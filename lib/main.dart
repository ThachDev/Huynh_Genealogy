import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart' as di;
import 'presentation/bloc/tree/tree_bloc.dart';
import 'presentation/pages/family_dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const FamilyTreeApp());
}

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
        home: const FamilyDashboardPage(),
      ),
    );
  }
}
