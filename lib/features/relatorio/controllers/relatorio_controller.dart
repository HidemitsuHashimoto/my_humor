import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../mood_registration/entities/mood_entry.dart';
import '../../mood_registration/repositories/mood_repository.dart';

final relatorioRepositoryProvider =
    Provider<MoodRepository>((_) => getIt<MoodRepository>());

final relatorioControllerProvider =
    FutureProvider.autoDispose.family<List<MoodEntry>, ({int year, int month})>(
        (ref, params) async {
  final repository = ref.watch(relatorioRepositoryProvider);
  return repository.getEntriesForMonth(params.year, params.month);
});
