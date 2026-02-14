import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../mood_registration/entities/mood_entry.dart';
import '../../mood_registration/entities/mood_level.dart';
import '../../mood_registration/repositories/mood_repository.dart';
import '../../../core/di/injection.dart';
import 'home_state.dart';

final moodRepositoryProvider = Provider<MoodRepository>((_) => getIt<MoodRepository>());

final homeControllerProvider =
    StateNotifierProvider<HomeController, HomeState>((ref) {
  final repository = ref.watch(moodRepositoryProvider);
  return HomeController(repository);
});

class HomeController extends StateNotifier<HomeState> {
  HomeController(this._repository) : super(const HomeState());

  final MoodRepository _repository;

  void selectMood(MoodLevel mood) {
    state = state.copyWith(selectedMood: mood, saveError: null);
  }

  void setObservation(String text) {
    state = state.copyWith(observation: text, saveError: null);
  }

  Future<bool> save() async {
    final selected = state.selectedMood;
    if (selected == null) {
      state = state.copyWith(saveError: 'Selecione um humor');
      return false;
    }
    state = state.copyWith(isSaving: true, saveError: null);
    try {
      final now = DateTime.now();
      final date = DateTime(now.year, now.month, now.day);
      final entry = MoodEntry(
        moodLevel: selected,
        observation: state.observation.trim(),
        date: date,
      );
      await _repository.save(entry);
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        saveError: e.toString(),
      );
      return false;
    }
  }
}
