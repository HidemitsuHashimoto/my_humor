import 'mood_level.dart';

/// Single mood record: Humor, Observação, Dia/Mês/Ano (B02).
class MoodEntry {
  const MoodEntry({
    required this.moodLevel,
    required this.observation,
    required this.date,
    this.id,
  });

  final int? id;
  final MoodLevel moodLevel;
  final String observation;
  final DateTime date;

  MoodEntry copyWith({
    int? id,
    MoodLevel? moodLevel,
    String? observation,
    DateTime? date,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      moodLevel: moodLevel ?? this.moodLevel,
      observation: observation ?? this.observation,
      date: date ?? this.date,
    );
  }
}
