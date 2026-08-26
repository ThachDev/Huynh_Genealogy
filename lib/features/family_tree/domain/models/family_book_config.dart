enum FamilyBookCoverTheme {
  lightTraditional, // Mỹ Thuật Sáng (Giấy Điệp & Hoàng Kim - Tối Ưu Bản In)
  darkRoyal, // Mỹ Thuật Tối (Sơn Mài & Dạ Kim - Tối Ưu Màn Hình)
  plain, // Để Trống (Nền Trắng Trơn Trang Nhã)
}

class FamilyBookConfig {
  FamilyBookConfig({
    this.coverTheme = FamilyBookCoverTheme.lightTraditional,
    this.bookTitle = 'GIA PHẢ ĐẠI TÔN',
    this.ancestorName = '',
    this.originAddress = '',
    this.compilerName = 'Hội Đồng Gia Tộc',
    this.publishYear = '',
    this.preface = defaultPreface,
    this.clanRules = defaultClanRules,
    this.epilogue = defaultEpilogue,
    this.includeCover = true,
    this.includePreface = true,
    this.includeClanRules = true,
    this.includeStatistics = true,
    this.includeTreeChart = true,
    this.includeGenerations = true,
    this.startGeneration = 1,
    this.endGeneration,
    this.includeBurialInfo = true,
    this.includeMemorialCalendar = true,
    this.includeEpilogue = true,
  });

  FamilyBookCoverTheme coverTheme;
  String bookTitle;
  String ancestorName;
  String originAddress;
  String compilerName;
  String publishYear;

  String preface;
  String clanRules;
  String epilogue;

  bool includeCover;
  bool includePreface;
  bool includeClanRules;
  bool includeStatistics;
  bool includeTreeChart;
  bool includeGenerations;
  int startGeneration;
  int? endGeneration;
  bool includeBurialInfo;
  bool includeMemorialCalendar;
  bool includeEpilogue;

  static const String defaultPreface =
      '“Cây có cội mới trổ cành xanh lá, nước có nguồn mới bồi đắp biển sâu.”\n\n'
      'Con người ta sinh ra ở đời, ắt phải có tổ tiên nguồn cội. Công đức sinh thành dưỡng dục của tiền nhân sâu dày như trời bể. '
      'Cuốn phả hệ này được phụng thảo nhằm khắc ghi công lao tiên tổ, xác lập thế thứ tông chi, răn dạy hậu thế giữ trọn gia phong, '
      'hiếu kính phụng dưỡng, hòa thuận tương thân, tiếp nối truyền thống rạng rỡ của gia tộc.';

  static const String defaultClanRules =
      'I. Hiếu kính phụ mẫu, phụng thờ tổ tiên chí thành, giữ trọn đạo hiếu làm đầu.\n'
      'II. Huynh đệ đồng tâm, cốt nhục tương thân, đùm bọc sẻ chia lúc hoạn nạn.\n'
      'III. Dùi mài kinh sử, rèn đức luyện tài, lập thân kiến quốc, giữ gìn thanh danh dòng tộc.\n'
      'IV. Giữ nghiêm gia phong, ứng xử nhân nghĩa, tích cực tham gia việc hiếu hỉ, tế tự gia đường.\n'
      'V. Thượng tôn pháp luật, sống hòa nhã với xóm làng, lan tỏa điều thiện lành cho muôn đời sau.';

  static const String defaultEpilogue =
      'Kính cẩn ghi chép phả hệ tiền nhân, lưu truyền hậu thế muôn đời soi chung. '
      'Cầu chúc cho dòng tộc vạn đại trường tồn, con cháu hiển vinh, nhân tài kế thế, phúc lộc miên trường.';
}
