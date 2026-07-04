import 'package:flutter/material.dart';
import '../models/active_class_model.dart'; // <-- Ini yang kelupaan tadi

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);
bool isMahasiswaRole = true;

Map<String, ActiveClass> manualStartOverrides = {};
Map<String, DateTime> forceStopOverrides = {};
Set<String> notifiedRooms = {};
