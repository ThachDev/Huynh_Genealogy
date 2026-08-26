import 'package:equatable/equatable.dart';
import 'member_entity.dart';

class KinshipPathStep extends Equatable {
  const KinshipPathStep({
    required this.member,
    required this.roleInPath,
  });

  final MemberEntity member;
  final String roleInPath;

  @override
  List<Object?> get props => [member, roleInPath];
}

class KinshipResultEntity extends Equatable {
  const KinshipResultEntity({
    required this.fromMember,
    required this.toMember,
    this.lowestCommonAncestor,
    required this.generationDiff,
    required this.fromCallsTo,
    required this.toCallsFrom,
    required this.selfPronounFrom,
    required this.selfPronounTo,
    required this.relationshipName,
    required this.explanation,
    required this.path,
    this.isDirectLineage = false,
    this.areSpouses = false,
    this.isSamePerson = false,
  });

  final MemberEntity fromMember;
  final MemberEntity toMember;
  final MemberEntity? lowestCommonAncestor;
  final int generationDiff;
  final String fromCallsTo;
  final String toCallsFrom;
  final String selfPronounFrom;
  final String selfPronounTo;
  final String relationshipName;
  final String explanation;
  final List<KinshipPathStep> path;
  final bool isDirectLineage;
  final bool areSpouses;
  final bool isSamePerson;

  @override
  List<Object?> get props => [
        fromMember,
        toMember,
        lowestCommonAncestor,
        generationDiff,
        fromCallsTo,
        toCallsFrom,
        selfPronounFrom,
        selfPronounTo,
        relationshipName,
        explanation,
        path,
        isDirectLineage,
        areSpouses,
        isSamePerson,
      ];
}
