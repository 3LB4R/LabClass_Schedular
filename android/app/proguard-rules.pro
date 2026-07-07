# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Package Khusus yang kita pakai
-keep class com.tekartik.sqflite.** { *; }
-keep class xyz.luan.audioplayers.** { *; }
-keep class net.nfet.flutter.printing.** { *; }

# Trik Sakti: Abaikan peringatan hilangnya fitur Google Play Core
-dontwarn com.google.android.play.core.**