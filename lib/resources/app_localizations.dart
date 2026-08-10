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

  /// No description provided for @clanAndPersonalInfoTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin dòng tộc và cá nhân'**
  String get clanAndPersonalInfoTitle;

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
  /// **'Gửi Mã Xác Thực'**
  String get forgotPasswordButton;

  /// No description provided for @forgotPasswordSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi email đặt lại mật khẩu. Vui lòng kiểm tra hộp thư (kể cả thư mục spam).'**
  String get forgotPasswordSuccess;

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
  /// **'Xác Thực'**
  String get otpVerifyButton;

  /// No description provided for @otpResendButton.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại mã'**
  String get otpResendButton;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại mật khẩu'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu mới cho tài khoản của bạn.'**
  String get resetPasswordSubtitle;

  /// No description provided for @resetPasswordButton.
  ///
  /// In vi, this message translates to:
  /// **'Đặt Lại Mật Khẩu'**
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
  /// **'Khởi Tạo Gia Tộc'**
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
  /// **'Gửi Yêu Cầu Gia Nhập'**
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

  /// No description provided for @familyPhotoSectionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh Đại Diện Dòng Họ'**
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
  /// **'Nhấn Để Thay Đổi Ảnh'**
  String get tapToChangePhoto;

  /// No description provided for @tapToUploadPhoto.
  ///
  /// In vi, this message translates to:
  /// **'Nhấn Để Tải Ảnh Lên'**
  String get tapToUploadPhoto;

  /// No description provided for @byInitAgreeTerms.
  ///
  /// In vi, this message translates to:
  /// **'Bằng Cách Nhấn Khởi Tạo, Bạn Đồng Ý Với '**
  String get byInitAgreeTerms;

  /// No description provided for @appTerms.
  ///
  /// In vi, this message translates to:
  /// **'Các Điều Khoản Của Gia Tộc Việt'**
  String get appTerms;

  /// No description provided for @enterInviteCodeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nhập Mã Tham Gia'**
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

  /// No description provided for @connectFamilySectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kết nối dòng tộc'**
  String get connectFamilySectionTitle;

  /// No description provided for @copiedShareContent.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép nội dung chia sẻ!'**
  String get copiedShareContent;

  /// No description provided for @creationSuccessTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khởi Tạo Thành Công'**
  String get creationSuccessTitle;

  /// No description provided for @confirmJoinButton.
  ///
  /// In vi, this message translates to:
  /// **'Xác Nhận Tham Gia'**
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

  /// No description provided for @navFamilyFund.
  ///
  /// In vi, this message translates to:
  /// **'Quỹ gia tộc'**
  String get navFamilyFund;

  /// No description provided for @navEvents.
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện'**
  String get navEvents;

  /// No description provided for @navSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get navSettings;

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
  /// **'Lưu Lại'**
  String get formSave;

  /// No description provided for @formCancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy Bỏ'**
  String get formCancel;

  /// No description provided for @lunarSuffix.
  ///
  /// In vi, this message translates to:
  /// **'Âm Lịch'**
  String get lunarSuffix;

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
  /// **'Chia Sẻ Cho Gia Đình'**
  String get shareFamilyButton;

  /// No description provided for @shareFamilyContent.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia gia phả \"{name}\" trên ứng dụng Gia Tộc Việt. Mã mời của dòng họ là: {code}'**
  String shareFamilyContent(String name, String code);

  /// No description provided for @startExploringButton.
  ///
  /// In vi, this message translates to:
  /// **'Bắt Đầu Khám Phá'**
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
  /// **'Cài Đặt Quản Trị'**
  String get adminSettingsTitle;

  /// No description provided for @accountAndClanSection.
  ///
  /// In vi, this message translates to:
  /// **'Tài Khoản Và Dòng Tộc'**
  String get accountAndClanSection;

  /// No description provided for @clanInfoLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin dòng tộc'**
  String get clanInfoLabel;

  /// No description provided for @accountSecurityLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật tài khoản'**
  String get accountSecurityLabel;

  /// No description provided for @switchToMemberPage.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển sang trang Thành viên'**
  String get switchToMemberPage;

  /// No description provided for @appSettingsSection.
  ///
  /// In vi, this message translates to:
  /// **'Thiết Lập Ứng Dụng'**
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

  /// No description provided for @notifyEventLabel.
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện mới'**
  String get notifyEventLabel;

  /// No description provided for @notifyAnnouncementLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo từ dòng họ'**
  String get notifyAnnouncementLabel;

  /// No description provided for @notifyWishLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lời chúc'**
  String get notifyWishLabel;

  /// No description provided for @notifyAnniversaryLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giỗ & sinh nhật'**
  String get notifyAnniversaryLabel;

  /// No description provided for @infoAndHelpSection.
  ///
  /// In vi, this message translates to:
  /// **'Thông Tin & Trợ Giúp'**
  String get infoAndHelpSection;

  /// No description provided for @regulationsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Quy định & Điều khoản'**
  String get regulationsLabel;

  /// No description provided for @helpCenterLabel.
  ///
  /// In vi, this message translates to:
  /// **'Trung tâm hỗ trợ'**
  String get helpCenterLabel;

  /// No description provided for @aboutUsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Về chúng tôi'**
  String get aboutUsLabel;

  /// No description provided for @advancedAdminSection.
  ///
  /// In vi, this message translates to:
  /// **'Quản Trị Nâng Cao'**
  String get advancedAdminSection;

  /// No description provided for @memberRolesLabel.
  ///
  /// In vi, this message translates to:
  /// **'Phân quyền thành viên'**
  String get memberRolesLabel;

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

  /// No description provided for @logoutButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng Xuất'**
  String get logoutButton;

  /// No description provided for @accountSecurityTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bảo Mật Tài Khoản'**
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
  /// **'Cập Nhật Mật Khẩu'**
  String get updatePasswordButton;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi mật khẩu thành công!'**
  String get changePasswordSuccess;

  /// No description provided for @dissolveClanTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giải Tán Gia Phả'**
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

  /// No description provided for @reenterClanNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập đúng từng chữ để xác nhận'**
  String get reenterClanNameHint;

  /// No description provided for @dissolvePermanentButton.
  ///
  /// In vi, this message translates to:
  /// **'Giải Tán Dòng Họ Vĩnh Viễn'**
  String get dissolvePermanentButton;

  /// No description provided for @deletePermanentDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa Gia Phả Vĩnh Viễn'**
  String get deletePermanentDialogTitle;

  /// No description provided for @deletePermanentDialogMessage.
  ///
  /// In vi, this message translates to:
  /// **'Hành động này cực kỳ nguy hiểm. Toàn bộ thông tin thành viên, các nhánh dòng họ, lịch sử gia tộc của \"{name}\" sẽ bị xóa vĩnh viễn khỏi máy chủ. Bạn chắc chắn muốn tiếp tục chứ?'**
  String deletePermanentDialogMessage(String name);

  /// No description provided for @confirmDeletePermanentLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đồng Ý Xóa Bỏ'**
  String get confirmDeletePermanentLabel;

  /// No description provided for @dissolveSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa gia phả. Toàn bộ dữ liệu đã được xóa khỏi hệ thống.'**
  String get dissolveSuccessMessage;

  /// No description provided for @chooseRecipientLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chọn người nhận quyền'**
  String get chooseRecipientLabel;

  /// No description provided for @transferDesc.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ những thành viên đã kích hoạt tài khoản và có vai trò khác Trưởng tộc mới xuất hiện trong danh sách dưới đây:'**
  String get transferDesc;

  /// No description provided for @searchMemberHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm thành viên...'**
  String get searchMemberHint;

  /// No description provided for @noMemberFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thành viên phù hợp.'**
  String get noMemberFound;

  /// No description provided for @noSearchResultsMessage.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy kết quả phù hợp.'**
  String get noSearchResultsMessage;

  /// No description provided for @noEligibleMembers.
  ///
  /// In vi, this message translates to:
  /// **'Không có thành viên nào đủ điều kiện nhận chuyển nhượng.'**
  String get noEligibleMembers;

  /// No description provided for @proceedTransferButton.
  ///
  /// In vi, this message translates to:
  /// **'Tiến Hành Chuyển Nhượng'**
  String get proceedTransferButton;

  /// No description provided for @warningDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo quan trọng'**
  String get warningDialogTitle;

  /// No description provided for @warningDialogMessage.
  ///
  /// In vi, this message translates to:
  /// **'Quyền Trưởng tộc là quyền hạn cao nhất trong hệ thống gia phả. Khi chuyển nhượng thành công, bạn sẽ mất quyền chỉnh sửa cấu trúc dòng họ cao cấp và các thiết lập bảo mật.'**
  String get warningDialogMessage;

  /// No description provided for @warningDialogConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn chuyển giao quyền Trưởng tộc cho {name}?'**
  String warningDialogConfirmMessage(String name);

  /// No description provided for @confirmTransferButton.
  ///
  /// In vi, this message translates to:
  /// **'Đồng Ý Chuyển'**
  String get confirmTransferButton;

  /// No description provided for @transferSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển nhượng quyền Trưởng tộc thành công!'**
  String get transferSuccess;

  /// No description provided for @transferProcessing.
  ///
  /// In vi, this message translates to:
  /// **'Đang xử lý chuyển nhượng...'**
  String get transferProcessing;

  /// No description provided for @memberRolesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Phân Quyền Thành Viên'**
  String get memberRolesTitle;

  /// No description provided for @roleOfUser.
  ///
  /// In vi, this message translates to:
  /// **'Vai trò của {name}'**
  String roleOfUser(String name);

  /// No description provided for @roleBranchAdminTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trưởng chi'**
  String get roleBranchAdminTitle;

  /// No description provided for @roleBranchAdminDesc.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý nhân sự và nội dung của chi tộc.'**
  String get roleBranchAdminDesc;

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

  /// No description provided for @roleViewerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên'**
  String get roleViewerTitle;

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

  /// No description provided for @accountInfoTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông Tin Cá Nhân'**
  String get accountInfoTitle;

  /// No description provided for @emailAccountLabel.
  ///
  /// In vi, this message translates to:
  /// **'Email (Tài khoản)'**
  String get emailAccountLabel;

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
  /// **'Tạo Hồ Sơ Gia Phả'**
  String get createProfileButton;

  /// No description provided for @clanInfoSettingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông Tin Dòng Tộc'**
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

  /// No description provided for @editTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa'**
  String get editTooltip;

  /// No description provided for @doneTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tất'**
  String get doneTooltip;

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
  /// **'Quy Định & Điều Khoản'**
  String get regulationsTitle;

  /// No description provided for @regulationTitle.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản sử dụng Gia Tộc Việt'**
  String get regulationTitle;

  /// No description provided for @regulationLastUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật lần cuối: Tháng 7, 2026'**
  String get regulationLastUpdated;

  /// No description provided for @regSection1Title.
  ///
  /// In vi, this message translates to:
  /// **'Chấp thuận'**
  String get regSection1Title;

  /// No description provided for @regSection1Content.
  ///
  /// In vi, this message translates to:
  /// **'Khi tải và sử dụng Gia Tộc Việt, bạn đồng ý với các điều khoản dưới đây và Chính sách bảo mật của chúng tôi. Nếu không đồng ý, vui lòng không dùng ứng dụng.'**
  String get regSection1Content;

  /// No description provided for @regSection2Title.
  ///
  /// In vi, this message translates to:
  /// **'Giải thích từ ngữ'**
  String get regSection2Title;

  /// No description provided for @regSection2Content.
  ///
  /// In vi, this message translates to:
  /// **'**Ứng dụng:** Gia Tộc Việt và các tính năng của ứng dụng.\n**Người dùng:** Cá nhân đã đăng ký tài khoản.\n**Dòng họ:** Nhóm thành viên do Trưởng tộc tạo lập, gồm chi tộc, thành viên và dữ liệu gia phả.\n**Trưởng tộc:** Người quản trị cao nhất của dòng họ.\n**Trưởng chi:** Người được phân quyền quản lý một chi tộc.\n**Biên tập viên:** Người được quyền đóng góp và chỉnh sửa thông tin gia phả.\n**Thành viên:** Người có quyền xem gia phả và các hoạt động của dòng họ.\n**Dữ liệu cá nhân:** Họ tên, ngày sinh, giới tính, quan hệ gia đình, hình ảnh, số điện thoại, email…'**
  String get regSection2Content;

  /// No description provided for @regSection3Title.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get regSection3Title;

  /// No description provided for @regSection3Content.
  ///
  /// In vi, this message translates to:
  /// **'• Bạn phải đủ 18 tuổi hoặc có người giám hộ hợp pháp.\n• Bạn chịu trách nhiệm bảo vệ mật khẩu của mình.\n• Mỗi người chỉ được tạo một tài khoản, dùng cho mục đích cá nhân.\n• Thông tin đăng ký phải chính xác và trung thực.'**
  String get regSection3Content;

  /// No description provided for @regSection4Title.
  ///
  /// In vi, this message translates to:
  /// **'Quyền hạn theo vai trò'**
  String get regSection4Title;

  /// No description provided for @regSection4Content.
  ///
  /// In vi, this message translates to:
  /// **'**Thành viên** – Xem gia phả, xem tin tức & sự kiện dòng tộc, cập nhật thông tin cá nhân.\n**Biên tập viên** – Thêm, sửa thông tin thành viên (không được xóa).\n**Trưởng chi** – Quản lý chi tộc được phân công, phê duyệt yêu cầu tham gia chi tộc.\n**Trưởng tộc** – Toàn quyền quản trị dòng họ, phân quyền vai trò cho thành viên, chuyển nhượng quyền Trưởng tộc, giải tán dòng họ.'**
  String get regSection4Content;

  /// No description provided for @regSection5Title.
  ///
  /// In vi, this message translates to:
  /// **'Quản trị dòng họ'**
  String get regSection5Title;

  /// No description provided for @regSection5Content.
  ///
  /// In vi, this message translates to:
  /// **'Trưởng tộc có toàn quyền: phê duyệt thành viên, phân vai trò, cập nhật thông tin, chuyển nhượng quyền Trưởng tộc và giải tán dòng họ. Khi chuyển nhượng, Trưởng tộc cũ trở thành Thành viên và không thể lấy lại quyền cũ. Mọi thao tác thêm, sửa, xóa trong hệ thống đều được ghi lại.'**
  String get regSection5Content;

  /// No description provided for @regSection6Title.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật dữ liệu'**
  String get regSection6Title;

  /// No description provided for @regSection6Content.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi bảo vệ dữ liệu của bạn theo Luật An ninh mạng Việt Nam và Nghị định 13/2023/NĐ-CP. Dữ liệu được lưu tại máy chủ Việt Nam, mã hóa khi truyền tải và lưu trữ. Chúng tôi không bán dữ liệu của bạn cho bên thứ ba. Thông tin dòng họ chỉ hiển thị cho thành viên đã được phê duyệt.'**
  String get regSection6Content;

  /// No description provided for @regSection7Title.
  ///
  /// In vi, this message translates to:
  /// **'Sở hữu trí tuệ'**
  String get regSection7Title;

  /// No description provided for @regSection7Content.
  ///
  /// In vi, this message translates to:
  /// **'Gia Tộc Việt (mã nguồn, thiết kế, thương hiệu, logo) là tài sản của đơn vị phát triển, được bảo hộ theo pháp luật Việt Nam. Dữ liệu gia phả do người dùng tạo ra thuộc quyền sở hữu của dòng họ đó.'**
  String get regSection7Content;

  /// No description provided for @regSection8Title.
  ///
  /// In vi, this message translates to:
  /// **'Trách nhiệm'**
  String get regSection8Title;

  /// No description provided for @regSection8Content.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng được cung cấp ở trạng thái hiện tại. Chúng tôi không chịu trách nhiệm nếu: (i) bạn sử dụng sai mục đích; (ii) thông tin bạn cung cấp không chính xác; (iii) Trưởng tộc chủ động xóa hoặc giải tán dòng họ. Nếu mất dữ liệu do lỗi hệ thống, chúng tôi sẽ cố gắng khôi phục.'**
  String get regSection8Content;

  /// No description provided for @regSection9Title.
  ///
  /// In vi, this message translates to:
  /// **'Xử lý vi phạm'**
  String get regSection9Title;

  /// No description provided for @regSection9Content.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi có thể tạm khóa hoặc chấm dứt tài khoản nếu phát hiện vi phạm. Các mức xử lý: cảnh báo, tạm khóa, khóa vĩnh viễn hoặc thông báo cơ quan chức năng nếu vi phạm pháp luật. Trưởng tộc có thể giải tán dòng họ bất kỳ lúc nào — sau khi xác nhận, toàn bộ dữ liệu bị xóa vĩnh viễn và không thể khôi phục.'**
  String get regSection9Content;

  /// No description provided for @regSection10Title.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản chung'**
  String get regSection10Title;

  /// No description provided for @regSection10Content.
  ///
  /// In vi, this message translates to:
  /// **'Các điều khoản này được điều chỉnh theo pháp luật Việt Nam. Mọi tranh chấp được ưu tiên giải quyết qua thương lượng. Chúng tôi có thể sửa đổi điều khoản và sẽ thông báo trên ứng dụng. Nếu bạn tiếp tục dùng ứng dụng sau khi thay đổi, nghĩa là bạn đã chấp nhận điều khoản mới.'**
  String get regSection10Content;

  /// No description provided for @copyrightText.
  ///
  /// In vi, this message translates to:
  /// **'© 2026 ThachDev. Bảo lưu mọi quyền.'**
  String get copyrightText;

  /// No description provided for @helpCenterTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trung Tâm Hỗ Trợ'**
  String get helpCenterTitle;

  /// No description provided for @helpDragInstruction.
  ///
  /// In vi, this message translates to:
  /// **'👉 Kéo sơ đồ để di chuyển'**
  String get helpDragInstruction;

  /// No description provided for @helpTapInstruction.
  ///
  /// In vi, this message translates to:
  /// **'👤 Nhấn vào thành viên để xem chi tiết'**
  String get helpTapInstruction;

  /// No description provided for @helpTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Hướng dẫn'**
  String get helpTooltip;

  /// No description provided for @helpZoomInstruction.
  ///
  /// In vi, this message translates to:
  /// **'🔍 Phóng to/Thu nhỏ bằng 2 ngón tay'**
  String get helpZoomInstruction;

  /// No description provided for @contactSection.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ trực tiếp'**
  String get contactSection;

  /// No description provided for @hotlineTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hotline hỗ trợ'**
  String get hotlineTitle;

  /// No description provided for @hotlineValue.
  ///
  /// In vi, this message translates to:
  /// **'1900 8888'**
  String get hotlineValue;

  /// No description provided for @hotlineSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'8:00 - 17:30 (T2-T6)'**
  String get hotlineSubtitle;

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

  /// No description provided for @accountLoginSection.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản & Đăng nhập'**
  String get accountLoginSection;

  /// No description provided for @genealogyMemberSection.
  ///
  /// In vi, this message translates to:
  /// **'Gia phả & Thành viên'**
  String get genealogyMemberSection;

  /// No description provided for @clanAndRolesSection.
  ///
  /// In vi, this message translates to:
  /// **'Dòng tộc & Phân quyền'**
  String get clanAndRolesSection;

  /// No description provided for @techSecuritySection.
  ///
  /// In vi, this message translates to:
  /// **'Kỹ thuật & Bảo mật'**
  String get techSecuritySection;

  /// No description provided for @faqRegisterQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để đăng ký tài khoản?'**
  String get faqRegisterQuestion;

  /// No description provided for @faqRegisterAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Tải ứng dụng Gia Tộc Việt, nhấn \"Đăng ký\" và điền đầy đủ họ tên, email và mật khẩu. Sau khi đăng ký thành công, bạn dùng mã mời từ Trưởng tộc để yêu cầu tham gia Dòng tộc.'**
  String get faqRegisterAnswer;

  /// No description provided for @faqForgotPasswordQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Tôi quên mật khẩu, phải làm sao?'**
  String get faqForgotPasswordQuestion;

  /// No description provided for @faqForgotPasswordAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Trên màn hình đăng nhập, nhấn \"Quên mật khẩu\". Nhập email đã đăng ký, hệ thống sẽ gửi mã OTP 6 chữ số qua email. Nhập mã OTP để xác thực và đặt mật khẩu mới.'**
  String get faqForgotPasswordAnswer;

  /// No description provided for @faqChangePasswordQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để đổi mật khẩu?'**
  String get faqChangePasswordQuestion;

  /// No description provided for @faqChangePasswordAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Vào Cài đặt > Bảo mật tài khoản, nhập mật khẩu hiện tại, sau đó nhập mật khẩu mới và xác nhận. Mật khẩu phải có ít nhất 8 ký tự.'**
  String get faqChangePasswordAnswer;

  /// No description provided for @faqAddMemberQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để thêm thành viên mới?'**
  String get faqAddMemberQuestion;

  /// No description provided for @faqAddMemberAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Vào Dashboard, nhấn nút \"+\" ở tab Thành viên. Điền thông tin: họ tên, giới tính, ngày sinh, nơi sinh, thế hệ, chi tộc, cha/mẹ (nếu có). Bạn có thể bổ sung ngày mất, tình trạng hôn nhân, ghi chú. Nhấn \"Lưu\" để hoàn tất. Yêu cầu quyền Biên tập viên trở lên.'**
  String get faqAddMemberAnswer;

  /// No description provided for @faqAddBranchQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để thêm chi tộc mới?'**
  String get faqAddBranchQuestion;

  /// No description provided for @faqAddBranchAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Vào Dashboard, chọn tab Chi họ và nhấn nút \"+\". Điền tên chi tộc, mô tả và thông tin người sáng lập (nếu có). Sau khi tạo, Trưởng tộc có thể phân quyền Trưởng chi cho thành viên phụ trách chi đó.'**
  String get faqAddBranchAnswer;

  /// No description provided for @faqEditMemberQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để chỉnh sửa thông tin thành viên?'**
  String get faqEditMemberQuestion;

  /// No description provided for @faqEditMemberAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Trong danh sách thành viên, chọn thành viên cần chỉnh sửa và nhấn biểu tượng bút. Cập nhật thông tin rồi nhấn \"Lưu\". Chỉ Biên tập viên và các vai trò cao hơn mới có quyền này.'**
  String get faqEditMemberAnswer;

  /// No description provided for @faqDeleteMemberQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để xóa thành viên?'**
  String get faqDeleteMemberQuestion;

  /// No description provided for @faqDeleteMemberAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thành viên trong danh sách, nhấn biểu tượng xóa (thùng rác) và xác nhận. Lưu ý: chỉ Trưởng tộc và Trưởng chi mới có quyền xóa thành viên; Biên tập viên không có quyền này.'**
  String get faqDeleteMemberAnswer;

  /// No description provided for @faqImportGenealogyQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Có thể nhập gia phả từ file không?'**
  String get faqImportGenealogyQuestion;

  /// No description provided for @faqImportGenealogyAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Hiện tại ứng dụng hỗ trợ thêm từng thành viên thủ công. Tính năng nhập hàng loạt từ file đang được phát triển.'**
  String get faqImportGenealogyAnswer;

  /// No description provided for @faqInviteCodeQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Mã mời hoạt động như thế nào?'**
  String get faqInviteCodeQuestion;

  /// No description provided for @faqInviteCodeAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi Dòng tộc có một Mã mời duy nhất do hệ thống tạo. Trưởng tộc có thể xem, sao chép và chia sẻ Mã mời (kèm QR code) ngay trong Dashboard. Thành viên mới dùng mã này để gửi yêu cầu gia nhập — Trưởng tộc hoặc Trưởng chi sẽ phê duyệt.'**
  String get faqInviteCodeAnswer;

  /// No description provided for @faqRolesQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Các vai trò trong Dòng tộc là gì?'**
  String get faqRolesQuestion;

  /// No description provided for @faqRolesAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống có 4 cấp vai trò:\n• Trưởng tộc — Quyền cao nhất: quản lý toàn bộ Dòng tộc, phân quyền, chuyển nhượng và giải tán.\n• Trưởng chi — Quản lý chi tộc được phân công, phê duyệt yêu cầu gia nhập.\n• Biên tập viên — Thêm và chỉnh sửa thông tin thành viên (không được xóa).\n• Thành viên — Xem gia phả và các sự kiện của dòng tộc.'**
  String get faqRolesAnswer;

  /// No description provided for @faqAssignRoleQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để phân quyền cho thành viên?'**
  String get faqAssignRoleQuestion;

  /// No description provided for @faqAssignRoleAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Vào Cài đặt > Phân quyền thành viên (chỉ Trưởng tộc thấy mục này). Chọn thành viên và chọn vai trò phù hợp. Trưởng tộc không thể tự hạ quyền của mình — cần dùng tính năng Chuyển nhượng quyền Trưởng tộc.'**
  String get faqAssignRoleAnswer;

  /// No description provided for @faqTransferOwnershipQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để chuyển nhượng quyền Trưởng tộc?'**
  String get faqTransferOwnershipQuestion;

  /// No description provided for @faqTransferOwnershipAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Vào Cài đặt > Chuyển nhượng quyền Trưởng tộc. Chọn thành viên đã có tài khoản từ danh sách. Xác nhận chuyển nhượng — thao tác này không thể hoàn tác. Sau khi chuyển, bạn trở thành Thành viên và người nhận là Trưởng tộc mới.'**
  String get faqTransferOwnershipAnswer;

  /// No description provided for @faqDissolveClanQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để giải tán Dòng tộc?'**
  String get faqDissolveClanQuestion;

  /// No description provided for @faqDissolveClanAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Vào Cài đặt > Giải tán dòng họ (chỉ Trưởng tộc). Gõ chính xác tên Dòng tộc để xác nhận. Toàn bộ dữ liệu — thành viên, chi tộc, gia phả — sẽ bị xóa vĩnh viễn và không thể khôi phục. Hành động này không thể hoàn tác.'**
  String get faqDissolveClanAnswer;

  /// No description provided for @faqDataSecurityQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu gia phả có được bảo mật không?'**
  String get faqDataSecurityQuestion;

  /// No description provided for @faqDataSecurityAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Có. Dữ liệu được lưu trữ trên máy chủ tại Việt Nam, mã hóa khi truyền tải và lưu trữ. Chúng tôi tuân thủ Nghị định 13/2023/NĐ-CP về bảo vệ dữ liệu cá nhân và cam kết không chia sẻ dữ liệu cho bên thứ ba. Thông tin dòng họ chỉ hiển thị cho thành viên đã được phê duyệt.'**
  String get faqDataSecurityAnswer;

  /// No description provided for @faqDeleteAccountQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để xóa tài khoản?'**
  String get faqDeleteAccountQuestion;

  /// No description provided for @faqDeleteAccountAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Vào Cài đặt > Bảo mật tài khoản, chọn \"Xóa tài khoản\" và xác nhận. Lưu ý: nếu bạn đang là Trưởng tộc, hãy chuyển nhượng quyền Trưởng tộc hoặc giải tán Dòng tộc trước khi xóa tài khoản.'**
  String get faqDeleteAccountAnswer;

  /// No description provided for @faqMultiDeviceQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Có thể dùng ứng dụng trên nhiều thiết bị không?'**
  String get faqMultiDeviceQuestion;

  /// No description provided for @faqMultiDeviceAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Có. Tài khoản của bạn có thể đăng nhập trên nhiều thiết bị, dữ liệu được đồng bộ theo thời gian thực. Vì lý do bảo mật, hãy đăng xuất trên các thiết bị không còn sử dụng.'**
  String get faqMultiDeviceAnswer;

  /// No description provided for @faqEnglishSupportQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng có hỗ trợ tiếng Anh không?'**
  String get faqEnglishSupportQuestion;

  /// No description provided for @faqEnglishSupportAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Có. Vào Cài đặt > Ngôn ngữ, bật công tắc để chuyển sang Tiếng Anh. Giao diện cập nhật ngay lập tức. Dữ liệu gia phả và thông tin thành viên vẫn được giữ nguyên.'**
  String get faqEnglishSupportAnswer;

  /// No description provided for @aboutUsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Về Chúng Tôi'**
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

  /// No description provided for @adminDashboardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bảng Quản Trị'**
  String get adminDashboardTitle;

  /// No description provided for @roleOwner.
  ///
  /// In vi, this message translates to:
  /// **'Trưởng Tộc'**
  String get roleOwner;

  /// No description provided for @roleBranchAdmin.
  ///
  /// In vi, this message translates to:
  /// **'Trưởng Chi'**
  String get roleBranchAdmin;

  /// No description provided for @roleEditor.
  ///
  /// In vi, this message translates to:
  /// **'Biên Tập Viên'**
  String get roleEditor;

  /// No description provided for @roleViewer.
  ///
  /// In vi, this message translates to:
  /// **'Thành Viên'**
  String get roleViewer;

  /// No description provided for @memberListTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh Sách Thành Viên'**
  String get memberListTitle;

  /// No description provided for @branchListTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh Sách Chi Tộc'**
  String get branchListTitle;

  /// No description provided for @pendingRequestTitle.
  ///
  /// In vi, this message translates to:
  /// **'Yêu Cầu Chờ Duyệt'**
  String get pendingRequestTitle;

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

  /// No description provided for @addMemberLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thêm thành viên'**
  String get addMemberLabel;

  /// No description provided for @addBranchLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thêm chi tộc'**
  String get addBranchLabel;

  /// No description provided for @statMembers.
  ///
  /// In vi, this message translates to:
  /// **'Thành Viên'**
  String get statMembers;

  /// No description provided for @statBranches.
  ///
  /// In vi, this message translates to:
  /// **'Chi Tộc'**
  String get statBranches;

  /// No description provided for @statPending.
  ///
  /// In vi, this message translates to:
  /// **'Chờ Duyệt'**
  String get statPending;

  /// No description provided for @inviteCodeSectionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mã Gia Tộc'**
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

  /// No description provided for @qrCodeTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Mã QR'**
  String get qrCodeTooltip;

  /// No description provided for @qrDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mã QR Gia Tộc'**
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

  /// No description provided for @generationBadge.
  ///
  /// In vi, this message translates to:
  /// **'Đời thứ {gen}'**
  String generationBadge(Object gen);

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
  /// **'Lưu Chi Tộc'**
  String get saveBranchLabel;

  /// No description provided for @editBranchTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sửa Chi Tộc'**
  String get editBranchTitle;

  /// No description provided for @addBranchTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm Chi Tộc'**
  String get addBranchTitle;

  /// No description provided for @deleteBranchTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Xóa chi tộc'**
  String get deleteBranchTooltip;

  /// No description provided for @basicInfoTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông Tin Cơ Bản'**
  String get basicInfoTitle;

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

  /// No description provided for @branchNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Tên chi tộc'**
  String get branchNameRequired;

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
  /// **'Tên tổ chi (Tự nhập)'**
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
  /// **'Xác Nhận Xóa'**
  String get deleteBranchConfirmTitle;

  /// No description provided for @deleteBranchConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xoá chi tộc {name} không?'**
  String deleteBranchConfirmMessage(Object name);

  /// No description provided for @editMemberTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sửa Thành Viên'**
  String get editMemberTitle;

  /// No description provided for @addMemberTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm Thành Viên'**
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
  /// **'Hôn Nhân'**
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

  /// No description provided for @maritalUnknown.
  ///
  /// In vi, this message translates to:
  /// **'Chưa rõ'**
  String get maritalUnknown;

  /// No description provided for @genderLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giới Tính'**
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

  /// No description provided for @genderUnknown.
  ///
  /// In vi, this message translates to:
  /// **'Chưa rõ'**
  String get genderUnknown;

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
  /// **'Tình Trạng'**
  String get statusLabel;

  /// No description provided for @dodLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày mất'**
  String get dodLabel;

  /// No description provided for @dodHint.
  ///
  /// In vi, this message translates to:
  /// **'dd/mm/yyyy'**
  String get dodHint;

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
  /// **'Tải Ảnh Đại Diện'**
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
  /// **'{name} Gia Tộc'**
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

  /// No description provided for @serverConnectionError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi kết nối máy chủ'**
  String get serverConnectionError;

  /// No description provided for @emailSubjectHelp.
  ///
  /// In vi, this message translates to:
  /// **'Hỗ Trợ Gia Tộc Việt'**
  String get emailSubjectHelp;

  /// No description provided for @accountSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tài Khoản'**
  String get accountSectionTitle;

  /// No description provided for @allLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get allLabel;

  /// No description provided for @biographySectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tiểu Sử & Ghi Chú'**
  String get biographySectionTitle;

  /// No description provided for @branchCountLabel.
  ///
  /// In vi, this message translates to:
  /// **'{count} Chi tộc'**
  String branchCountLabel(int count);

  /// No description provided for @branchLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chi tộc'**
  String get branchLabel;

  /// No description provided for @branchTabLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chi Tộc / Nhánh'**
  String get branchTabLabel;

  /// No description provided for @congratulateActionMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã gửi một lời chúc mừng.'**
  String get congratulateActionMessage;

  /// No description provided for @congratulateButton.
  ///
  /// In vi, this message translates to:
  /// **'Chúc Mừng ({count})'**
  String congratulateButton(int count);

  /// No description provided for @currentDateDisplay.
  ///
  /// In vi, this message translates to:
  /// **'Ngày {day}/{month}/{year} (Nhằm 12/05 Âm Lịch)'**
  String currentDateDisplay(int day, int month, int year);

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

  /// No description provided for @donateButton.
  ///
  /// In vi, this message translates to:
  /// **'Đóng góp'**
  String get donateButton;

  /// No description provided for @eventCountdown.
  ///
  /// In vi, this message translates to:
  /// **'Còn {days} ngày'**
  String eventCountdown(int days);

  /// No description provided for @eventDateSample1.
  ///
  /// In vi, this message translates to:
  /// **'12/05 Âm lịch'**
  String get eventDateSample1;

  /// No description provided for @eventDateSample2.
  ///
  /// In vi, this message translates to:
  /// **'28/06 Dương lịch'**
  String get eventDateSample2;

  /// No description provided for @eventDateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày {date}'**
  String eventDateLabel(String date);

  /// No description provided for @eventDetailFormat.
  ///
  /// In vi, this message translates to:
  /// **'Đời thứ {gen} • Ngày {date}'**
  String eventDetailFormat(int gen, String date);

  /// No description provided for @eventSample1.
  ///
  /// In vi, this message translates to:
  /// **'Giỗ cụ Huỳnh Công Minh'**
  String get eventSample1;

  /// No description provided for @eventSample2.
  ///
  /// In vi, this message translates to:
  /// **'Hội thảo Dòng họ Xuân 2026'**
  String get eventSample2;

  /// No description provided for @eventTypeAncestors.
  ///
  /// In vi, this message translates to:
  /// **'Giỗ Chạp'**
  String get eventTypeAncestors;

  /// No description provided for @eventTypeEvent.
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện'**
  String get eventTypeEvent;

  /// No description provided for @eventsSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sự Kiện & Lễ Giỗ Dòng Họ'**
  String get eventsSectionTitle;

  /// No description provided for @familyFundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quỹ Gia Tộc'**
  String get familyFundTitle;

  /// No description provided for @familyRelationSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quan Hệ Gia Đình'**
  String get familyRelationSectionTitle;

  /// No description provided for @familyTreeMapTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bản Đồ Phả Hệ'**
  String get familyTreeMapTitle;

  /// No description provided for @familyTreeNameFormat.
  ///
  /// In vi, this message translates to:
  /// **'Gia Phả Họ {name}'**
  String familyTreeNameFormat(String name);

  /// No description provided for @familyTreeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gia Phả Dòng Họ'**
  String get familyTreeTitle;

  /// No description provided for @guideButton.
  ///
  /// In vi, this message translates to:
  /// **'Hướng dẫn'**
  String get guideButton;

  /// No description provided for @guideDrag.
  ///
  /// In vi, this message translates to:
  /// **'👉 Kéo sơ đồ để di chuyển'**
  String get guideDrag;

  /// No description provided for @guideTapMember.
  ///
  /// In vi, this message translates to:
  /// **'👤 Nhấn vào thành viên để xem chi tiết'**
  String get guideTapMember;

  /// No description provided for @guideZoom.
  ///
  /// In vi, this message translates to:
  /// **'🔍 Phóng to/Thu nhỏ bằng 2 ngón tay'**
  String get guideZoom;

  /// No description provided for @incenseActionMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã thắp một nén nhang thành tâm.'**
  String get incenseActionMessage;

  /// No description provided for @incenseButton.
  ///
  /// In vi, this message translates to:
  /// **'Đốt Nhang ({count})'**
  String incenseButton(int count);

  /// No description provided for @knownLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã rõ'**
  String get knownLabel;

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

  /// No description provided for @memberIdFormat.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên #{id}'**
  String memberIdFormat(int id);

  /// No description provided for @memberTabLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thành Viên'**
  String get memberTabLabel;

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

  /// No description provided for @notificationLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notificationLabel;

  /// No description provided for @personalInfoLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cá nhân'**
  String get personalInfoLabel;

  /// No description provided for @personalInfoSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông Tin Cá Nhân'**
  String get personalInfoSectionTitle;

  /// No description provided for @placeOfBirthLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nơi sinh'**
  String get placeOfBirthLabel;

  /// No description provided for @searchMemberYearHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm thành viên, năm sinh...'**
  String get searchMemberYearHint;

  /// No description provided for @seeMoreLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xem thêm'**
  String get seeMoreLabel;

  /// No description provided for @settingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài Đặt'**
  String get settingsTitle;

  /// No description provided for @spiritualMotto.
  ///
  /// In vi, this message translates to:
  /// **'Cội Nguồn Tâm Linh • Vạn Đại Trường Tồn'**
  String get spiritualMotto;

  /// No description provided for @switchToAdminLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển sang trang Quản trị'**
  String get switchToAdminLabel;

  /// No description provided for @todayLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get todayLabel;

  /// No description provided for @wishDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gửi Lời Chúc'**
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
  /// **'Gửi Lời Tưởng Nhớ'**
  String get anniversaryDialogTitle;

  /// No description provided for @anniversaryDialogHint.
  ///
  /// In vi, this message translates to:
  /// **'Viết lời tưởng nhớ...'**
  String get anniversaryDialogHint;

  /// No description provided for @anniversarySentMessage.
  ///
  /// In vi, this message translates to:
  /// **'Lời tưởng nhớ đã được gửi.'**
  String get anniversarySentMessage;

  /// No description provided for @unassignedBranch.
  ///
  /// In vi, this message translates to:
  /// **'Chưa phân chi'**
  String get unassignedBranch;

  /// No description provided for @understoodLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã rõ'**
  String get understoodLabel;

  /// No description provided for @unknownGeneration.
  ///
  /// In vi, this message translates to:
  /// **'Chưa rõ đời'**
  String get unknownGeneration;

  /// No description provided for @unknownLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chưa rõ'**
  String get unknownLabel;

  /// No description provided for @usageGuideTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hướng dẫn sử dụng'**
  String get usageGuideTitle;

  /// No description provided for @eventsListTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sự Kiện Dòng Tộc'**
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
  /// **'Thêm Sự Kiện'**
  String get addEventTitle;

  /// No description provided for @editEventTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sửa Sự Kiện'**
  String get editEventTitle;

  /// No description provided for @selectEventDateError.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn ngày diễn ra sự kiện'**
  String get selectEventDateError;

  /// No description provided for @eventNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên sự kiện'**
  String get eventNameLabel;

  /// No description provided for @eventNameHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Ngày giỗ tổ dòng họ...'**
  String get eventNameHint;

  /// No description provided for @eventNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên sự kiện'**
  String get eventNameRequired;

  /// No description provided for @eventNameMinLength.
  ///
  /// In vi, this message translates to:
  /// **'Tên sự kiện phải từ 2 ký tự'**
  String get eventNameMinLength;

  /// No description provided for @eventDateFormLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày diễn ra'**
  String get eventDateFormLabel;

  /// No description provided for @selectDateHint.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày...'**
  String get selectDateHint;

  /// No description provided for @selectDateRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn ngày'**
  String get selectDateRequired;

  /// No description provided for @useLunarCalendar.
  ///
  /// In vi, this message translates to:
  /// **'Sử dụng ngày âm lịch'**
  String get useLunarCalendar;

  /// No description provided for @eventDescriptionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả chi tiết'**
  String get eventDescriptionLabel;

  /// No description provided for @eventDescriptionHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mô tả về sự kiện (địa điểm, nội dung)...'**
  String get eventDescriptionHint;

  /// No description provided for @saveEventButton.
  ///
  /// In vi, this message translates to:
  /// **'Lưu sự kiện'**
  String get saveEventButton;

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
  /// **'Đại Học'**
  String get educationUniversity;

  /// No description provided for @educationPostgraduate.
  ///
  /// In vi, this message translates to:
  /// **'Cao Học'**
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

  /// No description provided for @addChildTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Thêm Con'**
  String get addChildTooltip;

  /// No description provided for @addSpouseTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Thêm Vợ/Chồng'**
  String get addSpouseTooltip;

  /// No description provided for @eventTypeArticle.
  ///
  /// In vi, this message translates to:
  /// **'Tin tức'**
  String get eventTypeArticle;

  /// No description provided for @eventTypeAnnouncement.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get eventTypeAnnouncement;

  /// No description provided for @eventTypeAnniversary.
  ///
  /// In vi, this message translates to:
  /// **'Giỗ chạp / Kỷ niệm'**
  String get eventTypeAnniversary;

  /// No description provided for @selectPostType.
  ///
  /// In vi, this message translates to:
  /// **'Chọn loại bài đăng'**
  String get selectPostType;

  /// No description provided for @eventTitleHintArticle.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề bài viết...'**
  String get eventTitleHintArticle;

  /// No description provided for @eventTitleHint.
  ///
  /// In vi, this message translates to:
  /// **'Tên sự kiện...'**
  String get eventTitleHint;

  /// No description provided for @eventTitleRequiredArticle.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tiêu đề'**
  String get eventTitleRequiredArticle;

  /// No description provided for @eventTitleRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên sự kiện'**
  String get eventTitleRequired;

  /// No description provided for @eventAddDescription.
  ///
  /// In vi, this message translates to:
  /// **'Thêm mô tả...'**
  String get eventAddDescription;

  /// No description provided for @eventSelectDate.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày tổ chức'**
  String get eventSelectDate;

  /// No description provided for @eventAddLocation.
  ///
  /// In vi, this message translates to:
  /// **'Thêm địa điểm'**
  String get eventAddLocation;

  /// No description provided for @eventAddOrganizer.
  ///
  /// In vi, this message translates to:
  /// **'Người viết'**
  String get eventAddOrganizer;

  /// No description provided for @eventAddAuthor.
  ///
  /// In vi, this message translates to:
  /// **'Thêm tác giả'**
  String get eventAddAuthor;

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

  /// No description provided for @eventOrganizerLabel.
  ///
  /// In vi, this message translates to:
  /// **'Người viết'**
  String get eventOrganizerLabel;

  /// No description provided for @eventOrganizerHint.
  ///
  /// In vi, this message translates to:
  /// **'Tên người viết...'**
  String get eventOrganizerHint;

  /// No description provided for @eventAuthorLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tác giả'**
  String get eventAuthorLabel;

  /// No description provided for @eventAuthorHint.
  ///
  /// In vi, this message translates to:
  /// **'Tên tác giả...'**
  String get eventAuthorHint;

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

  /// No description provided for @doneLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xong'**
  String get doneLabel;

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

  /// No description provided for @birthdaysSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'NGÀY SINH NHẬT DÒNG HỌ'**
  String get birthdaysSectionTitle;

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

  /// No description provided for @newsEventsSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'SỰ KIỆN & TIN TỨC'**
  String get newsEventsSectionTitle;

  /// No description provided for @generationLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đời thứ {gen}'**
  String generationLabel(int gen);

  /// No description provided for @spouseInfoLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin Vợ / Chồng'**
  String get spouseInfoLabel;

  /// No description provided for @parentInfoLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin Cha / Mẹ'**
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
  /// **'Chọn Vợ / Chồng'**
  String get selectSpouseLabel;

  /// No description provided for @searchSpouseHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm tên Vợ / Chồng...'**
  String get searchSpouseHint;

  /// No description provided for @inputSpouseNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên Vợ / Chồng'**
  String get inputSpouseNameLabel;

  /// No description provided for @inputSpouseNameHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Kết hôn với bà Nguyễn Thị B...'**
  String get inputSpouseNameHint;

  /// No description provided for @selectParentLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chọn Cha / Mẹ'**
  String get selectParentLabel;

  /// No description provided for @searchParentHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm tên Cha / Mẹ...'**
  String get searchParentHint;

  /// No description provided for @inputParentNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên Cha / Mẹ'**
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
  /// **'Sự kiện / Bài viết'**
  String get eventTypeEventArticle;

  /// No description provided for @eventImageFormatHint.
  ///
  /// In vi, this message translates to:
  /// **'Định dạng JPG, PNG (Tối đa 5MB)'**
  String get eventImageFormatHint;

  /// No description provided for @eventTimeLocationSection.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian & Địa điểm'**
  String get eventTimeLocationSection;

  /// No description provided for @eventPublishDateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày phát thông báo'**
  String get eventPublishDateLabel;

  /// No description provided for @eventCreateTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo thông báo gia tộc'**
  String get eventCreateTitle;

  /// No description provided for @eventTitleLabelAnnouncement.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề thông báo'**
  String get eventTitleLabelAnnouncement;

  /// No description provided for @eventTitleLabelEventArticle.
  ///
  /// In vi, this message translates to:
  /// **'Tên sự kiện / Bài viết'**
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
  /// **'Nội dung & Lịch trình'**
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

  /// No description provided for @eventByAuthor.
  ///
  /// In vi, this message translates to:
  /// **'Bởi '**
  String get eventByAuthor;

  /// No description provided for @adminBoard.
  ///
  /// In vi, this message translates to:
  /// **'Ban Quản Trị'**
  String get adminBoard;

  /// No description provided for @eventEnded.
  ///
  /// In vi, this message translates to:
  /// **'Đã kết thúc'**
  String get eventEnded;

  /// No description provided for @eventOngoing.
  ///
  /// In vi, this message translates to:
  /// **'Đang diễn ra'**
  String get eventOngoing;

  /// No description provided for @eventUpcoming.
  ///
  /// In vi, this message translates to:
  /// **'Sắp diễn ra'**
  String get eventUpcoming;

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
  /// **'Chọn Thành Viên Chưa Nối Cây'**
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
  /// **'Xoá & Tách nhánh'**
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

  /// No description provided for @unknownShortLabel.
  ///
  /// In vi, this message translates to:
  /// **'Không rõ'**
  String get unknownShortLabel;

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
  /// **'Chọn Thành Viên Có Sẵn'**
  String get selectExistingMemberTitle;

  /// No description provided for @searchMemberByNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm theo tên thành viên...'**
  String get searchMemberByNameHint;

  /// No description provided for @noMatchingMember.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thành viên nào phù hợp'**
  String get noMatchingMember;

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
  /// **'Thành viên {name}, Giới tính: {gender}'**
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
  /// **'Thêm Con Cho {name}'**
  String addChildForFormat(Object name);

  /// No description provided for @selectChildMemberTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn Thành Viên Làm Con'**
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
  /// **'Thêm Vợ / Chồng Cho {name}'**
  String addSpouseForFormat(Object name);

  /// No description provided for @selectSpouseMemberTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn Thành Viên Làm Vợ / Chồng'**
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

  /// No description provided for @sendRemembranceButton.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời tưởng nhớ'**
  String get sendRemembranceButton;

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

  /// No description provided for @eventDetailSemanticLabel.
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện {title}, Ngày: {date}'**
  String eventDetailSemanticLabel(Object date, Object title);

  /// No description provided for @linkAccountsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quản Lý Tài Khoản & Liên Kết'**
  String get linkAccountsTitle;

  /// No description provided for @linkAccountsNodeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Liên Kết Tài Khoản'**
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
  /// **'Liên Kết'**
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

  /// No description provided for @invitePendingDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi lời mời tới {email}. Tài khoản sẽ tự liên kết sau khi thành viên đăng ký.'**
  String invitePendingDesc(Object email);

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
  /// **'Xác Nhận Gỡ Liên Kết'**
  String get confirmUnlinkTitle;

  /// No description provided for @confirmUnlinkMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn gỡ liên kết tài khoản của thành viên {name}?'**
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

  /// No description provided for @trashStatusDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa'**
  String get trashStatusDeleted;

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
  /// **'Khôi Phục Thành Viên'**
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
  /// **'Xóa Vĩnh Viễn'**
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

  /// No description provided for @auditActionCreate.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã thêm một thành viên mới'**
  String auditActionCreate(String actor);

  /// No description provided for @auditActionUpdate.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã chỉnh sửa thành viên'**
  String auditActionUpdate(String actor);

  /// No description provided for @auditActionDelete.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã đưa thành viên vào thùng rác'**
  String auditActionDelete(String actor);

  /// No description provided for @auditActionRestore.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã khôi phục thành viên'**
  String auditActionRestore(String actor);

  /// No description provided for @auditActionPurge.
  ///
  /// In vi, this message translates to:
  /// **'{actor} đã dọn dẹp thùng rác'**
  String auditActionPurge(String actor);

  /// No description provided for @auditActionGeneric.
  ///
  /// In vi, this message translates to:
  /// **'{actor} · {action}'**
  String auditActionGeneric(String actor, String action);

  /// No description provided for @auditUnknownActor.
  ///
  /// In vi, this message translates to:
  /// **'Không xác định'**
  String get auditUnknownActor;

  /// No description provided for @auditChangedFields.
  ///
  /// In vi, this message translates to:
  /// **'{name} · sửa: {fields}'**
  String auditChangedFields(Object fields, Object name);

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

  /// No description provided for @filterCreate.
  ///
  /// In vi, this message translates to:
  /// **'Thêm mới'**
  String get filterCreate;

  /// No description provided for @filterUpdate.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật'**
  String get filterUpdate;

  /// No description provided for @restoreLabel.
  ///
  /// In vi, this message translates to:
  /// **'Khôi phục'**
  String get restoreLabel;

  /// No description provided for @disabledLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã tắt'**
  String get disabledLabel;

  /// No description provided for @enabledCountFormat.
  ///
  /// In vi, this message translates to:
  /// **'Đang bật ({count}/4)'**
  String enabledCountFormat(int count);

  /// No description provided for @notifEventSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật lịch sự kiện và họp mặt dòng tộc'**
  String get notifEventSubtitle;

  /// No description provided for @notifNewsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhận tin tức và thông cáo quan trọng từ Ban Quản Trị'**
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

  /// No description provided for @announcementBadge.
  ///
  /// In vi, this message translates to:
  /// **'THÔNG BÁO'**
  String get announcementBadge;

  /// No description provided for @generationLevelFormat.
  ///
  /// In vi, this message translates to:
  /// **'Đời {gen}'**
  String generationLevelFormat(String gen);

  /// No description provided for @memberSearchNoResult.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thành viên phù hợp'**
  String get memberSearchNoResult;
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
