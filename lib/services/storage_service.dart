import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StorageService {
  static Database? _db;

  // Membuka atau membuat database
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('labclass_scheduler.db');
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Membuat tabel saat aplikasi pertama kali diinstal
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE room_overrides (
        ruang TEXT PRIMARY KEY,
        matkul TEXT,
        dosen TEXT,
        kelas TEXT,
        end_time TEXT
      )
    ''');
  }

  // --- CONTOH FUNGSI CRUD ---

  Future<void> insertOverride(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      'room_overrides',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getOverrides() async {
    final db = await database;
    return await db.query('room_overrides');
  }

  Future<void> deleteOverride(String ruang) async {
    final db = await database;
    await db.delete('room_overrides', where: 'ruang = ?', whereArgs: [ruang]);
  }
}
