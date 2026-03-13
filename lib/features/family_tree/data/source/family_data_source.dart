import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/features/family_tree/data/model/branch_model.dart';
import 'package:app_family_tree/features/family_tree/data/model/member_model.dart';

abstract class FamilyDataSource {
  Future<List<MemberModel>> getMembers({int? branchId});
  Future<MemberModel> getMemberById(int id);
  Future<MemberModel> saveMember(MemberModel member);
  Future<bool> deleteMember(int id);

  Future<List<BranchModel>> getBranches();
  Future<BranchModel> getBranchById(int id);
  Future<BranchModel> saveBranch(BranchModel branch);
  Future<bool> deleteBranch(int id);
}

class FamilyLocalDataSourceImpl implements FamilyDataSource {
  // In-memory storage for now.
  // In a real app, this would use Hive, Sqflite, or SharedPrefs.
  final List<BranchModel> _branches = [
    const BranchModel(
      id: 1,
      name: 'Họ Huỳnh (Gốc)',
      description: 'Dòng họ gốc',
      founderName: 'Huỳnh Văn Tổ',
      foundingYear: 1900,
      region: 'Việt Nam',
    ),
  ];

  final List<MemberModel> _members = [
    const MemberModel(
      id: 1,
      fullName: 'Huỳnh Văn Tổ',
      gender: Gender.male,
      dateOfBirth: '1900-01-01',
      isAlive: false,
      maritalStatus: MaritalStatus.married,
      generation: 1,
      branchId: 1,
      notes: 'Thủy tổ',
    ),
  ];

  @override
  Future<List<MemberModel>> getMembers({int? branchId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (branchId == null) return _members;
    return _members.where((m) => m.branchId == branchId).toList();
  }

  @override
  Future<MemberModel> getMemberById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _members.firstWhere((m) => m.id == id);
  }

  @override
  Future<MemberModel> saveMember(MemberModel member) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (member.id == 0) {
      final newId = _members.isEmpty
          ? 1
          : _members.map((m) => m.id).reduce((a, b) => a > b ? a : b) + 1;
      final newMember = MemberModel(
        id: newId,
        fullName: member.fullName,
        gender: member.gender,
        dateOfBirth: member.dateOfBirth,
        placeOfBirth: member.placeOfBirth,
        isAlive: member.isAlive,
        dateOfDeath: member.dateOfDeath,
        maritalStatus: member.maritalStatus,
        generation: member.generation,
        branchId: member.branchId,
        branchName: member.branchId != null
            ? _branches.firstWhere((b) => b.id == member.branchId).name
            : null,
        parentId: member.parentId,
        spouseId: member.spouseId,
        notes: member.notes,
        avatarUrl: member.avatarUrl,
      );
      _members.add(newMember);
      return newMember;
    } else {
      final index = _members.indexWhere((m) => m.id == member.id);
      if (index != -1) {
        _members[index] = member;
        return member;
      }
      throw Exception('Không tìm thấy thành viên');
    }
  }

  @override
  Future<bool> deleteMember(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _members.removeWhere((m) => m.id == id);
    return true;
  }

  @override
  Future<List<BranchModel>> getBranches() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _branches;
  }

  @override
  Future<BranchModel> getBranchById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _branches.firstWhere((b) => b.id == id);
  }

  @override
  Future<BranchModel> saveBranch(BranchModel branch) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (branch.id == 0) {
      final newId = _branches.isEmpty
          ? 1
          : _branches.map((b) => b.id).reduce((a, b) => a > b ? a : b) + 1;
      final newBranch = BranchModel(
        id: newId,
        name: branch.name,
        description: branch.description,
        founderName: branch.founderName,
        foundingYear: branch.foundingYear,
        region: branch.region,
      );
      _branches.add(newBranch);
      return newBranch;
    } else {
      final index = _branches.indexWhere((b) => b.id == branch.id);
      if (index != -1) {
        _branches[index] = branch;
        return branch;
      }
      throw Exception('Không tìm thấy chi/nhánh');
    }
  }

  @override
  Future<bool> deleteBranch(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _branches.removeWhere((b) => b.id == id);
    return true;
  }
}
