import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../core/helpers.dart';
import '../models/jadwal_model.dart';
import '../provider/schedule_providers.dart';
import '../widgets/animated_press_card.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  String filterTipe = 'Semua';
  int? filterSemester;
  String? filterKelas;

  final List<String> filterOptions = ['Semua', 'Ruang Kelas', 'Laboratorium'];

  // Cek apakah user sudah mengunci filter semester dan kelas (Proteksi UX)
  bool get _isFilterValid => filterSemester != null && filterKelas != null;

  // --- HELPER UNTUK PDF ---
  pw.Widget _buildHeader(String text) {
    return pw.Container(
      // PADDING DIKURANGI: Agar header tidak terlalu memakan tempat vertikal
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontWeight: pw.FontWeight.bold,
          fontSize: 10,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildCell(
    String text, {
    pw.Alignment align = pw.Alignment.center,
  }) {
    return pw.Container(
      // PADDING DIKURANGI: Agar muat lebih banyak baris di satu halaman
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      alignment: align,
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
    );
  }

  // Kumpulan warna pastel Aesthetic & Modern (Material Design 100 series)
  final List<PdfColor> _pastelColors = [
    PdfColor.fromHex('#E3F2FD'), // Blue 100 (Biru Langit Segar)
    PdfColor.fromHex('#FCE4EC'), // Pink 100 (Merah Muda Lembut)
    PdfColor.fromHex('#E8F5E9'), // Green 100 (Hijau Mint Terang)
    PdfColor.fromHex('#FFF3E0'), // Orange 100 (Peach / Oranye Lembut)
    PdfColor.fromHex('#F3E5F5'), // Purple 100 (Lavender Mewah)
    PdfColor.fromHex('#E0F7FA'), // Cyan 100 (Cyan / Tosca Terang)
    PdfColor.fromHex('#FFF9C4'), // Yellow 100 (Kuning Pastel)
    PdfColor.fromHex('#EFEBE9'), // Deep Orange 50 (Beige / Cokelat Sangat Muda)
  ];

  // Fungsi Cetak PDF Format Matriks (Sesuai Gambar 1)
  Future<void> _downloadJadwalPdf(List<Jadwal> jadwalList) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape, // Wajib landscape
        // MARGIN DIKETATKAN: Dari 32 menjadi 20 agar baris terakhir tidak lompat halaman
        margin: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 32),
        build: (pw.Context context) {
          return [
            // KOP SURAT / HEADER DOKUMEN
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'JADWAL KELAS & LABORATORIUM',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'UIN ALAUDDIN MAKASSAR - TEKNIK INFORMATIKA',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            pw.Text(
              'Filter Aktif: Semester $filterSemester | Kelas $filterKelas | Tipe Ruang: $filterTipe',
              style: pw.TextStyle(
                fontSize: 11,
                color: PdfColors.grey700,
                fontStyle: pw.FontStyle.italic,
              ),
            ),
            pw.SizedBox(height: 12), // Jarak ke tabel dirapatkan sedikit
            // TABEL MATRIKS JADWAL
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
              columnWidths: {
                0: const pw.FixedColumnWidth(25), // No
                1: const pw.FixedColumnWidth(30), // Kelas (Dikecilkan)
                2: const pw.FlexColumnWidth(3), // Mata Kuliah & Dosen
                3: const pw.FixedColumnWidth(25), // SKS (Dikecilkan)
                4: const pw.FixedColumnWidth(35), // Ruang (Dikecilkan)
                5: const pw.FlexColumnWidth(1.2), // Senin
                6: const pw.FlexColumnWidth(1.2), // Selasa
                7: const pw.FlexColumnWidth(1.2), // Rabu
                8: const pw.FlexColumnWidth(1.2), // Kamis
                9: const pw.FlexColumnWidth(1.2), // Jumat
              },
              children: [
                // 1. BARIS HEADER TABEL
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.green800),
                  children: [
                    _buildHeader('No.'),
                    _buildHeader('Kls'),
                    _buildHeader('Mata Kuliah & Pengajar'),
                    _buildHeader('SKS'),
                    _buildHeader('Ruang'),
                    _buildHeader('Senin'),
                    _buildHeader('Selasa'),
                    _buildHeader('Rabu'),
                    _buildHeader('Kamis'),
                    _buildHeader('Jumat'),
                  ],
                ),
                // 2. BARIS DATA JADWAL (Dilakukan looping)
                ...jadwalList.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final j = entry.value;

                  // Menentukan warna baris berdasarkan nama Matkul agar seragam
                  final colorIndex =
                      j.matkul.hashCode.abs() % _pastelColors.length;
                  final rowColor = _pastelColors[colorIndex];

                  final hari = j.hari.toUpperCase();

                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: rowColor,
                    ), // Warna pembeda Matkul
                    children: [
                      _buildCell('${idx + 1}'),
                      _buildCell(j.kelas),
                      // Kolom Gabungan Matkul & Dosen
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 6,
                        ),
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              j.matkul,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                            pw.SizedBox(height: 1), // Jarak dirapatkan
                            pw.Text(
                              j.dosen,
                              style: pw.TextStyle(
                                fontSize: 8,
                                color: PdfColors.grey800,
                                fontStyle: pw.FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildCell(j.sks.toString()), // SKS
                      _buildCell(j.ruang), // Ruang
                      // Logika Penempatan Jam berdasarkan Hari
                      _buildCell(hari == 'SENIN' ? j.jam : ''),
                      _buildCell(hari == 'SELASA' ? j.jam : ''),
                      _buildCell(hari == 'RABU' ? j.jam : ''),
                      _buildCell(hari == 'KAMIS' ? j.jam : ''),
                      _buildCell(hari == 'JUMAT' ? j.jam : ''),
                    ],
                  );
                }),
              ],
            ),
          ];
        },
      ),
    );

    // Buka tampilan Preview PDF sebelum di-download/print
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Jadwal_Smt${filterSemester}_Kls$filterKelas.pdf',
    );
  }

  void _showJadwalDetail(Jadwal j) {
    showDialog(
      context: context,
      builder: (context) {
        bool isActiveNow = false;

        if (j.hari == getHariSekarang()) {
          try {
            final start = parseJam(j.jam, true);
            final end = parseJam(j.jam, false);
            final now = DateTime.now();
            if (now.isAfter(start) && now.isBefore(end)) {
              isActiveNow = true;
            }
          } catch (_) {}
        }

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("Detail Jadwal ${j.ruang}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isActiveNow)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.play_circle_fill,
                        color: Colors.redAccent,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "Sedang Berlangsung",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              const Text(
                "Mata Kuliah / Kegiatan:",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                j.matkul,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Dosen / Asisten:",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(j.dosen, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              const Text(
                "Waktu & Kelas:",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                "${j.hari}, ${j.jam} (Kelas ${j.kelas})",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                "SKS & Semester:",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                "${j.sks} SKS | Semester ${j.semester}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();
    final jadwalData = provider.jadwalList;

    final listSemester = jadwalData.map((e) => e.semester).toSet().toList()
      ..sort();
    final listKelas = jadwalData.map((e) => e.kelas).toSet().toList()..sort();

    final filteredJadwal = jadwalData.where((j) {
      bool matchRuang =
          filterTipe == 'Semua' ||
          (filterTipe == 'Laboratorium' && j.ruang.startsWith('L')) ||
          (filterTipe == 'Ruang Kelas' && !j.ruang.startsWith('L'));
      bool matchSemester =
          filterSemester == null || j.semester == filterSemester;
      bool matchKelas = filterKelas == null || j.kelas == filterKelas;
      return matchRuang && matchSemester && matchKelas;
    }).toList();

    filteredJadwal.sort((a, b) {
      int dayDiff = urutanHari(a.hari).compareTo(urutanHari(b.hari));
      if (dayDiff != 0) return dayDiff;
      return a.jam.compareTo(b.jam);
    });

    return Scaffold(
      // --- FLOATING ACTION BUTTON (FAB) MELAYANG DI POJOK KANAN BAWAH ---
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isFilterValid
            ? () => _downloadJadwalPdf(filteredJadwal)
            : () {
                // Warning jika filter belum lengkap
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "⚠️ Gagal unduh! Pilih Semester & Kelas terlebih dahulu.",
                    ),
                    backgroundColor: Colors.orangeAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
        label: const Text(
          "Export PDF",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
        // Warna berubah abu-abu jika filter belum dipilih (Indikator UX Pro)
        backgroundColor: _isFilterValid ? Colors.redAccent : Colors.grey,
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800), // Rapi di Landscape
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 16),
                child: Text(
                  "Filter Pencarian Jadwal",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        initialValue: filterSemester,
                        decoration: const InputDecoration(
                          labelText: "Pilih Semester",
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text("Semua Smt"),
                          ),
                          ...listSemester.map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text("Smt $s"),
                            ),
                          ),
                        ],
                        onChanged: (val) =>
                            setState(() => filterSemester = val),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        initialValue: filterKelas,
                        decoration: const InputDecoration(
                          labelText: "Pilih Kelas",
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text("Semua Kelas"),
                          ),
                          ...listKelas.map(
                            (k) => DropdownMenuItem(
                              value: k,
                              child: Text("Kelas $k"),
                            ),
                          ),
                        ],
                        onChanged: (val) => setState(() => filterKelas = val),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: filterOptions.map((String type) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(type),
                        selected: filterTipe == type,
                        selectedColor: Colors.blueAccent.withValues(alpha: 0.3),
                        onSelected: (bool selected) =>
                            setState(() => filterTipe = type),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: filteredJadwal.isEmpty
                    ? const Center(child: Text("Jadwal tidak ditemukan."))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: filteredJadwal.length,
                        itemBuilder: (_, i) {
                          final j = filteredJadwal[i];
                          return AnimatedPressCard(
                            onTap: () => _showJadwalDetail(j),
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: j.ruang.startsWith('L')
                                      ? Colors.purple
                                      : Colors.blueAccent,
                                  child: Text(
                                    j.ruang,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  j.matkul,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      "Pengajar: ${j.dosen}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "${j.hari} | ${j.jam} | Smt ${j.semester} Kls ${j.kelas}",
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: const Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
