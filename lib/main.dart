import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'resources/app_localizations.dart';
import 'core/configs/firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/widgets.dart';
import 'injection_container.dart' as di;
import 'features/auth/auth.dart';
import 'features/onboarding/onboarding.dart';
import 'features/user/user.dart';
import 'features/admin/admin.dart';
import 'features/family_fund/family_fund.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider<UserTreeBloc>(create: (_) => di.sl<UserTreeBloc>()),
        BlocProvider<FamilyFundBloc>(
          create: (_) => di.sl<FamilyFundBloc>()..add(FetchFundSummary()),
        ),
        BlocProvider<OnboardingBloc>(create: (_) => di.sl<OnboardingBloc>()),
        BlocProvider<AdminMemberFormBloc>(
            create: (_) => di.sl<AdminMemberFormBloc>()),
        BlocProvider<AdminPendingRequestsBloc>(
            create: (_) => di.sl<AdminPendingRequestsBloc>()),
      ],
      child: MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode,
        locale: _locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              if (state.user.familyId != null) {
                return const UserMainNavigationPage();
              }
              return const OnboardingPage();
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
