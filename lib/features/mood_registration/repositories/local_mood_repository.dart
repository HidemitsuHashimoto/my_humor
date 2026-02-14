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

  @override
  Future<void> seedSampleDataForMonth(int year, int month) async {
    final lastDay = DateTime(year, month + 1, 0).day;
    final levels = MoodLevel.values;
    for (int day = 1; day <= lastDay; day++) {
      final date = DateTime(year, month, day);
      final levelIndex = _sampleLevelIndex(day, lastDay);
      final entry = MoodEntry(
        moodLevel: levels[levelIndex],
        observation: 'Exemplo',
        date: _dateOnly(date),
      );
      await save(entry);
    }
  }

  @override
  Future<void> clearSampleData() async {
    await _db.delete(MoodDatabase.tableMoodEntries);
  }

  /// Distribuição variada: mais "okay/good", menos "horrible/bad".
  int _sampleLevelIndex(int day, int lastDay) {
    final t = (day - 1) / (lastDay - 1).clamp(1, lastDay);
    if (t < 0.15) return 0;
    if (t < 0.30) return 1;
    if (t < 0.55) return 2;
    if (t < 0.80) return 3;
    return 4;
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
