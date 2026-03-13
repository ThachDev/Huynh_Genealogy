import 'package:go_router/go_router.dart';
import '../../features/family_tree/presentation/dashboard/pages/main_shell_page.dart';
import '../../features/family_tree/presentation/member/pages/member_detail_page.dart';
import '../../features/family_tree/domain/entities/member.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainShellPage(),
      ),
      GoRoute(
        path: '/member/detail',
        builder: (context, state) {
          final member = state.extra as MemberEntity;
          return MemberDetailPage(member: member);
        },
      ),
    ],
  );
}
