import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'auth.dart';

void initAuthDependencies(GetIt sl) {
  // External
  if (!sl.isRegistered<FlutterSecureStorage>()) {
    sl.registerLazySingleton(() => const FlutterSecureStorage());
  }

  // BLoC
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

  // Use Cases
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

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      firebaseAuth: sl(),
      googleSignIn: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      dio: sl(),
      firebaseAuth: sl(),
      googleSignIn: sl(),
    ),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl()),
  );
}
