import 'package:flutter/material.dart';

class LoggingNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    debugPrint('🚀 [Navigation] PUSH: ${route.settings.name ?? route.settings.arguments ?? route.runtimeType}');
    if (previousRoute != null) {
      debugPrint('   ⬅️ From: ${previousRoute.settings.name ?? "None"}');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    debugPrint('🔙 [Navigation] POP: ${route.settings.name ?? route.runtimeType}');
    if (previousRoute != null) {
      debugPrint('   ➡️ To: ${previousRoute.settings.name ?? "None"}');
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    debugPrint('🔄 [Navigation] REPLACE: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
  }
}
