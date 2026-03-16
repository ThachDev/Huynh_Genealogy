import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:app_family_tree/resource/app_theme.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:go_router/go_router.dart';
import 'package:app_family_tree/utils/member_utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:app_family_tree/features/family_tree/presentation/member/bloc/member_form_bloc.dart';
import 'package:app_family_tree/di/injection_container.dart' as di;

class MemberListPage extends StatefulWidget {
  const MemberListPage({super.key});

  @override
  State<MemberListPage> createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedGender = 'Tất cả';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: Text(
          'DANH SÁCH THÀNH VIÊN',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: AppColors.gold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.wood,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.gold),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/wood_dragon.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: AppColors.wood),
              ),
              Container(color: Colors.black.withValues(alpha: 0.3)),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildSearchAndFilter(),
        ),
      ),
      body: BlocBuilder<TreeBloc, TreeState>(
        builder: (context, state) {
          if (state is TreeLoading || state is TreeInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is TreeError) {
            return Center(child: Text(state.message));
          }

          if (state is TreeLoaded) {
            final filteredMembers = state.allMembers.where((m) {
              final matchesSearch = m.fullName.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
              final matchesGender =
                  _selectedGender == 'Tất cả' ||
                  (_selectedGender == 'Nam' && m.gender == Gender.male) ||
                  (_selectedGender == 'Nữ' && m.gender == Gender.female);
              return matchesSearch && matchesGender;
            }).toList();

            if (filteredMembers.isEmpty) {
              return Center(
                child: Text(
                  'Chưa có dữ liệu thành viên',
                  style: GoogleFonts.inter(color: AppColors.textSecondary),
                ),
              );
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
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(Icons.search, color: AppColors.crimson, size: 20),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm người thân...',
                  hintStyle: GoogleFonts.inter(
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
              ),
            Container(
              width: 1,
              height: 20,
              color: AppColors.gold.withValues(alpha: 0.3),
            ),
            Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.white),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    value: _selectedGender,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.crimson,
                      size: 18,
                    ),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    items:
                        [
                          ['Tất cả', Icons.all_inclusive],
                          ['Nam', Icons.male_rounded],
                          ['Nữ', Icons.female_rounded],
                        ].map((item) {
                          final label = item[0] as String;
                          final icon = item[1] as IconData;
                          return DropdownMenuItem<String>(
                            value: label,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(icon, size: 16, color: AppColors.crimson),
                                const SizedBox(width: 8),
                                Text(label),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedGender = val);
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lỗi: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Builder(
          builder: (context) {
            return Slidable(
              key: Key('member_list_${m.id}'),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.22,
                children: [
                  CustomSlidableAction(
                    onPressed: (_) async {
                      final confirm = await _showDeleteConfirmDialog(
                        context,
                        m.fullName,
                      );
                      if (confirm == true && context.mounted) {
                        context.read<MemberFormBloc>().add(
                          DeleteMemberFormEvent(m.id),
                        );
                      }
                    },
                    backgroundColor: AppColors.parchment,
                    foregroundColor: Colors.white,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.delete_outline, size: 28),
                    ),
                  ),
                ],
              ),
              child: _buildMemberTile(context, m),
            );
          },
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmDialog(BuildContext context, String name) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.parchment,
        title: Text(
          'Xác nhận xóa',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: AppColors.crimson,
          ),
        ),
        content: Text(
          'Bạn có chắc muốn xóa thành viên $name khỏi gia phả không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Hủy',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.crimson),
            child: const Text('Xóa ngay', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }


  Widget _buildMemberTile(BuildContext context, MemberEntity m) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.only(right: 8), // Thêm margin để tạo gap với nút xóa
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.gold.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gold, width: 1.5),
          ),
          child: CircleAvatar(
            backgroundColor: m.gender == Gender.male
                ? AppColors.nodeMale
                : AppColors.nodeFemale,
            radius: 20,
            backgroundImage: m.fullAvatarUrl != null
                ? NetworkImage(m.fullAvatarUrl!)
                : null,
            child: m.fullAvatarUrl == null
                ? Icon(
                    m.gender == Gender.male ? Icons.man : Icons.woman,
                    color: AppColors.crimson,
                    size: 20,
                  )
                : null,
          ),
        ),
        title: Text(
          m.fullName,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          'Đời ${m.generation ?? "?"} • ${m.branchName ?? "Họ Huỳnh"} • ${m.isAlive ? "Còn sống" : "Đã mất"}',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.gold),
        onTap: () {
          context.push('/members/${m.id}', extra: m);
        },
      ),
    );
  }
}
