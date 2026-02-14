import 'package:flutter/material.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

/// Root widget: MaterialApp with theme and router.
/// Initial route is resolved in main() by rule (N01, N02): registrou hoje → Relatorio, else Home.
class App extends StatelessWidget {
  const App({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Humor',
      theme: AppTheme.light,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: initialRoute,
    );
  }
}
