import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:giatocviet/features/family_tree/data/models/branch_model.dart';
import '../models/member_model.dart';
import 'package:giatocviet/features/family_tree/domain/entities/branch_entity.dart';
import 'package:giatocviet/features/family_tree/domain/entities/member_entity.dart';

/// Lưu dữ liệu cây gia phả xuống file cục bộ (documents) theo từng gia tộc,
/// để xem nhanh và xem offline khi không có mạng.
class FamilyTreeLocalDataSource {
  FamilyTreeLocalDataSource();

  Future<Directory> _cacheDir() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${appDocDir.path}/family_tree_cache');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  String _membersFile(int familyId) => 'members_$familyId.json';
  String _branchesFile(int familyId) => 'branches_$familyId.json';

  Future<void> cacheMembers(List<MemberEntity> members, int? familyId) async {
    if (familyId == null) return;
    try {
      final jsonList =
          members.map((m) => MemberModel.fromEntity(m).toJson()).toList();
      final file =
          File('${(await _cacheDir()).path}/${_membersFile(familyId)}');
      await file.writeAsString(json.encode(jsonList));
    } catch (_) {
      // Bỏ qua lỗi ghi cache, không ảnh hưởng đến luồng chính.
    }
  }

  Future<List<MemberEntity>?> getCachedMembers(int? familyId) async {
    if (familyId == null) return null;
    try {
      final file =
          File('${(await _cacheDir()).path}/${_membersFile(familyId)}');
      if (!await file.exists()) return null;
      final raw = await file.readAsString();
      final list = json.decode(raw) as List<dynamic>;
      return list
          .map((e) => MemberModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> cacheBranches(List<BranchEntity> branches, int? familyId) async {
    if (familyId == null) return;
    try {
      final jsonList = branches.map((b) => b.toJson()).toList();
      final file =
          File('${(await _cacheDir()).path}/${_branchesFile(familyId)}');
      await file.writeAsString(json.encode(jsonList));
    } catch (_) {}
  }

  Future<List<BranchEntity>?> getCachedBranches(int? familyId) async {
    if (familyId == null) return null;
    try {
      final file =
          File('${(await _cacheDir()).path}/${_branchesFile(familyId)}');
      if (!await file.exists()) return null;
      final raw = await file.readAsString();
      final list = json.decode(raw) as List<dynamic>;
      return list
          .map((e) => BranchModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Xoá toàn bộ cache cây gia phả (dùng sau khi sửa/xoá để tránh dữ liệu cũ).
  Future<void> clearAll() async {
    try {
      final dir = await _cacheDir();
      final files = await dir.list().toList();
      for (final entity in files) {
        if (entity is File) {
          await entity.delete();
        }
      }
    } catch (_) {}
  }
}