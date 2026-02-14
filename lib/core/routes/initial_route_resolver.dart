import '../di/injection.dart';
import '../../features/mood_registration/repositories/mood_repository.dart';
import 'app_router.dart';

/// Resolves initial route by rule: registrou hoje → Relatorio, else Home (N01, N02).
Future<String> resolveInitialRoute() async {
  final repository = getIt<MoodRepository>();
  final now = DateTime.now();
  final hasEntryToday = await repository.hasEntryForDate(now);
  return hasEntryToday ? AppRoutes.relatorio : AppRoutes.home;
}
