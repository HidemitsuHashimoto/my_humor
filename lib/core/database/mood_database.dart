import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const String _tableMoodEntries = 'mood_entries';
const String _columnId = 'id';
const String _columnMoodLevel = 'mood_level';
const String _columnObservation = 'observation';
const String _columnDate = 'date';

/// Local SQLite database for mood entries (B01).
class MoodDatabase {
  MoodDatabase._();
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, 'my_humor.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableMoodEntries (
        $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_columnMoodLevel INTEGER NOT NULL,
        $_columnObservation TEXT NOT NULL,
        $_columnDate TEXT NOT NULL UNIQUE
      )
    ''');
  }

  static String get tableMoodEntries => _tableMoodEntries;
  static String get columnId => _columnId;
  static String get columnMoodLevel => _columnMoodLevel;
  static String get columnObservation => _columnObservation;
  static String get columnDate => _columnDate;
}
