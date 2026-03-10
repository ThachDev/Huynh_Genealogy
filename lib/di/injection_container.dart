import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../services/dio_client.dart';

// Features
// Data
import '../features/family_tree/data/source/family_mock_data_source.dart';
import '../features/family_tree/data/source/family_remote_data_source.dart';
import '../features/family_tree/data/repository/family_repository_impl.dart';

// Domain
import '../features/family_tree/domain/repositories/family_repository.dart';
import '../features/family_tree/domain/usecase/delete_member.dart';
import '../features/family_tree/domain/usecase/get_branches.dart';
import '../features/family_tree/domain/usecase/get_members.dart';
import '../features/family_tree/domain/usecase/save_member.dart';

// Application
import '../features/family_tree/presentation/member/bloc/member_form_bloc.dart';
import '../features/family_tree/presentation/tree/bloc/tree_bloc.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // ─── BLoCs (factory – tạo mới mỗi lần dùng) ──────────────────────────────
  sl.registerFactory(() => TreeBloc(getMembers: sl(), getBranches: sl()));

  sl.registerFactory(
    () =>
        MemberFormBloc(getMembers: sl(), saveMember: sl(), deleteMember: sl()),
  );

  // ─── Use Cases ────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetMembers(sl()));
  sl.registerLazySingleton(() => GetBranches(sl()));
  sl.registerLazySingleton(() => SaveMember(sl()));
  sl.registerLazySingleton(() => DeleteMember(sl()));

  // ─── Repository ───────────────────────────────────────────────────────────
  sl.registerLazySingleton<FamilyRepository>(
    () => FamilyRepositoryImpl(remoteDataSource: sl()),
  );

  // ─── Data Sources ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<FamilyRemoteDataSource>(
    () => FamilyMockDataSourceImpl(),
  );

  // sl.registerLazySingleton<FamilyRemoteDataSource>(
  //   () => FamilyRemoteDataSourceImpl(dio: sl()),
  // );

  // ─── External ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton<Dio>(() => DioClient.instance);
}
