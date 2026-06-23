// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get loginTitle => 'Đăng Nhập';

  @override
  String get loginSubtitle => 'Kết nối với cội nguồn dòng tộc của bạn';

  @override
  String get emailLabel => 'Địa chỉ email';

  @override
  String get emailHint => 'email@example.com';

  @override
  String get passwordLabel => 'Mật khẩu';

  @override
  String get passwordHint => '••••••••';

  @override
  String get forgotPassword => 'QUÊN MẬT KHẨU?';

  @override
  String get loginButton => 'ĐĂNG NHẬP';

  @override
  String get orDivider => 'HOẶC';

  @override
  String get googleLoginButton => 'ĐĂNG NHẬP VỚI GOOGLE';

  @override
  String get noAccountText => 'Chưa có tài khoản? ';

  @override
  String get registerNow => 'ĐĂNG KÝ NGAY';
}
