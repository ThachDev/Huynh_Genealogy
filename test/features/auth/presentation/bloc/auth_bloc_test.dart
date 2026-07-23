import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giatocviet/core/domain/entity/user_entity.dart';
import 'package:giatocviet/core/usecases/usecase.dart';
import 'package:giatocviet/features/auth/domain/repository/auth_repository.dart';
import 'package:giatocviet/features/auth/domain/usecase/cache_credentials.dart';
import 'package:giatocviet/features/auth/domain/usecase/clear_credentials.dart';
import 'package:giatocviet/features/auth/domain/usecase/forgot_password.dart';
import 'package:giatocviet/features/auth/domain/usecase/get_cached_credentials.dart';
import 'package:giatocviet/features/auth/domain/usecase/get_cached_user.dart';
import 'package:giatocviet/features/auth/domain/usecase/login_with_email.dart';
import 'package:giatocviet/features/auth/domain/usecase/login_with_google.dart';
import 'package:giatocviet/features/auth/domain/usecase/logout.dart';
import 'package:giatocviet/features/auth/domain/usecase/refresh_profile.dart';
import 'package:giatocviet/features/auth/domain/usecase/register_with_email.dart';
import 'package:giatocviet/features/auth/domain/usecase/reset_password_with_otp.dart';
import 'package:giatocviet/features/auth/domain/usecase/verify_otp.dart';
import 'package:giatocviet/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:giatocviet/features/auth/presentation/bloc/auth_event.dart';
import 'package:giatocviet/features/auth/presentation/bloc/auth_state.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginWithGoogle extends Mock implements LoginWithGoogle {}
class MockLoginWithEmail extends Mock implements LoginWithEmail {}
class MockLogout extends Mock implements Logout {}
class MockGetCachedUser extends Mock implements GetCachedUser {}
class MockRegisterWithEmail extends Mock implements RegisterWithEmail {}
class MockGetCachedCredentials extends Mock implements GetCachedCredentials {}
class MockCacheCredentials extends Mock implements CacheCredentials {}
class MockClearCredentials extends Mock implements ClearCredentials {}
class MockForgotPassword extends Mock implements ForgotPassword {}
class MockVerifyOtp extends Mock implements VerifyOtp {}
class MockResetPasswordWithOtp extends Mock implements ResetPasswordWithOtp {}
class MockAuthRepository extends Mock implements AuthRepository {}
class MockRefreshProfile extends Mock implements RefreshProfile {}

void main() {
  late AuthBloc authBloc;
  late MockLoginWithGoogle mockLoginWithGoogle;
  late MockLoginWithEmail mockLoginWithEmail;
  late MockLogout mockLogout;
  late MockGetCachedUser mockGetCachedUser;
  late MockRegisterWithEmail mockRegisterWithEmail;
  late MockGetCachedCredentials mockGetCachedCredentials;
  late MockCacheCredentials mockCacheCredentials;
  late MockClearCredentials mockClearCredentials;
  late MockForgotPassword mockForgotPassword;
  late MockVerifyOtp mockVerifyOtp;
  late MockResetPasswordWithOtp mockResetPasswordWithOtp;
  late MockAuthRepository mockAuthRepository;
  late MockRefreshProfile mockRefreshProfile;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const LoginWithEmailParams(email: '', password: ''));
  });

  setUp(() {
    mockLoginWithGoogle = MockLoginWithGoogle();
    mockLoginWithEmail = MockLoginWithEmail();
    mockLogout = MockLogout();
    mockGetCachedUser = MockGetCachedUser();
    mockRegisterWithEmail = MockRegisterWithEmail();
    mockGetCachedCredentials = MockGetCachedCredentials();
    mockCacheCredentials = MockCacheCredentials();
    mockClearCredentials = MockClearCredentials();
    mockForgotPassword = MockForgotPassword();
    mockVerifyOtp = MockVerifyOtp();
    mockResetPasswordWithOtp = MockResetPasswordWithOtp();
    mockAuthRepository = MockAuthRepository();
    mockRefreshProfile = MockRefreshProfile();

    authBloc = AuthBloc(
      loginWithGoogle: mockLoginWithGoogle,
      loginWithEmail: mockLoginWithEmail,
      logout: mockLogout,
      getCachedUser: mockGetCachedUser,
      registerWithEmail: mockRegisterWithEmail,
      getCachedCredentials: mockGetCachedCredentials,
      cacheCredentials: mockCacheCredentials,
      clearCredentials: mockClearCredentials,
      forgotPassword: mockForgotPassword,
      verifyOtp: mockVerifyOtp,
      resetPasswordWithOtp: mockResetPasswordWithOtp,
      authRepository: mockAuthRepository,
      refreshProfile: mockRefreshProfile,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  const tUser = UserEntity(id: 1, fullName: 'Huỳnh Văn A', email: 'test@giatoc.vn');

  test('trạng thái ban đầu của AuthBloc phải là AuthInitial', () {
    expect(authBloc.state, isA<AuthInitial>());
  });

  test('nên emit [AuthLoading, Authenticated] khi AuthCheckRequested thành công tìm thấy user', () async {
    // Arrange
    when(() => mockGetCachedUser(any()))
        .thenAnswer((_) async => const Right(tUser));

    // Assert Later
    final expectedStates = [
      isA<AuthLoading>(),
      isA<Authenticated>().having((s) => s.user, 'user', equals(tUser)),
    ];
    expectLater(authBloc.stream, emitsInOrder(expectedStates));

    // Act
    authBloc.add(AuthCheckRequested());
  });

  test('nên emit [AuthLoading, Unauthenticated] khi AuthCheckRequested không tìm thấy user cached', () async {
    // Arrange
    when(() => mockGetCachedUser(any()))
        .thenAnswer((_) async => const Right(null));

    // Assert Later
    final expectedStates = [
      isA<AuthLoading>(),
      isA<Unauthenticated>(),
    ];
    expectLater(authBloc.stream, emitsInOrder(expectedStates));

    // Act
    authBloc.add(AuthCheckRequested());
  });

  test('nên emit [Unauthenticated] khi AuthLogoutRequested thành công', () async {
    // Arrange
    when(() => mockLogout(any()))
        .thenAnswer((_) async => const Right(null));

    // Assert Later
    final expectedStates = [
      isA<AuthLoading>(),
      isA<Unauthenticated>(),
    ];
    expectLater(authBloc.stream, emitsInOrder(expectedStates));

    // Act
    authBloc.add(AuthLogoutRequested());
  });
}
