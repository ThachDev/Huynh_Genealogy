import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'resources/app_localizations.dart';
import 'core/configs/firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/widgets.dart';
import 'core/errors/failures.dart';
import 'injection_container.dart' as di;
import 'features/auth/auth.dart';
import 'features/onboarding/onboarding.dart';
import 'features/admin/admin.dart';
import 'features/family_tree/family_tree.dart';

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
  final _navigatorKey = GlobalKey<NavigatorState>();
  Locale _locale = const Locale('vi');
  ThemeMode _themeMode = ThemeMode.light;

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

  Widget _homeForAuth(AuthState state) {
    if (state is Authenticated) {
      if (state.user.familyId != null) {
        return const UserMainNavigationPage();
      }
      return const OnboardingPage();
    }
    return const LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
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
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) {
          if (previous is Authenticated && current is Authenticated) {
            return (previous.user.familyId != null) !=
                (current.user.familyId != null);
          }
          return previous.runtimeType != current.runtimeType;
        },
        listener: (context, state) {
          _navigatorKey.currentState?.popUntil((route) => route.isFirst);
        },
        child: MaterialApp(
          navigatorKey: _navigatorKey,
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
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) => _homeForAuth(state),
          ),
        ),
      ),
    );
  }
}
