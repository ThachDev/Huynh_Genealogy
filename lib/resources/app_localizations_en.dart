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
  String pendingApprovalMessage(String clanLeaderName, String clanLeaderPhone) {
    return 'Your request to join the family has been sent successfully. Please wait for admin approval or contact Clan Leader $clanLeaderName - $clanLeaderPhone to approve.';
  }

  @override
  String get pendingApprovalMessageSimple =>
      'Your request to join the family has been sent successfully. Please wait for admin approval.';

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
  String get navEvents => 'Events';

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
  String get notificationsSectionTitle => 'Notifications';

  @override
  String get notifyEventLabel => 'New events';

  @override
  String get notifyAnnouncementLabel => 'Family announcements';

  @override
  String get notifyWishLabel => 'Wishes';

  @override
  String get notifyAnniversaryLabel => 'Anniversaries & birthdays';

  @override
  String get infoAndHelpSection => 'Information & Help';

  @override
  String get helpAndInfoHubLabel => 'Help & Information';

  @override
  String get tabFaqLabel => 'FAQ & Guide';

  @override
  String get tabRegulationsLabel => 'Regulations';

  @override
  String get tabAboutLabel => 'About Us';

  @override
  String get regulationsLabel => 'Terms & Legal Regulations';

  @override
  String get helpCenterLabel => 'Help Center';

  @override
  String get aboutUsLabel => 'About Us';

  @override
  String get advancedAdminSection => 'Advanced Management';

  @override
  String get linkAndRolesTitle => 'Link Accounts & Roles';

  @override
  String get tabLinkAccounts => 'Link Accounts';

  @override
  String get tabMemberRoles => 'Roles';

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
  String get noSearchResultsMessage => 'No matching results found.';

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
  String get regulationsTitle => 'Terms & Legal Regulations';

  @override
  String get regulationTitle => 'Gia Tộc Việt Terms of Service';

  @override
  String get regulationLastUpdated => 'Effective Version: August 2026';

  @override
  String get regSection1Title => 'Acceptance of Terms & Legal Basis';

  @override
  String get regSection1Content =>
      '• By registering, installing, or using the Gia Tộc Việt application, you confirm that you have read, understood, and unconditionally agreed to be bound by these Terms.\n• The service is operated in strict compliance with the applicable laws of the S.R. of Vietnam, including the Law on Electronic Transactions, Law on Cyberinformation Security, Law on Cybersecurity, and Decree 13/2023/ND-CP on Personal Data Protection.\n• If you do not agree with any part of these Terms, please discontinue using the application immediately.';

  @override
  String get regSection2Title => 'Definitions & Identifications';

  @override
  String get regSection2Content =>
      '**Application / Developer:** The Gia Tộc Việt software and related technology infrastructure, provided as an intermediary technical tool.\n**User:** Any individual creating an account to access the service.\n**Data Subject:** Individuals whose information is recorded in the family tree (living or deceased).\n**Clan (Lineage):** A private workspace comprising family trees, historical archives, and clan activities initiated by the Clan Leader.\n**Genealogy Data:** Names, dates of birth/death, generations, hometowns, and documents contributed by members.';

  @override
  String get regSection3Title => 'Account Regulations & Eligibility';

  @override
  String get regSection3Content =>
      '• **Age Requirement:** Users must be at least 18 years old or possess legal guardian consent.\n• **Credential Security:** You are solely responsible for safeguarding your password, OTP codes, and devices. Any action performed through your account is legally deemed your own.\n• **Truthfulness:** You agree to provide accurate contact information and bear sole personal liability regarding your authorization to represent a clan when creating a family workspace.';

  @override
  String get regSection4Title => 'Role Hierarchy & Administrative Duties';

  @override
  String get regSection4Content =>
      '**Member (Viewer):** Permitted to view genealogy, lineage events, and manage their own personal profile.\n**Editor:** Permitted to add and edit member records as authorized by the clan consensus.\n**Branch Leader:** Administers the branch subtree and approves join requests for their assigned branch.\n**Clan Leader:** Supreme administrator of the clan space, bearing legal and ethical responsibility for role delegation, ownership transfers, or clan dissolution/deletion decisions.';

  @override
  String get regSection5Title => 'Intellectual Property & Data Rights';

  @override
  String get regSection5Content =>
      '• **Software Ownership:** All source code, interfaces, designs, trademarks, and app copyrights remain the exclusive property of the Developer.\n• **Genealogy Data Ownership:** All genealogical records, photos, and materials uploaded by Users belong to the respective clan. Users grant the platform a limited technical license to store, back up, and display data solely for the clan\'s private use.';

  @override
  String get regSection6Title =>
      'Personal Data Protection (Decree 13/2023/ND-CP)';

  @override
  String get regSection6Content =>
      '• **Lawful Collection:** Users uploading personal records of others must ensure prior consent from the individual (or legal guardians/next of kin as prescribed by law).\n• **Privacy Safeguards:** Genealogy data is strictly private by default and visible only to approved clan members.\n• **No Commercialization:** We strictly do not sell, share, or monetize family data or personal records to third parties for advertising or commercial gains.\n• **Data Security:** Data is protected using modern encryption standards on secure data servers located in Vietnam.';

  @override
  String get regSection7Title => 'Strictly Prohibited Conduct';

  @override
  String get regSection7Content =>
      '• Uploading content that violates national security, distorts national history, or insults cultural/religious figures.\n• Illegally collecting or disseminating private personal data, sensitive details to defame, blackmail, or slander others.\n• Interfering technically, attacking, exploiting vulnerabilities, or reverse-engineering app source code and data structures.\n• Utilizing the app for fraud, unauthorized fundraising, or illegal commercial activities.';

  @override
  String get regSection8Title => 'Disclaimer & Limitation of Liability';

  @override
  String get regSection8Content =>
      '• **Intermediary Platform:** The app serves solely as a technical tool and digital storage facility. We are NOT legally liable for the authenticity of records, inheritance disputes, internal clan conflicts, or inaccurate user-submitted data.\n• **Administrator Actions:** We are fully exempt from liability for data modifications or deletions executed directly by Clan Leaders/Branch Admins (including role transfers, accidental removals, or clan dissolution).\n• **Force Majeure:** No liability shall arise from force majeure events beyond reasonable control (natural disasters, national telecom disruptions, cyber attacks).';

  @override
  String get regSection9Title => 'Violation Reporting & Sanctions';

  @override
  String get regSection9Content =>
      '• **Content Reporting:** Users have the right to report misleading, inappropriate, or infringing content via the built-in \'Report Violation\' feature.\n• **Enforcement:** The system reserves full authority to issue warnings, temporarily suspend, take down infringing content, or permanently terminate violating accounts without refund.\n• **Legal Cooperation:** Upon formal written requests from competent law enforcement agencies or courts, we are obligated to provide audit logs and relevant records for investigations in accordance with Vietnamese law.';

  @override
  String get regSection10Title => 'Dispute Resolution & Governing Law';

  @override
  String get regSection10Content =>
      '• These Terms are exclusively governed by and construed under the laws of the S.R. of Vietnam.\n• Any disputes between Users and the Developer shall first be resolved through good-faith negotiation and mediation.\n• If a dispute cannot be resolved within sixty (60) days through mediation, it shall be submitted to the competent People\'s Court in Vietnam.';

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
  String get genealogyMemberSection => 'Genealogy & Connections';

  @override
  String get clanAndRolesSection => 'Roles & Clan Management';

  @override
  String get techSecuritySection => 'Data Security & Account';

  @override
  String get faqAddMemberQuestion =>
      'How do I add descendants or spouses to the tree?';

  @override
  String get faqAddMemberAnswer =>
      '• **Quick action on Tree Map:** Tap any member and tap \"Add Child\" or \"Add Spouse\".\n• **Detailed input in Dashboard:** Go to Dashboard > Members tab > tap \"+\". Fill in generation, branch, solar/lunar dates, and bio.';

  @override
  String get faqAddBranchQuestion =>
      'How do I create branches and appoint Branch Leaders?';

  @override
  String get faqAddBranchAnswer =>
      '1. Go to Dashboard > Branches tab, tap \"+\" to create a branch (branch name, founder, foundation year, location).\n2. Go to Settings > Member Roles to appoint a Branch Leader to manage that specific branch.';

  @override
  String get faqEditMemberQuestion =>
      'How do I link accounts for relatives to view the family tree?';

  @override
  String get faqEditMemberAnswer =>
      'Go to Settings > Link Accounts > enter your relative\'s Email. The system will automatically link their account to their profile on the tree so they can log in and view the genealogy.';

  @override
  String get faqDeleteMemberQuestion =>
      'How are descendants handled when a member is deleted?';

  @override
  String get faqDeleteMemberAnswer =>
      'The system offers 2 smart mechanisms:\n• **Promote children (Recommended):** Automatically connects children to the generation above so the lineage is not broken.\n• **Detach branch:** Separates descendants into an independent subtree.';

  @override
  String get faqInviteCodeQuestion =>
      'How do I get the Invite Code and share QR Codes?';

  @override
  String get faqInviteCodeAnswer =>
      'In the Dashboard, tap on the \"Family Code\" card to copy the 6-character code or download high-resolution QR code images to share with family members.';

  @override
  String get faqRolesQuestion =>
      'What are the permissions for the 4 role tiers?';

  @override
  String get faqRolesAnswer =>
      '• **Clan Leader (Owner):** Supreme authority — full clan management, role delegation, ownership transfers, and clan dissolution.\n• **Branch Leader (Branch Admin):** Manages records and approves members in their assigned branch.\n• **Editor:** Adds and updates member profiles (cannot delete the lineage).\n• **Member (Viewer):** Views family tree, events, sends wishes, and lights online incense.';

  @override
  String get faqTransferOwnershipQuestion =>
      'Important notes on Transferring Leadership or Dissolving Clan?';

  @override
  String get faqTransferOwnershipAnswer =>
      '• **Transfer Leadership:** Effective immediately, the recipient becomes the new Clan Leader and you become a Member.\n• **Dissolve Clan:** Permanently deletes all family trees, generation history, and photos from the server with NO RECOVERY possible.';

  @override
  String get faqDataSecurityQuestion =>
      'How is genealogy data secured (Decree 13/2023/ND-CP)?';

  @override
  String get faqDataSecurityAnswer =>
      'Genealogy data is hosted on secure data servers in Vietnam with 256-bit SSL/TLS encryption, strictly visible only to approved clan members. We never commercialize your data.';

  @override
  String get aboutUsTitle => 'About Us';

  @override
  String get aboutUsTagline =>
      'Gia Tộc Việt helps you preserve your family genealogy on a digital platform, connecting generations no matter where they are.';

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
  String get educationLabel => 'Education';

  @override
  String get educationHint => 'Enter education level...';

  @override
  String get occupationLabel => 'Occupation';

  @override
  String get occupationHint => 'Enter occupation...';

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
  String get seeMoreLabel => 'See more';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get spiritualMotto => 'Spiritual Roots • Eternal Legacy';

  @override
  String get switchToAdminLabel => 'Switch to Admin Page';

  @override
  String get todayLabel => 'Today';

  @override
  String get wishDialogTitle => 'Send a Wish';

  @override
  String get wishDialogHint => 'Type your wish...';

  @override
  String get wishSendButton => 'Send';

  @override
  String get wishSentMessage => 'Your wish has been sent.';

  @override
  String get anniversaryDialogTitle => 'Send a Memorial Message';

  @override
  String get anniversaryDialogHint => 'Write a remembrance...';

  @override
  String get anniversarySentMessage => 'Your memorial message has been sent.';

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

  @override
  String get eventsListTitle => 'Clan Events';

  @override
  String get noEventsMessage => 'No events have been created yet';

  @override
  String get errorOccurred => 'An error occurred. Please try again.';

  @override
  String get lunarCalendar => 'Lunar';

  @override
  String get deleteEventTitle => 'Delete Event';

  @override
  String deleteEventConfirm(String title) {
    return 'Are you sure you want to delete the event \"$title\"?';
  }

  @override
  String get addEventTitle => 'Add Event';

  @override
  String get editEventTitle => 'Edit Event';

  @override
  String get selectEventDateError => 'Please select the event date';

  @override
  String get eventNameLabel => 'Event Name';

  @override
  String get eventNameHint => 'e.g. Ancestor\'s Death Anniversary...';

  @override
  String get eventNameRequired => 'Please enter the event name';

  @override
  String get eventNameMinLength => 'Event name must be at least 2 characters';

  @override
  String get eventDateFormLabel => 'Event Date';

  @override
  String get selectDateHint => 'Select date...';

  @override
  String get selectDateRequired => 'Please select the date';

  @override
  String get useLunarCalendar => 'Use Lunar Calendar';

  @override
  String get eventDescriptionLabel => 'Detailed Description';

  @override
  String get eventDescriptionHint =>
      'Enter description of the event (location, content)...';

  @override
  String get saveEventButton => 'Save Event';

  @override
  String get educationPrimary => 'Primary School';

  @override
  String get educationSecondary => 'Secondary School';

  @override
  String get educationHighSchool => 'High School';

  @override
  String get educationUniversity => 'University';

  @override
  String get educationPostgraduate => 'Postgraduate';

  @override
  String get otherLabel => 'Other';

  @override
  String get inputOtherEducationLabel => 'Enter other education';

  @override
  String get memberDetailTitle => 'Member Details';

  @override
  String get fatherLabel => 'Father';

  @override
  String get motherLabel => 'Mother';

  @override
  String get addChildTooltip => 'Add Child';

  @override
  String get addSpouseTooltip => 'Add Spouse';

  @override
  String get eventTypeArticle => 'News';

  @override
  String get eventTypeAnnouncement => 'Announcement';

  @override
  String get eventTypeAnniversary => 'Anniversary / Commemoration';

  @override
  String get selectPostType => 'Select post type';

  @override
  String get eventTitleHintArticle => 'Article title...';

  @override
  String get eventTitleHint => 'Event name...';

  @override
  String get eventTitleRequiredArticle => 'Please enter title';

  @override
  String get eventTitleRequired => 'Please enter event name';

  @override
  String get eventAddDescription => 'Add description...';

  @override
  String get eventSelectDate => 'Select event date';

  @override
  String get eventAddLocation => 'Add location';

  @override
  String get eventAddOrganizer => 'Organizer';

  @override
  String get eventAddAuthor => 'Add author';

  @override
  String get eventLocationLabel => 'Location';

  @override
  String get eventLocationHint => 'Enter location...';

  @override
  String get eventOrganizerLabel => 'Organizer';

  @override
  String get eventOrganizerHint => 'Name of person ...';

  @override
  String get eventAuthorLabel => 'Author';

  @override
  String get eventAuthorHint => 'Author name...';

  @override
  String get eventPickPhoto => 'Pick photo';

  @override
  String get eventChangePhoto => 'Pick photo';

  @override
  String get doneLabel => 'Done';

  @override
  String get eventDetailTitle => 'Event Detail';

  @override
  String get deathAnniversariesSectionTitle => 'CLAN DEATH ANNIVERSARIES';

  @override
  String get birthdaysSectionTitle => 'CLAN BIRTHDAYS';

  @override
  String get noBirthdaysMessage => 'No upcoming birthdays';

  @override
  String get noDeathAnniversariesMessage => 'No upcoming death anniversaries';

  @override
  String get newsEventsSectionTitle => 'EVENTS & NEWS';

  @override
  String generationLabel(int gen) {
    return 'Generation $gen';
  }

  @override
  String get spouseInfoLabel => 'Spouse Information';

  @override
  String get parentInfoLabel => 'Parent Information';

  @override
  String get hasInTreeLabel => 'In tree';

  @override
  String get notInTreeLabel => 'Not in tree';

  @override
  String get selectSpouseLabel => 'Select Spouse';

  @override
  String get searchSpouseHint => 'Search spouse name...';

  @override
  String get inputSpouseNameLabel => 'Enter Spouse Name';

  @override
  String get inputSpouseNameHint => 'E.g., Married to Ms. Nguyen...';

  @override
  String get selectParentLabel => 'Select Parent';

  @override
  String get searchParentHint => 'Search parent name...';

  @override
  String get inputParentNameLabel => 'Enter Parent Name';

  @override
  String get inputParentNameHint => 'E.g., Child of Mr. Nguyen...';

  @override
  String get changeInviteCodeButton => 'Change code';

  @override
  String get saveEventSuccess => 'Event saved successfully';

  @override
  String get deleteEventSuccess => 'Event deleted successfully';

  @override
  String get transferOwnershipError => 'Unable to transfer clan leadership';

  @override
  String get roleUpdateFailed => 'Failed to update role';

  @override
  String get updateProfileSuccess => 'Profile updated successfully';

  @override
  String get approveFailed => 'Approval failed';

  @override
  String get rejectFailed => 'Rejection failed';

  @override
  String get dissolveClanError => 'Unable to dissolve the clan';

  @override
  String familyTreeLoadError(Object error) {
    return 'Error loading data: $error';
  }

  @override
  String get eventTypeEventArticle => 'Event / Article';

  @override
  String get eventImageFormatHint => 'JPG, PNG format (Max 5MB)';

  @override
  String get eventTimeLocationSection => 'Time & Location';

  @override
  String get eventPublishDateLabel => 'Publish date';

  @override
  String get eventCreateTitle => 'Create clan announcement';

  @override
  String get eventTitleLabelAnnouncement => 'Announcement title';

  @override
  String get eventTitleLabelEventArticle => 'Event / Article name';

  @override
  String get eventTitleHintAnnouncement =>
      'Enter a short announcement title...';

  @override
  String get eventTitleRequiredAnnouncement =>
      'Please enter announcement title';

  @override
  String get eventOrganizerLabelFull => 'Organizer / Host';

  @override
  String get eventOrganizerHintFull =>
      'Enter host name or organizing committee...';

  @override
  String get eventContentLabelAnnouncement => 'Announcement content';

  @override
  String get eventContentLabelEventArticle => 'Content & Schedule';

  @override
  String get eventContentHintAnnouncement =>
      'Enter detailed announcement content sent to the clan...';

  @override
  String get eventContentHintEventArticle =>
      'Enter detailed article content and event schedule...';

  @override
  String get eventContentRequiredAnnouncement =>
      'Please enter announcement content';

  @override
  String get eventSearchHint => 'Search events, announcements...';

  @override
  String get eventNoResults => 'No matching information found';

  @override
  String get clanEventsSection => 'CLAN EVENTS';

  @override
  String get clanAnnouncementsSection => 'CLAN ANNOUNCEMENTS';

  @override
  String get eventDiscardChangesTitle => 'Discard changes?';

  @override
  String get eventDiscardChangesMessage => 'Unsaved changes will be lost.';

  @override
  String get eventDiscardChangesAction => 'Discard changes';

  @override
  String get eventByAuthor => 'By ';

  @override
  String get adminBoard => 'Management Board';

  @override
  String get eventEnded => 'Ended';

  @override
  String get eventOngoing => 'Ongoing';

  @override
  String get eventUpcoming => 'Upcoming';

  @override
  String get lunarShortLabel => 'LUNAR';

  @override
  String monthLabelFormat(Object month) {
    return 'Month $month';
  }

  @override
  String lunarMonthLabelFormat(Object leap, Object month) {
    return 'Month $month$leap';
  }

  @override
  String get leapMonthInline => ' (leap month)';

  @override
  String get addMemberFabLabel => 'Member +';

  @override
  String get addBranchFabLabel => 'Branch +';

  @override
  String get selectUnlinkedMemberTitle => 'Select Unlinked Member';

  @override
  String get selectUnlinkedMemberSubtitle =>
      'Select a member to view info and link to the family tree';

  @override
  String get deleteMemberConfirmStart =>
      'Are you sure you want to delete member ';

  @override
  String get deleteMemberConfirmEnd => ' from the family tree?';

  @override
  String get deleteMemberTitlePrefix => 'Delete member ';

  @override
  String get deleteMemberWithDescendantsMessage =>
      'This member has descendants continuing the family tree. Please choose how to handle the generation links:';

  @override
  String get promoteChildrenOption => 'Promote children';

  @override
  String get recommendedLabel => 'Recommended';

  @override
  String get promoteChildrenDesc =>
      'Automatically link children to the previous generation so the tree is not broken.';

  @override
  String get deleteAndDetachOption => 'Delete & Detach branch';

  @override
  String get deleteAndDetachDesc =>
      'Descendants will be detached into orphan branches (losing the link to the father\'s generation).';

  @override
  String get accountSection => 'Account';

  @override
  String get userIdLabel => 'User ID';

  @override
  String get registeredRoleLabel => 'Registered role';

  @override
  String get statusDisplayLabel => 'Status';

  @override
  String get registeredMemberInfoLabel => 'Registered member info';

  @override
  String get hometownLabel => 'Hometown';

  @override
  String get maritalStatusShortLabel => 'Marital status';

  @override
  String get notesLabel => 'Notes';

  @override
  String get memberFallbackName => 'member';

  @override
  String get createRelativeTitle => 'Create relative on the tree?';

  @override
  String createRelativeSuggestedMessage(Object suggestedName, Object userName) {
    return 'Member $userName recorded relative information: \"$suggestedName\". Do you want to quickly create this relative to branch the family tree?';
  }

  @override
  String createRelativeFallbackMessage(Object notes, Object userName) {
    return 'Registration note: \"$notes\". Do you want to go to the new member creation page to place $userName?';
  }

  @override
  String get laterAction => 'Later';

  @override
  String get createRelativeNowAction => 'Create relative now';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusApproved => 'Approved';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get unknownShortLabel => 'Unknown';

  @override
  String get maritalDivorcedStatus => 'Divorced';

  @override
  String get maritalWidowedShort => 'Widowed';

  @override
  String get selectExistingMemberTitle => 'Select Existing Member';

  @override
  String get searchMemberByNameHint => 'Search by member name...';

  @override
  String get noMatchingMember => 'No matching member found';

  @override
  String get noUnlinkedMembers => 'No unlinked members';

  @override
  String birthDateFormat(Object date) {
    return 'Date of birth: $date';
  }

  @override
  String get selectLabel => 'Select';

  @override
  String memberAccessibilityFormat(Object gender, Object name) {
    return 'Member $name, Gender: $gender';
  }

  @override
  String get meLabel => 'Me';

  @override
  String get addMemberChooseMethodDesc =>
      'Choose how to add a member to the clan';

  @override
  String get linkUnlinkedMemberLabel => 'Link a member not yet on the tree';

  @override
  String get createNewMemberLabel => 'Create new member';

  @override
  String get createNewMemberDesc =>
      'Enter complete information for the new member';

  @override
  String addChildForFormat(Object name) {
    return 'Add Child for $name';
  }

  @override
  String get selectChildMemberTitle => 'Select Member as Child';

  @override
  String linkAsChildFormat(Object name) {
    return 'Link member as child of $name';
  }

  @override
  String get confirmConnectionLabel => 'Confirm connection';

  @override
  String confirmLinkChildMessage(Object childName, Object parentName) {
    return 'Are you sure you want to link member \"$childName\" as a child of \"$parentName\"?';
  }

  @override
  String memberConnectedSuccessFormat(Object name) {
    return 'Successfully connected member \"$name\"!';
  }

  @override
  String addSpouseForFormat(Object name) {
    return 'Add Wife / Husband for $name';
  }

  @override
  String get selectSpouseMemberTitle => 'Select Member as Wife / Husband';

  @override
  String linkSpouseFormat(Object name) {
    return 'Link spouse to $name';
  }

  @override
  String confirmLinkSpouseMessage(Object memberName, Object spouseName) {
    return 'Are you sure you want to link spouse between \"$memberName\" and \"$spouseName\"?';
  }

  @override
  String get spouseConnectedSuccess => 'Successfully connected spouse!';

  @override
  String get markAllReadSuccess => 'All notifications marked as read';

  @override
  String get markAllReadAction => 'Read all';

  @override
  String get importantLabel => 'Important';

  @override
  String get noNotificationsMessage => 'No notifications';

  @override
  String notificationDetailTitle(Object title) {
    return 'Notification $title';
  }

  @override
  String get markAsReadAction => 'Mark as read';

  @override
  String get deleteNotificationAction => 'Delete notification';

  @override
  String get wishLoginRequired =>
      'Please wait for your information to load or log in again to send a wish';

  @override
  String get noWishesMessage => 'No wishes yet.';

  @override
  String get beFirstWisher => 'Be the first to send a wish!';

  @override
  String get sendWishButton => 'Send wish';

  @override
  String get sendRemembranceButton => 'Send remembrance';

  @override
  String get memberLabel => 'Member';

  @override
  String get clearBranchFilterLabel => 'Clear branch filter';

  @override
  String get pendingApprovalRequestSent =>
      'Your clan join request has been sent successfully. Please wait for admin approval or contact ';

  @override
  String pendingApprovalLeaderFormat(Object name, Object phone) {
    return 'Clan Leader $name - $phone';
  }

  @override
  String get pendingApprovalWaitEnd => ' to approve.';

  @override
  String get errNameEmpty => 'Name cannot be empty';

  @override
  String get errGoogleSignInCanceled =>
      'Google sign-in was canceled by the user';

  @override
  String get errFirebaseAuth => 'Unable to authenticate with Firebase';

  @override
  String get errFirebaseToken => 'Unable to get Firebase ID Token';

  @override
  String get errServerAuth => 'Server authentication error';

  @override
  String get errFirebaseAuthError => 'Firebase Auth error';

  @override
  String get errServerConnection => 'Server connection error';

  @override
  String errGenericFormat(Object error) {
    return 'Unknown error: $error';
  }

  @override
  String get errLoginFailed => 'Login failed';

  @override
  String get errInvalidCredentials => 'Incorrect email or password.';

  @override
  String get errAccountDisabled => 'Account has been disabled.';

  @override
  String get errEmailInvalidFormat => 'Email address is not in a valid format.';

  @override
  String get errInvalidCredentialsRetry =>
      'Incorrect email or password. Please try again in a few seconds.';

  @override
  String get errRegisterFirebase =>
      'Unable to register an account with Firebase';

  @override
  String get errFirebaseTokenAfterRegister =>
      'Unable to get Firebase ID Token after registration';

  @override
  String get errRegisterServer => 'Error registering the account on the server';

  @override
  String get errFirebaseRegisterError => 'Firebase registration error';

  @override
  String get errEmailAlreadyUsed =>
      'Email address is already used by another account.';

  @override
  String get errPasswordTooWeak => 'Password is too weak.';

  @override
  String get errSendResetEmail => 'Unable to send password reset email';

  @override
  String get errServerGeneric => 'Server error';

  @override
  String get errOtpInvalid => 'Invalid OTP code';

  @override
  String get errResetPasswordFailed => 'Unable to reset password';

  @override
  String get errNoFirebaseSession => 'Firebase sign-in session not found';

  @override
  String get errCacheCredentials => 'Error saving login information';

  @override
  String get errReadCredentials => 'Error reading saved login information';

  @override
  String get errDeleteCredentials => 'Error deleting login information';

  @override
  String get errSavePassword => 'Error saving password';

  @override
  String get errDeleteStoredCredentials =>
      'Error deleting saved login information';

  @override
  String errLoginFormat(Object error) {
    return 'Login error: $error';
  }

  @override
  String errLogoutFormat(Object error) {
    return 'Logout error: $error';
  }

  @override
  String errRegisterFormat(Object error) {
    return 'Registration error: $error';
  }

  @override
  String errSaveInfoFormat(Object error) {
    return 'Error saving information: $error';
  }

  @override
  String errCacheCredentialsFormat(Object error) {
    return 'Error saving login information: $error';
  }

  @override
  String errSendResetEmailFormat(Object error) {
    return 'Error sending password reset email: $error';
  }

  @override
  String errOtpVerifyFormat(Object error) {
    return 'OTP verification error: $error';
  }

  @override
  String errResetPasswordFormat(Object error) {
    return 'Password reset error: $error';
  }

  @override
  String errReloadProfileFormat(Object error) {
    return 'Error reloading user information: $error';
  }

  @override
  String get errInvalidResponseData => 'Invalid response data';

  @override
  String get errInvalidDataFormat =>
      'Returned data is not in the correct format';

  @override
  String get errInvalidListFormat =>
      'Returned list data is not in the correct format';

  @override
  String get errMemberNotFound => 'Member not found';

  @override
  String get errSaveMember => 'Error saving member';

  @override
  String get errDeleteMember => 'Error deleting member';

  @override
  String get errBranchNotFound => 'Branch not found';

  @override
  String get errSaveBranch => 'Error saving branch';

  @override
  String get errDeleteBranch => 'Error deleting branch';

  @override
  String get errCreateFamily => 'Error creating clan';

  @override
  String get errVerifyInviteCode => 'Error verifying invite code';

  @override
  String get errSendJoinRequest => 'Error sending join request';

  @override
  String get errLoadJoinRequest => 'Error loading join request';

  @override
  String get errApproveRequest => 'Error approving request';

  @override
  String get errRejectRequest => 'Error rejecting request';

  @override
  String get errLoadFamilyInfo => 'Error loading clan information';

  @override
  String get errUpdateFamilyInfo => 'Error updating clan information';

  @override
  String get errLoadMemberList => 'Error loading member list';

  @override
  String get errUpdateMemberRole => 'Error updating member role';

  @override
  String get errDeleteFamily => 'Error deleting clan';

  @override
  String get errLinkFamilyProfile => 'Error linking family profile';

  @override
  String get errTransferOwnership => 'Error transferring clan leadership';

  @override
  String eventDetailSemanticLabel(Object date, Object title) {
    return 'Event $title, Date: $date';
  }

  @override
  String get linkAccountsTitle => 'Account & Link Management';

  @override
  String get linkAccountsNodeTitle => 'Link Account';

  @override
  String get linkAccountsLabel => 'Link accounts';

  @override
  String get linkAccountEmailDesc =>
      'Enter the member\'s email. If the email already has an account it will be linked immediately; otherwise the system sends an email invite and auto-links once they register.';

  @override
  String get linkInviteButton => 'Link / Invite';

  @override
  String get changeEmailButton => 'Change email';

  @override
  String get linkButton => 'Link';

  @override
  String get unlinkButton => 'Unlink';

  @override
  String get linkedLabel => 'Linked';

  @override
  String get invitePendingLabel => 'Pending signup';

  @override
  String get notLinkedLabel => 'Not linked';

  @override
  String invitePendingDesc(Object email) {
    return 'Invitation sent to $email. The account will be linked automatically after the member registers.';
  }

  @override
  String linkSuccess(Object email) {
    return 'Account $email linked successfully.';
  }

  @override
  String inviteSentSuccess(Object email) {
    return 'Invitation sent to $email.';
  }

  @override
  String get unlinkSuccess => 'Account unlinked.';

  @override
  String get confirmUnlinkTitle => 'Confirm Unlink';

  @override
  String confirmUnlinkMessage(Object name) {
    return 'Are you sure you want to unlink the account of member $name?';
  }

  @override
  String get trashTitle => 'Trash';

  @override
  String get trashEmpty =>
      'Members in the trash for more than 30 days will be permanently deleted.';

  @override
  String get trashStatusDeleted => 'Deleted';

  @override
  String trashDeletedAt(String time) {
    return 'Deleted: $time';
  }

  @override
  String get trashRestoreButton => 'Restore';

  @override
  String get trashPurgeButton => 'Empty';

  @override
  String get trashRestoreTitle => 'Restore Member';

  @override
  String trashRestoreMessage(String name) {
    return 'Are you sure you want to restore member \"$name\" to the tree?';
  }

  @override
  String trashRestoreSuccess(String name) {
    return 'Member $name restored.';
  }

  @override
  String get trashPurgeTitle => 'Delete Permanently';

  @override
  String get trashPurgeMessage =>
      'Permanently delete all members in the trash older than 30 days? This cannot be undone.';

  @override
  String trashPurgeSuccess(int count) {
    return '$count members permanently deleted.';
  }

  @override
  String get auditLogsTitle => 'Audit Log';

  @override
  String get auditLogsEmpty => 'No editing activity yet.';

  @override
  String auditActionCreate(String actor) {
    return '$actor added a new member';
  }

  @override
  String auditActionUpdate(String actor) {
    return '$actor edited a member';
  }

  @override
  String auditActionDelete(String actor) {
    return '$actor moved a member to trash';
  }

  @override
  String auditActionRestore(String actor) {
    return '$actor restored a member';
  }

  @override
  String auditActionPurge(String actor) {
    return '$actor cleared the trash';
  }

  @override
  String auditActionGeneric(String actor, String action) {
    return '$actor · $action';
  }

  @override
  String get auditUnknownActor => 'Unknown';

  @override
  String auditChangedFields(Object fields, Object name) {
    return '$name · changed: $fields';
  }

  @override
  String get unlinkFailed => 'Failed to unlink account';

  @override
  String get auditActorLabel => 'Performed by:';

  @override
  String get auditEmailLabel => 'Email:';

  @override
  String get auditActionLabel => 'Action:';

  @override
  String get auditTargetLabel => 'Target:';

  @override
  String get auditTimeLabel => 'Time:';

  @override
  String get auditChangedFieldsTitle => 'Changed fields detail:';

  @override
  String get viewMemberPage => 'View member page';

  @override
  String get memberNoLongerExists =>
      'This member may have been deleted or no longer exists.';

  @override
  String get filterCreate => 'Added';

  @override
  String get filterUpdate => 'Updated';

  @override
  String get restoreLabel => 'Restore';

  @override
  String get disabledLabel => 'Disabled';

  @override
  String enabledCountFormat(int count) {
    return 'Enabled ($count/4)';
  }

  @override
  String get notifEventSubtitle => 'Updates on clan events and gatherings';

  @override
  String get notifNewsSubtitle =>
      'Receive news and important announcements from the Board of Management';

  @override
  String get notifWishSubtitle => 'Notify when receiving wishes from members';

  @override
  String get notifAnniversarySubtitle =>
      'Remind of death anniversaries and member birthdays';

  @override
  String imageTooLargeFormat(int size) {
    return 'Image must be smaller than ${size}MB';
  }

  @override
  String generationTooHighFormat(int max) {
    return 'Generation cannot exceed the current generation + 1 (max: $max)';
  }

  @override
  String get closeSearchTooltip => 'Close search';

  @override
  String get searchMemberTooltip => 'Search member';

  @override
  String get hideGenBadges => 'Hide generation labels';

  @override
  String get showGenBadges => 'Show generation labels';

  @override
  String get treeOverviewTooltip => 'Tree overview';

  @override
  String get announcementBadge => 'ANNOUNCEMENT';

  @override
  String generationLevelFormat(String gen) {
    return 'Generation $gen';
  }

  @override
  String get memberSearchNoResult => 'No matching members found';

  @override
  String get deleteAccountTitle => 'Delete Account';

  @override
  String get deleteAccountConfirmMessage =>
      'All your personal data will be permanently deleted and cannot be recovered. You will lose access to the clan.\n\nAre you sure you want to continue?';

  @override
  String get deleteAccountSuccess => 'Your account has been deleted.';

  @override
  String get deleteAccountFailed => 'Failed to delete account.';

  @override
  String get deleteAccountButton => 'Delete Account';

  @override
  String get deleteAccountDeleting => 'Deleting…';

  @override
  String get dangerZoneTitle => 'Danger Zone';

  @override
  String get dangerZoneDesc =>
      'After deleting your account, all personal data will be permanently deleted and cannot be restored.';

  @override
  String get reportContentTitle => 'Report Violation';

  @override
  String get selectReportReason => 'Select a reason for reporting';

  @override
  String get reportReasonInappropriate => 'Inappropriate content';

  @override
  String get reportReasonAbusive => 'Abusive or offensive language';

  @override
  String get reportReasonFalseInfo => 'False or misleading information';

  @override
  String get reportReasonSpam => 'Spam or advertising';

  @override
  String get reportReasonOther => 'Other reason';

  @override
  String get reportSuccessMessage =>
      'Report submitted successfully. Thank you!';

  @override
  String get reportFailedMessage =>
      'Failed to submit report. Please try again.';

  @override
  String otpResendCountdownFormat(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get typeConfirmToTransfer =>
      'Type \"CONFIRM\" to transfer clan leadership:';

  @override
  String get confirmWord => 'CONFIRM';

  @override
  String get dissolveWord => 'DISSOLVE';

  @override
  String get copyInfoTooltip => 'Copy member info';

  @override
  String get copyInfoSuccess => 'Member info copied to clipboard!';

  @override
  String get rolePermissionDenied =>
      'Your account does not have permission to access this page.';
}
