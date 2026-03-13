import 'package:app_family_tree/features/family_tree/data/model/branch_model.dart';
import 'package:app_family_tree/features/family_tree/data/model/member_model.dart';
import 'package:app_family_tree/features/family_tree/data/source/family_data_source.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';

class FamilyRemoteDataSourceImpl implements FamilyDataSource {
  // Giả lập dữ liệu từ API
  final List<BranchModel> _mockBranches = [
    const BranchModel(
      id: 1,
      name: 'Họ Huỳnh (Gốc - API)',
      description: 'Dòng họ gốc từ Remote API',
      founderName: 'Huỳnh Văn Tổ',
      foundingYear: 1900,
      region: 'Việt Nam',
    ),
  ];

  final List<MemberModel> _mockMembers = [
    const MemberModel(
      id: 1,
      fullName: 'Huỳnh Văn Tổ (API)',
      gender: Gender.male,
      dateOfBirth: '1900-01-01',
      isAlive: false,
      maritalStatus: MaritalStatus.married,
      generation: 1,
      branchId: 1,
      notes: 'Thủy tổ từ API',
    ),
  ];

  @override
  Future<List<MemberModel>> getMembers({int? branchId}) async {
    await Future.delayed(const Duration(seconds: 1)); // Giả lập độ trễ mạng
    if (branchId == null) return _mockMembers;
    return _mockMembers.where((m) => m.branchId == branchId).toList();
  }

  @override
  Future<MemberModel> getMemberById(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockMembers.firstWhere((m) => m.id == id);
  }

  @override
  Future<MemberModel> saveMember(MemberModel member) async {
    await Future.delayed(const Duration(seconds: 1));
    // Logic lưu tạm thời trên Mock
    return member;
  }

  @override
  Future<bool> deleteMember(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  @override
  Future<List<BranchModel>> getBranches() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockBranches;
  }

  @override
  Future<BranchModel> getBranchById(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockBranches.firstWhere((b) => b.id == id);
  }

  @override
  Future<BranchModel> saveBranch(BranchModel branch) async {
    await Future.delayed(const Duration(seconds: 1));
    return branch;
  }

  @override
  Future<bool> deleteBranch(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
