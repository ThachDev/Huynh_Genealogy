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

  @override
  String get adminSettingsTitle => 'CÀI ĐẶT QUẢN TRỊ';
  @override
  String get accountAndClanSection => 'TÀI KHOẢN VÀ DÒNG TỘC';
  @override
  String get clanInfoLabel => 'Thông tin dòng tộc';
  @override
  String get accountSecurityLabel => 'Bảo mật tài khoản';
  @override
  String get switchToMemberPage => 'Chuyển sang trang Thành viên';
  @override
  String get appSettingsSection => 'THIẾT LẬP ỨNG DỤNG';
  @override
  String get languageLabel => 'Ngôn ngữ';
  @override
  String get themeLabel => 'Giao diện';
  @override
  String get infoAndHelpSection => 'THÔNG TIN & TRỢ GIÚP';
  @override
  String get regulationsLabel => 'Quy định & Điều khoản';
  @override
  String get helpCenterLabel => 'Trung tâm hỗ trợ';
  @override
  String get aboutUsLabel => 'Về chúng tôi';
  @override
  String get advancedAdminSection => 'QUẢN TRỊ NÂNG CAO';
  @override
  String get memberRolesLabel => 'Phân quyền thành viên';
  @override
  String get transferOwnershipLabel => 'Chuyển nhượng quyền Trưởng tộc';
  @override
  String get dissolveClanLabel => 'Giải tán dòng họ';
  @override
  String get logoutButton => 'ĐĂNG XUẤT';

  @override
  String get accountSecurityTitle => 'BẢO MẬT TÀI KHOẢN';
  @override
  String get changePasswordTitle => 'Đổi mật khẩu';
  @override
  String get passwordRequirementsDesc => 'Mật khẩu mới của bạn cần chứa ít nhất 8 ký tự, bao gồm cả chữ số, chữ hoa và ký tự đặc biệt để đảm bảo an toàn.';
  @override
  String get currentPasswordLabel => 'Mật khẩu hiện tại';
  @override
  String get currentPasswordHint => 'Nhập mật khẩu đang sử dụng';
  @override
  String get currentPasswordRequired => 'Vui lòng nhập mật khẩu hiện tại';
  @override
  String get newPasswordHint => 'Nhập mật khẩu mới';
  @override
  String get confirmNewPasswordLabel => 'Xác nhận mật khẩu mới';
  @override
  String get confirmNewPasswordHint => 'Nhập lại mật khẩu mới';
  @override
  String get updatePasswordButton => 'CẬP NHẬT MẬT KHẨU';
  @override
  String get changePasswordSuccess => 'Thay đổi mật khẩu thành công!';

  @override
  String get dissolveClanTitle => 'GIẢI TÁN GIA PHẢ';
  @override
  String get irreversibleActionTitle => 'Hành động không thể hoàn tác';
  @override
  String get irreversibleWarningDesc => 'Việc này KHÔNG THỂ hoàn tác. Toàn bộ cây gia phả, thông tin các đời, thành viên và dữ liệu sẽ bị xóa vĩnh viễn khỏi hệ thống.';
  @override
  String get confirmDissolveTitle => 'Xác nhận giải tán';
  @override
  String get confirmDissolveInstruction => 'Để xác nhận, vui lòng nhập chính xác tên dòng họ bên dưới:';
  @override
  String get enterLabel => 'Nhập: ';
  @override
  String get reenterClanNameLabel => 'Nhập lại tên dòng họ';
  @override
  String get reenterClanNameHint => 'Nhập đúng từng chữ để xác nhận';
  @override
  String get dissolvePermanentButton => 'GIẢI TÁN DÒNG HỌ VĨNH VIỄN';
  @override
  String get deletePermanentDialogTitle => 'XÓA GIA PHẢ VĨNH VIỄN';
  @override
  String deletePermanentDialogMessage(String name) => 'Hành động này cực kỳ nguy hiểm. Toàn bộ thông tin thành viên, các nhánh dòng họ, lịch sử gia tộc của "$name" sẽ bị xóa vĩnh viễn khỏi máy chủ. Bạn chắc chắn muốn tiếp tục chứ?';
  @override
  String get confirmDeletePermanentLabel => 'ĐỒNG Ý XÓA BỎ';
  @override
  String get dissolveSuccessMessage => 'Đã xóa gia phả. Toàn bộ dữ liệu đã được xóa khỏi hệ thống.';

  @override
  String get chooseRecipientLabel => 'Chọn người nhận quyền';
  @override
  String get transferDesc => 'Chỉ những thành viên đã kích hoạt tài khoản và có vai trò khác Trưởng tộc mới xuất hiện trong danh sách dưới đây:';
  @override
  String get searchMemberHint => 'Tìm thành viên...';
  @override
  String get noMemberFound => 'Không tìm thấy thành viên phù hợp.';
  @override
  String get noEligibleMembers => 'Không có thành viên nào đủ điều kiện nhận chuyển nhượng.';
  @override
  String get proceedTransferButton => 'TIẾN HÀNH CHUYỂN NHƯỢNG';
  @override
  String get warningDialogTitle => 'Cảnh báo quan trọng';
  @override
  String get warningDialogMessage => 'Quyền Trưởng tộc là quyền hạn cao nhất trong hệ thống gia phả. Khi chuyển nhượng thành công, bạn sẽ mất quyền chỉnh sửa cấu trúc dòng họ cao cấp và các thiết lập bảo mật.';
  @override
  String warningDialogConfirmMessage(String name) => 'Bạn có chắc chắn muốn chuyển giao quyền Trưởng tộc cho $name?';
  @override
  String get confirmTransferButton => 'ĐỒNG Ý CHUYỂN';
  @override
  String get transferSuccess => 'Chuyển nhượng quyền Trưởng tộc thành công!';
  @override
  String get transferProcessing => 'Đang xử lý chuyển nhượng...';

  @override
  String get memberRolesTitle => 'Phân quyền thành viên';
  @override
  String roleOfUser(String name) => 'Vai trò của $name';
  @override
  String get roleBranchAdminTitle => 'Trưởng chi';
  @override
  String get roleBranchAdminDesc => 'Quản lý nhân sự và nội dung của chi tộc.';
  @override
  String get roleEditorTitle => 'Biên tập viên';
  @override
  String get roleEditorDesc => 'Đóng góp và chỉnh sửa thông tin gia phả.';
  @override
  String get roleViewerTitle => 'Thành viên';
  @override
  String get roleViewerDesc => 'Chỉ được xem thông tin gia tộc.';
  @override
  String get updateRoleSuccess => 'Cập nhật vai trò thành công!';
  @override
  String get noMembers => 'Chưa có thành viên nào trong gia tộc.';
  @override
  String get cannotSelfChange => 'Bạn không thể tự thay đổi quyền của chính mình. Hãy dùng tính năng "Chuyển nhượng quyền Trưởng tộc".';

  @override
  String get accountInfoTitle => 'THÔNG TIN TÀI KHOẢN';
  @override
  String get emailAccountLabel => 'Email (Tài khoản)';
  @override
  String get noProfileLink => 'Chưa liên kết hồ sơ gia phả';
  @override
  String get noProfileLinkDesc => 'Tài khoản của bạn là Trưởng tộc nhưng chưa được liên kết với một thành viên nào trong cây gia phả. Hãy tạo hồ sơ ngay để bắt đầu quản lý phả hệ.';
  @override
  String get createProfileButton => 'TẠO HỒ SƠ GIA PHẢ';

  @override
  String get clanInfoSettingsTitle => 'THÔNG TIN DÒNG TỘC';
  @override
  String get basicInfoSectionTitle => 'Thông tin cơ bản';
  @override
  String get clanNameLabel => 'Tên dòng tộc';
  @override
  String get clanNameHint => 'Nhập tên dòng tộc của bạn';
  @override
  String get clanNameRequired => 'Vui lòng nhập tên dòng tộc';
  @override
  String get originLabel => 'Quê quán / Nguồn gốc';
  @override
  String get originHint => 'Nhập quê quán tổ tiên dòng tộc';
  @override
  String get originRequired => 'Vui lòng nhập địa chỉ nguồn gốc dòng tộc';
  @override
  String get clanDescLabel => 'Mô tả chi tiết';
  @override
  String get clanDescHint => 'Tóm tắt lịch sử, gia phong dòng họ';
  @override
  String get editTooltip => 'Chỉnh sửa';
  @override
  String get doneTooltip => 'Hoàn tất';
  @override
  String get noFamilyInfo => 'Không tìm thấy thông tin dòng họ để cập nhật';
  @override
  String get updateFamilySuccess => 'Cập nhật thông tin dòng tộc thành công!';

  @override
  String get regulationsTitle => 'QUY ĐỊNH & ĐIỀU KHOẢN';
  @override
  String get regulationTitle => 'Điều khoản sử dụng Gia Tộc Việt';
  @override
  String get regulationLastUpdated => 'Cập nhật lần cuối: Tháng 7, 2026';
  @override
  String get regSection1Title => 'Chấp thuận';
  @override
  String get regSection1Content => 'Khi tải và sử dụng Gia Tộc Việt, bạn đồng ý với các điều khoản dưới đây và Chính sách bảo mật của chúng tôi. Nếu không đồng ý, vui lòng không dùng ứng dụng.';
  @override
  String get regSection2Title => 'Giải thích từ ngữ';
  @override
  String get regSection2Content => '**Ứng dụng:** Gia Tộc Việt và các tính năng của ứng dụng.\n**Người dùng:** Cá nhân đã đăng ký tài khoản.\n**Dòng họ:** Nhóm thành viên do Trưởng tộc tạo lập, gồm chi tộc, thành viên và dữ liệu gia phả.\n**Trưởng tộc:** Người quản trị cao nhất của dòng họ.\n**Quản trị chi:** Người được ủy quyền quản lý một chi tộc.\n**Biên tập viên:** Người được phép thêm, sửa thông tin.\n**Thành viên:** Người có quyền xem gia phả.\n**Dữ liệu cá nhân:** Họ tên, ngày sinh, giới tính, quan hệ gia đình, hình ảnh, số điện thoại, email…';
  @override
  String get regSection3Title => 'Tài khoản';
  @override
  String get regSection3Content => '• Bạn phải đủ 18 tuổi hoặc có người giám hộ hợp pháp.\n• Bạn chịu trách nhiệm bảo vệ mật khẩu của mình.\n• Mỗi người chỉ được tạo một tài khoản, dùng cho mục đích cá nhân.\n• Thông tin đăng ký phải chính xác và trung thực.';
  @override
  String get regSection4Title => 'Quyền hạn theo vai trò';
  @override
  String get regSection4Content => '**Thành viên** – Xem gia phả, quỹ dòng họ, sửa thông tin cá nhân.\n**Biên tập viên** – Thêm, sửa thông tin thành viên (không được xóa).\n**Quản trị chi** – Quản lý chi tộc, phê duyệt yêu cầu, quản lý quỹ.\n**Trưởng tộc** – Toàn quyền quản trị, phân quyền, chuyển nhượng, giải tán.';
  @override
  String get regSection5Title => 'Quản trị dòng họ';
  @override
  String get regSection5Content => 'Trưởng tộc có toàn quyền: phê duyệt thành viên, phân vai trò, cập nhật thông tin, chuyển nhượng quyền Trưởng tộc và giải tán dòng họ. Khi chuyển nhượng, Trưởng tộc cũ trở thành Thành viên và không thể lấy lại quyền cũ. Mọi thao tác thêm, sửa, xóa trong hệ thống đều được ghi lại.';
  @override
  String get regSection6Title => 'Bảo mật dữ liệu';
  @override
  String get regSection6Content => 'Chúng tôi bảo vệ dữ liệu của bạn theo Luật An ninh mạng Việt Nam và Nghị định 13/2023/NĐ-CP. Dữ liệu được lưu tại máy chủ Việt Nam, mã hóa khi truyền tải và lưu trữ. Chúng tôi không bán dữ liệu của bạn cho bên thứ ba. Thông tin dòng họ chỉ hiển thị cho thành viên đã được phê duyệt.';
  @override
  String get regSection7Title => 'Sở hữu trí tuệ';
  @override
  String get regSection7Content => 'Gia Tộc Việt (mã nguồn, thiết kế, thương hiệu, logo) là tài sản của đơn vị phát triển, được bảo hộ theo pháp luật Việt Nam. Dữ liệu gia phả do người dùng tạo ra thuộc quyền sở hữu của dòng họ đó.';
  @override
  String get regSection8Title => 'Trách nhiệm';
  @override
  String get regSection8Content => 'Ứng dụng được cung cấp ở trạng thái hiện tại. Chúng tôi không chịu trách nhiệm nếu: (i) bạn sử dụng sai mục đích; (ii) thông tin bạn cung cấp không chính xác; (iii) Trưởng tộc chủ động xóa hoặc giải tán dòng họ. Nếu mất dữ liệu do lỗi hệ thống, chúng tôi sẽ cố gắng khôi phục.';
  @override
  String get regSection9Title => 'Xử lý vi phạm';
  @override
  String get regSection9Content => 'Chúng tôi có thể tạm khóa hoặc chấm dứt tài khoản nếu phát hiện vi phạm. Các mức xử lý: cảnh báo, tạm khóa, khóa vĩnh viễn hoặc thông báo cơ quan chức năng nếu vi phạm pháp luật. Trưởng tộc có thể giải tán dòng họ bất kỳ lúc nào — sau khi xác nhận, toàn bộ dữ liệu bị xóa vĩnh viễn và không thể khôi phục.';
  @override
  String get regSection10Title => 'Điều khoản chung';
  @override
  String get regSection10Content => 'Các điều khoản này được điều chỉnh theo pháp luật Việt Nam. Mọi tranh chấp được ưu tiên giải quyết qua thương lượng. Chúng tôi có thể sửa đổi điều khoản và sẽ thông báo trên ứng dụng. Nếu bạn tiếp tục dùng ứng dụng sau khi thay đổi, nghĩa là bạn đã chấp nhận điều khoản mới.';
  @override
  String get copyrightText => '© 2026 ThachDev. Bảo lưu mọi quyền.';

  @override
  String get helpCenterTitle => 'TRUNG TÂM HỖ TRỢ';
  @override
  String get contactSection => 'Liên hệ trực tiếp';
  @override
  String get hotlineTitle => 'Hotline hỗ trợ';
  @override
  String get hotlineValue => '1900 8888';
  @override
  String get hotlineSubtitle => '8:00 - 17:30 (T2-T6)';
  @override
  String get supportEmailTitle => 'Email hỗ trợ';
  @override
  String get supportEmailValue => 'thachhuynh.dev@gmail.com';
  @override
  String get supportEmailSubtitle => 'Phản hồi trong 24h';
  @override
  String get accountLoginSection => 'Tài khoản & Đăng nhập';
  @override
  String get genealogyMemberSection => 'Gia phả & Thành viên';
  @override
  String get clanAndRolesSection => 'Dòng tộc & Phân quyền';
  @override
  String get techSecuritySection => 'Kỹ thuật & Bảo mật';
  @override
  String get faqRegisterQuestion => 'Làm sao để đăng ký tài khoản?';
  @override
  String get faqRegisterAnswer => 'Tải ứng dụng Gia Tộc Việt từ CH Play (Android). Mở ứng dụng, nhấn "Đăng ký" và điền đầy đủ họ tên, email, số điện thoại và mật khẩu.';
  @override
  String get faqForgotPasswordQuestion => 'Tôi quên mật khẩu, phải làm sao?';
  @override
  String get faqForgotPasswordAnswer => 'Trên màn hình đăng nhập, nhấn "Quên mật khẩu". Nhập email đã đăng ký, hệ thống sẽ gửi mã OTP gồm 6 chữ số qua email. Nhập mã OTP để xác thực, sau đó tạo mật khẩu mới.';
  @override
  String get faqChangePasswordQuestion => 'Làm sao để đổi mật khẩu?';
  @override
  String get faqChangePasswordAnswer => 'Vào Cài đặt > Bảo mật tài khoản, nhập mật khẩu hiện tại, sau đó nhập mật khẩu mới và xác nhận. Mật khẩu mới phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số.';
  @override
  String get faqAddMemberQuestion => 'Làm sao để thêm thành viên mới?';
  @override
  String get faqAddMemberAnswer => 'Vào Dashboard > Quản lý thành viên, nhấn nút "Thêm thành viên". Điền đầy đủ thông tin: họ tên, giới tính, ngày sinh, nơi sinh, thế hệ, chi tộc, cha/mẹ (nếu có). Bạn có thể thêm thông tin chi tiết như ngày mất, tình trạng hôn nhân, số điện thoại, ghi chú. Nhấn "Lưu" để hoàn tất.';
  @override
  String get faqAddBranchQuestion => 'Làm sao để thêm nhánh (chi tộc) mới?';
  @override
  String get faqAddBranchAnswer => 'Vào Dashboard > Quản lý chi tộc, nhấn "Thêm chi tộc". Điền tên chi tộc, mô tả và thông tin người sáng lập (nếu có). Sau khi tạo, bạn có thể phân quyền Quản trị chi cho thành viên phụ trách nhánh đó.';
  @override
  String get faqEditMemberQuestion => 'Làm sao để chỉnh sửa thông tin thành viên?';
  @override
  String get faqEditMemberAnswer => 'Vào Dashboard > Quản lý thành viên, chọn thành viên cần chỉnh sửa. Nhấn vào biểu tượng chỉnh sửa (bút) để cập nhật thông tin. Lưu ý: chỉ Biên tập viên và các vai trò cao hơn mới có quyền chỉnh sửa.';
  @override
  String get faqDeleteMemberQuestion => 'Làm sao để xóa thành viên?';
  @override
  String get faqDeleteMemberAnswer => 'Chọn thành viên trong danh sách, nhấn biểu tượng xóa (thùng rác). Một hộp thoại xác nhận sẽ hiện ra. Lưu ý: chỉ Trưởng tộc và Quản trị chi mới có quyền xóa thành viên. Biên tập viên không có quyền này.';
  @override
  String get faqImportGenealogyQuestion => 'Nhập gia phả từ file được không?';
  @override
  String get faqImportGenealogyAnswer => 'Ứng dụng hiện hỗ trợ thêm từng thành viên thủ công. Tính năng nhập hàng loạt từ file đang được phát triển.';
  @override
  String get faqInviteCodeQuestion => 'Mã mời gia tộc hoạt động như thế nào?';
  @override
  String get faqInviteCodeAnswer => 'Mỗi Dòng tộc có một Mã mời duy nhất do hệ thống tạo. Trưởng tộc có thể xem, sao chép hoặc chia sẻ Mã mời qua QR code trong Dashboard. Thành viên mới nhập mã này khi đăng ký hoặc trong mục "Tham gia gia tộc" để gửi yêu cầu gia nhập. Trưởng tộc hoặc Quản trị chi sẽ phê duyệt yêu cầu trước khi thành viên có thể truy cập.';
  @override
  String get faqRolesQuestion => 'Các vai trò trong Dòng tộc là gì?';
  @override
  String get faqRolesAnswer => 'Hệ thống có 4 cấp vai trò:\n• Trưởng tộc — Quyền cao nhất, quản lý toàn bộ Dòng tộc, phân quyền và giải tán.\n• Quản trị chi — Quản lý một hoặc nhiều nhánh, phê duyệt yêu cầu gia nhập.\n• Biên tập viên — Thêm và chỉnh sửa thông tin thành viên, không được xóa.\n• Thành viên — Xem thông tin gia phả, không được chỉnh sửa.';
  @override
  String get faqAssignRoleQuestion => 'Làm sao để phân quyền cho thành viên?';
  @override
  String get faqAssignRoleAnswer => 'Vào Cài đặt > Phân quyền thành viên (chỉ Trưởng tộc mới thấy mục này). Chọn thành viên cần thay đổi vai trò và chọn cấp quyền tương ứng. Trưởng tộc không thể tự hạ cấp vai trò của mình — cần sử dụng tính năng Chuyển nhượng quyền Trưởng tộc.';
  @override
  String get faqTransferOwnershipQuestion => 'Làm sao để chuyển nhượng quyền Trưởng tộc?';
  @override
  String get faqTransferOwnershipAnswer => 'Vào Cài đặt > Chuyển nhượng quyền Trưởng tộc. Chọn thành viên đã kích hoạt tài khoản từ danh sách. Xác nhận chuyển nhượng — thao tác này không thể hoàn tác. Sau khi chuyển nhượng, bạn sẽ trở thành Thành viên và người nhận trở thành Trưởng tộc mới.';
  @override
  String get faqDissolveClanQuestion => 'Làm sao để giải tán dòng tộc?';
  @override
  String get faqDissolveClanAnswer => 'Vào Cài đặt > Giải tán dòng họ (chỉ Trưởng tộc). Gõ chính xác tên Dòng tộc để xác nhận. Toàn bộ dữ liệu bao gồm thành viên, nhánh, gia phả và quỹ gia tộc sẽ bị xóa vĩnh viễn khỏi hệ thống và không thể khôi phục. Cân nhắc kỹ trước khi thực hiện.';
  @override
  String get faqDataSecurityQuestion => 'Dữ liệu gia phả của tôi có được bảo mật không?';
  @override
  String get faqDataSecurityAnswer => 'Có. Toàn bộ dữ liệu được lưu trữ trên máy chủ đặt tại Việt Nam, áp dụng mã hóa đầu cuối TLS 1.3 khi truyền tải và mã hóa AES-256 khi lưu trữ. Chúng tôi tuân thủ nghiêm ngặt Nghị định 13/2023/NĐ-CP về bảo vệ dữ liệu cá nhân và cam kết không bán, chia sẻ dữ liệu cho bên thứ ba.';
  @override
  String get faqDeleteAccountQuestion => 'Làm sao để xóa tài khoản?';
  @override
  String get faqDeleteAccountAnswer => 'Vào Cài đặt > Bảo mật tài khoản, chọn "Xóa tài khoản". Xác nhận yêu cầu xóa. Dữ liệu cá nhân của bạn sẽ được xóa khỏi hệ thống trong vòng 30 ngày. Lưu ý: nếu bạn là Trưởng tộc, cần chuyển nhượng quyền Trưởng tộc hoặc giải tán Dòng tộc trước khi xóa tài khoản.';
  @override
  String get faqMultiDeviceQuestion => 'Tôi có thể sử dụng ứng dụng trên nhiều thiết bị không?';
  @override
  String get faqMultiDeviceAnswer => 'Có. Tài khoản của bạn có thể đăng nhập trên nhiều thiết bị cùng lúc. Dữ liệu sẽ được đồng bộ hóa theo thời gian thực. Tuy nhiên, vì lý do bảo mật, bạn nên đăng xuất khỏi thiết bị không sử dụng.';
  @override
  String get faqEnglishSupportQuestion => 'Ứng dụng có hỗ trợ tiếng Anh không?';
  @override
  String get faqEnglishSupportAnswer => 'Có. Vào Cài đặt > Ngôn ngữ, chuyển đổi giữa Tiếng Việt và Tiếng Anh. Giao diện sẽ cập nhật ngay lập tức. Dữ liệu gia phả và thông tin thành viên vẫn được giữ nguyên.';

  @override
  String get aboutUsTitle => 'VỀ CHÚNG TÔI';
  @override
  String get aboutUsTagline => 'Gia Tộc Việt giúp bạn gìn giữ cây gia phả dòng họ trên nền tảng số, kết nối các thế hệ dù ở bất kỳ nơi đâu. Từ ông bà tổ tiên đến con cháu hôm nay — tất cả đều trong tầm tay.';
  @override
  String get versionLabel => 'Phiên bản';
  @override
  String get developerLabel => 'Nhà phát triển';
  @override
  String get contactEmailLabel => 'Email';

  @override
  String get adminDashboardTitle => 'BẢNG QUẢN TRỊ';
  @override
  String get roleOwner => 'TRƯỞNG TỘC';
  @override
  String get roleBranchAdmin => 'TRƯỞNG CHI';
  @override
  String get roleEditor => 'BIÊN TẬP VIÊN';
  @override
  String get roleViewer => 'THÀNH VIÊN';
  @override
  String get memberListTitle => 'DANH SÁCH THÀNH VIÊN';
  @override
  String get branchListTitle => 'DANH SÁCH CHI TỘC';
  @override
  String get pendingRequestTitle => 'YÊU CẦU CHỜ DUYỆT';
  @override
  String get searchMembersHint => 'Tìm kiếm thành viên hoặc chi tộc...';
  @override
  String get searchBranchesHint => 'Tìm kiếm chi tộc...';
  @override
  String get emptyMembers => 'Không tìm thấy thành viên phù hợp';
  @override
  String get emptyBranches => 'Không tìm thấy chi tộc phù hợp';
  @override
  String get emptyPendingRequests => 'Không có yêu cầu tham gia nào đang chờ duyệt';
  @override
  String get addMemberLabel => 'Thêm thành viên';
  @override
  String get addBranchLabel => 'Thêm chi tộc';
  @override
  String get statMembers => 'THÀNH VIÊN';
  @override
  String get statBranches => 'CHI TỘC';
  @override
  String get statPending => 'CHỜ DUYỆT';
  @override
  String get inviteCodeSectionLabel => 'MÃ THAM GIA GIA TỘC';
  @override
  String inviteCodeCopied(String code) => 'Đã sao chép mã mời: $code';
  @override
  String get copyCodeTooltip => 'Sao chép mã';
  @override
  String get qrCodeTooltip => 'Mã QR';
  @override
  String get qrDialogTitle => 'Mã QR Gia Tộc';
  @override
  String get qrSaved => 'Đã lưu QR vào thư viện ảnh!';
  @override
  String get qrSaveError => 'Không thể lưu ảnh. Vui lòng cấp quyền thư viện ảnh.';
  @override
  String get downloadLabel => 'Tải xuống';
  @override
  String get shareLabel => 'Chia sẻ';
  @override
  String get viewAllLabel => 'Xem tất cả';
  @override
  String get addNewLabel => 'Thêm mới';
  @override
  String get aliveLabel => 'Còn sống';
  @override
  String get deceasedLabel => 'Đã mất';
  @override
  String generationBadge(String gen) => 'Đời thứ $gen';
  @override
  String branchBadge(String name) => 'Chi tộc: $name';
  @override
  String get editLabel => 'Chỉnh sửa';
  @override
  String get deleteLabel => 'Xoá';
  @override
  String memberCountBadge(int count) => '$count thành viên';
  @override
  String founderBadge(String name) => 'Đời tổ/Sáng lập: $name';
  @override
  String get anonymousUser => 'Người dùng ẩn danh';
  @override
  String get noEmail => 'Không có email';
  @override
  String get approveButton => 'Phê duyệt';
  @override
  String get rejectButton => 'Từ chối';
  @override
  String get approveSuccess => 'Đã phê duyệt yêu cầu thành công!';
  @override
  String get rejectSuccess => 'Đã từ chối yêu cầu thành công!';
  @override
  String get deleteMemberSuccess => 'Đã xoá thành viên thành công!';
  @override
  String get saveMemberSuccess => 'Đã lưu thông tin thành viên!';
  @override
  String get deleteBranchSuccess => 'Đã xoá chi tộc thành công!';
  @override
  String get saveBranchSuccess => 'Đã lưu thông tin chi tộc!';
  @override
  String get deleteMemberTitle => 'Xác nhận xoá';
  @override
  String deleteMemberMessage(String name) => 'Bạn có chắc chắn muốn xoá thành viên $name khỏi gia phả không?';
  @override
  String get deleteBranchTitle => 'Xác nhận xoá chi tộc';
  @override
  String deleteBranchMessage(String name) => 'Bạn có chắc chắn muốn xoá chi tộc $name? Tất cả thành viên thuộc chi này sẽ mất liên kết chi tộc.';
  @override
  String get saveBranchLabel => 'LƯU CHI TỘC';
  @override
  String get editBranchTitle => 'SỬA CHI TỘC';
  @override
  String get addBranchTitle => 'THÊM CHI TỘC';
  @override
  String get deleteBranchTooltip => 'Xóa chi tộc';
  @override
  String get basicInfoTitle => 'THÔNG TIN CƠ BẢN';
  @override
  String get branchNameLabel => 'Tên chi tộc';
  @override
  String get branchNameHint => 'VD: Chi Trưởng, Chi Hai...';
  @override
  String get branchNameRequired => 'Tên chi tộc';
  @override
  String get branchNameEmptyError => 'Không được để trống';
  @override
  String get founderNameLabel => 'Tên tổ chi';
  @override
  String get addMemberPlaceholder => '✦ Thêm thành viên mới...';
  @override
  String get noSelectionLabel => 'Không chọn';
  @override
  String get manualInputLabel => 'Tên tổ chi (Tự nhập)';
  @override
  String get founderNameHint => 'Người lập chi (tùy chọn)';
  @override
  String get inputModeLabel => 'Tự nhập tên';
  @override
  String get selectModeLabel => 'Chọn từ danh sách';
  @override
  String get foundationYearLabel => 'Năm lập chi';
  @override
  String get foundationYearHint => 'VD: 1980';
  @override
  String get locationLabel => 'Địa phương';
  @override
  String get locationHint => 'VD: Làng X, Huyện Y';
  @override
  String get branchDescLabel => 'Mô tả chi tộc';
  @override
  String get branchDescHint => 'Nhập thêm thông tin mô tả chi tiết...';
  @override
  String get deleteBranchConfirmTitle => 'Xác Nhận Xóa';
  @override
  String deleteBranchConfirmMessage(String name) => 'Bạn có chắc chắn muốn xoá chi tộc $name không?';
  @override
  String get editMemberTitle => 'SỬA THÀNH VIÊN';
  @override
  String get addMemberTitle => 'THÊM THÀNH VIÊN';
  @override
  String get linkAccountSuccess => 'Đã tạo và liên kết hồ sơ gia phả thành công!';
  @override
  String linkAccountError(String msg) => 'Tạo hồ sơ thành công nhưng không thể liên kết tài khoản: $msg';
  @override
  String get nameHint => 'Nhập họ và tên';
  @override
  String get maritalStatusLabel => 'HÔN NHÂN';
  @override
  String get maritalSingle => 'Độc thân';
  @override
  String get maritalMarried => 'Đã kết hôn';
  @override
  String get maritalDivorced => 'Ly hôn';
  @override
  String get maritalWidowed => 'Góa phụ';
  @override
  String get maritalUnknown => 'Chưa rõ';
  @override
  String get genderLabel => 'GIỚI TÍNH';
  @override
  String get genderMale => 'Nam';
  @override
  String get genderFemale => 'Nữ';
  @override
  String get genderUnknown => 'Chưa rõ';
  @override
  String get dobLabel => 'Ngày sinh';
  @override
  String get dobHint => 'dd/mm/yyyy';
  @override
  String get statusLabel => 'TÌNH TRẠNG';
  @override
  String get dodLabel => 'Ngày mất';
  @override
  String get dodHint => 'dd/mm/yyyy';
  @override
  String get phoneLabel => 'Số điện thoại';
  @override
  String get phoneHint => '0xxxxxxxxx';
  @override
  String get addressLabel => 'Quê quán / Địa chỉ';
  @override
  String get addressHint => 'Nhập thông tin quê quán, nơi ở...';
  @override
  String get parentLabel => 'CHA/MẸ';
  @override
  String get spouseLabel => 'VỢ/CHỒNG';
  @override
  String get branchSectionLabel => 'CHI/NHÁNH';
  @override
  String get noBranchLabel => 'Không thuộc chi nào';
  @override
  String parentBranchMarker(String name) => '$name ✦ (Chi của cha/mẹ)';
  @override
  String get bioLabel => 'Tiểu sử';
  @override
  String get bioHint => 'Nhập thông tin nghề nghiệp, học vấn hoặc cột mốc quan trọng...';
  @override
  String get uploadPhotoLabel => 'TẢI ẢNH ĐẠI DIỆN';
  @override
  String get generationFieldLabel => 'Thế hệ';
  @override
  String get generationFieldHint => 'VD: 3';
  @override
  String familyNameFormat(String name) => '$name Gia Tộc';
  @override
  String get notLoggedIn => 'Người dùng chưa đăng nhập';
  @override
  String get sessionTokenError => 'Không thể lấy mã xác thực phiên đăng nhập';
  @override
  String get passwordChangeFailed => 'Thay đổi mật khẩu thất bại';
  @override
  String get serverConnectionError => 'Lỗi kết nối máy chủ';
  @override
  String get emailSubjectHelp => 'Hỗ Trợ Gia Tộc Việt';
}
