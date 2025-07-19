import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: tripDetailPage
    property var tripData: ({});

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
            Rectangle {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                height: 30
                color: "#f0f0f0"
                Label {
                    text: "Trip Information"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.bold: true
                }
            }

            Label { text: "<b>Driver:</b>"; textFormat: Text.RichText }
            Label { text: tripData.name; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>Vehicle:</b>"; textFormat: Text.RichText }
            Label { text: tripData.vehicle; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>Location:</b>"; textFormat: Text.RichText }
            Label { text: tripData.location; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>Date:</b>"; textFormat: Text.RichText }
            Label { text: tripData.startDate; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>Start Time:</b>"; textFormat: Text.RichText }
            Label { text: tripData.startTime; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>End Time:</b>"; textFormat: Text.RichText }
            Label { text: tripData.endTime; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>Duration:</b>"; textFormat: Text.RichText }
            Label { text: tripData.duration + " minutes"; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            // --- Energy & Performance ---
            Rectangle {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                height: 30
                color: "#f0f0f0"
                Label {
                    text: "Energy & Performance"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.bold: true
                }
            }

            Label { text: "<b>Start Battery:</b>"; textFormat: Text.RichText }
            Label { text: tripData.startOdometer.toFixed(1) + "%"; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>End Battery:</b>"; textFormat: Text.RichText }
            Label { text: tripData.endOdometer.toFixed(1) + "%"; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>Energy Used:</b>"; textFormat: Text.RichText }
            Label { text: tripData.energyUsed.toFixed(2) + " kWh"; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>Distance:</b>"; textFormat: Text.RichText }
            Label { text: tripData.distance + " m"; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>Average Speed:</b>"; textFormat: Text.RichText }
            Label { text: tripData.averageSpeed.toFixed(1) + " m/s"; wrapMode: Label.WordWrap; Layout.fillWidth: true }

            Label { text: "<b>Favorite:</b>"; textFormat: Text.RichText }
            Text {
                id: favoriteStar
                text: tripData.favorite ? "★" : "☆"
                font.pixelSize: 24
                color: tripData.favorite ? "gold" : "gray"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        var newStatus = !tripDetailPage.tripData.favorite;
                        tripDetailPage.tripData.favorite = newStatus;

                        // Manually update the star's appearance for immediate feedback
                        favoriteStar.text = newStatus ? "★" : "☆";
                        favoriteStar.color = newStatus ? "gold" : "gray";

                        // Call the C++ backend to save the change
                        dbHandler.updateTripFavoriteStatus(tripDetailPage.tripData.id, newStatus);
                    }
                }
            }

            Label { text: "<b>Notes:</b>"; textFormat: Text.RichText; Layout.columnSpan: 2 }
            Label { text: tripData.notes ? tripData.notes : "No notes for this trip."; wrapMode: Label.WordWrap; Layout.fillWidth: true; Layout.columnSpan: 2 }
        }
    }

    Button {
        id: backButton
        text: "Back"
        onClicked: backClicked()
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20
        Accessible.name: "Back to trips list"
        Accessible.description: "Returns to the list of all trips."
    }
}
