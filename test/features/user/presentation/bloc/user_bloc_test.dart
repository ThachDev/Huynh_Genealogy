import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giatocviet/core/errors/failures.dart';
import 'package:giatocviet/core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/user_entity.dart';
import 'package:giatocviet/features/user/domain/usecase/get_user_profile.dart';
import 'package:giatocviet/features/user/domain/usecase/update_user_profile.dart';
import 'package:giatocviet/features/user/presentation/bloc/user_bloc.dart';
import 'package:giatocviet/features/user/presentation/bloc/user_event.dart';
import 'package:giatocviet/features/user/presentation/bloc/user_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUserProfile extends Mock implements GetUserProfile {}
class MockUpdateUserProfile extends Mock implements UpdateUserProfile {}

void main() {
  late UserBloc bloc;
  late MockGetUserProfile mockGetUserProfile;
  late MockUpdateUserProfile mockUpdateUserProfile;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const UpdateUserProfileParams(
        profile: UserEntity(id: 1, email: '', fullName: ''),
      ),
    );
  });

  setUp(() {
    mockGetUserProfile = MockGetUserProfile();
    mockUpdateUserProfile = MockUpdateUserProfile();
    bloc = UserBloc(
      getUserProfile: mockGetUserProfile,
      updateUserProfile: mockUpdateUserProfile,
    );
  });

  const tUserEntity = UserEntity(
    id: 1,
    email: 'user@example.com',
    fullName: 'Lê Văn C',
    role: 'VIEWER',
  );

  test('state ban đầu phải là UserInitialState', () {
    expect(bloc.state, const UserInitialState());
  });

  test('gửi FetchUserProfileEvent thành công nên emit [UserLoadingState, UserLoadedState]', () async {
    // Arrange
    when(() => mockGetUserProfile(any()))
        .thenAnswer((_) async => const Right(tUserEntity));

    // Assert Later
    final expectedStates = [
      const UserLoadingState(),
      const UserLoadedState(profile: tUserEntity),
    ];
    expectLater(bloc.stream, emitsInOrder(expectedStates));

    // Act
    bloc.add(const FetchUserProfileEvent());
  });

  test('gửi FetchUserProfileEvent thất bại nên emit [UserLoadingState, UserErrorState]', () async {
    // Arrange
    when(() => mockGetUserProfile(any()))
        .thenAnswer((_) async => const Left(ServerFailure(message: 'Lỗi hệ thống')));

    // Assert Later
    final expectedStates = [
      const UserLoadingState(),
      const UserErrorState(message: 'Lỗi hệ thống'),
    ];
    expectLater(bloc.stream, emitsInOrder(expectedStates));

    // Act
    bloc.add(const FetchUserProfileEvent());
  });
}
