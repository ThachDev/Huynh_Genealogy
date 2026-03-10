import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import '../features/family_tree/presentation/dashboard/pages/main_shell_page.dart';
import '../resource/app_theme.dart';
import '../di/injection_container.dart' as di;

class FamilyTreeApp extends StatelessWidget {
  const FamilyTreeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<TreeBloc>(create: (_) => di.sl<TreeBloc>())],
      child: MaterialApp(
        title: 'Gia Phả',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainShellPage(),
      ),
    );
  }
}
