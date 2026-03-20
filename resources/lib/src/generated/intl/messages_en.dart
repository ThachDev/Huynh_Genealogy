// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  // ignore: strict_top_level_inference
  static String m0(version) => "Version ${version}";

  // ignore: strict_top_level_inference
  static String m1(name) =>
      "Are you sure you want to delete ${name} from the family tree? This action cannot be undone.";

  // ignore: strict_top_level_inference
  static String m2(count) => "${count} people";

  // ignore: strict_top_level_inference
  static String m3(name) =>
      "Are you sure you want to delete ${name} from the family tree?";

  // ignore: strict_top_level_inference
  static String m4(error) => "Image download error: ${error}";

  // ignore: strict_top_level_inference
  static String m5(error) => "Error: ${error}";

  static String m6(gen) => "Generation ${gen}";

  static String m7(name) => "Saved branch information for ${name}.";

  static String m8(name) => "Saved member information for ${name}.";

  static String m9(date) => "Last update: ${date}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aboutAppMenuItem": MessageLookupByLibrary.simpleMessage("About App"),
    "aboutAppName": MessageLookupByLibrary.simpleMessage("Huynh Family Tree"),
    "aboutCopyrightContent": MessageLookupByLibrary.simpleMessage(
      "© 2026 Huynh Family Tree. Internal circulation only.",
    ),
    "aboutCopyrightTitle": MessageLookupByLibrary.simpleMessage("Note"),
    "aboutDedicationContent": MessageLookupByLibrary.simpleMessage(
      "Built by family descendants.",
    ),
    "aboutDedicationTitle": MessageLookupByLibrary.simpleMessage(
      "Implementation",
    ),
    "aboutDescriptionContent": MessageLookupByLibrary.simpleMessage(
      "This app is created to preserve, connect and promote the lineage traditions, helping descendants understand their roots and preserve family values through generations.",
    ),
    "aboutDescriptionTitle": MessageLookupByLibrary.simpleMessage(
      "About the app",
    ),
    "aboutMotto": MessageLookupByLibrary.simpleMessage(
      "Roots make the branches green,\nSource makes the sea wide and rivers deep",
    ),
    "aboutTitle": MessageLookupByLibrary.simpleMessage("ABOUT THE APP"),
    "aboutVersion": m0,
    "accountSection": MessageLookupByLibrary.simpleMessage("Account"),
    "addBranchTitle": MessageLookupByLibrary.simpleMessage("ADD NEW BRANCH"),
    "addChild": MessageLookupByLibrary.simpleMessage("Add child (Descendant)"),
    "addMemberTitle": MessageLookupByLibrary.simpleMessage("ADD MEMBER"),
    "addSpouse": MessageLookupByLibrary.simpleMessage("Add spouse"),
    "all": MessageLookupByLibrary.simpleMessage("All"),
    "ancestor": MessageLookupByLibrary.simpleMessage("Ancestor"),
    "appTitle": MessageLookupByLibrary.simpleMessage("Huynh Family Tree"),
    "birthPlaceLabel": MessageLookupByLibrary.simpleMessage("PLACE OF BIRTH"),
    "branch": MessageLookupByLibrary.simpleMessage("Branch"),
    "branchDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "A brief history of the branch...",
    ),
    "branchDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "BRANCH DESCRIPTION / HISTORY",
    ),
    "branchDropdownHint": MessageLookupByLibrary.simpleMessage("Main lineage"),
    "branchFounderHint": MessageLookupByLibrary.simpleMessage(
      "Ancestor\'s name...",
    ),
    "branchFounderLabel": MessageLookupByLibrary.simpleMessage("FOUNDER"),
    "branchListTitle": MessageLookupByLibrary.simpleMessage("BRANCH LIST"),
    "branchNameHint": MessageLookupByLibrary.simpleMessage(
      "Huynh Van Branch...",
    ),
    "branchNameLabel": MessageLookupByLibrary.simpleMessage("BRANCH NAME"),
    "branchNotFound": MessageLookupByLibrary.simpleMessage(
      "No matching branch found",
    ),
    "branchRegionHint": MessageLookupByLibrary.simpleMessage(
      "Quang Ngai, Binh Dinh...",
    ),
    "branchRegionLabel": MessageLookupByLibrary.simpleMessage(
      "REGION / LOCATION",
    ),
    "branchRelationLabel": MessageLookupByLibrary.simpleMessage(
      "BRANCH / GENEALOGY LINE",
    ),
    "branchYearHint": MessageLookupByLibrary.simpleMessage("Ex: 1900"),
    "branchYearLabel": MessageLookupByLibrary.simpleMessage("ESTABLISHED YEAR"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelButton": MessageLookupByLibrary.simpleMessage("CANCEL"),
    "confirmDelete": MessageLookupByLibrary.simpleMessage("Confirm Delete"),
    "confirmDeleteContent": m1,
    "countPeople": m2,
    "deceased": MessageLookupByLibrary.simpleMessage("Deceased"),
    "deleteMemberButton": MessageLookupByLibrary.simpleMessage("DELETE MEMBER"),
    "deleteMemberConfirm": m3,
    "deleteMemberSuccess": MessageLookupByLibrary.simpleMessage(
      "Successfully deleted member",
    ),
    "deleteNow": MessageLookupByLibrary.simpleMessage("Delete Now"),
    "descriptionLabel": MessageLookupByLibrary.simpleMessage("Description"),
    "diagram": MessageLookupByLibrary.simpleMessage("Diagram"),
    "dobLabel": MessageLookupByLibrary.simpleMessage("DATE OF BIRTH"),
    "dodLabel": MessageLookupByLibrary.simpleMessage("DATE OF DEATH"),
    "downloadImageError": MessageLookupByLibrary.simpleMessage(
      "Failed to download image! Please grant gallery access.",
    ),
    "downloadImageException": m4,
    "downloadImageSuccess": MessageLookupByLibrary.simpleMessage(
      "Image saved to gallery successfully!",
    ),
    "downloadingImage": MessageLookupByLibrary.simpleMessage(
      "Processing image download...",
    ),
    "editBranchTitle": MessageLookupByLibrary.simpleMessage("EDIT BRANCH"),
    "editInfo": MessageLookupByLibrary.simpleMessage("Edit info"),
    "editMemberTitle": MessageLookupByLibrary.simpleMessage("EDIT MEMBER"),
    "errorEnterBranchName": MessageLookupByLibrary.simpleMessage(
      "Please enter branch name",
    ),
    "errorEnterName": MessageLookupByLibrary.simpleMessage(
      "Please enter full name",
    ),
    "errorMessage": m5,
    "errorOccurred": MessageLookupByLibrary.simpleMessage("An error occurred"),
    "event": MessageLookupByLibrary.simpleMessage("Event"),
    "familyTreeDiagram": MessageLookupByLibrary.simpleMessage(
      "FAMILY TREE DIAGRAM",
    ),
    "featureInDevelopment": MessageLookupByLibrary.simpleMessage(
      "Feature in development.\nUpdating soon!",
    ),
    "female": MessageLookupByLibrary.simpleMessage("Female"),
    "fullNameLabel": MessageLookupByLibrary.simpleMessage("FULL NAME"),
    "genderLabel": MessageLookupByLibrary.simpleMessage("GENDER"),
    "genealogyAndLinksSection": MessageLookupByLibrary.simpleMessage(
      "GENEALOGY & LINKS",
    ),
    "generalUnknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "generation": MessageLookupByLibrary.simpleMessage("Gen"),
    "generationLabel": MessageLookupByLibrary.simpleMessage("GENERATION"),
    "generationLabelShort": m6,
    "helpAndSupportMenuItem": MessageLookupByLibrary.simpleMessage(
      "Help & Support",
    ),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "infoAndSupport": MessageLookupByLibrary.simpleMessage("Info & Support"),
    "languageSelect": MessageLookupByLibrary.simpleMessage("Language"),
    "legend": MessageLookupByLibrary.simpleMessage("Legend"),
    "male": MessageLookupByLibrary.simpleMessage("Male"),
    "maritalDivorced": MessageLookupByLibrary.simpleMessage("Divorced"),
    "maritalMarried": MessageLookupByLibrary.simpleMessage("Married"),
    "maritalSingle": MessageLookupByLibrary.simpleMessage("Single"),
    "maritalStatusLabel": MessageLookupByLibrary.simpleMessage(
      "MARITAL STATUS",
    ),
    "maritalUnknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "maritalWidowed": MessageLookupByLibrary.simpleMessage("Widowed"),
    "member": MessageLookupByLibrary.simpleMessage("Member"),
    "memberListTitle": MessageLookupByLibrary.simpleMessage("MEMBER LIST"),
    "motto": MessageLookupByLibrary.simpleMessage(
      "SPIRITUAL ROOTS • ETERNAL PRESERVATION",
    ),
    "noBranchData": MessageLookupByLibrary.simpleMessage(
      "No branch data available",
    ),
    "noBranchDescription": MessageLookupByLibrary.simpleMessage(
      "No description for this branch yet.",
    ),
    "noMemberData": MessageLookupByLibrary.simpleMessage(
      "No member data available",
    ),
    "noMemberInBranch": MessageLookupByLibrary.simpleMessage(
      "No members in this branch yet",
    ),
    "notesLabel": MessageLookupByLibrary.simpleMessage("NOTES / BIOGRAPHY"),
    "parentDropdownHint": MessageLookupByLibrary.simpleMessage("Select parent"),
    "parentRelationLabel": MessageLookupByLibrary.simpleMessage(
      "PARENT (Direct Line)",
    ),
    "personalInfoSection": MessageLookupByLibrary.simpleMessage(
      "PERSONAL INFO",
    ),
    "pickAvatarLabel": MessageLookupByLibrary.simpleMessage(
      "PICK AVATAR PHOTO",
    ),
    "privacyPolicyMenuItem": MessageLookupByLibrary.simpleMessage(
      "Privacy Policy",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "saveBranchSuccessMessage": m7,
    "saveButton": MessageLookupByLibrary.simpleMessage("SAVE INFORMATION"),
    "saveMemberSuccessMessage": m8,
    "saveSuccessTitle": MessageLookupByLibrary.simpleMessage(
      "SAVED SUCCESSFULLY!",
    ),
    "searchHint": MessageLookupByLibrary.simpleMessage("Search relative..."),
    "securityLastUpdate": m9,
    "securityPart1Content": MessageLookupByLibrary.simpleMessage(
      "The app stores basic information of family members such as: Full name, gender, date of birth, date of death and family relationships to serve the construction and maintenance of the family tree.",
    ),
    "securityPart1Title": MessageLookupByLibrary.simpleMessage(
      "1. Stored Information",
    ),
    "securityPart2Content": MessageLookupByLibrary.simpleMessage(
      "All information is used only within the lineage, helping descendants track genealogy, connect generations and preserve family traditions. Not used for commercial purposes.",
    ),
    "securityPart2Title": MessageLookupByLibrary.simpleMessage(
      "2. Purpose of Use",
    ),
    "securityPart3Content": MessageLookupByLibrary.simpleMessage(
      "Genealogy data is carefully stored and only trusted people in the lineage have the right to update or edit information.",
    ),
    "securityPart3Title": MessageLookupByLibrary.simpleMessage(
      "3. Information Preservation",
    ),
    "securityPart4Content": MessageLookupByLibrary.simpleMessage(
      "Each member can request to add or adjust information of themselves and relatives through the family tree manager.",
    ),
    "securityPart4Title": MessageLookupByLibrary.simpleMessage(
      "4. Member Rights",
    ),
    "securityPart5Content": MessageLookupByLibrary.simpleMessage(
      "Information and content in the app may be updated over time to ensure accuracy and completeness, and will be notified to members when necessary.",
    ),
    "securityPart5Title": MessageLookupByLibrary.simpleMessage(
      "5. Content Update",
    ),
    "securityTitle": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "selectGenderTitle": MessageLookupByLibrary.simpleMessage("SELECT GENDER"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "settingsTitle": MessageLookupByLibrary.simpleMessage("SETTINGS"),
    "spouseDropdownHint": MessageLookupByLibrary.simpleMessage("Select spouse"),
    "spouseRelationLabel": MessageLookupByLibrary.simpleMessage("SPOUSE"),
    "statusEdit": MessageLookupByLibrary.simpleMessage("EDIT"),
    "statusNew": MessageLookupByLibrary.simpleMessage("NEW"),
    "stillAlive": MessageLookupByLibrary.simpleMessage("Alive"),
    "supportEmailTitle": MessageLookupByLibrary.simpleMessage("Support Email"),
    "supportFAQ1Answer": MessageLookupByLibrary.simpleMessage(
      "Select the \"Add member\" button (+), then enter the information and select the correct family relationship.",
    ),
    "supportFAQ1Question": MessageLookupByLibrary.simpleMessage(
      "How to add a family member?",
    ),
    "supportFAQ2Answer": MessageLookupByLibrary.simpleMessage(
      "To ensure the accuracy of the family tree, only certain designated members have the right to edit data.",
    ),
    "supportFAQ2Question": MessageLookupByLibrary.simpleMessage(
      "Why can\'t I edit information?",
    ),
    "supportFAQ3Answer": MessageLookupByLibrary.simpleMessage(
      "You can contact the family tree manager to be supported in updating or editing information.",
    ),
    "supportFAQ3Question": MessageLookupByLibrary.simpleMessage(
      "How can I update information?",
    ),
    "supportFAQ4Answer": MessageLookupByLibrary.simpleMessage(
      "Data is stored securely and only used within the family internal range.",
    ),
    "supportFAQ4Question": MessageLookupByLibrary.simpleMessage(
      "Where is the genealogy information stored?",
    ),
    "supportFacebookTitle": MessageLookupByLibrary.simpleMessage(
      "Facebook Group",
    ),
    "supportHotlineTitle": MessageLookupByLibrary.simpleMessage("Hotline"),
    "supportTitle": MessageLookupByLibrary.simpleMessage("FAQ"),
    "understand": MessageLookupByLibrary.simpleMessage("Got it"),
    "viewAll": MessageLookupByLibrary.simpleMessage("View all"),
    "viewDetail": MessageLookupByLibrary.simpleMessage("View detail"),
  };
}
