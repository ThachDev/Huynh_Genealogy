// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a vi locale. All the
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
  String get localeName => 'vi';

  // ignore: strict_top_level_inference
  static String m0(name) =>
      "Bạn có chắc muốn xóa thành viên ${name} khỏi gia phả không?";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "appTitle": MessageLookupByLibrary.simpleMessage("Gia phả họ Huỳnh"),
    "branch": MessageLookupByLibrary.simpleMessage("Chi tộc"),
    "cancel": MessageLookupByLibrary.simpleMessage("Hủy"),
    "confirmDelete": MessageLookupByLibrary.simpleMessage("Xác nhận xóa"),
    "deceased": MessageLookupByLibrary.simpleMessage("Đã mất"),
    "deleteMemberConfirm": m0,
    "deleteNow": MessageLookupByLibrary.simpleMessage("Xóa ngay"),
    "diagram": MessageLookupByLibrary.simpleMessage("Sơ đồ"),
    "errorOccurred": MessageLookupByLibrary.simpleMessage("Có lỗi xảy ra"),
    "familyTreeDiagram": MessageLookupByLibrary.simpleMessage("SƠ ĐỒ GIA PHẢ"),
    "female": MessageLookupByLibrary.simpleMessage("Nữ"),
    "generation": MessageLookupByLibrary.simpleMessage("Đời"),
    "home": MessageLookupByLibrary.simpleMessage("Trang chủ"),
    "legend": MessageLookupByLibrary.simpleMessage("Chú thích ký hiệu"),
    "male": MessageLookupByLibrary.simpleMessage("Nam"),
    "member": MessageLookupByLibrary.simpleMessage("Thành viên"),
    "motto": MessageLookupByLibrary.simpleMessage(
      "CỘI NGUỒN TÂM LINH • VẠN ĐẠI TRƯỜNG TỒN",
    ),
    "noBranchData": MessageLookupByLibrary.simpleMessage(
      "Chưa có dữ liệu chi tộc",
    ),
    "noMemberData": MessageLookupByLibrary.simpleMessage(
      "Chưa có dữ liệu thành viên",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Thử lại"),
    "searchHint": MessageLookupByLibrary.simpleMessage("Tìm người thân..."),
    "stillAlive": MessageLookupByLibrary.simpleMessage("Còn sống"),
    "understand": MessageLookupByLibrary.simpleMessage("Đã hiểu"),
    "viewAll": MessageLookupByLibrary.simpleMessage("Xem tất cả"),
  };
}
