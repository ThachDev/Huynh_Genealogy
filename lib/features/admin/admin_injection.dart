import 'package:get_it/get_it.dart';
import 'admin.dart';

void initAdminDependencies(GetIt sl) {
  // BLoCs
  sl.registerFactory(
    () => AdminMemberFormBloc(
      getMembers: sl(),
      getBranches: sl(),
      saveMember: sl(),
      deleteMember: sl(),
    ),
  );

  sl.registerFactory(
    () => AdminPendingRequestsBloc(
      getPendingRequests: sl(),
      approveRequest: sl(),
      rejectRequest: sl(),
      getFamilyDetail: sl(),
    ),
  );

  sl.registerFactory(
    () => AdminBranchFormBloc(
      saveBranch: sl(),
      deleteBranch: sl(),
    ),
  );

  sl.registerFactory(
    () => AdminMemberRolesBloc(
      getApprovedMembers: sl(),
      updateMemberRole: sl(),
    ),
  );

  sl.registerFactory(
    () => AdminDissolveClanBloc(
      deleteFamily: sl(),
    ),
  );

  sl.registerFactory(
    () => AdminTransferOwnershipBloc(
      getApprovedMembers: sl(),
      transferOwnership: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => SaveMember(sl()));
  sl.registerLazySingleton(() => DeleteMember(sl()));
}
