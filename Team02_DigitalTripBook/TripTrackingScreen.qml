import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: tripTrackingScreen
    color: Colors.currentTheme.background
    
    signal backPressed()
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20
        
        // Header
        Text {
            text: "Trip Tracking"
            font.pixelSize: 24
            font.weight: Font.Bold
            color: Colors.currentTheme.text
            Layout.alignment: Qt.AlignHCenter
        }
        
        // Tracking content
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Colors.currentTheme.cardBackground
            radius: 10
            border.color: Colors.currentTheme.border
            border.width: 1
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15
                
                Text {
                    text: "Real-time Trip Monitoring"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: Colors.currentTheme.text
                }
                
                Text {
                    text: "Track your current trip progress, vehicle status, and navigation updates."
                    font.pixelSize: 14
                    color: Colors.currentTheme.secondaryText
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
                
                // Placeholder for tracking features
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 200
                    color: Colors.currentTheme.background
                    radius: 5
                    border.color: Colors.currentTheme.border
                    border.width: 1
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Trip tracking features\nwill be implemented here"
                        font.pixelSize: 16
                        color: Colors.currentTheme.secondaryText
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
                
                Item {
                    Layout.fillHeight: true
                }
            }
        }
        
        // Back button
        CustomButton {
            text: "Back"
            Layout.alignment: Qt.AlignHCenter
            onClicked: tripTrackingScreen.backPressed()
        }
    }
}
