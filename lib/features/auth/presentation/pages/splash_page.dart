import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationCompleted = true;
        _checkAndNavigate();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkAndNavigate() {
    if (!_animationCompleted || !mounted) return;
    try {
      final authBloc = BlocProvider.of<AuthBloc>(context);
      _navigateIfReady(authBloc.state);
    } catch (_) {}
  }

  void _navigateIfReady(AuthState authState) {
    if (!_animationCompleted || !mounted) return;

    if (authState is Authenticated) {
      final isPending = authState.user.pendingStatus == 'PENDING';
      final hasFamily = authState.user.familyId != null;
      if (!hasFamily || isPending) {
        context.go('/onboarding');
      } else {
        context.go('/main');
      }
    } else if (authState is Unauthenticated || authState is AuthError) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthBloc? authBloc;
    try {
      authBloc = BlocProvider.of<AuthBloc>(context);
    } catch (_) {}

    final isDark = context.isDarkMode;
    final Widget content = AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: context.background,
        body: SizedBox.expand(
          child: Lottie.asset(
            'assets/json/Splash.json',
            controller: _controller,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            width: double.infinity,
            height: double.infinity,
            onLoaded: (composition) {
              FlutterNativeSplash.remove();
              _controller
                ..duration = composition.duration
                ..forward();
            },
          ),
        ),
      ),
    );

    if (authBloc != null) {
      return BlocListener<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          if (_animationCompleted) {
            _navigateIfReady(state);
          }
        },
        child: content,
      );
    }

    return content;
  }
}
