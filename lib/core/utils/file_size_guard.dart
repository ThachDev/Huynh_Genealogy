import 'package:image_picker/image_picker.dart';

/// Kiểm tra file ảnh có vượt quá giới hạn dung lượng (MB) cho phép hay không.
/// Khớp với giới hạn tương ứng phía server:
/// - avatar thành viên: 5MB
/// - logo dòng họ: 10MB
/// - ảnh sự kiện: 10MB
Future<bool> exceedsMaxFileSize(XFile file, int maxMB) async {
  try {
    return await file.length() > maxMB * 1024 * 1024;
  } catch (_) {
    // Không đọc được dung lượng thì để server quyết định.
    return false;
  }
}