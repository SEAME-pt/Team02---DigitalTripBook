# 🌍 Digital TripBook – Qt Quick Vehicle Trip Logger

A cross-platform vehicle trip logging and analytics app built with Qt Quick (QML + C++) and InfluxDB.

---

## 🚀 Overview

**Digital TripBook** is a smart, responsive application for tracking, analyzing, and visualizing vehicle trip data. It integrates real-time InfluxDB telemetry, local storage via SQLite, and a modular UI built with Qt Quick.

---

## 🧱 Architecture

- **Framework:** Qt 6 (QML + C++)
- **Backend:** Custom InfluxDB client for data collection
- **Storage:** Local SQLite DB for persistence
- **Design:** Modular, reusable components with centralized theming

---

## 🎨 UI Features

- **Navigation:** StackView + state-based routing with animated transitions
- **Themes:** Light/Dark support with centralized color and gradient system
- **Responsiveness:** Mobile-ready layout for various screen sizes
- **Custom Components:** Toolbars, buttons, and loaders

---

## 📱 Screen Overview

### 1. Home Screen
- Entry point with cards for:
  - Trip Booking
  - Explore
  - My Trips
  - Statistics

### 2. Trip Booking *(Planned)*
- Select destinations
- Set travel dates
- Plan accommodations and activities

### 3. Explore *(Planned)*
- Browse destinations, photos, reviews, and travel tips

### 4. My Trips
- Live display of trips from InfluxDB
- List view with empty state fallback
- Navigate to trip details

### 5. Trip Statistics
- Visual analytics:
  - Total trips, distance, avg/max speed
  - Battery stats, energy consumption
- Real-time updates from SQLite

### 6. Trip Details
- Full breakdown:
  - Speed, distance, duration
  - Battery levels, efficiency
- Scrollable UI + back navigation

---

## 🚗 Vehicle Data Integration

- **Live Telemetry:**
  - Speed, battery %, autonomy levels
- **Trip Detection:**
  - Starts after 60s movement
  - Ends after 60s stationary
  - 5-minute timeout failsafe
- **Data Handling:**
  - Interpolation, distance, and energy computation
  - 10-day historical data retrieval
- **Security:** SSL/TLS Android-compatible connections

---

## 💾 Data Management

- **SQLite Schema:**
  - Metadata, timing, performance, battery stats
- **Calculations:**
  - Real-time statistics + energy efficiency
- **Battery Setup:**
  - 6×3200 mAh (19,200 mAh total), 12V system
  - Watt-hour and Wh/km tracking

---

## 🛠 Technical Highlights

- **Network:**
  - Async requests, duplicate filtering, Android TLS fix.
  - The android build should be using android packages to access the influxDB cloud direct HTTP request in the cpp code do not work. JNI - seems to be one other the ways to get this to work.
- **Performance:**
  - Background threads, memory buffering, 400ms animations

---

## 🎯 Current Status

| Feature                  | Status              |
|--------------------------|---------------------|
| Trip Tracking            | ✅ Implemented      |
| Data Visualization       | ✅ Implemented      |
| Navigation Framework     | ✅ Implemented      |
| Trip Booking             | 🔜 Planned          |
| Explore Destinations     | 🔜 Planned          |
| Custom Media Integration | 🔜 Planned          |

---

## 🔧 Build & Compatibility

- **CMake-based:** Modern CMake project
- **Targets:** macOS, Android, iOS
- **Assets:** Organized with QML modules and icon resources

