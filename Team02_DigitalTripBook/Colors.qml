pragma Singleton
import QtQuick

Item {
    QtObject {
        id: light
        readonly property color background: "#ffffff"
        readonly property color textColor: "#121111"
        readonly property color borderColor: "#D8D8D8"
        readonly property color cardColor: "#FFFFFF"
        readonly property color caption: "#898989"
        readonly property color primary: "#2E7D32"
        readonly property color secondary: "#1976D2"
    }
    
    QtObject {
        id: dark
        readonly property color background: "#121212"
        readonly property color textColor: "#FEFEFE"
        readonly property color borderColor: "#3E3E3E"
        readonly property color cardColor: "#212121"
        readonly property color caption: "#898989"
        readonly property color primary: "#4CAF50"
        readonly property color secondary: "#42A5F5"
    }

    Gradient {
        id: primaryGradient
        GradientStop { position: 0.0; color: "#2CDE85" }
        GradientStop { position: 0.5; color: "#24b46d" }
        GradientStop { position: 0.9; color: "#1a8a52" }
    }

    Gradient {
        id: secondaryGradient
        GradientStop { position: 0.0; color: "#42A5F5" }
        GradientStop { position: 0.5; color: "#1976D2" }
        GradientStop { position: 0.9; color: "#0d47a1" }
    }

    Gradient {
        id: loadingGradient
        GradientStop { position: 0.0; color: "#1E88E5" }
        GradientStop { position: 0.5; color: "#42A5F5" }
        GradientStop { position: 1.0; color: "#64B5F6" }
    }

    // Coffee-style border gradients for cards
    Gradient {
        id: invertedBlueBorder
        GradientStop { position: 0.0; color: currentTheme.cardColor }
        GradientStop { position: 1.0; color: "#42A5F5" }
    }
    
    Gradient {
        id: blueBorder
        GradientStop { position: 0.0; color: "#42A5F5" }
        GradientStop { position: 1.0; color: currentTheme.cardColor }
    }
    
    Gradient {
        id: blueHighlightBorder
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
            color: currentTheme.cardColor
        }
    }
    
    Gradient {
        id: invertedBlueHighlightBorder
        GradientStop {
            position: 0.0
            color: "#2196F3"
        }
        GradientStop {
            position: 0.33
            color: "#c742A5F5"
        }
        GradientStop {
            position: 0.66
            color: "#ab42A5F5"
        }
        GradientStop {
            position: 1.0
            color: currentTheme.cardColor
        }
    }

    property color green: "#4CAF50"
    property color blue: "#2196F3"
    property color shadow: "white"
    property color border: "#898989"
    property color grey: "#585858"
    property var currentTheme: dark
    property alias dark: dark
    property alias light: light
    property alias primaryGradient: primaryGradient
    property alias secondaryGradient: secondaryGradient
    property alias loadingGradient: loadingGradient
    property alias invertedBlueBorder: invertedBlueBorder
    property alias blueBorder: blueBorder
    property alias blueHighlightBorder: blueHighlightBorder
    property alias invertedBlueHighlightBorder: invertedBlueHighlightBorder
}
