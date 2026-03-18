import 'package:app_family_tree/core/di/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:resources/resources.dart';
import '../features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import '../features/settings/presentation/language/bloc/language_bloc.dart';
import '../features/settings/presentation/language/bloc/language_state.dart';
import '../components/theme/app_theme.dart';
import '../navigation/routes/app_router.dart';

class FamilyTreeApp extends StatelessWidget {
  const FamilyTreeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TreeBloc>(create: (_) => di.sl<TreeBloc>()),
        BlocProvider<LanguageBloc>(create: (_) => di.sl<LanguageBloc>()),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Gia Phả',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: AppRouter.router,
            locale: state.locale,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
          );
        },
      ),
    );
  }
}
