import QtQuick 6.2
import QtQuick.Controls 2.15
import QtQuick.Layouts 6.2

Page {
    id: tripDetailPage
    property var tripData: ({});

    // Define a reusable component for section headers
    component SectionHeader: Label {
        Layout.columnSpan: 2
        font.bold: true
        font.pointSize: 14
        topPadding: 15
        bottomPadding: 5
        background: Rectangle {
            width: parent.width
            height: parent.height
            color: "#f0f0f0"
        }
    }

    signal backClicked()

    header: ToolBar {
        Label {
            text: "Trip Details"
            anchors.centerIn: parent
            font.bold: true
        }
    }

    Flickable {
        anchors.fill: parent
        anchors.bottomMargin: backButton.height + 20
        contentHeight: gridLayout.implicitHeight
        flickableDirection: Flickable.VerticalFlick

        GridLayout {
            id: gridLayout
            columns: 2
            width: parent.width
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            columnSpacing: 10

            // --- Trip Information ---
            SectionHeader { text: "Trip Information" }

            Label { text: "<b>Driver:</b>"; textFormat: Text.RichText }
            Label { text: tripData.driver; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>Vehicle:</b>"; textFormat: Text.RichText }
            Label { text: tripData.vehicle; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>Location:</b>"; textFormat: Text.RichText }
            Label { text: tripData.location; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>Date & Time:</b>"; textFormat: Text.RichText }
            Label { text: tripData.date; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>Duration:</b>"; textFormat: Text.RichText }
            Label { text: tripData.duration + " minutes"; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            // --- Energy & Performance ---
            SectionHeader { text: "Energy & Performance" }

            Label { text: "<b>Start Battery:</b>"; textFormat: Text.RichText }
            Label { text: tripData.start_battery.toFixed(1) + "%"; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>End Battery:</b>"; textFormat: Text.RichText }
            Label { text: tripData.end_battery.toFixed(1) + "%"; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>Energy Used:</b>"; textFormat: Text.RichText }
            Label { text: tripData.energy_used.toFixed(2) + " kWh"; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>Distance:</b>"; textFormat: Text.RichText }
            Label { text: tripData.distance_m + " m"; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>Average Speed:</b>"; textFormat: Text.RichText }
            Label { text: tripData.avg_speed.toFixed(1) + " m/s"; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            // --- Other Details ---
            SectionHeader { text: "Other Details" }

            Label { text: "<b>Favorite:</b>"; textFormat: Text.RichText }
            Label { text: (tripData.favorite ? "Yes" : "No"); wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>Notes:</b>"; textFormat: Text.RichText; Layout.columnSpan: 2 }
            Label { text: tripData.notes ? tripData.notes : "No notes for this trip."; wrapMode: Label.WordWrap; Layout.fillWidth: true; Layout.columnSpan: 2 }
        }
    }

    Button {
        id: backButton
        text: "Back"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 10
        onClicked: tripDetailPage.backClicked()
        Accessible.name: "Back to trips list"
    }
}
