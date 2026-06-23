import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';

// Data
import 'data/datasources/family_mock_data_source.dart';
import 'data/datasources/family_remote_data_source.dart';
import 'data/repositories/family_repository_impl.dart';
import 'data/datasources/auth_local_data_source.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';

// Domain
import 'domain/repositories/family_repository.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/delete_member.dart';
import 'domain/usecases/get_branches.dart';
import 'domain/usecases/get_members.dart';
import 'domain/usecases/save_member.dart';
import 'domain/usecases/auth/get_cached_user.dart';
import 'domain/usecases/auth/login_with_google.dart';
import 'domain/usecases/auth/logout.dart';
import 'domain/usecases/family/create_family.dart';
import 'domain/usecases/family/verify_invite_code.dart';
import 'domain/usecases/family/join_family.dart';
import 'domain/usecases/family/get_pending_requests.dart';
import 'domain/usecases/family/approve_request.dart';

// Presentation
import 'presentation/bloc/member_form/member_form_bloc.dart';
import 'presentation/bloc/tree/tree_bloc.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/onboarding/onboarding_bloc.dart';

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

  sl.registerFactory(
    () => AuthBloc(
      loginWithGoogle: sl(),
      logout: sl(),
      getCachedUser: sl(),
    ),
  );

  sl.registerFactory(
    () => OnboardingBloc(
      createFamily: sl(),
      verifyInviteCode: sl(),
      joinFamily: sl(),
      getPendingRequests: sl(),
      approveRequest: sl(),
    ),
  );

  // ─── Use Cases ────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetMembers(sl()));
  sl.registerLazySingleton(() => GetBranches(sl()));
  sl.registerLazySingleton(() => SaveMember(sl()));
  sl.registerLazySingleton(() => DeleteMember(sl()));

  // Auth Use Cases
  sl.registerLazySingleton(() => LoginWithGoogle(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetCachedUser(sl()));

  // Family Use Cases
  sl.registerLazySingleton(() => CreateFamily(sl()));
  sl.registerLazySingleton(() => VerifyInviteCode(sl()));
  sl.registerLazySingleton(() => JoinFamily(sl()));
  sl.registerLazySingleton(() => GetPendingRequests(sl()));
  sl.registerLazySingleton(() => ApproveRequest(sl()));

  // ─── Repository ───────────────────────────────────────────────────────────
  sl.registerLazySingleton<FamilyRepository>(
    () => FamilyRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      firebaseAuth: sl(),
      googleSignIn: sl(),
    ),
  );

  // ─── Data Sources ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<FamilyRemoteDataSource>(
    () => FamilyMockDataSourceImpl(),
  );

  // sl.registerLazySingleton<FamilyRemoteDataSource>(
  //   () => FamilyRemoteDataSourceImpl(dio: sl()),
  // );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      dio: sl(),
      firebaseAuth: sl(),
      googleSignIn: sl(),
    ),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ─── External ─────────────────────────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton<Dio>(() => DioClient.instance);
}
