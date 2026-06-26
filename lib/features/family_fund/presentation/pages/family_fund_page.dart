import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../bloc/family_fund_bloc.dart';
import '../bloc/family_fund_event.dart';
import '../bloc/family_fund_state.dart';
import '../../data/models/family_fund_transaction_model.dart';

class FamilyFundPage extends StatefulWidget {
  final bool isAdmin;
  const FamilyFundPage({super.key, required this.isAdmin});

  @override
  State<FamilyFundPage> createState() => _FamilyFundPageState();
}

class _FamilyFundPageState extends State<FamilyFundPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<FamilyFundBloc>().add(FetchFundSummary());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        backgroundColor: AppColors.wood,
        elevation: 0,
        title: Text(
          'Quỹ Gia Tộc',
          style: GoogleFonts.beVietnamPro(
            color: AppColors.gold,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocBuilder<FamilyFundBloc, FamilyFundState>(
        builder: (context, state) {
          if (state is FamilyFundLoading || state is FamilyFundInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.crimson));
          } else if (state is FamilyFundError) {
            return Center(child: Text(state.message));
          } else if (state is FamilyFundLoaded) {
            return Column(
              children: [
                _buildHeaderCard(state),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTransactionList(state.transactions),
                      _buildTransactionList(
                        state.transactions.where((tx) => tx.type == 'IN').toList(),
                      ),
                      _buildTransactionList(
                        state.transactions.where((tx) => tx.type == 'OUT').toList(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.wood,
              onPressed: () => _showAddTransactionDialog(context),
              icon: const Icon(LucideIcons.plus, color: AppColors.gold),
              label: Text(
                'Ghi nhận Thu/Chi',
                style: GoogleFonts.beVietnamPro(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildHeaderCard(FamilyFundLoaded state) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.wood, Color(0xFF502715)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SỐ DƯ QUỸ HIỆN TẠI',
                style: GoogleFonts.beVietnamPro(
                  color: AppColors.gold.withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const Icon(LucideIcons.wallet, color: AppColors.gold, size: 24),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _currencyFormat.format(state.balance),
            style: GoogleFonts.beVietnamPro(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Tổng thu', state.totalIncome, LucideIcons.arrowDownLeft, Colors.greenAccent),
              Container(width: 1, height: 32, color: Colors.white.withValues(alpha: 0.1)),
              _buildStatItem('Tổng chi', state.totalOutcome, LucideIcons.arrowUpRight, Colors.redAccent),
            ],
          ),
          if (!widget.isAdmin) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showContributionDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.wood,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(LucideIcons.heartHandshake, size: 18),
                label: Text(
                  'Đóng góp cho Dòng họ',
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, double amount, IconData icon, Color color) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.beVietnamPro(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
                Text(
                  _currencyFormat.format(amount),
                  style: GoogleFonts.beVietnamPro(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.wood.withValues(alpha: 0.15)),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: AppColors.wood,
          borderRadius: BorderRadius.circular(6),
        ),
        labelColor: AppColors.gold,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold, fontSize: 13),
        unselectedLabelStyle: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w500, fontSize: 13),
        tabs: const [
          Tab(text: 'Tất cả'),
          Tab(text: 'Khoản thu'),
          Tab(text: 'Khoản chi'),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<FamilyFundTransactionModel> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.receipt, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.3)),
            const SizedBox(height: 12),
            Text(
              'Chưa có giao dịch nào',
              style: GoogleFonts.beVietnamPro(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final isIncome = tx.type == 'IN';
        final isPending = tx.status == 'PENDING';
        final isRejected = tx.status == 'REJECTED';

        return Card(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.wood.withValues(alpha: 0.08)),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            shape: const Border(),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isPending
                    ? Colors.orange.withValues(alpha: 0.1)
                    : isRejected
                        ? Colors.red.withValues(alpha: 0.1)
                        : isIncome
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPending
                    ? LucideIcons.clock
                    : isIncome
                        ? LucideIcons.arrowDownLeft
                        : LucideIcons.arrowUpRight,
                color: isPending
                    ? Colors.orange
                    : isRejected
                        ? Colors.red
                        : isIncome
                            ? Colors.green
                            : Colors.red,
                size: 20,
              ),
            ),
            title: Text(
              tx.description,
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '${tx.category} • ${DateFormat('dd/MM/yyyy HH:mm').format(tx.createdAt)}',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (isPending) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Chờ duyệt giao dịch',
                      style: GoogleFonts.beVietnamPro(
                        color: Colors.orange.shade800,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            trailing: Text(
              '${isIncome ? '+' : '-'}${_currencyFormat.format(tx.amount)}',
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isPending
                    ? Colors.orange
                    : isIncome
                        ? Colors.green.shade700
                        : Colors.red.shade700,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                key: ValueKey(tx.id),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildDetailRow('Người thực hiện:', tx.senderName),
                    _buildDetailRow('Mã giao dịch:', tx.id),
                    _buildDetailRow('Thời gian:', DateFormat('dd/MM/yyyy HH:mm:ss').format(tx.createdAt)),
                    if (tx.evidenceUrl != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Minh chứng chuyển khoản:',
                        style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          tx.evidenceUrl!,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 100,
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: const Icon(LucideIcons.imageOff, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                    if (widget.isAdmin && isPending) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              context.read<FamilyFundBloc>().add(RejectTransaction(transactionId: tx.id));
                              AppSnackBar.success(context, 'Đã từ chối giao dịch đóng góp.');
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: const Text('Từ chối'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              context.read<FamilyFundBloc>().add(ApproveTransaction(transactionId: tx.id));
                              AppSnackBar.success(context, 'Đã phê duyệt giao dịch đóng góp!');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: const Text('Phê duyệt'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: GoogleFonts.beVietnamPro(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    final amountController = TextEditingController();
    final descController = TextEditingController();
    final senderController = TextEditingController();
    String selectedType = 'IN';
    String selectedCategory = 'Đóng góp';

    final categories = ['Đóng góp', 'Hiếu hỷ', 'Xây dựng', 'Khuyến học', 'Họp mặt', 'Khác'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.parchment,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Ghi nhận Thu / Chi',
            style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold, color: AppColors.wood),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  decoration: const InputDecoration(labelText: 'Loại giao dịch'),
                  items: const [
                    DropdownMenuItem(value: 'IN', child: Text('Thu (Quỹ nhận tiền)')),
                    DropdownMenuItem(value: 'OUT', child: Text('Chi (Quỹ chi tiền)')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() {
                        selectedType = val;
                        selectedCategory = val == 'IN' ? 'Đóng góp' : 'Xây dựng';
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  decoration: const InputDecoration(labelText: 'Hạng mục'),
                  items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() {
                        selectedCategory = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Số tiền (VNĐ)',
                    hintText: 'Ví dụ: 500000',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Nội dung chi tiết',
                    hintText: 'Nhập nội dung giao dịch...',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: senderController,
                  decoration: const InputDecoration(
                    labelText: 'Người thực hiện',
                    hintText: 'Tên thành viên / Người nhận chi',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Hủy', style: GoogleFonts.beVietnamPro(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                final amt = double.tryParse(amountController.text) ?? 0;
                if (amt <= 0) {
                  AppSnackBar.error(ctx, 'Số tiền không hợp lệ');
                  return;
                }
                if (descController.text.trim().isEmpty) {
                  AppSnackBar.error(ctx, 'Vui lòng điền nội dung');
                  return;
                }
                context.read<FamilyFundBloc>().add(
                      AddTransaction(
                        amount: amt,
                        type: selectedType,
                        category: selectedCategory,
                        description: descController.text,
                        senderName: senderController.text.isNotEmpty 
                            ? senderController.text 
                            : (selectedType == 'IN' ? 'Ẩn danh' : 'Ban quản trị'),
                      ),
                    );
                Navigator.pop(ctx);
                AppSnackBar.success(context, 'Đã thêm giao dịch thành công!');
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.wood, foregroundColor: Colors.white),
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  void _showContributionDialog(BuildContext context) {
    final amountController = TextEditingController();
    final descController = TextEditingController();
    double amount = 0;
    bool showQR = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: AppColors.parchment,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Đóng góp gia tộc',
                        style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.bold,
                          color: AppColors.wood,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: const Icon(LucideIcons.x, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(),
                  if (!showQR) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Số tiền đóng góp (VNĐ)',
                        hintText: 'Nhập số tiền...',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: 'Lời chúc / Nội dung',
                        hintText: 'Ví dụ: Đóng góp sửa nhà thờ tổ...',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final amt = double.tryParse(amountController.text) ?? 0;
                              if (amt <= 1000) {
                                AppSnackBar.error(ctx, 'Số tiền tối thiểu là 1.000₫');
                                return;
                              }
                              setDialogState(() {
                                amount = amt;
                                showQR = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.wood,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Tiếp tục (Quét QR)'),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: 12),
                    Text(
                      'Quét mã VietQR chuyển khoản',
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 200,
                      height: 200,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://img.vietqr.io/image/MB-1234567890-compact2.png?amount=${amount.toInt()}&addInfo=GIA%20TOC%20VIET%20HGT1',
                            width: 170,
                            height: 170,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(LucideIcons.qrCode, size: 100, color: AppColors.wood),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'STK: 1234567890 • MB Bank\nTên: HUYNH GIA TOC TRUONG\nNội dung: GIA TOC VIET HGT1',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              context.read<FamilyFundBloc>().add(
                                    AddTransaction(
                                      amount: amount,
                                      type: 'IN',
                                      category: 'Đóng góp',
                                      description: descController.text.isNotEmpty 
                                          ? descController.text 
                                          : 'Đóng góp trực tuyến qua VietQR',
                                      senderName: 'Thành viên đóng góp (VietQR)',
                                    ),
                                  );
                              Navigator.pop(ctx);
                              AppSnackBar.success(context, 'Hệ thống tự động đối soát ngân hàng thành công! Đã cộng vào số dư.');
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                              side: const BorderSide(color: Colors.green),
                            ),
                            child: const Text('Giả lập SePay thành công'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<FamilyFundBloc>().add(
                                    SubmitContribution(
                                      amount: amount,
                                      description: descController.text.isNotEmpty 
                                          ? descController.text 
                                          : 'Đóng góp qua ngân hàng',
                                      senderName: 'Huỳnh Minh Triết',
                                      evidenceUrl: 'https://images.unsplash.com/photo-1628157582853-a796fa650a6a?q=80&w=200',
                                    ),
                                  );
                              Navigator.pop(ctx);
                              AppSnackBar.success(context, 'Yêu cầu đóng góp đã được gửi. Chờ Admin phê duyệt!');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.wood,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Tôi đã chuyển (Gửi bill duyệt tay)'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
