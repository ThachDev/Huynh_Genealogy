import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';

// Features (Encapsulated Entry Points)
import 'features/auth/auth.dart';
import 'features/onboarding/onboarding.dart';
import 'features/admin/admin.dart';
import 'features/family_tree/family_tree.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // ─── BLoCs (factory – tạo mới mỗi lần dùng) ──────────────────────────────
  sl.registerFactory(
    () => FamilyTreeBloc(
      getMembers: sl(),
      getBranches: sl(),
    ),
  );

  sl.registerFactory(
    () => AdminMemberFormBloc(
      getMembers: sl(),
      getBranches: sl(),
      saveMember: sl(),
      deleteMember: sl(),
    ),
  );

  sl.registerFactory(
    () => AdminPendingRequestsBloc(
      getPendingRequests: sl(),
      approveRequest: sl(),
      rejectRequest: sl(),
      getFamilyDetail: sl(),
    ),
  );

  sl.registerFactory(
    () => AdminBranchFormBloc(
      saveBranch: sl(),
      deleteBranch: sl(),
    ),
  );

  sl.registerFactory(
    () => AdminMemberRolesBloc(
      getApprovedMembers: sl(),
      updateMemberRole: sl(),
    ),
  );

  sl.registerFactory(
    () => AdminDissolveClanBloc(
      deleteFamily: sl(),
    ),
  );

  sl.registerFactory(
    () => AdminTransferOwnershipBloc(
      getApprovedMembers: sl(),
      transferOwnership: sl(),
    ),
  );

  sl.registerFactory(
    () => AuthBloc(
      loginWithGoogle: sl(),
      loginWithEmail: sl(),
      logout: sl(),
      getCachedUser: sl(),
      registerWithEmail: sl(),
      getCachedCredentials: sl(),
      cacheCredentials: sl(),
      clearCredentials: sl(),
      forgotPassword: sl(),
      verifyOtp: sl(),
      resetPasswordWithOtp: sl(),
      authRepository: sl(),
      refreshProfile: sl(),
    ),
  );

  sl.registerFactory(
    () => OnboardingBloc(
      createFamily: sl(),
      verifyInviteCode: sl(),
      joinFamily: sl(),
    ),
  );

  // ─── Use Cases ────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetMembers(sl()));
  sl.registerLazySingleton(() => GetBranches(sl()));
  sl.registerLazySingleton(() => SaveMember(sl()));
  sl.registerLazySingleton(() => DeleteMember(sl()));

  // Auth Use Cases
  sl.registerLazySingleton(() => LoginWithGoogle(sl()));
  sl.registerLazySingleton(() => LoginWithEmail(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetCachedUser(sl()));
  sl.registerLazySingleton(() => RegisterWithEmail(sl()));
  sl.registerLazySingleton(() => GetCachedCredentials(sl()));
  sl.registerLazySingleton(() => CacheCredentials(sl()));
  sl.registerLazySingleton(() => ClearCredentials(sl()));
  sl.registerLazySingleton(() => ForgotPassword(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => RefreshProfile(sl()));
  sl.registerLazySingleton(() => ResetPasswordWithOtp(sl()));

  // Family Use Cases
  sl.registerLazySingleton(() => CreateFamily(sl()));
  sl.registerLazySingleton(() => VerifyInviteCode(sl()));
  sl.registerLazySingleton(() => JoinFamily(sl()));
  sl.registerLazySingleton(() => GetPendingRequests(sl()));
  sl.registerLazySingleton(() => ApproveRequest(sl()));
  sl.registerLazySingleton(() => RejectRequest(sl()));
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

  // ─── Repository ───────────────────────────────────────────────────────────
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<FamilyTreeRepository>(
    () => FamilyTreeRepositoryImpl(remoteDataSource: sl()),
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
  sl.registerLazySingleton<OnboardingRemoteDataSource>(
    () => OnboardingRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<FamilyTreeRemoteDataSource>(
    () => FamilyTreeRemoteDataSourceImpl(dio: sl()),
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
