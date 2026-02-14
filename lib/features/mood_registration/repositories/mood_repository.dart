import '../entities/mood_entry.dart';

/// Contract for local mood persistence (B01).
abstract interface class MoodRepository {
  Future<void> save(MoodEntry entry);
  Future<MoodEntry?> getEntryForDate(DateTime date);
  Future<List<MoodEntry>> getEntriesForMonth(int year, int month);
  Future<bool> hasEntryForDate(DateTime date);
  /// Inserts sample entries for the given month for demo/testing.
  Future<void> seedSampleDataForMonth(int year, int month);
  // Clear all entries
  Future<void> clearSampleData();
}
