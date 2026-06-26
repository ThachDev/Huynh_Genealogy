import 'package:equatable/equatable.dart';

abstract class FamilyFundEvent extends Equatable {
  const FamilyFundEvent();

  @override
  List<Object?> get props => [];
}

class FetchFundSummary extends FamilyFundEvent {}

class FetchTransactions extends FamilyFundEvent {}

class AddTransaction extends FamilyFundEvent {
  final double amount;
  final String type;
  final String category;
  final String description;
  final String senderName;

  const AddTransaction({
    required this.amount,
    required this.type,
    required this.category,
    required this.description,
    required this.senderName,
  });

  @override
  List<Object?> get props => [amount, type, category, description, senderName];
}

class SubmitContribution extends FamilyFundEvent {
  final double amount;
  final String description;
  final String senderName;
  final String? evidenceUrl;

  const SubmitContribution({
    required this.amount,
    required this.description,
    required this.senderName,
    this.evidenceUrl,
  });

  @override
  List<Object?> get props => [amount, description, senderName, evidenceUrl];
}

class ApproveTransaction extends FamilyFundEvent {
  final String transactionId;

  const ApproveTransaction({required this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}

class RejectTransaction extends FamilyFundEvent {
  final String transactionId;

  const RejectTransaction({required this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}
