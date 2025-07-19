cmake_minimum_required(VERSION 3.16)

project(Team02_DigitalTripBook VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Network Sql)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appTeam02_DigitalTripBook
    main.cpp
    influxdbclient.h
    influxdbclient.cpp
)

# Set Colors.qml as singleton
set_source_files_properties(Colors.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(appTeam02_DigitalTripBook
    URI Team02_DigitalTripBook
    VERSION 1.0
    QML_FILES
        Main.qml
        Colors.qml
        CustomButton.qml
        CustomToolBar.qml
        LoadingScreen.qml
        HomeScreen.qml
        TripBookingScreen.qml
        ExploreScreen.qml
        MyTripsScreen.qml
        TripDetailsScreen.qml
        StatisticsScreen.qml
        ApplicationFlow.qml
    SOURCES
        influxdbclient.h
        influxdbclient.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appTeam02_DigitalTripBook PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appTeam02_DigitalTripBook
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appTeam02_DigitalTripBook
    PRIVATE Qt6::Quick Qt6::Network Qt6::Sql
)

include(GNUInstallDirs)
install(TARGETS appTeam02_DigitalTripBook
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
