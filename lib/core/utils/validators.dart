// ignore_for_file: deprecated_member_use

class AppValidators {
  AppValidators._();

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập địa chỉ email';
    }
    final trimmed = value.trim();
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Email không đúng định dạng (Ví dụ: ten@gmail.com)';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải chứa ít nhất 6 ký tự';
    }
    return null;
  }

  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 8) {
      return 'Mật khẩu bảo mật phải có ít nhất 8 ký tự';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Mật khẩu cần ít nhất 1 chữ cái viết hoa';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Mật khẩu cần ít nhất 1 chữ số';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Mật khẩu cần ít nhất 1 ký tự đặc biệt (!@#...)';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận lại mật khẩu';
    }
    if (value != password) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập họ và tên';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Họ và tên quá ngắn';
    }
    if (trimmed.length > 50) {
      return 'Họ và tên không được vượt quá 50 ký tự';
    }
    final nameRegex = RegExp(
        r'^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂÂĐÎÔƠƯỨỨỰửữựỳỵỷỹ \s]+$');
    if (!nameRegex.hasMatch(trimmed)) {
      return 'Họ và tên chỉ được chứa chữ cái và khoảng trắng';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    final trimmed = value.trim();
    final phoneRegex = RegExp(r'^(0|\+84)[3|5|7|8|9][0-9]{8}$');
    if (!phoneRegex.hasMatch(trimmed)) {
      return 'Số điện thoại không hợp lệ (Ví dụ: 0912345678)';
    }
    return null;
  }

  static String? validateYear(String? value, {int? minYear}) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập năm';
    }
    final year = int.tryParse(value.trim());
    if (year == null) {
      return 'Vui lòng nhập số năm hợp lệ';
    }
    final currentYear = DateTime.now().year;
    if (year > currentYear) {
      return 'Năm không thể lớn hơn năm hiện tại ($currentYear)';
    }
    if (minYear != null && year < minYear) {
      return 'Năm phải lớn hơn hoặc bằng $minYear';
    }
    if (year < 1000) {
      return 'Năm quá nhỏ (yêu cầu từ năm 1000 trở đi)';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập $fieldName';
    }
    return null;
  }
}
