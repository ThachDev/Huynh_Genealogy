import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'core/network/dio_client.dart';

// Data
import 'data/datasources/family_mock_data_source.dart';
import 'data/datasources/family_remote_data_source.dart';
import 'data/repositories/family_repository_impl.dart';

// Domain
import 'domain/repositories/family_repository.dart';
import 'domain/usecases/delete_member.dart';
import 'domain/usecases/get_branches.dart';
import 'domain/usecases/get_members.dart';
import 'domain/usecases/save_member.dart';

// Presentation
import 'presentation/bloc/member_form/member_form_bloc.dart';
import 'presentation/bloc/tree/tree_bloc.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // ─── BLoCs (factory – tạo mới mỗi lần dùng) ──────────────────────────────
  sl.registerFactory(
    () => TreeBloc(
      getMembers: sl(),
      getBranches: sl(),
    ),
  );

  sl.registerFactory(
    () => MemberFormBloc(
      getMembers: sl(),
      saveMember: sl(),
      deleteMember: sl(),
    ),
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
