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
> ``
> assets/readme/loginMahasiswa.png

assets/readme/loginDosenAsisten.png

assets/readme/dashboard.png

assets/readme/schedule.png

assets/readme/about.png

assets/readme/jadwal.png

``

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

# ⚙️ Android Build Configuration

Selain pengembangan fitur utama menggunakan Flutter, proyek ini juga melakukan konfigurasi pada sisi **Native Android** agar aplikasi siap dijalankan pada **Production (Release Mode)**.

Konfigurasi utama dilakukan pada dua file berikut.

```
android/app/
│
├── build.gradle.kts
└── proguard-rules.pro
```

---

# 🏗 build.gradle.kts

> **Analogi:** 👷 Mandor Pabrik Perakitan

File ini merupakan pusat konfigurasi Android.

Tugas utamanya adalah mengatur bagaimana aplikasi Flutter dibangun menjadi file APK atau AAB yang siap dipasang pada perangkat Android.

---

## ✨ Fungsi

- 📦 Mengatur Package Name (`applicationId`)
- 📱 Menentukan Minimum Android Version (`minSdk`)
- 🚀 Mengatur Target Android Version (`targetSdk`)
- 🔢 Mengatur Version Code & Version Name
- 🏗 Mengatur Build Mode (Debug & Release)
- 🔐 Mengaktifkan Optimasi Release

---

## 🔄 Build Mode

Flutter memiliki dua mode utama.

### 🟢 Debug Mode

Digunakan saat proses pengembangan.

Karakteristik:

- Cepat dijalankan
- Mudah melakukan debugging
- Tidak dilakukan optimasi
- Tidak dilakukan penyandian kode

---

### 🔴 Release Mode

Digunakan ketika aplikasi akan didistribusikan kepada pengguna.

Karakteristik:

- Lebih cepat
- Lebih ringan
- Lebih aman
- Sudah dioptimasi Android

Pada mode ini Android akan menjalankan proses:

- Code Shrinking
- Code Optimization
- Code Obfuscation

---

## 📌 Konfigurasi yang Digunakan

Pada proyek ini kami mengaktifkan optimasi Release.

```kotlin
isMinifyEnabled = true
```

Artinya Android akan mengaktifkan mesin optimasi **R8**.

---

# 🔒 R8 / ProGuard

> **Analogi:** 🤖 Mesin Penyusun & Penyandi Otomatis

Ketika aplikasi dibangun pada mode Release, Android menjalankan **R8 Compiler**.

R8 memiliki tiga tugas utama.

---

## 📉 Code Shrinking

Menghapus kode yang dianggap tidak digunakan.

Tujuannya

- APK lebih kecil
- Lebih ringan
- Lebih cepat

---

## 🧹 Code Optimization

Mengoptimalkan struktur kode agar performa aplikasi meningkat.

---

## 🔐 Code Obfuscation

Mengubah nama Class, Method, dan Variable menjadi bentuk yang sulit dipahami.

Contoh

Sebelum

```dart
ScheduleProvider
```

Sesudah

```
a
```

atau

```
b
```

Hal ini bertujuan meningkatkan keamanan aplikasi dari proses Reverse Engineering.

---

# ⚠ Permasalahan

Optimasi R8 terkadang terlalu agresif.

Library Flutter yang sebenarnya digunakan melalui **Platform Channel** dapat dianggap sebagai kode yang tidak dipakai.

Akibatnya:

❌ SQLite tidak dapat dibaca

❌ Audio tidak dapat diputar

❌ Export PDF gagal

❌ Plugin Flutter mengalami crash

❌ Aplikasi Force Close saat dibuka

---

# 🛡 proguard-rules.pro

> **Analogi:** 📜 Daftar VIP

File ini berisi aturan khusus agar R8 tidak menghapus komponen penting.

---

## ✨ Fungsi

Memberitahu Android:

> "Komponen berikut merupakan bagian penting aplikasi dan tidak boleh dihapus."

Contohnya

```proguard
-keep
```

Perintah ini berarti

✅ Jangan hapus

✅ Jangan ubah nama

✅ Jangan optimasi secara berlebihan

---

## Contoh Package yang Dipertahankan

Pada proyek ini beberapa package harus tetap dipertahankan, misalnya

- Flutter Engine
- SQLite (sqflite)
- AudioPlayers
- Printing
- PDF Generator

Hal ini memastikan seluruh fitur tetap berjalan pada Release Mode.

---

# 🔕

Selain itu digunakan juga aturan

```proguard
-dontwarn
```

Perintah ini berarti

> Abaikan peringatan tertentu yang tidak memengaruhi jalannya aplikasi.

Contohnya

Google Play Core Library.

Tanpa aturan ini proses Build dapat berhenti karena Warning yang sebenarnya tidak berpengaruh terhadap aplikasi.

---

# 🔄 Build Process

```text
Flutter Project
       │
       ▼
build.gradle.kts
       │
       ▼
Android Build System
       │
       ▼
R8 Compiler
       │
       ├─────────────┐
       │             │
       ▼             ▼
Code Shrinking   Code Obfuscation
       │             │
       └──────┬──────┘
              ▼
Read proguard-rules.pro
              │
              ▼
Keep Important Classes
              │
              ▼
Generate Release APK / AAB
```

---

# 🎯 Why This Configuration?

Konfigurasi ini dilakukan agar aplikasi:

✅ Lebih ringan

✅ Lebih aman

✅ Lebih kecil ukuran APK

✅ Siap dipublikasikan

✅ Tidak mengalami crash pada Release Mode

✅ Mendukung proses distribusi ke pengguna

---

# 💡 Interview / Presentation Notes

### ❓ Mengapa perlu memodifikasi `build.gradle.kts`?

Karena aplikasi tidak hanya dijalankan pada mode **Debug**, tetapi juga dipersiapkan untuk **Release Mode**. Pada tahap ini Android melakukan proses optimasi menggunakan **R8 Compiler**, sehingga diperlukan konfigurasi tambahan agar proses build berjalan dengan benar.

---

### ❓ Mengapa membuat `proguard-rules.pro`?

Karena beberapa plugin Flutter seperti **SQLite**, **AudioPlayers**, dan **Printing** menggunakan mekanisme **Platform Channel** yang dapat dianggap sebagai kode tidak terpakai oleh R8.

Melalui file ini kami memberikan aturan kepada Android agar class penting tetap dipertahankan selama proses optimasi.

---

### ❓ Apa manfaat konfigurasi ini?

- APK lebih kecil
- Performa lebih baik
- Kode lebih aman
- Mengurangi risiko crash pada Release Mode
- Aplikasi siap digunakan pada lingkungan Production

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
