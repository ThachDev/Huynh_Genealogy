import 'package:flutter_test/flutter_test.dart';
import 'package:giatocviet/features/family_tree/domain/entities/member_entity.dart';
import 'package:giatocviet/features/family_tree/domain/services/kinship_calculator_service.dart';

void main() {
  late KinshipCalculatorService service;

  setUp(() {
    service = KinshipCalculatorService();
  });

  group('KinshipCalculatorService Tests', () {
    // Xây dựng cây mẫu:
    // Cụ Tổ: Id 1 (Nam, Gen 1)
    // Con 1: Id 2 (Bác Cả, Nam, Gen 2, Sinh 1950)
    // Con 2: Id 3 (Chú Hai, Nam, Gen 2, Sinh 1955)
    // Con của Bác Cả: Id 4 (Anh họ, Nam, Gen 3, Sinh 1980)
    // Con của Chú Hai: Id 5 (Bản thân, Nam, Gen 3, Sinh 1985)
    // Con của Bản thân: Id 6 (Con trai, Nam, Gen 4, Sinh 2010)
    // Vợ của Chú Hai: Id 7 (Thím, Nữ, Gen 2, spouseId: 3)
    const rootAncestor = MemberEntity(
      id: 1,
      fullName: 'Nguyễn Văn Tổ',
      gender: Gender.male,
      generation: 1,
      dateOfBirth: '1920-01-01',
    );

    const seniorUncle = MemberEntity(
      id: 2,
      fullName: 'Nguyễn Văn Trưởng (Bác Cả)',
      gender: Gender.male,
      generation: 2,
      parentId: 1,
      dateOfBirth: '1950-01-01',
    );

    const father = MemberEntity(
      id: 3,
      fullName: 'Nguyễn Văn Thứ (Bố/Chú Hai)',
      gender: Gender.male,
      generation: 2,
      parentId: 1,
      spouseId: 7,
      dateOfBirth: '1955-01-01',
    );

    const mother = MemberEntity(
      id: 7,
      fullName: 'Trần Thị Mẹ (Thím)',
      gender: Gender.female,
      generation: 2,
      spouseId: 3,
      dateOfBirth: '1958-01-01',
    );

    const cousinSenior = MemberEntity(
      id: 4,
      fullName: 'Nguyễn Văn Anh (Con Bác Cả)',
      gender: Gender.male,
      generation: 3,
      parentId: 2,
      dateOfBirth: '1980-01-01',
    );

    const self = MemberEntity(
      id: 5,
      fullName: 'Nguyễn Văn Em (Bản Thân)',
      gender: Gender.male,
      generation: 3,
      parentId: 3,
      dateOfBirth: '1985-01-01',
    );

    const son = MemberEntity(
      id: 6,
      fullName: 'Nguyễn Văn Con',
      gender: Gender.male,
      generation: 4,
      parentId: 5,
      dateOfBirth: '2010-01-01',
    );

    final tree = [rootAncestor, seniorUncle, father, mother, cousinSenior, self, son];

    test('1. Kiểm tra chính bản thân mình', () {
      final res = service.calculate(
        fromMember: self,
        toMember: self,
        allMembers: tree,
      );

      expect(res.isSamePerson, isTrue);
      expect(res.fromCallsTo, 'Bản thân');
    });

    test('2. Kiểm tra quan hệ Trực hệ: Bố và Con', () {
      // Con gọi Bố
      final resChildToFather = service.calculate(
        fromMember: self,
        toMember: father,
        allMembers: tree,
      );
      expect(resChildToFather.fromCallsTo, 'Bố');
      expect(resChildToFather.toCallsFrom, 'Con trai');
      expect(resChildToFather.isDirectLineage, isTrue);

      // Bố gọi Con
      final resFatherToChild = service.calculate(
        fromMember: father,
        toMember: self,
        allMembers: tree,
      );
      expect(resFatherToChild.fromCallsTo, 'Con trai');
      expect(resFatherToChild.toCallsFrom, 'Bố');
    });

    test('3. Kiểm tra quan hệ Trực hệ: Ông nội và Cháu', () {
      final res = service.calculate(
        fromMember: self,
        toMember: rootAncestor,
        allMembers: tree,
      );
      expect(res.fromCallsTo, 'Ông nội');
      expect(res.toCallsFrom, 'Cháu');
      expect(res.isDirectLineage, isTrue);
      expect(res.generationDiff, 2);
    });

    test('4. Kiểm tra Vợ Chồng', () {
      final res = service.calculate(
        fromMember: father,
        toMember: mother,
        allMembers: tree,
      );
      expect(res.areSpouses, isTrue);
      expect(res.fromCallsTo, 'Vợ');
      expect(res.toCallsFrom, 'Chồng');
    });

    test('5. Kiểm tra Con chú con bác: Nhánh Bác vs Nhánh Chú', () {
      // Bản thân (con Chú) gọi Con Bác Cả -> Phải là "Anh họ"
      final res = service.calculate(
        fromMember: self,
        toMember: cousinSenior,
        allMembers: tree,
      );
      expect(res.fromCallsTo, 'Anh họ');
      expect(res.toCallsFrom, 'Em họ');
      expect(res.selfPronounFrom, 'Em');
      expect(res.selfPronounTo, 'Anh');
    });

    test('6. Kiểm tra quy tắc Bác ruột / Cháu ruột', () {
      // Bản thân gọi Bác Cả (anh của bố) -> "Bác trai ruột" / Bác ruột
      final res = service.calculate(
        fromMember: self,
        toMember: seniorUncle,
        allMembers: tree,
      );
      expect(res.fromCallsTo, contains('Bác'));
      expect(res.toCallsFrom, contains('Cháu'));
    });

    test('7. Kiểm tra Bác họ / Cháu họ (Con gọi cousinSenior)', () {
      // Con (Gen 4) gọi cousinSenior (Gen 3, con Bác Cả) -> Phải gọi là "Bác họ"
      final res = service.calculate(
        fromMember: son,
        toMember: cousinSenior,
        allMembers: tree,
      );
      expect(res.fromCallsTo, 'Bác họ');
      expect(res.toCallsFrom, 'Cháu họ');
      expect(res.generationDiff, 1);
    });
  });
}
