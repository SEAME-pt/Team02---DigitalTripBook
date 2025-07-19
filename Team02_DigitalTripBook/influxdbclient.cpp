#include "influxdbclient.h"
#include <QUrl>
#include <QUrlQuery>
#include <QDebug>
#include <QHttpMultiPart>
#include <QFile>
#include <QDir>
#include <algorithm>

InfluxDBClient::InfluxDBClient(QObject *parent)
    : QObject(parent)
    , m_networkManager(new QNetworkAccessManager(this))
    , m_pollTimer(new QTimer(this))
    , m_currentReply(nullptr)
    , m_historicalReply(nullptr)
    , m_pollingInterval(1000) // Default 1 second
    , m_inTrip(false)          // Initialize trip detection state
    , m_nextTripId(1)          // Start with trip ID 1
{
    connect(m_pollTimer, &QTimer::timeout, this, &InfluxDBClient::fetchData);
    
    // Initialize local trip database
    if (!initializeDatabase()) {
        qDebug() << "Warning: Failed to initialize trip database";
    }
}

InfluxDBClient::~InfluxDBClient()
{
    stopDataCollection();
}

void InfluxDBClient::startDataCollection()
{
    qDebug() << "Starting InfluxDB data collection with interval:" << m_pollingInterval << "ms";
    m_pollTimer->start(m_pollingInterval);
}

void InfluxDBClient::stopDataCollection()
{
    qDebug() << "Stopping InfluxDB data collection";
    m_pollTimer->stop();
    
    if (m_currentReply) {
        m_currentReply->abort();
        m_currentReply = nullptr;
    }
    
    if (m_historicalReply) {
        m_historicalReply->abort();
        m_historicalReply = nullptr;
    }
}

void InfluxDBClient::setPollingInterval(int intervalMs)
{
    m_pollingInterval = intervalMs;
    if (m_pollTimer->isActive()) {
        m_pollTimer->setInterval(intervalMs);
    }
}

void InfluxDBClient::fetchData()
{
    if (m_currentReply) {
        // Previous request still pending
        return;
    }

    QNetworkRequest request;
    setupRequest(request);
    
    QString query = buildInfluxQuery();
    QByteArray postData = query.toUtf8();
    
    m_currentReply = m_networkManager->post(request, postData);
    
    connect(m_currentReply, &QNetworkReply::finished, this, &InfluxDBClient::onDataReady);
    connect(m_currentReply, QOverload<QNetworkReply::NetworkError>::of(&QNetworkReply::errorOccurred),
            this, &InfluxDBClient::onNetworkError);
}

void InfluxDBClient::setupRequest(QNetworkRequest& request)
{
    QUrl url(m_influxUrl + "/api/v2/query");
    request.setUrl(url);
    
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/vnd.flux");
    request.setRawHeader("Authorization", QString("Token %1").arg(m_token).toUtf8());
    request.setRawHeader("Accept", "application/csv");
    
    // Android TLS fix - configure SSL
    QSslConfiguration sslConfig = request.sslConfiguration();
    sslConfig.setPeerVerifyMode(QSslSocket::VerifyNone); // For testing - disable SSL verification
    sslConfig.setProtocol(QSsl::TlsV1_2OrLater);
    request.setSslConfiguration(sslConfig);
    
    // Add user agent for better compatibility
    request.setRawHeader("User-Agent", "DigitalTripBook/1.0 (Android)");
}

QString InfluxDBClient::buildInfluxQuery()
{
    // Flux query to get the latest values for all three measurements
    return QString(R"(
from(bucket: "%1")
  |> range(start: -1m)
  |> filter(fn: (r) => r["_measurement"] == "Vehicle/1/qt/speed" or 
                       r["_measurement"] == "Vehicle/1/qt/charge" or 
                       r["_measurement"] == "Vehicle/1/qt/autonomy_level")
  |> last()
  |> yield(name: "latest_values")
)").arg(m_influxDatabase);
}

void InfluxDBClient::fetchHistoricalData(int hoursBack)
{
    if (m_historicalReply) {
        // Previous historical request still pending
        qDebug() << "Historical data request already in progress";
        return;
    }

    qDebug() << "Fetching historical data for last" << hoursBack << "hours";
    
    QNetworkRequest request;
    setupRequest(request);
    
    QString query = buildHistoricalQuery(hoursBack);
    QByteArray postData = query.toUtf8();
    
    m_historicalReply = m_networkManager->post(request, postData);
    
    connect(m_historicalReply, &QNetworkReply::finished, this, &InfluxDBClient::onHistoricalDataReady);
    connect(m_historicalReply, QOverload<QNetworkReply::NetworkError>::of(&QNetworkReply::errorOccurred),
            this, &InfluxDBClient::onNetworkError);
}

QString InfluxDBClient::buildHistoricalQuery(int hoursBack)
{
    // Exact dataHandler Flux query for trip analysis (gets last 24h of data chronologically)
    QString fluxQuery = QString(
        "from(bucket: \"%1\")"
        " |> range(start: -%2h)"  // Get last N hours of data for trip analysis
        " |> filter(fn: (r) => r[\"_measurement\"] == \"Vehicle/1/qt/speed\" or r[\"_measurement\"] == \"Vehicle/1/qt/charge\")"
        " |> sort(columns: [\"_time\"])"  // Sort by time to ensure chronological order
        " |> yield(name: \"vehicle_data\")"
    ).arg(m_influxDatabase).arg(hoursBack);
    
    qDebug() << "InfluxDBClient: DataHandler-style query for Vehicle/1/qt/speed and Vehicle/1/qt/charge data (last" << hoursBack << "h):" << fluxQuery;
    
    return fluxQuery;
}

void InfluxDBClient::onDataReady()
{
    if (!m_currentReply) {
        return;
    }

    if (m_currentReply->error() == QNetworkReply::NoError) {
        QByteArray data = m_currentReply->readAll();
        VehicleData vehicleData = parseInfluxResponse(data);
        emit dataReceived(vehicleData);
    } else {
        emit connectionError(m_currentReply->errorString());
    }

    m_currentReply->deleteLater();
    m_currentReply = nullptr;
}

void InfluxDBClient::onHistoricalDataReady()
{
    if (!m_historicalReply) {
        return;
    }

    if (m_historicalReply->error() == QNetworkReply::NoError) {
        QByteArray data = m_historicalReply->readAll();
        QList<VehicleData> historicalData = parseHistoricalResponse(data);
        
        // Store data for statistics calculations
        m_historicalData = historicalData;
        
        qDebug() << "Received" << historicalData.size() << "historical data points";
        
        // Process historical data into trip records
        processHistoricalDataIntoTrips(historicalData);
        
        emit historicalDataReceived(historicalData);
    } else {
        emit connectionError("Historical data error: " + m_historicalReply->errorString());
    }

    m_historicalReply->deleteLater();
    m_historicalReply = nullptr;
}

void InfluxDBClient::onNetworkError(QNetworkReply::NetworkError error)
{
    QString errorString = QString("Network error: %1").arg(static_cast<int>(error));
    if (m_currentReply) {
        errorString += " - " + m_currentReply->errorString();
    }
    emit connectionError(errorString);
}

VehicleData InfluxDBClient::parseInfluxResponse(const QByteArray& data)
{
    VehicleData result;
    QString csvData = QString::fromUtf8(data);
    
    // Parse CSV response from InfluxDB
    QStringList lines = csvData.split('\n', Qt::SkipEmptyParts);
    
    if (lines.size() < 2) {
        qWarning() << "Invalid CSV response from InfluxDB";
        return result;
    }
    
    // Skip header line, process data lines
    for (int i = 1; i < lines.size(); ++i) {
        QStringList fields = lines[i].split(',');
        
        if (fields.size() < 6) {
            continue; // Skip invalid lines
        }
        
        QString measurement = fields[5]; // _measurement column
        QString valueStr = fields[6];    // _value column
        QString timeStr = fields[4];     // _time column
        
        double value = valueStr.toDouble();
        QDateTime timestamp = QDateTime::fromString(timeStr, Qt::ISODate);
        
        if (measurement == "Vehicle/1/qt/speed") {
            result.speed = value;
        } else if (measurement == "Vehicle/1/qt/charge") {
            result.charge = value;
        } else if (measurement == "Vehicle/1/qt/autonomy_level") {
            result.autonomyLevel = static_cast<int>(value);
        }
        
        // Use the most recent timestamp
        if (timestamp.isValid() && (result.timestamp.isNull() || timestamp > result.timestamp)) {
            result.timestamp = timestamp;
        }
    }
    
    if (result.timestamp.isNull()) {
        result.timestamp = QDateTime::currentDateTime();
    }
    
    return result;
}

QList<VehicleData> InfluxDBClient::parseHistoricalResponse(const QByteArray& data)
{
    QList<VehicleData> results;
    QString csvData = QString::fromUtf8(data);
    QStringList lines = csvData.split('\n', Qt::SkipEmptyParts);
    
    qDebug() << "=== TRIP ANALYSIS - PROCESSING DATA (EXACT DATAHANDLER LOGIC) ===";
    qDebug() << "Total lines received:" << lines.size();
    
    if (lines.size() < 2) {
        qDebug() << "No vehicle data found for trip analysis";
        return results;
    }
    
    // Parse CSV header (exact dataHandler logic)
    QStringList headers = lines[0].split(',');
    
    // Trim whitespace and carriage returns from headers
    for (int i = 0; i < headers.size(); ++i) {
        headers[i] = headers[i].trimmed();
    }
    
    // Print headers for debugging
    qDebug() << "CSV Headers found:";
    for (int i = 0; i < headers.size(); ++i) {
        qDebug() << "  Index" << i << ":" << headers[i];
    }
    
    // Find the indices we need
    int valueIndex = headers.indexOf("_value");
    int timeIndex = headers.indexOf("_time");
    int measurementIndex = headers.indexOf("_measurement");
    
    if (valueIndex == -1 || timeIndex == -1 || measurementIndex == -1) {
        qDebug() << "Required _value, _time, or _measurement columns not found in CSV";
        qDebug() << "valueIndex:" << valueIndex << "timeIndex:" << timeIndex << "measurementIndex:" << measurementIndex;
        return results;
    }
    
    // Separate parsing: Speed and battery measurements have different timestamps (exact dataHandler logic)
    QMap<QDateTime, double> speedData;
    QMap<QDateTime, double> batteryData;
    
    // First pass: Parse all data and separate speed/battery by timestamp
    for (int i = 1; i < lines.size(); i++) {
        QStringList fields = lines[i].split(',');
        if (fields.size() <= qMax(qMax(valueIndex, timeIndex), measurementIndex)) continue;
        
        QString valueStr = fields[valueIndex];
        QString timeStr = fields[timeIndex];
        QString measurement = fields[measurementIndex].trimmed(); // Remove carriage returns
        
        bool ok;
        double value = valueStr.toDouble(&ok);
        
        if (ok) {
            // Parse timestamp
            QDateTime timestamp = QDateTime::fromString(timeStr, Qt::ISODate);
            if (timestamp.isValid()) {
                // Debug: Show first few raw measurements
                if (speedData.size() + batteryData.size() < 5) {
                    qDebug() << "Raw measurement:" << measurement << "Value:" << value << "Time:" << timeStr;
                }
                
                // Store values separately by measurement type (exact dataHandler logic)
                if (measurement == "Vehicle/1/qt/speed") {
                    speedData[timestamp] = value;
                    if (speedData.size() <= 3) {
                        qDebug() << "Speed data:" << timestamp.toString() << "=" << value;
                    }
                } else if (measurement == "Vehicle/1/qt/charge") {
                    batteryData[timestamp] = value;
                    if (batteryData.size() <= 3) {
                        qDebug() << "Battery data:" << timestamp.toString() << "=" << value;
                    }
                }
            } else {
                // Debug: Show invalid timestamps
                if (speedData.size() + batteryData.size() < 3) {
                    qDebug() << "Invalid timestamp:" << timeStr << "for measurement:" << measurement;
                }
            }
        } else {
            // Debug: Show invalid values
            if (speedData.size() + batteryData.size() < 3) {
                qDebug() << "Invalid value:" << valueStr << "for measurement:" << measurement;
            }
        }
    }
    
    qDebug() << "Parsed" << speedData.size() << "speed points and" << batteryData.size() << "battery points";
    
    // Second pass: Create combined timeline with interpolated values (exact dataHandler logic)
    QSet<QDateTime> allTimestamps;
    for (auto it = speedData.begin(); it != speedData.end(); ++it) {
        allTimestamps.insert(it.key());
    }
    for (auto it = batteryData.begin(); it != batteryData.end(); ++it) {
        allTimestamps.insert(it.key());
    }
    
    // Convert to list and sort chronologically
    QList<QDateTime> sortedTimestamps = allTimestamps.values();
    std::sort(sortedTimestamps.begin(), sortedTimestamps.end());
    
    // Third pass: Create data points with interpolated values (exact dataHandler logic)
    double lastKnownSpeed = 0.0;
    double lastKnownBattery = 0.0;
    
    for (const QDateTime& timestamp : sortedTimestamps) {
        double currentSpeed = lastKnownSpeed;  // Default to last known
        double currentBattery = lastKnownBattery;  // Default to last known
        
        // Use actual values if available at this timestamp
        if (speedData.contains(timestamp)) {
            currentSpeed = speedData[timestamp];
            lastKnownSpeed = currentSpeed;
        }
        if (batteryData.contains(timestamp)) {
            currentBattery = batteryData[timestamp];
            lastKnownBattery = currentBattery;
        }
        
        // Add the data point with both values
        VehicleData dataPoint;
        dataPoint.timestamp = timestamp;
        dataPoint.speed = currentSpeed;
        dataPoint.charge = currentBattery;
        dataPoint.autonomyLevel = 0; // Not used in dataHandler
        
        results.append(dataPoint);
    }
    
    qDebug() << "Processed" << results.size() << "data points for trip analysis (dataHandler style)";
    
    // Debug: Show first and last timestamps to confirm chronological order
    if (!results.isEmpty()) {
        qDebug() << "Chronological order verification:";
        qDebug() << "Oldest timestamp:" << results.first().timestamp.toString() 
                 << "Speed:" << results.first().speed 
                 << "Battery:" << results.first().charge << "%";
        qDebug() << "Newest timestamp:" << results.last().timestamp.toString() 
                 << "Speed:" << results.last().speed 
                 << "Battery:" << results.last().charge << "%";
    }
    
    return results;
}

bool InfluxDBClient::initializeDatabase()
{
    // Create database file in this project's directory
    QString dbPath = QDir::currentPath() + "/trip_data.db";
    
    m_database = QSqlDatabase::addDatabase("QSQLITE", "trips_connection");
    m_database.setDatabaseName(dbPath);
    
    if (!m_database.open()) {
        qDebug() << "Failed to open trip database:" << m_database.lastError().text();
        return false;
    }
    
    // Create the trips table if it doesn't exist
    QSqlQuery query(m_database);
    QString createTableSql = R"(
        CREATE TABLE IF NOT EXISTS trips (
            trip_id INTEGER PRIMARY KEY AUTOINCREMENT,
            start_time TEXT NOT NULL,
            end_time TEXT,
            max_speed REAL DEFAULT 0.0,
            average_speed REAL DEFAULT 0.0,
            distance_traveled REAL DEFAULT 0.0,
            duration_seconds INTEGER DEFAULT 0,
            start_battery_charge REAL DEFAULT 0.0,
            end_battery_charge REAL DEFAULT 0.0,
            battery_used_percent REAL DEFAULT 0.0,
            energy_consumed_wh REAL DEFAULT 0.0,
            energy_efficiency_whkm REAL DEFAULT 0.0,
            trip_name TEXT DEFAULT '',
            driver_name TEXT DEFAULT '',
            notes TEXT DEFAULT '',
            data_points_count INTEGER DEFAULT 0,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP
        )
    )";
    
    if (!query.exec(createTableSql)) {
        qDebug() << "Failed to create trips table:" << query.lastError().text();
        return false;
    }
    
    // Database initialized without sample data
    
    // Fetch last 4 days of data to populate database
    fetchAndStoreHistoricalTrips(4 * 24); // 4 days = 96 hours
    
    qDebug() << "Successfully initialized trip database at:" << dbPath;
    return true;
}

// Statistics methods - now reading from local database
int InfluxDBClient::getTotalTrips()
{
    if (!m_database.isOpen()) {
        qDebug() << "Database not open";
        return 0;
    }
    
    QSqlQuery query(m_database);
    query.prepare("SELECT COUNT(*) FROM trips WHERE end_time IS NOT NULL");
    
    if (query.exec() && query.next()) {
        return query.value(0).toInt();
    }
    
    return 0;
}

double InfluxDBClient::getTotalDistance()
{
    if (!m_database.isOpen()) {
        return 0.0;
    }
    
    QSqlQuery query(m_database);
    query.prepare("SELECT SUM(distance_traveled) FROM trips WHERE end_time IS NOT NULL");
    
    if (query.exec() && query.next()) {
        return query.value(0).toDouble();
    }
    
    return 0.0;
}

double InfluxDBClient::getAverageSpeed()
{
    if (!m_database.isOpen()) {
        return 0.0;
    }
    
    QSqlQuery query(m_database);
    query.prepare("SELECT AVG(average_speed) FROM trips WHERE end_time IS NOT NULL AND average_speed > 0");
    
    if (query.exec() && query.next()) {
        return query.value(0).toDouble();
    }
    
    return 0.0;
}

double InfluxDBClient::getAverageCharge()
{
    if (!m_database.isOpen()) {
        return 0.0;
    }
    
    QSqlQuery query(m_database);
    query.prepare("SELECT AVG(start_battery_charge) FROM trips WHERE end_time IS NOT NULL AND start_battery_charge > 0");
    
    if (query.exec() && query.next()) {
        return query.value(0).toDouble();
    }
    
    return 0.0;
}

QJsonObject InfluxDBClient::getStatistics()
{
    QJsonObject stats;
    
    if (!m_database.isOpen()) {
        // Return empty stats if database is not available
        stats["totalTrips"] = 0;
        stats["totalDistance"] = 0.0;
        stats["averageSpeed"] = 0.0;
        stats["averageCharge"] = 0.0;
        stats["dataPoints"] = 0;
        stats["maxSpeed"] = 0.0;
        stats["minCharge"] = 0.0;
        stats["maxCharge"] = 0.0;
        stats["totalEnergyUsed"] = 0.0;
        stats["averageEfficiency"] = 0.0;
        return stats;
    }
    
    stats["totalTrips"] = getTotalTrips();
    stats["totalDistance"] = getTotalDistance();
    stats["averageSpeed"] = getAverageSpeed();
    stats["averageCharge"] = getAverageCharge();
    
    // Get additional statistics
    QSqlQuery query(m_database);
    
    // Max speed
    query.prepare("SELECT MAX(max_speed) FROM trips WHERE end_time IS NOT NULL");
    if (query.exec() && query.next()) {
        stats["maxSpeed"] = query.value(0).toDouble();
    }
    
    // Min and max charge
    query.prepare("SELECT MIN(end_battery_charge), MAX(start_battery_charge) FROM trips WHERE end_time IS NOT NULL");
    if (query.exec() && query.next()) {
        stats["minCharge"] = query.value(0).toDouble();
        stats["maxCharge"] = query.value(1).toDouble();
    }
    
    // Total energy used
    query.prepare("SELECT SUM(energy_consumed_wh) FROM trips WHERE end_time IS NOT NULL");
    if (query.exec() && query.next()) {
        stats["totalEnergyUsed"] = query.value(0).toDouble();
    }
    
    // Average efficiency
    query.prepare("SELECT AVG(energy_efficiency_whkm) FROM trips WHERE end_time IS NOT NULL");
    if (query.exec() && query.next()) {
        stats["averageEfficiency"] = query.value(0).toDouble();
    }
    
    // Data points (count of all trips)
    query.prepare("SELECT COUNT(*) FROM trips");
    if (query.exec() && query.next()) {
        stats["dataPoints"] = query.value(0).toInt();
    }
    
    return stats;
}

QVariantList InfluxDBClient::getAllTripsFromDatabase()
{
    QVariantList tripsArray;
    
    if (!m_database.isOpen()) {
        return tripsArray;
    }
    
    QSqlQuery query(m_database);
    query.prepare(R"(
        SELECT trip_id, start_time, end_time, max_speed, average_speed, 
               distance_traveled, duration_seconds, start_battery_charge, 
               end_battery_charge, energy_consumed_wh, energy_efficiency_whkm,
               trip_name, driver_name, notes
        FROM trips 
        WHERE end_time IS NOT NULL 
        ORDER BY start_time DESC
    )");
    
    if (query.exec()) {
        while (query.next()) {
            QVariantMap trip;
            trip["tripId"] = query.value("trip_id").toInt();
            trip["startTime"] = query.value("start_time").toString();
            trip["endTime"] = query.value("end_time").toString();
            trip["maxSpeed"] = query.value("max_speed").toDouble();
            trip["averageSpeed"] = query.value("average_speed").toDouble();
            trip["distance"] = query.value("distance_traveled").toDouble();
            trip["duration"] = query.value("duration_seconds").toInt();
            trip["startCharge"] = query.value("start_battery_charge").toDouble();
            trip["endCharge"] = query.value("end_battery_charge").toDouble();
            trip["energyUsed"] = query.value("energy_consumed_wh").toDouble();
            trip["efficiency"] = query.value("energy_efficiency_whkm").toDouble();
            trip["tripName"] = query.value("trip_name").toString();
            trip["driverName"] = query.value("driver_name").toString();
            trip["notes"] = query.value("notes").toString();
            
            tripsArray.append(trip);
        }
    }
    
    return tripsArray;
}

QVariantMap InfluxDBClient::getTripDetails(int tripId)
{
    QVariantMap tripDetails;
    
    if (!m_database.isOpen()) {
        return tripDetails;
    }
    
    QSqlQuery query(m_database);
    query.prepare(R"(
        SELECT trip_id, start_time, end_time, max_speed, average_speed, 
               distance_traveled, duration_seconds, start_battery_charge, 
               end_battery_charge, battery_used_percent, energy_consumed_wh, 
               energy_efficiency_whkm, trip_name, driver_name, notes
        FROM trips 
        WHERE trip_id = ?
    )");
    query.addBindValue(tripId);
    
    if (query.exec() && query.next()) {
        tripDetails["tripId"] = query.value("trip_id").toInt();
        tripDetails["startTime"] = query.value("start_time").toString();
        tripDetails["endTime"] = query.value("end_time").toString();
        tripDetails["maxSpeed"] = query.value("max_speed").toDouble();
        tripDetails["averageSpeed"] = query.value("average_speed").toDouble();
        tripDetails["distance"] = query.value("distance_traveled").toDouble();
        tripDetails["duration"] = query.value("duration_seconds").toInt();
        tripDetails["startCharge"] = query.value("start_battery_charge").toDouble();
        tripDetails["endCharge"] = query.value("end_battery_charge").toDouble();
        tripDetails["batteryUsed"] = query.value("battery_used_percent").toDouble();
        tripDetails["energyUsed"] = query.value("energy_consumed_wh").toDouble();
        tripDetails["efficiency"] = query.value("energy_efficiency_whkm").toDouble();
        tripDetails["tripName"] = query.value("trip_name").toString();
        tripDetails["driverName"] = query.value("driver_name").toString();
        tripDetails["notes"] = query.value("notes").toString();
    }
    
    return tripDetails;
}

bool InfluxDBClient::deleteTripFromDatabase(int tripId)
{
    if (!m_database.isOpen()) {
        return false;
    }
    
    QSqlQuery query(m_database);
    query.prepare("DELETE FROM trips WHERE trip_id = ?");
    query.addBindValue(tripId);
    
    if (query.exec()) {
        emit tripDataUpdated();
        return true;
    }
    
    return false;
}

void InfluxDBClient::insertSampleData()
{
    // Sample data insertion removed - app now starts with empty database
    // Real trip data will be populated from actual InfluxDB measurements
    qDebug() << "✅ Database ready for real InfluxDB trip data";
}

void InfluxDBClient::fetchAndStoreHistoricalTrips(int hoursBack)
{
    qDebug() << "🔄 Fetching" << hoursBack << "hours of historical data from InfluxDB to populate trip database...";
    
    // Fetch historical data from InfluxDB
    fetchHistoricalData(hoursBack);
}

void InfluxDBClient::processHistoricalDataIntoTrips(const QList<VehicleData>& historicalData)
{
    if (historicalData.isEmpty()) {
        qDebug() << "No historical data to process into trips";
        return;
    }
    
    qDebug() << "🔄 Processing" << historicalData.size() << "data points into trips using EXACT dataHandler logic...";
    
    // Battery configuration constants matching dataHandler project exactly
    const double BATTERY_CAPACITY_MAH = 6 * 3200; // Six 3200 mAh batteries = 19200 mAh total
    const double BATTERY_VOLTAGE = 12.0; // 12V system  
    const double BATTERY_CAPACITY_WH = (BATTERY_CAPACITY_MAH / 1000.0) * BATTERY_VOLTAGE; // 230.4 Watt-hours
    
    // Trip detection constants matching dataHandler exactly
    const int TRIP_START_DURATION_SECONDS = 60;    // 1 minute of movement to start trip
    const int TRIP_END_DURATION_SECONDS = 60;      // 1 minute of no movement to end trip
    
    // Convert VehicleData to VehicleDataPoint format and sort by timestamp (oldest first)
    QList<VehicleData> sortedData = historicalData;
    std::sort(sortedData.begin(), sortedData.end(), [](const VehicleData& a, const VehicleData& b) {
        return a.timestamp < b.timestamp;
    });
    
    qDebug() << "📊 Processing data chronologically from oldest to newest (dataHandler style)";
    qDebug() << "   Oldest:" << (sortedData.isEmpty() ? "N/A" : sortedData.first().timestamp.toString());
    qDebug() << "   Newest:" << (sortedData.isEmpty() ? "N/A" : sortedData.last().timestamp.toString());
    
    // Trip detection state variables (exactly like dataHandler)
    bool inTrip = false;
    int nextTripId = 1;
    QDateTime potentialTripStart;
    QDateTime potentialTripEnd;
    QList<VehicleData> currentTripData;
    QList<QList<VehicleData>> completedTrips;
    
    // Process data points chronologically (dataHandler logic)
    for (int i = 0; i < sortedData.size(); i++) {
        const VehicleData& point = sortedData[i];
        
        // Debug first few and last few points
        if (i < 3 || i >= sortedData.size() - 3) {
            qDebug() << "Processing point" << i << ":" << point.timestamp.toString() 
                     << "Speed:" << point.speed << "m/s Battery:" << point.charge << "%";
        }
        
        bool isMoving = (point.speed > 0.0); // Exact dataHandler isMoving logic
        
        if (!inTrip) {
            // Looking for trip start
            if (isMoving) {
                if (potentialTripStart.isNull()) {
                    potentialTripStart = point.timestamp;
                    qDebug() << "⏳ Potential trip start detected at:" << potentialTripStart.toString();
                } else {
                    // Check if we've been moving for at least 1 minute
                    qint64 movingDuration = potentialTripStart.secsTo(point.timestamp);
                    if (movingDuration >= TRIP_START_DURATION_SECONDS) {
                        // Trip confirmed! (exact dataHandler logic)
                        inTrip = true;
                        currentTripData.clear();
                        
                        // Add all data points from potential start until now
                        for (const VehicleData& tripPoint : sortedData) {
                            if (tripPoint.timestamp >= potentialTripStart && tripPoint.timestamp <= point.timestamp) {
                                currentTripData.append(tripPoint);
                            }
                        }
                        
                        qDebug() << "🚗 TRIP" << nextTripId << "STARTED at" << potentialTripStart.toString() << "(dataHandler logic)";
                        qDebug() << "   Start battery charge:" << (currentTripData.isEmpty() ? 0.0 : currentTripData.first().charge) << "%";
                        
                        potentialTripStart = QDateTime(); // Reset
                    }
                }
            } else {
                // Reset potential trip start if speed goes to zero (dataHandler logic)
                potentialTripStart = QDateTime();
            }
        } else {
            // We're in a trip - add data points and check for trip end
            currentTripData.append(point);
            
            if (isMoving) {
                potentialTripEnd = QDateTime(); // Reset potential end (dataHandler logic)
            } else {
                // Vehicle stopped
                if (potentialTripEnd.isNull()) {
                    potentialTripEnd = point.timestamp;
                } else {
                    // Check if stopped for more than 1 minute (dataHandler logic)
                    qint64 stoppedDuration = potentialTripEnd.secsTo(point.timestamp);
                    if (stoppedDuration >= TRIP_END_DURATION_SECONDS) {
                        // Trip ended! (exact dataHandler logic)
                        qDebug() << "🏁 TRIP" << nextTripId << "ENDED at" << potentialTripEnd.toString() << "(dataHandler logic)";
                        
                        // Save this completed trip
                        completedTrips.append(currentTripData);
                        nextTripId++;
                        
                        inTrip = false;
                        potentialTripEnd = QDateTime();
                        currentTripData.clear();
                    }
                }
            }
        }
    }
    
    // Handle ongoing trip at end of data (like dataHandler timeout logic)
    if (inTrip && !currentTripData.isEmpty()) {
        qDebug() << "🕐 TRIP" << nextTripId << "FORCE-ENDED at end of data (dataHandler timeout logic)";
        completedTrips.append(currentTripData);
    }
    
    qDebug() << "� Found" << completedTrips.size() << "completed trips using exact dataHandler algorithm";
    
    // Process each completed trip into database records (dataHandler calculations)
    QSqlQuery query(m_database);
    int tripsInserted = 0;
    
    for (int tripIndex = 0; tripIndex < completedTrips.size(); ++tripIndex) {
        const QList<VehicleData>& tripPoints = completedTrips[tripIndex];
        
        if (tripPoints.size() < 2) continue; // Need at least 2 points
        
        // Get trip start/end times from actual data points (dataHandler style)
        VehicleData startPoint = tripPoints.first();
        VehicleData endPoint = tripPoints.last();
        
        QDateTime startTime = startPoint.timestamp;
        QDateTime endTime = endPoint.timestamp;
        qint64 durationSeconds = startTime.secsTo(endTime);
        
        // Skip very short trips
        if (durationSeconds < 60) continue;
        
        // Calculate speed statistics (exact dataHandler logic)
        double maxSpeed = 0.0;
        double totalSpeed = 0.0;
        int speedPointCount = 0;
        
        for (const VehicleData& point : tripPoints) {
            totalSpeed += point.speed; // Sum in m/s
            speedPointCount++;
            
            if (point.speed > maxSpeed) {
                maxSpeed = point.speed; // Keep max in m/s
            }
        }
        
        // Calculate average speed in m/s (dataHandler logic)
        double averageSpeedMs = (speedPointCount > 0) ? (totalSpeed / speedPointCount) : 0.0;
        
        // Convert speeds to km/h for storage (dataHandler logic)
        double averageSpeedKmh = averageSpeedMs * 3.6;
        double maxSpeedKmh = maxSpeed * 3.6;
        
        // Calculate distance using dataHandler exact formula: avgSpeedKmh * durationHours
        double durationHours = durationSeconds / 3600.0;
        double totalDistance = averageSpeedKmh * durationHours; // km
        
        // Battery and energy calculations (exact dataHandler logic)
        double startBattery = startPoint.charge;
        double endBattery = endPoint.charge;
        double batteryUsedPercent = startBattery - endBattery;
        double energyConsumedWh = (batteryUsedPercent / 100.0) * BATTERY_CAPACITY_WH;
        double energyEfficiencyWhKm = (totalDistance > 0) ? (energyConsumedWh / totalDistance) : 0.0;
        
        // Generate trip details (dataHandler style)
        QString tripName = QString("InfluxDB Trip %1").arg(tripIndex + 1);
        QString driverName = "InfluxDB Data";
        QString notes = QString("Auto-generated from %1 data points using dataHandler logic").arg(tripPoints.size());
        
        // Check if trip already exists to prevent duplicates
        QSqlQuery checkQuery(m_database);
        checkQuery.prepare("SELECT COUNT(*) FROM trips WHERE start_time = ? AND end_time = ?");
        checkQuery.addBindValue(startTime.toString("yyyy-MM-dd hh:mm:ss"));
        checkQuery.addBindValue(endTime.toString("yyyy-MM-dd hh:mm:ss"));
        
        if (checkQuery.exec() && checkQuery.next() && checkQuery.value(0).toInt() > 0) {
            qDebug() << "⏭️  Skipping duplicate trip:" << tripName << "- already exists in database";
            continue; // Skip this trip, it already exists
        }
        
        // Insert trip into database
        QString insertSql = QString(R"(
            INSERT INTO trips (
                start_time, end_time, max_speed, average_speed, distance_traveled,
                duration_seconds, start_battery_charge, end_battery_charge, 
                battery_used_percent, energy_consumed_wh, energy_efficiency_whkm,
                trip_name, driver_name, notes, data_points_count
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        )");
        
        query.prepare(insertSql);
        query.addBindValue(startTime.toString("yyyy-MM-dd hh:mm:ss"));
        query.addBindValue(endTime.toString("yyyy-MM-dd hh:mm:ss"));
        query.addBindValue(maxSpeedKmh);          // Store in km/h
        query.addBindValue(averageSpeedKmh);      // Store in km/h
        query.addBindValue(totalDistance);
        query.addBindValue(durationSeconds);
        query.addBindValue(startBattery);
        query.addBindValue(endBattery);
        query.addBindValue(batteryUsedPercent);
        query.addBindValue(energyConsumedWh);
        query.addBindValue(energyEfficiencyWhKm);
        query.addBindValue(tripName);
        query.addBindValue(driverName);
        query.addBindValue(notes);
        query.addBindValue(tripPoints.size());
        
        if (query.exec()) {
            tripsInserted++;
            qDebug() << "✅ Inserted trip:" << tripName 
                     << "- Duration:" << QString::number(durationSeconds/60.0, 'f', 1) << "min"
                     << "- Distance:" << QString::number(totalDistance, 'f', 2) << "km"
                     << "- Avg Speed:" << QString::number(averageSpeedKmh, 'f', 1) << "km/h";
        } else {
            qDebug() << "❌ Failed to insert trip:" << query.lastError().text();
        }
    }
    
    qDebug() << "🎉 Successfully processed" << tripsInserted << "trips using EXACT dataHandler algorithm!";
}

// Exact DataHandler implementation for trip detection and data processing
void InfluxDBClient::addDataPoint(const QDateTime& timestamp, double speed, double batteryCharge) {
    VehicleDataPoint dataPoint(timestamp, speed, batteryCharge);
    m_dataBuffer.append(dataPoint);
    
    // Sort by timestamp to maintain chronological order (exact dataHandler logic)
    std::sort(m_dataBuffer.begin(), m_dataBuffer.end(), 
              [](const VehicleDataPoint& a, const VehicleDataPoint& b) {
                  return a.timestamp < b.timestamp;
              });
}

void InfluxDBClient::analyzeForTrips() {
    // Process data buffer chronologically to detect trips (exact dataHandler logic)
    for (const VehicleDataPoint& point : m_dataBuffer) {
        double speedMs = point.speed;
        
        if (speedMs > 0.0) { // Vehicle is moving
            if (!m_inTrip) {
                // Start of potential trip
                if (m_potentialTripStart.isNull()) {
                    m_potentialTripStart = point.timestamp;
                }
                
                // Check if we've been moving for the required duration
                if (m_potentialTripStart.secsTo(point.timestamp) >= TRIP_START_DURATION_SECONDS) {
                    m_inTrip = true;
                    qDebug() << "Trip started at:" << m_potentialTripStart;
                }
            }
            
            m_lastMovementTime = point.timestamp;
            m_potentialTripEnd = QDateTime(); // Reset potential end time
        } else {
            // Vehicle is not moving
            if (m_inTrip) {
                if (m_potentialTripEnd.isNull()) {
                    m_potentialTripEnd = point.timestamp;
                }
                
                // Check if we've been stopped for the required duration
                if (m_potentialTripEnd.secsTo(point.timestamp) >= TRIP_END_DURATION_SECONDS) {
                    // End the trip
                    qDebug() << "Trip ended at:" << m_potentialTripEnd;
                    
                    // Extract trip data and save to database
                    QList<VehicleDataPoint> tripData;
                    for (const VehicleDataPoint& tripPoint : m_dataBuffer) {
                        if (tripPoint.timestamp >= m_potentialTripStart && tripPoint.timestamp <= m_potentialTripEnd) {
                            tripData.append(tripPoint);
                        }
                    }
                    
                    if (!tripData.isEmpty()) {
                        // Get battery data for trip start and end
                        double startBattery = interpolateBatteryCharge(m_potentialTripStart, m_dataBuffer).batteryCharge;
                        double endBattery = interpolateBatteryCharge(m_potentialTripEnd, m_dataBuffer).batteryCharge;
                        
                        saveTripToDatabase(m_nextTripId++, m_potentialTripStart, m_potentialTripEnd, 
                                         startBattery, endBattery, tripData);
                    }
                    
                    // Reset trip state
                    m_inTrip = false;
                    m_potentialTripStart = QDateTime();
                    m_potentialTripEnd = QDateTime();
                }
            } else {
                // Not in a trip and not moving, reset potential start
                m_potentialTripStart = QDateTime();
            }
        }
        
        // Check for timeout (no data for extended period)
        if (m_inTrip && !m_lastMovementTime.isNull()) {
            if (m_lastMovementTime.secsTo(point.timestamp) > TRIP_TIMEOUT_SECONDS) {
                // Force end trip due to timeout
                qDebug() << "Trip force-ended due to timeout at:" << point.timestamp;
                
                // Extract trip data and save to database
                QList<VehicleDataPoint> tripData;
                for (const VehicleDataPoint& tripPoint : m_dataBuffer) {
                    if (tripPoint.timestamp >= m_potentialTripStart && tripPoint.timestamp <= m_lastMovementTime) {
                        tripData.append(tripPoint);
                    }
                }
                
                if (!tripData.isEmpty()) {
                    double startBattery = interpolateBatteryCharge(m_potentialTripStart, m_dataBuffer).batteryCharge;
                    double endBattery = interpolateBatteryCharge(m_lastMovementTime, m_dataBuffer).batteryCharge;
                    
                    saveTripToDatabase(m_nextTripId++, m_potentialTripStart, m_lastMovementTime, 
                                     startBattery, endBattery, tripData);
                }
                
                // Reset trip state
                m_inTrip = false;
                m_potentialTripStart = QDateTime();
                m_potentialTripEnd = QDateTime();
                m_lastMovementTime = QDateTime();
            }
        }
    }
}

VehicleDataPoint InfluxDBClient::interpolateBatteryCharge(const QDateTime& targetTime, const QList<VehicleDataPoint>& batteryData) {
    // Find closest battery readings (exact dataHandler interpolation logic)
    VehicleDataPoint result(targetTime, 0.0, 0.0);
    
    if (batteryData.isEmpty()) return result;
    
    // Find the two closest points for interpolation
    const VehicleDataPoint* before = nullptr;
    const VehicleDataPoint* after = nullptr;
    
    for (const VehicleDataPoint& point : batteryData) {
        if (point.batteryCharge > 0.0) { // Only consider points with valid battery data
            if (point.timestamp <= targetTime) {
                before = &point;
            } else if (after == nullptr) {
                after = &point;
                break;
            }
        }
    }
    
    if (before && after) {
        // Interpolate between two points
        qint64 totalDiff = before->timestamp.secsTo(after->timestamp);
        qint64 targetDiff = before->timestamp.secsTo(targetTime);
        
        if (totalDiff > 0) {
            double ratio = static_cast<double>(targetDiff) / totalDiff;
            result.batteryCharge = before->batteryCharge + ratio * (after->batteryCharge - before->batteryCharge);
        } else {
            result.batteryCharge = before->batteryCharge;
        }
    } else if (before) {
        // Use the point before
        result.batteryCharge = before->batteryCharge;
    } else if (after) {
        // Use the point after
        result.batteryCharge = after->batteryCharge;
    }
    
    return result;
}

void InfluxDBClient::saveTripToDatabase(int tripId, const QDateTime& startTime, const QDateTime& endTime, 
                                       double startBattery, double endBattery, const QList<VehicleDataPoint>& speedData) {
    // Calculate trip metrics using exact dataHandler formulas
    double totalDistance = 0.0;
    double maxSpeed = 0.0;
    double avgSpeed = 0.0;
    int validSpeedPoints = 0;
    
    // Calculate distance and speeds from speed data
    for (int i = 1; i < speedData.size(); ++i) {
        const VehicleDataPoint& prev = speedData[i-1];
        const VehicleDataPoint& curr = speedData[i];
        
        if (curr.speed > 0.0) {
            double speedMs = curr.speed;
            double speedKmh = speedMs * 3.6; // Convert m/s to km/h
            
            maxSpeed = qMax(maxSpeed, speedKmh);
            avgSpeed += speedKmh;
            validSpeedPoints++;
            
            // Calculate distance for this segment
            qint64 timeDiffSeconds = prev.timestamp.secsTo(curr.timestamp);
            double timeDiffHours = timeDiffSeconds / 3600.0;
            totalDistance += speedKmh * timeDiffHours; // km
        }
    }
    
    if (validSpeedPoints > 0) {
        avgSpeed /= validSpeedPoints;
    }
    
    // Calculate duration
    qint64 durationSeconds = startTime.secsTo(endTime);
    double durationHours = durationSeconds / 3600.0;
    
    // Calculate battery usage and energy
    double batteryUsedPercent = startBattery - endBattery;
    double energyUsedWh = (batteryUsedPercent / 100.0) * BATTERY_CAPACITY_WH;
    
    // Calculate efficiency (Wh/km)
    double efficiencyWhPerKm = (totalDistance > 0) ? energyUsedWh / totalDistance : 0.0;
    
    // Calculate range estimate
    double remainingEnergyWh = (endBattery / 100.0) * BATTERY_CAPACITY_WH;
    double estimatedRangeKm = (efficiencyWhPerKm > 0) ? remainingEnergyWh / efficiencyWhPerKm : 0.0;
    
    // Save to database
    QSqlQuery query(m_database);
    query.prepare("INSERT INTO trips (trip_id, start_time, end_time, duration_seconds, "
                  "start_battery_percent, end_battery_percent, battery_used_percent, "
                  "energy_used_wh, distance_km, avg_speed_kmh, max_speed_kmh, "
                  "efficiency_wh_per_km, estimated_range_km, trip_name, driver_name, notes) "
                  "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    
    query.addBindValue(tripId);
    query.addBindValue(startTime.toString(Qt::ISODate));
    query.addBindValue(endTime.toString(Qt::ISODate));
    query.addBindValue(durationSeconds);
    query.addBindValue(startBattery);
    query.addBindValue(endBattery);
    query.addBindValue(batteryUsedPercent);
    query.addBindValue(energyUsedWh);
    query.addBindValue(totalDistance);
    query.addBindValue(avgSpeed);
    query.addBindValue(maxSpeed);
    query.addBindValue(efficiencyWhPerKm);
    query.addBindValue(estimatedRangeKm);
    query.addBindValue(QString("Trip %1").arg(tripId));
    query.addBindValue("Default Driver");
    query.addBindValue("Auto-generated trip");
    
    if (query.exec()) {
        qDebug() << "Trip saved successfully:" << tripId;
        emit tripDataUpdated();
    } else {
        qDebug() << "Failed to save trip:" << query.lastError().text();
    }
}
