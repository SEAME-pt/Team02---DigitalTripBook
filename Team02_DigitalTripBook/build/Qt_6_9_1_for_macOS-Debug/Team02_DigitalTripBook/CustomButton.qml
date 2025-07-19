import QtQuick
import QtQuick.Controls

AbstractButton {
    id: button
    property string buttonText: ""
    property bool showIcon: true
    property string buttonColor: "primary"
    property alias rectangle: rectangle

    states: State {
        name: "pressed"
        when: button.pressed
        PropertyChanges {
            target: rectangle
            scale: 0.9
        }
    }

    transitions: Transition {
        NumberAnimation {
            properties: "scale"
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }

    contentItem: Rectangle {
        id: rectangle
        border.width: 1
        border.color: Colors.border
        radius: 10
        anchors.fill: parent
        gradient: button.buttonColor === "primary" ? Colors.primaryGradient : Colors.secondaryGradient
        
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8
            
            Text {
                text: button.buttonText
                color: Colors.currentTheme.background
                font.pixelSize: 18
                font.weight: Font.Bold
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Text {
                id: icon
                visible: button.showIcon
                text: "→"
                color: Colors.currentTheme.background
                font.pixelSize: 20
                font.weight: Font.Bold
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
