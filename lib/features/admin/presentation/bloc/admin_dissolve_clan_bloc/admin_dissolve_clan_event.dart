part of 'admin_dissolve_clan_bloc.dart';

abstract class AdminDissolveClanEvent {}

class DeleteFamilyRequested extends AdminDissolveClanEvent {
  final int familyId;
  DeleteFamilyRequested({required this.familyId});
}
