import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_client.dart';

// Feature DI Modules
import '../../features/auth/auth_injection.dart';
import '../../features/family_tree/family_tree_injection.dart';
import '../../features/events/events_injection.dart';
import '../../features/onboarding/onboarding_injection.dart';
import '../../features/admin/admin_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ─── External Services & Driver Core ─────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton<Dio>(() => DioClient.instance);

  // ─── Initialize Feature Modules DI ────────────────────────────────────────
  initAuthDependencies(sl);
  initFamilyTreeDependencies(sl);
  initEventsDependencies(sl);
  initOnboardingDependencies(sl);
  initAdminDependencies(sl);
}
