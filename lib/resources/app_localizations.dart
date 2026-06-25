import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'resources/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @loginTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng Nhập'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Kết nối với cội nguồn dòng tộc của bạn'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In vi, this message translates to:
  /// **'email@example.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In vi, this message translates to:
  /// **'••••••••'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get loginButton;

  /// No description provided for @orDivider.
  ///
  /// In vi, this message translates to:
  /// **'Hoặc'**
  String get orDivider;

  /// No description provided for @googleLoginButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập với Google'**
  String get googleLoginButton;

  /// No description provided for @noAccountText.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài khoản? '**
  String get noAccountText;

  /// No description provided for @registerNow.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký ngay'**
  String get registerNow;

  /// No description provided for @rememberMe.
  ///
  /// In vi, this message translates to:
  /// **'Ghi nhớ mật khẩu'**
  String get rememberMe;

  /// No description provided for @registerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng Ký'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản gia phả dòng tộc của bạn'**
  String get registerSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Nguyễn Văn A'**
  String get fullNameHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'••••••••'**
  String get confirmPasswordHint;

  /// No description provided for @registerButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get registerButton;

  /// No description provided for @alreadyHaveAccountText.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản? '**
  String get alreadyHaveAccountText;

  /// No description provided for @loginNow.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập ngay'**
  String get loginNow;

  /// No description provided for @registerAsCreator.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký với tư cách Trưởng tộc'**
  String get registerAsCreator;

  /// No description provided for @acceptTermsText.
  ///
  /// In vi, this message translates to:
  /// **'Tôi đồng ý với '**
  String get acceptTermsText;

  /// No description provided for @termsOfService.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản dịch vụ'**
  String get termsOfService;

  /// No description provided for @andText.
  ///
  /// In vi, this message translates to:
  /// **' và '**
  String get andText;

  /// No description provided for @privacyPolicy.
  ///
  /// In vi, this message translates to:
  /// **'Chính sách bảo mật'**
  String get privacyPolicy;

  /// No description provided for @termsValidationErr.
  ///
  /// In vi, this message translates to:
  /// **'Bạn phải đồng ý với Điều khoản dịch vụ và Chính sách bảo mật để tiếp tục'**
  String get termsValidationErr;

  /// No description provided for @termsContent.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng bạn đến với Gia Tộc Việt. Khi sử dụng dịch vụ của chúng tôi, bạn đồng ý với các điều khoản dưới đây:\n\n1. Quy định tài khoản: Bạn chịu trách nhiệm bảo mật thông tin tài khoản và mật khẩu của mình.\n\n2. Quyền sở hữu dữ liệu: Thông tin gia phả do dòng họ đóng góp thuộc quyền sở hữu chung của các thành viên được cấp quyền trong dòng họ.\n\n3. Hành vi bị cấm: Không đăng tải nội dung xuyên tạc lịch sử, thông tin sai sự thật hoặc xâm phạm đời tư của người khác.\n\n4. Thay đổi điều khoản: Chúng tôi có quyền cập nhật điều khoản dịch vụ để phù hợp hơn với hoạt động của hệ thống.'**
  String get termsContent;

  /// No description provided for @privacyContent.
  ///
  /// In vi, this message translates to:
  /// **'Gia Tộc Việt cam kết bảo vệ thông tin riêng tư của gia đình bạn:\n\n1. Thu thập dữ liệu: Chúng tôi thu thập họ tên, email, ảnh đại diện, và dữ liệu phả hệ do bạn chủ động cung cấp.\n\n2. Sử dụng thông tin: Dữ liệu được sử dụng để xây dựng sơ đồ cây gia phả, kết nối các thành viên và thông báo các sự kiện dòng họ.\n\n3. Bảo mật: Chúng tôi áp dụng các biện pháp bảo mật hiện đại để ngăn chặn rò rỉ dữ liệu.\n\n4. Chia sẻ dữ liệu: Chúng tôi tuyệt đối không bán hoặc chia sẻ dữ liệu gia phả của bạn cho bất kỳ bên thứ ba nào vì mục đích quảng cáo.'**
  String get privacyContent;

  /// No description provided for @closeButton.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get closeButton;

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gia Tộc Việt'**
  String get appTitle;

  /// No description provided for @confirmLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirmLabel;

  /// No description provided for @cancelLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancelLabel;

  /// No description provided for @okLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get okLabel;

  /// No description provided for @loadingMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đang xử lý...'**
  String get loadingMessage;

  /// No description provided for @emailLoginFeatureNotice.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng Đăng nhập Email đang được phát triển. Vui lòng sử dụng Đăng nhập với Google.'**
  String get emailLoginFeatureNotice;

  /// No description provided for @forgotPasswordNotice.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng liên hệ Chủ quản dòng họ để được cấp lại mật khẩu.'**
  String get forgotPasswordNotice;

  /// No description provided for @enterInviteCodeWarning.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mã mời'**
  String get enterInviteCodeWarning;

  /// No description provided for @onboardingTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thiết Lập Gia Tộc'**
  String get onboardingTitle;

  /// No description provided for @logoutTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logoutTooltip;

  /// No description provided for @createFamilySuccess.
  ///
  /// In vi, this message translates to:
  /// **'Tạo dòng họ thành công!'**
  String get createFamilySuccess;

  /// No description provided for @verifyInviteSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực mã mời thành công: {familyName}'**
  String verifyInviteSuccess(String familyName);

  /// No description provided for @joinRequestSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu tham gia đã gửi thành công!'**
  String get joinRequestSuccess;

  /// No description provided for @pendingApprovalTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đang Chờ Phê Duyệt'**
  String get pendingApprovalTitle;

  /// No description provided for @pendingApprovalMessage.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu tham gia dòng họ đã được gửi đi thành công. Vui lòng liên hệ Trưởng tộc hoặc Người quản trị dòng họ để được phê duyệt.'**
  String get pendingApprovalMessage;

  /// No description provided for @checkStatusButton.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra trạng thái'**
  String get checkStatusButton;

  /// No description provided for @welcomeCreatorTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chào Trưởng tộc, {name}!'**
  String welcomeCreatorTitle(String name);

  /// No description provided for @welcomeCreatorSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhập thông tin bên dưới để bắt đầu khởi tạo cây gia phả dòng tộc của bạn.'**
  String get welcomeCreatorSubtitle;

  /// No description provided for @familyNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên Gia tộc'**
  String get familyNameLabel;

  /// No description provided for @familyNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: Nguyễn Gia Tộc'**
  String get familyNameHint;

  /// No description provided for @familyNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Tên dòng họ không được để trống'**
  String get familyNameRequired;

  /// No description provided for @familyDescriptionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả Gia Tộc'**
  String get familyDescriptionLabel;

  /// No description provided for @familyDescriptionHint.
  ///
  /// In vi, this message translates to:
  /// **'Quê quán, nguồn gốc gia tộc...'**
  String get familyDescriptionHint;

  /// No description provided for @initFamilyButton.
  ///
  /// In vi, this message translates to:
  /// **'KHỞI TẠO GIA TỘC'**
  String get initFamilyButton;

  /// No description provided for @welcomeViewerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chào {name}!'**
  String welcomeViewerTitle(String name);

  /// No description provided for @welcomeViewerSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhập Mã mời do Trưởng tộc cung cấp để gia nhập và xem cây gia phả dòng tộc.'**
  String get welcomeViewerSubtitle;

  /// No description provided for @inviteCodeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mã Mời Gia Tộc'**
  String get inviteCodeLabel;

  /// No description provided for @inviteCodeHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã 6 ký tự'**
  String get inviteCodeHint;

  /// No description provided for @verifyButton.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực'**
  String get verifyButton;

  /// No description provided for @familyFoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tìm thấy gia tộc: {name}'**
  String familyFoundTitle(String name);

  /// No description provided for @selectMemberPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Chọn tên của bạn trong danh sách dưới đây để liên kết với cây gia phả (nếu có):'**
  String get selectMemberPrompt;

  /// No description provided for @whoAreYouDropdownHint.
  ///
  /// In vi, this message translates to:
  /// **'Bạn là ai trên cây gia phả?'**
  String get whoAreYouDropdownHint;

  /// No description provided for @sendJoinRequestButton.
  ///
  /// In vi, this message translates to:
  /// **'GỬI YÊU CẦU GIA NHẬP'**
  String get sendJoinRequestButton;

  /// No description provided for @chooseOnboardingSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn một phương thức thiết lập gia phả để bắt đầu kết nối dòng tộc của bạn.'**
  String get chooseOnboardingSubtitle;

  /// No description provided for @createFamilyCardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khởi tạo Gia tộc mới'**
  String get createFamilyCardTitle;

  /// No description provided for @createFamilyCardDesc.
  ///
  /// In vi, this message translates to:
  /// **'Dành cho Trưởng tộc, người lập phả muốn xây dựng một cây gia phả mới hoàn toàn.'**
  String get createFamilyCardDesc;

  /// No description provided for @joinFamilyCardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kết nối dòng tộc'**
  String get joinFamilyCardTitle;

  /// No description provided for @joinFamilyCardDesc.
  ///
  /// In vi, this message translates to:
  /// **'Dành cho thành viên đã có mã mời từ Trưởng tộc để xem và cập nhật cây gia phả.'**
  String get joinFamilyCardDesc;

  /// No description provided for @errEmailRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập địa chỉ email'**
  String get errEmailRequired;

  /// No description provided for @errEmailInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Email không đúng định dạng (Ví dụ: ten@gmail.com)'**
  String get errEmailInvalid;

  /// No description provided for @errPasswordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu'**
  String get errPasswordRequired;

  /// No description provided for @errPasswordMinLength.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu phải chứa ít nhất 6 ký tự'**
  String get errPasswordMinLength;

  /// No description provided for @errStrongPasswordMinLength.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu bảo mật phải có ít nhất 8 ký tự'**
  String get errStrongPasswordMinLength;

  /// No description provided for @errStrongPasswordUppercase.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu cần ít nhất 1 chữ cái viết hoa'**
  String get errStrongPasswordUppercase;

  /// No description provided for @errStrongPasswordNumber.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu cần ít nhất 1 chữ số'**
  String get errStrongPasswordNumber;

  /// No description provided for @errStrongPasswordSpecialChar.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu cần ít nhất 1 ký tự đặc biệt (!@#...)'**
  String get errStrongPasswordSpecialChar;

  /// No description provided for @errConfirmPasswordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng xác nhận lại mật khẩu'**
  String get errConfirmPasswordRequired;

  /// No description provided for @errConfirmPasswordMismatch.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu xác nhận không khớp'**
  String get errConfirmPasswordMismatch;

  /// No description provided for @errFullNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập họ và tên'**
  String get errFullNameRequired;

  /// No description provided for @errFullNameTooShort.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên quá ngắn'**
  String get errFullNameTooShort;

  /// No description provided for @errFullNameTooLong.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên không được vượt quá 50 ký tự'**
  String get errFullNameTooLong;

  /// No description provided for @errFullNameInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên chỉ được chứa chữ cái và khoảng trắng'**
  String get errFullNameInvalid;

  /// No description provided for @errPhoneNumberRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập số điện thoại'**
  String get errPhoneNumberRequired;

  /// No description provided for @errPhoneNumberInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại không hợp lệ (Ví dụ: 0912345678)'**
  String get errPhoneNumberInvalid;

  /// No description provided for @errYearRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập năm'**
  String get errYearRequired;

  /// No description provided for @errYearInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập số năm hợp lệ'**
  String get errYearInvalid;

  /// No description provided for @errYearFuture.
  ///
  /// In vi, this message translates to:
  /// **'Năm không thể lớn hơn năm hiện tại ({year})'**
  String errYearFuture(int year);

  /// No description provided for @errYearMin.
  ///
  /// In vi, this message translates to:
  /// **'Năm phải lớn hơn hoặc bằng {year}'**
  String errYearMin(int year);

  /// No description provided for @errYearTooSmall.
  ///
  /// In vi, this message translates to:
  /// **'Năm quá nhỏ (yêu cầu từ năm 1000 trở đi)'**
  String get errYearTooSmall;

  /// No description provided for @errRequiredField.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập {fieldName}'**
  String errRequiredField(String fieldName);

  /// No description provided for @errServer.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống đang gặp sự cố tạm thời. Vui lòng thử lại sau ít phút.'**
  String get errServer;

  /// No description provided for @errNetwork.
  ///
  /// In vi, this message translates to:
  /// **'Không có kết nối mạng. Vui lòng kiểm tra lại Wi-Fi hoặc dữ liệu di động.'**
  String get errNetwork;

  /// No description provided for @errCache.
  ///
  /// In vi, this message translates to:
  /// **'Không thể truy xuất dữ liệu lưu tạm trên thiết bị. Vui lòng tải lại trang.'**
  String get errCache;

  /// No description provided for @errNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thông tin yêu cầu hoặc dữ liệu đã bị xóa.'**
  String get errNotFound;

  /// No description provided for @errValidation.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin nhập vào chưa chính xác. Vui lòng kiểm tra lại.'**
  String get errValidation;

  /// No description provided for @errUnknown.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại sau.'**
  String get errUnknown;

  /// No description provided for @errAuth.
  ///
  /// In vi, this message translates to:
  /// **'Phiên đăng nhập đã hết hạn hoặc tài khoản/mật khẩu không chính xác. Vui lòng đăng nhập lại.'**
  String get errAuth;

  /// No description provided for @errPermission.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản của bạn không có quyền thực hiện chức năng này.'**
  String get errPermission;

  /// No description provided for @errTimeout.
  ///
  /// In vi, this message translates to:
  /// **'Kết nối mạng quá chậm hoặc bị gián đoạn. Vui lòng thử lại.'**
  String get errTimeout;

  /// No description provided for @retryButton.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retryButton;

  /// No description provided for @errStateTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi'**
  String get errStateTitle;

  /// No description provided for @qrScannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quét mã QR'**
  String get qrScannerTitle;

  /// No description provided for @qrScannerInstruction.
  ///
  /// In vi, this message translates to:
  /// **'Đặt mã QR vào trong khung hình để thực hiện quét tự động'**
  String get qrScannerInstruction;

  /// No description provided for @qrScannerNoCodeFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy mã QR nào trong bức ảnh này.'**
  String get qrScannerNoCodeFound;

  /// No description provided for @qrScannerSelectImageError.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi khi chọn ảnh.'**
  String get qrScannerSelectImageError;

  /// No description provided for @tapToChangePhoto.
  ///
  /// In vi, this message translates to:
  /// **'NHẤN ĐỂ THAY ĐỔI ẢNH'**
  String get tapToChangePhoto;

  /// No description provided for @tapToUploadPhoto.
  ///
  /// In vi, this message translates to:
  /// **'NHẤN ĐỂ TẢI ẢNH LÊN'**
  String get tapToUploadPhoto;

  /// No description provided for @byInitAgreeTerms.
  ///
  /// In vi, this message translates to:
  /// **'BẰNG CÁCH NHẤN KHỞI TẠO, BẠN ĐỒNG Ý VỚI '**
  String get byInitAgreeTerms;

  /// No description provided for @appTerms.
  ///
  /// In vi, this message translates to:
  /// **'CÁC ĐIỀU KHOẢN CỦA GIA TỘC VIỆT'**
  String get appTerms;

  /// No description provided for @enterInviteCodeLabel.
  ///
  /// In vi, this message translates to:
  /// **'NHẬP MÃ THAM GIA'**
  String get enterInviteCodeLabel;

  /// No description provided for @inviteCodeHintNew.
  ///
  /// In vi, this message translates to:
  /// **'VD: HGT-2024'**
  String get inviteCodeHintNew;

  /// No description provided for @inviteCodeDescription.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã định danh 9 ký tự được cung cấp bởi trưởng tộc hoặc người quản lý gia tộc.'**
  String get inviteCodeDescription;

  /// No description provided for @confirmJoinButton.
  ///
  /// In vi, this message translates to:
  /// **'XÁC NHẬN THAM GIA'**
  String get confirmJoinButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
