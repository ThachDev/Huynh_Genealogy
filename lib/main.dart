import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart' as di;
import 'features/auth/auth.dart';
import 'features/family_tree/family_tree.dart';

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

  @override
  State<FamilyTreeApp> createState() => _FamilyTreeAppState();
}

class _FamilyTreeAppState extends State<FamilyTreeApp> {
  Locale _locale = const Locale('vi');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider<TreeBloc>(create: (_) => di.sl<TreeBloc>()),
      ],
      child: MaterialApp(
        title: 'Gia Tộc Việt',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        locale: _locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return const FamilyDashboardPage();
            }
            // Mặc định hiển thị màn hình Đăng nhập nếu chưa xác thực
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
