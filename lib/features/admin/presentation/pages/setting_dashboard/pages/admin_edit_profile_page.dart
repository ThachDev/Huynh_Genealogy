import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../resources/app_localizations.dart';
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
        text: widget.user?.fullName ?? '');
    _emailController = TextEditingController(
        text: widget.user?.email ?? '');
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: Text(l10n.accountInfoTitle),
        backgroundColor: context.appBarBg,
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
                  decoration: BoxDecoration(
                    color: context.primary,
                    image: const DecorationImage(
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
                            color: context.background,
                            shape: BoxShape.circle,
                            border: Border.all(color: context.accent, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: context.resolve(Colors.black, Colors.black)
                                    .withValues(alpha: 0.1),
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
                              ? Center(
                                  child: Icon(LucideIcons.user,
                                      size: 45, color: context.primary),
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
                      label: l10n.fullNameLabel,
                      hintText: l10n.nameHint,
                      enabled: false,
                      prefixIcon:
                          Icon(LucideIcons.user, color: context.appBarBg),
                    ),
                    const SizedBox(height: 16),
                    AppOutlineTextField(
                      controller: _emailController,
                      label: l10n.emailAccountLabel,
                      hintText: l10n.emailHint,
                      enabled: false, // Locked account field
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon:
                          Icon(LucideIcons.mail, color: context.appBarBg),
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
                            color: context.accent.withValues(alpha: 0.1),
                            border: Border.all(
                                color: context.accent.withValues(alpha: 0.5),
                                width: 1.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(LucideIcons.alertCircle,
                                      color: context.appBarBg, size: 24),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      l10n.noProfileLink,
                                      style: GoogleFonts.beVietnamPro(
                                        color: context.textPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.noProfileLinkDesc,
                                style: GoogleFonts.inter(
                                  color: context.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _navigateToMemberFormSetup,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: context.appBarBg,
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
                                    l10n.createProfileButton,
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
