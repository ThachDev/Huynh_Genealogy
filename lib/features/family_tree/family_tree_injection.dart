import 'package:get_it/get_it.dart';
import 'family_tree.dart';
import '../admin/admin.dart';
import '../onboarding/onboarding.dart';
import '../../core/domain/usecase/get_family_detail.dart';
import '../../core/data/repository/logout_cache_cleaner.dart';
import 'data/source/family_tree_local_data_source.dart';

void initFamilyTreeDependencies(GetIt sl) {
  // BLoC
  sl.registerFactory(
    () => FamilyTreeBloc(
      getMembers: sl(),
      getBranches: sl(),
      getFamilyDetail: sl(),
      getCachedMembers: sl(),
      getCachedBranches: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetMembers(sl()));
  sl.registerLazySingleton(() => GetBranches(sl()));
  sl.registerLazySingleton(() => GetCachedMembers(sl()));
  sl.registerLazySingleton(() => GetCachedBranches(sl()));
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
  sl.registerLazySingleton(() => GetTrashedMembers(sl()));
  sl.registerLazySingleton(() => RestoreMember(sl()));
  sl.registerLazySingleton(() => PurgeTrash(sl()));
  sl.registerLazySingleton(() => GetAuditLogs(sl()));

  // Repository
  sl.registerLazySingleton<FamilyTreeRepository>(
    () => FamilyTreeRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data Source
  sl.registerLazySingleton<FamilyTreeRemoteDataSource>(
    () => FamilyTreeRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<FamilyTreeLocalDataSource>(
    () => FamilyTreeLocalDataSource(),
  );

  // Khi đăng xuất, xoá toàn bộ cache cây gia phả trên máy.
  LogoutCacheCleaner.register(
    () => sl<FamilyTreeLocalDataSource>().clearAll(),
  );
}
