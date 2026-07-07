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
  /// **'GỬI MÃ XÁC THỰC'**
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
  /// **'XÁC THỰC'**
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
  /// **'ĐẶT LẠI MẬT KHẨU'**
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

  /// No description provided for @joinRequestDescription.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu gia nhập sẽ được gửi tới Trưởng tộc. Trưởng tộc sẽ thêm và xếp bạn vào đúng vị trí trên cây gia phả sau khi phê duyệt.'**
  String get joinRequestDescription;

  /// No description provided for @joinFamilyCardDesc.
  ///
  /// In vi, this message translates to:
  /// **'Dành cho thành viên đã có mã mời từ Trưởng tộc để xem và cập nhật cây gia phả.'**
  String get joinFamilyCardDesc;

  /// No description provided for @familyPhotoSectionLabel.
  ///
  /// In vi, this message translates to:
  /// **'ẢNH ĐẠI DIỆN DÒNG HỌ'**
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
  /// **'KHỞI TẠO THÀNH CÔNG'**
  String get creationSuccessTitle;

  /// No description provided for @confirmJoinButton.
  ///
  /// In vi, this message translates to:
  /// **'XÁC NHẬN THAM GIA'**
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
  /// **'LƯU LẠI'**
  String get formSave;

  /// No description provided for @formCancel.
  ///
  /// In vi, this message translates to:
  /// **'HỦY BỎ'**
  String get formCancel;

  /// No description provided for @lunarSuffix.
  ///
  /// In vi, this message translates to:
  /// **'ÂM LỊCH'**
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
  /// **'CHIA SẺ CHO GIA ĐÌNH'**
  String get shareFamilyButton;

  /// No description provided for @shareFamilyContent.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia gia phả \"{name}\" trên ứng dụng Gia Tộc Việt. Mã mời của dòng họ là: {code}'**
  String shareFamilyContent(String name, String code);

  /// No description provided for @startExploringButton.
  ///
  /// In vi, this message translates to:
  /// **'BẮT ĐẦU KHÁM PHÁ'**
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
  /// **'CÀI ĐẶT QUẢN TRỊ'**
  String get adminSettingsTitle;

  /// No description provided for @accountAndClanSection.
  ///
  /// In vi, this message translates to:
  /// **'TÀI KHOẢN VÀ DÒNG TỘC'**
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
  /// **'THIẾT LẬP ỨNG DỤNG'**
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

  /// No description provided for @infoAndHelpSection.
  ///
  /// In vi, this message translates to:
  /// **'THÔNG TIN & TRỢ GIÚP'**
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
  /// **'QUẢN TRỊ NÂNG CAO'**
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
  /// **'ĐĂNG XUẤT'**
  String get logoutButton;

  /// No description provided for @accountSecurityTitle.
  ///
  /// In vi, this message translates to:
  /// **'BẢO MẬT TÀI KHOẢN'**
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
  /// **'CẬP NHẬT MẬT KHẨU'**
  String get updatePasswordButton;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi mật khẩu thành công!'**
  String get changePasswordSuccess;

  /// No description provided for @dissolveClanTitle.
  ///
  /// In vi, this message translates to:
  /// **'GIẢI TÁN GIA PHẢ'**
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
  /// **'GIẢI TÁN DÒNG HỌ VĨNH VIỄN'**
  String get dissolvePermanentButton;

  /// No description provided for @deletePermanentDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'XÓA GIA PHẢ VĨNH VIỄN'**
  String get deletePermanentDialogTitle;

  /// No description provided for @deletePermanentDialogMessage.
  ///
  /// In vi, this message translates to:
  /// **'Hành động này cực kỳ nguy hiểm. Toàn bộ thông tin thành viên, các nhánh dòng họ, lịch sử gia tộc của \"{name}\" sẽ bị xóa vĩnh viễn khỏi máy chủ. Bạn chắc chắn muốn tiếp tục chứ?'**
  String deletePermanentDialogMessage(String name);

  /// No description provided for @confirmDeletePermanentLabel.
  ///
  /// In vi, this message translates to:
  /// **'ĐỒNG Ý XÓA BỎ'**
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

  /// No description provided for @noEligibleMembers.
  ///
  /// In vi, this message translates to:
  /// **'Không có thành viên nào đủ điều kiện nhận chuyển nhượng.'**
  String get noEligibleMembers;

  /// No description provided for @proceedTransferButton.
  ///
  /// In vi, this message translates to:
  /// **'TIẾN HÀNH CHUYỂN NHƯỢNG'**
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
  /// **'ĐỒNG Ý CHUYỂN'**
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
  /// **'Phân quyền thành viên'**
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
  /// **'THÔNG TIN TÀI KHOẢN'**
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
  /// **'TẠO HỒ SƠ GIA PHẢ'**
  String get createProfileButton;

  /// No description provided for @clanInfoSettingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'THÔNG TIN DÒNG TỘC'**
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
  /// **'QUY ĐỊNH & ĐIỀU KHOẢN'**
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
  /// **'**Ứng dụng:** Gia Tộc Việt và các tính năng của ứng dụng.\n**Người dùng:** Cá nhân đã đăng ký tài khoản.\n**Dòng họ:** Nhóm thành viên do Trưởng tộc tạo lập, gồm chi tộc, thành viên và dữ liệu gia phả.\n**Trưởng tộc:** Người quản trị cao nhất của dòng họ.\n**Quản trị chi:** Người được ủy quyền quản lý một chi tộc.\n**Biên tập viên:** Người được phép thêm, sửa thông tin.\n**Thành viên:** Người có quyền xem gia phả.\n**Dữ liệu cá nhân:** Họ tên, ngày sinh, giới tính, quan hệ gia đình, hình ảnh, số điện thoại, email…'**
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
  /// **'**Thành viên** – Xem gia phả, quỹ dòng họ, sửa thông tin cá nhân.\n**Biên tập viên** – Thêm, sửa thông tin thành viên (không được xóa).\n**Quản trị chi** – Quản lý chi tộc, phê duyệt yêu cầu, quản lý quỹ.\n**Trưởng tộc** – Toàn quyền quản trị, phân quyền, chuyển nhượng, giải tán.'**
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
  /// **'TRUNG TÂM HỖ TRỢ'**
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
  /// **'Tải ứng dụng Gia Tộc Việt từ CH Play (Android). Mở ứng dụng, nhấn \"Đăng ký\" và điền đầy đủ họ tên, email, số điện thoại và mật khẩu.'**
  String get faqRegisterAnswer;

  /// No description provided for @faqForgotPasswordQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Tôi quên mật khẩu, phải làm sao?'**
  String get faqForgotPasswordQuestion;

  /// No description provided for @faqForgotPasswordAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Trên màn hình đăng nhập, nhấn \"Quên mật khẩu\". Nhập email đã đăng ký, hệ thống sẽ gửi mã OTP gồm 6 chữ số qua email. Nhập mã OTP để xác thực, sau đó tạo mật khẩu mới.'**
  String get faqForgotPasswordAnswer;

  /// No description provided for @faqChangePasswordQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để đổi mật khẩu?'**
  String get faqChangePasswordQuestion;

  /// No description provided for @faqChangePasswordAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Vào Cài đặt > Bảo mật tài khoản, nhập mật khẩu hiện tại, sau đó nhập mật khẩu mới và xác nhận. Mật khẩu mới phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số.'**
  String get faqChangePasswordAnswer;

  /// No description provided for @faqAddMemberQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để thêm thành viên mới?'**
  String get faqAddMemberQuestion;

  /// No description provided for @faqAddMemberAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Vào Dashboard > Quản lý thành viên, nhấn nút \"Thêm thành viên\". Điền đầy đủ thông tin: họ tên, giới tính, ngày sinh, nơi sinh, thế hệ, chi tộc, cha/mẹ (nếu có). Bạn có thể thêm thông tin chi tiết như ngày mất, tình trạng hôn nhân, số điện thoại, ghi chú. Nhấn \"Lưu\" để hoàn tất.'**
  String get faqAddMemberAnswer;

  /// No description provided for @faqAddBranchQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để thêm nhánh (chi tộc) mới?'**
  String get faqAddBranchQuestion;

  /// No description provided for @faqAddBranchAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Vào Dashboard > Quản lý chi tộc, nhấn \"Thêm chi tộc\". Điền tên chi tộc, mô tả và thông tin người sáng lập (nếu có). Sau khi tạo, bạn có thể phân quyền Quản trị chi cho thành viên phụ trách nhánh đó.'**
  String get faqAddBranchAnswer;

  /// No description provided for @faqEditMemberQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để chỉnh sửa thông tin thành viên?'**
  String get faqEditMemberQuestion;

  /// No description provided for @faqEditMemberAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Vào Dashboard > Quản lý thành viên, chọn thành viên cần chỉnh sửa. Nhấn vào biểu tượng chỉnh sửa (bút) để cập nhật thông tin. Lưu ý: chỉ Biên tập viên và các vai trò cao hơn mới có quyền chỉnh sửa.'**
  String get faqEditMemberAnswer;

  /// No description provided for @faqDeleteMemberQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để xóa thành viên?'**
  String get faqDeleteMemberQuestion;

  /// No description provided for @faqDeleteMemberAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thành viên trong danh sách, nhấn biểu tượng xóa (thùng rác). Một hộp thoại xác nhận sẽ hiện ra. Lưu ý: chỉ Trưởng tộc và Quản trị chi mới có quyền xóa thành viên. Biên tập viên không có quyền này.'**
  String get faqDeleteMemberAnswer;

  /// No description provided for @faqImportGenealogyQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Nhập gia phả từ file được không?'**
  String get faqImportGenealogyQuestion;

  /// No description provided for @faqImportGenealogyAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng hiện hỗ trợ thêm từng thành viên thủ công. Tính năng nhập hàng loạt từ file đang được phát triển.'**
  String get faqImportGenealogyAnswer;

  /// No description provided for @faqInviteCodeQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Mã mời gia tộc hoạt động như thế nào?'**
  String get faqInviteCodeQuestion;

  /// No description provided for @faqInviteCodeAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi Dòng tộc có một Mã mời duy nhất do hệ thống tạo. Trưởng tộc có thể xem, sao chép hoặc chia sẻ Mã mời qua QR code trong Dashboard. Thành viên mới nhập mã này khi đăng ký hoặc trong mục \"Tham gia gia tộc\" để gửi yêu cầu gia nhập. Trưởng tộc hoặc Quản trị chi sẽ phê duyệt yêu cầu trước khi thành viên có thể truy cập.'**
  String get faqInviteCodeAnswer;

  /// No description provided for @faqRolesQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Các vai trò trong Dòng tộc là gì?'**
  String get faqRolesQuestion;

  /// No description provided for @faqRolesAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống có 4 cấp vai trò:\n• Trưởng tộc — Quyền cao nhất, quản lý toàn bộ Dòng tộc, phân quyền và giải tán.\n• Quản trị chi — Quản lý một hoặc nhiều nhánh, phê duyệt yêu cầu gia nhập.\n• Biên tập viên — Thêm và chỉnh sửa thông tin thành viên, không được xóa.\n• Thành viên — Xem thông tin gia phả, không được chỉnh sửa.'**
  String get faqRolesAnswer;

  /// No description provided for @faqAssignRoleQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để phân quyền cho thành viên?'**
  String get faqAssignRoleQuestion;

  /// No description provided for @faqAssignRoleAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Vào Cài đặt > Phân quyền thành viên (chỉ Trưởng tộc mới thấy mục này). Chọn thành viên cần thay đổi vai trò và chọn cấp quyền tương ứng. Trưởng tộc không thể tự hạ cấp vai trò của mình — cần sử dụng tính năng Chuyển nhượng quyền Trưởng tộc.'**
  String get faqAssignRoleAnswer;

  /// No description provided for @faqTransferOwnershipQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để chuyển nhượng quyền Trưởng tộc?'**
  String get faqTransferOwnershipQuestion;

  /// No description provided for @faqTransferOwnershipAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Vào Cài đặt > Chuyển nhượng quyền Trưởng tộc. Chọn thành viên đã kích hoạt tài khoản từ danh sách. Xác nhận chuyển nhượng — thao tác này không thể hoàn tác. Sau khi chuyển nhượng, bạn sẽ trở thành Thành viên và người nhận trở thành Trưởng tộc mới.'**
  String get faqTransferOwnershipAnswer;

  /// No description provided for @faqDissolveClanQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để giải tán dòng tộc?'**
  String get faqDissolveClanQuestion;

  /// No description provided for @faqDissolveClanAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Vào Cài đặt > Giải tán dòng họ (chỉ Trưởng tộc). Gõ chính xác tên Dòng tộc để xác nhận. Toàn bộ dữ liệu bao gồm thành viên, nhánh, gia phả và quỹ gia tộc sẽ bị xóa vĩnh viễn khỏi hệ thống và không thể khôi phục. Cân nhắc kỹ trước khi thực hiện.'**
  String get faqDissolveClanAnswer;

  /// No description provided for @faqDataSecurityQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu gia phả của tôi có được bảo mật không?'**
  String get faqDataSecurityQuestion;

  /// No description provided for @faqDataSecurityAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Có. Toàn bộ dữ liệu được lưu trữ trên máy chủ đặt tại Việt Nam, áp dụng mã hóa đầu cuối TLS 1.3 khi truyền tải và mã hóa AES-256 khi lưu trữ. Chúng tôi tuân thủ nghiêm ngặt Nghị định 13/2023/NĐ-CP về bảo vệ dữ liệu cá nhân và cam kết không bán, chia sẻ dữ liệu cho bên thứ ba.'**
  String get faqDataSecurityAnswer;

  /// No description provided for @faqDeleteAccountQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao để xóa tài khoản?'**
  String get faqDeleteAccountQuestion;

  /// No description provided for @faqDeleteAccountAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Vào Cài đặt > Bảo mật tài khoản, chọn \"Xóa tài khoản\". Xác nhận yêu cầu xóa. Dữ liệu cá nhân của bạn sẽ được xóa khỏi hệ thống trong vòng 30 ngày. Lưu ý: nếu bạn là Trưởng tộc, cần chuyển nhượng quyền Trưởng tộc hoặc giải tán Dòng tộc trước khi xóa tài khoản.'**
  String get faqDeleteAccountAnswer;

  /// No description provided for @faqMultiDeviceQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Tôi có thể sử dụng ứng dụng trên nhiều thiết bị không?'**
  String get faqMultiDeviceQuestion;

  /// No description provided for @faqMultiDeviceAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Có. Tài khoản của bạn có thể đăng nhập trên nhiều thiết bị cùng lúc. Dữ liệu sẽ được đồng bộ hóa theo thời gian thực. Tuy nhiên, vì lý do bảo mật, bạn nên đăng xuất khỏi thiết bị không sử dụng.'**
  String get faqMultiDeviceAnswer;

  /// No description provided for @faqEnglishSupportQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng có hỗ trợ tiếng Anh không?'**
  String get faqEnglishSupportQuestion;

  /// No description provided for @faqEnglishSupportAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Có. Vào Cài đặt > Ngôn ngữ, chuyển đổi giữa Tiếng Việt và Tiếng Anh. Giao diện sẽ cập nhật ngay lập tức. Dữ liệu gia phả và thông tin thành viên vẫn được giữ nguyên.'**
  String get faqEnglishSupportAnswer;

  /// No description provided for @aboutUsTitle.
  ///
  /// In vi, this message translates to:
  /// **'VỀ CHÚNG TÔI'**
  String get aboutUsTitle;

  /// No description provided for @aboutUsTagline.
  ///
  /// In vi, this message translates to:
  /// **'Gia Tộc Việt giúp bạn gìn giữ cây gia phả dòng họ trên nền tảng số, kết nối các thế hệ dù ở bất kỳ nơi đâu. Từ ông bà tổ tiên đến con cháu hôm nay — tất cả đều trong tầm tay.'**
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
  /// **'BẢNG QUẢN TRỊ'**
  String get adminDashboardTitle;

  /// No description provided for @roleOwner.
  ///
  /// In vi, this message translates to:
  /// **'TRƯỞNG TỘC'**
  String get roleOwner;

  /// No description provided for @roleBranchAdmin.
  ///
  /// In vi, this message translates to:
  /// **'TRƯỞNG CHI'**
  String get roleBranchAdmin;

  /// No description provided for @roleEditor.
  ///
  /// In vi, this message translates to:
  /// **'BIÊN TẬP VIÊN'**
  String get roleEditor;

  /// No description provided for @roleViewer.
  ///
  /// In vi, this message translates to:
  /// **'THÀNH VIÊN'**
  String get roleViewer;

  /// No description provided for @memberListTitle.
  ///
  /// In vi, this message translates to:
  /// **'DANH SÁCH THÀNH VIÊN'**
  String get memberListTitle;

  /// No description provided for @branchListTitle.
  ///
  /// In vi, this message translates to:
  /// **'DANH SÁCH CHI TỘC'**
  String get branchListTitle;

  /// No description provided for @pendingRequestTitle.
  ///
  /// In vi, this message translates to:
  /// **'YÊU CẦU CHỜ DUYỆT'**
  String get pendingRequestTitle;

  /// No description provided for @searchMembersHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm thành viên hoặc chi tộc...'**
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
  /// **'THÀNH VIÊN'**
  String get statMembers;

  /// No description provided for @statBranches.
  ///
  /// In vi, this message translates to:
  /// **'CHI TỘC'**
  String get statBranches;

  /// No description provided for @statPending.
  ///
  /// In vi, this message translates to:
  /// **'CHỜ DUYỆT'**
  String get statPending;

  /// No description provided for @inviteCodeSectionLabel.
  ///
  /// In vi, this message translates to:
  /// **'MÃ THAM GIA GIA TỘC'**
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
  /// **'Đời tổ/Sáng lập: {name}'**
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
  /// **'LƯU CHI TỘC'**
  String get saveBranchLabel;

  /// No description provided for @editBranchTitle.
  ///
  /// In vi, this message translates to:
  /// **'SỬA CHI TỘC'**
  String get editBranchTitle;

  /// No description provided for @addBranchTitle.
  ///
  /// In vi, this message translates to:
  /// **'THÊM CHI TỘC'**
  String get addBranchTitle;

  /// No description provided for @deleteBranchTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Xóa chi tộc'**
  String get deleteBranchTooltip;

  /// No description provided for @basicInfoTitle.
  ///
  /// In vi, this message translates to:
  /// **'THÔNG TIN CƠ BẢN'**
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
  /// **'SỬA THÀNH VIÊN'**
  String get editMemberTitle;

  /// No description provided for @addMemberTitle.
  ///
  /// In vi, this message translates to:
  /// **'THÊM THÀNH VIÊN'**
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
  /// **'HÔN NHÂN'**
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
  /// **'GIỚI TÍNH'**
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
  /// **'TÌNH TRẠNG'**
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

  /// No description provided for @parentLabel.
  ///
  /// In vi, this message translates to:
  /// **'CHA/MẸ'**
  String get parentLabel;

  /// No description provided for @spouseLabel.
  ///
  /// In vi, this message translates to:
  /// **'VỢ/CHỒNG'**
  String get spouseLabel;

  /// No description provided for @branchSectionLabel.
  ///
  /// In vi, this message translates to:
  /// **'CHI/NHÁNH'**
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
  /// **'TẢI ẢNH ĐẠI DIỆN'**
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
  /// **'TÀI KHOẢN'**
  String get accountSectionTitle;

  /// No description provided for @allLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get allLabel;

  /// No description provided for @biographySectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'TIỂU SỬ & GHI CHÚ'**
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
  /// **'CHÚC MỪNG ({count})'**
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
  /// **'QUỸ GIA TỘC'**
  String get familyFundTitle;

  /// No description provided for @familyRelationSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'QUAN HỆ GIA ĐÌNH'**
  String get familyRelationSectionTitle;

  /// No description provided for @familyTreeMapTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bản Đồ Phả Hệ'**
  String get familyTreeMapTitle;

  /// No description provided for @familyTreeNameFormat.
  ///
  /// In vi, this message translates to:
  /// **'GIA PHẢ HỌ {name}'**
  String familyTreeNameFormat(String name);

  /// No description provided for @familyTreeTitle.
  ///
  /// In vi, this message translates to:
  /// **'GIA PHẢ DÒNG HỌ'**
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
  /// **'ĐỐT NHANG ({count})'**
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
  /// **'THÔNG TIN CÁ NHÂN'**
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

  /// No description provided for @settingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'CÀI ĐẶT'**
  String get settingsTitle;

  /// No description provided for @spiritualMotto.
  ///
  /// In vi, this message translates to:
  /// **'CỘI NGUỒN TÂM LINH • VẠN ĐẠI TRƯỜNG TỒN'**
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
