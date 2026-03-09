import '../../domain/entities/member_entity.dart';
import '../models/branch_model.dart';
import '../models/member_model.dart';
import 'family_remote_data_source.dart';

class FamilyMockDataSourceImpl implements FamilyRemoteDataSource {
  final List<BranchModel> _branches = [
    const BranchModel(
      id: 1,
      name: 'Chi Trưởng (Hà Nội)',
      description: 'Nhánh con cả, định cư tại Hà Nội từ năm 1950',
      founderName: 'Nguyễn Văn Thái',
      foundingYear: 1950,
      region: 'Hà Nội',
    ),
    const BranchModel(
      id: 2,
      name: 'Chi Thứ (Nam Định)',
      description: 'Nhánh con thứ, giữ nhà thờ tổ tại quê',
      founderName: 'Nguyễn Văn Bình',
      foundingYear: 1952,
      region: 'Nam Định',
    ),
    const BranchModel(
      id: 3,
      name: 'Chi Út (TP. HCM)',
      description: 'Nhánh con út, vào Nam lập nghiệp từ năm 1975',
      founderName: 'Nguyễn Văn An',
      foundingYear: 1975,
      region: 'TP. Hồ Chí Minh',
    ),
  ];

  final List<MemberModel> _members = [
    // Tông gia (Đời 1)
    const MemberModel(
      id: 1,
      fullName: 'Nguyễn Văn Khang',
      gender: Gender.male,
      dateOfBirth: '1900-01-01',
      isAlive: false,
      dateOfDeath: '1980-05-10',
      maritalStatus: MaritalStatus.widowed,
      generation: 1,
      notes: 'Cụ tổ khởi nghiệp',
    ),

    // Đời 2 (Các con của cụ Khang)
    const MemberModel(
      id: 2,
      fullName: 'Nguyễn Văn Thái',
      gender: Gender.male,
      dateOfBirth: '1925-03-15',
      isAlive: false,
      dateOfDeath: '2005-11-20',
      maritalStatus: MaritalStatus.married,
      generation: 2,
      parentId: 1,
      branchId: 1,
      branchName: 'Chi Trưởng (Hà Nội)',
      notes: 'Trưởng chi Hà Nội',
    ),
    const MemberModel(
      id: 3,
      fullName: 'Nguyễn Văn Bình',
      gender: Gender.male,
      dateOfBirth: '1928-06-20',
      isAlive: false,
      dateOfDeath: '2010-02-14',
      maritalStatus: MaritalStatus.married,
      generation: 2,
      parentId: 1,
      branchId: 2,
      branchName: 'Chi Thứ (Nam Định)',
    ),
    const MemberModel(
      id: 4,
      fullName: 'Nguyễn Thị Hoa',
      gender: Gender.female,
      dateOfBirth: '1932-08-10',
      isAlive: true,
      maritalStatus: MaritalStatus.married,
      generation: 2,
      parentId: 1,
    ),

    // Đời 3 (Con ông Thái - Chi 1)
    const MemberModel(
      id: 5,
      fullName: 'Nguyễn Văn Hùng',
      gender: Gender.male,
      dateOfBirth: '1955-12-01',
      isAlive: true,
      maritalStatus: MaritalStatus.married,
      generation: 3,
      parentId: 2,
      branchId: 1,
      branchName: 'Chi Trưởng (Hà Nội)',
    ),
    const MemberModel(
      id: 6,
      fullName: 'Nguyễn Thị Lan',
      gender: Gender.female,
      dateOfBirth: '1958-04-25',
      isAlive: true,
      maritalStatus: MaritalStatus.married,
      generation: 3,
      parentId: 2,
      branchId: 1,
      branchName: 'Chi Trưởng (Hà Nội)',
    ),

    // Đời 3 (Con ông Bình - Chi 2)
    const MemberModel(
      id: 7,
      fullName: 'Nguyễn Văn Minh',
      gender: Gender.male,
      dateOfBirth: '1960-09-12',
      isAlive: true,
      maritalStatus: MaritalStatus.married,
      generation: 3,
      parentId: 3,
      branchId: 2,
      branchName: 'Chi Thứ (Nam Định)',
    ),

    // Đời 4
    const MemberModel(
      id: 8,
      fullName: 'Nguyễn Văn Tuấn',
      gender: Gender.male,
      dateOfBirth: '1985-01-20',
      isAlive: true,
      maritalStatus: MaritalStatus.single,
      generation: 4,
      parentId: 5,
      branchId: 1,
      branchName: 'Chi Trưởng (Hà Nội)',
    ),
    const MemberModel(
      id: 9,
      fullName: 'Nguyễn Minh Anh',
      gender: Gender.female,
      dateOfBirth: '1990-05-30',
      isAlive: true,
      maritalStatus: MaritalStatus.single,
      generation: 4,
      parentId: 7,
      branchId: 2,
      branchName: 'Chi Thứ (Nam Định)',
    ),
  ];

  @override
  Future<List<MemberModel>> getMembers({int? branchId}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (branchId == null) return _members;
    return _members.where((m) => m.branchId == branchId).toList();
  }

  @override
  Future<MemberModel> getMemberById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _members.firstWhere((m) => m.id == id);
  }

  @override
  Future<MemberModel> saveMember(MemberModel member) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (member.id == 0) {
      final newMember = MemberModel(
        id: _members.isEmpty ? 1 : _members.map((m) => m.id).reduce((a, b) => a > b ? a : b) + 1,
        fullName: member.fullName,
        gender: member.gender,
        dateOfBirth: member.dateOfBirth,
        placeOfBirth: member.placeOfBirth,
        isAlive: member.isAlive,
        dateOfDeath: member.dateOfDeath,
        maritalStatus: member.maritalStatus,
        generation: member.generation,
        branchId: member.branchId,
        branchName: _branches.firstWhere((b) => b.id == member.branchId, orElse: () => _branches[0]).name,
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
    await Future.delayed(const Duration(milliseconds: 300));
    _members.removeWhere((m) => m.id == id);
    return true;
  }

  @override
  Future<List<BranchModel>> getBranches() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _branches;
  }

  @override
  Future<BranchModel> getBranchById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _branches.firstWhere((b) => b.id == id);
  }

  @override
  Future<BranchModel> saveBranch(BranchModel branch) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (branch.id == 0) {
      final newBranch = BranchModel(
        id: _branches.isEmpty ? 1 : _branches.map((b) => b.id).reduce((a, b) => a > b ? a : b) + 1,
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
    await Future.delayed(const Duration(milliseconds: 300));
    _branches.removeWhere((b) => b.id == id);
    return true;
  }
}
