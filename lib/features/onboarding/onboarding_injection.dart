import 'package:get_it/get_it.dart';
import 'onboarding.dart';
import '../admin/admin.dart';

void initOnboardingDependencies(GetIt sl) {
  // BLoC
  sl.registerFactory(
    () => OnboardingBloc(
      createFamily: sl(),
      verifyInviteCode: sl(),
      joinFamily: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => CreateFamily(sl()));
  sl.registerLazySingleton(() => VerifyInviteCode(sl()));
  sl.registerLazySingleton(() => JoinFamily(sl()));
  sl.registerLazySingleton(() => GetPendingRequests(sl()));
  sl.registerLazySingleton(() => ApproveRequest(sl()));
  sl.registerLazySingleton(() => RejectRequest(sl()));

  // Repository
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<OnboardingRemoteDataSource>(
    () => OnboardingRemoteDataSourceImpl(dio: sl()),
  );
}
