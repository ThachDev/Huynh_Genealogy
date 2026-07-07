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
  String get forgotPasswordTitle => 'Quên mật khẩu';

  @override
  String get forgotPasswordSubtitle =>
      'Nhập email đã đăng ký để nhận mã xác thực đặt lại mật khẩu.';

  @override
  String get forgotPasswordButton => 'GỬI MÃ XÁC THỰC';

  @override
  String get forgotPasswordSuccess =>
      'Đã gửi email đặt lại mật khẩu. Vui lòng kiểm tra hộp thư (kể cả thư mục spam).';

  @override
  String get backToLogin => 'Quay lại đăng nhập';

  @override
  String get otpTitle => 'Xác thực OTP';

  @override
  String get otpSubtitleStart => 'Chúng tôi đã gửi mã xác thực 6 số đến email ';

  @override
  String get otpSubtitleEnd => '. Vui lòng kiểm tra hộp thư và nhập mã.';

  @override
  String get otpLabel => 'Mã xác thực';

  @override
  String get otpHint => '123456';

  @override
  String get otpRequiredError => 'Vui lòng nhập mã OTP';

  @override
  String get otpInvalidError => 'Mã OTP phải có 6 chữ số';

  @override
  String get otpVerifyButton => 'XÁC THỰC';

  @override
  String get otpResendButton => 'Gửi lại mã';

  @override
  String get resetPasswordTitle => 'Đặt lại mật khẩu';

  @override
  String get resetPasswordSubtitle =>
      'Nhập mật khẩu mới cho tài khoản của bạn.';

  @override
  String get resetPasswordButton => 'ĐẶT LẠI MẬT KHẨU';

  @override
  String get resetPasswordSuccessTitle => 'Thành công!';

  @override
  String get resetPasswordSuccessMessage =>
      'Mật khẩu của bạn đã được đặt lại. Vui lòng đăng nhập lại bằng mật khẩu mới.';

  @override
  String get newPasswordLabel => 'Mật khẩu mới';

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
      'Yêu cầu tham gia dòng họ đã được gửi đi thành công. Vui lòng liên hệ Trưởng tộc hoặc Người quản trị dòng họ để được phê duyệt.';

  @override
  String get checkStatusButton => 'Kiểm tra trạng thái';

  @override
  String welcomeCreatorTitle(String name) {
    return 'Chào Trưởng tộc, $name!';
  }

  @override
  String get welcomeCreatorSubtitle =>
      'Nhập thông tin bên dưới để bắt đầu khởi tạo cây gia phả dòng tộc của bạn.';

  @override
  String get familyNameLabel => 'Tên Gia tộc';

  @override
  String get familyNameHint => 'Ví dụ: Nguyễn Gia Tộc';

  @override
  String get familyNameRequired => 'Tên dòng họ không được để trống';

  @override
  String get familyDescriptionLabel => 'Mô tả Gia Tộc';

  @override
  String get familyDescriptionHint => 'Quê quán, nguồn gốc gia tộc...';

  @override
  String get initFamilyButton => 'KHỞI TẠO GIA TỘC';

  @override
  String welcomeViewerTitle(String name) {
    return 'Chào $name!';
  }

  @override
  String get welcomeViewerSubtitle =>
      'Nhập Mã mời do Trưởng tộc cung cấp để gia nhập và xem cây gia phả dòng tộc.';

  @override
  String get inviteCodeLabel => 'Mã Mời Gia Tộc';

  @override
  String get inviteCodeHint => 'Nhập mã 6 ký tự';

  @override
  String get verifyButton => 'Xác thực';

  @override
  String familyFoundTitle(String name) {
    return 'Tìm thấy gia tộc: $name';
  }

  @override
  String get selectMemberPrompt =>
      'Chọn tên của bạn trong danh sách dưới đây để liên kết với cây gia phả (nếu có):';

  @override
  String get whoAreYouDropdownHint => 'Bạn là ai trên cây gia phả?';

  @override
  String get sendJoinRequestButton => 'GỬI YÊU CẦU GIA NHẬP';

  @override
  String get chooseOnboardingSubtitle =>
      'Chọn một phương thức thiết lập gia phả để bắt đầu kết nối dòng tộc của bạn.';

  @override
  String get createFamilyCardTitle => 'Khởi tạo Gia tộc mới';

  @override
  String get createFamilyCardDesc =>
      'Dành cho Trưởng tộc, người lập phả muốn xây dựng một cây gia phả mới hoàn toàn.';

  @override
  String get joinFamilyCardTitle => 'Kết nối dòng tộc';

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

  @override
  String get retryButton => 'Thử lại';

  @override
  String get errStateTitle => 'Đã xảy ra lỗi';

  @override
  String get qrScannerTitle => 'Quét mã QR';

  @override
  String get qrScannerInstruction =>
      'Đặt mã QR vào trong khung hình để thực hiện quét tự động';

  @override
  String get qrScannerNoCodeFound =>
      'Không tìm thấy mã QR nào trong bức ảnh này.';

  @override
  String get qrScannerSelectImageError => 'Đã xảy ra lỗi khi chọn ảnh.';

  @override
  String get tapToChangePhoto => 'NHẤN ĐỂ THAY ĐỔI ẢNH';

  @override
  String get tapToUploadPhoto => 'NHẤN ĐỂ TẢI ẢNH LÊN';

  @override
  String get byInitAgreeTerms => 'BẰNG CÁCH NHẤN KHỞI TẠO, BẠN ĐỒNG Ý VỚI ';

  @override
  String get appTerms => 'CÁC ĐIỀU KHOẢN CỦA GIA TỘC VIỆT';

  @override
  String get enterInviteCodeLabel => 'NHẬP MÃ THAM GIA';

  @override
  String get inviteCodeHintNew => 'VD: HGT-2024';

  @override
  String get inviteCodeDescription =>
      'Nhập mã định danh 6 ký tự được cung cấp bởi trưởng tộc hoặc người quản lý gia tộc.';

  @override
  String get confirmJoinButton => 'XÁC NHẬN THAM GIA';

  @override
  String get navOverview => 'Tổng quan';

  @override
  String get navFamilyTree => 'Cây gia phả';

  @override
  String get navFamilyFund => 'Quỹ gia tộc';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get errGenerationRequired => 'Vui lòng nhập thế hệ';

  @override
  String get errGenerationMustBeNumber => 'Thế hệ phải là số';

  @override
  String get errPlaceOfBirthRequired => 'Vui lòng nhập quê quán';

  @override
  String get errDateOfBirthRequired => 'Vui lòng chọn ngày sinh';

  @override
  String get errDateOfDeathRequired => 'Vui lòng chọn ngày mất';

  @override
  String get formSave => 'LƯU LẠI';

  @override
  String get formCancel => 'HỦY BỎ';

  @override
  String get lunarSuffix => 'ÂM LỊCH';

  @override
  String get leapMonthSuffix => '(Nhuận)';

  @override
  String get searchHint => 'Tìm kiếm...';

  @override
  String get selectDate => 'Chọn ngày';

  @override
  String get selectMonthYear => 'Chọn tháng và năm';
}
