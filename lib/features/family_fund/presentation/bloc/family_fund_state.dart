import 'package:equatable/equatable.dart';
import '../../data/models/family_fund_transaction_model.dart';

abstract class FamilyFundState extends Equatable {
  const FamilyFundState();

  @override
  List<Object?> get props => [];
}

class FamilyFundInitial extends FamilyFundState {}

class FamilyFundLoading extends FamilyFundState {}

class FamilyFundLoaded extends FamilyFundState {
  final double balance;
  final double totalIncome;
  final double totalOutcome;
  final List<FamilyFundTransactionModel> transactions;

  const FamilyFundLoaded({
    required this.balance,
    required this.totalIncome,
    required this.totalOutcome,
    required this.transactions,
  });

  FamilyFundLoaded copyWith({
    double? balance,
    double? totalIncome,
    double? totalOutcome,
    List<FamilyFundTransactionModel>? transactions,
  }) {
    return FamilyFundLoaded(
      balance: balance ?? this.balance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalOutcome: totalOutcome ?? this.totalOutcome,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  List<Object?> get props => [balance, totalIncome, totalOutcome, transactions];
}

class FamilyFundError extends FamilyFundState {
  final String message;

  const FamilyFundError(this.message);

  @override
  List<Object?> get props => [message];
}
