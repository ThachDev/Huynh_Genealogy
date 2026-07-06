part of 'admin_dissolve_clan_bloc.dart';

abstract class AdminDissolveClanState {
  const AdminDissolveClanState();
}

class AdminDissolveClanInitial extends AdminDissolveClanState {}

class AdminDissolveClanLoading extends AdminDissolveClanState {}

class AdminDissolveClanSuccess extends AdminDissolveClanState {}

class AdminDissolveClanFailure extends AdminDissolveClanState {
  final String message;
  const AdminDissolveClanFailure({required this.message});
}
