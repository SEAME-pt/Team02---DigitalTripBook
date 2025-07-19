import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    id: tripDetailsScreen
    property var tripData: null
    signal backPressed()

    background: Rectangle {
        color: Colors.currentTheme.background
    }

    ScrollView {
        anchors.fill: parent
        clip: true
        
        Flickable {
            anchors.fill: parent
            contentWidth: parent.width
            contentHeight: mainColumn.height
            
            Column {
                id: mainColumn
                width: parent.width - 40
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20
                topPadding: 20

            // Back button
            Rectangle {
                width: 80
                height: 35
                color: Colors.currentTheme.primary
                radius: 6
                
                Text {
                    anchors.centerIn: parent
                    text: "← Back"
                    color: "white"
                    font.weight: Font.Bold
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: tripDetailsScreen.backPressed()
                }
            }

            Text {
                text: "Trip " + (tripDetailsScreen.tripData ? tripDetailsScreen.tripData.tripId : "")
                font.pixelSize: 24
                font.weight: Font.Bold
                color: Colors.currentTheme.primary
            }

            Rectangle {
                width: parent.width
                height: 2
                gradient: Colors.primaryGradient
                radius: 1
            }

            // Trip Information Section
            Column {
                width: parent.width
                spacing: 8

                Text {
                    text: "Trip Information"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: Colors.currentTheme.secondary
                }

                // Start Time
                Row {
                    spacing: 10
                    Text {
                        text: "Start Time:"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        color: Colors.currentTheme.textColor
                        width: 120
                    }
                    Text {
                        text: tripDetailsScreen.tripData ? tripDetailsScreen.formatDateTime(tripDetailsScreen.tripData.startTime) : ""
                        font.pixelSize: 14
                        color: Colors.currentTheme.caption
                    }
                }

                // End Time
                Row {
                    spacing: 10
                    Text {
                        text: "End Time:"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        color: Colors.currentTheme.textColor
                        width: 120
                    }
                    Text {
                        text: tripDetailsScreen.tripData ? tripDetailsScreen.formatDateTime(tripDetailsScreen.tripData.endTime) : ""
                        font.pixelSize: 14
                        color: Colors.currentTheme.caption
                    }
                }

                // Duration
                Row {
                    spacing: 10
                    Text {
                        text: "Duration:"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        color: Colors.currentTheme.textColor
                        width: 120
                    }
                    Text {
                        text: tripDetailsScreen.tripData ? tripDetailsScreen.formatDuration(tripDetailsScreen.tripData.duration) : ""
                        font.pixelSize: 14
                        color: Colors.currentTheme.caption
                    }
                }
            }

            // Speed & Distance Section
            Column {
                width: parent.width
                spacing: 8

                Text {
                    text: "Speed & Distance"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: Colors.currentTheme.secondary
                }

                // Distance Traveled
                Row {
                    spacing: 10
                    Text {
                        text: "Distance:"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        color: Colors.currentTheme.textColor
                        width: 120
                    }
                    Text {
                        text: tripDetailsScreen.tripData ? (tripDetailsScreen.tripData.distance || 0).toFixed(2) + " km" : "0.00 km"
                        font.pixelSize: 14
                        color: Colors.currentTheme.caption
                    }
                }

                // Average Speed
                Row {
                    spacing: 10
                    Text {
                        text: "Avg Speed:"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        color: Colors.currentTheme.textColor
                        width: 120
                    }
                    Text {
                        text: tripDetailsScreen.tripData ? (tripDetailsScreen.tripData.averageSpeed || 0).toFixed(1) + " km/h" : "0.0 km/h"
                        font.pixelSize: 14
                        color: Colors.currentTheme.caption
                    }
                }

                // Max Speed
                Row {
                    spacing: 10
                    Text {
                        text: "Max Speed:"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        color: Colors.currentTheme.textColor
                        width: 120
                    }
                    Text {
                        text: tripDetailsScreen.tripData ? (tripDetailsScreen.tripData.maxSpeed || 0).toFixed(1) + " km/h" : "0.0 km/h"
                        font.pixelSize: 14
                        color: Colors.currentTheme.caption
                    }
                }
            }

            // Battery & Energy Section
            Column {
                width: parent.width
                spacing: 8

                Text {
                    text: "Battery & Energy"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: Colors.currentTheme.secondary
                }

                // Start Battery
                Row {
                    spacing: 10
                    Text {
                        text: "Start Battery:"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        color: Colors.currentTheme.textColor
                        width: 120
                    }
                    Text {
                        text: tripDetailsScreen.tripData ? (tripDetailsScreen.tripData.startCharge || 0).toFixed(1) + "%" : "0.0%"
                        font.pixelSize: 14
                        color: Colors.green
                    }
                }

                // End Battery
                Row {
                    spacing: 10
                    Text {
                        text: "End Battery:"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        color: Colors.currentTheme.textColor
                        width: 120
                    }
                    Text {
                        text: tripDetailsScreen.tripData ? (tripDetailsScreen.tripData.endCharge || 0).toFixed(1) + "%" : "0.0%"
                        font.pixelSize: 14
                        color: Colors.currentTheme.caption
                    }
                }

                // Battery Used
                Row {
                    spacing: 10
                    Text {
                        text: "Battery Used:"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        color: Colors.currentTheme.textColor
                        width: 120
                    }
                    Text {
                        text: tripDetailsScreen.tripData ? ((tripDetailsScreen.tripData.startCharge || 0) - (tripDetailsScreen.tripData.endCharge || 0)).toFixed(1) + "%" : "0.0%"
                        font.pixelSize: 14
                        color: "#FF5722"
                    }
                }

                // Energy Consumed
                Row {
                    spacing: 10
                    Text {
                        text: "Energy Used:"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        color: Colors.currentTheme.textColor
                        width: 120
                    }
                    Text {
                        text: tripDetailsScreen.tripData ? (tripDetailsScreen.tripData.energyUsed || 0).toFixed(1) + " Wh" : "0.0 Wh"
                        font.pixelSize: 14
                        color: Colors.currentTheme.caption
                    }
                }

                // Energy Efficiency
                Row {
                    spacing: 10
                    Text {
                        text: "Efficiency:"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        color: Colors.currentTheme.textColor
                        width: 120
                    }
                    Text {
                        text: tripDetailsScreen.tripData ? (tripDetailsScreen.tripData.efficiency || 0).toFixed(1) + " Wh/km" : "0.0 Wh/km"
                        font.pixelSize: 14
                        color: Colors.currentTheme.caption
                    }
                }
            }

            // Trip Notes Section
            Column {
                width: parent.width
                spacing: 8

                Text {
                    text: "Trip Notes"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: Colors.currentTheme.secondary
                }

                Rectangle {
                    width: parent.width
                    height: notesText.implicitHeight + 20 < 40 ? 40 : notesText.implicitHeight + 20
                    color: Colors.currentTheme.background
                    border.color: Colors.currentTheme.borderColor
                    border.width: 1
                    radius: 4

                    Text {
                        id: notesText
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: 10
                        text: tripDetailsScreen.tripData && tripDetailsScreen.tripData.notes ? tripDetailsScreen.tripData.notes : "No notes for this trip"
                        font.pixelSize: 14
                        color: Colors.currentTheme.caption
                        wrapMode: Text.WordWrap
                        font.italic: !tripDetailsScreen.tripData || !tripDetailsScreen.tripData.notes
                        lineHeight: 1.2
                        verticalAlignment: Text.AlignTop
                    }
                }
            }
        }
    }
    }

    function formatDateTime(dateString) {
        if (!dateString) return "";
        var date = new Date(dateString);
        return date.toLocaleString();
    }

    function formatDuration(duration) {
        if (!duration) return "0 min";
        var hours = Math.floor(duration / 3600);
        var minutes = Math.floor((duration % 3600) / 60);
        if (hours > 0) {
            return hours + "h " + minutes + "m";
        } else {
            return minutes + "m";
        }
    }
}
