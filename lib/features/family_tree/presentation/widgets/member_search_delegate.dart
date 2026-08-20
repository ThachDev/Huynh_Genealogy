import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giatocviet/features/family_tree/domain/entities/member_entity.dart';
import '../../../../resources/app_localizations.dart';

/// Search delegate cho cây gia phả: tìm thành viên theo tên và trả về id.
class MemberSearchDelegate extends SearchDelegate<int?> {
  MemberSearchDelegate(this.members);
  final List<MemberEntity> members;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(LucideIcons.x),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(LucideIcons.arrowLeft),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSuggestions(context);
  }

  Widget _buildSuggestions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final matches = members
        .where((m) => m.fullName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final member = matches[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: member.avatarUrl != null
                ? CachedNetworkImageProvider(member.avatarUrl!)
                : null,
            child: member.avatarUrl == null ? const Icon(Icons.person) : null,
          ),
          title: Text(member.fullName),
          subtitle: Text(l10n.generationLabel('${member.generation ?? 0}')),
          onTap: () {
            close(context, member.id);
          },
        );
      },
    );
  }
}