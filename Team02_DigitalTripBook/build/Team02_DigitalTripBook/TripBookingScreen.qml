import QtQuick
import QtQuick.Layouts

Rectangle {
    id: tripBookingScreen
    color: Colors.currentTheme.background
    
    ColumnLayout {
        anchors.centerIn: parent
        anchors.margins: Math.max(20, parent.width * 0.05)
        spacing: Math.max(20, parent.height * 0.03)
        width: Math.min(parent.width * 0.8, 600)
        
        Text {
            text: "Trip Planner"
            font.pixelSize: Math.min(32, parent.width * 0.08)
            font.weight: Font.Bold
            color: Colors.currentTheme.textColor
            Layout.alignment: Qt.AlignCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
        
        Text {
            text: "Coming soon:"
            font.pixelSize: Math.min(18, parent.width * 0.045)
            color: Colors.currentTheme.caption
            Layout.alignment: Qt.AlignCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
        
        Text {
            text: "🌍"
            font.pixelSize: Math.min(80, parent.width * 0.15)
            Layout.alignment: Qt.AlignCenter
        }
        
        Text {
            text: "This is where you'll be able to:"
            font.pixelSize: 16
            color: Colors.currentTheme.textColor
            Layout.alignment: Qt.AlignCenter
        }
        
        Column {
            Layout.alignment: Qt.AlignCenter
            spacing: 10
            
            Text {
                text: "• Choose destinations"
                font.pixelSize: 14
                color: Colors.currentTheme.caption
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: "• Set travel dates"
                font.pixelSize: 14
                color: Colors.currentTheme.caption
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: "• Book accommodations"
                font.pixelSize: 14
                color: Colors.currentTheme.caption
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: "• Plan activities"
                font.pixelSize: 14
                color: Colors.currentTheme.caption
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
