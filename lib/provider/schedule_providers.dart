import 'package:flutter/material.dart';
import '../models/jadwal_model.dart';
import '../models/active_class_model.dart';
import '../repositories/schedule_repository.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleRepository _repository = ScheduleRepository();

  // --- Tambahkan kode ini di dalam ScheduleProvider ---

  // Mendapatkan daftar ruangan secara dinamis dari jadwal
  List<String> get ruangLab =>
      _jadwalList
          .where((j) => j.ruang.startsWith('L'))
          .map((e) => e.ruang)
          .toSet()
          .toList()
        ..sort();
  List<String> get ruangKelas =>
      _jadwalList
          .where((j) => !j.ruang.startsWith('L'))
          .map((e) => e.ruang)
          .toSet()
          .toList()
        ..sort();

  // Memindahkan fungsi getRoomStatus dari helpers.dart ke sini
  ActiveClass? getRoomStatus(String ruang) {
    final now = DateTime.now();
    if (manualStartOverrides.containsKey(ruang)) {
      final active = manualStartOverrides[ruang]!;
      if (now.isBefore(active.endTime)) return active;
      manualStartOverrides.remove(ruang);
    }
    if (forceStopOverrides.containsKey(ruang)) {
      if (now.isBefore(forceStopOverrides[ruang]!)) return null;
      forceStopOverrides.remove(ruang);
    }

    // Cari jadwal otomatis
    const hari = [
      "SENIN",
      "SELASA",
      "RABU",
      "KAMIS",
      "JUMAT",
      "SABTU",
      "MINGGU",
    ];
    final today = hari[now.weekday - 1];

    for (var j in _jadwalList) {
      if (j.hari == today && j.ruang == ruang) {
        try {
          final tStart = j.jam.split("-")[0].split(":");
          final tEnd = j.jam.split("-")[1].split(":");
          final start = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(tStart[0]),
            int.parse(tStart[1]),
          );
          final end = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(tEnd[0]),
            int.parse(tEnd[1]),
          );

          if (now.isAfter(start) && now.isBefore(end)) {
            return ActiveClass(j.matkul, end, j.jam, j.kelas, j.dosen);
          }
        } catch (_) {
          continue;
        }
      }
    }
    return null;
  }

  Color getStatusColor(ActiveClass? active) {
    if (active == null) return Colors.black;
    final diff = active.endTime.difference(DateTime.now()).inMinutes;
    if (diff <= 15 && diff > 0) return Colors.orangeAccent;
    return Colors.green;
  }

  // Data Jadwal Utama
  List<Jadwal> _jadwalList = [];
  List<Jadwal> get jadwalList => _jadwalList;

  // Pengganti Variabel Global
  Map<String, ActiveClass> manualStartOverrides = {};
  Map<String, DateTime> forceStopOverrides = {};

  ScheduleProvider() {
    _loadJadwal();
  }

  // Meminta data ke Repository
  void _loadJadwal() {
    _jadwalList = List<Jadwal>.from(
      _repository.getJadwalBawaan(),
    ); // Di sini nantinya kamu bisa panggil fungsi dari repository untuk meload data SQLite
    notifyListeners(); // Menyuruh UI update
  }

  // Fungsi untuk Admin mengeset kelas manual
  void setManualOverride(String ruang, ActiveClass activeClass) {
    manualStartOverrides[ruang] = activeClass;
    forceStopOverrides.remove(ruang);

    // Simpan juga ke SQLite lewat Repository biar permanen
    _repository.simpanOverrideLokal(
      ruang,
      activeClass.matkul,
      activeClass.dosen,
      activeClass.kelas,
      activeClass.endTime.toIso8601String(),
    );

    notifyListeners(); // Langsung ubah warna ruangan di Dashboard!
  }

  // Fungsi untuk Admin mengosongkan ruangan
  void forceStopRoom(String ruang) {
    forceStopOverrides[ruang] = DateTime.now().add(const Duration(hours: 2));
    manualStartOverrides.remove(ruang);

    // Hapus dari SQLite lewat Repository
    _repository.hapusOverrideLokal(ruang);

    notifyListeners(); // Langsung ubah warna ruangan di Dashboard!
  }

  // Fungsi untuk membersihkan kelas yang sudah kadaluarsa waktunya
  void checkExpiredOverrides() {
    final now = DateTime.now();
    bool hasChanged = false;

    manualStartOverrides.removeWhere((key, value) {
      if (now.isAfter(value.endTime)) {
        hasChanged = true;
        _repository.hapusOverrideLokal(key); // Hapus dari database juga
        return true;
      }
      return false;
    });

    if (hasChanged) {
      notifyListeners();
    }
  }
}
