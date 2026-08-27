import 'family_book_config.dart';

enum PosterPaperSize {
  a0, // 841 x 1189 mm (Cực lớn - Treo Đại Từ Đường)
  a1, // 594 x 841 mm (Khổ lớn - Phổ biến nhất)
  a2, // 420 x 594 mm (Khổ vừa)
  a3, // 297 x 420 mm (Khổ nhỏ)
  a4, // 210 x 297 mm (Khổ tiêu chuẩn)
}

enum PosterOrientation {
  landscape, // Khổ ngang (Tối ưu cho cây nhiều nhánh)
  portrait, // Khổ dọc (Tối ưu cho cây ít nhánh, nhiều đời)
}

class FamilyTreePosterConfig {
  FamilyTreePosterConfig({
    this.posterTheme = FamilyBookCoverTheme.lightTraditional,
    this.paperSize = PosterPaperSize.a1,
    this.orientation = PosterOrientation.landscape,
    this.title = 'PHẢ HỆ ĐỒ ĐẠI TÔN',
    this.ancestorName = '',
    this.originAddress = '',
    this.leftCouplet = 'Tổ tông công đức thiên niên thịnh',
    this.rightCouplet = 'Tử hiếu tôn hiền vạn đại vinh',
    this.compilerName = 'Hội Đồng Gia Tộc',
    this.publishYear = '',
    this.startGeneration = 1,
    this.endGeneration,
    this.includeSpouse = true,
    this.includeDates = true,
  });

  FamilyBookCoverTheme posterTheme;
  PosterPaperSize paperSize;
  PosterOrientation orientation;
  String title;
  String ancestorName;
  String originAddress;
  String leftCouplet;
  String rightCouplet;
  String compilerName;
  String publishYear;
  int startGeneration;
  int? endGeneration;
  bool includeSpouse;
  bool includeDates;
}
