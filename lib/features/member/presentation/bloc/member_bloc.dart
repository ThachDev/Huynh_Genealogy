import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_family_tree/features/member/domain/entities/member.dart';
import 'package:app_family_tree/features/member/domain/usecase/delete_member_usecase.dart';
import 'package:app_family_tree/features/member/domain/usecase/get_member_by_id_usecase.dart';
import 'package:app_family_tree/features/member/domain/usecase/save_member_usecase.dart';

part 'member_event.dart';
part 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final GetMemberByIdUseCase getMemberByIdUseCase;
  final SaveMemberUseCase saveMemberUseCase;
  final DeleteMemberUseCase deleteMemberUseCase;

  MemberBloc({
    required this.getMemberByIdUseCase,
    required this.saveMemberUseCase,
    required this.deleteMemberUseCase,
  }) : super(MemberInitial()) {
    on<LoadMemberEvent>(_onLoad);
    on<SubmitMemberEvent>(_onSubmit);
    on<DeleteMemberEvent>(_onDelete);
    on<ResetMemberEvent>(_onReset);
  }

  Future<void> _onLoad(
    LoadMemberEvent event,
    Emitter<MemberState> emit,
  ) async {
    emit(MemberLoading());
    if (event.memberId == null) {
      emit(const MemberReady(member: null));
      return;
    }
    final result = await getMemberByIdUseCase(event.memberId!);
    result.fold(
      (failure) => emit(MemberError(failure.message)),
      (member) => emit(MemberReady(member: member)),
    );
  }

  Future<void> _onSubmit(
    SubmitMemberEvent event,
    Emitter<MemberState> emit,
  ) async {
    emit(MemberSubmitting());
    final result = await saveMemberUseCase(
      SaveMemberParams(member: event.member, imageFile: event.imageFile),
    );
    result.fold(
      (failure) => emit(MemberError(failure.message)),
      (saved) => emit(MemberSuccess(member: saved)),
    );
  }

  Future<void> _onDelete(
    DeleteMemberEvent event,
    Emitter<MemberState> emit,
  ) async {
    emit(MemberSubmitting());
    final result = await deleteMemberUseCase(event.memberId);
    result.fold((failure) => emit(MemberError(failure.message)), (_) {
      const dummy = MemberEntity(id: 0, fullName: '', gender: Gender.unknown);
      emit(MemberSuccess(member: dummy, isDeleted: true));
    });
  }

  void _onReset(ResetMemberEvent event, Emitter<MemberState> emit) {
    emit(MemberInitial());
  }
}
