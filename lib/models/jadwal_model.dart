// lib/models/jadwal_model.dart
class Jadwal {
  final String hari;
  final String jam;
  final String ruang;
  final String matkul;
  final int sks;
  final String kelas;
  final int semester;
  final String dosen;

  Jadwal({
    required this.hari,
    required this.jam,
    required this.ruang,
    required this.matkul,
    required this.sks,
    required this.kelas,
    required this.semester,
    required this.dosen,
  });
}
