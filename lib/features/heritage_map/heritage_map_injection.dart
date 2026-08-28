import 'package:get_it/get_it.dart';

import 'data/datasources/heritage_place_remote_data_source.dart';
import 'data/repositories/heritage_place_repository_impl.dart';
import 'domain/repositories/heritage_place_repository.dart';
import 'domain/usecases/delete_heritage_place.dart';
import 'domain/usecases/get_heritage_places.dart';
import 'domain/usecases/get_member_grave.dart';
import 'domain/usecases/save_heritage_place.dart';
import 'presentation/bloc/heritage_map_bloc.dart';

void initHeritageMapDependencies(GetIt sl) {
  // Data sources
  sl.registerLazySingleton<HeritagePlaceRemoteDataSource>(
    () => HeritagePlaceRemoteDataSourceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<HeritagePlaceRepository>(
    () => HeritagePlaceRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetHeritagePlaces(sl()));
  sl.registerLazySingleton(() => GetMemberGrave(sl()));
  sl.registerLazySingleton(() => SaveHeritagePlace(sl()));
  sl.registerLazySingleton(() => DeleteHeritagePlace(sl()));

  // BLoC
  sl.registerFactory(
    () => HeritageMapBloc(
      getHeritagePlaces: sl(),
      saveHeritagePlace: sl(),
      deleteHeritagePlace: sl(),
    ),
  );
}
