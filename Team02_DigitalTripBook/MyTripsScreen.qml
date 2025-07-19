import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    id: myTripsScreen
    property var trips: []
    signal showTripDetails(var tripData)

    background: Rectangle {
        color: Colors.currentTheme.background
    }

    Component.onCompleted: {
        trips = influxClient.getAllTripsFromDatabase()
    }

    ListView {
        anchors.fill: parent
        anchors.margins: 20
        model: trips
        spacing: 8
        clip: true
        delegate: Rectangle {
            width: ListView.view.width
            height: 60
            color: Colors.currentTheme.cardColor
            border.color: Colors.currentTheme.borderColor
            border.width: 1
            radius: 6

            MouseArea {
                anchors.fill: parent
                onClicked: myTripsScreen.showTripDetails(modelData)
                cursorShape: Qt.PointingHandCursor
            }

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 15
                text: "Trip " + modelData.tripId
                font.pixelSize: 18
                font.weight: Font.Bold
                color: Colors.currentTheme.primary
            }

            Text {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 15
                text: new Date(modelData.startTime).toLocaleDateString()
                font.pixelSize: 14
                color: Colors.currentTheme.caption
            }
        }
    }

    // Empty state when no trips available
    Rectangle {
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: 200
        color: "transparent"
        visible: trips.length === 0

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "🚗"
                font.pixelSize: 48
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "No Trips Yet"
                font.pixelSize: 24
                font.weight: Font.Bold
                color: Colors.currentTheme.primary
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Real InfluxDB trip data will appear here when available"
                font.pixelSize: 16
                color: Colors.currentTheme.caption
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
        }
    }
}
