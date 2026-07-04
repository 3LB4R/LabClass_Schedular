String getHariSekarang() {
  const hari = ["SENIN", "SELASA", "RABU", "KAMIS", "JUMAT", "SABTU", "MINGGU"];
  return hari[DateTime.now().weekday - 1];
}

DateTime parseJam(String jam, bool start) {
  final parts = jam.split("-");
  final timeStr = start ? parts[0] : parts[1];

  final t = timeStr.split(":");
  final h = int.parse(t[0]);
  final m = int.parse(t[1]);

  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, h, m);
}

int urutanHari(String hari) {
  switch (hari.toUpperCase()) {
    case 'SENIN':
      return 1;
    case 'SELASA':
      return 2;
    case 'RABU':
      return 3;
    case 'KAMIS':
      return 4;
    case 'JUMAT':
      return 5;
    default:
      return 6;
  }
}
