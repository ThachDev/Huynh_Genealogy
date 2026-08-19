part of 'admin_dissolve_clan_bloc.dart';

abstract class AdminDissolveClanEvent {}

class DeleteFamilyRequested extends AdminDissolveClanEvent {
  DeleteFamilyRequested({required this.familyId});
  final int familyId;
}
