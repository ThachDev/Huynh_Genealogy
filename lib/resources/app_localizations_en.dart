// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Login';

  @override
  String get loginSubtitle => 'Connect with your family genealogy roots';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get emailHint => 'email@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => '••••••••';

  @override
  String get forgotPassword => 'FORGOT PASSWORD?';

  @override
  String get loginButton => 'LOGIN';

  @override
  String get orDivider => 'OR';

  @override
  String get googleLoginButton => 'LOGIN WITH GOOGLE';

  @override
  String get noAccountText => 'Don\'t have an account? ';

  @override
  String get registerNow => 'REGISTER NOW';
}
