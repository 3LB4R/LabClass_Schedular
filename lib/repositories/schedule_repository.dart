import '../models/jadwal_model.dart';
import '../data/jadwal_data.dart'; // Tempat data TSV kamu berada
import '../services/storage_service.dart';

class ScheduleRepository {
  final StorageService _storageService = StorageService();

  // 1. Ambil data jadwal statis dari file TSV
  List<Jadwal> getJadwalBawaan() {
    return jadwalList;
  }

  // 2. Ambil data ruangan yang di-override dari SQLite
  Future<List<Map<String, dynamic>>> getOverrideLokal() async {
    return await _storageService.getOverrides();
  }

  // 3. Simpan data ruangan manual ke SQLite
  Future<void> simpanOverrideLokal(
    String ruang,
    String matkul,
    String dosen,
    String kelas,
    String endTime,
  ) async {
    await _storageService.insertOverride({
      'ruang': ruang,
      'matkul': matkul,
      'dosen': dosen,
      'kelas': kelas,
      'end_time': endTime,
    });
  }

  // 4. Hapus data ruangan manual dari SQLite
  Future<void> hapusOverrideLokal(String ruang) async {
    await _storageService.deleteOverride(ruang);
  }
}
