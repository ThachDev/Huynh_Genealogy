import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/auth.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/path_selection_widget.dart';
import '../widgets/creator_onboarding_widget.dart';
import '../widgets/viewer_onboarding_widget.dart';
import '../widgets/pending_approval_widget.dart';
import '../widgets/family_creation_success_dialog.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // Common states
  bool _isRequestSent = false;
  int? _selectedPath; // null = select screen, 1 = Creator, 2 = Viewer

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is! Authenticated) {
      return const Scaffold(
        body: Center(
          child: AppLoading(size: 80),
        ),
      );
    }

    final user = authState.user;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppAppBar(
        title: l10n.onboardingTitle,
        leading: (_selectedPath != null && !_isRequestSent)
            ? IconButton(
                icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _selectedPath = null;
                  });
                },
              )
            : null,
        actions: [
          if (_selectedPath == null)
            IconButton(
              icon: const Icon(LucideIcons.logOut, color: Colors.white),
              tooltip: l10n.logoutTooltip,
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
            ),
        ],
      ),
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingFailureState) {
            AppSnackBar.error(context, state.message);
          } else if (state is FamilyCreatedState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogCtx) => FamilyCreationSuccessDialog(
                family: state.family,
                onProceed: () {
                  final updatedUser = user.copyWith(
                    familyId: state.family.id,
                    role: 'OWNER',
                  );
                  UserMainNavigationPage.adminModeNotifier.value = true;
                  context.read<AuthBloc>().add(AuthUserUpdated(user: updatedUser));
                },
              ),
            );
          } else if (state is InviteCodeVerifiedState) {
            AppSnackBar.success(
              context,
              l10n.verifyInviteSuccess(state.family.name),
            );
          } else if (state is JoinRequestSentState) {
            AppSnackBar.success(context, l10n.joinRequestSuccess);
            setState(() {
              _isRequestSent = true;
            });
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isRequestSent)
                  PendingApprovalWidget(user: user)
                else if (_selectedPath == null)
                  PathSelectionWidget(
                    user: user,
                    selectedPath: _selectedPath,
                    onPathSelected: (path) {
                      setState(() {
                        _selectedPath = path;
                      });
                    },
                  )
                else if (_selectedPath == 1)
                  CreatorOnboardingWidget(user: user)
                else
                  ViewerOnboardingWidget(user: user),
              ],
            ),
          );
        },
      ),
    );
  }
}
