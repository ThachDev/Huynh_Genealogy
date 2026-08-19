import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giatocviet/features/family_tree/domain/entities/member_entity.dart';
import '../../../domain/usecase/get_trashed_members.dart';
import '../../../domain/usecase/restore_member.dart';
import '../../../domain/usecase/purge_trash.dart';

part 'member_trash_event.dart';
part 'member_trash_state.dart';

class MemberTrashBloc extends Bloc<MemberTrashEvent, MemberTrashState> {

  MemberTrashBloc({
    required this.getTrashedMembers,
    required this.restoreMember,
    required this.purgeTrash,
  }) : super(const MemberTrashInitial()) {
    on<LoadMemberTrashEvent>(_onLoad);
    on<RestoreMemberEvent>(_onRestore);
    on<PurgeTrashEvent>(_onPurge);
  }
  final GetTrashedMembers getTrashedMembers;
  final RestoreMember restoreMember;
  final PurgeTrash purgeTrash;

  Future<void> _onLoad(
    LoadMemberTrashEvent event,
    Emitter<MemberTrashState> emit,
  ) async {
    emit(const MemberTrashLoading());
    final result = await getTrashedMembers(GetTrashedMembersParams(
      familyId: event.familyId,
      branchId: event.branchId,
    ));
    result.fold(
      (failure) => emit(MemberTrashFailure(message: failure.message)),
      (members) => emit(MemberTrashLoaded(members: members)),
    );
  }

  Future<void> _onRestore(
    RestoreMemberEvent event,
    Emitter<MemberTrashState> emit,
  ) async {
    emit(const MemberTrashLoading());
    final result = await restoreMember(event.memberId);
    result.fold(
      (failure) => emit(MemberTrashFailure(message: failure.message)),
      (member) => emit(MemberRestoredState(member: member)),
    );
  }

  Future<void> _onPurge(
    PurgeTrashEvent event,
    Emitter<MemberTrashState> emit,
  ) async {
    emit(const MemberTrashLoading());
    final result = await purgeTrash(PurgeTrashParams(days: event.days));
    result.fold(
      (failure) => emit(MemberTrashFailure(message: failure.message)),
      (removed) => emit(TrashPurgedState(removed: removed)),
    );
  }
}