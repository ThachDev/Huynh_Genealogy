import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecase/get_cached_user.dart';
import '../../domain/usecase/login_with_google.dart';
import '../../domain/usecase/login_with_email.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/usecase/logout.dart';
import '../../domain/usecase/register_with_email.dart';
import '../../domain/usecase/cache_credentials.dart';
import '../../domain/usecase/get_cached_credentials.dart';
import '../../domain/usecase/clear_credentials.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithGoogle loginWithGoogle;
  final LoginWithEmail loginWithEmail;
  final Logout logout;
  final GetCachedUser getCachedUser;
  final RegisterWithEmail registerWithEmail;
  final GetCachedCredentials getCachedCredentials;
  final CacheCredentials cacheCredentials;
  final ClearCredentials clearCredentials;
  final AuthRepository authRepository;

  AuthBloc({
    required this.loginWithGoogle,
    required this.loginWithEmail,
    required this.logout,
    required this.getCachedUser,
    required this.registerWithEmail,
    required this.getCachedCredentials,
    required this.cacheCredentials,
    required this.clearCredentials,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLoginWithEmailRequested>(_onAuthLoginWithEmailRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthUserUpdated>(_onAuthUserUpdated);
    on<AuthLoadCredentialsRequested>(_onAuthLoadCredentialsRequested);
    on<AuthCacheCredentialsRequested>(_onAuthCacheCredentialsRequested);
    on<AuthClearCredentialsRequested>(_onAuthClearCredentialsRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failureOrUser = await getCachedUser(NoParams());
    failureOrUser.fold(
      (failure) => emit(Unauthenticated()),
      (user) {
        if (user != null) {
          emit(Authenticated(user: user));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failureOrUser = await loginWithGoogle(NoParams());
    failureOrUser.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onAuthLoginWithEmailRequested(
    AuthLoginWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failureOrUser = await loginWithEmail(
      LoginWithEmailParams(
        email: event.email,
        password: event.password,
      ),
    );
    failureOrUser.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failureOrVoid = await logout(NoParams());
    failureOrVoid.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failureOrUser = await registerWithEmail(
      RegisterParams(
        email: event.email,
        password: event.password,
        role: event.role,
        fullName: event.fullName,
      ),
    );
    failureOrUser.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onAuthUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) async {
    // Cache the updated user data
    await authRepository.cacheUser(event.user);
    emit(Authenticated(user: event.user));
  }

  Future<void> _onAuthLoadCredentialsRequested(
    AuthLoadCredentialsRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getCachedCredentials(NoParams());
    result.fold(
      (_) => emit(const AuthCredentialsLoaded()),
      (credentials) {
        if (credentials != null) {
          emit(AuthCredentialsLoaded(
            email: credentials['email'],
            password: credentials['password'],
          ));
        } else {
          emit(const AuthCredentialsLoaded());
        }
      },
    );
  }

  Future<void> _onAuthCacheCredentialsRequested(
    AuthCacheCredentialsRequested event,
    Emitter<AuthState> emit,
  ) async {
    await cacheCredentials(
      CacheCredentialsParams(
        email: event.email,
        password: event.password,
      ),
    );
  }

  Future<void> _onAuthClearCredentialsRequested(
    AuthClearCredentialsRequested event,
    Emitter<AuthState> emit,
  ) async {
    await clearCredentials(NoParams());
  }
}
