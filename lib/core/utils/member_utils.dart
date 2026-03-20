import 'package:app_family_tree/constants/app_constants.dart';
import 'package:app_family_tree/features/member/domain/entities/member.dart';

extension MemberImageExtension on MemberEntity {
  String? get fullAvatarUrl {
    if (avatarUrl == null || avatarUrl!.isEmpty) return null;
    if (avatarUrl!.startsWith('http')) return avatarUrl;
    return '${AppConstants.serverUrl}$avatarUrl';
  }
}
