/****************************************************************************
** Meta object code from reading C++ file 'influxdbclient.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../influxdbclient.h"
#include <QtNetwork/QSslError>
#include <QtCore/qmetatype.h>
#include <QtCore/QList>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'influxdbclient.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.9.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN14InfluxDBClientE_t {};
} // unnamed namespace

template <> constexpr inline auto InfluxDBClient::qt_create_metaobjectdata<qt_meta_tag_ZN14InfluxDBClientE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "InfluxDBClient",
        "dataReceived",
        "",
        "VehicleData",
        "data",
        "historicalDataReceived",
        "QList<VehicleData>",
        "dataList",
        "connectionError",
        "error",
        "tripDataUpdated",
        "fetchData",
        "onDataReady",
        "onHistoricalDataReady",
        "onNetworkError",
        "QNetworkReply::NetworkError",
        "getTotalTrips",
        "getTotalDistance",
        "getAverageSpeed",
        "getAverageCharge",
        "getStatistics",
        "getAllTripsFromDatabase",
        "QVariantList",
        "getTripDetails",
        "QVariantMap",
        "tripId",
        "deleteTripFromDatabase"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'dataReceived'
        QtMocHelpers::SignalData<void(const VehicleData &)>(1, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 3, 4 },
        }}),
        // Signal 'historicalDataReceived'
        QtMocHelpers::SignalData<void(const QList<VehicleData> &)>(5, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 6, 7 },
        }}),
        // Signal 'connectionError'
        QtMocHelpers::SignalData<void(const QString &)>(8, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 9 },
        }}),
        // Signal 'tripDataUpdated'
        QtMocHelpers::SignalData<void()>(10, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'fetchData'
        QtMocHelpers::SlotData<void()>(11, 2, QMC::AccessPrivate, QMetaType::Void),
        // Slot 'onDataReady'
        QtMocHelpers::SlotData<void()>(12, 2, QMC::AccessPrivate, QMetaType::Void),
        // Slot 'onHistoricalDataReady'
        QtMocHelpers::SlotData<void()>(13, 2, QMC::AccessPrivate, QMetaType::Void),
        // Slot 'onNetworkError'
        QtMocHelpers::SlotData<void(QNetworkReply::NetworkError)>(14, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 15, 9 },
        }}),
        // Method 'getTotalTrips'
        QtMocHelpers::MethodData<int()>(16, 2, QMC::AccessPublic, QMetaType::Int),
        // Method 'getTotalDistance'
        QtMocHelpers::MethodData<double()>(17, 2, QMC::AccessPublic, QMetaType::Double),
        // Method 'getAverageSpeed'
        QtMocHelpers::MethodData<double()>(18, 2, QMC::AccessPublic, QMetaType::Double),
        // Method 'getAverageCharge'
        QtMocHelpers::MethodData<double()>(19, 2, QMC::AccessPublic, QMetaType::Double),
        // Method 'getStatistics'
        QtMocHelpers::MethodData<QJsonObject()>(20, 2, QMC::AccessPublic, QMetaType::QJsonObject),
        // Method 'getAllTripsFromDatabase'
        QtMocHelpers::MethodData<QVariantList()>(21, 2, QMC::AccessPublic, 0x80000000 | 22),
        // Method 'getTripDetails'
        QtMocHelpers::MethodData<QVariantMap(int)>(23, 2, QMC::AccessPublic, 0x80000000 | 24, {{
            { QMetaType::Int, 25 },
        }}),
        // Method 'deleteTripFromDatabase'
        QtMocHelpers::MethodData<bool(int)>(26, 2, QMC::AccessPublic, QMetaType::Bool, {{
            { QMetaType::Int, 25 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<InfluxDBClient, qt_meta_tag_ZN14InfluxDBClientE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject InfluxDBClient::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14InfluxDBClientE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14InfluxDBClientE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN14InfluxDBClientE_t>.metaTypes,
    nullptr
} };

void InfluxDBClient::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<InfluxDBClient *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->dataReceived((*reinterpret_cast< std::add_pointer_t<VehicleData>>(_a[1]))); break;
        case 1: _t->historicalDataReceived((*reinterpret_cast< std::add_pointer_t<QList<VehicleData>>>(_a[1]))); break;
        case 2: _t->connectionError((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 3: _t->tripDataUpdated(); break;
        case 4: _t->fetchData(); break;
        case 5: _t->onDataReady(); break;
        case 6: _t->onHistoricalDataReady(); break;
        case 7: _t->onNetworkError((*reinterpret_cast< std::add_pointer_t<QNetworkReply::NetworkError>>(_a[1]))); break;
        case 8: { int _r = _t->getTotalTrips();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = std::move(_r); }  break;
        case 9: { double _r = _t->getTotalDistance();
            if (_a[0]) *reinterpret_cast< double*>(_a[0]) = std::move(_r); }  break;
        case 10: { double _r = _t->getAverageSpeed();
            if (_a[0]) *reinterpret_cast< double*>(_a[0]) = std::move(_r); }  break;
        case 11: { double _r = _t->getAverageCharge();
            if (_a[0]) *reinterpret_cast< double*>(_a[0]) = std::move(_r); }  break;
        case 12: { QJsonObject _r = _t->getStatistics();
            if (_a[0]) *reinterpret_cast< QJsonObject*>(_a[0]) = std::move(_r); }  break;
        case 13: { QVariantList _r = _t->getAllTripsFromDatabase();
            if (_a[0]) *reinterpret_cast< QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 14: { QVariantMap _r = _t->getTripDetails((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = std::move(_r); }  break;
        case 15: { bool _r = _t->deleteTripFromDatabase((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
        case 7:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QNetworkReply::NetworkError >(); break;
            }
            break;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (InfluxDBClient::*)(const VehicleData & )>(_a, &InfluxDBClient::dataReceived, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (InfluxDBClient::*)(const QList<VehicleData> & )>(_a, &InfluxDBClient::historicalDataReceived, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (InfluxDBClient::*)(const QString & )>(_a, &InfluxDBClient::connectionError, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (InfluxDBClient::*)()>(_a, &InfluxDBClient::tripDataUpdated, 3))
            return;
    }
}

const QMetaObject *InfluxDBClient::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *InfluxDBClient::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14InfluxDBClientE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int InfluxDBClient::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 16)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 16;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 16)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 16;
    }
    return _id;
}

// SIGNAL 0
void InfluxDBClient::dataReceived(const VehicleData & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 0, nullptr, _t1);
}

// SIGNAL 1
void InfluxDBClient::historicalDataReceived(const QList<VehicleData> & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1);
}

// SIGNAL 2
void InfluxDBClient::connectionError(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 2, nullptr, _t1);
}

// SIGNAL 3
void InfluxDBClient::tripDataUpdated()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}
QT_WARNING_POP
