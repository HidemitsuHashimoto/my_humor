import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import '../database/mood_database.dart';
import '../../features/mood_registration/repositories/local_mood_repository.dart';
import '../../features/mood_registration/repositories/mood_repository.dart';

final GetIt getIt = GetIt.instance;

/// Registers all dependencies. Call from main() before runApp.
Future<void> configureDependencies() async {
  final Database db = await MoodDatabase.database;
  getIt.registerSingleton<MoodRepository>(LocalMoodRepository(db));
}
