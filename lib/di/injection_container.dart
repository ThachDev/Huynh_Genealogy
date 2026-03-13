import 'package:get_it/get_it.dart';



// Features
// Data

import '../features/family_tree/data/source/family_data_source.dart';
import '../features/family_tree/data/repository/family_repository_impl.dart';

// Domain
import '../features/family_tree/domain/repositories/family_repository.dart';

// Application
import '../features/family_tree/presentation/member/bloc/member_form_bloc.dart';
import '../features/family_tree/presentation/tree/bloc/tree_bloc.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // ─── BLoCs (factory – tạo mới mỗi lần dùng) ──────────────────────────────
  sl.registerFactory(() => TreeBloc(repository: sl()));

  sl.registerFactory(
    () => MemberFormBloc(repository: sl()),
  );

  // ─── Use Cases ────────────────────────────────────────────────────────────

  // ─── Repository ───────────────────────────────────────────────────────────
  sl.registerLazySingleton<FamilyRepository>(
    () => FamilyRepositoryImpl(dataSource: sl()),
  );

  // ─── Data Sources ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<FamilyDataSource>(
    () => FamilyLocalDataSourceImpl(),
  );

  // ─── External ─────────────────────────────────────────────────────────────
}
