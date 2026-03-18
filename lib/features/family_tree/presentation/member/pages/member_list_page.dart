import 'package:app_family_tree/core/di/injection_container.dart' as di;
import 'package:app_family_tree/core/utils/member_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:app_family_tree/features/family_tree/presentation/member/bloc/member_form_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/member/widgets/add_member_dialog.dart';
import 'package:app_family_tree/components/app_bar/app_bar.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage({super.key});

  @override
  State<MemberListPage> createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedGender = 'Tất cả';
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: CommonAppBar(
        titleText: 'DANH SÁCH THÀNH VIÊN',
        isSearching: _isSearching,
        searchController: _searchController,
        onSearchChanged: (val) => setState(() => _searchQuery = val),
        onSearchToggle: () => setState(() => _isSearching = true),
        onSearchClear: () {
          _searchController.clear();
          setState(() {
            _searchQuery = '';
            _isSearching = false;
          });
        },
        onFilterToggle: _showFilterMenu,
        isFilterActive: _selectedGender != 'Tất cả',
        actions: const [],
      ),
      body: BlocBuilder<TreeBloc, TreeState>(
        builder: (context, state) {
          if (state is TreeLoading || state is TreeInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is TreeError) return Center(child: Text(state.message));

          if (state is TreeLoaded) {
            final filteredMembers = state.allMembers.where((m) {
              final matchesSearch = m.fullName.toLowerCase().contains(_searchQuery.toLowerCase());
              final matchesGender = _selectedGender == 'Tất cả' ||
                  (_selectedGender == 'Nam' && m.gender == Gender.male) ||
                  (_selectedGender == 'Nữ' && m.gender == Gender.female);
              return matchesSearch && matchesGender;
            }).toList()..sort((a, b) {
              final genComp = (a.generation ?? 0).compareTo(b.generation ?? 0);
              if (genComp != 0) return genComp;
              return a.fullName.compareTo(b.fullName);
            });

            if (filteredMembers.isEmpty) {
              return Center(child: Text('Chưa có dữ liệu thành viên', style: GoogleFonts.inter(color: AppColors.textSecondary)));
            }

            return AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  final member = filteredMembers[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildSlidableMemberTile(context, member),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final treeBloc = context.read<TreeBloc>();
          showDialog(
            context: context,
            barrierColor: Colors.black.withValues(alpha: 0.6),
            builder: (ctx) => MultiBlocProvider(
              providers: [
                BlocProvider<MemberFormBloc>(create: (_) => di.sl<MemberFormBloc>()),
                BlocProvider.value(value: treeBloc),
              ],
              child: const AddMemberDialog(),
            ),
          );
        },
        backgroundColor: AppColors.crimson,
        elevation: 4,
        child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 26),
      ),
    );
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('CHỌN GIỚI TÍNH', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.crimson)),
            const Divider(),
            _buildFilterOption('Tất cả', Icons.all_inclusive),
            _buildFilterOption('Nam', Icons.male_rounded),
            _buildFilterOption('Nữ', Icons.female_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.crimson),
      title: Text(label, style: GoogleFonts.inter(fontWeight: _selectedGender == label ? FontWeight.bold : FontWeight.normal)),
      trailing: _selectedGender == label ? const Icon(Icons.check, color: AppColors.crimson) : null,
      onTap: () {
        setState(() => _selectedGender = label);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildSlidableMemberTile(BuildContext context, MemberEntity m) {
    return BlocProvider(
      create: (context) => di.sl<MemberFormBloc>(),
      child: BlocListener<MemberFormBloc, MemberFormState>(
        listener: (context, state) {
          if (state is MemberFormSuccess && state.isDeleted) {
            context.read<TreeBloc>().add(LoadTreeEvent(force: true));
          } else if (state is MemberFormError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: ${state.message}'), backgroundColor: Colors.red));
          }
        },
        child: Builder(
          builder: (context) => Slidable(
            key: Key('member_list_${m.id}'),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.22,
              children: [
                CustomSlidableAction(
                  onPressed: (_) async {
                    final confirm = await _showDeleteConfirmDialog(context, m.fullName);
                    if (confirm == true && context.mounted) {
                      context.read<MemberFormBloc>().add(DeleteMemberFormEvent(m.id));
                    }
                  },
                  backgroundColor: AppColors.parchment,
                  foregroundColor: Colors.white,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))]),
                    child: const Icon(Icons.delete_outline, size: 28),
                  ),
                ),
              ],
            ),
            child: _buildMemberTile(context, m),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmDialog(BuildContext context, String name) {
    return showDialog<bool>(context: context, builder: (context) => AlertDialog(backgroundColor: AppColors.parchment, title: Text('Xác nhận xóa', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, color: AppColors.crimson)), content: Text('Bạn có chắc muốn xóa thành viên $name khỏi gia phả không?'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy', style: TextStyle(color: AppColors.textSecondary))), ElevatedButton(onPressed: () => Navigator.pop(context, true), style: ElevatedButton.styleFrom(backgroundColor: AppColors.crimson), child: const Text('Xóa ngay', style: TextStyle(color: Colors.white)))]));
  }

  Widget _buildMemberTile(BuildContext context, MemberEntity m) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.only(right: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: AppColors.gold.withValues(alpha: 0.2))),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.gold, width: 1.5)),
          child: CircleAvatar(backgroundColor: m.gender == Gender.male ? AppColors.nodeMale : AppColors.nodeFemale, radius: 20, backgroundImage: m.fullAvatarUrl != null ? NetworkImage(m.fullAvatarUrl!) : null, child: m.fullAvatarUrl == null ? Icon(m.gender == Gender.male ? Icons.man : Icons.woman, color: AppColors.crimson, size: 20) : null),
        ),
        title: Text(m.fullName, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text('Đời ${m.generation ?? "?"} • ${m.branchName ?? "Họ Huỳnh"} • ${m.isAlive ? "Còn sống" : "Đã mất"}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.gold),
        onTap: () => context.push('/members/${m.id}', extra: m),
      ),
    );
  }
}
