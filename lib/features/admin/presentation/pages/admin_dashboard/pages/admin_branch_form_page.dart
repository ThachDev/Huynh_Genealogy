import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../resources/app_localizations.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../auth/auth.dart';
import '../../../../../family_tree/family_tree.dart';
import '../../../bloc/admin_branch_form/admin_branch_form_bloc.dart';
import 'admin_member_form_page.dart';

class AdminBranchFormPage extends StatefulWidget {
  final BranchEntity? branch; // null = Thêm mới, có giá trị = Chỉnh sửa

  const AdminBranchFormPage({super.key, this.branch});

  @override
  State<AdminBranchFormPage> createState() => _AdminBranchFormPageState();
}

class _AdminBranchFormPageState extends State<AdminBranchFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _founderController;
  late TextEditingController _descriptionController;
  late TextEditingController _foundingYearController;
  late TextEditingController _regionController;

  bool _useDropdown = true;
  bool _isFounderNameInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.branch?.name ?? '');
    _founderController =
        TextEditingController(text: widget.branch?.founderName ?? '');
    _descriptionController =
        TextEditingController(text: widget.branch?.description ?? '');
    _foundingYearController = TextEditingController(
        text: widget.branch?.foundingYear?.toString() ?? '');
    _regionController =
        TextEditingController(text: widget.branch?.region ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _founderController.dispose();
    _descriptionController.dispose();
    _foundingYearController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmDialog() {
    if (widget.branch == null) return;
    showDialog(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          backgroundColor: ctx.background,
          title: Text(
            l10n.deleteBranchConfirmTitle,
            style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold, color: ctx.textPrimary),
          ),
          content: Text(
            l10n.deleteBranchConfirmMessage(widget.branch!.name),
            style: GoogleFonts.beVietnamPro(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancelLabel,
                  style: GoogleFonts.beVietnamPro(color: ctx.textSecondary)),
            ),
            AppButton(
              label: l10n.deleteLabel,
              onPressed: () {
                Navigator.pop(ctx);
                context
                    .read<AdminBranchFormBloc>()
                    .add(DeleteAdminBranchFormEvent(widget.branch!.id));
              },
              variant: AppButtonVariant.danger,
              size: AppButtonSize.small,
            ),
          ],
        );
      },
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_nameController.text.trim().isEmpty) {
      AppSnackBar.error(
          context,
          AppLocalizations.of(context)!
              .errRequiredField(AppLocalizations.of(context)!.branchNameLabel));
      return;
    }

    final authState = context.read<AuthBloc>().state;
    final familyId =
        authState is Authenticated ? authState.user.familyId : null;

    final newBranch = BranchEntity(
      id: widget.branch?.id ?? 0,
      name: _nameController.text.trim(),
      founderName: _founderController.text.trim().isEmpty
          ? null
          : _founderController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      foundingYear: int.tryParse(_foundingYearController.text),
      region: _regionController.text.trim().isEmpty
          ? null
          : _regionController.text.trim(),
      familyId: widget.branch?.familyId ?? familyId ?? 1,
    );

    context
        .read<AdminBranchFormBloc>()
        .add(SaveAdminBranchFormEvent(newBranch));
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: context.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return AppOutlineTextField(
      controller: controller,
      label: label,
      hintText: hintText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (val) {
        final l10n = AppLocalizations.of(context)!;
        if (label == l10n.branchNameLabel &&
            (val == null || val.trim().isEmpty)) {
          return l10n.branchNameEmptyError;
        }
        return null;
      },
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    IconData? icon,
    String? title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.isDarkMode
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFF2ECE7),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: context.resolve(
              Colors.black.withValues(alpha: 0.02),
              Colors.transparent,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null && title != null) ...[
            Row(
              children: [
                Icon(icon, size: 20, color: context.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: context.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
          ],
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = widget.branch != null;
    final title = isEdit ? l10n.editBranchTitle : l10n.addBranchTitle;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: title,
        automaticallyImplyLeading: false,
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(LucideIcons.trash2,
                  color: Colors.redAccent, size: 20),
              onPressed: _showDeleteConfirmDialog,
              tooltip: l10n.deleteBranchTooltip,
            ),
        ],
      ),
      body: BlocConsumer<AdminBranchFormBloc, AdminBranchFormState>(
        listener: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          if (state is AdminBranchFormSuccess) {
            AppSnackBar.success(
              context,
              state.isDeleted
                  ? l10n.deleteBranchSuccess
                  : l10n.saveBranchSuccess,
            );
            Navigator.pop(context, true);
          } else if (state is AdminBranchFormError) {
            AppSnackBar.error(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is AdminBranchFormLoading) {
            return const Center(
              child: AppLoading(size: 80),
            );
          }

          final userTreeState = context.watch<FamilyTreeBloc>().state;
          final members = userTreeState is FamilyTreeLoaded
              ? userTreeState.members
              : <MemberEntity>[];

          if (!_isFounderNameInitialized &&
              members.isNotEmpty &&
              _founderController.text.isNotEmpty) {
            final hasMatch =
                members.any((m) => m.fullName == _founderController.text);
            if (!hasMatch) {
              _useDropdown = false;
            }
            _isFounderNameInitialized = true;
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildSectionCard(
                          context,
                          icon: LucideIcons.gitBranch,
                          title: l10n.basicInfoTitle,
                          children: [
                            _buildTextField(
                              controller: _nameController,
                              label: l10n.branchNameLabel,
                              hintText: l10n.branchNameHint,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: _useDropdown
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildLabel(
                                                context, l10n.founderNameLabel),
                                            AppDropdown<String?>(
                                              value: members.any((m) =>
                                                      m.fullName ==
                                                      _founderController.text)
                                                  ? _founderController.text
                                                  : null,
                                              items: [
                                                DropdownItem<String?>(
                                                  value: '__ADD_NEW__',
                                                  child: Text(
                                                    l10n.addMemberPlaceholder,
                                                    style: TextStyle(
                                                      color: context.primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                DropdownItem<String?>(
                                                  value: null,
                                                  child: Text(
                                                      l10n.noSelectionLabel),
                                                ),
                                                ...members.map((m) =>
                                                    DropdownItem<String?>(
                                                      value: m.fullName,
                                                      child: Text(
                                                          '${m.fullName} (${l10n.generationBadge('${m.generation}')})'),
                                                    )),
                                              ],
                                              onChanged: (val) {
                                                if (val == '__ADD_NEW__') {
                                                  // Reset selection value
                                                  setState(() {});

                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) async {
                                                    final result =
                                                        await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const AdminMemberFormPage(),
                                                      ),
                                                    );
                                                    if (result == true) {
                                                      if (context.mounted) {
                                                        final familyId = context
                                                                    .read<
                                                                        AuthBloc>()
                                                                    .state
                                                                is Authenticated
                                                            ? (context
                                                                        .read<
                                                                            AuthBloc>()
                                                                        .state
                                                                    as Authenticated)
                                                                .user
                                                                .familyId
                                                            : null;
                                                        context
                                                            .read<
                                                                FamilyTreeBloc>()
                                                            .add(FamilyTreeLoadEvent(
                                                                familyId:
                                                                    familyId));
                                                      }
                                                    }
                                                  });
                                                } else {
                                                  setState(() {
                                                    _founderController.text =
                                                        val ?? '';
                                                  });
                                                }
                                              },
                                              showSearchBox: true,
                                            ),
                                          ],
                                        )
                                      : _buildTextField(
                                          controller: _founderController,
                                          label: l10n.manualInputLabel,
                                          hintText: l10n.founderNameHint,
                                        ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: context.textSecondary
                                            .withValues(alpha: 0.2),
                                        width: 1.2),
                                    borderRadius: BorderRadius.circular(12),
                                    color: context.resolve(
                                        const Color(0xFFFCFAF8),
                                        context.surface),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _useDropdown = !_useDropdown;
                                      });
                                    },
                                    icon: Icon(
                                      _useDropdown
                                          ? LucideIcons.keyboard
                                          : LucideIcons.listStart,
                                      color: context.textPrimary,
                                      size: 20,
                                    ),
                                    tooltip: _useDropdown
                                        ? l10n.inputModeLabel
                                        : l10n.selectModeLabel,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _buildTextField(
                                    controller: _foundingYearController,
                                    label: l10n.foundationYearLabel,
                                    hintText: l10n.foundationYearHint,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 3,
                                  child: _buildTextField(
                                    controller: _regionController,
                                    label: l10n.locationLabel,
                                    hintText: l10n.locationHint,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _descriptionController,
                              label: l10n.branchDescLabel,
                              hintText: l10n.branchDescHint,
                              maxLines: 4,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Sticky bottom buttons
              Container(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                decoration: BoxDecoration(
                  color: context.background,
                  boxShadow: [
                    BoxShadow(
                      color: context.resolve(
                        Colors.black.withValues(alpha: 0.06),
                        Colors.transparent,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: AppFormActionButtons(
                  saveLabel: l10n.saveBranchLabel,
                  onSave: _submitForm,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
