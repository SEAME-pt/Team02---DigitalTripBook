import QtQuick 6.2
import QtQuick.Controls 2.15
import QtQuick.Layouts 6.2

Page {
    id: tripDetailPage
    property var tripData: ({});

    signal backClicked()

    header: ToolBar {
        Label {
            text: "Trip Details"
            anchors.centerIn: parent
        }
    }

    Flickable {
        anchors.fill: parent
        contentHeight: columnLayout.height

        ColumnLayout {
            id: columnLayout
            width: parent.width
            anchors.margins: 10
            spacing: 10

            Label { text: "Driver: " + tripData.name }
            Label { text: "Start Date: " + tripData.startDate }
            Label { text: "End Date: " + tripData.endDate }
            Label { text: "Start Time: " + tripData.startTime }
            Label { text: "End Time: " + tripData.endTime }
            Label { text: "Start Odometer: " + tripData.startOdometer }
            Label { text: "End Odometer: " + tripData.endOdometer }
            Label { text: "Vehicle: " + tripData.vehicle }
            Label { text: "Notes: " + tripData.notes }
        }
    }
}
