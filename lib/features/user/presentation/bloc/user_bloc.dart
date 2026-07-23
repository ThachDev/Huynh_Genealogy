import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecase/get_user_profile.dart';
import '../../domain/usecase/update_user_profile.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;

  UserBloc({
    required this.getUserProfile,
    required this.updateUserProfile,
  }) : super(const UserInitialState()) {
    on<FetchUserProfileEvent>(_onFetchUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
  }

  Future<void> _onFetchUserProfile(
      FetchUserProfileEvent event, Emitter<UserState> emit) async {
    emit(const UserLoadingState());
    final result = await getUserProfile(NoParams());
    result.fold(
      (failure) => emit(UserErrorState(message: failure.message)),
      (profile) => emit(UserLoadedState(profile: profile)),
    );
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfileEvent event, Emitter<UserState> emit) async {
    emit(const UserUpdatingState());
    final result =
        await updateUserProfile(UpdateUserProfileParams(profile: event.profile));
    result.fold(
      (failure) => emit(UserErrorState(message: failure.message)),
      (updatedProfile) => emit(UserUpdateSuccessState(
        profile: updatedProfile,
        message: 'Cập nhật thông tin thành công',
      )),
    );
  }
}
