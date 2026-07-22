import 'package:get_it/get_it.dart';
import 'family_tree.dart';
import '../admin/admin.dart';
import '../onboarding/onboarding.dart';
import '../../core/domain/usecase/get_family_detail.dart';

void initFamilyTreeDependencies(GetIt sl) {
  // BLoC
  sl.registerFactory(
    () => FamilyTreeBloc(
      getMembers: sl(),
      getBranches: sl(),
      getFamilyDetail: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetMembers(sl()));
  sl.registerLazySingleton(() => GetBranches(sl()));
  sl.registerLazySingleton(() => GetFamilyDetail(sl()));
  sl.registerLazySingleton(() => SaveBranch(sl()));
  sl.registerLazySingleton(() => DeleteBranch(sl()));
  sl.registerLazySingleton(() => UpdateFamily(sl()));
  sl.registerLazySingleton(() => GetMemberDetail(sl()));
  sl.registerLazySingleton(() => GetApprovedMembers(sl()));
  sl.registerLazySingleton(() => UpdateMemberRole(sl()));
  sl.registerLazySingleton(() => LinkMemberToUser(sl()));
  sl.registerLazySingleton(() => DeleteFamily(sl()));
  sl.registerLazySingleton(() => TransferOwnership(sl()));

  // Repository
  sl.registerLazySingleton<FamilyTreeRepository>(
    () => FamilyTreeRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<FamilyTreeRemoteDataSource>(
    () => FamilyTreeRemoteDataSourceImpl(dio: sl()),
  );
}
