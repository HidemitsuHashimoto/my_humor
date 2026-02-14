import '../../mood_registration/entities/mood_level.dart';

/// UI state for Home page (PH02, PH04).
class HomeState {
  const HomeState({
    this.selectedMood,
    this.observation = '',
    this.isSaving = false,
    this.saveError,
  });

  final MoodLevel? selectedMood;
  final String observation;
  final bool isSaving;
  final String? saveError;

  HomeState copyWith({
    MoodLevel? selectedMood,
    String? observation,
    bool? isSaving,
    String? saveError,
  }) {
    return HomeState(
      selectedMood: selectedMood ?? this.selectedMood,
      observation: observation ?? this.observation,
      isSaving: isSaving ?? this.isSaving,
      saveError: saveError,
    );
  }
}
