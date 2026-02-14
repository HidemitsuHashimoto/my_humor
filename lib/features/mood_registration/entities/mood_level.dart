/// Mood levels in display order (PH01): Horrível, Mal, Mais ou Menos, Bem, Ótimo.
enum MoodLevel {
  horrible(1, 'Horrível'),
  bad(2, 'Mal'),
  okay(3, 'Mais ou Menos'),
  good(4, 'Bem'),
  great(5, 'Ótimo');

  const MoodLevel(this.value, this.label);
  final int value;
  final String label;
}
