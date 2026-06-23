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
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get loginButton => 'Đăng nhập';

  @override
  String get orDivider => 'Hoặc';

  @override
  String get googleLoginButton => 'Đăng nhập với Google';

  @override
  String get noAccountText => 'Chưa có tài khoản? ';

  @override
  String get registerNow => 'Đăng ký ngay';

  @override
  String get rememberMe => 'Ghi nhớ mật khẩu';

  @override
  String get registerTitle => 'Đăng Ký';

  @override
  String get registerSubtitle => 'Tạo tài khoản gia phả dòng tộc của bạn';

  @override
  String get fullNameLabel => 'Họ và tên';

  @override
  String get fullNameHint => 'Nguyễn Văn A';

  @override
  String get confirmPasswordLabel => 'Xác nhận mật khẩu';

  @override
  String get confirmPasswordHint => '••••••••';

  @override
  String get registerButton => 'Đăng ký';

  @override
  String get alreadyHaveAccountText => 'Đã có tài khoản? ';

  @override
  String get loginNow => 'Đăng nhập ngay';

  @override
  String get registerAsCreator => 'Đăng ký với tư cách Trưởng tộc';

  @override
  String get acceptTermsText => 'Tôi đồng ý với ';

  @override
  String get termsOfService => 'Điều khoản dịch vụ';

  @override
  String get andText => ' và ';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get termsValidationErr =>
      'Bạn phải đồng ý với Điều khoản dịch vụ và Chính sách bảo mật để tiếp tục';

  @override
  String get termsContent =>
      'Chào mừng bạn đến với Gia Tộc Việt. Khi sử dụng dịch vụ của chúng tôi, bạn đồng ý với các điều khoản dưới đây:\n\n1. Quy định tài khoản: Bạn chịu trách nhiệm bảo mật thông tin tài khoản và mật khẩu của mình.\n\n2. Quyền sở hữu dữ liệu: Thông tin gia phả do dòng họ đóng góp thuộc quyền sở hữu chung của các thành viên được cấp quyền trong dòng họ.\n\n3. Hành vi bị cấm: Không đăng tải nội dung xuyên tạc lịch sử, thông tin sai sự thật hoặc xâm phạm đời tư của người khác.\n\n4. Thay đổi điều khoản: Chúng tôi có quyền cập nhật điều khoản dịch vụ để phù hợp hơn với hoạt động của hệ thống.';

  @override
  String get privacyContent =>
      'Gia Tộc Việt cam kết bảo vệ thông tin riêng tư của gia đình bạn:\n\n1. Thu thập dữ liệu: Chúng tôi thu thập họ tên, email, ảnh đại diện, và dữ liệu phả hệ do bạn chủ động cung cấp.\n\n2. Sử dụng thông tin: Dữ liệu được sử dụng để xây dựng sơ đồ cây gia phả, kết nối các thành viên và thông báo các sự kiện dòng họ.\n\n3. Bảo mật: Chúng tôi áp dụng các biện pháp bảo mật hiện đại để ngăn chặn rò rỉ dữ liệu.\n\n4. Chia sẻ dữ liệu: Chúng tôi tuyệt đối không bán hoặc chia sẻ dữ liệu gia phả của bạn cho bất kỳ bên thứ ba nào vì mục đích quảng cáo.';

  @override
  String get closeButton => 'Đóng';

  @override
  String get appTitle => 'Gia Tộc Việt';

  @override
  String get confirmLabel => 'Xác nhận';

  @override
  String get cancelLabel => 'Hủy';

  @override
  String get okLabel => 'Đóng';

  @override
  String get loadingMessage => 'Đang xử lý...';

  @override
  String get emailLoginFeatureNotice =>
      'Tính năng Đăng nhập Email đang được phát triển. Vui lòng sử dụng Đăng nhập với Google.';

  @override
  String get forgotPasswordNotice =>
      'Vui lòng liên hệ Chủ quản dòng họ để được cấp lại mật khẩu.';

  @override
  String get enterInviteCodeWarning => 'Vui lòng nhập mã mời';

  @override
  String get onboardingTitle => 'Thiết Lập Gia Tộc';

  @override
  String get logoutTooltip => 'Đăng xuất';

  @override
  String get createFamilySuccess => 'Tạo dòng họ thành công!';

  @override
  String verifyInviteSuccess(String familyName) {
    return 'Xác thực mã mời thành công: $familyName';
  }

  @override
  String get joinRequestSuccess => 'Yêu cầu tham gia đã gửi thành công!';

  @override
  String get pendingApprovalTitle => 'Đang Chờ Phê Duyệt';

  @override
  String get pendingApprovalMessage =>
      'Yêu cầu tham gia dòng họ của bạn đã được gửi đi thành công. Vui lòng liên hệ Trưởng tộc / Chủ quản dòng họ để phê duyệt tài khoản.';

  @override
  String get checkStatusButton => 'Kiểm tra trạng thái';

  @override
  String welcomeCreatorTitle(String name) {
    return 'Chào Trưởng tộc, $name!';
  }

  @override
  String get welcomeCreatorSubtitle =>
      'Vui lòng nhập thông tin dưới đây để khởi tạo cây gia phả dòng tộc của bạn.';

  @override
  String get familyNameLabel => 'Tên Dòng Họ / Gia Tộc';

  @override
  String get familyNameHint => 'Ví dụ: Nguyễn Gia Tộc';

  @override
  String get familyNameRequired => 'Tên dòng họ không được để trống';

  @override
  String get familyDescriptionLabel => 'Tiểu sử / Mô tả Dòng Họ';

  @override
  String get familyDescriptionHint => 'Quê quán, nguồn gốc gia phả...';

  @override
  String get initFamilyButton => 'KHỞI TẠO GIA TỘC';

  @override
  String welcomeViewerTitle(String name) {
    return 'Chào $name!';
  }

  @override
  String get welcomeViewerSubtitle =>
      'Vui lòng nhập Mã Mời (Invite Code) do Trưởng tộc cung cấp để gia nhập và xem cây gia phả dòng tộc.';

  @override
  String get inviteCodeLabel => 'Mã Mời Gia Tộc';

  @override
  String get inviteCodeHint => 'Nhập mã 6 ký tự';

  @override
  String get verifyButton => 'Xác thực';

  @override
  String familyFoundTitle(String name) {
    return 'Gia tộc tìm thấy: $name';
  }

  @override
  String get selectMemberPrompt =>
      'Vui lòng chọn tên của bạn trong danh sách dưới đây để liên kết với cây gia phả (nếu có):';

  @override
  String get whoAreYouDropdownHint => 'Bạn là ai trên cây gia phả?';

  @override
  String get sendJoinRequestButton => 'GỬI YÊU CẦU GIA NHẬP';

  @override
  String get chooseOnboardingSubtitle =>
      'Vui lòng chọn một phương thức thiết lập gia phả để bắt đầu kết nối dòng tộc của bạn.';

  @override
  String get createFamilyCardTitle => 'Khởi tạo Gia tộc mới';

  @override
  String get createFamilyCardDesc =>
      'Dành cho Trưởng tộc, người lập phả muốn xây dựng một cây gia phả mới hoàn toàn.';

  @override
  String get joinFamilyCardTitle => 'Gia nhập Gia tộc đã có';

  @override
  String get joinFamilyCardDesc =>
      'Dành cho thành viên đã có mã mời từ Trưởng tộc để xem và cập nhật cây gia phả.';

  @override
  String get errEmailRequired => 'Vui lòng nhập địa chỉ email';

  @override
  String get errEmailInvalid =>
      'Email không đúng định dạng (Ví dụ: ten@gmail.com)';

  @override
  String get errPasswordRequired => 'Vui lòng nhập mật khẩu';

  @override
  String get errPasswordMinLength => 'Mật khẩu phải chứa ít nhất 6 ký tự';

  @override
  String get errStrongPasswordMinLength =>
      'Mật khẩu bảo mật phải có ít nhất 8 ký tự';

  @override
  String get errStrongPasswordUppercase =>
      'Mật khẩu cần ít nhất 1 chữ cái viết hoa';

  @override
  String get errStrongPasswordNumber => 'Mật khẩu cần ít nhất 1 chữ số';

  @override
  String get errStrongPasswordSpecialChar =>
      'Mật khẩu cần ít nhất 1 ký tự đặc biệt (!@#...)';

  @override
  String get errConfirmPasswordRequired => 'Vui lòng xác nhận lại mật khẩu';

  @override
  String get errConfirmPasswordMismatch => 'Mật khẩu xác nhận không khớp';

  @override
  String get errFullNameRequired => 'Vui lòng nhập họ và tên';

  @override
  String get errFullNameTooShort => 'Họ và tên quá ngắn';

  @override
  String get errFullNameTooLong => 'Họ và tên không được vượt quá 50 ký tự';

  @override
  String get errFullNameInvalid =>
      'Họ và tên chỉ được chứa chữ cái và khoảng trắng';

  @override
  String get errPhoneNumberRequired => 'Vui lòng nhập số điện thoại';

  @override
  String get errPhoneNumberInvalid =>
      'Số điện thoại không hợp lệ (Ví dụ: 0912345678)';

  @override
  String get errYearRequired => 'Vui lòng nhập năm';

  @override
  String get errYearInvalid => 'Vui lòng nhập số năm hợp lệ';

  @override
  String errYearFuture(int year) {
    return 'Năm không thể lớn hơn năm hiện tại ($year)';
  }

  @override
  String errYearMin(int year) {
    return 'Năm phải lớn hơn hoặc bằng $year';
  }

  @override
  String get errYearTooSmall => 'Năm quá nhỏ (yêu cầu từ năm 1000 trở đi)';

  @override
  String errRequiredField(String fieldName) {
    return 'Vui lòng nhập $fieldName';
  }

  @override
  String get errServer =>
      'Hệ thống đang gặp sự cố tạm thời. Vui lòng thử lại sau ít phút.';

  @override
  String get errNetwork =>
      'Không có kết nối mạng. Vui lòng kiểm tra lại Wi-Fi hoặc dữ liệu di động.';

  @override
  String get errCache =>
      'Không thể truy xuất dữ liệu lưu tạm trên thiết bị. Vui lòng tải lại trang.';

  @override
  String get errNotFound =>
      'Không tìm thấy thông tin yêu cầu hoặc dữ liệu đã bị xóa.';

  @override
  String get errValidation =>
      'Thông tin nhập vào chưa chính xác. Vui lòng kiểm tra lại.';

  @override
  String get errUnknown =>
      'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại sau.';

  @override
  String get errAuth =>
      'Phiên đăng nhập đã hết hạn hoặc tài khoản/mật khẩu không chính xác. Vui lòng đăng nhập lại.';

  @override
  String get errPermission =>
      'Tài khoản của bạn không có quyền thực hiện chức năng này.';

  @override
  String get errTimeout =>
      'Kết nối mạng quá chậm hoặc bị gián đoạn. Vui lòng thử lại.';
}
