// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Gia phả họ Huỳnh`
  String get appTitle {
    return Intl.message(
      'Gia phả họ Huỳnh',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `CỘI NGUỒN TÂM LINH • VẠN ĐẠI TRƯỜNG TỒN`
  String get motto {
    return Intl.message(
      'CỘI NGUỒN TÂM LINH • VẠN ĐẠI TRƯỜNG TỒN',
      name: 'motto',
      desc: '',
      args: [],
    );
  }

  /// `Trang chủ`
  String get home {
    return Intl.message('Trang chủ', name: 'home', desc: '', args: []);
  }

  /// `Sơ đồ`
  String get diagram {
    return Intl.message('Sơ đồ', name: 'diagram', desc: '', args: []);
  }

  /// `Thành viên`
  String get member {
    return Intl.message('Thành viên', name: 'member', desc: '', args: []);
  }

  /// `Chi tộc`
  String get branch {
    return Intl.message('Chi tộc', name: 'branch', desc: '', args: []);
  }

  /// `Đời`
  String get generation {
    return Intl.message('Đời', name: 'generation', desc: '', args: []);
  }

  /// `Còn sống`
  String get stillAlive {
    return Intl.message('Còn sống', name: 'stillAlive', desc: '', args: []);
  }

  /// `Đã mất`
  String get deceased {
    return Intl.message('Đã mất', name: 'deceased', desc: '', args: []);
  }

  /// `Thử lại`
  String get retry {
    return Intl.message('Thử lại', name: 'retry', desc: '', args: []);
  }

  /// `Có lỗi xảy ra`
  String get errorOccurred {
    return Intl.message(
      'Có lỗi xảy ra',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Chưa có dữ liệu thành viên`
  String get noMemberData {
    return Intl.message(
      'Chưa có dữ liệu thành viên',
      name: 'noMemberData',
      desc: '',
      args: [],
    );
  }

  /// `Chưa có dữ liệu chi tộc`
  String get noBranchData {
    return Intl.message(
      'Chưa có dữ liệu chi tộc',
      name: 'noBranchData',
      desc: '',
      args: [],
    );
  }

  /// `Xem tất cả`
  String get viewAll {
    return Intl.message('Xem tất cả', name: 'viewAll', desc: '', args: []);
  }

  /// `Xác nhận xóa`
  String get confirmDelete {
    return Intl.message(
      'Xác nhận xóa',
      name: 'confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Bạn có chắc muốn xóa thành viên {name} khỏi gia phả không?`
  String deleteMemberConfirm(String name) {
    return Intl.message(
      'Bạn có chắc muốn xóa thành viên $name khỏi gia phả không?',
      name: 'deleteMemberConfirm',
      desc: '',
      args: [name],
    );
  }

  /// `Hủy`
  String get cancel {
    return Intl.message('Hủy', name: 'cancel', desc: '', args: []);
  }

  /// `Xóa ngay`
  String get deleteNow {
    return Intl.message('Xóa ngay', name: 'deleteNow', desc: '', args: []);
  }

  /// `Tìm người thân...`
  String get searchHint {
    return Intl.message(
      'Tìm người thân...',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `Chú thích ký hiệu`
  String get legend {
    return Intl.message(
      'Chú thích ký hiệu',
      name: 'legend',
      desc: '',
      args: [],
    );
  }

  /// `Nam`
  String get male {
    return Intl.message('Nam', name: 'male', desc: '', args: []);
  }

  /// `Nữ`
  String get female {
    return Intl.message('Nữ', name: 'female', desc: '', args: []);
  }

  /// `Đã hiểu`
  String get understand {
    return Intl.message('Đã hiểu', name: 'understand', desc: '', args: []);
  }

  /// `SƠ ĐỒ GIA PHẢ`
  String get familyTreeDiagram {
    return Intl.message(
      'SƠ ĐỒ GIA PHẢ',
      name: 'familyTreeDiagram',
      desc: '',
      args: [],
    );
  }

  /// `VỀ ỨNG DỤNG`
  String get aboutTitle {
    return Intl.message('VỀ ỨNG DỤNG', name: 'aboutTitle', desc: '', args: []);
  }

  /// `Gia Phả Họ Huỳnh`
  String get aboutAppName {
    return Intl.message(
      'Gia Phả Họ Huỳnh',
      name: 'aboutAppName',
      desc: '',
      args: [],
    );
  }

  /// `Cây có gốc mới nở ngành xanh ngọn,\nNước có nguồn mới bể rộng sông sâu`
  String get aboutMotto {
    return Intl.message(
      'Cây có gốc mới nở ngành xanh ngọn,\nNước có nguồn mới bể rộng sông sâu',
      name: 'aboutMotto',
      desc: '',
      args: [],
    );
  }

  /// `Về ứng dụng`
  String get aboutDescriptionTitle {
    return Intl.message(
      'Về ứng dụng',
      name: 'aboutDescriptionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Ứng dụng được tạo ra nhằm lưu giữ, kết nối và phát huy truyền thống của dòng họ, giúp con cháu hiểu rõ cội nguồn và gìn giữ giá trị gia đình qua nhiều thế hệ.`
  String get aboutDescriptionContent {
    return Intl.message(
      'Ứng dụng được tạo ra nhằm lưu giữ, kết nối và phát huy truyền thống của dòng họ, giúp con cháu hiểu rõ cội nguồn và gìn giữ giá trị gia đình qua nhiều thế hệ.',
      name: 'aboutDescriptionContent',
      desc: '',
      args: [],
    );
  }

  /// `Tâm huyết thực hiện`
  String get aboutDedicationTitle {
    return Intl.message(
      'Tâm huyết thực hiện',
      name: 'aboutDedicationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Được xây dựng bởi con cháu trong dòng họ với mong muốn lưu giữ những ký ức, câu chuyện và giá trị tốt đẹp của gia đình.`
  String get aboutDedicationContent {
    return Intl.message(
      'Được xây dựng bởi con cháu trong dòng họ với mong muốn lưu giữ những ký ức, câu chuyện và giá trị tốt đẹp của gia đình.',
      name: 'aboutDedicationContent',
      desc: '',
      args: [],
    );
  }

  /// `Ghi chú`
  String get aboutCopyrightTitle {
    return Intl.message(
      'Ghi chú',
      name: 'aboutCopyrightTitle',
      desc: '',
      args: [],
    );
  }

  /// `© 2026 Gia phả họ Huỳnh.`
  String get aboutCopyrightContent {
    return Intl.message(
      '© 2026 Gia phả họ Huỳnh.',
      name: 'aboutCopyrightContent',
      desc: '',
      args: [],
    );
  }

  /// `Phiên bản {version}`
  String aboutVersion(String version) {
    return Intl.message(
      'Phiên bản $version',
      name: 'aboutVersion',
      desc: '',
      args: [version],
    );
  }

  /// `Chính sách bảo mật`
  String get securityTitle {
    return Intl.message(
      'Chính sách bảo mật',
      name: 'securityTitle',
      desc: '',
      args: [],
    );
  }

  /// `1. Thông tin được lưu trữ`
  String get securityPart1Title {
    return Intl.message(
      '1. Thông tin được lưu trữ',
      name: 'securityPart1Title',
      desc: '',
      args: [],
    );
  }

  /// `Ứng dụng lưu giữ các thông tin cơ bản của thành viên trong dòng họ như: Họ tên, giới tính, ngày sinh, ngày mất và mối quan hệ gia đình nhằm phục vụ việc xây dựng và duy trì gia phả.`
  String get securityPart1Content {
    return Intl.message(
      'Ứng dụng lưu giữ các thông tin cơ bản của thành viên trong dòng họ như: Họ tên, giới tính, ngày sinh, ngày mất và mối quan hệ gia đình nhằm phục vụ việc xây dựng và duy trì gia phả.',
      name: 'securityPart1Content',
      desc: '',
      args: [],
    );
  }

  /// `2. Mục đích sử dụng`
  String get securityPart2Title {
    return Intl.message(
      '2. Mục đích sử dụng',
      name: 'securityPart2Title',
      desc: '',
      args: [],
    );
  }

  /// `Toàn bộ thông tin chỉ được sử dụng trong phạm vi nội bộ dòng họ, nhằm giúp con cháu theo dõi phả hệ, kết nối các thế hệ và gìn giữ truyền thống gia đình. Không sử dụng cho mục đích thương mại.`
  String get securityPart2Content {
    return Intl.message(
      'Toàn bộ thông tin chỉ được sử dụng trong phạm vi nội bộ dòng họ, nhằm giúp con cháu theo dõi phả hệ, kết nối các thế hệ và gìn giữ truyền thống gia đình. Không sử dụng cho mục đích thương mại.',
      name: 'securityPart2Content',
      desc: '',
      args: [],
    );
  }

  /// `3. Bảo quản thông tin`
  String get securityPart3Title {
    return Intl.message(
      '3. Bảo quản thông tin',
      name: 'securityPart3Title',
      desc: '',
      args: [],
    );
  }

  /// `Dữ liệu gia phả được lưu trữ cẩn thận và chỉ những người được tin cậy trong dòng họ mới có quyền cập nhật hoặc chỉnh sửa thông tin.`
  String get securityPart3Content {
    return Intl.message(
      'Dữ liệu gia phả được lưu trữ cẩn thận và chỉ những người được tin cậy trong dòng họ mới có quyền cập nhật hoặc chỉnh sửa thông tin.',
      name: 'securityPart3Content',
      desc: '',
      args: [],
    );
  }

  /// `4. Quyền của thành viên`
  String get securityPart4Title {
    return Intl.message(
      '4. Quyền của thành viên',
      name: 'securityPart4Title',
      desc: '',
      args: [],
    );
  }

  /// `Mỗi thành viên có thể đề nghị bổ sung hoặc điều chỉnh thông tin của bản thân và người thân thông qua người quản lý gia phả của dòng họ.`
  String get securityPart4Content {
    return Intl.message(
      'Mỗi thành viên có thể đề nghị bổ sung hoặc điều chỉnh thông tin của bản thân và người thân thông qua người quản lý gia phả của dòng họ.',
      name: 'securityPart4Content',
      desc: '',
      args: [],
    );
  }

  /// `5. Cập nhật nội dung`
  String get securityPart5Title {
    return Intl.message(
      '5. Cập nhật nội dung',
      name: 'securityPart5Title',
      desc: '',
      args: [],
    );
  }

  /// `Thông tin và nội dung trong ứng dụng có thể được cập nhật theo thời gian để đảm bảo chính xác và đầy đủ hơn, và sẽ được thông báo đến các thành viên khi cần thiết.`
  String get securityPart5Content {
    return Intl.message(
      'Thông tin và nội dung trong ứng dụng có thể được cập nhật theo thời gian để đảm bảo chính xác và đầy đủ hơn, và sẽ được thông báo đến các thành viên khi cần thiết.',
      name: 'securityPart5Content',
      desc: '',
      args: [],
    );
  }

  /// `Cập nhật lần cuối: {date}`
  String securityLastUpdate(String date) {
    return Intl.message(
      'Cập nhật lần cuối: $date',
      name: 'securityLastUpdate',
      desc: '',
      args: [date],
    );
  }

  /// `HỎI ĐÁP`
  String get supportTitle {
    return Intl.message('HỎI ĐÁP', name: 'supportTitle', desc: '', args: []);
  }

  /// `Email hỗ trợ`
  String get supportEmailTitle {
    return Intl.message(
      'Email hỗ trợ',
      name: 'supportEmailTitle',
      desc: '',
      args: [],
    );
  }

  /// `Hotline`
  String get supportHotlineTitle {
    return Intl.message(
      'Hotline',
      name: 'supportHotlineTitle',
      desc: '',
      args: [],
    );
  }

  /// `Nhóm Facebook`
  String get supportFacebookTitle {
    return Intl.message(
      'Nhóm Facebook',
      name: 'supportFacebookTitle',
      desc: '',
      args: [],
    );
  }

  /// `Làm sao để thêm người trong gia đình?`
  String get supportFAQ1Question {
    return Intl.message(
      'Làm sao để thêm người trong gia đình?',
      name: 'supportFAQ1Question',
      desc: '',
      args: [],
    );
  }

  /// `Bạn chọn nút "Thêm thành viên" (+), sau đó nhập thông tin và chọn đúng mối quan hệ trong gia đình.`
  String get supportFAQ1Answer {
    return Intl.message(
      'Bạn chọn nút "Thêm thành viên" (+), sau đó nhập thông tin và chọn đúng mối quan hệ trong gia đình.',
      name: 'supportFAQ1Answer',
      desc: '',
      args: [],
    );
  }

  /// `Vì sao tôi không chỉnh sửa được thông tin?`
  String get supportFAQ2Question {
    return Intl.message(
      'Vì sao tôi không chỉnh sửa được thông tin?',
      name: 'supportFAQ2Question',
      desc: '',
      args: [],
    );
  }

  /// `Để đảm bảo tính chính xác của gia phả, chỉ một số thành viên được giao trách nhiệm mới có quyền chỉnh sửa dữ liệu.`
  String get supportFAQ2Answer {
    return Intl.message(
      'Để đảm bảo tính chính xác của gia phả, chỉ một số thành viên được giao trách nhiệm mới có quyền chỉnh sửa dữ liệu.',
      name: 'supportFAQ2Answer',
      desc: '',
      args: [],
    );
  }

  /// `Tôi có thể cập nhật thông tin bằng cách nào?`
  String get supportFAQ3Question {
    return Intl.message(
      'Tôi có thể cập nhật thông tin bằng cách nào?',
      name: 'supportFAQ3Question',
      desc: '',
      args: [],
    );
  }

  /// `Bạn có thể liên hệ với người quản lý gia phả trong dòng họ để được hỗ trợ cập nhật hoặc chỉnh sửa thông tin.`
  String get supportFAQ3Answer {
    return Intl.message(
      'Bạn có thể liên hệ với người quản lý gia phả trong dòng họ để được hỗ trợ cập nhật hoặc chỉnh sửa thông tin.',
      name: 'supportFAQ3Answer',
      desc: '',
      args: [],
    );
  }

  /// `Thông tin gia phả được lưu ở đâu?`
  String get supportFAQ4Question {
    return Intl.message(
      'Thông tin gia phả được lưu ở đâu?',
      name: 'supportFAQ4Question',
      desc: '',
      args: [],
    );
  }

  /// `Dữ liệu được lưu trữ an toàn và chỉ sử dụng trong phạm vi nội bộ dòng họ.`
  String get supportFAQ4Answer {
    return Intl.message(
      'Dữ liệu được lưu trữ an toàn và chỉ sử dụng trong phạm vi nội bộ dòng họ.',
      name: 'supportFAQ4Answer',
      desc: '',
      args: [],
    );
  }

  /// `Sự kiện`
  String get event {
    return Intl.message('Sự kiện', name: 'event', desc: '', args: []);
  }

  /// `Cài đặt`
  String get settings {
    return Intl.message('Cài đặt', name: 'settings', desc: '', args: []);
  }

  /// `LƯU THÀNH CÔNG!`
  String get saveSuccessTitle {
    return Intl.message(
      'LƯU THÀNH CÔNG!',
      name: 'saveSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `Đã lưu thông tin thành viên {name}.`
  String saveMemberSuccessMessage(Object name) {
    return Intl.message(
      'Đã lưu thông tin thành viên $name.',
      name: 'saveMemberSuccessMessage',
      desc: '',
      args: [name],
    );
  }

  /// `CHỈNH SỬA THÀNH VIÊN`
  String get editMemberTitle {
    return Intl.message(
      'CHỈNH SỬA THÀNH VIÊN',
      name: 'editMemberTitle',
      desc: '',
      args: [],
    );
  }

  /// `THÊM THÀNH VIÊN`
  String get addMemberTitle {
    return Intl.message(
      'THÊM THÀNH VIÊN',
      name: 'addMemberTitle',
      desc: '',
      args: [],
    );
  }

  /// `SỬA`
  String get statusEdit {
    return Intl.message('SỬA', name: 'statusEdit', desc: '', args: []);
  }

  /// `MỚI`
  String get statusNew {
    return Intl.message('MỚI', name: 'statusNew', desc: '', args: []);
  }

  /// `HỌ VÀ TÊN`
  String get fullNameLabel {
    return Intl.message('HỌ VÀ TÊN', name: 'fullNameLabel', desc: '', args: []);
  }

  /// `GIỚI TÍNH`
  String get genderLabel {
    return Intl.message('GIỚI TÍNH', name: 'genderLabel', desc: '', args: []);
  }

  /// `ĐỜI THỨ`
  String get generationLabel {
    return Intl.message('ĐỜI THỨ', name: 'generationLabel', desc: '', args: []);
  }

  /// `NGÀY SINH`
  String get dobLabel {
    return Intl.message('NGÀY SINH', name: 'dobLabel', desc: '', args: []);
  }

  /// `NGÀY MẤT`
  String get dodLabel {
    return Intl.message('NGÀY MẤT', name: 'dodLabel', desc: '', args: []);
  }

  /// `QUÊ QUÁN`
  String get birthPlaceLabel {
    return Intl.message(
      'QUÊ QUÁN',
      name: 'birthPlaceLabel',
      desc: '',
      args: [],
    );
  }

  /// `HÔN NHÂN`
  String get maritalStatusLabel {
    return Intl.message(
      'HÔN NHÂN',
      name: 'maritalStatusLabel',
      desc: '',
      args: [],
    );
  }

  /// `GHI CHÚ / TIỂU SỬ`
  String get notesLabel {
    return Intl.message(
      'GHI CHÚ / TIỂU SỬ',
      name: 'notesLabel',
      desc: '',
      args: [],
    );
  }

  /// `CHỌN ẢNH CHÂN DUNG`
  String get pickAvatarLabel {
    return Intl.message(
      'CHỌN ẢNH CHÂN DUNG',
      name: 'pickAvatarLabel',
      desc: '',
      args: [],
    );
  }

  /// `CHA / MẸ (Người trực hệ)`
  String get parentRelationLabel {
    return Intl.message(
      'CHA / MẸ (Người trực hệ)',
      name: 'parentRelationLabel',
      desc: '',
      args: [],
    );
  }

  /// `VỢ / CHỒNG`
  String get spouseRelationLabel {
    return Intl.message(
      'VỢ / CHỒNG',
      name: 'spouseRelationLabel',
      desc: '',
      args: [],
    );
  }

  /// `CHI / NHÁNH GIA PHẢ`
  String get branchRelationLabel {
    return Intl.message(
      'CHI / NHÁNH GIA PHẢ',
      name: 'branchRelationLabel',
      desc: '',
      args: [],
    );
  }

  /// `HỦY BỎ`
  String get cancelButton {
    return Intl.message('HỦY BỎ', name: 'cancelButton', desc: '', args: []);
  }

  /// `LƯU THÔNG TIN`
  String get saveButton {
    return Intl.message(
      'LƯU THÔNG TIN',
      name: 'saveButton',
      desc: '',
      args: [],
    );
  }

  /// `Vui lòng nhập họ tên`
  String get errorEnterName {
    return Intl.message(
      'Vui lòng nhập họ tên',
      name: 'errorEnterName',
      desc: '',
      args: [],
    );
  }

  /// `Độc thân`
  String get maritalSingle {
    return Intl.message('Độc thân', name: 'maritalSingle', desc: '', args: []);
  }

  /// `Đã kết hôn`
  String get maritalMarried {
    return Intl.message(
      'Đã kết hôn',
      name: 'maritalMarried',
      desc: '',
      args: [],
    );
  }

  /// `Ly hôn`
  String get maritalDivorced {
    return Intl.message('Ly hôn', name: 'maritalDivorced', desc: '', args: []);
  }

  /// `Góa`
  String get maritalWidowed {
    return Intl.message('Góa', name: 'maritalWidowed', desc: '', args: []);
  }

  /// `Không rõ`
  String get maritalUnknown {
    return Intl.message('Không rõ', name: 'maritalUnknown', desc: '', args: []);
  }

  /// `Chọn người đời trước`
  String get parentDropdownHint {
    return Intl.message(
      'Chọn người đời trước',
      name: 'parentDropdownHint',
      desc: '',
      args: [],
    );
  }

  /// `Chọn người phối ngẫu`
  String get spouseDropdownHint {
    return Intl.message(
      'Chọn người phối ngẫu',
      name: 'spouseDropdownHint',
      desc: '',
      args: [],
    );
  }

  /// `Dòng họ chính`
  String get branchDropdownHint {
    return Intl.message(
      'Dòng họ chính',
      name: 'branchDropdownHint',
      desc: '',
      args: [],
    );
  }

  /// `DANH SÁCH THÀNH VIÊN`
  String get memberListTitle {
    return Intl.message(
      'DANH SÁCH THÀNH VIÊN',
      name: 'memberListTitle',
      desc: '',
      args: [],
    );
  }

  /// `CHỌN GIỚI TÍNH`
  String get selectGenderTitle {
    return Intl.message(
      'CHỌN GIỚI TÍNH',
      name: 'selectGenderTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tất cả`
  String get all {
    return Intl.message('Tất cả', name: 'all', desc: '', args: []);
  }

  /// `Xem chi tiết`
  String get viewDetail {
    return Intl.message('Xem chi tiết', name: 'viewDetail', desc: '', args: []);
  }

  /// `Thêm con (Hậu duệ)`
  String get addChild {
    return Intl.message(
      'Thêm con (Hậu duệ)',
      name: 'addChild',
      desc: '',
      args: [],
    );
  }

  /// `Thêm vợ / chồng`
  String get addSpouse {
    return Intl.message(
      'Thêm vợ / chồng',
      name: 'addSpouse',
      desc: '',
      args: [],
    );
  }

  /// `Sửa thông tin`
  String get editInfo {
    return Intl.message('Sửa thông tin', name: 'editInfo', desc: '', args: []);
  }

  /// `Đã xóa thành viên thành công`
  String get deleteMemberSuccess {
    return Intl.message(
      'Đã xóa thành viên thành công',
      name: 'deleteMemberSuccess',
      desc: '',
      args: [],
    );
  }

  /// `XÓA THÀNH VIÊN`
  String get deleteMemberButton {
    return Intl.message(
      'XÓA THÀNH VIÊN',
      name: 'deleteMemberButton',
      desc: '',
      args: [],
    );
  }

  /// `Bạn có chắc muốn xóa thành viên {name} khỏi gia phả không? Thao tác này không thể hoàn tác.`
  String confirmDeleteContent(Object name) {
    return Intl.message(
      'Bạn có chắc muốn xóa thành viên $name khỏi gia phả không? Thao tác này không thể hoàn tác.',
      name: 'confirmDeleteContent',
      desc: '',
      args: [name],
    );
  }

  /// `Đời thứ {gen}`
  String generationLabelShort(Object gen) {
    return Intl.message(
      'Đời thứ $gen',
      name: 'generationLabelShort',
      desc: '',
      args: [gen],
    );
  }

  /// `Tổ`
  String get ancestor {
    return Intl.message('Tổ', name: 'ancestor', desc: '', args: []);
  }

  /// `Đã lưu thông tin chi tộc {name}.`
  String saveBranchSuccessMessage(Object name) {
    return Intl.message(
      'Đã lưu thông tin chi tộc $name.',
      name: 'saveBranchSuccessMessage',
      desc: '',
      args: [name],
    );
  }

  /// `CHỈNH SỬA CHI TỘC`
  String get editBranchTitle {
    return Intl.message(
      'CHỈNH SỬA CHI TỘC',
      name: 'editBranchTitle',
      desc: '',
      args: [],
    );
  }

  /// `THÊM CHI TỘC MỚI`
  String get addBranchTitle {
    return Intl.message(
      'THÊM CHI TỘC MỚI',
      name: 'addBranchTitle',
      desc: '',
      args: [],
    );
  }

  /// `TÊN CHI TỘC`
  String get branchNameLabel {
    return Intl.message(
      'TÊN CHI TỘC',
      name: 'branchNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Chi tộc Huỳnh Văn...`
  String get branchNameHint {
    return Intl.message(
      'Chi tộc Huỳnh Văn...',
      name: 'branchNameHint',
      desc: '',
      args: [],
    );
  }

  /// `NGƯỜI SÁNG LẬP`
  String get branchFounderLabel {
    return Intl.message(
      'NGƯỜI SÁNG LẬP',
      name: 'branchFounderLabel',
      desc: '',
      args: [],
    );
  }

  /// `Tên cụ tổ...`
  String get branchFounderHint {
    return Intl.message(
      'Tên cụ tổ...',
      name: 'branchFounderHint',
      desc: '',
      args: [],
    );
  }

  /// `NĂM THÀNH LẬP`
  String get branchYearLabel {
    return Intl.message(
      'NĂM THÀNH LẬP',
      name: 'branchYearLabel',
      desc: '',
      args: [],
    );
  }

  /// `VD: 1900`
  String get branchYearHint {
    return Intl.message('VD: 1900', name: 'branchYearHint', desc: '', args: []);
  }

  /// `VÙNG MIỀN / ĐỊA DANH`
  String get branchRegionLabel {
    return Intl.message(
      'VÙNG MIỀN / ĐỊA DANH',
      name: 'branchRegionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Quảng Ngãi, Bình Định...`
  String get branchRegionHint {
    return Intl.message(
      'Quảng Ngãi, Bình Định...',
      name: 'branchRegionHint',
      desc: '',
      args: [],
    );
  }

  /// `MÔ TẢ / TIỂU SỬ CHI TỘC`
  String get branchDescriptionLabel {
    return Intl.message(
      'MÔ TẢ / TIỂU SỬ CHI TỘC',
      name: 'branchDescriptionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Đôi nét về lịch sử chi tộc...`
  String get branchDescriptionHint {
    return Intl.message(
      'Đôi nét về lịch sử chi tộc...',
      name: 'branchDescriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `Vui lòng nhập tên chi tộc`
  String get errorEnterBranchName {
    return Intl.message(
      'Vui lòng nhập tên chi tộc',
      name: 'errorEnterBranchName',
      desc: '',
      args: [],
    );
  }

  /// `DANH SÁCH CHI TỘC`
  String get branchListTitle {
    return Intl.message(
      'DANH SÁCH CHI TỘC',
      name: 'branchListTitle',
      desc: '',
      args: [],
    );
  }

  /// `Không tìm thấy chi tộc phù hợp`
  String get branchNotFound {
    return Intl.message(
      'Không tìm thấy chi tộc phù hợp',
      name: 'branchNotFound',
      desc: '',
      args: [],
    );
  }

  /// `{count} người`
  String countPeople(Object count) {
    return Intl.message(
      '$count người',
      name: 'countPeople',
      desc: '',
      args: [count],
    );
  }

  /// `Chưa có thành viên trong chi tộc này`
  String get noMemberInBranch {
    return Intl.message(
      'Chưa có thành viên trong chi tộc này',
      name: 'noMemberInBranch',
      desc: '',
      args: [],
    );
  }

  /// `Chưa rõ`
  String get generalUnknown {
    return Intl.message('Chưa rõ', name: 'generalUnknown', desc: '', args: []);
  }

  /// `Mô tả`
  String get descriptionLabel {
    return Intl.message('Mô tả', name: 'descriptionLabel', desc: '', args: []);
  }

  /// `Chưa có mô tả cho chi tộc này.`
  String get noBranchDescription {
    return Intl.message(
      'Chưa có mô tả cho chi tộc này.',
      name: 'noBranchDescription',
      desc: '',
      args: [],
    );
  }

  /// `Tính năng đang được phát triển.\nSẽ sớm cập nhật!`
  String get featureInDevelopment {
    return Intl.message(
      'Tính năng đang được phát triển.\nSẽ sớm cập nhật!',
      name: 'featureInDevelopment',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'vi'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
