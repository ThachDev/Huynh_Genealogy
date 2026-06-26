import 'package:flutter_bloc/flutter_bloc.dart';
import 'family_fund_event.dart';
import 'family_fund_state.dart';
import '../../data/models/family_fund_transaction_model.dart';

class FamilyFundBloc extends Bloc<FamilyFundEvent, FamilyFundState> {
  // Mock data khởi tạo cho Quỹ Gia Tộc
  final List<FamilyFundTransactionModel> _mockTransactions = [
    FamilyFundTransactionModel(
      id: 'tx_1',
      amount: 15000000,
      type: 'IN',
      category: 'Đóng góp',
      description: 'Ông Huỳnh Kim Long đóng góp xây dựng nhà thờ tổ',
      senderName: 'Huỳnh Kim Long',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      status: 'COMPLETED',
    ),
    FamilyFundTransactionModel(
      id: 'tx_2',
      amount: 5000000,
      type: 'OUT',
      category: 'Xây dựng',
      description: 'Mua sắm bình hoa, lư hương đồng mới',
      senderName: 'Thủ quỹ dòng họ',
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      status: 'COMPLETED',
    ),
    FamilyFundTransactionModel(
      id: 'tx_3',
      amount: 2000000,
      type: 'IN',
      category: 'Khuyến học',
      description: 'Bà Huỳnh Thị Mai đóng quỹ khuyến học hè 2026',
      senderName: 'Huỳnh Thị Mai',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      status: 'COMPLETED',
    ),
    FamilyFundTransactionModel(
      id: 'tx_4',
      amount: 3000000,
      type: 'OUT',
      category: 'Khuyến học',
      description: 'Phát thưởng học sinh giỏi cấp Tỉnh/Thành phố',
      senderName: 'Thủ quỹ dòng họ',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      status: 'COMPLETED',
    ),
    FamilyFundTransactionModel(
      id: 'tx_5',
      amount: 1000000,
      type: 'IN',
      category: 'Đóng góp',
      description: 'Đóng góp quỹ gia tộc quý II',
      senderName: 'Huỳnh Minh Triết',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: 'PENDING',
      evidenceUrl: 'https://images.unsplash.com/photo-1628157582853-a796fa650a6a?q=80&w=200',
    ),
  ];

  FamilyFundBloc() : super(FamilyFundInitial()) {
    on<FetchFundSummary>(_onFetchSummary);
    on<FetchTransactions>(_onFetchTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<SubmitContribution>(_onSubmitContribution);
    on<ApproveTransaction>(_onApproveTransaction);
    on<RejectTransaction>(_onRejectTransaction);
  }

  void _onFetchSummary(FetchFundSummary event, Emitter<FamilyFundState> emit) {
    _emitLoadedState(emit);
  }

  void _onFetchTransactions(FetchTransactions event, Emitter<FamilyFundState> emit) {
    _emitLoadedState(emit);
  }

  void _onAddTransaction(AddTransaction event, Emitter<FamilyFundState> emit) {
    final newTx = FamilyFundTransactionModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      amount: event.amount,
      type: event.type,
      category: event.category,
      description: event.description,
      senderName: event.senderName,
      createdAt: DateTime.now(),
      status: 'COMPLETED',
    );
    _mockTransactions.insert(0, newTx);
    _emitLoadedState(emit);
  }

  void _onSubmitContribution(SubmitContribution event, Emitter<FamilyFundState> emit) {
    final newTx = FamilyFundTransactionModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      amount: event.amount,
      type: 'IN',
      category: 'Đóng góp',
      description: event.description,
      senderName: event.senderName,
      createdAt: DateTime.now(),
      status: 'PENDING',
      evidenceUrl: event.evidenceUrl,
    );
    _mockTransactions.insert(0, newTx);
    _emitLoadedState(emit);
  }

  void _onApproveTransaction(ApproveTransaction event, Emitter<FamilyFundState> emit) {
    final idx = _mockTransactions.indexWhere((tx) => tx.id == event.transactionId);
    if (idx != -1) {
      _mockTransactions[idx] = _mockTransactions[idx].copyWith(status: 'COMPLETED');
    }
    _emitLoadedState(emit);
  }

  void _onRejectTransaction(RejectTransaction event, Emitter<FamilyFundState> emit) {
    final idx = _mockTransactions.indexWhere((tx) => tx.id == event.transactionId);
    if (idx != -1) {
      _mockTransactions[idx] = _mockTransactions[idx].copyWith(status: 'REJECTED');
    }
    _emitLoadedState(emit);
  }

  void _emitLoadedState(Emitter<FamilyFundState> emit) {
    double totalIncome = 0;
    double totalOutcome = 0;

    for (var tx in _mockTransactions) {
      if (tx.status == 'COMPLETED') {
        if (tx.type == 'IN') {
          totalIncome += tx.amount;
        } else {
          totalOutcome += tx.amount;
        }
      }
    }

    emit(FamilyFundLoaded(
      balance: totalIncome - totalOutcome,
      totalIncome: totalIncome,
      totalOutcome: totalOutcome,
      transactions: List.from(_mockTransactions),
    ));
  }
}
