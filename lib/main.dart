import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/routes/app_router.dart';
import 'core/routes/initial_route_resolver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  await configureDependencies();
  final initialRoute = await _resolveInitialRouteSafe();
  runApp(ProviderScope(child: App(initialRoute: initialRoute)));
}

Future<String> _resolveInitialRouteSafe() async {
  try {
    return await resolveInitialRoute();
  } catch (e, st) {
    debugPrint('resolveInitialRoute failed: $e\n$st');
    return AppRoutes.home;
  }
}
