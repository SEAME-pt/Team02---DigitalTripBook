import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Page {
    id: statisticsScreen
    property var stats: {}
    
    background: Rectangle {
        color: Colors.currentTheme.background
    }
    
    Component.onCompleted: {
        stats = influxClient.getStatistics()
    }
    
    ScrollView {
        anchors.fill: parent
        anchors.margins: 20
        
        Column {
            width: parent.width
            spacing: 25
            
            // Header
            Text {
                text: "📊 Digital TripBook Statistics"
                font.pixelSize: 28
                font.weight: Font.Bold
                color: Colors.currentTheme.primary
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Rectangle {
                width: parent.width
                height: 2
                gradient: Colors.primaryGradient
                radius: 1
            }
            
            // Trip Overview Section
            Column {
                width: parent.width
                spacing: 15
                
                Text {
                    text: "🚗 Trip Overview"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                    color: Colors.currentTheme.secondary
                }
                
                GridLayout {
                    width: parent.width
                    columns: 1
                    columnSpacing: 15
                    rowSpacing: 10
                    
                    // Total Trips
                    Rectangle {
                        Layout.fillWidth: true
                        height: 80
                        color: Colors.currentTheme.cardColor
                        border.color: Colors.currentTheme.borderColor
                        border.width: 1
                        radius: 8
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 5
                            
                            Text {
                                text: (statisticsScreen.stats.totalTrips || 0).toString()
                                font.pixelSize: 24
                                font.weight: Font.Bold
                                color: Colors.currentTheme.primary
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text {
                                text: "Total Trips"
                                font.pixelSize: 12
                                color: Colors.currentTheme.caption
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }
            
            // Distance & Speed Section
            Column {
                width: parent.width
                spacing: 15
                
                Text {
                    text: "🏁 Distance & Speed"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                    color: Colors.currentTheme.secondary
                }
                
                GridLayout {
                    width: parent.width
                    columns: 2
                    columnSpacing: 15
                    rowSpacing: 10
                    
                    // Total Distance
                    Rectangle {
                        Layout.fillWidth: true
                        height: 80
                        color: Colors.currentTheme.cardColor
                        border.color: Colors.currentTheme.borderColor
                        border.width: 1
                        radius: 8
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 5
                            
                            Text {
                                text: (statisticsScreen.stats.totalDistance || 0).toFixed(2) + " km"
                                font.pixelSize: 20
                                font.weight: Font.Bold
                                color: "#FF5722"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text {
                                text: "Total Distance"
                                font.pixelSize: 12
                                color: Colors.currentTheme.caption
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                    
                    // Average Speed
                    Rectangle {
                        Layout.fillWidth: true
                        height: 80
                        color: Colors.currentTheme.cardColor
                        border.color: Colors.currentTheme.borderColor
                        border.width: 1
                        radius: 8
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 5
                            
                            Text {
                                text: (statisticsScreen.stats.averageSpeed || 0).toFixed(1) + " km/h"
                                font.pixelSize: 20
                                font.weight: Font.Bold
                                color: "#2196F3"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text {
                                text: "Avg Speed"
                                font.pixelSize: 12
                                color: Colors.currentTheme.caption
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                    
                    // Max Speed
                    Rectangle {
                        Layout.fillWidth: true
                        height: 80
                        color: Colors.currentTheme.cardColor
                        border.color: Colors.currentTheme.borderColor
                        border.width: 1
                        radius: 8
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 5
                            
                            Text {
                                text: (statisticsScreen.stats.maxSpeed || 0).toFixed(1) + " km/h"
                                font.pixelSize: 20
                                font.weight: Font.Bold
                                color: "#FF9800"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text {
                                text: "Max Speed"
                                font.pixelSize: 12
                                color: Colors.currentTheme.caption
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }
            
            // Battery & Energy Section
            Column {
                width: parent.width
                spacing: 15
                
                Text {
                    text: "🔋 Battery & Energy"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                    color: Colors.currentTheme.secondary
                }
                
                GridLayout {
                    width: parent.width
                    columns: 2
                    columnSpacing: 15
                    rowSpacing: 10
                    
                    // Average Battery Level
                    Rectangle {
                        Layout.fillWidth: true
                        height: 80
                        color: Colors.currentTheme.cardColor
                        border.color: Colors.currentTheme.borderColor
                        border.width: 1
                        radius: 8
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 5
                            
                            Text {
                                text: (statisticsScreen.stats.averageCharge || 0).toFixed(1) + "%"
                                font.pixelSize: 20
                                font.weight: Font.Bold
                                color: Colors.green
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text {
                                text: "Avg Battery"
                                font.pixelSize: 12
                                color: Colors.currentTheme.caption
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                    
                    // Total Energy Used
                    Rectangle {
                        Layout.fillWidth: true
                        height: 80
                        color: Colors.currentTheme.cardColor
                        border.color: Colors.currentTheme.borderColor
                        border.width: 1
                        radius: 8
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 5
                            
                            Text {
                                text: (statisticsScreen.stats.totalEnergyUsed || 0).toFixed(1) + " Wh"
                                font.pixelSize: 18
                                font.weight: Font.Bold
                                color: "#E91E63"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text {
                                text: "Energy Used"
                                font.pixelSize: 12
                                color: Colors.currentTheme.caption
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                    
                    // Battery Range
                    Rectangle {
                        Layout.fillWidth: true
                        height: 80
                        color: Colors.currentTheme.cardColor
                        border.color: Colors.currentTheme.borderColor
                        border.width: 1
                        radius: 8
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 5
                            
                            Text {
                                text: (statisticsScreen.stats.minCharge || 0).toFixed(1) + "% - " + (statisticsScreen.stats.maxCharge || 0).toFixed(1) + "%"
                                font.pixelSize: 16
                                font.weight: Font.Bold
                                color: "#009688"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text {
                                text: "Battery Range"
                                font.pixelSize: 12
                                color: Colors.currentTheme.caption
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                    
                    // Energy Efficiency
                    Rectangle {
                        Layout.fillWidth: true
                        height: 80
                        color: Colors.currentTheme.cardColor
                        border.color: Colors.currentTheme.borderColor
                        border.width: 1
                        radius: 8
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 5
                            
                            Text {
                                text: (statisticsScreen.stats.averageEfficiency || 0).toFixed(1) + " Wh/km"
                                font.pixelSize: 16
                                font.weight: Font.Bold
                                color: "#795548"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text {
                                text: "Efficiency"
                                font.pixelSize: 12
                                color: Colors.currentTheme.caption
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }
            
            // Interesting Insights Section
            Column {
                width: parent.width
                spacing: 15
                
                Text {
                    text: "💡 Insights"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                    color: Colors.currentTheme.secondary
                }
                
                Rectangle {
                    width: parent.width
                    height: 180  // Fixed height to avoid binding loop
                    color: Colors.currentTheme.cardColor
                    border.color: Colors.currentTheme.borderColor
                    border.width: 1
                    radius: 8
                    
                    Column {
                        id: insightsColumn
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: 15
                        spacing: 12
                        
                        Text {
                            width: parent.width
                            text: "🚀 You've traveled " + (statisticsScreen.stats.totalDistance || 0).toFixed(2) + " km with your vehicle!"
                            font.pixelSize: 14
                            color: Colors.currentTheme.textColor
                            wrapMode: Text.WordWrap
                        }
                        
                        Text {
                            width: parent.width
                            text: "⚡ Your energy efficiency is " + (statisticsScreen.stats.averageEfficiency || 0).toFixed(1) + " Wh/km"
                            font.pixelSize: 14
                            color: Colors.currentTheme.textColor
                            wrapMode: Text.WordWrap
                        }
                        
                        Text {
                            width: parent.width
                            text: "🔋 Battery levels ranged from " + (statisticsScreen.stats.minCharge || 0).toFixed(1) + "% to " + (statisticsScreen.stats.maxCharge || 0).toFixed(1) + "%"
                            font.pixelSize: 14
                            color: Colors.currentTheme.textColor
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }
        }
    }
}
