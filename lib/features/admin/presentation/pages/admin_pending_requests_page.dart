import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/auth.dart';
import '../bloc/admin_pending_requests/admin_pending_requests_bloc.dart';

class AdminPendingRequestsPage extends StatefulWidget {
  const AdminPendingRequestsPage({super.key});

  @override
  State<AdminPendingRequestsPage> createState() => _AdminPendingRequestsPageState();
}

class _AdminPendingRequestsPageState extends State<AdminPendingRequestsPage> {
  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated && authState.user.familyId != null) {
      context.read<AdminPendingRequestsBloc>().add(
            LoadAdminPendingRequestsEvent(familyId: authState.user.familyId!),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        backgroundColor: AppColors.wood,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Duyệt Yêu Cầu Tham Gia',
          style: GoogleFonts.beVietnamPro(
            color: AppColors.gold,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw, color: Colors.white70),
            onPressed: _loadRequests,
            tooltip: 'Tải lại',
          ),
        ],
      ),
      body: BlocConsumer<AdminPendingRequestsBloc, AdminPendingRequestsState>(
        listener: (context, state) {
          if (state is AdminRequestApprovedSuccess) {
            AppSnackBar.success(context, 'Đã phê duyệt yêu cầu thành công!');
            // Reload list requests after approval
            _loadRequests();
          } else if (state is AdminPendingRequestsFailure) {
            AppSnackBar.error(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is AdminPendingRequestsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }

          if (state is AdminPendingRequestsFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.alertTriangle, size: 48, color: AppColors.crimson),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: 'Tải lại',
                      onPressed: _loadRequests,
                      size: AppButtonSize.medium,
                      variant: AppButtonVariant.primary,
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is AdminPendingRequestsLoaded) {
            final requests = state.requests;

            if (requests.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.wood.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.clipboardCheck,
                        size: 64,
                        color: AppColors.wood,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Không có yêu cầu nào đang chờ duyệt',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Yêu cầu mới sẽ hiển thị ở đây để bạn phê duyệt.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.wood.withValues(alpha: 0.12),
                              backgroundImage: request.userAvatarUrl != null
                                  ? NetworkImage(request.userAvatarUrl!)
                                  : null,
                              child: request.userAvatarUrl == null
                                  ? const Icon(LucideIcons.user, color: AppColors.wood)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request.userFullName ?? 'Người dùng ẩn danh',
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    request.userEmail ?? 'Không có email',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Divider(height: 1, color: Colors.black12),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  LucideIcons.shieldAlert,
                                  size: 14,
                                  color: AppColors.gold,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Vai trò yêu cầu: ',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.wood.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    request.role.toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.wood,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            AppButton(
                              label: 'Phê duyệt',
                              onPressed: () {
                                context.read<AdminPendingRequestsBloc>().add(
                                      ApproveAdminRequestEvent(requestId: request.id),
                                    );
                              },
                              size: AppButtonSize.small,
                              variant: AppButtonVariant.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
