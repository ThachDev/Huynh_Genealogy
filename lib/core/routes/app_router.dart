import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../features/auth/auth.dart';
import '../../features/onboarding/onboarding.dart';
import '../widgets/app_bottom_navigation_bar.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'rootNavKey');

  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/',
      refreshListenable: _GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final isLoggingIn = state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

        if (authState is Unauthenticated || authState is AuthInitial) {
          return isLoggingIn ? null : '/login';
        }

        if (authState is Authenticated) {
          final hasFamily = authState.user.familyId != null;
          if (!hasFamily) {
            return state.matchedLocation == '/onboarding' ? null : '/onboarding';
          }
          if (isLoggingIn || state.matchedLocation == '/' || state.matchedLocation == '/onboarding') {
            return '/main';
          }
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Center(
              child: Lottie.asset(
                'assets/json/loading.json',
                width: 150,
                height: 150,
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: '/main',
          builder: (context, state) => const UserMainNavigationPage(),
        ),
      ],
    );
  }
}

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    stream.listen((_) => notifyListeners());
  }
}
