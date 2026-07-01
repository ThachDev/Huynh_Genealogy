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
  String get forgotPassword => 'Forgot password?';

  @override
  String get loginButton => 'Login';

  @override
  String get orDivider => 'Or';

  @override
  String get googleLoginButton => 'Login with Google';

  @override
  String get noAccountText => 'Don\'t have an account? ';

  @override
  String get registerNow => 'Register now';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get registerTitle => 'Register';

  @override
  String get registerSubtitle => 'Create your family tree lineage account';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get fullNameHint => 'John Doe';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get confirmPasswordHint => '••••••••';

  @override
  String get registerButton => 'Register';

  @override
  String get alreadyHaveAccountText => 'Already have an account? ';

  @override
  String get loginNow => 'Login now';

  @override
  String get registerAsCreator => 'Register as Clan Leader';

  @override
  String get acceptTermsText => 'I agree to the ';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get andText => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsValidationErr =>
      'You must agree to the Terms of Service and Privacy Policy to continue';

  @override
  String get termsContent =>
      'Welcome to Gia Toc Viet. By using our service, you agree to the following terms:\n\n1. Account regulations: You are responsible for maintaining the confidentiality of your account and password.\n\n2. Data ownership: Genealogy information contributed by the clan is owned collectively by authorized members of the family.\n\n3. Prohibited conduct: Do not post content that distorts history, contains false information, or violates others\' privacy.\n\n4. Changes to terms: We reserve the right to update these terms of service to better fit system operations.';

  @override
  String get privacyContent =>
      'Gia Toc Viet is committed to protecting your family\'s privacy:\n\n1. Data collection: We collect name, email, avatar, and genealogy data actively provided by you.\n\n2. Data usage: Data is used to build the family tree diagram, connect members, and notify family events.\n\n3. Security: We apply modern security measures to prevent data breaches.\n\n4. Data sharing: We strictly do not sell or share your genealogy data with any third party for advertising purposes.';

  @override
  String get closeButton => 'Close';

  @override
  String get appTitle => 'Gia Toc Viet';

  @override
  String get confirmLabel => 'Confirm';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get okLabel => 'Close';

  @override
  String get loadingMessage => 'Processing...';

  @override
  String get emailLoginFeatureNotice =>
      'Email Login feature is under development. Please use Login with Google.';

  @override
  String get forgotPasswordNotice =>
      'Please contact the Clan Leader to reset your password.';

  @override
  String get forgotPasswordTitle => 'Forgot password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your registered email to receive a 6-digit verification code.';

  @override
  String get forgotPasswordButton => 'SEND VERIFICATION CODE';

  @override
  String get forgotPasswordSuccess =>
      'Password reset email sent. Please check your inbox (including spam folder).';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get otpTitle => 'OTP Verification';

  @override
  String get otpSubtitleStart => 'We have sent a 6-digit verification code to ';

  @override
  String get otpSubtitleEnd => '. Please check your inbox and enter the code.';

  @override
  String get otpLabel => 'Verification code';

  @override
  String get otpHint => '123456';

  @override
  String get otpRequiredError => 'Please enter the OTP code';

  @override
  String get otpInvalidError => 'OTP code must be 6 digits';

  @override
  String get otpVerifyButton => 'VERIFY';

  @override
  String get otpResendButton => 'Resend code';

  @override
  String get resetPasswordTitle => 'Reset password';

  @override
  String get resetPasswordSubtitle =>
      'Enter your new password for your account.';

  @override
  String get resetPasswordButton => 'RESET PASSWORD';

  @override
  String get resetPasswordSuccessTitle => 'Success!';

  @override
  String get resetPasswordSuccessMessage =>
      'Your password has been reset. Please sign in with your new password.';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get enterInviteCodeWarning => 'Please enter the invite code';

  @override
  String get onboardingTitle => 'Set Up Family';

  @override
  String get logoutTooltip => 'Logout';

  @override
  String get createFamilySuccess => 'Family created successfully!';

  @override
  String verifyInviteSuccess(String familyName) {
    return 'Invite code verified successfully: $familyName';
  }

  @override
  String get joinRequestSuccess => 'Join request sent successfully!';

  @override
  String get pendingApprovalTitle => 'Pending Approval';

  @override
  String get pendingApprovalMessage =>
      'Your request to join the family has been sent successfully. Please contact the Clan Leader to approve your account.';

  @override
  String get checkStatusButton => 'Check Status';

  @override
  String welcomeCreatorTitle(String name) {
    return 'Welcome Clan Leader, $name!';
  }

  @override
  String get welcomeCreatorSubtitle =>
      'Please enter the information below to initialize your family tree.';

  @override
  String get familyNameLabel => 'Family / Clan Name';

  @override
  String get familyNameHint => 'e.g. Nguyen Family';

  @override
  String get familyNameRequired => 'Family name cannot be empty';

  @override
  String get familyDescriptionLabel => 'Biography / Description';

  @override
  String get familyDescriptionHint => 'Home town, origins...';

  @override
  String get initFamilyButton => 'INITIALIZE FAMILY';

  @override
  String welcomeViewerTitle(String name) {
    return 'Welcome $name!';
  }

  @override
  String get welcomeViewerSubtitle =>
      'Please enter the Invite Code provided by the Clan Leader to join and view the family tree.';

  @override
  String get inviteCodeLabel => 'Family Invite Code';

  @override
  String get inviteCodeHint => 'Enter 6-character code';

  @override
  String get verifyButton => 'Verify';

  @override
  String familyFoundTitle(String name) {
    return 'Family found: $name';
  }

  @override
  String get selectMemberPrompt =>
      'Please select your name from the list below to link with the family tree (if any):';

  @override
  String get whoAreYouDropdownHint => 'Who are you on the family tree?';

  @override
  String get sendJoinRequestButton => 'SEND JOIN REQUEST';

  @override
  String get chooseOnboardingSubtitle =>
      'Please select a family tree setup method to start connecting your clan.';

  @override
  String get createFamilyCardTitle => 'Create a new Family';

  @override
  String get createFamilyCardDesc =>
      'For Clan Leaders/Genealogists who want to build a completely new family tree.';

  @override
  String get joinFamilyCardTitle => 'Connect with Family';

  @override
  String get joinFamilyCardDesc =>
      'For members who have an invite code from the Clan Leader to view and update the family tree.';

  @override
  String get errEmailRequired => 'Please enter your email address';

  @override
  String get errEmailInvalid => 'Invalid email format (e.g. name@gmail.com)';

  @override
  String get errPasswordRequired => 'Please enter password';

  @override
  String get errPasswordMinLength =>
      'Password must contain at least 6 characters';

  @override
  String get errStrongPasswordMinLength =>
      'Strong password must have at least 8 characters';

  @override
  String get errStrongPasswordUppercase =>
      'Password needs at least 1 uppercase letter';

  @override
  String get errStrongPasswordNumber => 'Password needs at least 1 digit';

  @override
  String get errStrongPasswordSpecialChar =>
      'Password needs at least 1 special character (!@#...)';

  @override
  String get errConfirmPasswordRequired => 'Please confirm your password';

  @override
  String get errConfirmPasswordMismatch => 'Confirm password does not match';

  @override
  String get errFullNameRequired => 'Please enter full name';

  @override
  String get errFullNameTooShort => 'Full name is too short';

  @override
  String get errFullNameTooLong => 'Full name cannot exceed 50 characters';

  @override
  String get errFullNameInvalid =>
      'Full name can only contain letters and spaces';

  @override
  String get errPhoneNumberRequired => 'Please enter phone number';

  @override
  String get errPhoneNumberInvalid => 'Invalid phone number (e.g. 0912345678)';

  @override
  String get errYearRequired => 'Please enter year';

  @override
  String get errYearInvalid => 'Please enter a valid year';

  @override
  String errYearFuture(int year) {
    return 'Year cannot be greater than the current year ($year)';
  }

  @override
  String errYearMin(int year) {
    return 'Year must be greater than or equal to $year';
  }

  @override
  String get errYearTooSmall =>
      'Year is too small (required from year 1000 onwards)';

  @override
  String errRequiredField(String fieldName) {
    return 'Please enter $fieldName';
  }

  @override
  String get errServer =>
      'The system is temporarily unavailable. Please try again in a few minutes.';

  @override
  String get errNetwork =>
      'No internet connection. Please check your Wi-Fi or cellular data.';

  @override
  String get errCache =>
      'Could not access temporary data on the device. Please reload the page.';

  @override
  String get errNotFound =>
      'Requested information could not be found or has been deleted.';

  @override
  String get errValidation =>
      'The entered details are incorrect. Please verify and try again.';

  @override
  String get errUnknown =>
      'An unexpected error occurred. Please try again later.';

  @override
  String get errAuth =>
      'Session has expired or credentials are incorrect. Please sign in again.';

  @override
  String get errPermission =>
      'Your account does not have permission to access this feature.';

  @override
  String get errTimeout =>
      'Connection is too slow or was interrupted. Please try again.';

  @override
  String get retryButton => 'Retry';

  @override
  String get errStateTitle => 'An error occurred';

  @override
  String get qrScannerTitle => 'Scan QR Code';

  @override
  String get qrScannerInstruction =>
      'Place the QR code inside the frame to scan automatically';

  @override
  String get qrScannerNoCodeFound => 'No QR code found in this photo.';

  @override
  String get qrScannerSelectImageError =>
      'An error occurred while choosing the photo.';

  @override
  String get tapToChangePhoto => 'TAP TO CHANGE PHOTO';

  @override
  String get tapToUploadPhoto => 'TAP TO UPLOAD PHOTO';

  @override
  String get byInitAgreeTerms => 'BY CLICKING INITIALIZE, YOU AGREE TO ';

  @override
  String get appTerms => 'THE TERMS OF GIA TOC VIET';

  @override
  String get enterInviteCodeLabel => 'ENTER INVITE CODE';

  @override
  String get inviteCodeHintNew => 'EG: HGT-2024';

  @override
  String get inviteCodeDescription =>
      'Enter the 6-character code provided by your family leader or administrator.';

  @override
  String get confirmJoinButton => 'CONFIRM JOIN';
}
