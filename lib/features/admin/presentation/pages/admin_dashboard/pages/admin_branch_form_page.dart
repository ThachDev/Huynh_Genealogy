import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/domain/entity/branch_entity.dart';
import '../../../../../../core/domain/entity/member_entity.dart';
import '../../../../../auth/auth.dart';
import '../../../../../user/presentation/bloc/user_tree_bloc.dart';
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
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.parchment,
        title: Text(
          'Xác Nhận Xóa',
          style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.bold, color: AppColors.wood),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xoá chi tộc ${widget.branch!.name} không?',
          style: GoogleFonts.beVietnamPro(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Hủy',
                style:
                    GoogleFonts.beVietnamPro(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<AdminBranchFormBloc>()
                  .add(DeleteAdminBranchFormEvent(widget.branch!.id));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_nameController.text.trim().isEmpty) {
      AppSnackBar.error(context, 'Vui lòng nhập tên chi tộc');
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF6B6661),
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
        if (label == 'Tên chi tộc' && (val == null || val.trim().isEmpty)) {
          return 'Không được để trống';
        }
        return null;
      },
    );
  }

  Widget _buildSectionCard({
    IconData? icon,
    String? title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF2ECE7), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
                Icon(icon, size: 20, color: AppColors.crimson),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.crimson,
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
    final isEdit = widget.branch != null;
    final title = isEdit ? 'SỬA CHI TỘC' : 'THÊM CHI TỘC';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2825),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft,
              color: AppColors.gold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          title,
          style: GoogleFonts.beVietnamPro(
            color: AppColors.gold,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(LucideIcons.trash2,
                  color: Colors.redAccent, size: 20),
              onPressed: _showDeleteConfirmDialog,
              tooltip: 'Xóa chi tộc',
            ),
        ],
      ),
      body: BlocConsumer<AdminBranchFormBloc, AdminBranchFormState>(
        listener: (context, state) {
          if (state is AdminBranchFormSuccess) {
            AppSnackBar.success(
              context,
              state.isDeleted
                  ? 'Đã xóa chi tộc thành công'
                  : 'Đã lưu thông tin chi tộc thành công',
            );
            Navigator.pop(context, true);
          } else if (state is AdminBranchFormError) {
            AppSnackBar.error(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is AdminBranchFormLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }

          final userTreeState = context.watch<UserTreeBloc>().state;
          final members = userTreeState is UserTreeLoaded
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
                          icon: LucideIcons.gitBranch,
                          title: 'THÔNG TIN CƠ BẢN',
                          children: [
                            _buildTextField(
                              controller: _nameController,
                              label: 'Tên chi tộc',
                              hintText: 'VD: Chi Trưởng, Chi Hai...',
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
                                            _buildLabel('Tên tổ chi'),
                                            AppDropdown<String?>(
                                              value: members.any((m) =>
                                                      m.fullName ==
                                                      _founderController.text)
                                                  ? _founderController.text
                                                  : null,
                                              items: [
                                                const DropdownItem<String?>(
                                                  value: '__ADD_NEW__',
                                                  child: Text(
                                                    '✦ Thêm thành viên mới...',
                                                    style: TextStyle(
                                                      color: AppColors.crimson,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const DropdownItem<String?>(
                                                  value: null,
                                                  child: Text('Không chọn'),
                                                ),
                                                ...members.map((m) =>
                                                    DropdownItem<String?>(
                                                      value: m.fullName,
                                                      child: Text(
                                                          '${m.fullName} (Đời ${m.generation})'),
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
                                                        context
                                                            .read<
                                                                UserTreeBloc>()
                                                            .add(
                                                                UserTreeLoadEvent());
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
                                          label: 'Tên tổ chi (Tự nhập)',
                                          hintText: 'Người lập chi (tùy chọn)',
                                        ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFEFEBE7),
                                        width: 1.2),
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFFFCFAF8),
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
                                      color: AppColors.wood,
                                      size: 20,
                                    ),
                                    tooltip: _useDropdown
                                        ? 'Tự nhập tên'
                                        : 'Chọn từ danh sách',
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
                                    label: 'Năm lập chi',
                                    hintText: 'VD: 1980',
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 3,
                                  child: _buildTextField(
                                    controller: _regionController,
                                    label: 'Địa phương',
                                    hintText: 'VD: Làng X, Huyện Y',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _descriptionController,
                              label: 'Mô tả chi tộc',
                              hintText: 'Nhập thêm thông tin mô tả chi tiết...',
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
                  color: const Color(0xFFF7F5F2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: AppFormActionButtons(
                  saveLabel: 'LƯU CHI TỘC',
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
