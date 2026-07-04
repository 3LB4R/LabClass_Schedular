// lib/data/jadwal_data.dart
import '../models/jadwal_model.dart';

/* ================= DATA & PARSER ================= */
List<Jadwal> parseSchedule(String raw) {
  List<Jadwal> result = [];
  String currentHari = "SENIN";

  for (var line in raw.trim().split('\n')) {
    var cols = line.split('\t').map((e) => e.trim()).toList();
    if (cols.length < 8) continue;

    if (cols[0].isNotEmpty) currentHari = cols[0].toUpperCase();
    String normalizedJam = cols[1].replaceAll('.', ':').replaceAll(' ', '');

    result.add(
      Jadwal(
        hari: currentHari,
        jam: normalizedJam,
        ruang: cols[2],
        matkul: cols[3]
            .replaceAll(RegExp(r'^\d+\.\s*'), '')
            .replaceAll('*', ''),
        sks: int.tryParse(cols[4]) ?? 0,
        kelas: cols[5],
        semester: int.tryParse(cols[6]) ?? 0,
        dosen: cols[7],
      ),
    );
  }
  return result;
}

// 1. DATA TSV ASLI MILIKMU (JANGAN DIUBAH, INI SUMBER UTAMANYA)
const String rawDataTSV = '''
SENIN	08:00 - 10:30	L406	Analisis dan Sains Data	3	B	6	Dr.Ridwan Andi Kambau, ST., M.Kom
	08:00 - 10:30	E201	Matematika Diskrit	3	A	2	Dr. Ir. A. Muhammad Syafar, ST., MT
	08:00 - 10:30	E202	Jaringan Komputer	3	E	4	Andi Muhammad Nur Hidayat, S.Kom., MT
	08:00 - 10:30	E101	Cyber Security	3	A	6	Dr. Eng. Antamil, S.T.,M.T
	08:00 - 10:30	E204	Pemrograman Perangkat Bergerak	3	A	4	Ahmad Muyassar, S.Kom.,M.Cs
	08:00 - 10:30	L401	Basis Data Non Relasional	3	D	6	Nur Afif, ST., MT.
	08:00 - 10:30	C101	Matematika Diskrit	3	B	2	Nur Aeni, S.Si., M.Pd
	08:00 - 09:40	L404	Prak. Sistem Operasi Komputer	1	C	2	Asisten Lab
	08:00 - 09:40	L405	Prak. Dasar Pemrograman	1	D	2	Asisten Lab
	10:35 - 13:05	E102	Interaksi Manusia dan Komputer	2	A	4	Dr. Faisal, ST., MT
	10:35 - 13:05	E201	Basis Data Non Relasional	3	B	6	Sri Wahyuni, S.Kom., MT
	10:35 - 13:05	E202	Jaringan Komputer	3	D	4	Andi Muhammad Nur Hidayat, S.Kom., MT
	10:35 - 13:05	E306	Technopreneurship	2	B	2	Ahmad Anshari, S.Kom.,M.Kom
	10:35 - 13:05	E204	Manajemen Jaringan	3	D	6	Dr. Eng. Antamil, S.T.,M.T
	10:35 - 13:05	C101	Matematika Diskrit	3	C	2	Nur Aeni, S.Si., M.Pd 
	10:35 - 12:15	L404	Prak. Sistem Operasi Komputer	1	A	2	Asisten Lab
	10:35 - 12:15	L405	Prak. Dasar Pemrograman	1	E	2	Asisten Lab
	10:35 - 12:15	L406	Prak. Jaringan Komputer	1	A	4	Asisten Lab
	13:30 - 15:10	E102	Dasar Pemrograman	3	B	2	M.Hasrul.H., S.Kom., M.Kom
	13:30 - 15:10	E201	Dasar Pemrograman	3	D	2	Sri Wahyuni, S.Kom., MT
	13:30 - 15:10	E202	Teknologi AI & Big Data	2	A	2	Darmatasia, S.Pd., M.Kom
	13:30 - 15:10	L406	Generative AI	3	A	6	Dr.Ridwan Andi Kambau, ST., M.Kom
	13:30 - 15:10	L401	Basis Data Non Relasional	3	C	6	Nur Afif, ST., MT.
	13:30 - 15:10	E306	Pemrograman Perangkat Bergerak	3	E	4	Ahmad Muyassar, S.Kom.,M.Cs
	13:30 - 15:10	C101	Statistika dan Probabilitas	3	B	4	Sri Dewi Anugrawari, S.Pd., M.Sc
	13:30 - 15:10	L404	Prak. Sistem Operasi Komputer	1	E	2	Asisten Lab
	13:30 - 15:10	L405	Prak. Dasar Pemrograman	1	C	2	Asisten Lab
	15:20 - 17:00	E102	Teknologi AI & Big Data	2	D	2	Darmatasia, S.Pd., M.Kom
	15:20 - 17:00	E202	Manajemen Jaringan	3	A	6	Dr. Eng. Antamil, S.T.,M.T
	15:20 - 17:00	E306	Metodologi Penelitian Sains & teknologi	2	D	4	Faisal.Kom., M.Kom
	15:20 - 17:50	C101	Teknologi Internet of Things	3	B	6	Asep Indra Syahyadi, S.Kom., M.Kom.
	15:20 - 17:00	L404	Prak. Jaringan Komputer	1	B	4	Asisten Lab
	15:20 - 17:00	L405	Prak. Manajemen Jaringan	1	C	6	Asisten Lab
	15:20 - 17:00	L406	Prak. Sistem Multimedia	1	D	6	Asisten Lab
SELASA	08:00 - 09:40	E102	Sejarah Peradaban Islam	2	A	2	Dr. Rahmat., M.Pd.I
	08:00 - 10:30	L406	Rekayasa Perangkat Lunak	3	A	4	Dr.Ridwan Andi Kambau, ST., M.Kom
	08:00 - 10:30	E201	Sistem Pendukung Keputusan	3	A	6	Faisal.Kom., M.Kom
	08:00 - 10:30	E202	Matematika Diskrit	3	D	2	Dr. Ir. A. Muhammad Syafar, ST., MT
	08:00 - 10:30	E306	Jaringan Komputer	3	C	4	Andi Muhammad Nur Hidayat, S.Kom., MT
	08:00 - 10:30	E204	Interaksi Manusia dan Komputer	2	E	4	Dr. Faisal, ST., MT
	08:00 - 10:30	L404	Teknologi Internet of Things	3	C	6	Hariani, S.Kom., M.Kom 
	08:00 - 10:30	C101	Statistika dan Probabilitas	3	F	4	Sri Dewi Anugrawari, S.Pd., M.Sc
	08:00 - 09:40	L404	Prak. Sistem Operasi Komputer	1	B	2	Asisten Lab
	08:00 - 09:40	L405	Prak. Pemrograman Web 2	1	B	4	Asisten Lab
	10:35 - 12:15	E102	Sejarah Peradaban Islam	2	C	2	Dr. Rahmat., M.Pd.I
	10:35 - 13:05	E201	Metodologi Penelitian Sains & teknologi	2	A	4	Faisal.Kom., M.Kom
	10:35 - 13:05	E202	Interaksi Manusia dan Komputer	2	D	4	Ahmad Anshari, S.Kom.,M.Kom
	10:35 - 13:05	E306	Manajemen Jaringan	3	B	6	Andi Muhammad Nur Hidayat, S.Kom., MT
	10:35 - 13:05	E204	Statistika dan Probabilitas	3	D	6	Dr. Eng. Antamil, S.T.,M.T
	10:35 - 13:05	L406	Analisis dan Sains Data	3	A	6	Dr.Ridwan Andi Kambau, ST., M.Kom
	10:35 - 13:05	C101	Statistika dan Probabilitas	3	C	4	Sri Dewi Anugrawari, S.Pd., M.Sc
	10:35 - 12:15	L404	Prak. Jaringan Komputer	1	E	4	Asisten Lab
	11:35 - 13:15	L403	Prak. Dasar Pemrograman	1	A	2	Asisten Lab
	13:30 - 15:10	E102	Pemrograman Web 2	3	D	4	M.Asrarul Ikram, S.Kom.M.T
	13:30 - 15:10	E201	Sistem Multimedia	3	C	6	M.Hasrul.H., S.Kom., M.Kom
	13:30 - 15:10	E202	Teknologi AI & Big Data	2	B	2	Darmatasia, S.Pd., M.Kom
	13:30 - 15:10	E306	Technopreneurship	2	A	2	Ahmad Anshari, S.Kom.,M.Kom
	13:30 - 15:10	E204	Basis Data Non Relasional	3	A	6	Sri Wahyuni, S.Kom., MT
	13:30 - 15:10	C101	Teknologi Internet of Things	3	D	6	Hariani, S.Kom., M.Kom 
	13:30 - 15:10	L404	Prak. Sistem Operasi Komputer	1	D	2	Asisten Lab
	13:30 - 15:10	L405	Prak. Pemrograman Web 2	1	A	4	Asisten Lab
	13:30 - 15:10	L406	Prak. Pemrograman Perangkat Bergerak	1	A	4	Asisten Lab
	15:20 - 17:00	E102	Metodologi Penelitian Sains & teknologi	2	E	4	Faisal.Kom., M.Kom
	15:20 - 17:50	E201	Sistem Pendukung Keputusan	3	B	6	Sri Wahyuni, S.Kom., MT
	15:20 - 17:50	E202	Teknologi AI & Big Data	2	C	2	Darmatasia, S.Pd., M.Kom
	15:20 - 17:00	E306	Pemrograman Web 2	3	A	4	M.Asrarul Ikram, S.Kom.M.T
	15:20 - 17:50	C101	Teknologi Internet of Things	3	A	6	Asep Indra Syahyadi, S.Kom., M.Kom.
	15:20 - 17:00	L404	Prak. Pemrograman Perangkat Bergerak	1	D	4	Asisten Lab
	15:20 - 17:00	L403	Prak. Dasar Pemrograman	1	B	2	Asisten Lab
	15:20 - 17:00	L406	Prak. Pemrograman Web 2	1	C	4	Asisten Lab
RABU	08:00 - 09:40	E102	Dasar Pemrograman	3	E	2	Sri Wahyuni, S.Kom., MT
	08:00 - 09:40	E201	Sejarah Peradaban Islam	2	B	2	Dr. Riswandi, S. Hum., M. Hum
	08:00 - 09:40	E202	Forensik Digital Komputer	3	A	6	Hariani, S.Kom., M.Kom 
	08:00 - 09:40	E306	Metodologi Penelitian Sains & teknologi	2	C	4	Ahmad Anshari, S.Kom.,M.Kom
	08:00 - 09:40	C101	Sistem Operasi Komputer	3	A	2	Dr. Faisal, ST., MT
	08:00 - 09:40	L404	Prak. Manajemen Jaringan	1	B	6	Asisten Lab
	08:00 - 09:40	L405	Prak. Basis Data Non Relasional	1	C	6	Asisten Lab
	08:00 - 09:40	L406	Prak. Pemrograman Web 2	1	E	4	Asisten Lab
	09:45 - 12:15	E102	Metodologi Penelitian Sains & teknologi	2	B	4	M.Hasrul.H., S.Kom., M.Kom
	09:45 - 12:15	E201	Sejarah Peradaban Islam	2	D	2	Dr. Riswandi, S. Hum., M. Hum
	09:45 - 12:15	E202	Teknologi AI & Big Data	2	F	2	Darmatasia, S.Pd., M.Kom
	09:45 - 12:15	E306	Technopreneurship	2	C	2	Ahmad Anshari, S.Kom.,M.Kom
	09:45 - 12:15	C101	Jaringan Komputer	3	A	4	Andi Muhammad Nur Hidayat, S.Kom., MT
	09:45 - 12:15	C104	Sistem Operasi Komputer	3	B	2	Dr. Faisal, ST., MT
	09:45 - 11:25	L404	Prak. Jaringan Komputer	1	C	4	Asisten Lab
	09:45 - 11:25	L405	Prak. Sistem Multimedia	1	C	6	Asisten Lab
	09:45 - 11:25	L406	Prak. Cyber Security	1	B	6	Asisten Lab
	12:40 - 15:10	E102	Dasar Pemrograman	3	C	2	Sri Wahyuni, S.Kom., MT
	12:40 - 15:10	L306	Rekayasa Perangkat Lunak	3	B	4	Dr.Ridwan Andi Kambau, ST., M.Kom
	12:40 - 15:10	E202	Teknologi AI & Big Data	2	E	2	Darmatasia, S.Pd., M.Kom
	12:40 - 15:10	E201	Teori Bahasa dan Automata	3	E	4	Dr. Ir. A. Muhammad Syafar, ST., MT
	12:40 - 15:10	L404	Teori Bahasa dan Automata	3	C	4	Mustikasari, S.Kom., M.Kom. 
	12:40 - 15:10	C101	Autonomous System Network	3	A	6	Andi Muhammad Nur Hidayat, S.Kom., MT
	12:40 - 14:20	L405	Prak. Pemrograman Web 2	1	D	4	Asisten Lab
	12:40 - 14:20	L406	Prak. Cyber Security	1	C	6	Asisten Lab
	15:20 - 17:50	E102	Deep Learning	3	B	6	Darmatasia, S.Pd., M.Kom
	15:20 - 17:00	E201	Dasar Pemrograman	3	A	2	M.Hasrul.H., S.Kom., M.Kom
	15:20 - 17:50	E202	Rekayasa Perangkat Lunak	3	C	4	Dr.Ridwan Andi Kambau, ST., M.Kom
	15:20 - 17:00	C101	Pemrograman Perangkat Bergerak	3	D	4	Asep Indra Syahyadi, S.Kom., M.Kom.
	15:20 - 17:50	L404	Teori Bahasa dan Automata	3	B	4	Mustikasari, S.Kom., M.Kom. 
	15:20 - 17:50	E306	Matematika Diskrit	3	E	2	Dr. Ir. A. Muhammad Syafar, ST., MT
	15:20 - 17:00	L405	Prak. Cyber Security	1	A	6	Asisten Lab
	15:20 - 17:00	L406	Prak. Pemrograman Perangkat Bergerak	1	E	4	Asisten Lab
KAMIS	08:00 - 09:40	E102	Sistem Multimedia	3	D	6	M.Hasrul.H., S.Kom., M.Kom
	08:00 - 09:40	E201	Ilmu Hadis	2	D	2	Rofia Masrifa, M.Pd.I
	08:00 - 09:40	E202	Ilmu Fikih	2	C	2	Dr. Besse Ruhaya, S.Pd.I., M.Pd.I
	08:00 - 09:40	E306	Cyber Security	3	B	6	Dr. Eng. Antamil, S.T.,M.T
	08:00 - 09:40	E204	Teknologi AI & Big Data	2	G	2	Darmatasia, S.Pd., M.Kom
	08:00 - 09:40	C101	Statistika dan Probabilitas	3	A	4	Dr. Muhammad Ridwan, S.Si, M.Si
	08:00 - 09:40	L404	Prak. Statistika dan Probabilitas	1	B	4	Asisten Lab
	08:00 - 09:40	L405	Prak. Basis Data Non Relasional	1	A	6	Asisten Lab
	08:00 - 09:40	L406	Prak. Pemrograman Perangkat Bergerak	1	C	6	Asisten Lab
	09:45 - 12:15	E102	Sistem Multimedia	3	B	6	M.Hasrul.H., S.Kom., M.Kom
	09:45 - 12:15	E201	Ilmu Hadis	2	B	2	Rofia Masrifa, M.Pd.I
	09:45 - 12:15	E202	Technopreneurship	2	E	2	Faisal.Kom., M.Kom
	09:45 - 12:15	E306	Cyber Security	3	C	6	Dr. Eng. Antamil, S.T.,M.T
	09:45 - 12:15	E204	Teknologi AI & Big Data	2	H	2	Darmatasia, S.Pd., M.Kom
	09:45 - 12:15	C101	Statistika dan Probabilitas	3	E	4	Dr. Muhammad Ridwan, S.Si, M.Si
	09:45 - 11:25	L404	Prak. Jaringan Komputer	1	D	4	Asisten Lab
	09:45 - 11:25	L405	Prak. Basis Data Non Relasional	1	D	6	Asisten Lab
	09:45 - 11:25	L406	Prak. Forensik Digital Komputer	1	A	6	Asisten Lab
	12:40 - 15:10	L404	Rekayasa Perangkat Lunak	3	E	4	Dr.Ridwan Andi Kambau, ST., M.Kom
	12:40 - 15:10	E102	Pemrograman Perangkat Bergerak	3	B	4	Ahmad Muyassar, S.Kom.,M.Cs
	12:40 - 15:10	E201	Ilmu Hadis	2	C	2	Rofia Masrifa, M.Pd.I
	12:40 - 15:10	E202	Ilmu Fikih	2	A	2	Dr. Besse Ruhaya, S.Pd.I., M.Pd.I
	12:40 - 15:10	L401	Pemrograman Web 2	3	C	4	Nur Afif, ST., MT.
	12:40 - 15:10	C102	Teori Bahasa dan Automata	3	D	4	Dr. Ir. A. Muhammad Syafar, ST., MT
	12:40 - 15:10	E306	Deep Learning	3	A	6	Darmatasia, S.Pd., M.Kom
	12:40 - 15:10	E204	Pengolahan Citra Digital	3	A	6	Rahman, S.Kom. MT
	12:40 - 15:10	C101	Sistem Operasi Komputer	3	E	2	Dr. Faisal, ST., MT
	12:45 - 14:25	L403	Prak. Manajemen Jaringan	1	D	6	Asisten Lab
	12:45 - 14:25	L406	Prak. Statistika dan Probabilitas	1	A	4	Asisten Lab
	15:20 - 17:00	E102	Technopreneurship	2	D	2	Faisal.Kom., M.Kom
	15:20 - 17:00	E201	Manajemen Jaringan	3	C	6	Andi Muhammad Nur Hidayat, S.Kom., MT
	15:20 - 17:50	C102	Teori Bahasa dan Automata	3	A	4	Dr. Ir. A. Muhammad Syafar, ST., MT
	15:20 - 17:50	E306	Pemrograman Perangkat Bergerak	3	C	4	Ahmad Muyassar, S.Kom.,M.Cs
	15:20 - 17:50	L404	Rekayasa Perangkat Lunak	3	D	4	Dr.Ridwan Andi Kambau, ST., M.Kom
	15:20 - 17:00	L401	Pemrograman Web 2	3	E	4	Nur Afif, ST., MT.
	15:20 - 17:00	C101	Interaksi Manusia dan Komputer	2	B	4	Dr. Faisal, ST., MT
	15:20 - 17:00	L403	Prak. Manajemen Jaringan	1	A	6	Asisten Lab
	15:20 - 17:00	L406	Prak. Statistika dan Probabilitas	1	F	4	Asisten Lab
JUMAT	08:00 - 09:40	E102	Ilmu Fikih	2	B	2	Prof. Dr. Sohra
	08:00 - 09:40	E202	Sejarah Peradaban Islam	2	E	2	Dr. Besse Ruhaya, S.Pd.I., M.Pd.I
	08:00 - 09:40	E201	Sistem Operasi Komputer	3	D	2	Dr. Faisal, ST., MT
	08:00 - 09:40	E306	Jaringan Komputer	3	B	4	Muniardi, S.Kom.,M.Kom
	08:00 - 09:40	L404	Prak. Statistika dan Probabilitas	1	E	4	Asisten Lab
	08:00 - 09:40	L405	Prak. Sistem Multimedia	1	A	6	Asisten Lab
	08:00 - 09:40	L406	Prak. Basis Data Non Relasional	1	B	6	Asisten Lab
	09:45 - 11:25	E102	Ilmu Fikih	2	D	2	Prof. Dr. Sohra
	09:45 - 11:25	E202	Ilmu Hadis	2	A	2	Rofia Masrifa, M.Pd.I
	09:45 - 11:25	E201	Sistem Operasi Komputer	3	C	2	Dr. Faisal, ST., MT
	09:45 - 11:25	E306	Ilmu Fikih	2	E	2	Dr. Besse Ruhaya, S.Pd.I., M.Pd.I
	09:45 - 11:25	E204	Sistem Multimedia	3	A	6	M.Hasrul.H., S.Kom., M.Kom
	09:45 - 11:25	L405	Prak. Statistika dan Probabilitas	1	C	4	Asisten Lab
	09:45 - 11:25	L406	Prak. Pemrograman Perangkat Bergerak	1	B	4	Asisten Lab
	13:20 - 15:00	E102	Pemrograman Web 2	3	B	4	Ahmad Muyassar, S.Kom.,M.Cs
	13:20 - 15:00	E201	Ilmu Hadis	2	E	2	Rofia Masrifa, M.Pd.I
	13:20 - 15:00	E202	Interaksi Manusia dan Komputer	2	C	4	Ahmad Anshari, S.Kom.,M.Kom
	13:20 - 15:00	L403	Prak. Generative AI	1	A	6	Asisten Lab
	13:20 - 15:00	L405	Prak. Statistika dan Probabilitas	1	D	4	Asisten Lab
	13:20 - 15:00	L406	Prak. Sistem Multimedia	1	B	6	Asisten Lab''';

// 2. DATA NAMA ASISTEN LAB (DARI GAMBAR YANG SAYA BUATKAN)
final List<Jadwal> dataJadwalPraktikum = [
  // SEMESTER 2
  Jadwal(
    matkul: "Praktikum Dasar Pemrograman",
    kelas: "A",
    semester: 2,
    hari: "Selasa",
    jam: "11:35 - 13:15",
    ruang: "L403",
    dosen: "Ayu Aziza Feriana.Hn & St. Zilfiana Wardani",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Dasar Pemrograman",
    kelas: "B",
    semester: 2,
    hari: "Selasa",
    jam: "15:20 - 17:00",
    ruang: "L403",
    dosen: "Ayu Aziza Feriana.Hn & St. Zilfiana Wardani",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Dasar Pemrograman",
    kelas: "C",
    semester: 2,
    hari: "Senin",
    jam: "13:30 - 15:10",
    ruang: "L405",
    dosen: "Sitti Munawarah & St. Zilfiana Wardani",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Dasar Pemrograman",
    kelas: "D",
    semester: 2,
    hari: "Senin",
    jam: "08:00 - 09:40",
    ruang: "L405",
    dosen: "Sitti Munawarah & St. Zilfiana Wardani",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Dasar Pemrograman",
    kelas: "E",
    semester: 2,
    hari: "Senin",
    jam: "10:35 - 12:15",
    ruang: "L406",
    dosen: "Sitti Munawarah & Ayu Aziza Feriana.Hn",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Sistem Operasi Komputer",
    kelas: "A",
    semester: 2,
    hari: "Senin",
    jam: "10:35 - 12:15",
    ruang: "L404",
    dosen: "Akidatul Izza & Ahmad Rifai Qadri",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Sistem Operasi Komputer",
    kelas: "B",
    semester: 2,
    hari: "Selasa",
    jam: "08:00 - 09:40",
    ruang: "L404",
    dosen: "Akidatul Izza & Fathur Rizqi S Djafar",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Sistem Operasi Komputer",
    kelas: "C",
    semester: 2,
    hari: "Senin",
    jam: "08:00 - 09:40",
    ruang: "L404",
    dosen: "Akidatul Izza & Muh. Ichsan Pratama Putra",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Sistem Operasi Komputer",
    kelas: "D",
    semester: 2,
    hari: "Selasa",
    jam: "13:30 - 15:10",
    ruang: "L404",
    dosen: "Akidatul Izza & Muh. Ichsan Pratama Putra",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Sistem Operasi Komputer",
    kelas: "E",
    semester: 2,
    hari: "Senin",
    jam: "13:30 - 15:10",
    ruang: "L404",
    dosen: "Akidatul Izza & Fathur Rizqi S Djafar",
    sks: 1,
  ),

  // SEMESTER 4
  Jadwal(
    matkul: "Praktikum Statistika dan Probabilitas",
    kelas: "A",
    semester: 4,
    hari: "Kamis",
    jam: "12:40 - 15:10",
    ruang: "L406",
    dosen: "Ayu Aziza Feriana.Hn & A.Eka Reski Wahyunengsi",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Statistika dan Probabilitas",
    kelas: "B",
    semester: 4,
    hari: "Kamis",
    jam: "08:00 - 09:40",
    ruang: "L404",
    dosen: "Ayu Aziza Feriana.Hn & A.Eka Reski Wahyunengsi",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Statistika dan Probabilitas",
    kelas: "C",
    semester: 4,
    hari: "Jumat",
    jam: "09:45 - 11:25",
    ruang: "L405",
    dosen: "Andi Khalil Gibran Tri Anugrah. AR & Muhammad Fadel Hamka",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Statistika dan Probabilitas",
    kelas: "D",
    semester: 4,
    hari: "Jumat",
    jam: "13:20 - 15:00",
    ruang: "L405",
    dosen: "Andi Khalil Gibran Tri Anugrah. AR & Muhammad Fadel Hamka",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Statistika dan Probabilitas",
    kelas: "E",
    semester: 4,
    hari: "Jumat",
    jam: "08:00 - 09:40",
    ruang: "L404",
    dosen: "Andi Khalil Gibran Tri Anugrah. AR & Muhammad Fadel Hamka",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Statistika dan Probabilitas",
    kelas: "F",
    semester: 4,
    hari: "Kamis",
    jam: "15:20 - 17:00",
    ruang: "L406",
    dosen: "Ayu Aziza Feriana.Hn & A.Eka Reski Wahyunengsi",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Pemrograman Web 2",
    kelas: "A",
    semester: 4,
    hari: "Selasa",
    jam: "13:30 - 15:10",
    ruang: "L405",
    dosen: "Muammar & Ahmad Syahid",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Pemrograman Web 2",
    kelas: "B",
    semester: 4,
    hari: "Selasa",
    jam: "08:00 - 09:40",
    ruang: "L405",
    dosen: "Muammar & Ahmad Syahid",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Pemrograman Web 2",
    kelas: "C",
    semester: 4,
    hari: "Selasa",
    jam: "15:20 - 17:00",
    ruang: "L406",
    dosen: "Muammar & Ahmad Syahid",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Pemrograman Web 2",
    kelas: "D",
    semester: 4,
    hari: "Rabu",
    jam: "12:40 - 15:10",
    ruang: "L405",
    dosen: "Dian Pertiwi & Muh Anwar Syafriaawan",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Pemrograman Web 2",
    kelas: "E",
    semester: 4,
    hari: "Rabu",
    jam: "08:00 - 09:40",
    ruang: "L406",
    dosen: "Dian Pertiwi & Muh Anwar Syafriaawan",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Jaringan Komputer",
    kelas: "A",
    semester: 4,
    hari: "Senin",
    jam: "10:35 - 12:15",
    ruang: "L406",
    dosen: "Reski Amalia Uswat & Ahmad Rifai Qadri",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Jaringan Komputer",
    kelas: "B",
    semester: 4,
    hari: "Senin",
    jam: "15:20 - 17:00",
    ruang: "L404",
    dosen: "Reski Amalia Uswat & Ahmad Rifai Qadri",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Jaringan Komputer",
    kelas: "C",
    semester: 4,
    hari: "Rabu",
    jam: "09:45 - 11:25",
    ruang: "L404",
    dosen: "Reski Amalia Uswat & Ahmad Rifai Qadri",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Jaringan Komputer",
    kelas: "D",
    semester: 4,
    hari: "Kamis",
    jam: "09:45 - 11:25",
    ruang: "L404",
    dosen: "Reski Amalia Uswat & Ahmad Rifai Qadri",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Jaringan Komputer",
    kelas: "E",
    semester: 4,
    hari: "Selasa",
    jam: "10:35 - 12:15",
    ruang: "L404",
    dosen: "Reski Amalia Uswat & Ahmad Rifai Qadri",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Pemrograman Perangkat Bergerak",
    kelas: "A",
    semester: 4,
    hari: "Selasa",
    jam: "13:30 - 15:10",
    ruang: "L406",
    dosen: "A. Nasywa Atja & Muhammad Shamil Izzah",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Pemrograman Perangkat Bergerak",
    kelas: "B",
    semester: 4,
    hari: "Jumat",
    jam: "09:45 - 11:25",
    ruang: "L406",
    dosen: "A. Nasywa Atja & Muhammad Shamil Izzah",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Pemrograman Perangkat Bergerak",
    kelas: "C",
    semester: 4,
    hari: "Kamis",
    jam: "08:00 - 09:40",
    ruang: "L406",
    dosen: "A. Nasywa Atja & Muhammad Shamil Izzah",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Pemrograman Perangkat Bergerak",
    kelas: "D",
    semester: 4,
    hari: "Selasa",
    jam: "15:20 - 17:00",
    ruang: "L404",
    dosen: "A. Nasywa Atja & Muhammad Shamil Izzah",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Pemrograman Perangkat Bergerak",
    kelas: "E",
    semester: 4,
    hari: "Rabu",
    jam: "15:20 - 17:00",
    ruang: "L406",
    dosen: "A. Nasywa Atja & Muhammad Shamil Izzah",
    sks: 1,
  ),

  // SEMESTER 6
  Jadwal(
    matkul: "Praktikum Manajemen Jaringan",
    kelas: "A",
    semester: 6,
    hari: "Kamis",
    jam: "15:20 - 17:00",
    ruang: "L403",
    dosen: "Restu Andikha & Fathur Rizqi S Djafar",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Manajemen Jaringan",
    kelas: "B",
    semester: 6,
    hari: "Rabu",
    jam: "08:00 - 09:40",
    ruang: "L404",
    dosen: "Restu Andikha & Fathur Rizqi S Djafar",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Manajemen Jaringan",
    kelas: "C",
    semester: 6,
    hari: "Senin",
    jam: "15:20 - 17:00",
    ruang: "L405",
    dosen: "Restu Andikha & Fathur Rizqi S Djafar",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Manajemen Jaringan",
    kelas: "D",
    semester: 6,
    hari: "Kamis",
    jam: "12:40 - 14:20",
    ruang: "L403",
    dosen: "Restu Andikha & Fathur Rizqi S Djafar",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Sistem Multimedia",
    kelas: "A",
    semester: 6,
    hari: "Jumat",
    jam: "08:00 - 09:40",
    ruang: "L405",
    dosen: "Mulktasam & Lili Rahmianti",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Sistem Multimedia",
    kelas: "B",
    semester: 6,
    hari: "Jumat",
    jam: "13:20 - 15:00",
    ruang: "L406",
    dosen: "Mulktasam & Lili Rahmianti",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Sistem Multimedia",
    kelas: "C",
    semester: 6,
    hari: "Rabu",
    jam: "09:45 - 12:15",
    ruang: "L405",
    dosen: "Thariq Putra Aulia Rahmadana & Aditya Dwi Nugroho",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Sistem Multimedia",
    kelas: "D",
    semester: 6,
    hari: "Senin",
    jam: "15:20 - 17:00",
    ruang: "L406",
    dosen: "Thariq Putra Aulia Rahmadana & Aditya Dwi Nugroho",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Basis Data Non Relasional",
    kelas: "A",
    semester: 6,
    hari: "Kamis",
    jam: "08:00 - 09:40",
    ruang: "L405",
    dosen: "Muhammad Alif Hardhy Anugrah & Muh Anwar Syafriaawan",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Basis Data Non Relasional",
    kelas: "B",
    semester: 6,
    hari: "Jumat",
    jam: "08:00 - 09:40",
    ruang: "L406",
    dosen: "Muhammad Alif Hardhy Anugrah & Muh Anwar Syafriaawan",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Basis Data Non Relasional",
    kelas: "C",
    semester: 6,
    hari: "Rabu",
    jam: "08:00 - 09:40",
    ruang: "L405",
    dosen: "Muhammad Alif Hardhy Anugrah & Muh Anwar Syafriaawan",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Basis Data Non Relasional",
    kelas: "D",
    semester: 6,
    hari: "Kamis",
    jam: "09:45 - 12:15",
    ruang: "L405",
    dosen: "Muhammad Alif Hardhy Anugrah & Ahmad Syahid",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Forensik Digital Komputer",
    kelas: "A",
    semester: 6,
    hari: "Kamis",
    jam: "09:45 - 11:25",
    ruang: "L406",
    dosen: "Ayu Aziza Feriana.Hn & Fathur Rizqi S Djafar",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Cyber Security",
    kelas: "A",
    semester: 6,
    hari: "Rabu",
    jam: "15:20 - 17:00",
    ruang: "L405",
    dosen: "Muh. Syahrial Rahmat J & Restu Andhika",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Cyber Security",
    kelas: "B",
    semester: 6,
    hari: "Rabu",
    jam: "09:45 - 11:25",
    ruang: "L406",
    dosen: "Muh. Syahrial Rahmat J & Restu Andhika",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Cyber Security",
    kelas: "C",
    semester: 6,
    hari: "Rabu",
    jam: "12:40 - 14:20",
    ruang: "L406",
    dosen: "Muh. Syahrial Rahmat J & Muh. Ichsan Pratama Putra",
    sks: 1,
  ),
  Jadwal(
    matkul: "Praktikum Generative AI",
    kelas: "A",
    semester: 6,
    hari: "Jumat",
    jam: "13:20 - 15:00",
    ruang: "L403",
    dosen: "Ade Nurchalisa & Muhammad Fadel Hamka",
    sks: 1,
  ),
];

// 3. FUNGSI AJAIB PENGGABUNG DATA (INJECTION) YANG SUDAH DI-UPGRADE
List<Jadwal> _gabungkanJadwal() {
  List<Jadwal> base = parseSchedule(rawDataTSV);

  // Fungsi pembersih string: hapus semua spasi, titik, huruf besar, dan kata "prak"/"praktikum"
  String cleanString(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '') // Buang semua spasi dan simbol
        .replaceAll('praktikum', '')
        .replaceAll('prak', '');
  }

  for (int i = 0; i < base.length; i++) {
    // Cari kelas yang nama dosennya masih kosongan / "Asisten Lab"
    if (base[i].dosen.toLowerCase().contains("asisten lab")) {
      String cleanBaseMatkul = cleanString(base[i].matkul);
      String cleanBaseKelas = cleanString(base[i].kelas);

      try {
        // Cocokkan data dengan mode super ketat (tanpa peduli spasi/huruf besar)
        var match = dataJadwalPraktikum.firstWhere(
          (p) =>
              cleanString(p.matkul) == cleanBaseMatkul &&
              cleanString(p.kelas) == cleanBaseKelas,
        );

        // Timpa data asistennya
        base[i] = Jadwal(
          hari: base[i].hari,
          jam: base[i].jam,
          ruang: base[i].ruang,
          matkul: base[i].matkul, // Tetap gunakan nama asli dari TSV ("Prak.")
          sks: base[i].sks,
          kelas: base[i].kelas,
          semester: base[i].semester,
          dosen: match.dosen, // <-- INI DIA! Nama 2 Asisten asli pasti masuk
        );
      } catch (e) {
        // Jika karena suatu hal aneh tidak ketemu, biarkan "Asisten Lab"
        continue;
      }
    }
  }
  return base;
}

// 4. HASIL AKHIR YANG AKAN DIPAKAI APLIKASI
final List<Jadwal> jadwalList = _gabungkanJadwal();

final List<String> ruangLab =
    jadwalList
        .where((j) => j.ruang.startsWith('L'))
        .map((e) => e.ruang)
        .toSet()
        .toList()
      ..sort();

final List<String> ruangKelas =
    jadwalList
        .where((j) => !j.ruang.startsWith('L'))
        .map((e) => e.ruang)
        .toSet()
        .toList()
      ..sort();
