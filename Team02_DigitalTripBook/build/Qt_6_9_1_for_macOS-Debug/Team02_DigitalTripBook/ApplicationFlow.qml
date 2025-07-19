import QtQuick
import QtQuick.Controls

Rectangle {
    id: applicationFlow
    color: Colors.currentTheme.background
    
    // State management like coffee project
    state: "Loading"
    property string previousState: ""
    property int animationDuration: 400
    
    // Component aliases for easy access
    property alias stack: stack
    property alias toolbar: toolbar
    
    // Function to switch theme
    function themeButton() {
        if (Colors.currentTheme === Colors.dark) {
            Colors.currentTheme = Colors.light
        } else {
            Colors.currentTheme = Colors.dark
        }
    }
    
    // Back button function following coffee pattern with iOS safety
    function backButton() {
        // Check if we can safely pop - following coffee project logic
        if (stack.depth > 1) {
            // iOS-safe navigation: pop with immediate transition
            stack.pop(StackView.Immediate)
            
            // Update state based on previousState like coffee project
            if (stack.depth === 1) {
                applicationFlow.state = "Home"
            } else {
                // Use the state system to determine where to go back
                applicationFlow.state = applicationFlow.previousState
            }
        } else {
            // We're at the root, ensure we're in Home state
            applicationFlow.state = "Home"
        }
    }
    
    // Safe navigation to home - like coffee's onReturnToStart
    function navigateToHome() {
        // Pop all items except the initial one - coffee project pattern
        while (stack.depth > 1) {
            stack.pop(StackView.Immediate)
        }
        applicationFlow.state = "Home"
        // Ensure we're showing the home component
        if (stack.currentItem !== homeComponent) {
            stack.replace(homeComponent, StackView.Immediate)
        }
    }
    
    // Cancel function like coffee project for emergency navigation
    function cancelToHome() {
        // Emergency navigation back to home - like coffee's cancelButton
        while (stack.depth > 1) {
            stack.pop(StackView.Immediate)
        }
        applicationFlow.state = "Home"
    }
    
    function navigateToTripBooking() {
        applicationFlow.previousState = applicationFlow.state
        applicationFlow.state = "TripBooking"
        stack.push(tripBookingComponent)
    }
    
    function navigateToExplore() {
        applicationFlow.previousState = applicationFlow.state
        applicationFlow.state = "Explore" 
        stack.push(exploreComponent)
    }
    
    function navigateToMyTrips() {
        applicationFlow.previousState = applicationFlow.state
        applicationFlow.state = "MyTrips"
        stack.push(myTripsComponent)
    }
    
    function navigateToStatistics() {
        applicationFlow.previousState = applicationFlow.state
        applicationFlow.state = "Statistics"
        stack.push(statisticsComponent)
    }
    
    function navigateToTripDetails(tripData) {
        applicationFlow.previousState = applicationFlow.state
        applicationFlow.state = "TripDetails"
        stack.push(tripDetailsComponent, {"tripData": tripData})
    }
    
    // Helper function to ensure safe navigation back to home from anywhere
    function safeNavigateHome() {
        // Emergency navigation like coffee project's onReturnToStart
        while (stack.depth > 1) {
            stack.pop(StackView.Immediate)
        }
        applicationFlow.state = "Home"
        if (stack.currentItem && stack.currentItem !== homeComponent) {
            stack.replace(homeComponent, StackView.Immediate)
        }
    }
    
    // Custom Toolbar like coffee project
    CustomToolBar {
        id: toolbar
        anchors.top: parent.top
        anchors.topMargin: Math.max(20, parent.height * 0.02) // Even smaller margin
        width: parent.width
        height: 30 // Much smaller height
        anchors.leftMargin: 10
        anchors.rightMargin: 10
    }
    
    // Title text
    Text {
        id: titleText
        text: "Digital TripBook"
        font.pixelSize: Math.min(16, parent.width * 0.04) // Smaller font
        font.weight: Font.Bold
        color: "#2196F3" // Blue title for modern look
        anchors.top: toolbar.bottom
        anchors.topMargin: Math.max(5, parent.height * 0.008) // Minimal margin
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
    }
    
    // StackView for navigation like coffee project
    StackView {
        id: stack
        anchors.top: titleText.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: Math.max(5, parent.height * 0.008) // Minimal margin
        anchors.margins: Math.max(5, parent.width * 0.008) // Minimal side margins
        
        initialItem: LoadingScreen {
            id: loadingScreen
            onLoadingComplete: {
                // Safe initial navigation - just replace current item
                stack.replace(homeComponent, StackView.Immediate)
                applicationFlow.state = "Home"
            }
        }
        
        // Smooth slide transitions like coffee project
        pushEnter: Transition {
            PropertyAnimation {
                property: "x"
                from: stack.width
                to: 0
                duration: applicationFlow.animationDuration
                easing.type: Easing.InOutQuad
            }
        }
        
        pushExit: Transition {
            PropertyAnimation {
                property: "x"
                from: 0
                to: -stack.width
                duration: applicationFlow.animationDuration
                easing.type: Easing.InOutQuad
            }
        }
        
        popEnter: Transition {
            PropertyAnimation {
                property: "x"
                from: -stack.width
                to: 0
                duration: applicationFlow.animationDuration
                easing.type: Easing.InOutQuad
            }
        }
        
        popExit: Transition {
            PropertyAnimation {
                property: "x"
                from: 0
                to: stack.width
                duration: applicationFlow.animationDuration
                easing.type: Easing.InOutQuad
            }
        }
    }
    
    // Component definitions
    Component {
        id: homeComponent
        HomeScreen {
            onStartTripBooking: applicationFlow.navigateToTripBooking()
            onExploreDestinations: applicationFlow.navigateToExplore()
            onViewMyTrips: applicationFlow.navigateToMyTrips()
            onViewStatistics: applicationFlow.navigateToStatistics()
        }
    }
    
    Component {
        id: tripBookingComponent
        TripBookingScreen {
        }
    }
    
    Component {
        id: exploreComponent
        ExploreScreen {
        }
    }
    
    Component {
        id: myTripsComponent
        MyTripsScreen {
            onShowTripDetails: function(tripData) {
                applicationFlow.navigateToTripDetails(tripData)
            }
        }
    }
    
    Component {
        id: tripDetailsComponent
        TripDetailsScreen {
            onBackPressed: applicationFlow.backButton()
        }
    }
    
    Component {
        id: statisticsComponent
        StatisticsScreen {
        }
    }
    
    // States following coffee project pattern
    states: [
        State {
            name: "Loading"
            PropertyChanges {
                target: toolbar
                backButtonVisible: false
                themeButtonVisible: false
            }
            PropertyChanges {
                target: titleText
                visible: false
            }
        },
        State {
            name: "Home"
            PropertyChanges {
                target: applicationFlow
                previousState: "Loading"
            }
            PropertyChanges {
                target: toolbar
                backButtonVisible: false
                themeButtonVisible: true
            }
            PropertyChanges {
                target: titleText
                text: "Digital TripBook"
                visible: true
            }
        },
        State {
            name: "TripBooking"
            PropertyChanges {
                target: applicationFlow
                previousState: "Home"
            }
            PropertyChanges {
                target: toolbar
                backButtonVisible: true
                themeButtonVisible: true
            }
            PropertyChanges {
                target: titleText
                text: "Plan Your Trip"
                visible: true
            }
        },
        State {
            name: "Explore"
            PropertyChanges {
                target: applicationFlow
                previousState: "Home"
            }
            PropertyChanges {
                target: toolbar
                backButtonVisible: true
                themeButtonVisible: true
            }
            PropertyChanges {
                target: titleText
                text: "Explore Destinations"
                visible: true
            }
        },
        State {
            name: "MyTrips"
            PropertyChanges {
                target: applicationFlow
                previousState: "Home"
            }
            PropertyChanges {
                target: toolbar
                backButtonVisible: true
                themeButtonVisible: true
            }
            PropertyChanges {
                target: titleText
                text: "My Trips"
                visible: true
            }
        },
        State {
            name: "Statistics"
            PropertyChanges {
                target: applicationFlow
                previousState: "Home"
            }
            PropertyChanges {
                target: toolbar
                backButtonVisible: true
                themeButtonVisible: true
            }
            PropertyChanges {
                target: titleText
                text: "Travel Statistics"
                visible: true
            }
        },
        State {
            name: "TripDetails"
            PropertyChanges {
                target: applicationFlow
                previousState: "MyTrips"
            }
            PropertyChanges {
                target: toolbar
                backButtonVisible: true
                themeButtonVisible: true
            }
            PropertyChanges {
                target: titleText
                text: "Trip Details"
                visible: true
            }
        }
    ]
}