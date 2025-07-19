#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "influxdbclient.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Create InfluxDB client instance
    InfluxDBClient influxClient;
    
    QQmlApplicationEngine engine;
    
    // Register InfluxDB client to QML context
    engine.rootContext()->setContextProperty("influxClient", &influxClient);
    
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Team02_DigitalTripBook", "Main");

    return app.exec();
}
