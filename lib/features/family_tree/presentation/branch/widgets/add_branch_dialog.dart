import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/resource/app_theme.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/branch.dart';
import 'package:app_family_tree/features/family_tree/presentation/branch/bloc/branch_form_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';

class AddBranchDialog extends StatefulWidget {
  final BranchEntity? branchToEdit;

  const AddBranchDialog({super.key, this.branchToEdit});

  @override
  State<AddBranchDialog> createState() => _AddBranchDialogState();
}

class _AddBranchDialogState extends State<AddBranchDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _founderController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.branchToEdit != null) {
      final b = widget.branchToEdit!;
      _nameController.text = b.name;
      _founderController.text = b.founderName ?? '';
      _yearController.text = b.foundingYear?.toString() ?? '';
      _regionController.text = b.region ?? '';
      _descriptionController.text = b.description ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BranchFormBloc, BranchFormState>(
      listener: (context, state) {
        if (state is BranchFormSuccess) {
          _showSuccessDialog(context, state.branch.name);
          context.read<TreeBloc>().add(LoadTreeEvent(force: true));
        } else if (state is BranchFormError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: AppColors.parchment,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: AppColors.gold, width: 2),
            ),
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: const BoxConstraints(maxWidth: 500),
              child: Stack(
                children: [
                   // Decorative corner
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Transform.rotate(
                      angle: 0.5,
                      child: Container(
                        width: 100,
                        height: 22,
                        color: AppColors.gold,
                        alignment: Alignment.center,
                        child: Text(
                          widget.branchToEdit != null ? 'SỬA' : 'MỚI',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: AppColors.crimson,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.park_rounded, color: AppColors.crimson),
                            const SizedBox(width: 12),
                            Text(
                              widget.branchToEdit != null
                                  ? 'CHỈNH SỬA CHI TỘC'
                                  : 'THÊM CHI TỘC MỚI',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.crimson,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 32, thickness: 1, color: AppColors.gold),

                        _buildLabel('TÊN CHI TỘC'),
                        _buildTextField(_nameController, hintText: 'Chi tộc Huỳnh Văn...'),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('NGƯỜI SÁNG LẬP'),
                                  _buildTextField(_founderController, hintText: 'Tên cụ tổ...'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('NĂM THÀNH LẬP'),
                                  _buildTextField(
                                    _yearController,
                                    hintText: 'VD: 1900',
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('VÙNG MIỀN / ĐỊA DANH'),
                        _buildTextField(_regionController, hintText: 'Quảng Ngãi, Bình Định...'),
                        const SizedBox(height: 16),

                        _buildLabel('MÔ TẢ / TIỂU SỬ CHI TỘC'),
                        _buildTextField(_descriptionController, hintText: 'Đôi nét về lịch sử chi tộc...', maxLines: 4),

                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.textSecondary),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text('HỦY', style: GoogleFonts.inter(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: BlocBuilder<BranchFormBloc, BranchFormState>(
                                builder: (context, state) {
                                  final isSubmitting = state is BranchFormSubmitting;
                                  return ElevatedButton(
                                    onPressed: isSubmitting ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.crimson,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      elevation: 4,
                                    ),
                                    child: isSubmitting
                                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                        : Text('LƯU LẠI', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên chi tộc')),
      );
      return;
    }

    final branch = BranchEntity(
      id: widget.branchToEdit?.id ?? 0,
      name: _nameController.text,
      founderName: _founderController.text.isNotEmpty ? _founderController.text : null,
      foundingYear: int.tryParse(_yearController.text),
      region: _regionController.text.isNotEmpty ? _regionController.text : null,
      description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
    );

    context.read<BranchFormBloc>().add(SubmitBranchFormEvent(branch));
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.gold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    String? hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(color: Colors.grey.withValues(alpha: 0.5), fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gold.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gold.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gold, width: 2),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String name) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (context, anim1, anim2) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (context.mounted) {
             Navigator.of(context).pop(); // Close Success
             Navigator.of(context).pop(); // Close Form
          }
        });

        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: AppColors.parchment,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gold, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.green, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'LƯU THÀNH CÔNG!',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.crimson,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Đã lưu thông tin chi tộc $name.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
