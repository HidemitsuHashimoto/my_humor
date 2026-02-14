import 'package:flutter/material.dart';

import '../../features/home/pages/home_page.dart';
import '../../features/relatorio/pages/relatorio_page.dart';

/// Named route paths. Accessible from any widget (N03).
abstract final class AppRoutes {
  static const String home = '/home';
  static const String relatorio = '/relatorio';
}

/// Router. Use pushReplacementNamed when navigating so previous route is destroyed (N04).
class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    debugPrint('Teste 3 ${settings.name}');
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const HomePage(),
        );
      case AppRoutes.relatorio:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const RelatorioPage(),
        );
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const HomePage(),
        );
    }
  }
}
