import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window

Rectangle {
    id: homeScreen
    color: Colors.currentTheme.background
    
    signal startTripBooking()
    signal exploreDestinations()
    signal viewMyTrips()
    signal viewStatistics()
    
    // Responsive properties
    property bool isSmallScreen: (Screen.width * Screen.devicePixelRatio) < 1000
    property bool isPortrait: height > width
    property real baseMargin: isSmallScreen ? 15 : 20
    property real cardSize: isSmallScreen ? Math.min(parent.width * 0.85, 250) : Math.min(parent.width * 0.4, 320)

    ScrollView {
        anchors.fill: parent
        contentWidth: homeScreen.width
        contentHeight: mainContent.height + 40
        
        ColumnLayout {
            id: mainContent
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: homeScreen.baseMargin
            spacing: homeScreen.isSmallScreen ? 20 : 30
            width: Math.min(parent.width * 0.95, 900)
        
        // Header Section
        Column {
            Layout.alignment: Qt.AlignCenter
            spacing: homeScreen.isSmallScreen ? 10 : 15
            Layout.maximumWidth: parent.width
            
            // Logo
            Rectangle {
                width: homeScreen.isSmallScreen ? 100 : 160
                height: width
                radius: width / 2
                anchors.horizontalCenter: parent.horizontalCenter
                gradient: Colors.loadingGradient // Changed to blue gradient
                
                Text {
                    anchors.centerIn: parent
                    text: "🌍"
                    font.pixelSize: homeScreen.isSmallScreen ? 60 : 100
                    color: "white"
                }
            }
            
            // Title
            Text {
                text: "Digital TripBook"
                font.pixelSize: homeScreen.isSmallScreen ? 24 : 36
                font.weight: Font.Bold
                color: "#2196F3" // Blue title for modern look
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
            
            // Subtitle
            Text {
                text: "Plan, Track & Remember Your Adventures"
                font.pixelSize: homeScreen.isSmallScreen ? 14 : 18
                color: Colors.currentTheme.caption
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                Layout.maximumWidth: parent.width * 0.8
            }
        }
        
        // Action Cards
        ColumnLayout {
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: parent.width
            spacing: homeScreen.isSmallScreen ? 12 : 20
            
            // Statistics Card - Coffee style with blue gradient border
            Rectangle {
                Layout.preferredWidth: homeScreen.isSmallScreen ? parent.width * 0.95 : 320
                Layout.preferredHeight: homeScreen.isSmallScreen ? 70 : 160
                Layout.alignment: Qt.AlignCenter
                radius: 15
                
                gradient: Gradient {
                    GradientStop {
                        position: 1.0
                        color: "#2196F3"
                    }
                    GradientStop {
                        position: 0.66
                        color: "#c742A5F5"
                    }
                    GradientStop {
                        position: 0.33
                        color: "#ab42A5F5"
                    }
                    GradientStop {
                        position: 0.0
                        color: Colors.currentTheme.cardColor
                    }
                }
                
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: 13
                    color: Colors.currentTheme.cardColor
                
                // Small screen: horizontal layout
                RowLayout {
                    visible: homeScreen.isSmallScreen
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "📊"
                        font.pixelSize: 28
                        Layout.alignment: Qt.AlignVCenter
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        
                        Text {
                            text: "Statistics"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: "#2196F3" // Blue title
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            text: "Track your travel stats"
                            font.pixelSize: 12
                            color: Colors.currentTheme.caption
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                        }
                    }
                    
                    Text {
                        text: "→"
                        font.pixelSize: 18
                        color: Colors.currentTheme.caption
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
                
                // Large screen: vertical layout
                ColumnLayout {
                    visible: !homeScreen.isSmallScreen
                    anchors.centerIn: parent
                    spacing: 12
                    width: parent.width * 0.8
                    
                    Text {
                        text: "📊"
                        font.pixelSize: 40
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Text {
                        text: "Statistics"
                        font.pixelSize: 18
                        font.weight: Font.Bold
                        color: "#2196F3" // Blue title
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                    
                    Text {
                        text: "Track your travel stats"
                        font.pixelSize: 14
                        color: Colors.currentTheme.caption
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: homeScreen.viewStatistics()
                    onPressed: parent.parent.scale = 0.95
                    onReleased: parent.parent.scale = 1.0
                    onCanceled: parent.parent.scale = 1.0
                }
                }
                
                Behavior on scale {
                    NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
                }
            }

            // My Trips Card - Coffee style with blue gradient border
            Rectangle {
                Layout.preferredWidth: homeScreen.isSmallScreen ? parent.width * 0.95 : 320
                Layout.preferredHeight: homeScreen.isSmallScreen ? 70 : 160
                Layout.alignment: Qt.AlignCenter
                radius: 15
                
                gradient: Gradient {
                    GradientStop {
                        position: 1.0
                        color: "#2196F3"
                    }
                    GradientStop {
                        position: 0.66
                        color: "#c742A5F5"
                    }
                    GradientStop {
                        position: 0.33
                        color: "#ab42A5F5"
                    }
                    GradientStop {
                        position: 0.0
                        color: Colors.currentTheme.cardColor
                    }
                }
                
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: 13
                    color: Colors.currentTheme.cardColor
                
                // Small screen: horizontal layout
                RowLayout {
                    visible: homeScreen.isSmallScreen
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "📁"
                        font.pixelSize: 28
                        Layout.alignment: Qt.AlignVCenter
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        
                        Text {
                            text: "Journeys History"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: "#2196F3" // Blue title
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            text: "View your travel history"
                            font.pixelSize: 12
                            color: Colors.currentTheme.caption
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                        }
                    }
                    
                    Text {
                        text: "→"
                        font.pixelSize: 18
                        color: Colors.currentTheme.caption
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
                
                // Large screen: vertical layout
                ColumnLayout {
                    visible: !homeScreen.isSmallScreen
                    anchors.centerIn: parent
                    spacing: 12
                    width: parent.width * 0.8
                    
                    Text {
                        text: "📁"
                        font.pixelSize: 40
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Text {
                        text: "Journeys History"
                        font.pixelSize: 18
                        font.weight: Font.Bold
                        color: "#2196F3" // Blue title
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                    
                    Text {
                        text: "View your travel history"
                        font.pixelSize: 14
                        color: Colors.currentTheme.caption
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: homeScreen.viewMyTrips()
                    onPressed: parent.parent.scale = 0.95
                    onReleased: parent.parent.scale = 1.0
                    onCanceled: parent.parent.scale = 1.0
                }
                }
                
                Behavior on scale {
                    NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
                }
            }

            // Start New Trip Card - Coffee style with blue gradient border
            Rectangle {
                Layout.preferredWidth: homeScreen.isSmallScreen ? parent.width * 0.95 : 320
                Layout.preferredHeight: homeScreen.isSmallScreen ? 70 : 160
                Layout.alignment: Qt.AlignCenter
                radius: 15
                
                gradient: Gradient {
                    GradientStop {
                        position: 1.0
                        color: "#2196F3"
                    }
                    GradientStop {
                        position: 0.66
                        color: "#c742A5F5"
                    }
                    GradientStop {
                        position: 0.33
                        color: "#ab42A5F5"
                    }
                    GradientStop {
                        position: 0.0
                        color: Colors.currentTheme.cardColor
                    }
                }
                
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: 13
                    color: Colors.currentTheme.cardColor
                
                // Small screen: horizontal layout
                RowLayout {
                    visible: homeScreen.isSmallScreen
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "🚗"
                        font.pixelSize: 28
                        Layout.alignment: Qt.AlignVCenter
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        
                        Text {
                            text: "New Trip"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: "#2196F3" // Blue title
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            text: "Plan your next adventure"
                            font.pixelSize: 12
                            color: Colors.currentTheme.caption
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                        }
                    }
                    
                    Text {
                        text: "→"
                        font.pixelSize: 18
                        color: Colors.currentTheme.caption
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
                
                // Large screen: vertical layout
                ColumnLayout {
                    visible: !homeScreen.isSmallScreen
                    anchors.centerIn: parent
                    spacing: 12
                    width: parent.width * 0.8
                    
                    Text {
                        text: "🚗"
                        font.pixelSize: 40
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Text {
                        text: "New Trip"
                        font.pixelSize: 18
                        font.weight: Font.Bold
                        color: "#2196F3" // Blue title
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                    
                    Text {
                        text: "Adventure Mode"
                        font.pixelSize: 14
                        color: Colors.currentTheme.caption
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: homeScreen.startTripBooking()
                    onPressed: parent.parent.scale = 0.95
                    onReleased: parent.parent.scale = 1.0
                    onCanceled: parent.parent.scale = 1.0
                }
                }
                
                Behavior on scale {
                    NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
                }
            }

            // Explore Card - Coffee style with blue gradient border
            Rectangle {
                Layout.preferredWidth: homeScreen.isSmallScreen ? parent.width * 0.95 : 320
                Layout.preferredHeight: homeScreen.isSmallScreen ? 70 : 160
                Layout.alignment: Qt.AlignCenter
                radius: 15
                
                gradient: Gradient {
                    GradientStop {
                        position: 1.0
                        color: "#2196F3"
                    }
                    GradientStop {
                        position: 0.66
                        color: "#c742A5F5"
                    }
                    GradientStop {
                        position: 0.33
                        color: "#ab42A5F5"
                    }
                    GradientStop {
                        position: 0.0
                        color: Colors.currentTheme.cardColor
                    }
                }
                
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: 13
                    color: Colors.currentTheme.cardColor
                
                // Small screen: horizontal layout
                RowLayout {
                    visible: homeScreen.isSmallScreen
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "🗺️"
                        font.pixelSize: 28
                        Layout.alignment: Qt.AlignVCenter
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        
                        Text {
                            text: "Adventure Mode"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: "#2196F3" // Blue title
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            text: "Discover amazing places"
                            font.pixelSize: 12
                            color: Colors.currentTheme.caption
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                        }
                    }
                    
                    Text {
                        text: "→"
                        font.pixelSize: 18
                        color: Colors.currentTheme.caption
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
                
                // Large screen: vertical layout
                ColumnLayout {
                    visible: !homeScreen.isSmallScreen
                    anchors.centerIn: parent
                    spacing: 12
                    width: parent.width * 0.8
                    
                    Text {
                        text: "🗺️"
                        font.pixelSize: 40
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Text {
                        text: "Adventure Mode"
                        font.pixelSize: 18
                        font.weight: Font.Bold
                        color: "#2196F3" // Blue title
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                    
                    Text {
                        text: "Discover amazing places"
                        font.pixelSize: 14
                        color: Colors.currentTheme.caption
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: homeScreen.exploreDestinations()
                    onPressed: parent.parent.scale = 0.95
                    onReleased: parent.parent.scale = 1.0
                    onCanceled: parent.parent.scale = 1.0
                }
                }
                
                Behavior on scale {
                    NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
                }
            }
        }
    }
    }
}
