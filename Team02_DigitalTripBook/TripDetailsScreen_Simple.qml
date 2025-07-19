import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    id: tripDetailsScreen
    property var tripData: null

    ScrollView {
        anchors.fill: parent
        
        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Text {
                text: "Trip " + (tripData ? tripData.tripId : "")
                font.pixelSize: 24
                font.weight: Font.Bold
                color: "#333"
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#ddd"
            }

            // Trip Information Section
            Text {
                text: "Trip Information"
                font.pixelSize: 18
                font.weight: Font.Bold
                color: "#333"
            }

            Text {
                text: "Start Time: " + (tripData ? formatDateTime(tripData.startTime) : "")
                font.pixelSize: 14
                color: "#555"
            }

            Text {
                text: "End Time: " + (tripData ? formatDateTime(tripData.endTime) : "")
                font.pixelSize: 14
                color: "#555"
            }

            Text {
                text: "Duration: " + (tripData ? formatDuration(tripData.duration) : "")
                font.pixelSize: 14
                color: "#555"
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#eee"
            }

            // Speed & Distance Section
            Text {
                text: "Speed & Distance"
                font.pixelSize: 18
                font.weight: Font.Bold
                color: "#333"
            }

            Text {
                text: "Distance Traveled: " + (tripData ? (tripData.distance || 0).toFixed(2) + " km" : "0.00 km")
                font.pixelSize: 14
                color: "#555"
            }

            Text {
                text: "Average Speed: " + (tripData ? (tripData.averageSpeed || 0).toFixed(1) + " km/h" : "0.0 km/h")
                font.pixelSize: 14
                color: "#555"
            }

            Text {
                text: "Max Speed: " + (tripData ? (tripData.maxSpeed || 0).toFixed(1) + " km/h" : "0.0 km/h")
                font.pixelSize: 14
                color: "#555"
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#eee"
            }

            // Battery & Energy Section
            Text {
                text: "Battery & Energy"
                font.pixelSize: 18
                font.weight: Font.Bold
                color: "#333"
            }

            Text {
                text: "Start Battery: " + (tripData ? (tripData.startCharge || 0).toFixed(1) + "%" : "0.0%")
                font.pixelSize: 14
                color: "#555"
            }

            Text {
                text: "End Battery: " + (tripData ? (tripData.endCharge || 0).toFixed(1) + "%" : "0.0%")
                font.pixelSize: 14
                color: "#555"
            }

            Text {
                text: "Battery Used: " + (tripData ? ((tripData.startCharge || 0) - (tripData.endCharge || 0)).toFixed(1) + "%" : "0.0%")
                font.pixelSize: 14
                color: "#555"
            }

            Text {
                text: "Energy Consumed: " + (tripData ? (tripData.energyUsed || 0).toFixed(1) + " Wh" : "0.0 Wh")
                font.pixelSize: 14
                color: "#555"
            }

            Text {
                text: "Energy Efficiency: " + (tripData ? (tripData.efficiency || 0).toFixed(1) + " Wh/km" : "0.0 Wh/km")
                font.pixelSize: 14
                color: "#555"
            }
        }
    }

    // Helper functions for formatting
    function formatDateTime(dateTimeStr) {
        if (!dateTimeStr) return "N/A"
        var date = new Date(dateTimeStr)
        return date.toLocaleString()
    }

    function formatDuration(seconds) {
        if (!seconds) return "0 min"
        var hours = Math.floor(seconds / 3600)
        var minutes = Math.floor((seconds % 3600) / 60)
        var secs = seconds % 60
        
        if (hours > 0) {
            return hours + " h " + minutes + " min"
        } else {
            return minutes + " min " + secs + " sec"
        }
    }
}
