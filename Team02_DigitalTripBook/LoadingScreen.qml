import QtQuick
import Team02_DigitalTripBook

Rectangle {
    id: loadingScreen
    color: Colors.currentTheme.background
    
    signal loadingComplete()
    
    // System initialization status
    property bool systemInitialized: false
    
    Column {
        anchors.centerIn: parent
        spacing: Math.max(20, parent.height * 0.03)
        width: Math.min(parent.width * 0.8, 400)
        
        // Logo/Icon area
        Rectangle {
            width: Math.min(120, parent.width * 0.3)
            height: width
            radius: width / 2
            anchors.horizontalCenter: parent.horizontalCenter
            gradient: Colors.loadingGradient
            
            Text {
                anchors.centerIn: parent
                text: "🌍"
                font.pixelSize: Math.min(60, parent.width * 0.5)
                color: "white"
            }
        }
        
        // App Title
        Text {
            text: "Digital TripBook"
            font.pixelSize: Math.min(32, parent.width * 0.08)
            font.weight: Font.Bold
            color: "#2196F3" // Blue title for modern look
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }
        
        // Subtitle
        Text {
            text: "Your Journey Starts Here"
            font.pixelSize: Math.min(16, parent.width * 0.04)
            color: "#42A5F5" // Light blue subtitle for modern accent
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }
        
        // Simple loading animation
        Item {
            width: Math.min(250, parent.width * 0.8)
            height: 8
            anchors.horizontalCenter: parent.horizontalCenter
            
            Rectangle {
                id: progressBackground
                width: parent.width
                height: 4
                radius: 2
                color: Colors.currentTheme.borderColor
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Rectangle {
                id: progressBar
                height: 4
                radius: 2
                gradient: Colors.loadingGradient
                anchors.verticalCenter: parent.verticalCenter
                
                property real progress: 0
                width: progress * progressBackground.width
                
                // Smooth animation like coffee project
                Behavior on progress {
                    SmoothedAnimation {
                        velocity: 0.5
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
        
        // Loading text
        Text {
            text: "Loading your adventure..."
            font.pixelSize: Math.min(14, parent.width * 0.035)
            color: Colors.blue
            anchors.horizontalCenter: parent.horizontalCenter
            font.weight: Font.Medium
        }
    }
    
    // Timer to control progress like coffee project
    Timer {
        id: progressTimer
        interval: 50
        running: true
        repeat: true
        property real step: 0.02
        
        onTriggered: {
            if (progressBar.progress < 0.8) {
                progressBar.progress += step
            } else if (progressBar.progress < 1.0 && !systemInitialized) {
                // Initialize system when progress reaches 80%
                console.log("LoadingScreen: Initializing system...");
                systemInitialized = true;
                console.log("LoadingScreen: System initialized successfully");
                progressBar.progress += step
            } else if (progressBar.progress < 1.0) {
                progressBar.progress += step
            } else {
                running = false
                loadingScreen.loadingComplete()
            }
        }
    }
}
