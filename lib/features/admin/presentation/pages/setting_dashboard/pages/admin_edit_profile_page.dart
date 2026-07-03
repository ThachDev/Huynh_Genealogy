import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../injection_container.dart';
import '../../../../admin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../auth/auth.dart';

class AdminEditProfilePage extends StatefulWidget {
  final UserEntity? user;
  const AdminEditProfilePage({super.key, this.user});

  @override
  State<AdminEditProfilePage> createState() => _AdminEditProfilePageState();
}

class _AdminEditProfilePageState extends State<AdminEditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
        text: widget.user?.fullName ?? 'Huỳnh Gia Trưởng');
    _emailController = TextEditingController(
        text: widget.user?.email ?? 'truongtoc@gmail.com');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _navigateToMemberFormSetup() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<AdminMemberFormBloc>(),
          child: AdminMemberFormPage(
            isOwnerSelfSetup: true,
            ownerUserId: widget.user?.id,
            initialFullName: widget.user?.fullName,
            initialAvatarUrl: widget.user?.avatarUrl,
          ),
        ),
      ),
    );
    // If member was created and linked, refresh profile
    if (result == true && mounted) {
      context.read<AuthBloc>().add(AuthProfileRefreshSilent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: const Text('THÔNG TIN TÀI KHOẢN'),
        backgroundColor: AppColors.wood,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Clouds Banner + User Avatar Stack
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.crimson,
                    image: DecorationImage(
                      image: AssetImage('assets/images/clouds.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: AppColors.parchment,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.gold, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                            image: widget.user?.avatarUrl != null &&
                                    widget.user!.avatarUrl!.isNotEmpty
                                ? DecorationImage(
                                    image:
                                        NetworkImage(widget.user!.avatarUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: (widget.user?.avatarUrl == null ||
                                  widget.user!.avatarUrl!.isEmpty)
                              ? const Center(
                                  child: Icon(LucideIcons.user,
                                      size: 45, color: AppColors.crimson),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 70),

            // Form Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppOutlineTextField(
                      controller: _nameController,
                      label: 'Họ và tên',
                      hintText: 'Nhập họ và tên',
                      enabled: false,
                      prefixIcon:
                          const Icon(LucideIcons.user, color: AppColors.wood),
                    ),
                    const SizedBox(height: 16),
                    AppOutlineTextField(
                      controller: _emailController,
                      label: 'Email (Tài khoản)',
                      hintText: 'example@email.com',
                      enabled: false, // Locked account field
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon:
                          const Icon(LucideIcons.mail, color: AppColors.wood),
                    ),
                    const SizedBox(height: 32),
                    if (widget.user?.role == 'OWNER' &&
                        (widget.user?.memberId == null ||
                            widget.user?.memberId == 0))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.1),
                            border: Border.all(
                                color: AppColors.gold.withValues(alpha: 0.5),
                                width: 1.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(LucideIcons.alertCircle,
                                      color: AppColors.wood, size: 24),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Chưa liên kết hồ sơ gia phả',
                                      style: GoogleFonts.beVietnamPro(
                                        color: AppColors.wood,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tài khoản của bạn là Trưởng tộc nhưng chưa được liên kết với một thành viên nào trong cây gia phả. Hãy tạo hồ sơ ngay để bắt đầu quản lý phả hệ.',
                                style: GoogleFonts.inter(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _navigateToMemberFormSetup,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.wood,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                  ),
                                  icon: const Icon(LucideIcons.userPlus,
                                      size: 16),
                                  label: Text(
                                    'TẠO HỒ SƠ GIA PHẢ',
                                    style: GoogleFonts.beVietnamPro(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
