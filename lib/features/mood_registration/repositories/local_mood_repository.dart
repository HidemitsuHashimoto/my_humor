import 'package:sqflite/sqflite.dart';

import '../../../core/database/mood_database.dart';
import '../entities/mood_entry.dart';
import '../entities/mood_level.dart';
import 'mood_repository.dart';

/// SQLite implementation of MoodRepository (B01).
class LocalMoodRepository implements MoodRepository {
  LocalMoodRepository(this._db);
  final Database _db;

  static String _dateKey(DateTime date) {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Future<void> save(MoodEntry entry) async {
    final dateKey = _dateKey(entry.date);
    await _db.insert(
      MoodDatabase.tableMoodEntries,
      {
        MoodDatabase.columnMoodLevel: entry.moodLevel.value,
        MoodDatabase.columnObservation: entry.observation,
        MoodDatabase.columnDate: dateKey,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<MoodEntry?> getEntryForDate(DateTime date) async {
    final dateKey = _dateKey(date);
    final rows = await _db.query(
      MoodDatabase.tableMoodEntries,
      where: '${MoodDatabase.columnDate} = ?',
      whereArgs: [dateKey],
    );
    if (rows.isEmpty) return null;
    return _rowToEntry(rows.first);
  }

  @override
  Future<List<MoodEntry>> getEntriesForMonth(int year, int month) async {
    final prefix = '$year-${month.toString().padLeft(2, '0')}-';
    final rows = await _db.query(
      MoodDatabase.tableMoodEntries,
      where: '${MoodDatabase.columnDate} LIKE ?',
      whereArgs: ['$prefix%'],
      orderBy: MoodDatabase.columnDate,
    );
    return rows.map(_rowToEntry).toList();
  }

  @override
  Future<bool> hasEntryForDate(DateTime date) async {
    final entry = await getEntryForDate(date);
    return entry != null;
  }

  MoodEntry _rowToEntry(Map<String, Object?> row) {
    final id = row[MoodDatabase.columnId] as int?;
    final level = row[MoodDatabase.columnMoodLevel] as int;
    final observation = row[MoodDatabase.columnObservation] as String? ?? '';
    final dateStr = row[MoodDatabase.columnDate] as String;
    final parts = dateStr.split('-');
    final date = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    final moodLevel = MoodLevel.values.firstWhere(
      (e) => e.value == level,
      orElse: () => MoodLevel.okay,
    );
    return MoodEntry(
      id: id,
      moodLevel: moodLevel,
      observation: observation,
      date: _dateOnly(date),
    );
  }
}
