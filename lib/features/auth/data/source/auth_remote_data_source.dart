import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithGoogle();
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
        throw const ServerException(message: 'Đăng nhập Google bị huỷ bởi người dùng');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 2. Firebase Authentication
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
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
        final Map<String, dynamic> userData = data['data']['user'] as Map<String, dynamic>;
        return UserModel.fromJson(userData);
      } else {
        throw ServerException(
          message: response.data['message']?.toString() ?? 'Lỗi xác thực máy chủ',
          statusCode: response.statusCode,
        );
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'Lỗi Firebase Auth', statusCode: 401);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message']?.toString() ?? e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Lỗi không xác định: $e');
    }
  }
}
