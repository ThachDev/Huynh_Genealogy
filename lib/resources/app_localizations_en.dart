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
  String get clanAndPersonalInfoTitle => 'Clan & Personal Info';

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
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your registered email to receive a 6-digit verification code.';

  @override
  String get forgotPasswordButton => 'Send Verification Code';

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
  String get otpVerifyButton => 'Verify';

  @override
  String get otpResendButton => 'Resend code';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordSubtitle =>
      'Enter your new password for your account.';

  @override
  String get resetPasswordButton => 'Reset Password';

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
  String get initFamilyButton => 'Initialize Family';

  @override
  String get initFamilySectionDesc =>
      'Create a digital family tree today to connect generations and preserve your family\'s heritage.';

  @override
  String get initFamilySectionTitle => 'Start a new family tree';

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
  String get sendJoinRequestButton => 'Send Join Request';

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
  String get joinRequestDescription =>
      'Your join request will be sent to the Clan Leader. The Clan Leader will add you to the correct position on the family tree after approval.';

  @override
  String get joinFamilyCardDesc =>
      'For members who have an invite code from the Clan Leader to view and update the family tree.';

  @override
  String get familyPhotoSectionLabel => 'Family Representative Photo';

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
  String get tapToChangePhoto => 'Tap to Change Photo';

  @override
  String get tapToUploadPhoto => 'Tap to Upload Photo';

  @override
  String get byInitAgreeTerms => 'By Clicking Initialize, You Agree To ';

  @override
  String get appTerms => 'The Terms of Gia Toc Viet';

  @override
  String get enterInviteCodeLabel => 'Enter Invite Code';

  @override
  String get inviteCodeHintNew => 'EG: HGT-2024';

  @override
  String get inviteCodeDescription =>
      'Enter the 6-character code provided by your family leader or administrator.';

  @override
  String get connectFamilySectionTitle => 'Connect with Family';

  @override
  String get copiedShareContent => 'Copied share content!';

  @override
  String get creationSuccessTitle => 'Creation Success';

  @override
  String get confirmJoinButton => 'Confirm Join';

  @override
  String get navOverview => 'Overview';

  @override
  String get navFamilyTree => 'Family Tree';

  @override
  String get navFamilyFund => 'Family Fund';

  @override
  String get navSettings => 'Settings';

  @override
  String get errGenerationRequired => 'Please enter the generation number';

  @override
  String get errGenerationMustBeNumber => 'Generation must be a number';

  @override
  String get errPlaceOfBirthRequired => 'Please enter place of birth';

  @override
  String get errDateOfBirthRequired => 'Please select date of birth';

  @override
  String get errDateOfDeathRequired => 'Please select date of death';

  @override
  String get formSave => 'Save';

  @override
  String get formCancel => 'Cancel';

  @override
  String get lunarSuffix => 'Lunar';

  @override
  String get leapMonthSuffix => '(Leap)';

  @override
  String get searchNameHint => 'Search your name...';

  @override
  String get selectMemberHint => 'Select member...';

  @override
  String get shareFamilyButton => 'Share With Family';

  @override
  String shareFamilyContent(String name, String code) {
    return 'Join the \"$name\" family tree on Gia Toc Viet app. The family invite code is: $code';
  }

  @override
  String get startExploringButton => 'Start Exploring';

  @override
  String get searchHint => 'Search...';

  @override
  String get selectDate => 'Select date';

  @override
  String get selectMonthYear => 'Select month and year';

  @override
  String get adminSettingsTitle => 'Admin Settings';

  @override
  String get accountAndClanSection => 'Account & Clan';

  @override
  String get clanInfoLabel => 'Clan Information';

  @override
  String get accountSecurityLabel => 'Account Security';

  @override
  String get switchToMemberPage => 'Switch to Member Page';

  @override
  String get appSettingsSection => 'App Settings';

  @override
  String get languageLabel => 'Language';

  @override
  String get themeLabel => 'Theme';

  @override
  String get infoAndHelpSection => 'Info & Help';

  @override
  String get regulationsLabel => 'Regulations & Terms';

  @override
  String get helpCenterLabel => 'Help Center';

  @override
  String get aboutUsLabel => 'About Us';

  @override
  String get advancedAdminSection => 'Advanced Admin';

  @override
  String get memberRolesLabel => 'Member Roles';

  @override
  String get transferOwnershipLabel => 'Transfer Clan Leadership';

  @override
  String get dissolveClanLabel => 'Dissolve Clan';

  @override
  String get logoutButton => 'Logout';

  @override
  String get accountSecurityTitle => 'Account Security';

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get passwordRequirementsDesc =>
      'Your new password needs at least 8 characters, including numbers, uppercase letters, and special characters for security.';

  @override
  String get currentPasswordLabel => 'Current Password';

  @override
  String get currentPasswordHint => 'Enter current password';

  @override
  String get currentPasswordRequired => 'Please enter current password';

  @override
  String get newPasswordHint => 'Enter new password';

  @override
  String get confirmNewPasswordLabel => 'Confirm New Password';

  @override
  String get confirmNewPasswordHint => 'Re-enter new password';

  @override
  String get updatePasswordButton => 'Update Password';

  @override
  String get changePasswordSuccess => 'Password changed successfully!';

  @override
  String get dissolveClanTitle => 'Dissolve Clan';

  @override
  String get irreversibleActionTitle => 'Irreversible Action';

  @override
  String get irreversibleWarningDesc =>
      'This CANNOT be undone. All family tree data, generations, members and information will be permanently deleted from the system.';

  @override
  String get confirmDissolveTitle => 'Confirm Dissolve';

  @override
  String get confirmDissolveInstruction =>
      'To confirm, please enter the exact clan name below:';

  @override
  String get enterLabel => 'Enter: ';

  @override
  String get reenterClanNameLabel => 'Re-enter clan name';

  @override
  String get reenterClanNameHint => 'Type exactly to confirm';

  @override
  String get dissolvePermanentButton => 'Permanently Dissolve Clan';

  @override
  String get deletePermanentDialogTitle => 'Permanently Delete Genealogy';

  @override
  String deletePermanentDialogMessage(String name) {
    return 'This action is extremely dangerous. All member information, branches, and family history of \"$name\" will be permanently deleted from the server. Are you sure you want to continue?';
  }

  @override
  String get confirmDeletePermanentLabel => 'Confirm Delete';

  @override
  String get dissolveSuccessMessage =>
      'Genealogy deleted. All data has been removed from the system.';

  @override
  String get chooseRecipientLabel => 'Choose Recipient';

  @override
  String get transferDesc =>
      'Only members with activated accounts and a role other than Clan Leader appear in the list below:';

  @override
  String get searchMemberHint => 'Search member...';

  @override
  String get noMemberFound => 'No matching member found.';

  @override
  String get noEligibleMembers => 'No eligible members for transfer.';

  @override
  String get proceedTransferButton => 'Proceed With Transfer';

  @override
  String get warningDialogTitle => 'Important Warning';

  @override
  String get warningDialogMessage =>
      'Clan Leader is the highest authority in the genealogy system. Once transferred, you will lose the ability to edit advanced clan structure and security settings.';

  @override
  String warningDialogConfirmMessage(String name) {
    return 'Are you sure you want to transfer Clan Leadership to $name?';
  }

  @override
  String get confirmTransferButton => 'Confirm Transfer';

  @override
  String get transferSuccess => 'Clan Leadership transferred successfully!';

  @override
  String get transferProcessing => 'Processing transfer...';

  @override
  String get memberRolesTitle => 'Member Roles';

  @override
  String roleOfUser(String name) {
    return 'Role of $name';
  }

  @override
  String get roleBranchAdminTitle => 'Branch Leader';

  @override
  String get roleBranchAdminDesc =>
      'Manage personnel and content of the branch.';

  @override
  String get roleEditorTitle => 'Editor';

  @override
  String get roleEditorDesc => 'Contribute and edit genealogy information.';

  @override
  String get roleViewerTitle => 'Member';

  @override
  String get roleViewerDesc => 'Can only view family information.';

  @override
  String get updateRoleSuccess => 'Role updated successfully!';

  @override
  String get noMembers => 'No members in the clan yet.';

  @override
  String get cannotSelfChange =>
      'You cannot change your own role. Use the \"Transfer Clan Leadership\" feature.';

  @override
  String get accountInfoTitle => 'Account Information';

  @override
  String get emailAccountLabel => 'Email (Account)';

  @override
  String get noProfileLink => 'No genealogy profile linked';

  @override
  String get noProfileLinkDesc =>
      'Your account is Clan Leader but hasn\'t been linked to any member in the family tree. Create a profile now to start managing the genealogy.';

  @override
  String get createProfileButton => 'Create Genealogy Profile';

  @override
  String get clanInfoSettingsTitle => 'Clan Information';

  @override
  String get basicInfoSectionTitle => 'Basic Information';

  @override
  String get clanNameLabel => 'Clan Name';

  @override
  String get clanNameHint => 'Enter your clan name';

  @override
  String get clanNameRequired => 'Please enter the clan name';

  @override
  String get originLabel => 'Origin / Hometown';

  @override
  String get originHint => 'Enter ancestral hometown';

  @override
  String get originRequired => 'Please enter clan origin';

  @override
  String get clanDescLabel => 'Detailed Description';

  @override
  String get clanDescHint => 'Summary of clan history and traditions';

  @override
  String get editTooltip => 'Edit';

  @override
  String get doneTooltip => 'Done';

  @override
  String get noFamilyInfo => 'No family info found to update';

  @override
  String get updateFamilySuccess => 'Clan information updated successfully!';

  @override
  String get regulationsTitle => 'Regulations & Terms';

  @override
  String get regulationTitle => 'Gia Tộc Việt Terms of Service';

  @override
  String get regulationLastUpdated => 'Last Updated: July, 2026';

  @override
  String get regSection1Title => 'Acceptance';

  @override
  String get regSection1Content =>
      'By downloading and using Gia Tộc Việt, you agree to the following terms and our Privacy Policy. If you do not agree, please do not use the app.';

  @override
  String get regSection2Title => 'Definitions';

  @override
  String get regSection2Content =>
      '**App:** Gia Tộc Việt and its features.\n**User:** An individual who has registered an account.\n**Clan:** A group of members created by the Clan Leader, including branches, members, and genealogy data.\n**Clan Leader:** The highest administrator of the clan.\n**Branch Admin:** A person authorized to manage a branch.\n**Editor:** A person allowed to add and edit information.\n**Member:** A person with permission to view the genealogy.\n**Personal Data:** Full name, date of birth, gender, family relationships, images, phone number, email...';

  @override
  String get regSection3Title => 'Accounts';

  @override
  String get regSection3Content =>
      '• You must be at least 18 years old or have a legal guardian.\n• You are responsible for protecting your password.\n• Each person may only create one account for personal use.\n• Registration information must be accurate and truthful.';

  @override
  String get regSection4Title => 'Role Permissions';

  @override
  String get regSection4Content =>
      '**Member** – View genealogy, family fund, edit personal information.\n**Editor** – Add, edit member information (cannot delete).\n**Branch Admin** – Manage branch, approve requests, manage fund.\n**Clan Leader** – Full administrative rights, assign roles, transfer ownership, dissolve clan.';

  @override
  String get regSection5Title => 'Clan Management';

  @override
  String get regSection5Content =>
      'The Clan Leader has full authority: approve members, assign roles, update information, transfer Clan Leadership, and dissolve the clan. Upon transfer, the former Clan Leader becomes a Member and cannot regain the previous role. All add, edit, and delete operations in the system are recorded.';

  @override
  String get regSection6Title => 'Data Security';

  @override
  String get regSection6Content =>
      'We protect your data in accordance with Vietnam\'s Cybersecurity Law and Decree 13/2023/NĐ-CP. Data is stored on servers in Vietnam, encrypted during transmission and storage. We do not sell your data to third parties. Clan information is only visible to approved members.';

  @override
  String get regSection7Title => 'Intellectual Property';

  @override
  String get regSection7Content =>
      'Gia Tộc Việt (source code, design, brand, logo) is the property of the developer, protected under Vietnamese law. Genealogy data created by users belongs to their respective clan.';

  @override
  String get regSection8Title => 'Liability';

  @override
  String get regSection8Content =>
      'The app is provided as-is. We are not liable if: (i) you misuse the app; (ii) the information you provide is inaccurate; (iii) the Clan Leader actively deletes or dissolves the clan. If data is lost due to system errors, we will attempt to restore it.';

  @override
  String get regSection9Title => 'Violations';

  @override
  String get regSection9Content =>
      'We may suspend or terminate accounts if violations are detected. Actions include: warning, temporary suspension, permanent ban, or notifying authorities if laws are broken. The Clan Leader may dissolve the clan at any time — after confirmation, all data is permanently deleted and cannot be recovered.';

  @override
  String get regSection10Title => 'General Terms';

  @override
  String get regSection10Content =>
      'These terms are governed by Vietnamese law. Disputes shall first be resolved through negotiation. We may modify the terms and will notify you via the app. Your continued use after changes constitutes acceptance of the new terms.';

  @override
  String get copyrightText => '© 2026 ThachDev. All rights reserved.';

  @override
  String get helpCenterTitle => 'Help Center';

  @override
  String get helpDragInstruction => '👉 Drag the diagram to move around';

  @override
  String get helpTapInstruction => '👤 Tap a member to view details';

  @override
  String get helpTooltip => 'Help';

  @override
  String get helpZoomInstruction => '🔍 Pinch to zoom in/out';

  @override
  String get contactSection => 'Direct Contact';

  @override
  String get hotlineTitle => 'Support Hotline';

  @override
  String get hotlineValue => '1900 8888';

  @override
  String get hotlineSubtitle => '8:00 - 17:30 (Mon-Fri)';

  @override
  String get supportEmailTitle => 'Support Email';

  @override
  String get supportEmailValue => 'thachhuynh.dev@gmail.com';

  @override
  String get supportEmailSubtitle => 'Response within 24h';

  @override
  String get accountLoginSection => 'Account & Login';

  @override
  String get genealogyMemberSection => 'Genealogy & Members';

  @override
  String get clanAndRolesSection => 'Clan & Permissions';

  @override
  String get techSecuritySection => 'Technical & Security';

  @override
  String get faqRegisterQuestion => 'How to register an account?';

  @override
  String get faqRegisterAnswer =>
      'Download Gia Tộc Việt from CH Play (Android). Open the app, tap \"Register\" and fill in your full name, email, phone number and password.';

  @override
  String get faqForgotPasswordQuestion =>
      'I forgot my password, what should I do?';

  @override
  String get faqForgotPasswordAnswer =>
      'On the login screen, tap \"Forgot password\". Enter your registered email, the system will send a 6-digit OTP code via email. Enter the OTP to verify, then create a new password.';

  @override
  String get faqChangePasswordQuestion => 'How to change password?';

  @override
  String get faqChangePasswordAnswer =>
      'Go to Settings > Account Security, enter your current password, then enter and confirm your new password. The new password must have at least 8 characters, including uppercase, lowercase letters and numbers.';

  @override
  String get faqAddMemberQuestion => 'How to add a new member?';

  @override
  String get faqAddMemberAnswer =>
      'Go to Dashboard > Member Management, tap \"Add Member\". Fill in the required information: full name, gender, date of birth, place of birth, generation, branch, parents (if any). You can add optional details like date of death, marital status, phone number, notes. Tap \"Save\" to finish.';

  @override
  String get faqAddBranchQuestion => 'How to add a new branch?';

  @override
  String get faqAddBranchAnswer =>
      'Go to Dashboard > Branch Management, tap \"Add Branch\". Enter the branch name, description, and founder information (if any). After creating, you can assign a Branch Admin to manage that branch.';

  @override
  String get faqEditMemberQuestion => 'How to edit member information?';

  @override
  String get faqEditMemberAnswer =>
      'Go to Dashboard > Member Management, select the member to edit. Tap the edit icon (pen) to update information. Note: only Editors and higher roles can edit.';

  @override
  String get faqDeleteMemberQuestion => 'How to delete a member?';

  @override
  String get faqDeleteMemberAnswer =>
      'Select the member from the list, tap the delete icon (trash). A confirmation dialog will appear. Note: only Clan Leaders and Branch Admins can delete members. Editors cannot delete.';

  @override
  String get faqImportGenealogyQuestion =>
      'Can I import genealogy from a file?';

  @override
  String get faqImportGenealogyAnswer =>
      'The app currently supports adding members manually. Bulk import from file is under development.';

  @override
  String get faqInviteCodeQuestion => 'How does the clan invite code work?';

  @override
  String get faqInviteCodeAnswer =>
      'Each Clan has a unique Invite Code generated by the system. The Clan Leader can view, copy, or share the Invite Code via QR code in the Dashboard. New members enter this code when registering or in \"Join Family\" to send a join request. The Clan Leader or Branch Admin will approve before the member can access.';

  @override
  String get faqRolesQuestion => 'What are the roles in the Clan?';

  @override
  String get faqRolesAnswer =>
      'The system has 4 role levels:\n• Clan Leader — Highest authority, manages the entire Clan, assigns roles, and dissolves.\n• Branch Admin — Manages one or more branches, approves join requests.\n• Editor — Adds and edits member information, cannot delete.\n• Member — Views genealogy information, cannot edit.';

  @override
  String get faqAssignRoleQuestion => 'How to assign roles to members?';

  @override
  String get faqAssignRoleAnswer =>
      'Go to Settings > Member Roles (only visible to Clan Leader). Select the member whose role you want to change and choose the appropriate permission level. The Clan Leader cannot self-demote — use the Transfer Clan Leadership feature.';

  @override
  String get faqTransferOwnershipQuestion => 'How to transfer Clan Leadership?';

  @override
  String get faqTransferOwnershipAnswer =>
      'Go to Settings > Transfer Clan Leadership. Select a member with an activated account from the list. Confirm the transfer — this action cannot be undone. After transfer, you become a Member and the recipient becomes the new Clan Leader.';

  @override
  String get faqDissolveClanQuestion => 'How to dissolve a clan?';

  @override
  String get faqDissolveClanAnswer =>
      'Go to Settings > Dissolve Clan (Clan Leader only). Type the exact Clan name to confirm. All data including members, branches, genealogy, and family fund will be permanently deleted from the system and cannot be recovered. Consider carefully before proceeding.';

  @override
  String get faqDataSecurityQuestion => 'Is my genealogy data secure?';

  @override
  String get faqDataSecurityAnswer =>
      'Yes. All data is stored on servers in Vietnam, using TLS 1.3 encryption for transmission and AES-256 encryption for storage. We strictly comply with Decree 13/2023/NĐ-CP on personal data protection and commit not to sell or share data with third parties.';

  @override
  String get faqDeleteAccountQuestion => 'How to delete my account?';

  @override
  String get faqDeleteAccountAnswer =>
      'Go to Settings > Account Security, select \"Delete Account\". Confirm the deletion request. Your personal data will be deleted from the system within 30 days. Note: if you are Clan Leader, you need to transfer Clan Leadership or dissolve the Clan before deleting your account.';

  @override
  String get faqMultiDeviceQuestion => 'Can I use the app on multiple devices?';

  @override
  String get faqMultiDeviceAnswer =>
      'Yes. Your account can log in on multiple devices simultaneously. Data will be synced in real-time. However, for security reasons, you should log out from unused devices.';

  @override
  String get faqEnglishSupportQuestion => 'Does the app support English?';

  @override
  String get faqEnglishSupportAnswer =>
      'Yes. Go to Settings > Language, switch between Vietnamese and English. The interface will update immediately. Genealogy data and member information remain intact.';

  @override
  String get aboutUsTitle => 'About Us';

  @override
  String get aboutUsTagline =>
      'Gia Tộc Việt helps you preserve your family genealogy on a digital platform, connecting generations no matter where they are. From ancestors to today\'s descendants — all at your fingertips.';

  @override
  String get versionLabel => 'Version';

  @override
  String get developerLabel => 'Developer';

  @override
  String get contactEmailLabel => 'Email';

  @override
  String get adminDashboardTitle => 'Control Panel';

  @override
  String get roleOwner => 'Clan Leader';

  @override
  String get roleBranchAdmin => 'Branch Leader';

  @override
  String get roleEditor => 'Editor';

  @override
  String get roleViewer => 'Member';

  @override
  String get memberListTitle => 'Member List';

  @override
  String get branchListTitle => 'Branch List';

  @override
  String get pendingRequestTitle => 'Pending Requests';

  @override
  String get searchMembersHint => 'Search members...';

  @override
  String get searchBranchesHint => 'Search branches...';

  @override
  String get emptyMembers => 'No matching members found';

  @override
  String get emptyBranches => 'No matching branches found';

  @override
  String get emptyPendingRequests => 'No pending join requests';

  @override
  String get addMemberLabel => 'Add member';

  @override
  String get addBranchLabel => 'Add branch';

  @override
  String get statMembers => 'Members';

  @override
  String get statBranches => 'Branches';

  @override
  String get statPending => 'Pending';

  @override
  String get inviteCodeSectionLabel => 'Family Invite Code';

  @override
  String inviteCodeCopied(Object code) {
    return 'Copied invite code: $code';
  }

  @override
  String get copyCodeTooltip => 'Copy code';

  @override
  String get qrCodeTooltip => 'QR Code';

  @override
  String get qrDialogTitle => 'Family QR Code';

  @override
  String get qrSaved => 'QR saved to gallery!';

  @override
  String get qrSaveError =>
      'Cannot save image. Please grant gallery permission.';

  @override
  String get downloadLabel => 'Download';

  @override
  String get shareLabel => 'Share';

  @override
  String get viewAllLabel => 'View all';

  @override
  String get addNewLabel => 'Add new';

  @override
  String get aliveLabel => 'Alive';

  @override
  String get deceasedLabel => 'Deceased';

  @override
  String generationBadge(Object gen) {
    return 'Generation $gen';
  }

  @override
  String branchBadge(Object name) {
    return 'Branch: $name';
  }

  @override
  String get editLabel => 'Edit';

  @override
  String get deleteLabel => 'Delete';

  @override
  String memberCountBadge(Object count) {
    return '$count members';
  }

  @override
  String founderBadge(Object name) {
    return 'Founder: $name';
  }

  @override
  String founderFormat(Object name) {
    return 'Founder: $name';
  }

  @override
  String get anonymousUser => 'Anonymous user';

  @override
  String get noEmail => 'No email';

  @override
  String get approveButton => 'Approve';

  @override
  String get rejectButton => 'Reject';

  @override
  String get approveSuccess => 'Request approved successfully!';

  @override
  String get rejectSuccess => 'Request rejected successfully!';

  @override
  String get deleteMemberSuccess => 'Member deleted successfully!';

  @override
  String get saveMemberSuccess => 'Member info saved successfully!';

  @override
  String get deleteBranchSuccess => 'Branch deleted successfully!';

  @override
  String get saveBranchSuccess => 'Branch info saved successfully!';

  @override
  String get deleteMemberTitle => 'Confirm Deletion';

  @override
  String deleteMemberMessage(Object name) {
    return 'Are you sure you want to delete $name from the family tree?';
  }

  @override
  String get deleteBranchTitle => 'Confirm Branch Deletion';

  @override
  String deleteBranchMessage(Object name) {
    return 'Are you sure you want to delete branch $name? All members will lose their branch connection.';
  }

  @override
  String get saveBranchLabel => 'Save Branch';

  @override
  String get editBranchTitle => 'Edit Branch';

  @override
  String get addBranchTitle => 'Add Branch';

  @override
  String get deleteBranchTooltip => 'Delete branch';

  @override
  String get basicInfoTitle => 'Basic Information';

  @override
  String get branchNameLabel => 'Branch name';

  @override
  String get branchNameHint => 'E.g: Main Branch, Second Branch...';

  @override
  String get branchNameRequired => 'Branch name';

  @override
  String get branchNameEmptyError => 'Cannot be empty';

  @override
  String get founderNameLabel => 'Founder name';

  @override
  String get addMemberPlaceholder => '✦ Add new member...';

  @override
  String get noSelectionLabel => 'None';

  @override
  String get manualInputLabel => 'Founder name (Manual)';

  @override
  String get founderNameHint => 'Branch founder (optional)';

  @override
  String get inputModeLabel => 'Enter manually';

  @override
  String get selectModeLabel => 'Select from list';

  @override
  String get foundationYearLabel => 'Foundation year';

  @override
  String get foundationYearHint => 'E.g: 1980';

  @override
  String get locationLabel => 'Location';

  @override
  String get locationHint => 'E.g: Village X, District Y';

  @override
  String get branchDescLabel => 'Branch description';

  @override
  String get branchDescHint => 'Enter additional detailed description...';

  @override
  String get deleteBranchConfirmTitle => 'Confirm Deletion';

  @override
  String deleteBranchConfirmMessage(Object name) {
    return 'Are you sure you want to delete branch $name?';
  }

  @override
  String get editMemberTitle => 'Edit Member';

  @override
  String get addMemberTitle => 'Add Member';

  @override
  String get linkAccountSuccess => 'Profile created and linked successfully!';

  @override
  String linkAccountError(Object msg) {
    return 'Profile created but failed to link account: $msg';
  }

  @override
  String get nameHint => 'Enter full name';

  @override
  String get maritalStatusLabel => 'Marital Status';

  @override
  String get maritalSingle => 'Single';

  @override
  String get maritalMarried => 'Married';

  @override
  String get maritalDivorced => 'Divorced';

  @override
  String get maritalWidowed => 'Widowed';

  @override
  String get maritalUnknown => 'Unknown';

  @override
  String get genderLabel => 'Gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderUnknown => 'Unknown';

  @override
  String get dobLabel => 'Date of birth';

  @override
  String get dobHint => 'dd/mm/yyyy';

  @override
  String get statusLabel => 'Status';

  @override
  String get dodLabel => 'Date of death';

  @override
  String get dodHint => 'dd/mm/yyyy';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get phoneHint => '0xxxxxxxxx';

  @override
  String get addressLabel => 'Hometown / Address';

  @override
  String get addressHint => 'Enter hometown, address info...';

  @override
  String get parentLabel => 'Parent';

  @override
  String get spouseLabel => 'Spouse';

  @override
  String get branchSectionLabel => 'Branch';

  @override
  String get noBranchLabel => 'No branch';

  @override
  String parentBranchMarker(Object name) {
    return '$name ✦ (Parent\'s branch)';
  }

  @override
  String get bioLabel => 'Biography';

  @override
  String get bioHint =>
      'Enter profession, education, or important milestones...';

  @override
  String get uploadPhotoLabel => 'Upload Photo';

  @override
  String get generationFieldLabel => 'Generation';

  @override
  String get generationFieldHint => 'E.g: 3';

  @override
  String familyNameFormat(Object name) {
    return '$name Family';
  }

  @override
  String get notOnTreeLabel => 'My name is not on the family tree';

  @override
  String get notLoggedIn => 'User not logged in';

  @override
  String get sessionTokenError => 'Could not get session token';

  @override
  String get passwordChangeFailed => 'Password change failed';

  @override
  String get serverConnectionError => 'Server connection error';

  @override
  String get emailSubjectHelp => 'Gia Toc Viet Support';

  @override
  String get accountSectionTitle => 'Account';

  @override
  String get allLabel => 'All';

  @override
  String get biographySectionTitle => 'Biography & Notes';

  @override
  String branchCountLabel(int count) {
    return '$count Branches';
  }

  @override
  String get branchLabel => 'Branch';

  @override
  String get branchTabLabel => 'Branches';

  @override
  String get congratulateActionMessage => 'You sent congratulations.';

  @override
  String congratulateButton(int count) {
    return 'Congratulate ($count)';
  }

  @override
  String currentDateDisplay(int day, int month, int year) {
    return 'Date $day/$month/$year (Lunar 12/05)';
  }

  @override
  String get dateOfBirthLabel => 'Date of Birth';

  @override
  String get dateOfDeathLabel => 'Date of Death';

  @override
  String get donateButton => 'Donate';

  @override
  String eventCountdown(int days) {
    return '$days days left';
  }

  @override
  String get eventDateSample1 => '12/05 Lunar';

  @override
  String get eventDateSample2 => '28/06 Solar';

  @override
  String eventDateLabel(String date) {
    return 'Date $date';
  }

  @override
  String eventDetailFormat(int gen, String date) {
    return 'Generation $gen • Date $date';
  }

  @override
  String get eventSample1 => 'Ancestor Huynh Cong Minh Anniversary';

  @override
  String get eventSample2 => 'Spring Family Gathering 2026';

  @override
  String get eventTypeAncestors => 'Ancestors';

  @override
  String get eventTypeEvent => 'Event';

  @override
  String get eventsSectionTitle => 'Events & Anniversaries';

  @override
  String get familyFundTitle => 'Family Fund';

  @override
  String get familyRelationSectionTitle => 'Family Relations';

  @override
  String get familyTreeMapTitle => 'Family Tree Map';

  @override
  String familyTreeNameFormat(String name) {
    return '$name Family Tree';
  }

  @override
  String get familyTreeTitle => 'Family Tree';

  @override
  String get guideButton => 'Guide';

  @override
  String get guideDrag => '👉 Drag the diagram to move around';

  @override
  String get guideTapMember => '👤 Tap a member to see details';

  @override
  String get guideZoom => '🔍 Pinch to zoom in/out';

  @override
  String get incenseActionMessage => 'You lit a stick of incense.';

  @override
  String incenseButton(int count) {
    return 'Incense ($count)';
  }

  @override
  String get knownLabel => 'Known';

  @override
  String get logoutConfirmMessage =>
      'Are you sure you want to log out of the app?';

  @override
  String get logoutLabel => 'Logout';

  @override
  String memberIdFormat(int id) {
    return 'Member #$id';
  }

  @override
  String get memberTabLabel => 'Members';

  @override
  String get noBiographyMessage => 'No biography information for this member.';

  @override
  String get noTreeDataMessage => 'No genealogy data available';

  @override
  String get notificationLabel => 'Notifications';

  @override
  String get personalInfoLabel => 'Personal Information';

  @override
  String get personalInfoSectionTitle => 'Personal Information';

  @override
  String get placeOfBirthLabel => 'Place of Birth';

  @override
  String get searchMemberYearHint => 'Search member, year of birth...';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get spiritualMotto => 'Spiritual Roots • Eternal Legacy';

  @override
  String get switchToAdminLabel => 'Switch to Admin Page';

  @override
  String get todayLabel => 'Today';

  @override
  String get unassignedBranch => 'Unassigned branch';

  @override
  String get understoodLabel => 'Got it';

  @override
  String get unknownGeneration => 'Unknown generation';

  @override
  String get unknownLabel => 'Unknown';

  @override
  String get usageGuideTitle => 'Usage Guide';
}
