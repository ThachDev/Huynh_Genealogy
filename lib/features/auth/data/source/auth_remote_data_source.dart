import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import 'package:giatocviet/core/data/model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithGoogle();
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  });
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String role,
  });
  Future<void> forgotPassword({required String email});
  Future<void> verifyOtp({required String email, required String otp});
  Future<void> resetPasswordWithOtp({
    required String email,
    required String otp,
    required String newPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.dio,
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  @override
  Future<UserModel> loginWithGoogle() async {
    try {
      // 1. Google Sign-In
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw const ServerException(
            message: 'Đăng nhập Google bị huỷ bởi người dùng');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 2. Firebase Authentication
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw const ServerException(message: 'Không thể xác thực với Firebase');
      }

      // 3. Get Firebase ID Token
      final String? idToken = await firebaseUser.getIdToken();
      if (idToken == null) {
        throw const ServerException(message: 'Không thể lấy Firebase ID Token');
      }

      // 4. Send token to backend
      // In a real app, you can pass fcmToken if available
      final response = await dio.post(
        AppConstants.loginEndpoint,
        data: {
          'idToken': idToken,
          'fcmToken': null, // Can be added later via notification integration
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        final Map<String, dynamic> userData =
            data['data']['user'] as Map<String, dynamic>;
        return UserModel.fromJson(userData);
      } else {
        throw ServerException(
          message:
              response.data['message']?.toString() ?? 'Lỗi xác thực máy chủ',
          statusCode: response.statusCode,
        );
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(
          message: e.message ?? 'Lỗi Firebase Auth', statusCode: 401);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message']?.toString() ??
            e.message ??
            'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Lỗi không xác định: $e');
    }
  }

  @override
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    // Retry logic for Firebase Auth propagation delay after password reset
    const maxRetries = 3;
    const retryDelays = [
      Duration(seconds: 1),
      Duration(seconds: 3),
      Duration(seconds: 5)
    ];

    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        // 1. Firebase Login
        final UserCredential userCredential =
            await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final User? firebaseUser = userCredential.user;
        if (firebaseUser == null) {
          throw const ServerException(
              message: 'Không thể xác thực với Firebase');
        }

        // 2. Get Firebase ID Token
        final String? idToken = await firebaseUser.getIdToken();
        if (idToken == null) {
          throw const ServerException(
              message: 'Không thể lấy Firebase ID Token');
        }

        // 3. Send token to backend
        final response = await dio.post(
          AppConstants.loginEndpoint,
          data: {
            'idToken': idToken,
            'fcmToken': null,
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data =
              response.data as Map<String, dynamic>;
          final Map<String, dynamic> userData =
              data['data']['user'] as Map<String, dynamic>;
          return UserModel.fromJson(userData);
        } else {
          throw ServerException(
            message:
                response.data['message']?.toString() ?? 'Lỗi xác thực máy chủ',
            statusCode: response.statusCode,
          );
        }
      } on FirebaseAuthException catch (e) {
        // Only retry on invalid credential (could be propagation delay after password reset)
        if (e.code == 'invalid-credential' ||
            e.code == 'wrong-password' ||
            e.code == 'user-not-found') {
          if (attempt < maxRetries - 1) {
            await Future.delayed(retryDelays[attempt]);
            continue;
          }
        }

        String msg = 'Lỗi đăng nhập';
        if (e.code == 'user-not-found' ||
            e.code == 'wrong-password' ||
            e.code == 'invalid-credential') {
          msg = 'Email hoặc mật khẩu không chính xác.';
        } else if (e.code == 'user-disabled') {
          msg = 'Tài khoản đã bị vô hiệu hoá.';
        } else if (e.code == 'invalid-email') {
          msg = 'Địa chỉ email không đúng định dạng.';
        } else if (e.message != null) {
          msg = e.message!;
        }
        throw ServerException(message: msg, statusCode: 401);
      } on DioException catch (e) {
        throw ServerException(
          message: e.response?.data['message']?.toString() ??
              e.message ??
              'Lỗi kết nối máy chủ',
          statusCode: e.response?.statusCode,
        );
      } catch (e) {
        if (e is ServerException) rethrow;
        throw ServerException(message: 'Lỗi không xác định: $e');
      }
    }

    // All retries exhausted
    throw const ServerException(
      message:
          'Email hoặc mật khẩu không chính xác. Vui lòng thử lại sau vài giây.',
      statusCode: 401,
    );
  }

  @override
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    User? firebaseUser;
    try {
      try {
        // 1. Firebase Register
        final UserCredential userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        firebaseUser = userCredential.user;
        if (firebaseUser == null) {
          throw const ServerException(
              message: 'Không thể đăng ký tài khoản với Firebase');
        }

        // 2. Update Display Name
        await firebaseUser.updateDisplayName(fullName);

        // 3. Get Firebase ID Token (force refresh to include the updated display name)
        final String? idToken = await firebaseUser.getIdToken(true);
        if (idToken == null) {
          throw const ServerException(
              message: 'Không thể lấy Firebase ID Token sau đăng ký');
        }

        // 4. Send token to backend
        final response = await dio.post(
          AppConstants.loginEndpoint,
          data: {
            'idToken': idToken,
            'fcmToken': null,
            'role': role,
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data =
              response.data as Map<String, dynamic>;
          final Map<String, dynamic> userData =
              data['data']['user'] as Map<String, dynamic>;
          return UserModel.fromJson(userData);
        } else {
          throw ServerException(
            message: response.data['message']?.toString() ??
                'Lỗi đăng ký tài khoản trên máy chủ',
            statusCode: response.statusCode,
          );
        }
      } on FirebaseAuthException catch (e) {
        String msg = 'Lỗi đăng ký Firebase';
        if (e.code == 'email-already-in-use') {
          msg = 'Địa chỉ email đã được sử dụng bởi một tài khoản khác.';
        } else if (e.code == 'weak-password') {
          msg = 'Mật khẩu quá yếu.';
        } else if (e.code == 'invalid-email') {
          msg = 'Địa chỉ email không đúng định dạng.';
        } else if (e.message != null) {
          msg = e.message!;
        }
        throw ServerException(message: msg, statusCode: 400);
      } on DioException catch (e) {
        throw ServerException(
          message: e.response?.data['message']?.toString() ??
              e.message ??
              'Lỗi kết nối máy chủ',
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      // Rollback Firebase User if created but flow failed
      if (firebaseUser != null) {
        try {
          await firebaseUser.delete();
        } catch (_) {}
      }
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      final response = await dio.post(
        AppConstants.forgotPasswordEndpoint,
        data: {'email': email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return;
        }
        throw ServerException(
          message: data['message']?.toString() ??
              'Không thể gửi email đặt lại mật khẩu',
          statusCode: response.statusCode,
        );
      } else {
        final data = response.data as Map<String, dynamic>;
        throw ServerException(
          message: data['message']?.toString() ?? 'Lỗi máy chủ',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message']?.toString() ??
            e.message ??
            'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Lỗi không xác định: $e');
    }
  }

  @override
  Future<void> verifyOtp({required String email, required String otp}) async {
    try {
      final response = await dio.post(
        AppConstants.verifyOtpEndpoint,
        data: {'email': email, 'otp': otp},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return;
        }
        throw ServerException(
          message: data['message']?.toString() ?? 'Mã OTP không đúng',
          statusCode: response.statusCode,
        );
      } else {
        final data = response.data as Map<String, dynamic>;
        throw ServerException(
          message: data['message']?.toString() ?? 'Lỗi máy chủ',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message']?.toString() ??
            e.message ??
            'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Lỗi không xác định: $e');
    }
  }

  @override
  Future<void> resetPasswordWithOtp({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await dio.post(
        AppConstants.resetPasswordEndpoint,
        data: {
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return;
        }
        throw ServerException(
          message: data['message']?.toString() ?? 'Không thể đặt lại mật khẩu',
          statusCode: response.statusCode,
        );
      } else {
        final data = response.data as Map<String, dynamic>;
        throw ServerException(
          message: data['message']?.toString() ?? 'Lỗi máy chủ',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message']?.toString() ??
            e.message ??
            'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Lỗi không xác định: $e');
    }
  }
}
