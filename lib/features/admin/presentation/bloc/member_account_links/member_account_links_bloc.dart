import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giatocviet/core/errors/failures.dart';
import 'package:giatocviet/features/admin/domain/entities/member_account_link_entity.dart';
import '../../../domain/usecase/get_account_links.dart';
import '../../../domain/usecase/link_member_account.dart';
import '../../../domain/usecase/unlink_member_account.dart';

part 'member_account_links_event.dart';
part 'member_account_links_state.dart';

class MemberAccountLinksBloc
    extends Bloc<MemberAccountLinksEvent, MemberAccountLinksState> {
  final GetAccountLinks getAccountLinks;
  final LinkMemberAccount linkMemberAccount;
  final UnlinkMemberAccount unlinkMemberAccount;

  MemberAccountLinksBloc({
    required this.getAccountLinks,
    required this.linkMemberAccount,
    required this.unlinkMemberAccount,
  }) : super(const MemberAccountLinksInitial()) {
    on<LoadMemberAccountLinksEvent>(_onLoad);
    on<LinkMemberEmailEvent>(_onLink);
    on<UnlinkMemberAccountEvent>(_onUnlink);
  }

  Future<void> _onLoad(
    LoadMemberAccountLinksEvent event,
    Emitter<MemberAccountLinksState> emit,
  ) async {
    emit(const MemberAccountLinksLoading());
    final result = await getAccountLinks(event.familyId);
    result.fold(
      (failure) => emit(MemberAccountLinksFailure(message: failure.message)),
      (items) => emit(MemberAccountLinksLoaded(items: items)),
    );
  }

  Future<void> _onLink(
    LinkMemberEmailEvent event,
    Emitter<MemberAccountLinksState> emit,
  ) async {
    emit(const MemberAccountLinksLoading());
    final result = await linkMemberAccount(LinkMemberAccountParams(
      familyId: event.familyId,
      memberId: event.memberId,
      email: event.email.trim(),
    ));
    result.fold(
      (failure) => emit(MemberAccountLinksFailure(message: failure.message)),
      (data) => emit(MemberAccountLinkedSuccess(
        memberId: event.memberId,
        email: data.email,
        invited: data.invited,
      )),
    );
  }

  Future<void> _onUnlink(
    UnlinkMemberAccountEvent event,
    Emitter<MemberAccountLinksState> emit,
  ) async {
    emit(const MemberAccountLinksLoading());
    final result = await unlinkMemberAccount(UnlinkMemberAccountParams(
      familyId: event.familyId,
      memberId: event.memberId,
    ));
    result.fold(
      (failure) => emit(MemberAccountLinksFailure(message: failure.message)),
      (success) => success
          ? emit(MemberAccountUnlinkedSuccess(memberId: event.memberId))
          : emit(MemberAccountLinksFailure(
              message: AppLanguage.current?.unlinkFailed ??
                  'Gỡ liên kết tài khoản thất bại')),
    );
  }
}