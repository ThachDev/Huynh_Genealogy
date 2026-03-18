import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/branch.dart';
import 'package:app_family_tree/features/family_tree/presentation/branch/bloc/branch_form_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import 'package:app_family_tree/components/text/section_label.dart';
import 'package:app_family_tree/components/input/common_text_field.dart';
import 'package:app_family_tree/components/dialog/common_dialog_container.dart';
import 'package:app_family_tree/components/dialog/success_dialog.dart';
import 'package:app_family_tree/components/button/common_buttons.dart';

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
  void dispose() {
    _nameController.dispose();
    _founderController.dispose();
    _yearController.dispose();
    _regionController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BranchFormBloc, BranchFormState>(
      listener: (context, state) {
        if (state is BranchFormSuccess) {
          SuccessDialog.show(
            context,
            title: 'LƯU THÀNH CÔNG!',
            message: 'Đã lưu thông tin chi tộc ${state.branch.name}.',
          );
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
      child: CommonDialogContainer(
        title: widget.branchToEdit != null ? 'CHỈNH SỬA CHI TỘC' : 'THÊM CHI TỘC MỚI',
        icon: Icons.park_rounded,
        statusLabel: widget.branchToEdit != null ? 'SỬA' : 'MỚI',
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionLabel('TÊN CHI TỘC'),
              CommonTextField(
                controller: _nameController,
                hintText: 'Chi tộc Huỳnh Văn...',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionLabel('NGƯỜI SÁNG LẬP'),
                        CommonTextField(
                          controller: _founderController,
                          hintText: 'Tên cụ tổ...',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionLabel('NĂM THÀNH LẬP'),
                        CommonTextField(
                          controller: _yearController,
                          hintText: 'VD: 1900',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const SectionLabel('VÙNG MIỀN / ĐỊA DANH'),
              CommonTextField(
                controller: _regionController,
                hintText: 'Quảng Ngãi, Bình Định...',
              ),
              const SizedBox(height: 16),
              const SectionLabel('MÔ TẢ / TIỂU SỬ CHI TỘC'),
              CommonTextField(
                controller: _descriptionController,
                hintText: 'Đôi nét về lịch sử chi tộc...',
                maxLines: 4,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: 'HỦY',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BlocBuilder<BranchFormBloc, BranchFormState>(
                      builder: (context, state) {
                        return PrimaryButton(
                          text: 'LƯU LẠI',
                          isLoading: state is BranchFormSubmitting,
                          onPressed: _submit,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
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
}
