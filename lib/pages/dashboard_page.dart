import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:toastification/toastification.dart'; // <-- IMPORT PACKAGE DYNAMIC ISLAND

import '../core/globals.dart';
import '../models/active_class_model.dart';
import '../provider/schedule_providers.dart';
import '../widgets/animated_press_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        context.read<ScheduleProvider>().checkExpiredOverrides();
        _checkNotifications();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkNotifications() {
    final now = DateTime.now();
    final provider = context.read<ScheduleProvider>();

    for (var ruang in [...provider.ruangLab, ...provider.ruangKelas]) {
      final status = provider.getRoomStatus(ruang);
      if (status != null) {
        final diff = status.endTime.difference(now).inMinutes;
        if (diff <= 15 && diff > 0 && !notifiedRooms.contains(ruang)) {
          notifiedRooms.add(ruang);

          // Putar Suara
          _audioPlayer.setVolume(1.0);
          _audioPlayer.play(AssetSource('notif.mp3'));

          // --- KODE NOTIFIKASI DYNAMIC ISLAND PRO ---
          toastification.show(
            context: context,
            type: ToastificationType.warning,
            style: ToastificationStyle.flatColored,
            title: Text(
              'Peringatan Kelas!',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            description: Text(
              'Kelas di $ruang akan selesai dalam $diff menit.',
            ),
            alignment: Alignment.topCenter, // Muncul dari atas (Dynamic Island)
            autoCloseDuration: const Duration(seconds: 6),
            animationDuration: const Duration(milliseconds: 300),
            icon: const Icon(Icons.timer),
            showProgressBar: false, // Biar lebih minimalis
            margin: const EdgeInsets.only(
              top: 16,
            ), // Jarak sedikit dari bezel atas
          );
          // ------------------------------------------
        }
      } else {
        notifiedRooms.remove(ruang);
      }
    }
  }

  void _showRoomDetailDialog(String ruang, ActiveClass? currentStatus) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("Informasi Ruangan $ruang"),
          content: currentStatus == null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green, size: 60),
                    SizedBox(height: 16),
                    Text(
                      "Ruangan Kosong",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Ruangan ini bisa kamu gunakan sekarang.",
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                            Icons.lock_clock,
                            color: Colors.redAccent,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Sedang Terpakai",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Mata Kuliah / Kegiatan:",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      currentStatus.matkul,
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
                    Text(
                      currentStatus.dosen,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Kelas / Waktu:",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      "Kelas ${currentStatus.kelas} (${currentStatus.jamStr})",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Divider(height: 30),
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            "Sisa Waktu Kelas",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          StreamBuilder(
                            stream: Stream.periodic(const Duration(seconds: 1)),
                            builder: (context, snapshot) {
                              final diff = currentStatus.endTime.difference(
                                DateTime.now(),
                              );
                              if (diff.isNegative) {
                                return const Text(
                                  "KELAS SELESAI",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              final minutes = diff.inMinutes;
                              final seconds = diff.inSeconds % 60;
                              final color = minutes <= 15
                                  ? Colors.orange
                                  : Colors.blueAccent;
                              return Text(
                                "${minutes.toString().padLeft(2, '0')} Menit ${seconds.toString().padLeft(2, '0')} Detik",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
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

  void _showAdminControlDialog(String ruang, ActiveClass? currentStatus) {
    final provider = context.read<ScheduleProvider>();
    List<String> matkulDiRuanganIni =
        provider.jadwalList
            .where((j) => j.ruang == ruang)
            .map((e) => e.matkul)
            .toSet()
            .toList()
          ..sort();
    matkulDiRuanganIni.add("Kegiatan Tambahan (Manual)");
    String selectedMatkul = currentStatus?.matkul ?? matkulDiRuanganIni.first;
    if (!matkulDiRuanganIni.contains(selectedMatkul)) {
      matkulDiRuanganIni.insert(0, selectedMatkul);
    }
    final durasiCtrl = TextEditingController(text: "100");
    final dosenCtrl = TextEditingController(text: currentStatus?.dosen ?? "");
    final kelasCtrl = TextEditingController(text: currentStatus?.kelas ?? "");

    void updateAutoFill(String matkul) {
      if (matkul == "Kegiatan Tambahan (Manual)") {
        dosenCtrl.text = "Dosen / Asisten (Manual)";
        kelasCtrl.text = "-";
      } else {
        try {
          final match = provider.jadwalList.firstWhere(
            (j) => j.ruang == ruang && j.matkul == matkul,
          );
          dosenCtrl.text = match.dosen;
          kelasCtrl.text = match.kelas;
        } catch (e) {
          dosenCtrl.text = "Tidak Ditemukan";
          kelasCtrl.text = "-";
        }
      }
    }

    if (currentStatus == null) updateAutoFill(selectedMatkul);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Semantics(
                header: true,
                child: Text("Kontrol Ruangan $ruang"),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (currentStatus != null) ...[
                      const Text(
                        "Ruangan sedang terpakai.",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    const Text(
                      "Pilih Matkul / Kegiatan:",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: selectedMatkul,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: matkulDiRuanganIni
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e, overflow: TextOverflow.ellipsis),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setStateDialog(() {
                            selectedMatkul = val;
                            updateAutoFill(val);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: dosenCtrl,
                      decoration: const InputDecoration(
                        labelText: "Dosen / Asisten (Auto-fill)",
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: kelasCtrl,
                            decoration: const InputDecoration(
                              labelText: "Kelas (Auto)",
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: durasiCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Durasi (Menit)",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                if (currentStatus != null)
                  TextButton(
                    onPressed: () {
                      provider.forceStopRoom(ruang);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Kosongkan Paksa",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                TextButton(
                  onPressed: () {
                    final durasi = int.tryParse(durasiCtrl.text) ?? 100;
                    final now = DateTime.now();
                    String startTime =
                        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
                    final newClass = ActiveClass(
                      selectedMatkul,
                      DateTime.now().add(Duration(minutes: durasi)),
                      "$startTime - Override",
                      kelasCtrl.text.isEmpty ? "-" : kelasCtrl.text,
                      dosenCtrl.text.isEmpty
                          ? "Dosen / Asisten (Manual)"
                          : dosenCtrl.text,
                    );
                    provider.setManualOverride(ruang, newClass);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Terapkan Kelas",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSection(String title, List<String> ruanganList, IconData icon) {
    final provider = context.watch<ScheduleProvider>();
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800), // Rapi di Landscape
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Icon(icon, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Semantics(
                    header: true,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: ruanganList.length,
              itemBuilder: (_, i) {
                final ruang = ruanganList[i];
                final activeClass = provider.getRoomStatus(ruang);
                final color = provider.getStatusColor(activeClass);
                final bool isKosong = color == Colors.black;
                final String semanticLabel = isKosong
                    ? "Ruangan $ruang sedang kosong."
                    : "Ruangan $ruang sedang terpakai untuk ${activeClass!.matkul}. Ketuk untuk lihat detail waktu.";
                return Semantics(
                  label: semanticLabel,
                  button: true,
                  child: AnimatedPressCard(
                    onTap: () {
                      if (isMahasiswaRole) {
                        _showRoomDetailDialog(ruang, activeClass);
                      } else {
                        _showAdminControlDialog(ruang, activeClass);
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: isKosong
                            ? BorderSide(color: Colors.grey.shade700, width: 1)
                            : BorderSide.none,
                      ),
                      color: isKosong
                          ? (themeNotifier.value == ThemeMode.dark
                                ? Colors.black
                                : Colors.white)
                          : color.withValues(alpha: 0.85),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ruang,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isKosong ? Colors.grey : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              activeClass?.matkul ?? "KOSONG",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isKosong ? Colors.grey : Colors.white,
                              ),
                            ),
                            if (!isKosong) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "${activeClass!.jamStr} | Kls ${activeClass.kelas}",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            isMahasiswaRole
                ? "Ketuk ruangan untuk melihat detail dan timer kelas."
                : "Ketuk ruangan untuk mengubah status secara manual.",
            style: const TextStyle(color: Colors.grey, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ),
        _buildSection("Laboratorium", provider.ruangLab, Icons.computer),
        _buildSection("Ruang Kelas", provider.ruangKelas, Icons.meeting_room),
      ],
    );
  }
}
