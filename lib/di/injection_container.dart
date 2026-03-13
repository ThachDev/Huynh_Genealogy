import 'package:app_family_tree/features/family_tree/data/source/family_remote_data_source_impl.dart';
import 'package:app_family_tree/features/family_tree/domain/usecase/get_branches_usecase.dart';
import 'package:get_it/get_it.dart';

// Features
// Data

import '../features/family_tree/data/source/family_data_source.dart';
import '../features/family_tree/data/repository/family_repository_impl.dart';

// Domain
import '../features/family_tree/domain/repositories/family_repository.dart';
import '../features/family_tree/domain/usecase/get_members_usecase.dart';
import '../features/family_tree/domain/usecase/get_member_by_id_usecase.dart';
import '../features/family_tree/domain/usecase/save_member_usecase.dart';
import '../features/family_tree/domain/usecase/delete_member_usecase.dart';
import '../features/family_tree/domain/usecase/save_branch_usecase.dart';

// Application
import '../features/family_tree/presentation/member/bloc/member_form_bloc.dart';
import '../features/family_tree/presentation/tree/bloc/tree_bloc.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // ─── BLoCs (factory – tạo mới mỗi lần dùng) ──────────────────────────────
  sl.registerFactory(
    () => TreeBloc(getMembersUseCase: sl(), getBranchesUseCase: sl()),
  );

  sl.registerFactory(
    () => MemberFormBloc(
      getMemberByIdUseCase: sl(),
      saveMemberUseCase: sl(),
      deleteMemberUseCase: sl(),
    ),
  );

  // ─── Use Cases ────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetMembersUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetMemberByIdUseCase(repository: sl()));
  sl.registerLazySingleton(() => SaveMemberUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteMemberUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetBranchesUseCase(repository: sl()));
  sl.registerLazySingleton(() => SaveBranchUseCase(repository: sl()));

  // ─── Repository ───────────────────────────────────────────────────────────
  sl.registerLazySingleton<FamilyRepository>(
    () => FamilyRepositoryImpl(dataSource: sl()),
  );

  // ─── Data Sources ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<FamilyDataSource>(
    // Thay đổi ở đây để chuyển đổi giữa Local và Remote
    // () => FamilyLocalDataSourceImpl(),
    () => FamilyRemoteDataSourceImpl(),
  );

  // ─── External ─────────────────────────────────────────────────────────────
}
