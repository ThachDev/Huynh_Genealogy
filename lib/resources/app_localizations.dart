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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
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
  /// **'OK'**
  String get okLabel;

  /// No description provided for @loadingMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đang xử lý...'**
  String get loadingMessage;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email đã đăng ký để nhận mã xác thực đặt lại mật khẩu.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In vi, this message translates to:
  /// **'Gửi mã xác thực'**
  String get forgotPasswordButton;

  /// No description provided for @backToLogin.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại đăng nhập'**
  String get backToLogin;

  /// No description provided for @otpTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực OTP'**
  String get otpTitle;

  /// No description provided for @otpSubtitleStart.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi đã gửi mã xác thực 6 số đến email '**
  String get otpSubtitleStart;

  /// No description provided for @otpSubtitleEnd.
  ///
  /// In vi, this message translates to:
  /// **'. Vui lòng kiểm tra hộp thư và nhập mã.'**
  String get otpSubtitleEnd;

  /// No description provided for @otpLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mã xác thực'**
  String get otpLabel;

  /// No description provided for @otpHint.
  ///
  /// In vi, this message translates to:
  /// **'123456'**
  String get otpHint;

  /// No description provided for @otpRequiredError.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mã OTP'**
  String get otpRequiredError;

  /// No description provided for @otpInvalidError.
  ///
  /// In vi, this message translates to:
  /// **'Mã OTP phải có 6 chữ số'**
  String get otpInvalidError;

  /// No description provided for @otpVerifyButton.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực'**
  String get otpVerifyButton;

  /// No description provided for @otpResendButton.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại mã'**
  String get otpResendButton;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu mới cho tài khoản của bạn.'**
  String get resetPasswordSubtitle;

  /// No description provided for @resetPasswordButton.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại mật khẩu'**
  String get resetPasswordButton;

  /// No description provided for @resetPasswordSuccessTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thành công!'**
  String get resetPasswordSuccessTitle;

  /// No description provided for @resetPasswordSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu của bạn đã được đặt lại. Vui lòng đăng nhập lại bằng mật khẩu mới.'**
  String get resetPasswordSuccessMessage;

  /// No description provided for @newPasswordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới'**
  String get newPasswordLabel;

  /// No description provided for @enterInviteCodeWarning.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mã mời'**
  String get enterInviteCodeWarning;

  /// No description provided for @onboardingTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thiết lập gia tộc'**
  String get onboardingTitle;

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
  /// **'Đang chờ phê duyệt'**
  String get pendingApprovalTitle;

  /// No description provided for @pendingApprovalMessage.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu tham gia dòng họ đã được gửi đi thành công. Vui lòng đợi quản trị phê duyệt hoặc liên hệ Trưởng tộc {clanLeaderName} - {clanLeaderPhone} để phê duyệt.'**
  String pendingApprovalMessage(String clanLeaderName, String clanLeaderPhone);

  /// No description provided for @pendingApprovalMessageSimple.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu tham gia dòng họ đã được gửi đi thành công. Vui lòng đợi quản trị phê duyệt để được tham gia dòng họ.'**
  String get pendingApprovalMessageSimple;

  /// No description provided for @checkStatusButton.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra trạng thái'**
  String get checkStatusButton;

  /// No description provided for @familyNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên gia tộc'**
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
  /// **'Mô tả gia tộc'**
  String get familyDescriptionLabel;

  /// No description provided for @familyDescriptionHint.
  ///
  /// In vi, this message translates to:
  /// **'Quê quán, nguồn gốc gia tộc...'**
  String get familyDescriptionHint;

  /// No description provided for @initFamilyButton.
  ///
  /// In vi, this message translates to:
  /// **'Khởi tạo gia tộc'**
  String get initFamilyButton;

  /// No description provided for @initFamilySectionDesc.
  ///
  /// In vi, this message translates to:
  /// **'Khởi tạo cây gia phả số ngay hôm nay để kết nối các thế hệ và gìn giữ nguồn cội của dòng họ.'**
  String get initFamilySectionDesc;

  /// No description provided for @initFamilySectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khởi tạo gia tộc mới'**
  String get initFamilySectionTitle;

  /// No description provided for @welcomeViewerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chào {name}!'**
  String welcomeViewerTitle(String name);

  /// No description provided for @welcomeViewerSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã mời do Trưởng tộc cung cấp để gia nhập và xem cây gia phả dòng tộc.'**
  String get welcomeViewerSubtitle;

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

  /// No description provided for @sendJoinRequestButton.
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu gia nhập'**
  String get sendJoinRequestButton;

  /// No description provided for @chooseOnboardingSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn một phương thức thiết lập gia phả để bắt đầu kết nối dòng tộc của bạn.'**
  String get chooseOnboardingSubtitle;

  /// No description provided for @createFamilyCardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khởi tạo gia tộc mới'**
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

  /// No description provided for @familyPhotoSectionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh đại diện dòng họ'**
  String get familyPhotoSectionLabel;

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
  /// **'Nhấn để thay đổi ảnh'**
  String get tapToChangePhoto;

  /// No description provided for @tapToUploadPhoto.
  ///
  /// In vi, this message translates to:
  /// **'Nhấn để tải ảnh lên'**
  String get tapToUploadPhoto;

  /// No description provided for @byInitAgreeTerms.
  ///
  /// In vi, this message translates to:
  /// **'Bằng cách nhấn Khởi tạo, bạn đồng ý với '**
  String get byInitAgreeTerms;

  /// No description provided for @appTerms.
  ///
  /// In vi, this message translates to:
  /// **'Các điều khoản của Gia Tộc Việt'**
  String get appTerms;

  /// No description provided for @enterInviteCodeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã tham gia'**
  String get enterInviteCodeLabel;

  /// No description provided for @inviteCodeHintNew.
  ///
  /// In vi, this message translates to:
  /// **'VD: HGT-2024'**
  String get inviteCodeHintNew;

  /// No description provided for @inviteCodeDescription.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã định danh 6 ký tự được cung cấp bởi trưởng tộc hoặc người quản lý gia tộc.'**
  String get inviteCodeDescription;

  /// No description provided for @copiedShareContent.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép nội dung chia sẻ!'**
  String get copiedShareContent;

  /// No description provided for @creationSuccessTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khởi tạo thành công'**
  String get creationSuccessTitle;

  /// No description provided for @confirmJoinButton.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận tham gia'**
  String get confirmJoinButton;

  /// No description provided for @navOverview.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan'**
  String get navOverview;

  /// No description provided for @navFamilyTree.
  ///
  /// In vi, this message translates to:
  /// **'Cây gia phả'**
  String get navFamilyTree;

  /// No description provided for @navEvents.
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện'**
  String get navEvents;

  /// No description provided for @errGenerationRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập thế hệ'**
  String get errGenerationRequired;

  /// No description provided for @errGenerationMustBeNumber.
  ///
  /// In vi, this message translates to:
  /// **'Thế hệ phải là số'**
  String get errGenerationMustBeNumber;

  /// No description provided for @errPlaceOfBirthRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập quê quán'**
  String get errPlaceOfBirthRequired;

  /// No description provided for @errDateOfBirthRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn ngày sinh'**
  String get errDateOfBirthRequired;

  /// No description provided for @errDateOfDeathRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn ngày mất'**
  String get errDateOfDeathRequired;

  /// No description provided for @formSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu lại'**
  String get formSave;

  /// No description provided for @formCancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy bỏ'**
  String get formCancel;

  /// No description provided for @leapMonthSuffix.
  ///
  /// In vi, this message translates to:
  /// **'(Nhuận)'**
  String get leapMonthSuffix;

  /// No description provided for @searchNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm tên của bạn...'**
  String get searchNameHint;

  /// No description provided for @selectMemberHint.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thành viên...'**
  String get selectMemberHint;

  /// No description provided for @shareFamilyButton.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ cho gia đình'**
  String get shareFamilyButton;

  /// No description provided for @shareFamilyContent.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia gia phả \"{name}\" trên ứng dụng Gia Tộc Việt. Mã mời của dòng họ là: {code}'**
  String shareFamilyContent(String name, String code);

  /// No description provided for @startExploringButton.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu khám phá'**
  String get startExploringButton;

  /// No description provided for @searchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm...'**
  String get searchHint;

  /// No description provided for @selectDate.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày'**
  String get selectDate;

  /// No description provided for @selectMonthYear.
  ///
  /// In vi, this message translates to:
  /// **'Chọn tháng và năm'**
  String get selectMonthYear;

  /// No description provided for @adminSettingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt quản trị'**
  String get adminSettingsTitle;

  /// No description provided for @accountAndClanSection.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản & dòng tộc'**
  String get accountAndClanSection;

  /// No description provided for @switchToMemberPage.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển sang trang thành viên'**
  String get switchToMemberPage;

  /// No description provided for @appSettingsSection.
  ///
  /// In vi, this message translates to:
  /// **'Thiết lập ứng dụng'**
  String get appSettingsSection;

  /// No description provided for @languageLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get languageLabel;

  /// No description provided for @themeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get themeLabel;

  /// No description provided for @notificationsSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notificationsSectionTitle;

  /// No description provided for @notifyAnnouncementLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo từ dòng họ'**
  String get notifyAnnouncementLabel;

  /// No description provided for @notifyAnniversaryLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giỗ & sinh nhật'**
  String get notifyAnniversaryLabel;

  /// No description provided for @infoAndHelpSection.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin & trợ giúp'**
  String get infoAndHelpSection;

  /// No description provided for @helpAndInfoHubLabel.
  ///
  /// In vi, this message translates to:
  /// **'Trợ giúp & thông tin'**
  String get helpAndInfoHubLabel;

  /// No description provided for @tabFaqLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hỏi đáp'**
  String get tabFaqLabel;

  /// No description provided for @tabRegulationsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản'**
  String get tabRegulationsLabel;

  /// No description provided for @tabAboutLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu'**
  String get tabAboutLabel;

  /// No description provided for @advancedAdminSection.
  ///
  /// In vi, this message translates to:
  /// **'Quản trị nâng cao'**
  String get advancedAdminSection;

  /// No description provided for @linkAndRolesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết & phân quyền'**
  String get linkAndRolesTitle;

  /// No description provided for @tabLinkAccounts.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết tài khoản'**
  String get tabLinkAccounts;

  /// No description provided for @tabMemberRoles.
  ///
  /// In vi, this message translates to:
  /// **'Phân quyền'**
  String get tabMemberRoles;

  /// No description provided for @transferOwnershipLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển nhượng quyền Trưởng tộc'**
  String get transferOwnershipLabel;

  /// No description provided for @dissolveClanLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giải tán dòng họ'**
  String get dissolveClanLabel;

  /// No description provided for @accountSecurityTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật tài khoản'**
  String get accountSecurityTitle;

  /// No description provided for @changePasswordTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu'**
  String get changePasswordTitle;

  /// No description provided for @passwordRequirementsDesc.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới của bạn cần chứa ít nhất 8 ký tự, bao gồm cả chữ số, chữ hoa và ký tự đặc biệt để đảm bảo an toàn.'**
  String get passwordRequirementsDesc;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu hiện tại'**
  String get currentPasswordLabel;

  /// No description provided for @currentPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu đang sử dụng'**
  String get currentPasswordHint;

  /// No description provided for @currentPasswordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu hiện tại'**
  String get currentPasswordRequired;

  /// No description provided for @newPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu mới'**
  String get newPasswordHint;

  /// No description provided for @confirmNewPasswordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu mới'**
  String get confirmNewPasswordLabel;

  /// No description provided for @confirmNewPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lại mật khẩu mới'**
  String get confirmNewPasswordHint;

  /// No description provided for @updatePasswordButton.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật mật khẩu'**
  String get updatePasswordButton;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi mật khẩu thành công!'**
  String get changePasswordSuccess;

  /// No description provided for @dissolveClanTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giải tán gia phả'**
  String get dissolveClanTitle;

  /// No description provided for @irreversibleActionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hành động không thể hoàn tác'**
  String get irreversibleActionTitle;

  /// No description provided for @irreversibleWarningDesc.
  ///
  /// In vi, this message translates to:
  /// **'Việc này KHÔNG THỂ hoàn tác. Toàn bộ cây gia phả, thông tin các đời, thành viên và dữ liệu sẽ bị xóa vĩnh viễn khỏi hệ thống.'**
  String get irreversibleWarningDesc;

  /// No description provided for @confirmDissolveTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận giải tán'**
  String get confirmDissolveTitle;

  /// No description provided for @confirmDissolveInstruction.
  ///
  /// In vi, this message translates to:
  /// **'Để xác nhận, vui lòng nhập chính xác tên dòng họ bên dưới:'**
  String get confirmDissolveInstruction;

  /// No description provided for @enterLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nhập: '**
  String get enterLabel;

  /// No description provided for @reenterClanNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lại tên dòng họ'**
  String get reenterClanNameLabel;

  /// No description provided for @dissolvePermanentButton.
  ///
  /// In vi, this message translates to:
  /// **'Giải tán dòng họ vĩnh viễn'**
  String get dissolvePermanentButton;

  /// No description provided for @deletePermanentDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa gia phả vĩnh viễn'**
  String get deletePermanentDialogTitle;

  /// No description provided for @deletePermanentDialogMessage.
  ///
  /// In vi, this message translates to:
  /// **'Hành động này cực kỳ nguy hiểm. Toàn bộ thông tin thành viên, các nhánh dòng họ, lịch sử gia tộc của \"{name}\" sẽ bị xóa vĩnh viễn khỏi máy chủ. Bạn chắc chắn muốn tiếp tục chứ?'**
  String deletePermanentDialogMessage(String name);

  /// No description provided for @confirmDeletePermanentLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đồng ý xóa bỏ'**
  String get confirmDeletePermanentLabel;

  /// No description provided for @dissolveSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa gia phả. Toàn bộ dữ liệu đã được xóa khỏi hệ thống.'**
  String get dissolveSuccessMessage;

  /// No description provided for @searchMemberHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm thành viên...'**
  String get searchMemberHint;

  /// No description provided for @noSearchResultsMessage.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy kết quả phù hợp.'**
  String get noSearchResultsMessage;

  /// No description provided for @warningDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo quan trọng'**
  String get warningDialogTitle;

  /// No description provided for @warningDialogConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn chuyển giao quyền Trưởng tộc cho {name}?'**
  String warningDialogConfirmMessage(String name);

  /// No description provided for @confirmTransferButton.
  ///
  /// In vi, this message translates to:
  /// **'Đồng ý chuyển'**
  String get confirmTransferButton;

  /// No description provided for @transferSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển nhượng quyền Trưởng tộc thành công!'**
  String get transferSuccess;

  /// No description provided for @roleOfUser.
  ///
  /// In vi, this message translates to:
  /// **'Vai trò của {name}'**
  String roleOfUser(String name);

  /// No description provided for @roleEditorTitle.
  ///
  /// In vi, this message translates to:
  /// **'Biên tập viên'**
  String get roleEditorTitle;

  /// No description provided for @roleEditorDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đóng góp và chỉnh sửa thông tin gia phả.'**
  String get roleEditorDesc;

  /// No description provided for @roleViewerDesc.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ được xem thông tin gia tộc.'**
  String get roleViewerDesc;

  /// No description provided for @updateRoleSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật vai trò thành công!'**
  String get updateRoleSuccess;

  /// No description provided for @noMembers.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thành viên nào trong gia tộc.'**
  String get noMembers;

  /// No description provided for @cannotSelfChange.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không thể tự thay đổi quyền của chính mình. Hãy dùng tính năng \"Chuyển nhượng quyền Trưởng tộc\".'**
  String get cannotSelfChange;

  /// No description provided for @noProfileLink.
  ///
  /// In vi, this message translates to:
  /// **'Chưa liên kết hồ sơ gia phả'**
  String get noProfileLink;

  /// No description provided for @noProfileLinkDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản của bạn là Trưởng tộc nhưng chưa được liên kết với một thành viên nào trong cây gia phả. Hãy tạo hồ sơ ngay để bắt đầu quản lý phả hệ.'**
  String get noProfileLinkDesc;

  /// No description provided for @createProfileButton.
  ///
  /// In vi, this message translates to:
  /// **'Tạo hồ sơ gia phả'**
  String get createProfileButton;

  /// No description provided for @clanInfoSettingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin dòng tộc'**
  String get clanInfoSettingsTitle;

  /// No description provided for @basicInfoSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cơ bản'**
  String get basicInfoSectionTitle;

  /// No description provided for @clanNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên dòng tộc'**
  String get clanNameLabel;

  /// No description provided for @clanNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên dòng tộc của bạn'**
  String get clanNameHint;

  /// No description provided for @clanNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên dòng tộc'**
  String get clanNameRequired;

  /// No description provided for @originLabel.
  ///
  /// In vi, this message translates to:
  /// **'Quê quán / Nguồn gốc'**
  String get originLabel;

  /// No description provided for @originHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập quê quán tổ tiên dòng tộc'**
  String get originHint;

  /// No description provided for @originRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập địa chỉ nguồn gốc dòng tộc'**
  String get originRequired;

  /// No description provided for @clanDescLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả chi tiết'**
  String get clanDescLabel;

  /// No description provided for @clanDescHint.
  ///
  /// In vi, this message translates to:
  /// **'Tóm tắt lịch sử, gia phong dòng họ'**
  String get clanDescHint;

  /// No description provided for @noFamilyInfo.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thông tin dòng họ để cập nhật'**
  String get noFamilyInfo;

  /// No description provided for @updateFamilySuccess.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật thông tin dòng tộc thành công!'**
  String get updateFamilySuccess;

  /// No description provided for @regulationsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quy định & điều khoản pháp lý'**
  String get regulationsTitle;

  /// No description provided for @regulationTitle.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản sử dụng Gia Tộc Việt'**
  String get regulationTitle;

  /// No description provided for @regulationLastUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản hiệu lực: Tháng 8, 2026'**
  String get regulationLastUpdated;

  /// No description provided for @regSection1Title.
  ///
  /// In vi, this message translates to:
  /// **'Chấp thuận điều khoản & căn cứ pháp lý'**
  String get regSection1Title;

  /// No description provided for @regSection1Content.
  ///
  /// In vi, this message translates to:
  /// **'• Khi đăng ký, cài đặt hoặc sử dụng ứng dụng Gia Tộc Việt, bạn xác nhận đã đọc kỹ, hiểu rõ và đồng ý vô điều kiện chịu sự ràng buộc bởi các Điều khoản này.\n• Dịch vụ được cung cấp và vận hành tuân thủ các quy định pháp luật nước CHXHCN Việt Nam, bao gồm Luật Giao dịch điện tử, Luật An toàn thông tin mạng, Luật An ninh mạng và Nghị định 13/2023/NĐ-CP về Bảo vệ dữ liệu cá nhân.\n• Nếu bạn không đồng ý với bất kỳ phần nào của Điều khoản, vui lòng ngừng sử dụng ứng dụng ngay lập tức.'**
  String get regSection1Content;

  /// No description provided for @regSection2Title.
  ///
  /// In vi, this message translates to:
  /// **'Giải thích thuật ngữ & định danh'**
  String get regSection2Title;

  /// No description provided for @regSection2Content.
  ///
  /// In vi, this message translates to:
  /// **'**Ứng dụng / Nhà phát triển:** Hệ thống phần mềm Gia Tộc Việt cùng hạ tầng công nghệ đi kèm, được cung cấp như một công cụ kỹ thuật trung gian.\n**Người dùng:** Cá nhân tạo tài khoản để sử dụng dịch vụ.\n**Chủ thể dữ liệu:** Cá nhân được phản ánh thông tin trong phả hệ (bao gồm người còn sống hoặc đã mất).\n**Dòng họ (Gia tộc):** Không gian dữ liệu riêng tư gồm cây gia phả, tư liệu lịch sử, hoạt động dòng họ do Trưởng tộc khởi tạo.\n**Dữ liệu phả hệ:** Thông tin họ tên, ngày sinh/mất, quan hệ thế hệ, quê quán, tư liệu do các thành viên đóng góp.'**
  String get regSection2Content;

  /// No description provided for @regSection3Title.
  ///
  /// In vi, this message translates to:
  /// **'Quy định tài khoản & điều kiện sử dụng'**
  String get regSection3Title;

  /// No description provided for @regSection3Content.
  ///
  /// In vi, this message translates to:
  /// **'• **Độ tuổi:** Người dùng phải từ đủ 18 tuổi hoặc có sự đồng ý của người đại diện hợp pháp.\n• **Bảo mật thông tin xác thực:** Bạn tự chịu trách nhiệm bảo vệ mật khẩu, mã OTP và thiết bị của mình. Mọi hành vi thực hiện qua tài khoản của bạn được coi là do chính bạn thực hiện.\n• **Trung thực thông tin:** Cam kết cung cấp thông tin liên hệ chính xác và chịu hoàn toàn trách nhiệm cá nhân về tư cách đại diện dòng họ khi đăng ký tạo lập gia tộc.'**
  String get regSection3Content;

  /// No description provided for @regSection4Title.
  ///
  /// In vi, this message translates to:
  /// **'Phân cấp quyền hạn & trách nhiệm quản trị'**
  String get regSection4Title;

  /// No description provided for @regSection4Content.
  ///
  /// In vi, this message translates to:
  /// **'**Thành viên (Viewer):** Được quyền xem phả hệ, thông tin hoạt động và cập nhật hồ sơ cá nhân của chính mình.\n**Biên tập viên (Editor):** Được quyền nhập liệu, hiệu chỉnh hồ sơ thành viên theo sự phân công và đồng thuận của dòng họ.\n**Trưởng chi (Branch Leader):** Quản trị nhánh phả hệ, kiểm duyệt thành viên thuộc chi nhánh được phân công.\n**Trưởng tộc (Clan Leader):** Quản trị tối cao của không gian dòng họ, chịu trách nhiệm pháp lý và đạo đức về việc phân quyền, chuyển nhượng quyền quản trị hoặc quyết định xóa/giải tán dữ liệu dòng tộc.'**
  String get regSection4Content;

  /// No description provided for @regSection5Title.
  ///
  /// In vi, this message translates to:
  /// **'Quyền sở hữu trí tuệ & quyền dữ liệu'**
  String get regSection5Title;

  /// No description provided for @regSection5Content.
  ///
  /// In vi, this message translates to:
  /// **'• **Sở hữu phần mềm:** Toàn bộ mã nguồn, giao diện, thiết kế, thương hiệu và bản quyền ứng dụng thuộc quyền sở hữu độc quyền của Đơn vị phát triển.\n• **Sở hữu dữ liệu phả hệ:** Dữ liệu lịch sử gia phả, hình ảnh và tư liệu do Người dùng đăng tải thuộc quyền sở hữu của dòng tộc tương ứng. Người dùng cấp cho Hệ thống quyền kỹ thuật hạn chế để lưu trữ, sao lưu và hiển thị phục vụ chính dòng tộc đó.'**
  String get regSection5Content;

  /// No description provided for @regSection6Title.
  ///
  /// In vi, this message translates to:
  /// **'Bảo vệ dữ liệu cá nhân (Nghị định 13/2023/NĐ-CP)'**
  String get regSection6Title;

  /// No description provided for @regSection6Content.
  ///
  /// In vi, this message translates to:
  /// **'• **Cam kết thu thập hợp lệ:** Người dùng khi đăng tải thông tin của các thành viên khác phải đảm bảo đã có sự đồng thuận của cá nhân đó (hoặc người giám hộ/thân nhân trực hệ theo luật định).\n• **Bảo vệ quyền riêng tư:** Dữ liệu gia phả được thiết lập ở chế độ nội bộ (Private), chỉ hiển thị cho các thành viên được phê duyệt của dòng họ.\n• **Không thương mại hóa dữ liệu:** Cam kết tuyệt đối không bán, chia sẻ hoặc khai thác dữ liệu gia phả, thông tin cá nhân cho bên thứ ba vì bất kỳ mục đích thương mại nào.\n• **Xử lý dữ liệu:** Áp dụng các biện pháp mã hóa, lưu trữ an toàn trên máy chủ đạt chuẩn an toàn thông tin tại Việt Nam.'**
  String get regSection6Content;

  /// No description provided for @regSection7Title.
  ///
  /// In vi, this message translates to:
  /// **'Hành vi nghiêm cấm tuyệt đối'**
  String get regSection7Title;

  /// No description provided for @regSection7Content.
  ///
  /// In vi, this message translates to:
  /// **'• Đăng tải thông tin chống phá Nhà nước, vi phạm an ninh quốc gia, xuyên tạc lịch sử dân tộc hoặc xúc phạm danh nhân văn hóa/tôn giáo.\n• Thu thập, phát tán trái phép bí mật đời tư cá nhân, thông tin nhạy cảm của người khác nhằm mục đích bôi nhọ, tống tiền hoặc vu khống.\n• Can thiệp kỹ thuật, tấn công phá hoại, khai thác lỗ hổng hoặc sao chép mã nguồn, cấu trúc dữ liệu của ứng dụng.\n• Sử dụng ứng dụng vào các mục đích lừa đảo, huy động quỹ trái pháp luật hoặc các mục đích thương mại trái phép.'**
  String get regSection7Content;

  /// No description provided for @regSection8Title.
  ///
  /// In vi, this message translates to:
  /// **'Tuyên bố miễn trừ trách nhiệm pháp lý'**
  String get regSection8Title;

  /// No description provided for @regSection8Content.
  ///
  /// In vi, this message translates to:
  /// **'• **Bản chất nền tảng:** Ứng dụng chỉ đóng vai trò cung cấp công cụ kỹ thuật và không gian lưu trữ số. Chúng tôi KHÔNG chịu trách nhiệm pháp lý về tính xác thực, tranh chấp thừa kế, tranh chấp phả hệ nội bộ hoặc thông tin sai lệch do Người dùng nhập vào.\n• **Hành động của Quản trị viên:** Chúng tôi hoàn toàn miễn trừ trách nhiệm khi dữ liệu bị xóa hoặc thay đổi do chính Trưởng tộc/Trưởng chi thực hiện (như chuyển nhượng quyền, giải tán dòng họ hoặc thao tác nhầm).\n• **Bất khả kháng:** Miễn trừ trách nhiệm bồi thường đối với các sự cố bất khả kháng ngoài tầm kiểm soát hợp lý như thiên tai, gián đoạn mạng viễn thông quốc gia hoặc tấn công mạng diện rộng.'**
  String get regSection8Content;

  /// No description provided for @regSection9Title.
  ///
  /// In vi, this message translates to:
  /// **'Cơ chế báo cáo vi phạm & chế tài xử lý'**
  String get regSection9Title;

  /// No description provided for @regSection9Content.
  ///
  /// In vi, this message translates to:
  /// **'• **Báo cáo nội dung xấu:** Người dùng có quyền gửi khiếu nại/báo cáo khi phát hiện thông tin sai sự thật hoặc xâm phạm quyền cá nhân thông qua tính năng \"Báo cáo vi phạm\".\n• **Chế tài vi phạm:** Hệ thống có toàn quyền cảnh báo, tạm khóa, gỡ bỏ nội dung vi phạm hoặc hủy bỏ vĩnh viễn tài khoản vi phạm mà không cần hoàn phí.\n• **Phối hợp pháp lý:** Khi có yêu cầu bằng văn bản từ Cơ quan Công an hoặc Tòa án có thẩm quyền, chúng tôi có nghĩa vụ cung cấp nhật ký (logs) và dữ liệu liên quan để phục vụ điều tra theo đúng quy định pháp luật.'**
  String get regSection9Content;

  /// No description provided for @regSection10Title.
  ///
  /// In vi, this message translates to:
  /// **'Giải quyết tranh chấp & luật áp dụng'**
  String get regSection10Title;

  /// No description provided for @regSection10Content.
  ///
  /// In vi, this message translates to:
  /// **'• Mọi Điều khoản này được giải thích và điều chỉnh độc quyền theo Pháp luật nước CHXHCN Việt Nam.\n• Mọi tranh chấp phát sinh giữa Người dùng và Đơn vị phát triển trước hết sẽ được giải quyết thông qua thương lượng và hòa giải trên tinh thần thiện chí.\n• Trường hợp hòa giải không thành trong vòng sáu mươi (60) ngày, tranh chấp sẽ được đưa ra giải quyết tại Tòa án nhân dân có thẩm quyền tại Việt Nam.'**
  String get regSection10Content;

  /// No description provided for @copyrightText.
  ///
  /// In vi, this message translates to:
  /// **'© 2026 ThachDev. Bảo lưu mọi quyền.'**
  String get copyrightText;

  /// No description provided for @contactSection.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ trực tiếp'**
  String get contactSection;

  /// No description provided for @supportEmailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Email hỗ trợ'**
  String get supportEmailTitle;

  /// No description provided for @supportEmailValue.
  ///
  /// In vi, this message translates to:
  /// **'thachhuynh.dev@gmail.com'**
  String get supportEmailValue;

  /// No description provided for @supportEmailSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Phản hồi trong 24h'**
  String get supportEmailSubtitle;

  /// No description provided for @genealogyMemberSection.
  ///
  /// In vi, this message translates to:
  /// **'Phả hệ & liên kết'**
  String get genealogyMemberSection;

  /// No description provided for @clanAndRolesSection.
  ///
  /// In vi, this message translates to:
  /// **'Phân quyền & quản trị dòng họ'**
  String get clanAndRolesSection;

  /// No description provided for @techSecuritySection.
  ///
  /// In vi, this message translates to:
  /// **'An toàn dữ liệu & tài khoản'**
  String get techSecuritySection;

  /// No description provided for @faqAddMemberQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để thêm con cháu, vợ/chồng trên cây gia phả?'**
  String get faqAddMemberQuestion;

  /// No description provided for @faqAddMemberAnswer.
  ///
  /// In vi, this message translates to:
  /// **'• **Thao tác nhanh trên Cây phả hệ:** Chạm vào bất kỳ thành viên nào trên sơ đồ và chọn nút \"Thêm Con\" hoặc \"Thêm Vợ/Chồng\".\n• **Nhập chi tiết từ Bảng quản trị:** Vào Dashboard > tab Thành viên > nhấn nút \"+\". Điền đầy đủ thế hệ, nhánh chi họ, ngày sinh/mất âm dương lịch và tiểu sử.'**
  String get faqAddMemberAnswer;

  /// No description provided for @faqAddBranchQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Cách phân tách chi tộc và chỉ định Trưởng chi quản lý nhánh?'**
  String get faqAddBranchQuestion;

  /// No description provided for @faqAddBranchAnswer.
  ///
  /// In vi, this message translates to:
  /// **'1. Vào Dashboard > tab Chi họ, nhấn \"+\" để tạo chi họ mới (tên chi, tổ lập chi, năm lập, địa phương).\n2. Vào Cài đặt > Liên kết & Phân quyền > tab Phân quyền để bổ nhiệm vai trò cho thành viên quản lý nhánh.'**
  String get faqAddBranchAnswer;

  /// No description provided for @faqEditMemberQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Cách liên kết tài khoản cho người thân để cùng xem gia phả?'**
  String get faqEditMemberQuestion;

  /// No description provided for @faqEditMemberAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Vào Cài đặt > Liên kết & Phân quyền > tab Liên kết tài khoản > nhập Email của người thân. Hệ thống sẽ tự động ghép nối tài khoản của họ với hồ sơ trên cây gia phả để họ có thể đăng nhập xem và đóng góp cho cây dòng tộc.'**
  String get faqEditMemberAnswer;

  /// No description provided for @faqDeleteMemberQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Xóa thành viên thì nhánh con cháu phía sau sẽ được xử lý ra sao?'**
  String get faqDeleteMemberQuestion;

  /// No description provided for @faqDeleteMemberAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống hỗ trợ 2 cơ chế thông minh khi xóa một người có con cháu:\n• **Nâng đời con cháu (Khuyên dùng):** Tự động liên kết thế hệ con lên bậc ông bà/cha mẹ phía trên để cây phả hệ không bị đứt đoạn.\n• **Tách nhánh:** Đưa nhánh con cháu thành một nhánh độc lập riêng biệt.'**
  String get faqDeleteMemberAnswer;

  /// No description provided for @faqInviteCodeQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Cách lấy mã mời và chia sẻ mã QR cho dòng họ gia nhập?'**
  String get faqInviteCodeQuestion;

  /// No description provided for @faqInviteCodeAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Tại Bảng quản trị, Trưởng họ nhấn vào ô \"Mã Gia Tộc\" để sao chép mã 6 ký tự hoặc tải ảnh QR Code chất lượng cao để gửi vào nhóm Zalo/Facebook dòng họ hoặc in ra giấy.'**
  String get faqInviteCodeAnswer;

  /// No description provided for @faqRolesQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Quyền hạn cụ thể của 4 cấp bậc trong dòng họ là gì?'**
  String get faqRolesQuestion;

  /// No description provided for @faqRolesAnswer.
  ///
  /// In vi, this message translates to:
  /// **'• **Trưởng tộc (Owner):** Toàn quyền tối cao — quản trị toàn phả hệ, phân quyền, chuyển nhượng quyền Trưởng họ và giải tán dòng tộc.\n• **Trưởng chi (Branch Admin):** Quản lý hồ sơ, duyệt thành viên trong nhánh chi họ được giao.\n• **Biên tập viên (Editor):** Được quyền thêm, sửa thông tin các thành viên (không được xóa phả hệ).\n• **Thành viên (Member):** Xem cây gia phả, xem tin tức/sự kiện, gửi lời chúc và thắp nhang online.'**
  String get faqRolesAnswer;

  /// No description provided for @faqTransferOwnershipQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Cách chuyển nhượng quyền Trưởng tộc và những lưu ý an toàn?'**
  String get faqTransferOwnershipQuestion;

  /// No description provided for @faqTransferOwnershipAnswer.
  ///
  /// In vi, this message translates to:
  /// **'• **Cách thực hiện:** Vào Cài đặt > Liên kết & Phân quyền > tab Phân quyền > chọn thành viên muốn trao quyền > chọn \"Chuyển nhượng quyền Trưởng tộc\" (có huy hiệu Tối cao) và nhập chính xác chữ \"XÁC NHẬN\" để hoàn tất.\n• **Lưu ý:** Quyền Trưởng tộc sẽ được chuyển giao tức thì, người được chọn trở thành Trưởng tộc mới và bạn sẽ tự động trở về vai trò Thành viên.'**
  String get faqTransferOwnershipAnswer;

  /// No description provided for @faqDataSecurityQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu gia phả được bảo mật thế nào (Nghị định 13/2023/NĐ-CP)?'**
  String get faqDataSecurityQuestion;

  /// No description provided for @faqDataSecurityAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu gia phả được lưu trữ tại máy chủ Việt Nam, mã hóa SSL/TLS 256-bit và chỉ hiển thị nội bộ cho các thành viên được Trưởng họ duyệt. Chúng tôi cam kết tuyệt đối không thương mại hóa dữ liệu cho bên thứ ba.'**
  String get faqDataSecurityAnswer;

  /// No description provided for @aboutUsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Về chúng tôi'**
  String get aboutUsTitle;

  /// No description provided for @aboutUsTagline.
  ///
  /// In vi, this message translates to:
  /// **'Gia Tộc Việt giúp bạn gìn giữ gia phả dòng họ trên nền tảng số, kết nối các thế hệ dù ở bất kỳ nơi đâu.'**
  String get aboutUsTagline;

  /// No description provided for @versionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản'**
  String get versionLabel;

  /// No description provided for @developerLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nhà phát triển'**
  String get developerLabel;

  /// No description provided for @contactEmailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get contactEmailLabel;

  /// No description provided for @roleOwner.
  ///
  /// In vi, this message translates to:
  /// **'Trưởng tộc'**
  String get roleOwner;

  /// No description provided for @searchMembersHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm thành viên...'**
  String get searchMembersHint;

  /// No description provided for @searchBranchesHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm chi tộc...'**
  String get searchBranchesHint;

  /// No description provided for @emptyMembers.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thành viên phù hợp'**
  String get emptyMembers;

  /// No description provided for @emptyBranches.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy chi tộc phù hợp'**
  String get emptyBranches;

  /// No description provided for @emptyPendingRequests.
  ///
  /// In vi, this message translates to:
  /// **'Không có yêu cầu tham gia nào đang chờ duyệt'**
  String get emptyPendingRequests;

  /// No description provided for @statMembers.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên'**
  String get statMembers;

  /// No description provided for @statBranches.
  ///
  /// In vi, this message translates to:
  /// **'Chi tộc'**
  String get statBranches;

  /// No description provided for @inviteCodeSectionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mã gia tộc'**
  String get inviteCodeSectionLabel;

  /// No description provided for @inviteCodeCopied.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép mã mời: {code}'**
  String inviteCodeCopied(Object code);

  /// No description provided for @copyCodeTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép mã'**
  String get copyCodeTooltip;

  /// No description provided for @qrDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mã QR gia tộc'**
  String get qrDialogTitle;

  /// No description provided for @qrSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu QR vào thư viện ảnh!'**
  String get qrSaved;

  /// No description provided for @qrSaveError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lưu ảnh. Vui lòng cấp quyền thư viện ảnh.'**
  String get qrSaveError;

  /// No description provided for @downloadLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tải xuống'**
  String get downloadLabel;

  /// No description provided for @shareLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ'**
  String get shareLabel;

  /// No description provided for @viewAllLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get viewAllLabel;

  /// No description provided for @addNewLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thêm mới'**
  String get addNewLabel;

  /// No description provided for @aliveLabel.
  ///
  /// In vi, this message translates to:
  /// **'Còn sống'**
  String get aliveLabel;

  /// No description provided for @deceasedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã mất'**
  String get deceasedLabel;

  /// No description provided for @branchBadge.
  ///
  /// In vi, this message translates to:
  /// **'Chi tộc: {name}'**
  String branchBadge(Object name);

  /// No description provided for @editLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa'**
  String get editLabel;

  /// No description provided for @deleteLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xoá'**
  String get deleteLabel;

  /// No description provided for @memberCountBadge.
  ///
  /// In vi, this message translates to:
  /// **'{count} thành viên'**
  String memberCountBadge(Object count);

  /// No description provided for @founderBadge.
  ///
  /// In vi, this message translates to:
  /// **'Sáng lập: {name}'**
  String founderBadge(Object name);

  /// No description provided for @founderFormat.
  ///
  /// In vi, this message translates to:
  /// **'Tổ: {name}'**
  String founderFormat(Object name);

  /// No description provided for @anonymousUser.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng ẩn danh'**
  String get anonymousUser;

  /// No description provided for @noEmail.
  ///
  /// In vi, this message translates to:
  /// **'Không có email'**
  String get noEmail;

  /// No description provided for @approveButton.
  ///
  /// In vi, this message translates to:
  /// **'Phê duyệt'**
  String get approveButton;

  /// No description provided for @rejectButton.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get rejectButton;

  /// No description provided for @approveSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã phê duyệt yêu cầu thành công!'**
  String get approveSuccess;

  /// No description provided for @rejectSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối yêu cầu thành công!'**
  String get rejectSuccess;

  /// No description provided for @deleteMemberSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá thành viên thành công!'**
  String get deleteMemberSuccess;

  /// No description provided for @saveMemberSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu thông tin thành viên!'**
  String get saveMemberSuccess;

  /// No description provided for @deleteBranchSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá chi tộc thành công!'**
  String get deleteBranchSuccess;

  /// No description provided for @saveBranchSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu thông tin chi tộc!'**
  String get saveBranchSuccess;

  /// No description provided for @deleteMemberTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận xoá'**
  String get deleteMemberTitle;

  /// No description provided for @deleteMemberMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xoá thành viên {name} khỏi gia phả không?'**
  String deleteMemberMessage(Object name);

  /// No description provided for @deleteBranchTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận xoá chi tộc'**
  String get deleteBranchTitle;

  /// No description provided for @deleteBranchMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xoá chi tộc {name}? Tất cả thành viên thuộc chi này sẽ mất liên kết chi tộc.'**
  String deleteBranchMessage(Object name);

  /// No description provided for @saveBranchLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lưu chi tộc'**
  String get saveBranchLabel;

  /// No description provided for @editBranchTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sửa chi tộc'**
  String get editBranchTitle;

  /// No description provided for @addBranchTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm chi tộc'**
  String get addBranchTitle;

  /// No description provided for @deleteBranchTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Xóa chi tộc'**
  String get deleteBranchTooltip;

  /// No description provided for @branchNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên chi tộc'**
  String get branchNameLabel;

  /// No description provided for @branchNameHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Chi Trưởng, Chi Hai...'**
  String get branchNameHint;

  /// No description provided for @branchNameEmptyError.
  ///
  /// In vi, this message translates to:
  /// **'Không được để trống'**
  String get branchNameEmptyError;

  /// No description provided for @founderNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên tổ chi'**
  String get founderNameLabel;

  /// No description provided for @addMemberPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'✦ Thêm thành viên mới...'**
  String get addMemberPlaceholder;

  /// No description provided for @noSelectionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Không chọn'**
  String get noSelectionLabel;

  /// No description provided for @manualInputLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên tổ chi (tự nhập)'**
  String get manualInputLabel;

  /// No description provided for @founderNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Người lập chi (tùy chọn)'**
  String get founderNameHint;

  /// No description provided for @inputModeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tự nhập tên'**
  String get inputModeLabel;

  /// No description provided for @selectModeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chọn từ danh sách'**
  String get selectModeLabel;

  /// No description provided for @foundationYearLabel.
  ///
  /// In vi, this message translates to:
  /// **'Năm lập chi'**
  String get foundationYearLabel;

  /// No description provided for @foundationYearHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: 1980'**
  String get foundationYearHint;

  /// No description provided for @locationLabel.
  ///
  /// In vi, this message translates to:
  /// **'Địa phương'**
  String get locationLabel;

  /// No description provided for @locationHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Làng X, Huyện Y'**
  String get locationHint;

  /// No description provided for @branchDescLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả chi tộc'**
  String get branchDescLabel;

  /// No description provided for @branchDescHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập thêm thông tin mô tả chi tiết...'**
  String get branchDescHint;

  /// No description provided for @deleteBranchConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận xóa'**
  String get deleteBranchConfirmTitle;

  /// No description provided for @deleteBranchConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xoá chi tộc {name} không?'**
  String deleteBranchConfirmMessage(Object name);

  /// No description provided for @editMemberTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sửa thành viên'**
  String get editMemberTitle;

  /// No description provided for @addMemberTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm thành viên'**
  String get addMemberTitle;

  /// No description provided for @linkAccountSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã tạo và liên kết hồ sơ gia phả thành công!'**
  String get linkAccountSuccess;

  /// No description provided for @linkAccountError.
  ///
  /// In vi, this message translates to:
  /// **'Tạo hồ sơ thành công nhưng không thể liên kết tài khoản: {msg}'**
  String linkAccountError(Object msg);

  /// No description provided for @nameHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập họ và tên'**
  String get nameHint;

  /// No description provided for @maritalStatusLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tình trạng hôn nhân'**
  String get maritalStatusLabel;

  /// No description provided for @maritalSingle.
  ///
  /// In vi, this message translates to:
  /// **'Độc thân'**
  String get maritalSingle;

  /// No description provided for @maritalMarried.
  ///
  /// In vi, this message translates to:
  /// **'Đã kết hôn'**
  String get maritalMarried;

  /// No description provided for @maritalDivorced.
  ///
  /// In vi, this message translates to:
  /// **'Ly hôn'**
  String get maritalDivorced;

  /// No description provided for @maritalWidowed.
  ///
  /// In vi, this message translates to:
  /// **'Góa phụ'**
  String get maritalWidowed;

  /// No description provided for @genderLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giới tính'**
  String get genderLabel;

  /// No description provided for @genderMale.
  ///
  /// In vi, this message translates to:
  /// **'Nam'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In vi, this message translates to:
  /// **'Nữ'**
  String get genderFemale;

  /// No description provided for @dobLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày sinh'**
  String get dobLabel;

  /// No description provided for @dobHint.
  ///
  /// In vi, this message translates to:
  /// **'dd/mm/yyyy'**
  String get dobHint;

  /// No description provided for @statusLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tình trạng'**
  String get statusLabel;

  /// No description provided for @dodLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày mất'**
  String get dodLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In vi, this message translates to:
  /// **'0xxxxxxxxx'**
  String get phoneHint;

  /// No description provided for @addressLabel.
  ///
  /// In vi, this message translates to:
  /// **'Quê quán / Địa chỉ'**
  String get addressLabel;

  /// No description provided for @addressHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập thông tin quê quán, nơi ở...'**
  String get addressHint;

  /// No description provided for @educationLabel.
  ///
  /// In vi, this message translates to:
  /// **'Học vấn'**
  String get educationLabel;

  /// No description provided for @educationHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập trình độ học vấn...'**
  String get educationHint;

  /// No description provided for @occupationLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nghề nghiệp'**
  String get occupationLabel;

  /// No description provided for @occupationHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập nghề nghiệp...'**
  String get occupationHint;

  /// No description provided for @parentLabel.
  ///
  /// In vi, this message translates to:
  /// **'Cha/Mẹ'**
  String get parentLabel;

  /// No description provided for @spouseLabel.
  ///
  /// In vi, this message translates to:
  /// **'Vợ/Chồng'**
  String get spouseLabel;

  /// No description provided for @branchSectionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chi/Nhánh'**
  String get branchSectionLabel;

  /// No description provided for @noBranchLabel.
  ///
  /// In vi, this message translates to:
  /// **'Không thuộc chi nào'**
  String get noBranchLabel;

  /// No description provided for @parentBranchMarker.
  ///
  /// In vi, this message translates to:
  /// **'{name} ✦ (Chi của cha/mẹ)'**
  String parentBranchMarker(Object name);

  /// No description provided for @bioLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tiểu sử'**
  String get bioLabel;

  /// No description provided for @bioHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập thông tin nghề nghiệp, học vấn hoặc cột mốc quan trọng...'**
  String get bioHint;

  /// No description provided for @uploadPhotoLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tải ảnh đại diện'**
  String get uploadPhotoLabel;

  /// No description provided for @generationFieldLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thế hệ'**
  String get generationFieldLabel;

  /// No description provided for @generationFieldHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: 3'**
  String get generationFieldHint;

  /// No description provided for @familyNameFormat.
  ///
  /// In vi, this message translates to:
  /// **'Gia tộc {name}'**
  String familyNameFormat(Object name);

  /// No description provided for @notOnTreeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên tôi chưa có trên cây gia phả'**
  String get notOnTreeLabel;

  /// No description provided for @notLoggedIn.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng chưa đăng nhập'**
  String get notLoggedIn;

  /// No description provided for @sessionTokenError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lấy mã xác thực phiên đăng nhập'**
  String get sessionTokenError;

  /// No description provided for @passwordChangeFailed.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi mật khẩu thất bại'**
  String get passwordChangeFailed;

  /// No description provided for @emailSubjectHelp.
  ///
  /// In vi, this message translates to:
  /// **'Hỗ trợ Gia Tộc Việt'**
  String get emailSubjectHelp;

  /// No description provided for @allLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get allLabel;

  /// No description provided for @biographySectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tiểu sử & ghi chú'**
  String get biographySectionTitle;

  /// No description provided for @branchLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chi tộc'**
  String get branchLabel;

  /// No description provided for @branchTabLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chi tộc / nhánh'**
  String get branchTabLabel;

  /// No description provided for @dateOfBirthLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày sinh'**
  String get dateOfBirthLabel;

  /// No description provided for @dateOfDeathLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày mất'**
  String get dateOfDeathLabel;

  /// No description provided for @eventCountdown.
  ///
  /// In vi, this message translates to:
  /// **'Còn {days} ngày'**
  String eventCountdown(int days);

  /// No description provided for @eventTypeEvent.
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện'**
  String get eventTypeEvent;

  /// No description provided for @familyRelationSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quan hệ gia đình'**
  String get familyRelationSectionTitle;

  /// No description provided for @familyTreeNameFormat.
  ///
  /// In vi, this message translates to:
  /// **'Gia phả họ {name}'**
  String familyTreeNameFormat(String name);

  /// No description provided for @familyTreeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gia phả dòng họ'**
  String get familyTreeTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng?'**
  String get logoutConfirmMessage;

  /// No description provided for @logoutLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logoutLabel;

  /// No description provided for @noBiographyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thông tin tiểu sử cho thành viên này.'**
  String get noBiographyMessage;

  /// No description provided for @noTreeDataMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu gia phả'**
  String get noTreeDataMessage;

  /// No description provided for @personalInfoSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cá nhân'**
  String get personalInfoSectionTitle;

  /// No description provided for @placeOfBirthLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nơi sinh'**
  String get placeOfBirthLabel;

  /// No description provided for @settingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settingsTitle;

  /// No description provided for @switchToAdminLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển sang trang quản trị'**
  String get switchToAdminLabel;

  /// No description provided for @todayLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get todayLabel;

  /// No description provided for @wishDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời chúc'**
  String get wishDialogTitle;

  /// No description provided for @wishDialogHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lời chúc...'**
  String get wishDialogHint;

  /// No description provided for @wishSendButton.
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get wishSendButton;

  /// No description provided for @wishSentMessage.
  ///
  /// In vi, this message translates to:
  /// **'Lời chúc đã được gửi.'**
  String get wishSentMessage;

  /// No description provided for @anniversaryDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời tưởng nhớ'**
  String get anniversaryDialogTitle;

  /// No description provided for @anniversaryDialogHint.
  ///
  /// In vi, this message translates to:
  /// **'Viết lời tưởng nhớ...'**
  String get anniversaryDialogHint;

  /// No description provided for @understoodLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã rõ'**
  String get understoodLabel;

  /// No description provided for @unknownLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chưa rõ'**
  String get unknownLabel;

  /// No description provided for @eventsListTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện dòng tộc'**
  String get eventsListTitle;

  /// No description provided for @noEventsMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có sự kiện nào được tạo'**
  String get noEventsMessage;

  /// No description provided for @errorOccurred.
  ///
  /// In vi, this message translates to:
  /// **'Đã có lỗi xảy ra. Vui lòng thử lại.'**
  String get errorOccurred;

  /// No description provided for @lunarCalendar.
  ///
  /// In vi, this message translates to:
  /// **'Âm lịch'**
  String get lunarCalendar;

  /// No description provided for @deleteEventTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xoá sự kiện'**
  String get deleteEventTitle;

  /// No description provided for @deleteEventConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xoá sự kiện \"{title}\"?'**
  String deleteEventConfirm(String title);

  /// No description provided for @addEventTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm sự kiện'**
  String get addEventTitle;

  /// No description provided for @editEventTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sửa sự kiện'**
  String get editEventTitle;

  /// No description provided for @selectEventDateError.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn ngày diễn ra sự kiện'**
  String get selectEventDateError;

  /// No description provided for @educationPrimary.
  ///
  /// In vi, this message translates to:
  /// **'Tiểu học'**
  String get educationPrimary;

  /// No description provided for @educationSecondary.
  ///
  /// In vi, this message translates to:
  /// **'Trung học cơ sở'**
  String get educationSecondary;

  /// No description provided for @educationHighSchool.
  ///
  /// In vi, this message translates to:
  /// **'Trung học phổ thông'**
  String get educationHighSchool;

  /// No description provided for @educationUniversity.
  ///
  /// In vi, this message translates to:
  /// **'Đại học'**
  String get educationUniversity;

  /// No description provided for @educationPostgraduate.
  ///
  /// In vi, this message translates to:
  /// **'Sau đại học'**
  String get educationPostgraduate;

  /// No description provided for @otherLabel.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get otherLabel;

  /// No description provided for @inputOtherEducationLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nhập học vấn khác'**
  String get inputOtherEducationLabel;

  /// No description provided for @memberDetailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết thành viên'**
  String get memberDetailTitle;

  /// No description provided for @fatherLabel.
  ///
  /// In vi, this message translates to:
  /// **'Cha'**
  String get fatherLabel;

  /// No description provided for @motherLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mẹ'**
  String get motherLabel;

  /// No description provided for @eventTypeAnnouncement.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get eventTypeAnnouncement;

  /// No description provided for @selectPostType.
  ///
  /// In vi, this message translates to:
  /// **'Chọn loại bài đăng'**
  String get selectPostType;

  /// No description provided for @eventTitleHint.
  ///
  /// In vi, this message translates to:
  /// **'Tên sự kiện...'**
  String get eventTitleHint;

  /// No description provided for @eventTitleRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên sự kiện'**
  String get eventTitleRequired;

  /// No description provided for @eventSelectDate.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày tổ chức'**
  String get eventSelectDate;

  /// No description provided for @eventLocationLabel.
  ///
  /// In vi, this message translates to:
  /// **'Địa điểm'**
  String get eventLocationLabel;

  /// No description provided for @eventLocationHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập địa điểm...'**
  String get eventLocationHint;

  /// No description provided for @eventAuthorLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tác giả'**
  String get eventAuthorLabel;

  /// No description provided for @eventPickPhoto.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ảnh'**
  String get eventPickPhoto;

  /// No description provided for @eventChangePhoto.
  ///
  /// In vi, this message translates to:
  /// **'Thay ảnh'**
  String get eventChangePhoto;

  /// No description provided for @eventDetailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết sự kiện'**
  String get eventDetailTitle;

  /// No description provided for @deathAnniversariesSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'NGÀY GIỖ DÒNG HỌ'**
  String get deathAnniversariesSectionTitle;

  /// No description provided for @noBirthdaysMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có sinh nhật nào sắp tới'**
  String get noBirthdaysMessage;

  /// No description provided for @noDeathAnniversariesMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có ngày giỗ nào sắp tới'**
  String get noDeathAnniversariesMessage;

  /// No description provided for @generationLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đời thứ {gen}'**
  String generationLabel(String gen);

  /// No description provided for @spouseInfoLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin vợ / chồng'**
  String get spouseInfoLabel;

  /// No description provided for @parentInfoLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cha / mẹ'**
  String get parentInfoLabel;

  /// No description provided for @hasInTreeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã có'**
  String get hasInTreeLabel;

  /// No description provided for @notInTreeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có'**
  String get notInTreeLabel;

  /// No description provided for @selectSpouseLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chọn vợ / chồng'**
  String get selectSpouseLabel;

  /// No description provided for @searchSpouseHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm tên vợ / chồng...'**
  String get searchSpouseHint;

  /// No description provided for @inputSpouseNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên vợ / chồng'**
  String get inputSpouseNameLabel;

  /// No description provided for @inputSpouseNameHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Kết hôn với bà Nguyễn Thị B...'**
  String get inputSpouseNameHint;

  /// No description provided for @selectParentLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chọn cha / mẹ'**
  String get selectParentLabel;

  /// No description provided for @searchParentHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm tên cha / mẹ...'**
  String get searchParentHint;

  /// No description provided for @inputParentNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên cha / mẹ'**
  String get inputParentNameLabel;

  /// No description provided for @inputParentNameHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Con ông Nguyễn Văn A, cháu ông B...'**
  String get inputParentNameHint;

  /// No description provided for @changeInviteCodeButton.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mã'**
  String get changeInviteCodeButton;

  /// No description provided for @saveEventSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Lưu sự kiện thành công'**
  String get saveEventSuccess;

  /// No description provided for @deleteEventSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Xoá sự kiện thành công'**
  String get deleteEventSuccess;

  /// No description provided for @transferOwnershipError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể chuyển nhượng quyền Trưởng tộc'**
  String get transferOwnershipError;

  /// No description provided for @roleUpdateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Phân quyền thất bại'**
  String get roleUpdateFailed;

  /// No description provided for @updateProfileSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật thông tin thành công'**
  String get updateProfileSuccess;

  /// No description provided for @approveFailed.
  ///
  /// In vi, this message translates to:
  /// **'Phê duyệt thất bại'**
  String get approveFailed;

  /// No description provided for @rejectFailed.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối thất bại'**
  String get rejectFailed;

  /// No description provided for @dissolveClanError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể giải tán dòng họ'**
  String get dissolveClanError;

  /// No description provided for @familyTreeLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Có lỗi xảy ra khi tải dữ liệu: {error}'**
  String familyTreeLoadError(Object error);

  /// No description provided for @eventTypeEventArticle.
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện / bài viết'**
  String get eventTypeEventArticle;

  /// No description provided for @eventImageFormatHint.
  ///
  /// In vi, this message translates to:
  /// **'Định dạng JPG, PNG (Tối đa 5MB)'**
  String get eventImageFormatHint;

  /// No description provided for @eventTitleLabelAnnouncement.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề thông báo'**
  String get eventTitleLabelAnnouncement;

  /// No description provided for @eventTitleLabelEventArticle.
  ///
  /// In vi, this message translates to:
  /// **'Tên sự kiện / bài viết'**
  String get eventTitleLabelEventArticle;

  /// No description provided for @eventTitleHintAnnouncement.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tiêu đề thông báo ngắn gọn...'**
  String get eventTitleHintAnnouncement;

  /// No description provided for @eventTitleRequiredAnnouncement.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tiêu đề thông báo'**
  String get eventTitleRequiredAnnouncement;

  /// No description provided for @eventOrganizerLabelFull.
  ///
  /// In vi, this message translates to:
  /// **'Ban tổ chức / Người chủ trì'**
  String get eventOrganizerLabelFull;

  /// No description provided for @eventOrganizerHintFull.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên người chủ trì hoặc ban tổ chức...'**
  String get eventOrganizerHintFull;

  /// No description provided for @eventContentLabelAnnouncement.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung thông báo'**
  String get eventContentLabelAnnouncement;

  /// No description provided for @eventContentLabelEventArticle.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung & lịch trình'**
  String get eventContentLabelEventArticle;

  /// No description provided for @eventContentHintAnnouncement.
  ///
  /// In vi, this message translates to:
  /// **'Nhập nội dung chi tiết thông báo gửi đến gia tộc...'**
  String get eventContentHintAnnouncement;

  /// No description provided for @eventContentHintEventArticle.
  ///
  /// In vi, this message translates to:
  /// **'Nhập nội dung chi tiết bài viết, lịch trình sự kiện...'**
  String get eventContentHintEventArticle;

  /// No description provided for @eventContentRequiredAnnouncement.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập nội dung thông báo'**
  String get eventContentRequiredAnnouncement;

  /// No description provided for @eventSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm sự kiện, thông báo...'**
  String get eventSearchHint;

  /// No description provided for @eventNoResults.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thông tin phù hợp'**
  String get eventNoResults;

  /// No description provided for @clanEventsSection.
  ///
  /// In vi, this message translates to:
  /// **'SỰ KIỆN GIA TỘC'**
  String get clanEventsSection;

  /// No description provided for @clanAnnouncementsSection.
  ///
  /// In vi, this message translates to:
  /// **'THÔNG BÁO GIA TỘC'**
  String get clanAnnouncementsSection;

  /// No description provided for @eventDiscardChangesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ chỉnh sửa?'**
  String get eventDiscardChangesTitle;

  /// No description provided for @eventDiscardChangesMessage.
  ///
  /// In vi, this message translates to:
  /// **'Các thay đổi chưa lưu sẽ bị mất.'**
  String get eventDiscardChangesMessage;

  /// No description provided for @eventDiscardChangesAction.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ chỉnh sửa'**
  String get eventDiscardChangesAction;

  /// No description provided for @adminBoard.
  ///
  /// In vi, this message translates to:
  /// **'Ban quản trị'**
  String get adminBoard;

  /// No description provided for @lunarShortLabel.
  ///
  /// In vi, this message translates to:
  /// **'LỊCH ÂM'**
  String get lunarShortLabel;

  /// No description provided for @monthLabelFormat.
  ///
  /// In vi, this message translates to:
  /// **'Tháng {month}'**
  String monthLabelFormat(Object month);

  /// No description provided for @lunarMonthLabelFormat.
  ///
  /// In vi, this message translates to:
  /// **'Tháng {month}{leap}'**
  String lunarMonthLabelFormat(Object leap, Object month);

  /// No description provided for @leapMonthInline.
  ///
  /// In vi, this message translates to:
  /// **' Nhuận'**
  String get leapMonthInline;

  /// No description provided for @addMemberFabLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên +'**
  String get addMemberFabLabel;

  /// No description provided for @addBranchFabLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chi họ +'**
  String get addBranchFabLabel;

  /// No description provided for @selectUnlinkedMemberTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thành viên chưa nối cây'**
  String get selectUnlinkedMemberTitle;

  /// No description provided for @selectUnlinkedMemberSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thành viên để mở thông tin và nối vào gia phả'**
  String get selectUnlinkedMemberSubtitle;

  /// No description provided for @deleteMemberConfirmStart.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xoá thành viên '**
  String get deleteMemberConfirmStart;

  /// No description provided for @deleteMemberConfirmEnd.
  ///
  /// In vi, this message translates to:
  /// **' khỏi gia phả không?'**
  String get deleteMemberConfirmEnd;

  /// No description provided for @deleteMemberTitlePrefix.
  ///
  /// In vi, this message translates to:
  /// **'Xoá thành viên '**
  String get deleteMemberTitlePrefix;

  /// No description provided for @deleteMemberWithDescendantsMessage.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên này đang có con/cháu nối tiếp trong cây gia phả. Vui lòng lựa chọn phương án xử lý liên kết thế hệ:'**
  String get deleteMemberWithDescendantsMessage;

  /// No description provided for @promoteChildrenOption.
  ///
  /// In vi, this message translates to:
  /// **'Đôn con lên'**
  String get promoteChildrenOption;

  /// No description provided for @recommendedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Khuyên dùng'**
  String get recommendedLabel;

  /// No description provided for @promoteChildrenDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tự động nối trực tiếp các con lên thế hệ trên để cây không bị đứt đoạn.'**
  String get promoteChildrenDesc;

  /// No description provided for @deleteAndDetachOption.
  ///
  /// In vi, this message translates to:
  /// **'Xoá & tách nhánh'**
  String get deleteAndDetachOption;

  /// No description provided for @deleteAndDetachDesc.
  ///
  /// In vi, this message translates to:
  /// **'Các con cháu sẽ bị tách thành nhánh mồ côi (mất liên kết với thế hệ cha).'**
  String get deleteAndDetachDesc;

  /// No description provided for @accountSection.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get accountSection;

  /// No description provided for @userIdLabel.
  ///
  /// In vi, this message translates to:
  /// **'ID người dùng'**
  String get userIdLabel;

  /// No description provided for @registeredRoleLabel.
  ///
  /// In vi, this message translates to:
  /// **'Vai trò đăng ký'**
  String get registeredRoleLabel;

  /// No description provided for @statusDisplayLabel.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái'**
  String get statusDisplayLabel;

  /// No description provided for @registeredMemberInfoLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin thành viên đăng ký'**
  String get registeredMemberInfoLabel;

  /// No description provided for @hometownLabel.
  ///
  /// In vi, this message translates to:
  /// **'Quê quán'**
  String get hometownLabel;

  /// No description provided for @maritalStatusShortLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tình trạng HN'**
  String get maritalStatusShortLabel;

  /// No description provided for @notesLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú'**
  String get notesLabel;

  /// No description provided for @memberFallbackName.
  ///
  /// In vi, this message translates to:
  /// **'thành viên'**
  String get memberFallbackName;

  /// No description provided for @createRelativeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo người thân trên cây?'**
  String get createRelativeTitle;

  /// No description provided for @createRelativeSuggestedMessage.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên {userName} ghi nhận thông tin người thân: \"{suggestedName}\". Bạn có muốn tạo nhanh người thân này để phân nhánh cây gia phả không?'**
  String createRelativeSuggestedMessage(Object suggestedName, Object userName);

  /// No description provided for @createRelativeFallbackMessage.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú đăng ký: \"{notes}\". Bạn có muốn vào trang tạo thành viên mới để xếp vị trí cho {userName} không?'**
  String createRelativeFallbackMessage(Object notes, Object userName);

  /// No description provided for @laterAction.
  ///
  /// In vi, this message translates to:
  /// **'Để sau'**
  String get laterAction;

  /// No description provided for @createRelativeNowAction.
  ///
  /// In vi, this message translates to:
  /// **'Tạo người thân ngay'**
  String get createRelativeNowAction;

  /// No description provided for @statusPending.
  ///
  /// In vi, this message translates to:
  /// **'Chờ duyệt'**
  String get statusPending;

  /// No description provided for @statusApproved.
  ///
  /// In vi, this message translates to:
  /// **'Đã duyệt'**
  String get statusApproved;

  /// No description provided for @statusRejected.
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối'**
  String get statusRejected;

  /// No description provided for @maritalDivorcedStatus.
  ///
  /// In vi, this message translates to:
  /// **'Đã ly hôn'**
  String get maritalDivorcedStatus;

  /// No description provided for @maritalWidowedShort.
  ///
  /// In vi, this message translates to:
  /// **'Góa'**
  String get maritalWidowedShort;

  /// No description provided for @selectExistingMemberTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thành viên có sẵn'**
  String get selectExistingMemberTitle;

  /// No description provided for @searchMemberByNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm theo tên thành viên...'**
  String get searchMemberByNameHint;

  /// No description provided for @noUnlinkedMembers.
  ///
  /// In vi, this message translates to:
  /// **'Không có thành viên nào chưa nối cây'**
  String get noUnlinkedMembers;

  /// No description provided for @birthDateFormat.
  ///
  /// In vi, this message translates to:
  /// **'Ngày sinh: {date}'**
  String birthDateFormat(Object date);

  /// No description provided for @selectLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chọn'**
  String get selectLabel;

  /// No description provided for @memberAccessibilityFormat.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên {name}, giới tính: {gender}'**
  String memberAccessibilityFormat(Object gender, Object name);

  /// No description provided for @meLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tôi'**
  String get meLabel;

  /// No description provided for @addMemberChooseMethodDesc.
  ///
  /// In vi, this message translates to:
  /// **'Chọn cách thức thêm thành viên vào gia tộc'**
  String get addMemberChooseMethodDesc;

  /// No description provided for @linkUnlinkedMemberLabel.
  ///
  /// In vi, this message translates to:
  /// **'Kết nối thành viên chưa có trên cây'**
  String get linkUnlinkedMemberLabel;

  /// No description provided for @createNewMemberLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tạo thành viên mới'**
  String get createNewMemberLabel;

  /// No description provided for @createNewMemberDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhập đầy đủ thông tin thành viên mới'**
  String get createNewMemberDesc;

  /// No description provided for @addChildForFormat.
  ///
  /// In vi, this message translates to:
  /// **'Thêm con cho {name}'**
  String addChildForFormat(Object name);

  /// No description provided for @selectChildMemberTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thành viên làm con'**
  String get selectChildMemberTitle;

  /// No description provided for @linkAsChildFormat.
  ///
  /// In vi, this message translates to:
  /// **'Kết nối thành viên làm con của {name}'**
  String linkAsChildFormat(Object name);

  /// No description provided for @confirmConnectionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận kết nối'**
  String get confirmConnectionLabel;

  /// No description provided for @confirmLinkChildMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn gắn thành viên \"{childName}\" làm con của \"{parentName}\"?'**
  String confirmLinkChildMessage(Object childName, Object parentName);

  /// No description provided for @memberConnectedSuccessFormat.
  ///
  /// In vi, this message translates to:
  /// **'Đã kết nối thành viên \"{name}\" thành công!'**
  String memberConnectedSuccessFormat(Object name);

  /// No description provided for @addSpouseForFormat.
  ///
  /// In vi, this message translates to:
  /// **'Thêm vợ / chồng cho {name}'**
  String addSpouseForFormat(Object name);

  /// No description provided for @selectSpouseMemberTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thành viên làm vợ / chồng'**
  String get selectSpouseMemberTitle;

  /// No description provided for @linkSpouseFormat.
  ///
  /// In vi, this message translates to:
  /// **'Kết nối vợ/chồng với {name}'**
  String linkSpouseFormat(Object name);

  /// No description provided for @confirmLinkSpouseMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn kết nối vợ/chồng giữa \"{memberName}\" và \"{spouseName}\"?'**
  String confirmLinkSpouseMessage(Object memberName, Object spouseName);

  /// No description provided for @spouseConnectedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã kết nối vợ/chồng thành công!'**
  String get spouseConnectedSuccess;

  /// No description provided for @markAllReadSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã đánh dấu đọc tất cả thông báo'**
  String get markAllReadSuccess;

  /// No description provided for @markAllReadAction.
  ///
  /// In vi, this message translates to:
  /// **'Đọc tất cả'**
  String get markAllReadAction;

  /// No description provided for @importantLabel.
  ///
  /// In vi, this message translates to:
  /// **'Quan trọng'**
  String get importantLabel;

  /// No description provided for @noNotificationsMessage.
  ///
  /// In vi, this message translates to:
  /// **'Không có thông báo nào'**
  String get noNotificationsMessage;

  /// No description provided for @notificationDetailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo {title}'**
  String notificationDetailTitle(Object title);

  /// No description provided for @markAsReadAction.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu đã đọc'**
  String get markAsReadAction;

  /// No description provided for @markAsUnreadAction.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu chưa đọc'**
  String get markAsUnreadAction;

  /// No description provided for @deleteNotificationAction.
  ///
  /// In vi, this message translates to:
  /// **'Xóa thông báo'**
  String get deleteNotificationAction;

  /// No description provided for @wishLoginRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chờ tải thông tin hoặc đăng nhập lại để gửi lời chúc'**
  String get wishLoginRequired;

  /// No description provided for @noWishesMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lời chúc nào.'**
  String get noWishesMessage;

  /// No description provided for @beFirstWisher.
  ///
  /// In vi, this message translates to:
  /// **'Hãy là người đầu tiên gửi lời chúc!'**
  String get beFirstWisher;

  /// No description provided for @sendWishButton.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời chúc'**
  String get sendWishButton;

  /// No description provided for @offerIncenseButton.
  ///
  /// In vi, this message translates to:
  /// **'Dâng hương'**
  String get offerIncenseButton;

  /// No description provided for @memberLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên'**
  String get memberLabel;

  /// No description provided for @clearBranchFilterLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ lọc chi'**
  String get clearBranchFilterLabel;

  /// No description provided for @pendingApprovalRequestSent.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu tham gia dòng họ đã được gửi đi thành công. Vui lòng đợi quản trị phê duyệt hoặc liên hệ '**
  String get pendingApprovalRequestSent;

  /// No description provided for @pendingApprovalLeaderFormat.
  ///
  /// In vi, this message translates to:
  /// **'Trưởng tộc {name} - {phone}'**
  String pendingApprovalLeaderFormat(Object name, Object phone);

  /// No description provided for @pendingApprovalWaitEnd.
  ///
  /// In vi, this message translates to:
  /// **' để phê duyệt.'**
  String get pendingApprovalWaitEnd;

  /// No description provided for @errNameEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Tên không được để trống'**
  String get errNameEmpty;

  /// No description provided for @errGoogleSignInCanceled.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập Google bị huỷ bởi người dùng'**
  String get errGoogleSignInCanceled;

  /// No description provided for @errFirebaseAuth.
  ///
  /// In vi, this message translates to:
  /// **'Không thể xác thực với Firebase'**
  String get errFirebaseAuth;

  /// No description provided for @errFirebaseToken.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lấy Firebase ID Token'**
  String get errFirebaseToken;

  /// No description provided for @errServerAuth.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi xác thực máy chủ'**
  String get errServerAuth;

  /// No description provided for @errFirebaseAuthError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi Firebase Auth'**
  String get errFirebaseAuthError;

  /// No description provided for @errServerConnection.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi kết nối máy chủ'**
  String get errServerConnection;

  /// No description provided for @errGenericFormat.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi không xác định: {error}'**
  String errGenericFormat(Object error);

  /// No description provided for @errLoginFailed.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi đăng nhập'**
  String get errLoginFailed;

  /// No description provided for @errInvalidCredentials.
  ///
  /// In vi, this message translates to:
  /// **'Email hoặc mật khẩu không chính xác.'**
  String get errInvalidCredentials;

  /// No description provided for @errAccountDisabled.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản đã bị vô hiệu hoá.'**
  String get errAccountDisabled;

  /// No description provided for @errEmailInvalidFormat.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ email không đúng định dạng.'**
  String get errEmailInvalidFormat;

  /// No description provided for @errInvalidCredentialsRetry.
  ///
  /// In vi, this message translates to:
  /// **'Email hoặc mật khẩu không chính xác. Vui lòng thử lại sau vài giây.'**
  String get errInvalidCredentialsRetry;

  /// No description provided for @errRegisterFirebase.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đăng ký tài khoản với Firebase'**
  String get errRegisterFirebase;

  /// No description provided for @errFirebaseTokenAfterRegister.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lấy Firebase ID Token sau đăng ký'**
  String get errFirebaseTokenAfterRegister;

  /// No description provided for @errRegisterServer.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi đăng ký tài khoản trên máy chủ'**
  String get errRegisterServer;

  /// No description provided for @errFirebaseRegisterError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi đăng ký Firebase'**
  String get errFirebaseRegisterError;

  /// No description provided for @errEmailAlreadyUsed.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ email đã được sử dụng bởi một tài khoản khác.'**
  String get errEmailAlreadyUsed;

  /// No description provided for @errPasswordTooWeak.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu quá yếu.'**
  String get errPasswordTooWeak;

  /// No description provided for @errSendResetEmail.
  ///
  /// In vi, this message translates to:
  /// **'Không thể gửi email đặt lại mật khẩu'**
  String get errSendResetEmail;

  /// No description provided for @errServerGeneric.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi máy chủ'**
  String get errServerGeneric;

  /// No description provided for @errOtpInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Mã OTP không đúng'**
  String get errOtpInvalid;

  /// No description provided for @errResetPasswordFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đặt lại mật khẩu'**
  String get errResetPasswordFailed;

  /// No description provided for @errNoFirebaseSession.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy phiên đăng nhập Firebase'**
  String get errNoFirebaseSession;

  /// No description provided for @errCacheCredentials.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi ghi nhớ thông tin đăng nhập'**
  String get errCacheCredentials;

  /// No description provided for @errReadCredentials.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi đọc thông tin đăng nhập đã lưu'**
  String get errReadCredentials;

  /// No description provided for @errDeleteCredentials.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi xoá thông tin đăng nhập'**
  String get errDeleteCredentials;

  /// No description provided for @errSavePassword.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi ghi nhớ mật khẩu'**
  String get errSavePassword;

  /// No description provided for @errDeleteStoredCredentials.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi xoá thông tin đăng nhập đã lưu'**
  String get errDeleteStoredCredentials;

  /// No description provided for @errLoginFormat.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi đăng nhập: {error}'**
  String errLoginFormat(Object error);

  /// No description provided for @errLogoutFormat.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi đăng xuất: {error}'**
  String errLogoutFormat(Object error);

  /// No description provided for @errRegisterFormat.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi đăng ký: {error}'**
  String errRegisterFormat(Object error);

  /// No description provided for @errSaveInfoFormat.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi lưu thông tin: {error}'**
  String errSaveInfoFormat(Object error);

  /// No description provided for @errCacheCredentialsFormat.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi ghi nhớ thông tin đăng nhập: {error}'**
  String errCacheCredentialsFormat(Object error);

  /// No description provided for @errSendResetEmailFormat.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi gửi email đặt lại mật khẩu: {error}'**
  String errSendResetEmailFormat(Object error);

  /// No description provided for @errOtpVerifyFormat.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi xác thực OTP: {error}'**
  String errOtpVerifyFormat(Object error);

  /// No description provided for @errResetPasswordFormat.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi đặt lại mật khẩu: {error}'**
  String errResetPasswordFormat(Object error);

  /// No description provided for @errReloadProfileFormat.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi nạp lại thông tin người dùng: {error}'**
  String errReloadProfileFormat(Object error);

  /// No description provided for @errInvalidResponseData.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu phản hồi không hợp lệ'**
  String get errInvalidResponseData;

  /// No description provided for @errInvalidDataFormat.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu trả về không đúng định dạng'**
  String get errInvalidDataFormat;

  /// No description provided for @errInvalidListFormat.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu danh sách trả về không đúng định dạng'**
  String get errInvalidListFormat;

  /// No description provided for @errMemberNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thành viên'**
  String get errMemberNotFound;

  /// No description provided for @errSaveMember.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi lưu thành viên'**
  String get errSaveMember;

  /// No description provided for @errDeleteMember.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi xoá thành viên'**
  String get errDeleteMember;

  /// No description provided for @errBranchNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy chi/nhánh'**
  String get errBranchNotFound;

  /// No description provided for @errSaveBranch.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi lưu chi/nhánh'**
  String get errSaveBranch;

  /// No description provided for @errDeleteBranch.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi xoá chi/nhánh'**
  String get errDeleteBranch;

  /// No description provided for @errCreateFamily.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi tạo dòng họ'**
  String get errCreateFamily;

  /// No description provided for @errVerifyInviteCode.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi xác nhận mã mời'**
  String get errVerifyInviteCode;

  /// No description provided for @errSendJoinRequest.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi gửi yêu cầu gia nhập'**
  String get errSendJoinRequest;

  /// No description provided for @errLoadJoinRequest.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi tải yêu cầu gia nhập'**
  String get errLoadJoinRequest;

  /// No description provided for @errApproveRequest.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi phê duyệt yêu cầu'**
  String get errApproveRequest;

  /// No description provided for @errRejectRequest.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi từ chối yêu cầu'**
  String get errRejectRequest;

  /// No description provided for @errLoadFamilyInfo.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi tải thông tin dòng họ'**
  String get errLoadFamilyInfo;

  /// No description provided for @errUpdateFamilyInfo.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi cập nhật thông tin dòng họ'**
  String get errUpdateFamilyInfo;

  /// No description provided for @errLoadMemberList.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi tải danh sách thành viên'**
  String get errLoadMemberList;

  /// No description provided for @errUpdateMemberRole.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi phân quyền thành viên'**
  String get errUpdateMemberRole;

  /// No description provided for @errDeleteFamily.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi xóa dòng họ'**
  String get errDeleteFamily;

  /// No description provided for @errLinkFamilyProfile.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi liên kết hồ sơ gia phả'**
  String get errLinkFamilyProfile;

  /// No description provided for @errTransferOwnership.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi chuyển nhượng quyền Trưởng tộc'**
  String get errTransferOwnership;

  /// No description provided for @linkAccountsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý tài khoản & liên kết'**
  String get linkAccountsTitle;

  /// No description provided for @linkAccountsNodeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết tài khoản'**
  String get linkAccountsNodeTitle;

  /// No description provided for @linkAccountsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết tài khoản'**
  String get linkAccountsLabel;

  /// No description provided for @linkAccountEmailDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email của thành viên. Nếu email đã có tài khoản sẽ liên kết ngay; ngược lại hệ thống sẽ gửi email mời và tự động liên kết khi họ đăng ký.'**
  String get linkAccountEmailDesc;

  /// No description provided for @linkInviteButton.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết / Mời'**
  String get linkInviteButton;

  /// No description provided for @changeEmailButton.
  ///
  /// In vi, this message translates to:
  /// **'Đổi email'**
  String get changeEmailButton;

  /// No description provided for @linkButton.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết'**
  String get linkButton;

  /// No description provided for @unlinkButton.
  ///
  /// In vi, this message translates to:
  /// **'Gỡ liên kết'**
  String get unlinkButton;

  /// No description provided for @linkedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã liên kết'**
  String get linkedLabel;

  /// No description provided for @invitePendingLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chờ đăng ký'**
  String get invitePendingLabel;

  /// No description provided for @notLinkedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chưa liên kết'**
  String get notLinkedLabel;

  /// No description provided for @linkSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã liên kết tài khoản {email} thành công.'**
  String linkSuccess(Object email);

  /// No description provided for @inviteSentSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi lời mời gia nhập tới {email}.'**
  String inviteSentSuccess(Object email);

  /// No description provided for @unlinkSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã gỡ liên kết tài khoản.'**
  String get unlinkSuccess;

  /// No description provided for @confirmUnlinkTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận gỡ liên kết'**
  String get confirmUnlinkTitle;

  /// No description provided for @confirmUnlinkMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn gỡ liên kết tài khoản của thành viên {name}? Tài khoản này sẽ bị rời khỏi dòng họ và không thể truy cập thông tin gia tộc nữa.'**
  String confirmUnlinkMessage(Object name);

  /// No description provided for @trashTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thùng rác'**
  String get trashTitle;

  /// No description provided for @trashEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên trong thùng rác quá 30 ngày sẽ bị xoá vĩnh viễn.'**
  String get trashEmpty;

  /// No description provided for @trashDeletedAt.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa: {time}'**
  String trashDeletedAt(String time);

  /// No description provided for @trashRestoreButton.
  ///
  /// In vi, this message translates to:
  /// **'Khôi phục'**
  String get trashRestoreButton;

  /// No description provided for @trashPurgeButton.
  ///
  /// In vi, this message translates to:
  /// **'Dọn sạch'**
  String get trashPurgeButton;

  /// No description provided for @trashRestoreTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khôi phục thành viên'**
  String get trashRestoreTitle;

  /// No description provided for @trashRestoreMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn khôi phục thành viên \"{name}\" vào sơ đồ?'**
  String trashRestoreMessage(String name);

  /// No description provided for @trashRestoreSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã khôi phục thành viên {name}.'**
  String trashRestoreSuccess(String name);

  /// No description provided for @trashPurgeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa vĩnh viễn'**
  String get trashPurgeTitle;

  /// No description provided for @trashPurgeMessage.
  ///
  /// In vi, this message translates to:
  /// **'Xóa vĩnh viễn toàn bộ thành viên trong thùng rác quá 30 ngày? Hành động này không thể hoàn tác.'**
  String get trashPurgeMessage;

  /// No description provided for @trashPurgeSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa vĩnh viễn {count} thành viên.'**
  String trashPurgeSuccess(int count);

  /// No description provided for @auditLogsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhật ký biên soạn'**
  String get auditLogsTitle;

  /// No description provided for @auditLogsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có hoạt động biên soạn nào.'**
  String get auditLogsEmpty;

  /// No description provided for @auditUnknownActor.
  ///
  /// In vi, this message translates to:
  /// **'Không xác định'**
  String get auditUnknownActor;

  /// No description provided for @unlinkFailed.
  ///
  /// In vi, this message translates to:
  /// **'Gỡ liên kết tài khoản thất bại'**
  String get unlinkFailed;

  /// No description provided for @auditActorLabel.
  ///
  /// In vi, this message translates to:
  /// **'Người thực hiện:'**
  String get auditActorLabel;

  /// No description provided for @auditEmailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Email:'**
  String get auditEmailLabel;

  /// No description provided for @auditActionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hành động:'**
  String get auditActionLabel;

  /// No description provided for @auditTargetLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đối tượng:'**
  String get auditTargetLabel;

  /// No description provided for @auditTimeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian:'**
  String get auditTimeLabel;

  /// No description provided for @auditChangedFieldsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết các trường thay đổi:'**
  String get auditChangedFieldsTitle;

  /// No description provided for @viewMemberPage.
  ///
  /// In vi, this message translates to:
  /// **'Xem trang thành viên'**
  String get viewMemberPage;

  /// No description provided for @memberNoLongerExists.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên này có thể đã bị xóa hoặc không còn tồn tại.'**
  String get memberNoLongerExists;

  /// No description provided for @disabledLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã tắt'**
  String get disabledLabel;

  /// No description provided for @enabledCountFormat.
  ///
  /// In vi, this message translates to:
  /// **'Đang bật ({count}/3)'**
  String enabledCountFormat(int count);

  /// No description provided for @notifEventSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật lịch sự kiện và họp mặt dòng tộc'**
  String get notifEventSubtitle;

  /// No description provided for @notifNewsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhận tin tức và thông cáo quan trọng từ Ban quản trị'**
  String get notifNewsSubtitle;

  /// No description provided for @notifWishSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo khi nhận được lời chúc từ các thành viên'**
  String get notifWishSubtitle;

  /// No description provided for @notifAnniversarySubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo nhắc lịch giỗ chạp và sinh nhật thành viên'**
  String get notifAnniversarySubtitle;

  /// No description provided for @imageTooLargeFormat.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh phải nhỏ hơn {size}MB'**
  String imageTooLargeFormat(int size);

  /// No description provided for @generationTooHighFormat.
  ///
  /// In vi, this message translates to:
  /// **'Thế hệ không thể vượt quá thế hệ hiện tại + 1 (tối đa: {max})'**
  String generationTooHighFormat(int max);

  /// No description provided for @closeSearchTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Đóng tìm kiếm'**
  String get closeSearchTooltip;

  /// No description provided for @searchMemberTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm thành viên'**
  String get searchMemberTooltip;

  /// No description provided for @hideGenBadges.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn nhãn thế hệ'**
  String get hideGenBadges;

  /// No description provided for @showGenBadges.
  ///
  /// In vi, this message translates to:
  /// **'Hiện nhãn thế hệ'**
  String get showGenBadges;

  /// No description provided for @treeOverviewTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan sơ đồ'**
  String get treeOverviewTooltip;

  /// No description provided for @generationLevelFormat.
  ///
  /// In vi, this message translates to:
  /// **'Đời {gen}'**
  String generationLevelFormat(String gen);

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản của bạn đã được xóa.'**
  String get deleteAccountSuccess;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể xóa tài khoản.'**
  String get deleteAccountFailed;

  /// No description provided for @deleteAccountButton.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tài khoản'**
  String get deleteAccountButton;

  /// No description provided for @dangerZoneDesc.
  ///
  /// In vi, this message translates to:
  /// **'Sau khi xóa tài khoản, toàn bộ dữ liệu cá nhân sẽ bị xóa vĩnh viễn và không thể khôi phục.'**
  String get dangerZoneDesc;

  /// No description provided for @reportContentTitle.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo vi phạm'**
  String get reportContentTitle;

  /// No description provided for @selectReportReason.
  ///
  /// In vi, this message translates to:
  /// **'Chọn lý do báo cáo'**
  String get selectReportReason;

  /// No description provided for @reportReasonInappropriate.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung không phù hợp'**
  String get reportReasonInappropriate;

  /// No description provided for @reportReasonAbusive.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn từ xúc phạm, thô tục'**
  String get reportReasonAbusive;

  /// No description provided for @reportReasonFalseInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin sai sự thật'**
  String get reportReasonFalseInfo;

  /// No description provided for @reportReasonSpam.
  ///
  /// In vi, this message translates to:
  /// **'Spam / Quảng cáo'**
  String get reportReasonSpam;

  /// No description provided for @reportReasonOther.
  ///
  /// In vi, this message translates to:
  /// **'Lý do khác'**
  String get reportReasonOther;

  /// No description provided for @reportSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo đã được ghi nhận. Cảm ơn bạn!'**
  String get reportSuccessMessage;

  /// No description provided for @reportFailedMessage.
  ///
  /// In vi, this message translates to:
  /// **'Không thể gửi báo cáo. Vui lòng thử lại.'**
  String get reportFailedMessage;

  /// No description provided for @otpResendCountdownFormat.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại mã sau {seconds} giây'**
  String otpResendCountdownFormat(int seconds);

  /// No description provided for @typeConfirmToTransfer.
  ///
  /// In vi, this message translates to:
  /// **'Nhập \"XÁC NHẬN\" để đồng ý chuyển quyền Trưởng tộc:'**
  String get typeConfirmToTransfer;

  /// No description provided for @confirmWord.
  ///
  /// In vi, this message translates to:
  /// **'XÁC NHẬN'**
  String get confirmWord;

  /// No description provided for @dissolveWord.
  ///
  /// In vi, this message translates to:
  /// **'GIẢI TÁN'**
  String get dissolveWord;

  /// No description provided for @rolePermissionDenied.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản của bạn không có quyền truy cập trang này.'**
  String get rolePermissionDenied;

  /// No description provided for @notifWishTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lời chúc'**
  String get notifWishTitle;

  /// No description provided for @notifBirthdayTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sinh nhật hôm nay'**
  String get notifBirthdayTitle;

  /// No description provided for @notifDeathAnniversaryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngày giỗ hôm nay'**
  String get notifDeathAnniversaryTitle;

  /// No description provided for @notifAnnouncementTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo mới từ dòng họ'**
  String get notifAnnouncementTitle;

  /// No description provided for @notifNewEventTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện mới'**
  String get notifNewEventTitle;

  /// No description provided for @notifGenericBody.
  ///
  /// In vi, this message translates to:
  /// **'Có thông báo mới từ dòng họ'**
  String get notifGenericBody;

  /// No description provided for @notifDeathOfPart.
  ///
  /// In vi, this message translates to:
  /// **'ngày giỗ của {names}'**
  String notifDeathOfPart(String names);

  /// No description provided for @notifBirthdayOfPart.
  ///
  /// In vi, this message translates to:
  /// **'sinh nhật của {names}'**
  String notifBirthdayOfPart(String names);

  /// No description provided for @notifAnniversariesTodayTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giỗ & sinh nhật hôm nay'**
  String get notifAnniversariesTodayTitle;

  /// No description provided for @notifTodayBody.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay là {parts}.'**
  String notifTodayBody(String parts);

  /// No description provided for @optionsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ chọn'**
  String get optionsLabel;

  /// No description provided for @resetFilterLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại'**
  String get resetFilterLabel;

  /// No description provided for @incenseSubtitleRemember.
  ///
  /// In vi, this message translates to:
  /// **'Tưởng nhớ tiền nhân dòng tộc'**
  String get incenseSubtitleRemember;

  /// No description provided for @incenseDefaultPrayer.
  ///
  /// In vi, this message translates to:
  /// **'Thắp nén tâm nhang tưởng nhớ tiền nhân thành kính.'**
  String get incenseDefaultPrayer;

  /// No description provided for @incenseLitFor.
  ///
  /// In vi, this message translates to:
  /// **'Đã thắp nén tâm nhang tưởng nhớ {name} thành kính!'**
  String incenseLitFor(String name);

  /// No description provided for @anniversariesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giỗ & sinh nhật'**
  String get anniversariesTitle;

  /// No description provided for @incenseLitStatus.
  ///
  /// In vi, this message translates to:
  /// **'Đã thắp'**
  String get incenseLitStatus;

  /// No description provided for @incenseLightingStatus.
  ///
  /// In vi, this message translates to:
  /// **'Đang thắp'**
  String get incenseLightingStatus;

  /// No description provided for @incensePrayerHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lời khấn nguyện / tâm nguyện thành kính...'**
  String get incensePrayerHint;

  /// No description provided for @incenseOfferedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã dâng hương'**
  String get incenseOfferedLabel;

  /// No description provided for @incenseOfferingLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đang dâng hương...'**
  String get incenseOfferingLabel;

  /// No description provided for @incenseLightButton.
  ///
  /// In vi, this message translates to:
  /// **'Thắp nhang thành kính'**
  String get incenseLightButton;

  /// No description provided for @clearAllLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ chọn tất cả'**
  String get clearAllLabel;

  /// No description provided for @sortByLabel.
  ///
  /// In vi, this message translates to:
  /// **'Sắp xếp'**
  String get sortByLabel;

  /// No description provided for @sortNewestLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mới nhất'**
  String get sortNewestLabel;

  /// No description provided for @sortOldestLabel.
  ///
  /// In vi, this message translates to:
  /// **'Cũ nhất'**
  String get sortOldestLabel;

  /// No description provided for @sortNearestLabel.
  ///
  /// In vi, this message translates to:
  /// **'Gần nhất'**
  String get sortNearestLabel;

  /// No description provided for @sortFurthestLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xa nhất'**
  String get sortFurthestLabel;

  /// No description provided for @searchDeathAnniversaryHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm ngày giỗ...'**
  String get searchDeathAnniversaryHint;

  /// No description provided for @searchBirthdayHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm ngày sinh nhật...'**
  String get searchBirthdayHint;

  /// No description provided for @deathAnniversaryTab.
  ///
  /// In vi, this message translates to:
  /// **'Ngày giỗ'**
  String get deathAnniversaryTab;

  /// No description provided for @birthdayTab.
  ///
  /// In vi, this message translates to:
  /// **'Sinh nhật'**
  String get birthdayTab;

  /// No description provided for @notificationDeletedMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá thông báo'**
  String get notificationDeletedMessage;

  /// No description provided for @clanMemberLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên dòng họ'**
  String get clanMemberLabel;

  /// No description provided for @memorialCeremonyGenerationLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lễ tưởng niệm tiền nhân đời thứ {generation}'**
  String memorialCeremonyGenerationLabel(int generation);

  /// No description provided for @memorialCeremonyLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lễ giỗ tưởng niệm tiền nhân'**
  String get memorialCeremonyLabel;

  /// No description provided for @highlightTypeEventLabel.
  ///
  /// In vi, this message translates to:
  /// **'SỰ KIỆN DÒNG TỘC'**
  String get highlightTypeEventLabel;

  /// No description provided for @viewEventDetailsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xem chi tiết sự kiện'**
  String get viewEventDetailsLabel;

  /// No description provided for @highlightTypeBirthdayLabel.
  ///
  /// In vi, this message translates to:
  /// **'SINH NHẬT THÀNH VIÊN'**
  String get highlightTypeBirthdayLabel;

  /// No description provided for @sendBirthdayWishLabel.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời chúc sinh nhật'**
  String get sendBirthdayWishLabel;

  /// No description provided for @lightIncenseLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thắp nén tâm nhang'**
  String get lightIncenseLabel;

  /// No description provided for @commentsCountLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bình luận ({count})'**
  String commentsCountLabel(int count);

  /// No description provided for @noCommentsMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bình luận nào.'**
  String get noCommentsMessage;

  /// No description provided for @beFirstCommentMessage.
  ///
  /// In vi, this message translates to:
  /// **'Hãy là người đầu tiên để lại ý kiến!'**
  String get beFirstCommentMessage;

  /// No description provided for @anonymousLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn danh'**
  String get anonymousLabel;

  /// No description provided for @writeCommentHint.
  ///
  /// In vi, this message translates to:
  /// **'Viết bình luận...'**
  String get writeCommentHint;

  /// No description provided for @collapseLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thu gọn'**
  String get collapseLabel;

  /// No description provided for @viewMoreLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xem thêm'**
  String get viewMoreLabel;

  /// No description provided for @likeCountLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thích ({count})'**
  String likeCountLabel(int count);

  /// No description provided for @likeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thích'**
  String get likeLabel;

  /// No description provided for @commentLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bình luận'**
  String get commentLabel;

  /// No description provided for @memberBirthdayLabel.
  ///
  /// In vi, this message translates to:
  /// **'Sinh nhật thành viên'**
  String get memberBirthdayLabel;

  /// No description provided for @deathAnniversaryMemorialLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày giỗ tưởng niệm'**
  String get deathAnniversaryMemorialLabel;

  /// No description provided for @happyBirthdayTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chúc mừng sinh nhật!'**
  String get happyBirthdayTitle;

  /// No description provided for @noIncenseWishesMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có nén tâm nhang nào'**
  String get noIncenseWishesMessage;

  /// No description provided for @beFirstIncenseMessage.
  ///
  /// In vi, this message translates to:
  /// **'Hãy là người đầu tiên thắp nén tâm nhang tưởng nhớ.'**
  String get beFirstIncenseMessage;

  /// No description provided for @memberDiedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mất: {date}'**
  String memberDiedLabel(String date);

  /// No description provided for @addChildLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thêm con'**
  String get addChildLabel;

  /// No description provided for @addHusbandLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thêm chồng'**
  String get addHusbandLabel;

  /// No description provided for @addWifeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thêm vợ'**
  String get addWifeLabel;

  /// No description provided for @cannotDeleteAccountTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa thể xóa tài khoản'**
  String get cannotDeleteAccountTitle;

  /// No description provided for @cannotDeleteAccountContent.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang giữ vai trò Trưởng tộc của dòng họ. Để đảm bảo an toàn cho dữ liệu dòng tộc, bạn cần chuyển nhượng quyền Trưởng tộc cho thành viên khác trước khi xóa tài khoản.'**
  String get cannotDeleteAccountContent;

  /// No description provided for @transferOwnershipShortLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển nhượng quyền'**
  String get transferOwnershipShortLabel;

  /// No description provided for @deleteAccountPermanentTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tài khoản vĩnh viễn'**
  String get deleteAccountPermanentTitle;

  /// No description provided for @deleteAccountPermanentContent.
  ///
  /// In vi, this message translates to:
  /// **'Toàn bộ thông tin cá nhân, quyền hạn và liên kết gia phả của bạn sẽ bị xóa vĩnh viễn không thể khôi phục.'**
  String get deleteAccountPermanentContent;

  /// No description provided for @deleteAccountRequiredWord.
  ///
  /// In vi, this message translates to:
  /// **'XÓA TÀI KHOẢN'**
  String get deleteAccountRequiredWord;

  /// No description provided for @deleteAccountInputInstruction.
  ///
  /// In vi, this message translates to:
  /// **'Nhập chính xác cụm từ \"XÓA TÀI KHOẢN\" để xác nhận:'**
  String get deleteAccountInputInstruction;

  /// No description provided for @confirmDeleteLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận xóa'**
  String get confirmDeleteLabel;

  /// No description provided for @clanCodeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mã gia tộc:'**
  String get clanCodeLabel;

  /// No description provided for @qrCodeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mã QR'**
  String get qrCodeLabel;

  /// No description provided for @helloLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xin chào, '**
  String get helloLabel;

  /// No description provided for @youLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bạn'**
  String get youLabel;

  /// No description provided for @clanLabel.
  ///
  /// In vi, this message translates to:
  /// **'Dòng họ'**
  String get clanLabel;

  /// No description provided for @familyNamePrefix.
  ///
  /// In vi, this message translates to:
  /// **'Họ {name}'**
  String familyNamePrefix(String name);

  /// No description provided for @orLabel.
  ///
  /// In vi, this message translates to:
  /// **' hoặc '**
  String get orLabel;

  /// No description provided for @founderLabel.
  ///
  /// In vi, this message translates to:
  /// **'Người sáng lập'**
  String get founderLabel;

  /// No description provided for @establishedYearLabel.
  ///
  /// In vi, this message translates to:
  /// **'Năm thành lập'**
  String get establishedYearLabel;

  /// No description provided for @regionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Khu vực / Địa bàn'**
  String get regionLabel;

  /// No description provided for @memberCountLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số lượng thành viên'**
  String get memberCountLabel;

  /// No description provided for @roleColonLabel.
  ///
  /// In vi, this message translates to:
  /// **'Vai trò:'**
  String get roleColonLabel;

  /// No description provided for @clanLeaderAdminLabel.
  ///
  /// In vi, this message translates to:
  /// **'Trưởng tộc / Quản trị viên'**
  String get clanLeaderAdminLabel;

  /// No description provided for @roleFieldLabel.
  ///
  /// In vi, this message translates to:
  /// **'Vai trò'**
  String get roleFieldLabel;

  /// No description provided for @titleFieldLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề'**
  String get titleFieldLabel;

  /// No description provided for @dateFieldLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get dateFieldLabel;

  /// No description provided for @contentFieldLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung'**
  String get contentFieldLabel;

  /// No description provided for @newOwnerFieldLabel.
  ///
  /// In vi, this message translates to:
  /// **'Trưởng tộc mới'**
  String get newOwnerFieldLabel;

  /// No description provided for @auditSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm theo người thực hiện, đối tượng...'**
  String get auditSearchHint;

  /// No description provided for @deletedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá'**
  String get deletedLabel;

  /// No description provided for @auditActionMemberCreate.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã thêm thành viên mới'**
  String auditActionMemberCreate(String actor);

  /// No description provided for @auditActionMemberUpdate.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã cập nhật thành viên'**
  String auditActionMemberUpdate(String actor);

  /// No description provided for @auditActionMemberSoftDelete.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã đưa thành viên vào thùng rác'**
  String auditActionMemberSoftDelete(String actor);

  /// No description provided for @auditActionMemberRestore.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã khôi phục thành viên'**
  String auditActionMemberRestore(String actor);

  /// No description provided for @auditActionMemberPurge.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã dọn dẹp thùng rác'**
  String auditActionMemberPurge(String actor);

  /// No description provided for @auditActionInvite.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã gửi lời mời gia nhập gia tộc'**
  String auditActionInvite(String actor);

  /// No description provided for @auditActionRoleChange.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã thay đổi phân quyền thành viên'**
  String auditActionRoleChange(String actor);

  /// No description provided for @auditActionLinkAccount.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã liên kết tài khoản cho thành viên'**
  String auditActionLinkAccount(String actor);

  /// No description provided for @auditActionUnlinkAccount.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã gỡ liên kết tài khoản'**
  String auditActionUnlinkAccount(String actor);

  /// No description provided for @auditActionTransferOwnership.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã chuyển nhượng quyền Trưởng tộc'**
  String auditActionTransferOwnership(String actor);

  /// No description provided for @auditActionFamilyCreate.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã khởi tạo dòng họ'**
  String auditActionFamilyCreate(String actor);

  /// No description provided for @auditActionFamilyUpdate.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã cập nhật thông tin dòng họ'**
  String auditActionFamilyUpdate(String actor);

  /// No description provided for @auditActionFamilyDissolve.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã giải tán dòng họ'**
  String auditActionFamilyDissolve(String actor);

  /// No description provided for @auditActionBranchCreate.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã thêm chi tộc mới'**
  String auditActionBranchCreate(String actor);

  /// No description provided for @auditActionBranchUpdate.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã cập nhật chi tộc'**
  String auditActionBranchUpdate(String actor);

  /// No description provided for @auditActionBranchDelete.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã xoá chi tộc'**
  String auditActionBranchDelete(String actor);

  /// No description provided for @auditActionEventCreate.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã tạo sự kiện mới'**
  String auditActionEventCreate(String actor);

  /// No description provided for @auditActionEventUpdate.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã cập nhật sự kiện'**
  String auditActionEventUpdate(String actor);

  /// No description provided for @auditActionEventDelete.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã xoá sự kiện'**
  String auditActionEventDelete(String actor);

  /// No description provided for @auditActionGeneric.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã thực hiện: {action}'**
  String auditActionGeneric(String actor, String action);

  /// No description provided for @auditDetailEdit.
  ///
  /// In vi, this message translates to:
  /// **'{name} · Sửa: {fields}'**
  String auditDetailEdit(String name, String fields);

  /// No description provided for @auditDetailChanges.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi: {fields}'**
  String auditDetailChanges(String fields);

  /// No description provided for @auditDetailTarget.
  ///
  /// In vi, this message translates to:
  /// **'Đối tượng: {name}'**
  String auditDetailTarget(String name);

  /// No description provided for @supremeRoleLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tối cao'**
  String get supremeRoleLabel;

  /// No description provided for @transferFullOwnershipLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển giao toàn quyền quản trị dòng họ cho người này'**
  String get transferFullOwnershipLabel;

  /// No description provided for @darkModeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get darkModeLabel;

  /// No description provided for @lightModeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get lightModeLabel;

  /// No description provided for @copyImageAction.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép ảnh'**
  String get copyImageAction;

  /// No description provided for @imageLinkCopied.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép liên kết hình ảnh'**
  String get imageLinkCopied;

  /// No description provided for @deleteWishTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa lời chúc'**
  String get deleteWishTitle;

  /// No description provided for @deleteMemorialTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa lời tưởng niệm'**
  String get deleteMemorialTitle;

  /// No description provided for @deleteWishConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xóa lời chúc này không?'**
  String get deleteWishConfirmMessage;

  /// No description provided for @deleteMemorialConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xóa lời tưởng niệm này không?'**
  String get deleteMemorialConfirmMessage;

  /// No description provided for @deleteWishSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa lời chúc thành công'**
  String get deleteWishSuccessMessage;

  /// No description provided for @deleteMemorialSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa lời tưởng niệm thành công'**
  String get deleteMemorialSuccessMessage;

  /// No description provided for @timeJustNow.
  ///
  /// In vi, this message translates to:
  /// **'Vừa xong'**
  String get timeJustNow;

  /// No description provided for @minutesAgoFormat.
  ///
  /// In vi, this message translates to:
  /// **'{count} phút trước'**
  String minutesAgoFormat(int count);

  /// No description provided for @hoursAgoFormat.
  ///
  /// In vi, this message translates to:
  /// **'{count} giờ trước'**
  String hoursAgoFormat(int count);

  /// No description provided for @daysAgoFormat.
  ///
  /// In vi, this message translates to:
  /// **'{count} ngày trước'**
  String daysAgoFormat(int count);

  /// No description provided for @adminBoardLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ban Quản Trị'**
  String get adminBoardLabel;

  /// No description provided for @birthdayWishTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chúc mừng sinh nhật'**
  String get birthdayWishTitle;

  /// No description provided for @newWishTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lời chúc mới'**
  String get newWishTitle;

  /// No description provided for @aMemberLabel.
  ///
  /// In vi, this message translates to:
  /// **'Một thành viên'**
  String get aMemberLabel;

  /// No description provided for @allTab.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get allTab;

  /// No description provided for @unreadTab.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đọc'**
  String get unreadTab;

  /// No description provided for @noUnreadNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Không có thông báo chưa đọc nào'**
  String get noUnreadNotifications;

  /// No description provided for @sentBirthdayWishToYou.
  ///
  /// In vi, this message translates to:
  /// **'đã gửi lời chúc mừng sinh nhật đến bạn'**
  String get sentBirthdayWishToYou;

  /// No description provided for @sentWishToYou.
  ///
  /// In vi, this message translates to:
  /// **'đã gửi một lời chúc đến bạn'**
  String get sentWishToYou;

  /// No description provided for @postedAnAnnouncementFormat.
  ///
  /// In vi, this message translates to:
  /// **'đã đăng một thông báo: {title}'**
  String postedAnAnnouncementFormat(String title);

  /// No description provided for @createdNewEventFormat.
  ///
  /// In vi, this message translates to:
  /// **'đã tạo sự kiện mới: {title}'**
  String createdNewEventFormat(String title);

  /// No description provided for @turningAgeFormat.
  ///
  /// In vi, this message translates to:
  /// **'{age} tuổi'**
  String turningAgeFormat(int age);

  /// No description provided for @livingAgeFormat.
  ///
  /// In vi, this message translates to:
  /// **'Thọ {age} tuổi'**
  String livingAgeFormat(int age);

  /// No description provided for @kinshipUnknown.
  ///
  /// In vi, this message translates to:
  /// **'Đồng tộc / Chưa rõ liên kết'**
  String get kinshipUnknown;

  /// No description provided for @lunarShort.
  ///
  /// In vi, this message translates to:
  /// **'ÂL'**
  String get lunarShort;

  /// No description provided for @noClanCode.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có mã gia tộc'**
  String get noClanCode;

  /// No description provided for @updateInfoSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật thông tin thành công'**
  String get updateInfoSuccess;

  /// No description provided for @accountNotLinkedWithMember.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản chưa được liên kết với thành viên trên cây gia phả'**
  String get accountNotLinkedWithMember;

  /// No description provided for @noMemberDataToExport.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu thành viên để xuất gia phả.'**
  String get noMemberDataToExport;

  /// No description provided for @exportFamilyTreeFile.
  ///
  /// In vi, this message translates to:
  /// **'Xuất Phả Ký / Phả Đồ'**
  String get exportFamilyTreeFile;

  /// No description provided for @myLocationOnTree.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí của tôi'**
  String get myLocationOnTree;

  /// No description provided for @selfRelationTag.
  ///
  /// In vi, this message translates to:
  /// **'(Tôi)'**
  String get selfRelationTag;

  /// No description provided for @familyBookConfigTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xuất Phả Ký & Phả Đồ'**
  String get familyBookConfigTitle;

  /// No description provided for @familyBookPreviewPdf.
  ///
  /// In vi, this message translates to:
  /// **'Xem trước PDF'**
  String get familyBookPreviewPdf;

  /// No description provided for @familyBookSectionStyle.
  ///
  /// In vi, this message translates to:
  /// **'1. Phong Cách Giao Diện & Bìa Phả Ký'**
  String get familyBookSectionStyle;

  /// No description provided for @themeLightLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chủ đề sáng'**
  String get themeLightLabel;

  /// No description provided for @themeDarkLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chủ đề tối'**
  String get themeDarkLabel;

  /// No description provided for @themeBlankLabel.
  ///
  /// In vi, this message translates to:
  /// **'Để trống'**
  String get themeBlankLabel;

  /// No description provided for @familyBookSectionInfo.
  ///
  /// In vi, this message translates to:
  /// **'2. Thông Tin Bìa & Tiền Nhân'**
  String get familyBookSectionInfo;

  /// No description provided for @familyBookTitleLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề Phả Ký'**
  String get familyBookTitleLabel;

  /// No description provided for @familyBookTitleHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: PHẢ KÝ ĐẠI TÔN HỌ NGUYỄN'**
  String get familyBookTitleHint;

  /// No description provided for @familyBookFounderLabel.
  ///
  /// In vi, this message translates to:
  /// **'Danh tính Cụ Thủy Tổ / Khởi Tổ'**
  String get familyBookFounderLabel;

  /// No description provided for @familyBookFounderHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Thủy Tổ: Nguyễn Văn A'**
  String get familyBookFounderHint;

  /// No description provided for @familyBookLocationLabel.
  ///
  /// In vi, this message translates to:
  /// **'Địa danh Từ Đường / Quê quán phát tích'**
  String get familyBookLocationLabel;

  /// No description provided for @familyBookLocationHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Từ Đường Họ Nguyễn, Xã..., Huyện..., Tỉnh...'**
  String get familyBookLocationHint;

  /// No description provided for @familyBookEditorLabel.
  ///
  /// In vi, this message translates to:
  /// **'Người biên soạn'**
  String get familyBookEditorLabel;

  /// No description provided for @familyBookEditorHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Hội Đồng Gia Tộc'**
  String get familyBookEditorHint;

  /// No description provided for @familyBookYearLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian biên soạn'**
  String get familyBookYearLabel;

  /// No description provided for @familyBookYearHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Năm Bính Ngọ 2026'**
  String get familyBookYearHint;

  /// No description provided for @familyBookSectionPreface.
  ///
  /// In vi, this message translates to:
  /// **'3. Lời Tựa & Gia Huấn Dòng Tộc'**
  String get familyBookSectionPreface;

  /// No description provided for @familyBookPrefaceTab.
  ///
  /// In vi, this message translates to:
  /// **'Lời Nói Đầu Cội Nguồn'**
  String get familyBookPrefaceTab;

  /// No description provided for @familyBookRulesTab.
  ///
  /// In vi, this message translates to:
  /// **'Tộc Ước & Gia Quy Tiên Tổ'**
  String get familyBookRulesTab;

  /// No description provided for @familyBookMemorialTab.
  ///
  /// In vi, this message translates to:
  /// **'Khắc Ghi Tri Ân Hậu Thế'**
  String get familyBookMemorialTab;

  /// No description provided for @familyBookSectionContent.
  ///
  /// In vi, this message translates to:
  /// **'4. Tùy Chọn Nội Dung Xuất Bản'**
  String get familyBookSectionContent;

  /// No description provided for @familyBookOptTreeChart.
  ///
  /// In vi, this message translates to:
  /// **'Sơ đồ Phả Đồ trực quan'**
  String get familyBookOptTreeChart;

  /// No description provided for @familyBookOptTreeChartDesc.
  ///
  /// In vi, this message translates to:
  /// **'Lược đồ phân nhánh thế thứ kết nối các thế hệ dòng họ'**
  String get familyBookOptTreeChartDesc;

  /// No description provided for @familyBookOptStats.
  ///
  /// In vi, this message translates to:
  /// **'Bảng thống kê nhân khẩu'**
  String get familyBookOptStats;

  /// No description provided for @familyBookOptStatsDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tổng hợp số đời, nam đinh, nữ giới, dâu hiền, sinh tử'**
  String get familyBookOptStatsDesc;

  /// No description provided for @familyBookOptAnniversary.
  ///
  /// In vi, this message translates to:
  /// **'Kỵ Nhật Biểu (Lịch giỗ 12 tháng ÂL)'**
  String get familyBookOptAnniversary;

  /// No description provided for @familyBookOptAnniversaryDesc.
  ///
  /// In vi, this message translates to:
  /// **'Bảng tổng hợp ngày kỵ nhật chư vị tôn linh trong năm'**
  String get familyBookOptAnniversaryDesc;

  /// No description provided for @familyBookOptTombs.
  ///
  /// In vi, this message translates to:
  /// **'Mộ chí & Nơi an táng'**
  String get familyBookOptTombs;

  /// No description provided for @familyBookOptTombsDesc.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chép thông tin nơi an táng của các bậc tiền nhân'**
  String get familyBookOptTombsDesc;

  /// No description provided for @familyBookResetDefault.
  ///
  /// In vi, this message translates to:
  /// **'Khôi phục văn mẫu'**
  String get familyBookResetDefault;

  /// No description provided for @familyBookPreviewTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xem Trước Phả Ký'**
  String get familyBookPreviewTitle;

  /// No description provided for @familyBookSharePdf.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ PDF'**
  String get familyBookSharePdf;

  /// No description provided for @familyBookPrint.
  ///
  /// In vi, this message translates to:
  /// **'In Phả Ký'**
  String get familyBookPrint;

  /// No description provided for @familyBookRendering.
  ///
  /// In vi, this message translates to:
  /// **'Đang biên tập & mở Phả Ký...'**
  String get familyBookRendering;

  /// No description provided for @familyBookPleaseWait.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chờ trong giây lát'**
  String get familyBookPleaseWait;

  /// No description provided for @noPageData.
  ///
  /// In vi, this message translates to:
  /// **'Không có dữ liệu trang'**
  String get noPageData;

  /// No description provided for @requestLinkWithFormat.
  ///
  /// In vi, this message translates to:
  /// **'Xin liên kết với: {name}'**
  String requestLinkWithFormat(String name);

  /// No description provided for @requestNewMemberFormat.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên mới: {name}'**
  String requestNewMemberFormat(String name);

  /// No description provided for @joinClanRequest.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu tham gia'**
  String get joinClanRequest;

  /// No description provided for @memberLinkRequestTitle.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu liên kết thành viên'**
  String get memberLinkRequestTitle;

  /// No description provided for @newMemberRegistrationTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký thành viên mới'**
  String get newMemberRegistrationTitle;

  /// No description provided for @senderAccountLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản người gửi yêu cầu'**
  String get senderAccountLabel;

  /// No description provided for @roleRequestedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Vai trò xin cấp'**
  String get roleRequestedLabel;

  /// No description provided for @treeMemberInfoLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin thành viên trên cây'**
  String get treeMemberInfoLabel;

  /// No description provided for @notCategorizedBranch.
  ///
  /// In vi, this message translates to:
  /// **'Chưa phân chi'**
  String get notCategorizedBranch;

  /// No description provided for @permanentDeleteMemberConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xoá vĩnh viễn thành viên \"{name}\"? Hành động này không thể hoàn tác.'**
  String permanentDeleteMemberConfirm(String name);

  /// No description provided for @permanentDeleteAllTrashConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xoá vĩnh viễn toàn bộ thành viên trong thùng rác? Hành động này không thể hoàn tác.'**
  String get permanentDeleteAllTrashConfirm;

  /// No description provided for @permanentDeleteSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá vĩnh viễn thành viên khỏi thùng rác.'**
  String get permanentDeleteSuccess;

  /// No description provided for @cleanTrashButton.
  ///
  /// In vi, this message translates to:
  /// **'Dọn sạch'**
  String get cleanTrashButton;

  /// No description provided for @memberAlreadyLinkedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên đã được liên kết'**
  String get memberAlreadyLinkedTitle;

  /// No description provided for @memberAlreadyLinkedDescFormat.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên \"{name}\" đã được liên kết với một tài khoản khác.\n\nBạn không thể gửi yêu cầu liên kết vào thành viên này. Vui lòng chọn thành viên khác hoặc tích chọn \"Tôi chưa có tên trên cây gia phả\".'**
  String memberAlreadyLinkedDescFormat(String name);

  /// No description provided for @unlinkAccountFailed.
  ///
  /// In vi, this message translates to:
  /// **'Gỡ liên kết tài khoản thất bại'**
  String get unlinkAccountFailed;

  /// No description provided for @dissolveClanFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể giải tán dòng họ'**
  String get dissolveClanFailed;

  /// No description provided for @assignRoleFailed.
  ///
  /// In vi, this message translates to:
  /// **'Phân quyền thất bại'**
  String get assignRoleFailed;

  /// No description provided for @transferOwnershipFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể chuyển nhượng quyền Trưởng tộc'**
  String get transferOwnershipFailed;

  /// No description provided for @notUpdatedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chưa cập nhật'**
  String get notUpdatedLabel;

  /// No description provided for @branchNameFieldLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chi họ'**
  String get branchNameFieldLabel;

  /// No description provided for @statusLinked.
  ///
  /// In vi, this message translates to:
  /// **'Đã liên kết'**
  String get statusLinked;

  /// No description provided for @contentLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung'**
  String get contentLabel;

  /// No description provided for @writeContentHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập nội dung...'**
  String get writeContentHint;

  /// No description provided for @familyBookTabBook.
  ///
  /// In vi, this message translates to:
  /// **'Phả Ký (Sách A4)'**
  String get familyBookTabBook;

  /// No description provided for @familyBookTabPoster.
  ///
  /// In vi, this message translates to:
  /// **'Phả Đồ (Tranh)'**
  String get familyBookTabPoster;

  /// No description provided for @familyBookScopeGenerations.
  ///
  /// In vi, this message translates to:
  /// **'Phạm vi thế hệ xuất bản'**
  String get familyBookScopeGenerations;

  /// No description provided for @familyBookScopeGenerationsRange.
  ///
  /// In vi, this message translates to:
  /// **'Đời {start} - Đời {end}'**
  String familyBookScopeGenerationsRange(int start, int end);

  /// No description provided for @familyBookStandardSample.
  ///
  /// In vi, this message translates to:
  /// **'Mẫu chuẩn'**
  String get familyBookStandardSample;

  /// No description provided for @familyBookInputContentHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập nội dung...'**
  String get familyBookInputContentHint;

  /// No description provided for @familyBookThemePlainShort.
  ///
  /// In vi, this message translates to:
  /// **'TỐI GIẢN'**
  String get familyBookThemePlainShort;

  /// No description provided for @familyBookArtBorder.
  ///
  /// In vi, this message translates to:
  /// **'Viền mỹ thuật'**
  String get familyBookArtBorder;

  /// No description provided for @familyPosterPreviewTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xem Trước Tranh Phả Đồ'**
  String get familyPosterPreviewTitle;

  /// No description provided for @familyPosterOrientationLandscape.
  ///
  /// In vi, this message translates to:
  /// **'Khổ ngang'**
  String get familyPosterOrientationLandscape;

  /// No description provided for @familyPosterOrientationPortrait.
  ///
  /// In vi, this message translates to:
  /// **'Khổ dọc'**
  String get familyPosterOrientationPortrait;

  /// No description provided for @familyPosterRendering.
  ///
  /// In vi, this message translates to:
  /// **'Đang dựng tranh Phả Đồ {size}...'**
  String familyPosterRendering(String size);

  /// No description provided for @familyPosterPrintQuality.
  ///
  /// In vi, this message translates to:
  /// **'Độ nét cao chuẩn in ấn'**
  String get familyPosterPrintQuality;

  /// No description provided for @familyPosterNoData.
  ///
  /// In vi, this message translates to:
  /// **'Không có dữ liệu tranh'**
  String get familyPosterNoData;

  /// No description provided for @familyPosterFitScreen.
  ///
  /// In vi, this message translates to:
  /// **'Vừa màn hình'**
  String get familyPosterFitScreen;

  /// No description provided for @familyPosterSectionPaper.
  ///
  /// In vi, this message translates to:
  /// **'1. Khổ In & Hướng Tranh'**
  String get familyPosterSectionPaper;

  /// No description provided for @familyPosterPaperSize.
  ///
  /// In vi, this message translates to:
  /// **'Kích thước khổ giấy'**
  String get familyPosterPaperSize;

  /// No description provided for @familyPosterOrientation.
  ///
  /// In vi, this message translates to:
  /// **'Hướng bố cục tranh'**
  String get familyPosterOrientation;

  /// No description provided for @familyPosterSectionStyle.
  ///
  /// In vi, this message translates to:
  /// **'2. Phong Cách Nền & Khung Tranh'**
  String get familyPosterSectionStyle;

  /// No description provided for @familyPosterSectionTitleCouplet.
  ///
  /// In vi, this message translates to:
  /// **'3. Tiêu Đề & Câu Đối Nhà Thờ Họ'**
  String get familyPosterSectionTitleCouplet;

  /// No description provided for @familyPosterTitleLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề Tranh Phả Đồ'**
  String get familyPosterTitleLabel;

  /// No description provided for @familyPosterTitleHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: PHẢ HỆ ĐỒ ĐẠI TÔN HỌ NGUYỄN'**
  String get familyPosterTitleHint;

  /// No description provided for @familyPosterCoupletLeftLabel.
  ///
  /// In vi, this message translates to:
  /// **'Câu đối vế trái (Thượng liên)'**
  String get familyPosterCoupletLeftLabel;

  /// No description provided for @familyPosterCoupletLeftHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Tổ tông công đức thiên niên thịnh'**
  String get familyPosterCoupletLeftHint;

  /// No description provided for @familyPosterCoupletRightLabel.
  ///
  /// In vi, this message translates to:
  /// **'Câu đối vế phải (Hạ liên)'**
  String get familyPosterCoupletRightLabel;

  /// No description provided for @familyPosterCoupletRightHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Tử hiếu tôn hiền vạn đại vinh'**
  String get familyPosterCoupletRightHint;

  /// No description provided for @familyPosterSectionScope.
  ///
  /// In vi, this message translates to:
  /// **'4. Phạm Vi & Tùy Chọn Hiển Thị'**
  String get familyPosterSectionScope;

  /// No description provided for @familyPosterScopeGenerations.
  ///
  /// In vi, this message translates to:
  /// **'Phạm vi thế hệ trên tranh'**
  String get familyPosterScopeGenerations;

  /// No description provided for @familyPosterPaperA0Desc.
  ///
  /// In vi, this message translates to:
  /// **'Khổ A0 (84.1 × 118.9 cm) • Khổ đại cho Từ Đường, Nhà Thờ Họ'**
  String get familyPosterPaperA0Desc;

  /// No description provided for @familyPosterPaperA1Desc.
  ///
  /// In vi, this message translates to:
  /// **'Khổ A1 (59.4 × 84.1 cm) • Kích thước chuẩn treo tường đẹp nhất'**
  String get familyPosterPaperA1Desc;

  /// No description provided for @familyPosterPaperA2Desc.
  ///
  /// In vi, this message translates to:
  /// **'Khổ A2 (42.0 × 59.4 cm) • Phù hợp không gian phòng khách vừa'**
  String get familyPosterPaperA2Desc;

  /// No description provided for @familyPosterPaperA3Desc.
  ///
  /// In vi, this message translates to:
  /// **'Khổ A3 (29.7 × 42.0 cm) • Khổ nhỏ đóng khung để bàn / treo tường'**
  String get familyPosterPaperA3Desc;

  /// No description provided for @familyPosterPaperA4Desc.
  ///
  /// In vi, this message translates to:
  /// **'Khổ A4 (21.0 × 29.7 cm) • Tiêu chuẩn in ấn kẹp hồ sơ gia phả'**
  String get familyPosterPaperA4Desc;

  /// No description provided for @heritageTypeAncestralHouse.
  ///
  /// In vi, this message translates to:
  /// **'Nhà thờ họ'**
  String get heritageTypeAncestralHouse;

  /// No description provided for @heritageTypePatriarchTomb.
  ///
  /// In vi, this message translates to:
  /// **'Lăng mộ tổ'**
  String get heritageTypePatriarchTomb;

  /// No description provided for @heritageTypeMemberGrave.
  ///
  /// In vi, this message translates to:
  /// **'Mộ tiền nhân'**
  String get heritageTypeMemberGrave;

  /// No description provided for @heritageTypeShrine.
  ///
  /// In vi, this message translates to:
  /// **'Miếu / Đình'**
  String get heritageTypeShrine;

  /// No description provided for @heritageTypeUnknown.
  ///
  /// In vi, this message translates to:
  /// **'Địa điểm'**
  String get heritageTypeUnknown;

  /// No description provided for @heritageTypeAncestralHouseShort.
  ///
  /// In vi, this message translates to:
  /// **'Nhà thờ'**
  String get heritageTypeAncestralHouseShort;

  /// No description provided for @heritageTypePatriarchTombShort.
  ///
  /// In vi, this message translates to:
  /// **'Mộ tổ'**
  String get heritageTypePatriarchTombShort;

  /// No description provided for @heritageTypeMemberGraveShort.
  ///
  /// In vi, this message translates to:
  /// **'Mộ tiền nhân'**
  String get heritageTypeMemberGraveShort;

  /// No description provided for @heritageTypeShrineShort.
  ///
  /// In vi, this message translates to:
  /// **'Miếu / Đình'**
  String get heritageTypeShrineShort;

  /// No description provided for @heritageTypeUnknownShort.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get heritageTypeUnknownShort;

  /// No description provided for @heritageMapDirections.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ đường'**
  String get heritageMapDirections;

  /// No description provided for @heritageMapEdit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa'**
  String get heritageMapEdit;

  /// No description provided for @heritageMapDeletePlace.
  ///
  /// In vi, this message translates to:
  /// **'Xóa địa điểm'**
  String get heritageMapDeletePlace;

  /// No description provided for @heritageMapLocationDescLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả vị trí & chỉ dẫn.'**
  String get heritageMapLocationDescLabel;

  /// No description provided for @heritageMapLocationDescHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Nằm cạnh cây đa, rẽ ngõ thứ 2 bên phải...'**
  String get heritageMapLocationDescHint;

  /// No description provided for @heritageMapCancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get heritageMapCancel;

  /// No description provided for @heritageMapSaveGraveLocation.
  ///
  /// In vi, this message translates to:
  /// **'Lưu vị trí mộ'**
  String get heritageMapSaveGraveLocation;

  /// No description provided for @heritageMapSaveChanges.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thay đổi'**
  String get heritageMapSaveChanges;

  /// No description provided for @heritageMapSavePlace.
  ///
  /// In vi, this message translates to:
  /// **'Lưu địa điểm'**
  String get heritageMapSavePlace;

  /// No description provided for @heritageMapCopiedCoordinates.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép tọa độ'**
  String get heritageMapCopiedCoordinates;

  /// No description provided for @heritageMapCannotOpenGoogleMaps.
  ///
  /// In vi, this message translates to:
  /// **'Không thể mở ứng dụng bản đồ Google Maps'**
  String get heritageMapCannotOpenGoogleMaps;

  /// No description provided for @heritageMapSemanticsClose.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get heritageMapSemanticsClose;

  /// No description provided for @heritageMapSemanticsCopyCoordinates.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép tọa độ'**
  String get heritageMapSemanticsCopyCoordinates;

  /// No description provided for @heritageMapSemanticsEditPlace.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa địa điểm'**
  String get heritageMapSemanticsEditPlace;

  /// No description provided for @heritageMapSemanticsDeletePlace.
  ///
  /// In vi, this message translates to:
  /// **'Xóa địa điểm'**
  String get heritageMapSemanticsDeletePlace;

  /// No description provided for @heritageMapSemanticsSelectType.
  ///
  /// In vi, this message translates to:
  /// **'Chọn loại: {type}'**
  String heritageMapSemanticsSelectType(String type);

  /// No description provided for @heritageMapCoordinatesClipboard.
  ///
  /// In vi, this message translates to:
  /// **'Tọa độ: {coordinates}'**
  String heritageMapCoordinatesClipboard(String coordinates);

  /// No description provided for @heritageMapSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm di tích, mộ phần...'**
  String get heritageMapSearchHint;

  /// No description provided for @heritageMapGeocodeSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập địa danh để tìm...'**
  String get heritageMapGeocodeSearchHint;

  /// No description provided for @heritageMapBack.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get heritageMapBack;

  /// No description provided for @heritageMapFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get heritageMapFilterAll;

  /// No description provided for @heritageMapLayerStreet.
  ///
  /// In vi, this message translates to:
  /// **'Bản đồ giao thông'**
  String get heritageMapLayerStreet;

  /// No description provided for @heritageMapLayerSatellite.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh vệ tinh'**
  String get heritageMapLayerSatellite;

  /// No description provided for @heritageMapMyCurrentLocation.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí của tôi'**
  String get heritageMapMyCurrentLocation;

  /// No description provided for @heritageMapDeleteConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa địa điểm?'**
  String get heritageMapDeleteConfirmTitle;

  /// No description provided for @heritageMapDeleteConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn xóa \"{name}\" khỏi bản đồ dòng họ?'**
  String heritageMapDeleteConfirmMessage(String name);

  /// No description provided for @heritageMapDeleteConfirmBtn.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get heritageMapDeleteConfirmBtn;

  /// No description provided for @heritageMapGpsTurnOnPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng bật định vị GPS trên thiết bị'**
  String get heritageMapGpsTurnOnPrompt;

  /// No description provided for @heritageMapGpsPermissionDenied.
  ///
  /// In vi, this message translates to:
  /// **'Chưa cấp quyền vị trí'**
  String get heritageMapGpsPermissionDenied;

  /// No description provided for @heritageMapGpsPermissionPermanentlyDenied.
  ///
  /// In vi, this message translates to:
  /// **'Quyền vị trí bị tắt trong Cài đặt. Vui lòng mở Cài đặt để bật.'**
  String get heritageMapGpsPermissionPermanentlyDenied;

  /// No description provided for @heritageMapGpsLocationFetched.
  ///
  /// In vi, this message translates to:
  /// **'Đã lấy vị trí GPS hiện tại'**
  String get heritageMapGpsLocationFetched;

  /// No description provided for @heritageMapGpsCannotIdentify.
  ///
  /// In vi, this message translates to:
  /// **'Không thể nhận diện tọa độ GPS'**
  String get heritageMapGpsCannotIdentify;

  /// No description provided for @heritageMapGpsError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi lấy GPS: {error}'**
  String heritageMapGpsError(String error);

  /// No description provided for @heritageMapRelativeGrave.
  ///
  /// In vi, this message translates to:
  /// **'Mộ người thân'**
  String get heritageMapRelativeGrave;

  /// No description provided for @heritageMapNoResultsFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy địa điểm phù hợp'**
  String get heritageMapNoResultsFound;

  /// No description provided for @heritageMapSaveSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu thông tin địa điểm thành công'**
  String get heritageMapSaveSuccess;

  /// No description provided for @heritageMapQuickActionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bản đồ'**
  String get heritageMapQuickActionTitle;

  /// No description provided for @familyMemberGraveLocationSection.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí Mộ phần'**
  String get familyMemberGraveLocationSection;

  /// No description provided for @familyMemberViewGraveOnMap.
  ///
  /// In vi, this message translates to:
  /// **'Xem vị trí mộ trên bản đồ'**
  String get familyMemberViewGraveOnMap;

  /// No description provided for @familyMemberPinGraveOnMap.
  ///
  /// In vi, this message translates to:
  /// **'Gắn vị trí mộ trên bản đồ'**
  String get familyMemberPinGraveOnMap;

  /// No description provided for @familyPosterIncludeSpouse.
  ///
  /// In vi, this message translates to:
  /// **'Hiển thị Phối ngẫu (Vợ / Chồng)'**
  String get familyPosterIncludeSpouse;

  /// No description provided for @familyPosterIncludeSpouseDesc.
  ///
  /// In vi, this message translates to:
  /// **'Kèm tên phu nhân hoặc phu quân trong từng thẻ'**
  String get familyPosterIncludeSpouseDesc;

  /// No description provided for @familyPosterIncludeDates.
  ///
  /// In vi, this message translates to:
  /// **'Hiển thị Năm Sinh & Năm Mất'**
  String get familyPosterIncludeDates;

  /// No description provided for @familyPosterIncludeDatesDesc.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú niên đại sinh tử của các bậc tiền nhân'**
  String get familyPosterIncludeDatesDesc;

  /// No description provided for @familyPosterPreviewError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể dựng bản xem trước: {error}'**
  String familyPosterPreviewError(String error);

  /// No description provided for @familyBookPreviewError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể hiển thị bản xem trước: {error}'**
  String familyBookPreviewError(String error);

  /// No description provided for @errLoadHeritagePlaces.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi lấy danh sách di tích & mộ phần'**
  String get errLoadHeritagePlaces;

  /// No description provided for @errHeritagePlaceNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thông tin địa điểm'**
  String get errHeritagePlaceNotFound;

  /// No description provided for @errLoadHeritagePlaceDetail.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi lấy thông tin chi tiết di tích'**
  String get errLoadHeritagePlaceDetail;

  /// No description provided for @errFindMemberGrave.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi tra cứu vị trí mộ phần'**
  String get errFindMemberGrave;

  /// No description provided for @errNoResponseData.
  ///
  /// In vi, this message translates to:
  /// **'Không nhận được dữ liệu phản hồi sau khi tạo'**
  String get errNoResponseData;

  /// No description provided for @errSaveHeritagePlace.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi lưu thông tin địa điểm / mộ phần'**
  String get errSaveHeritagePlace;

  /// No description provided for @errDeleteHeritagePlace.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi xóa địa điểm'**
  String get errDeleteHeritagePlace;

  /// No description provided for @defaultMemberName.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên'**
  String get defaultMemberName;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
