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
  static String m0(name) =>
      "Are you sure you want to delete ${name} from the family tree?";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "appTitle": MessageLookupByLibrary.simpleMessage("Huynh Family Tree"),
    "branch": MessageLookupByLibrary.simpleMessage("Branch"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "confirmDelete": MessageLookupByLibrary.simpleMessage("Confirm Delete"),
    "deceased": MessageLookupByLibrary.simpleMessage("Deceased"),
    "deleteMemberConfirm": m0,
    "deleteNow": MessageLookupByLibrary.simpleMessage("Delete Now"),
    "diagram": MessageLookupByLibrary.simpleMessage("Diagram"),
    "errorOccurred": MessageLookupByLibrary.simpleMessage("An error occurred"),
    "familyTreeDiagram": MessageLookupByLibrary.simpleMessage(
      "FAMILY TREE DIAGRAM",
    ),
    "female": MessageLookupByLibrary.simpleMessage("Female"),
    "generation": MessageLookupByLibrary.simpleMessage("Gen"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "legend": MessageLookupByLibrary.simpleMessage("Legend"),
    "male": MessageLookupByLibrary.simpleMessage("Male"),
    "member": MessageLookupByLibrary.simpleMessage("Member"),
    "motto": MessageLookupByLibrary.simpleMessage(
      "SPIRITUAL ROOTS • ETERNAL PRESERVATION",
    ),
    "noBranchData": MessageLookupByLibrary.simpleMessage(
      "No branch data available",
    ),
    "noMemberData": MessageLookupByLibrary.simpleMessage(
      "No member data available",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "searchHint": MessageLookupByLibrary.simpleMessage("Search relative..."),
    "stillAlive": MessageLookupByLibrary.simpleMessage("Alive"),
    "understand": MessageLookupByLibrary.simpleMessage("Got it"),
    "viewAll": MessageLookupByLibrary.simpleMessage("View all"),
  };
}
