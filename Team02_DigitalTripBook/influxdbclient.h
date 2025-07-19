#ifndef INFLUXDBCLIENT_H
#define INFLUXDBCLIENT_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QTimer>
#include <QDateTime>
#include <QString>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QStandardPaths>
#include <QDir>
#include <QSslConfiguration>
#include <QSslSocket>
#include <QMap>
#include <QSet>

// Battery configuration constants (exact dataHandler values)
const double BATTERY_CAPACITY_MAH = 6 * 3200; // Six 3200 mAh batteries = 19200 mAh total
const double BATTERY_VOLTAGE = 12.0; // 12V system
const double BATTERY_CAPACITY_WH = (BATTERY_CAPACITY_MAH / 1000.0) * BATTERY_VOLTAGE; // Watt-hours

// Structure to hold individual data points (speed + battery) - exact dataHandler structure
struct VehicleDataPoint {
    QDateTime timestamp;
    double speed;        // m/s
    double batteryCharge; // percentage (0-100)
    
    VehicleDataPoint() : speed(0.0), batteryCharge(0.0) {}
    VehicleDataPoint(const QDateTime& time, double spd, double charge = 0.0) 
        : timestamp(time), speed(spd), batteryCharge(charge) {}
};

struct VehicleData {
    double speed;
    double charge;
    int autonomyLevel;
    QDateTime timestamp;
    
    VehicleData() : speed(0.0), charge(0.0), autonomyLevel(0), timestamp(QDateTime::currentDateTime()) {}
    VehicleData(double s, double c, int a, const QDateTime& t) 
        : speed(s), charge(c), autonomyLevel(a), timestamp(t) {}
};

class InfluxDBClient : public QObject
{
    Q_OBJECT

public:
    explicit InfluxDBClient(QObject *parent = nullptr);
    ~InfluxDBClient();

    void startDataCollection();
    void stopDataCollection();
    void setPollingInterval(int intervalMs);
    void fetchHistoricalData(int hoursBack = 12);
    
    // Statistics methods
    Q_INVOKABLE int getTotalTrips();
    Q_INVOKABLE double getTotalDistance();
    Q_INVOKABLE double getAverageSpeed();
    Q_INVOKABLE double getAverageCharge();
    Q_INVOKABLE QJsonObject getStatistics();
    Q_INVOKABLE QVariantList getAllTripsFromDatabase();
    Q_INVOKABLE QVariantMap getTripDetails(int tripId);
    Q_INVOKABLE bool deleteTripFromDatabase(int tripId);
    
    // DataHandler exact functions for trip detection and data processing
    void addDataPoint(const QDateTime& timestamp, double speed, double batteryCharge);
    void analyzeForTrips();
    VehicleDataPoint interpolateBatteryCharge(const QDateTime& targetTime, const QList<VehicleDataPoint>& batteryData);
    void processDataIntoTrips();
    void saveTripToDatabase(int tripId, const QDateTime& startTime, const QDateTime& endTime, 
                           double startBattery, double endBattery, const QList<VehicleDataPoint>& speedData);

signals:
    void dataReceived(const VehicleData& data);
    void historicalDataReceived(const QList<VehicleData>& dataList);
    void connectionError(const QString& error);
    void tripDataUpdated();

private slots:
    void fetchData();
    void onDataReady();
    void onHistoricalDataReady();
    void onNetworkError(QNetworkReply::NetworkError error);

private:
    void setupRequest(QNetworkRequest& request);
    QString buildInfluxQuery();
    QString buildHistoricalQuery(int hoursBack);
    VehicleData parseInfluxResponse(const QByteArray& data);
    QList<VehicleData> parseHistoricalResponse(const QByteArray& data);
    bool initializeDatabase();
    void insertSampleData();
    void fetchAndStoreHistoricalTrips(int hoursBack);
    void processHistoricalDataIntoTrips(const QList<VehicleData>& historicalData);

    QNetworkAccessManager* m_networkManager;
    QTimer* m_pollTimer;
    QNetworkReply* m_currentReply;
    QNetworkReply* m_historicalReply;
    
    // Data storage for statistics
    QList<VehicleData> m_historicalData;
    
    // Trip detection data storage (exact dataHandler structure)
    QList<VehicleDataPoint> m_dataBuffer;
    
    // Trip detection state (exact dataHandler variables)
    bool m_inTrip;
    int m_nextTripId;
    QDateTime m_potentialTripStart;
    QDateTime m_lastMovementTime;
    QDateTime m_potentialTripEnd;
    
    // Trip detection parameters (exact dataHandler constants)
    static const int TRIP_START_DURATION_SECONDS = 60;    // 1 minute of movement to start trip
    static const int TRIP_END_DURATION_SECONDS = 60;      // 1 minute of no movement to end trip
    static const int TRIP_TIMEOUT_SECONDS = 300;          // 5 minutes without data to force trip end
    
    // SQLite database for trips
    QSqlDatabase m_database;
    
    // InfluxDB Configuration
    const QString m_influxUrl = "https://eu-central-1-1.aws.cloud2.influxdata.com";
    const QString m_influxDatabase = "jetracer";
    const QString m_token = "rYtXXREgOrb0Kd5DSkA4b--qI9AC1gHvIGfNK90Ne0yGHsIDAYkvyxKzgxDLonwTVhzclF8ZZoVk7R9atXeHbQ==";
    
    int m_pollingInterval;
};

#endif // INFLUXDBCLIENT_H
