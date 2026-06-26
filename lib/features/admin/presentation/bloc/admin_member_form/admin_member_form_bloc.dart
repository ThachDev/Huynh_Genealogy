import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../../../domain/usecase/delete_member.dart';
import '../../../../user/domain/usecase/user_get_members.dart';
import '../../../domain/usecase/save_member.dart';

part 'admin_member_form_event.dart';
part 'admin_member_form_state.dart';

class AdminMemberFormBloc extends Bloc<AdminMemberFormEvent, AdminMemberFormState> {
  final UserGetMembers getMembers;
  final SaveMember saveMember;
  final DeleteMember deleteMember;

  AdminMemberFormBloc({
    required this.getMembers,
    required this.saveMember,
    required this.deleteMember,
  }) : super(AdminMemberFormInitial()) {
    on<LoadAdminMemberFormEvent>(_onLoad);
    on<SubmitAdminMemberFormEvent>(_onSubmit);
    on<DeleteAdminMemberFormEvent>(_onDelete);
    on<ResetAdminMemberFormEvent>(_onReset);
  }

  Future<void> _onLoad(
      LoadAdminMemberFormEvent event, Emitter<AdminMemberFormState> emit) async {
    emit(AdminMemberFormLoading());
    if (event.memberId == null) {
      // Create mode
      emit(AdminMemberFormReady(member: null));
      return;
    }
    // Edit mode – fetch member
    final result = await getMembers(const UserGetMembersParams());
    result.fold(
      (failure) => emit(AdminMemberFormError(failure.message)),
      (members) {
        final member = members
            .cast<MemberEntity?>()
            .firstWhere((m) => m?.id == event.memberId, orElse: () => null);
        emit(AdminMemberFormReady(member: member));
      },
    );
  }

  Future<void> _onSubmit(
      SubmitAdminMemberFormEvent event, Emitter<AdminMemberFormState> emit) async {
    emit(AdminMemberFormSubmitting());
    final result = await saveMember(SaveMemberParams(member: event.member));
    result.fold(
      (failure) => emit(AdminMemberFormError(failure.message)),
      (saved) => emit(AdminMemberFormSuccess(member: saved)),
    );
  }

  Future<void> _onDelete(
      DeleteAdminMemberFormEvent event, Emitter<AdminMemberFormState> emit) async {
    emit(AdminMemberFormSubmitting());
    final result = await deleteMember(DeleteMemberParams(id: event.memberId));
    result.fold(
      (failure) => emit(AdminMemberFormError(failure.message)),
      (_) {
        // Tạo một entity dummy để trả về khi xoá
        const dummy = MemberEntity(
          id: 0,
          fullName: '',
          gender: Gender.unknown,
        );
        emit(AdminMemberFormSuccess(member: dummy, isDeleted: true));
      },
    );
  }

  void _onReset(ResetAdminMemberFormEvent event, Emitter<AdminMemberFormState> emit) {
    emit(AdminMemberFormInitial());
  }
}
