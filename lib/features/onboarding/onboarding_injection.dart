import 'package:get_it/get_it.dart';
import 'onboarding.dart';
import '../admin/admin.dart';

/// ============================================================================
/// DEPENDENCY INJECTION (DI) — ONBOARDING FEATURE
/// ============================================================================
/// Sử dụng thư viện `GetIt` (Service Locator) để quản lý các phụ thuộc (dependencies)
/// theo đúng nguyên lý Clean Architecture:
///   1. Presentation (BLoCs): Đăng ký dạng Factory (tạo mới mỗi lần gọi).
///   2. Domain (Use Cases): Đăng ký dạng LazySingleton (chỉ tạo 1 instance khi cần).
///   3. Data (Repositories & Data Sources): Đăng ký dạng LazySingleton.
/// ============================================================================
void initOnboardingDependencies(GetIt sl) {
  // --------------------------------------------------------------------------
  // 1. PRESENTATION LAYER — BLoCs
  // --------------------------------------------------------------------------
  // RegisterFactory: Mỗi lần gọi sl<OnboardingBloc>(), GetIt sẽ tạo ra một BLoC instance mới.
  // Điều này giúp tránh việc dùng chung state cũ khi user quay lại màn hình Onboarding.
  sl.registerFactory(
    () => OnboardingBloc(
      createFamily: sl(),
      verifyInviteCode: sl(),
      joinFamily: sl(),
    ),
  );

  // --------------------------------------------------------------------------
  // 2. DOMAIN LAYER — USE CASES
  // --------------------------------------------------------------------------
  // RegisterLazySingleton: Chỉ khởi tạo khi có nơi đầu tiên gọi đến (Lazy),
  // và giữ nguyên 1 instance duy nhất trong toàn bộ ứng dụng (Singleton).
  sl.registerLazySingleton(() => CreateFamily(sl()));
  sl.registerLazySingleton(() => VerifyInviteCode(sl()));
  sl.registerLazySingleton(() => JoinFamily(sl()));
  sl.registerLazySingleton(() => GetPendingRequests(sl()));
  sl.registerLazySingleton(() => ApproveRequest(sl()));
  sl.registerLazySingleton(() => RejectRequest(sl()));

  // --------------------------------------------------------------------------
  // 3. DATA LAYER — REPOSITORIES (Abstraction -> Implementation)
  // --------------------------------------------------------------------------
  // Đăng ký Interface (OnboardingRepository) ánh xạ tới Implementation (OnboardingRepositoryImpl).
  // Giúp các UseCase chỉ phụ thuộc vào Interface (Inversion of Control - IoC).
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(remoteDataSource: sl()),
  );

  // --------------------------------------------------------------------------
  // 4. DATA LAYER — DATA SOURCES
  // --------------------------------------------------------------------------
  // Remote Data Source thực hiện gọi REST API thông qua Dio Client (đã được cấu hình global).
  sl.registerLazySingleton<OnboardingRemoteDataSource>(
    () => OnboardingRemoteDataSourceImpl(dio: sl()),
  );
}

