import 'package:get_it/get_it.dart';
import 'events.dart';

void initEventsDependencies(GetIt sl) {
  // BLoC
  sl.registerFactory(
    () => EventsBloc(
      getEvents: sl(),
      saveEvent: sl(),
      deleteEvent: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetEvents(sl()));
  sl.registerLazySingleton(() => SaveEvent(sl()));
  sl.registerLazySingleton(() => DeleteEvent(sl()));

  // Repository
  sl.registerLazySingleton<EventsRepository>(
    () => EventsRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<EventsRemoteDataSource>(
    () => EventsRemoteDataSourceImpl(dio: sl()),
  );
}
