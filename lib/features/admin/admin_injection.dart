import 'package:get_it/get_it.dart';
import 'admin.dart';
import 'data/repository/member_account_link_repository_impl.dart';
import 'data/source/member_account_link_remote_data_source.dart';
import 'domain/repository/member_account_link_repository.dart';
import 'domain/usecase/get_account_links.dart';
import 'domain/usecase/link_member_account.dart';
import 'domain/usecase/unlink_member_account.dart';

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

  sl.registerFactory(
    () => MemberAccountLinksBloc(
      getAccountLinks: sl(),
      linkMemberAccount: sl(),
      unlinkMemberAccount: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => SaveMember(sl()));
  sl.registerLazySingleton(() => DeleteMember(sl()));

  // Liên kết tài khoản hai chiều (gán email theo nút / gỡ liên kết)
  sl.registerLazySingleton(() => GetAccountLinks(sl()));
  sl.registerLazySingleton(() => LinkMemberAccount(sl()));
  sl.registerLazySingleton(() => UnlinkMemberAccount(sl()));
  sl.registerLazySingleton<MemberAccountLinkRepository>(
    () => MemberAccountLinkRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<MemberAccountLinkRemoteDataSource>(
    () => MemberAccountLinkRemoteDataSourceImpl(dio: sl()),
  );
}
