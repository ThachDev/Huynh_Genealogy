import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';

import 'resources/app_localizations.dart';
import 'core/configs/firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/errors/failures.dart';
import 'core/routes/app_router.dart';
import 'core/di/injection_container.dart' as di;

import 'features/auth/auth.dart';
import 'features/family_tree/family_tree.dart';
import 'features/onboarding/onboarding.dart';
import 'features/events/events.dart';
import 'features/admin/admin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  runApp(const FamilyTreeApp());
}

class FamilyTreeApp extends StatefulWidget {
  const FamilyTreeApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _FamilyTreeAppState? state =
        context.findAncestorStateOfType<_FamilyTreeAppState>();
    state?.setLocale(newLocale);
  }

  static void setThemeMode(BuildContext context, ThemeMode newThemeMode) {
    _FamilyTreeAppState? state =
        context.findAncestorStateOfType<_FamilyTreeAppState>();
    state?.setThemeMode(newThemeMode);
  }

  @override
  State<FamilyTreeApp> createState() => _FamilyTreeAppState();
}

class _FamilyTreeAppState extends State<FamilyTreeApp> {
  Locale _locale = const Locale('vi');
  ThemeMode _themeMode = ThemeMode.light;
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = di.sl<AuthBloc>()..add(AuthCheckRequested());
    _router = AppRouter.createRouter(_authBloc);
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void setThemeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<FamilyTreeBloc>(create: (_) => di.sl<FamilyTreeBloc>()),
        BlocProvider<OnboardingBloc>(create: (_) => di.sl<OnboardingBloc>()),
        BlocProvider<AdminMemberFormBloc>(
            create: (_) => di.sl<AdminMemberFormBloc>()),
        BlocProvider<AdminPendingRequestsBloc>(
            create: (_) => di.sl<AdminPendingRequestsBloc>()),
        BlocProvider<AdminBranchFormBloc>(
            create: (_) => di.sl<AdminBranchFormBloc>()),
        BlocProvider<AdminMemberRolesBloc>(
            create: (_) => di.sl<AdminMemberRolesBloc>()),
        BlocProvider<AdminDissolveClanBloc>(
            create: (_) => di.sl<AdminDissolveClanBloc>()),
        BlocProvider<AdminTransferOwnershipBloc>(
            create: (_) => di.sl<AdminTransferOwnershipBloc>()),
        BlocProvider<EventsBloc>(create: (_) => di.sl<EventsBloc>()),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode,
        locale: _locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) {
          AppLanguage.init(context);
          return child!;
        },
      ),
    );
  }
}
