import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../main.dart';

class AdminLanguageSettingsPage extends StatefulWidget {
  const AdminLanguageSettingsPage({super.key});

  @override
  State<AdminLanguageSettingsPage> createState() =>
      _AdminLanguageSettingsPageState();
}

class _AdminLanguageSettingsPageState extends State<AdminLanguageSettingsPage> {
  String _selectedLocale = 'vi';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    setState(() {
      _selectedLocale = locale.languageCode;
    });
  }

  void _changeLanguage(String langCode) {
    if (_selectedLocale != langCode) {
      setState(() {
        _selectedLocale = langCode;
      });
      // Notify main.dart config to update application wide locale
      FamilyTreeApp.setLocale(context, Locale(langCode));
      AppSnackBar.success(
        context,
        langCode == 'vi'
            ? 'Đã chuyển đổi sang Tiếng Việt'
            : 'Language switched to English',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: const Text('NGÔN NGỮ HỆ THỐNG'),
        backgroundColor: AppColors.wood,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chọn ngôn ngữ hiển thị chính cho ứng dụng của bạn:',
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.gold.withValues(alpha: 0.15)),
              ),
              child: Column(
                children: [
                  _buildLanguageOption(
                    title: 'Tiếng Việt',
                    subtitle: 'Giao diện tiếng Việt chuẩn',
                    code: 'vi',
                    flag: '🇻🇳',
                  ),
                  Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.gold.withValues(alpha: 0.05)),
                  _buildLanguageOption(
                    title: 'English',
                    subtitle: 'Standard English interface',
                    code: 'en',
                    flag: '🇺🇸',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String title,
    required String subtitle,
    required String code,
    required String flag,
  }) {
    final isSelected = _selectedLocale == code;
    return InkWell(
      onTap: () => _changeLanguage(code),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.crimson
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                LucideIcons.check,
                color: AppColors.crimson,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
