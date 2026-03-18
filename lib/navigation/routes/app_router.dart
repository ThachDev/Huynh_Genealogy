import 'package:go_router/go_router.dart';
import '../../shell/main_shell_page.dart';
import '../../features/family_tree/presentation/member/pages/member_detail_page.dart';
import '../../features/family_tree/presentation/member/pages/member_list_page.dart';
import '../../features/family_tree/presentation/branch/pages/branch_list_page.dart';
import '../../features/family_tree/presentation/branch/pages/branch_detail_page.dart';
import '../../features/family_tree/domain/entities/member.dart';
import '../../features/family_tree/domain/entities/branch.dart';
import '../../features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import '../../features/settings/presentation/about/pages/about_page.dart';
import '../../features/settings/presentation/security_policy/pages/security_policy_page.dart';
import '../../features/settings/presentation/support/pages/support_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'logging_navigator_observer.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    observers: [LoggingNavigatorObserver()],
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const MainShellPage(),
      ),
      GoRoute(
        path: '/branches',
        name: 'branch_list',
        builder: (context, state) => const BranchListPage(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'branch_detail',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
              final branch = state.extra as BranchEntity?;

              if (branch != null) {
                return BranchDetailPage(branch: branch);
              }

              final treeState = context.read<TreeBloc>().state;
              if (treeState is TreeLoaded) {
                final b = treeState.branches.firstWhere((b) => b.id == id);
                return BranchDetailPage(branch: b);
              }
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/members',
        name: 'member_list',
        builder: (context, state) => const MemberListPage(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'member_detail',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
              final member = state.extra as MemberEntity?;

              if (member != null) {
                return MemberDetailPage(member: member);
              }

              final treeState = context.read<TreeBloc>().state;
              if (treeState is TreeLoaded) {
                final m = treeState.allMembers.firstWhere((m) => m.id == id);
                return MemberDetailPage(member: m);
              }
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ],
      ),
      // Giữ lại route cũ để tránh lỗi trong quá trình chuyển đổi nếu cần,
      // nhưng khuyến khích dùng /members/:id
      GoRoute(
        path: '/member/detail',
        name: 'member_detail_old',
        builder: (context, state) {
          final member = state.extra as MemberEntity;
          return MemberDetailPage(member: member);
        },
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: '/security_policy',
        name: 'security_policy',
        builder: (context, state) => const SecurityPolicyPage(),
      ),
      GoRoute(
        path: '/support',
        name: 'support',
        builder: (context, state) => const SupportPage(),
      ),
    ],
  );
}
