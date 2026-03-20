import 'package:app_family_tree/constants/app_constants.dart';
import 'package:app_family_tree/core/logger/app_log_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// Branch Feature
import 'package:app_family_tree/features/branch/data/repositories/branch_repository_impl.dart';
import 'package:app_family_tree/features/branch/data/sources/branch_api_service.dart';
import 'package:app_family_tree/features/branch/domain/repositories/branch_repository.dart';
import 'package:app_family_tree/features/branch/domain/usecase/get_branches_usecase.dart';
import 'package:app_family_tree/features/branch/domain/usecase/save_branch_usecase.dart';
import 'package:app_family_tree/features/branch/presentation/bloc/branch_bloc.dart';

// Member Feature
import 'package:app_family_tree/features/member/data/repositories/member_repository_impl.dart';
import 'package:app_family_tree/features/member/data/sources/member_api_service.dart';
import 'package:app_family_tree/features/member/domain/repositories/member_repository.dart';
import 'package:app_family_tree/features/member/domain/usecase/delete_member_usecase.dart';
import 'package:app_family_tree/features/member/domain/usecase/get_member_by_id_usecase.dart';
import 'package:app_family_tree/features/member/domain/usecase/get_members_usecase.dart';
import 'package:app_family_tree/features/member/domain/usecase/save_member_usecase.dart';
import 'package:app_family_tree/features/member/presentation/bloc/member_bloc.dart';

// Tree Feature
import 'package:app_family_tree/features/tree/presentation/bloc/tree_bloc.dart';

// Settings & Shared
import 'package:app_family_tree/features/settings/presentation/language/bloc/language_bloc.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // ─── BLoCs (factory – tạo mới mỗi lần dùng) ──────────────────────────────
  sl.registerFactory(
    () => TreeBloc(getMembersUseCase: sl(), getBranchesUseCase: sl()),
  );

  sl.registerFactory(
    () => MemberBloc(
      getMemberByIdUseCase: sl(),
      saveMemberUseCase: sl(),
      deleteMemberUseCase: sl(),
    ),
  );

  sl.registerFactory(() => BranchBloc(saveBranchUseCase: sl()));

  sl.registerLazySingleton(() => LanguageBloc());

  // ─── Use Cases ────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetMembersUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetMemberByIdUseCase(repository: sl()));
  sl.registerLazySingleton(() => SaveMemberUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteMemberUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetBranchesUseCase(repository: sl()));
  sl.registerLazySingleton(() => SaveBranchUseCase(repository: sl()));

  // ─── Repository ───────────────────────────────────────────────────────────
  sl.registerLazySingleton<BranchRepository>(
    () => BranchRepositoryImpl(apiService: sl()),
  );
  sl.registerLazySingleton<MemberRepository>(
    () => MemberRepositoryImpl(apiService: sl()),
  );

  // ─── Services (Data Layer) ────────────────────────────────────────────────
  sl.registerLazySingleton(() => BranchApiService(sl()));
  sl.registerLazySingleton(() => MemberApiService(sl()));

  // ─── External ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton(
    () =>
        Dio(
            BaseOptions(
              baseUrl: AppConstants.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          )
          ..interceptors.add(AppLogInterceptor()),
  );
}
