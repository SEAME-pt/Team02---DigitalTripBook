import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Team02_DigitalTripBook

Page {
    id: tripDetailsScreen
    
    property var tripData: null
    
    signal backPressed()
    
    // Header
    Rectangle {
        id: headerBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 60
        color: Colors.currentTheme.cardColor
        border.color: Colors.currentTheme.borderColor
        border.width: 1
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            
            // Back button
            Button {
                text: "← Back"
                onClicked: tripDetailsScreen.backPressed()
                Layout.preferredWidth: 80
                background: Rectangle {
                    color: parent.pressed ? Colors.blue : "transparent"
                    border.color: Colors.blue
                    border.width: 1
                    radius: 6
                }
                contentItem: Text {
                    text: parent.text
                    color: parent.pressed ? "white" : Colors.blue
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            
            // Trip title
            Text {
                text: getTripTitle()
                font.pixelSize: 20
                font.weight: Font.Bold
                color: Colors.currentTheme.textColor
                Layout.fillWidth: true
                Layout.leftMargin: 20
            }
        }
    }
    
    // Scrollable content
    ScrollView {
        anchors.top: headerBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20
        
        ColumnLayout {
            width: parent.width
            spacing: 20
            
            // Trip Information Section
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: tripInfoColumn.implicitHeight + 40
                color: Colors.currentTheme.cardColor
                border.color: Colors.currentTheme.borderColor
                border.width: 1
                radius: 12
                
                ColumnLayout {
                    id: tripInfoColumn
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15
                    
                    Text {
                        text: "Trip Information"
                        font.pixelSize: 18
                        font.weight: Font.Bold
                        color: Colors.blue
                    }
                    
                    // Trip Name
                    Text {
                        text: "Trip Name: " + (tripData && tripData.tripName ? tripData.tripName : "Unnamed Trip")
                        font.pixelSize: 16
                        color: Colors.currentTheme.textColor
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }
                    
                    // Driver Name
                    Text {
                        text: "Driver: " + (tripData && tripData.driverName ? tripData.driverName : "Unknown Driver")
                        font.pixelSize: 16
                        color: Colors.currentTheme.textColor
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }
                    
                    // Trip ID
                    Text {
                        text: "Trip ID: #" + (tripData ? tripData.tripId : "Unknown")
                        font.pixelSize: 16
                        color: Colors.currentTheme.textColor
                    }
                    
                    // Start Time
                    Text {
                        text: "Start Time: " + formatDateTime(tripData ? tripData.startTime : "")
                        font.pixelSize: 16
                        color: Colors.currentTheme.textColor
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }
                    
                    // End Time
                    Text {
                        text: "End Time: " + formatDateTime(tripData ? tripData.endTime : "")
                        font.pixelSize: 16
                        color: Colors.currentTheme.textColor
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }
                    
                    // Duration
                    Text {
                        text: "Duration: " + formatDuration(tripData ? tripData.duration : 0)
                        font.pixelSize: 16
                        color: Colors.currentTheme.textColor
                    }
                }
            }
            
            // Distance & Speed Section
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: distanceSpeedColumn.implicitHeight + 40
                color: Colors.currentTheme.cardColor
                border.color: Colors.currentTheme.borderColor
                border.width: 1
                radius: 12
                
                ColumnLayout {
                    id: distanceSpeedColumn
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15
                    
                    Text {
                        text: "Distance & Speed"
                        font.pixelSize: 18
                        font.weight: Font.Bold
                        color: Colors.blue
                    }
                    
                    Text {
                        text: "Distance Traveled: " + (tripData ? tripData.distance.toFixed(1) : "0.0") + " km"
                        font.pixelSize: 16
                        color: Colors.currentTheme.textColor
                    }
                    
                    Text {
                        text: "Average Speed: " + (tripData ? tripData.averageSpeed.toFixed(1) : "0.0") + " km/h"
                        font.pixelSize: 16
                        color: Colors.currentTheme.textColor
                    }
                    
                    Text {
                        text: "Maximum Speed: " + (tripData ? tripData.maxSpeed.toFixed(1) : "0.0") + " km/h"
                        font.pixelSize: 16
                        color: Colors.currentTheme.textColor
                    }
                }
            }
            
            // Battery & Energy Section
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: batteryEnergyColumn.implicitHeight + 40
                color: Colors.currentTheme.cardColor
                border.color: Colors.currentTheme.borderColor
                border.width: 1
                radius: 12
                
                ColumnLayout {
                    id: batteryEnergyColumn
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15
                    
                    Text {
                        text: "Battery & Energy"
                        font.pixelSize: 18
                        font.weight: Font.Bold
                        color: Colors.blue
                    }
                    
                    Text {
                        text: "Start Battery: " + (tripData ? tripData.startCharge.toFixed(1) : "0.0") + "%"
                        font.pixelSize: 16
                        color: Colors.currentTheme.textColor
                    }
                    
                    Text {
                        text: "End Battery: " + (tripData ? tripData.endCharge.toFixed(1) : "0.0") + "%"
                        font.pixelSize: 16
                        color: Colors.currentTheme.textColor
                    }
                    
                    Text {
                        text: "Battery Used: " + (tripData ? (tripData.startCharge - tripData.endCharge).toFixed(1) : "0.0") + "%"
                        font.pixelSize: 16
                        color: Colors.currentTheme.textColor
                    }
                    
                    Text {
                        text: "Energy Consumed: " + (tripData ? (tripData.energyUsed / 1000).toFixed(2) : "0.00") + " kWh"
                        font.pixelSize: 16
                        color: Colors.currentTheme.textColor
                    }
                    
                    Text {
                        text: "Energy Efficiency: " + (tripData ? tripData.efficiency.toFixed(1) : "0.0") + " Wh/km"
                        font.pixelSize: 16
                        color: Colors.currentTheme.textColor
                    }
                }
            }
            
            // Notes Section
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: notesColumn.implicitHeight + 40
                color: Colors.currentTheme.cardColor
                border.color: Colors.currentTheme.borderColor
                border.width: 1
                radius: 12
                
                ColumnLayout {
                    id: notesColumn
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15
                    
                    Text {
                        text: "Notes"
                        font.pixelSize: 18
                        font.weight: Font.Bold
                        color: Colors.blue
                    }
                    
                    Text {
                        text: tripData && tripData.notes ? tripData.notes : "No notes for this trip"
                        font.pixelSize: 16
                        color: Colors.currentTheme.textColor
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        font.italic: !tripData || !tripData.notes
                    }
                }
            }
        }
    }
    
    // Helper functions
    function getTripTitle() {
        if (!tripData) return "Trip Details"
        if (tripData.tripName) return tripData.tripName
        return "Trip #" + tripData.tripId
    }
    
    function formatDateTime(dateTimeString) {
        if (!dateTimeString) return "Unknown"
        
        // Parse the datetime string and format it nicely
        var date = new Date(dateTimeString)
        if (isNaN(date.getTime())) return dateTimeString // Return original if parsing failed
        
        var options = {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        }
        
        return date.toLocaleDateString('en-US', options)
    }
    
    function formatDuration(seconds) {
        if (!seconds || seconds === 0) return "Unknown"
        
        var hours = Math.floor(seconds / 3600)
        var minutes = Math.floor((seconds % 3600) / 60)
        var remainingSeconds = seconds % 60
        
        if (hours > 0) {
            return hours + "h " + minutes + "m " + remainingSeconds + "s"
        } else if (minutes > 0) {
            return minutes + "m " + remainingSeconds + "s"
        } else {
            return remainingSeconds + "s"
        }
    }
}
