import 'package:flutter/widgets.dart';
import '../../resources/app_localizations.dart';

class AppValidators {
  AppValidators._();

  static String? validateEmail(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.errEmailRequired;
    }
    final trimmed = value.trim();
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(trimmed)) {
      return l10n.errEmailInvalid;
    }
    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.errPasswordRequired;
    }
    if (value.length < 6) {
      return l10n.errPasswordMinLength;
    }
    return null;
  }

  static String? validateStrongPassword(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.errPasswordRequired;
    }
    if (value.length < 8) {
      return l10n.errStrongPasswordMinLength;
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return l10n.errStrongPasswordUppercase;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return l10n.errStrongPasswordNumber;
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return l10n.errStrongPasswordSpecialChar;
    }
    return null;
  }

  static String? validateConfirmPassword(BuildContext context, String? value, String password) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.errConfirmPasswordRequired;
    }
    if (value != password) {
      return l10n.errConfirmPasswordMismatch;
    }
    return null;
  }

  static String? validateFullName(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.errFullNameRequired;
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return l10n.errFullNameTooShort;
    }
    if (trimmed.length > 50) {
      return l10n.errFullNameTooLong;
    }
    final nameRegex = RegExp(
        r'^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂÂĐÎÔƠƯỨỨỰửữựỳỵỷỹ \s]+$');
    if (!nameRegex.hasMatch(trimmed)) {
      return l10n.errFullNameInvalid;
    }
    return null;
  }

  static String? validatePhoneNumber(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.errPhoneNumberRequired;
    }
    final trimmed = value.trim();
    final phoneRegex = RegExp(r'^(0|\+84)[3|5|7|8|9][0-9]{8}$');
    if (!phoneRegex.hasMatch(trimmed)) {
      return l10n.errPhoneNumberInvalid;
    }
    return null;
  }

  static String? validateYear(BuildContext context, String? value, {int? minYear}) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.errYearRequired;
    }
    final year = int.tryParse(value.trim());
    if (year == null) {
      return l10n.errYearInvalid;
    }
    final currentYear = DateTime.now().year;
    if (year > currentYear) {
      return l10n.errYearFuture(currentYear);
    }
    if (minYear != null && year < minYear) {
      return l10n.errYearMin(minYear);
    }
    if (year < 1000) {
      return l10n.errYearTooSmall;
    }
    return null;
  }

  static String? validateRequired(BuildContext context, String? value, String fieldName) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.errRequiredField(fieldName);
    }
    return null;
  }
}
