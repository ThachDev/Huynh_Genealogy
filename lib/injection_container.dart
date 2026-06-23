import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';

// Features (Encapsulated Entry Points)
import 'features/auth/auth.dart';
import 'features/family/family.dart';
import 'features/family_tree/family_tree.dart';

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
      registerWithEmail: sl(),
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
  sl.registerLazySingleton(() => RegisterWithEmail(sl()));

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

  sl.registerLazySingleton<TreeRepository>(
    () => TreeRepositoryImpl(remoteDataSource: sl()),
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
    () => FamilyRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<TreeRemoteDataSource>(
    () => TreeRemoteDataSourceImpl(dio: sl()),
  );

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
