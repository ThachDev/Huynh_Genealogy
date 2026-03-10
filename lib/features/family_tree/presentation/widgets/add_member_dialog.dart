import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/resource/app_theme.dart';

class AddMemberDialog extends StatefulWidget {
  const AddMemberDialog({super.key});

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _generationController = TextEditingController(
    text: '1',
  );
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _dodController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _selectedGender = 'Nam';
  String? _selectedFather;
  String? _selectedMother;

  @override
  Widget build(BuildContext context) {
    // Determine layout based on screen width
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: isDesktop ? 800 : double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: AppColors.parchment,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.crimson, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thêm thành viên mới',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.crimson,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.crimson,
                      size: 28,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // ── Content ──
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _buildLeftColumn()),
                          const SizedBox(width: 40),
                          Expanded(flex: 3, child: _buildRightColumn()),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLeftColumn(),
                          const SizedBox(height: 24),
                          _buildRightColumn(),
                        ],
                      ),
              ),
            ),

            // ── Footer ──
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.crimson,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      'HỦY BỎ',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Save action
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.crimson,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black45,
                    ),
                    child: Text(
                      'LƯU THÔNG TIN',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Avatar picker
        Center(
          child: Column(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.gold, width: 1.5),
                ),
                child: Center(
                  child: Icon(
                    Icons.person_outline,
                    size: 64,
                    color: AppColors.crimson.withValues(alpha: 0.2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'ẢNH CHÂN DUNG',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.crimson.withValues(alpha: 0.8),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Name
        _buildLabel('HỌ VÀ TÊN'),
        const SizedBox(height: 8),
        _buildTextField(_nameController),
        const SizedBox(height: 20),

        // Gender & Generation
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('GIỚI TÍNH'),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    value: _selectedGender,
                    items: ['Nam', 'Nữ'],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedGender = val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('ĐỜI THỨ'),
                  const SizedBox(height: 8),
                  _buildTextField(_generationController),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Dates
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('NGÀY SINH'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    _dobController,
                    hintText: 'dd/mm/yyyy',
                    icon: Icons.calendar_today_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('NGÀY MẤT'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    _dodController,
                    hintText: 'dd/mm/yyyy',
                    icon: Icons.calendar_today_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Father
        _buildLabel('CHA'),
        const SizedBox(height: 8),
        _buildDropdown(
          value: _selectedFather,
          items: ['Khổng rõ / Không có'],
          hint: 'Khổng rõ / Không có',
          onChanged: (val) {
            setState(() => _selectedFather = val);
          },
        ),
        const SizedBox(height: 20),

        // Mother
        _buildLabel('MẸ'),
        const SizedBox(height: 8),
        _buildDropdown(
          value: _selectedMother,
          items: ['Khổng rõ / Không có'],
          hint: 'Khổng rõ / Không có',
          onChanged: (val) {
            setState(() => _selectedMother = val);
          },
        ),
        const SizedBox(height: 20),

        // Note
        _buildLabel('GHI CHÚ / TIỂU SỬ'),
        const SizedBox(height: 8),
        TextField(
          controller: _noteController,
          maxLines: 10,
          style: GoogleFonts.inter(fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.gold.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.gold.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.gold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.crimson,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    String? hintText,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: icon != null
            ? Icon(icon, size: 20, color: Colors.black54)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.gold.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.gold.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.gold),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    String? value,
    required List<String> items,
    String? hint,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: hint != null
              ? Text(
                  hint,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                )
              : null,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
