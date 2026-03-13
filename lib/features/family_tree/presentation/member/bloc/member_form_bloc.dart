import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/features/family_tree/domain/usecase/delete_member_usecase.dart';
import 'package:app_family_tree/features/family_tree/domain/usecase/get_member_by_id_usecase.dart';
import 'package:app_family_tree/features/family_tree/domain/usecase/save_member_usecase.dart';

part 'member_form_event.dart';
part 'member_form_state.dart';

class MemberFormBloc extends Bloc<MemberFormEvent, MemberFormState> {
  final GetMemberByIdUseCase getMemberByIdUseCase;
  final SaveMemberUseCase saveMemberUseCase;
  final DeleteMemberUseCase deleteMemberUseCase;

  MemberFormBloc({
    required this.getMemberByIdUseCase,
    required this.saveMemberUseCase,
    required this.deleteMemberUseCase,
  }) : super(MemberFormInitial()) {
    on<LoadMemberFormEvent>(_onLoad);
    on<SubmitMemberFormEvent>(_onSubmit);
    on<DeleteMemberFormEvent>(_onDelete);
    on<ResetMemberFormEvent>(_onReset);
  }

  Future<void> _onLoad(
    LoadMemberFormEvent event,
    Emitter<MemberFormState> emit,
  ) async {
    emit(MemberFormLoading());
    if (event.memberId == null) {
      // Create mode
      emit(MemberFormReady(member: null));
      return;
    }
    // Edit mode – fetch member
    final result = await getMemberByIdUseCase(event.memberId!);
    result.fold(
      (failure) => emit(MemberFormError(failure.message)),
      (member) => emit(MemberFormReady(member: member)),
    );
  }

  Future<void> _onSubmit(
    SubmitMemberFormEvent event,
    Emitter<MemberFormState> emit,
  ) async {
    emit(MemberFormSubmitting());
    final result = await saveMemberUseCase(event.member);
    result.fold(
      (failure) => emit(MemberFormError(failure.message)),
      (saved) => emit(MemberFormSuccess(member: saved)),
    );
  }

  Future<void> _onDelete(
    DeleteMemberFormEvent event,
    Emitter<MemberFormState> emit,
  ) async {
    emit(MemberFormSubmitting());
    final result = await deleteMemberUseCase(event.memberId);
    result.fold((failure) => emit(MemberFormError(failure.message)), (_) {
      // Tạo một entity dummy để trả về khi xoá
      const dummy = MemberEntity(id: 0, fullName: '', gender: Gender.unknown);
      emit(MemberFormSuccess(member: dummy, isDeleted: true));
    });
  }

  void _onReset(ResetMemberFormEvent event, Emitter<MemberFormState> emit) {
    emit(MemberFormInitial());
  }
}
