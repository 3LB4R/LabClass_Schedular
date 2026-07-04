<div align="center">

# 🧪 LabClass Scheduler

### Smart Monitoring System for Laboratory Class Management

<p align="center">

Flutter • Provider • SQLite • PDF • Real-Time Monitoring

</p>

<img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter">
<img src="https://img.shields.io/badge/Dart-3.x-blue?logo=dart">
<img src="https://img.shields.io/badge/Provider-State%20Management-success">
<img src="https://img.shields.io/badge/SQLite-Local%20Database-green">
<img src="https://img.shields.io/badge/PDF-Export-red">
<img src="https://img.shields.io/badge/License-Educational-orange">

---

**Final Project Mobile Programming**

Developed using Flutter with Clean Architecture, Role-Based Access Control,
Real-Time Monitoring, Local Database, Smart Notification,
and PDF Reporting.

</div>

---

# 📖 Overview

LabClass Scheduler merupakan aplikasi **Smart Monitoring System** yang dirancang untuk membantu proses monitoring laboratorium secara **real-time**.

Aplikasi ini mampu menampilkan status penggunaan laboratorium, melakukan monitoring kelas yang sedang berlangsung, memberikan notifikasi ketika kelas hampir selesai, mendukung **Manual Override** oleh dosen, serta menghasilkan laporan jadwal dalam bentuk **PDF**.

---

# ✨ Main Features

## 👨‍🎓 Student Mode

- 🔍 View laboratory status
- 📅 View class schedules
- ⏳ Countdown remaining class time
- 📄 Export schedules to PDF
- 👀 Read Only Access

---

## 👨‍🏫 Lecturer / Assistant Mode

- 🔐 Secure Login
- 🎛 Manual Override Room
- ➕ Create Temporary Class
- ⛔ Force End Class
- 💾 Store Override into SQLite
- 🔄 Real-Time Synchronization

---

# 🚀 Tech Stack

| Technology        | Description              |
| ----------------- | ------------------------ |
| 💙 Flutter        | Cross Platform Framework |
| 🎯 Dart           | Programming Language     |
| 🧠 Provider       | State Management         |
| 💾 SQLite         | Local Database           |
| 🔊 AudioPlayers   | Alarm Notification       |
| 🔔 Toastification | Floating Notification    |
| 📄 PDF & Printing | Export Schedule          |

---

# 🏗 Project Architecture

```
lib/
│
├── core/
├── data/
├── models/
├── pages/
├── provider/
├── repositories/
├── services/
├── widgets/
│
└── main.dart
```

---

# 📂 Folder Explanation

---

## 🎨 core/

Global configuration used throughout the application.

Contains

- Theme
- Global Variables
- Helper Functions
- Utility Functions

Example

```
globals.dart
helpers.dart
theme.dart
```

---

## 📚 data/

Contains static schedule data.

```
jadwal_data.dart
```

This file stores the original TSV schedule from the laboratory.

---

## 📦 models/

Contains all application models.

Example

```
JadwalModel
ActiveClassModel
```

Models ensure that every schedule object has a consistent structure.

---

## 📱 pages/

Contains every UI page.

Including

- Login
- Dashboard
- Schedule
- About

This layer only handles user interface.

---

## 🧠 provider/

Application State Management.

Responsible for

- Timer
- Room Status
- Notification
- UI Refresh

Provider automatically updates the interface whenever data changes.

---

## 📚 repositories/

Acts as a bridge between UI and data source.

Responsibilities

- Retrieve Schedule
- Update Data
- Manage Business Logic

---

## 💾 services/

Handles communication with local storage.

Example

```
storage_service.dart
```

Used to

- Save Override
- Read Override
- Delete Override

---

## 🧩 widgets/

Contains reusable UI components.

Examples

- Custom Button
- Custom Card
- Dialog
- Loading Widget

Reusable widgets make the project cleaner and easier to maintain.

---

# 👥 Role Based Access

---

## 👨‍🎓 Student

Permissions

✅ View Schedule

✅ View Laboratory Status

✅ View Countdown

✅ Export PDF

❌ Cannot Modify Data

---

## 👨‍🏫 Lecturer

Permissions

✅ Manual Override

✅ Force End Class

✅ Add Temporary Class

✅ Change Duration

✅ Save Changes into SQLite

---

# ⚙ System Workflow

```text
Application Started
        │
        ▼
Parse TSV Schedule
        │
        ▼
Normalize Data
        │
        ▼
Inject Assistant Data
        │
        ▼
Create Schedule Model
        │
        ▼
Provider Monitoring
        │
        ▼
Dashboard
        │
        ▼
Notification
        │
        ▼
PDF Export
```

---

# 🧠 System Logic

## 1️⃣ Parsing Schedule

The application reads the TSV schedule file during startup.

The parser converts every row into a structured object.

---

## 2️⃣ Data Injection

If the lecturer name is

```
Asisten Lab
```

The application automatically searches for the real assistant name.

Matching is performed using

- Course
- Class

with

**Brute Force Normalization**

Ignoring

- Uppercase
- Lowercase
- Extra Spaces

---

## 3️⃣ Real-Time Monitoring

The application uses

```dart
Timer.periodic()
```

Every **2 seconds**

Provider checks

Current Time

↓

Current Schedule

↓

Room Status

↓

Automatically Update Dashboard

---

## 4️⃣ Smart Notification

If remaining class time

≤ **15 Minutes**

System will

🔔 Play Alarm

📢 Show Floating Notification

🧠 Store Room ID into

```
notifiedRooms
```

to prevent duplicate notifications.

---

## 5️⃣ Manual Override

Only available for Lecturer.

Features

- Create Temporary Class
- Force End Class
- Change Duration

All changes are stored using SQLite.

---

## 6️⃣ PDF Export

Schedules are exported into

Landscape Matrix Table.

Each course receives a consistent pastel color using

```dart
hashCode.abs() % pastelColors.length
```

making schedules easier to read.

---

# 🔄 Application Flow

```text
User
 │
 ▼
Login
 │
 ▼
Role Verification
 │
 ▼
Dashboard
 │
 ▼
Provider
 │
 ▼
Repository
 │
 ▼
SQLite
 │
 ▼
Realtime Update
 │
 ▼
Notification
 │
 ▼
Export PDF
```

---

# 🎯 Design Pattern

This project follows several software engineering principles.

✅ Separation of Concerns

✅ Clean Architecture

✅ Repository Pattern

✅ Provider State Management

✅ Reusable Widgets

✅ Local Persistence

---

# 📸 Screenshots

> Add your screenshots here.

```
assets/readme/login.png

assets/readme/dashboard.png

assets/readme/schedule.png

assets/readme/pdf.png
```

---

# 📦 Dependencies

```yaml
provider:

sqflite:

path:

audioplayers:

toastification:

pdf:

printing:
```

---

# 🔮 Future Improvements

- 🌐 REST API Integration
- 🔥 Firebase Authentication
- ☁ Cloud Firestore
- 📱 Push Notification
- 📊 Analytics Dashboard
- 🌙 Dark Mode
- 📍 Laboratory GPS
- 📷 QR Attendance

---

# 👨‍💻 Authors

Final Project

**LabClass Scheduler - Smart Monitoring System**

Developed by

- 👨‍💻 Thorranov
- 👨‍💻 Team Members

Department of Informatics

Universitas Islam Negeri Alauddin Makassar

---

# ⭐ Project Highlights

✅ Flutter Cross Platform

✅ Provider State Management

✅ SQLite Local Database

✅ Role Based Access Control

✅ Manual Override System

✅ Smart Notification

✅ Real-Time Monitoring

✅ PDF Export

✅ Clean Architecture

✅ Responsive User Interface

---

<div align="center">

## ⭐ If you like this project, don't forget to give it a star!

Made with ❤️ using Flutter

</div>
