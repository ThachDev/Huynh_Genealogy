import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entity/member_entity.dart';
import '../../../domain/usecase/delete_member.dart';
import '../../../domain/usecase/get_members.dart';
import '../../../domain/usecase/save_member.dart';

part 'member_form_event.dart';
part 'member_form_state.dart';

class MemberFormBloc extends Bloc<MemberFormEvent, MemberFormState> {
  final GetMembers getMembers;
  final SaveMember saveMember;
  final DeleteMember deleteMember;

  MemberFormBloc({
    required this.getMembers,
    required this.saveMember,
    required this.deleteMember,
  }) : super(MemberFormInitial()) {
    on<LoadMemberFormEvent>(_onLoad);
    on<SubmitMemberFormEvent>(_onSubmit);
    on<DeleteMemberFormEvent>(_onDelete);
    on<ResetMemberFormEvent>(_onReset);
  }

  Future<void> _onLoad(
      LoadMemberFormEvent event, Emitter<MemberFormState> emit) async {
    emit(MemberFormLoading());
    if (event.memberId == null) {
      // Create mode
      emit(MemberFormReady(member: null));
      return;
    }
    // Edit mode – fetch member
    final result = await getMembers(const GetMembersParams());
    result.fold(
      (failure) => emit(MemberFormError(failure.message)),
      (members) {
        final member = members
            .cast<MemberEntity?>()
            .firstWhere((m) => m?.id == event.memberId, orElse: () => null);
        emit(MemberFormReady(member: member));
      },
    );
  }

  Future<void> _onSubmit(
      SubmitMemberFormEvent event, Emitter<MemberFormState> emit) async {
    emit(MemberFormSubmitting());
    final result = await saveMember(SaveMemberParams(member: event.member));
    result.fold(
      (failure) => emit(MemberFormError(failure.message)),
      (saved) => emit(MemberFormSuccess(member: saved)),
    );
  }

  Future<void> _onDelete(
      DeleteMemberFormEvent event, Emitter<MemberFormState> emit) async {
    emit(MemberFormSubmitting());
    final result = await deleteMember(DeleteMemberParams(id: event.memberId));
    result.fold(
      (failure) => emit(MemberFormError(failure.message)),
      (_) {
        // Tạo một entity dummy để trả về khi xoá
        const dummy = MemberEntity(
          id: 0,
          fullName: '',
          gender: Gender.unknown,
        );
        emit(MemberFormSuccess(member: dummy, isDeleted: true));
      },
    );
  }

  void _onReset(ResetMemberFormEvent event, Emitter<MemberFormState> emit) {
    emit(MemberFormInitial());
  }
}
