import QtQuick
import QtQuick.Layouts

Item {
    id: root
    property bool backButtonVisible: true
    property bool themeButtonVisible: true

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 20
        
        // Back Button with circular background
        Rectangle {
            id: backButton
            visible: root.backButtonVisible
            Layout.preferredWidth: 44
            Layout.preferredHeight: 44
            radius: 22
            color: Colors.currentTheme.cardColor
            border.color: Colors.currentTheme.borderColor
            border.width: 1
            
            Text {
                anchors.centerIn: parent
                text: "←"
                font.pixelSize: 20
                font.weight: Font.Bold
                color: Colors.currentTheme.textColor
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: applicationFlow.backButton()
                onPressed: parent.scale = 0.9
                onReleased: parent.scale = 1.0
                onCanceled: parent.scale = 1.0
            }
            
            Behavior on scale {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // Spacer to push theme button to the right
        Item {
            Layout.fillWidth: true
        }

        // Theme Button with circular background
        Rectangle {
            id: themeButton
            visible: root.themeButtonVisible
            Layout.preferredWidth: 44
            Layout.preferredHeight: 44
            radius: 22
            color: Colors.currentTheme.cardColor
            border.color: Colors.currentTheme.borderColor
            border.width: 1
            
            Text {
                anchors.centerIn: parent
                text: Colors.currentTheme === Colors.dark ? "☀️" : "🌙"
                font.pixelSize: 16
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: applicationFlow.themeButton()
                onPressed: parent.scale = 0.9
                onReleased: parent.scale = 1.0
                onCanceled: parent.scale = 1.0
            }
            
            Behavior on scale {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
