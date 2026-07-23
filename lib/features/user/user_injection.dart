import 'package:get_it/get_it.dart';
import 'data/repository/user_repository_impl.dart';
import 'data/source/user_remote_data_source.dart';
import 'domain/repository/user_repository.dart';
import 'domain/usecase/get_user_profile.dart';
import 'domain/usecase/update_user_profile.dart';
import 'presentation/bloc/user_bloc.dart';

void initUserDependencies(GetIt sl) {
  // BLoC
  sl.registerFactory(
    () => UserBloc(
      getUserProfile: sl(),
      updateUserProfile: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(dio: sl()),
  );
}
