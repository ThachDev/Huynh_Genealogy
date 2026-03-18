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
