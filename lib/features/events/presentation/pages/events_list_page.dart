import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../features/auth/auth.dart';
import '../../events.dart';

class EventsListPage extends StatefulWidget {
  final int familyId;

  const EventsListPage({super.key, required this.familyId});

  @override
  State<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    context.read<EventsBloc>().add(LoadEventsEvent(familyId: widget.familyId));
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final canEdit = authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'BRANCH_ADMIN' ||
            authState.user.role == 'EDITOR');

    return Scaffold(
      backgroundColor: context.background,
      appBar: const AppAppBar(
        title: 'Sự Kiện Dòng Tộc',
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton(
              backgroundColor: context.primary,
              foregroundColor: Colors.white,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AdminEventFormPage(familyId: widget.familyId),
                  ),
                );
                if (result == true) {
                  _loadEvents();
                }
              },
              child: const Icon(LucideIcons.plus),
            )
          : null,
      body: BlocConsumer<EventsBloc, EventsState>(
        listener: (context, state) {
          if (state is EventsSubmitSuccess) {
            AppSnackBar.success(context, state.message);
            _loadEvents();
          } else if (state is EventsError) {
            AppSnackBar.error(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is EventsLoading || state is EventsSubmitting) {
            return const Center(child: AppLoading(size: 80));
          }

          if (state is EventsLoaded) {
            final events = state.events;
            if (events.isEmpty) {
              return const AppEmptyState(
                icon: LucideIcons.calendarDays,
                message: 'Chưa có sự kiện nào được tạo',
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return _buildEventCard(event, canEdit);
              },
            );
          }

          return const Center(
              child: Text('Đã có lỗi xảy ra. Vui lòng thử lại.'));
        },
      ),
    );
  }

  Widget _buildEventCard(EventEntity event, bool canEdit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color:
            context.resolve(const Color(0xFFFFFDF2), const Color(0xFF1E1E1E)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.resolve(const Color(0xFFD4AF37).withValues(alpha: 0.3),
              Colors.grey.shade800),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: context.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    _getDay(event.eventDate),
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.primary,
                    ),
                  ),
                  Text(
                    _getMonthYear(event.eventDate),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: context.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (event.isLunar) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: context.resolve(
                            const Color(0xFFD4AF37), Colors.yellow.shade800),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Âm lịch',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 8,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Event Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: context.resolve(
                          const Color(0xFF7D0C0E), Colors.white),
                    ),
                  ),
                  if (event.description != null &&
                      event.description!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      event.description!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: context.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (canEdit) ...[
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: Icon(LucideIcons.moreVertical,
                    color: context.textSecondary, size: 20),
                onSelected: (value) async {
                  if (value == 'edit') {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminEventFormPage(
                          familyId: widget.familyId,
                          event: event,
                        ),
                      ),
                    );
                    if (result == true) {
                      _loadEvents();
                    }
                  } else if (value == 'delete') {
                    final confirm = await _showConfirmDeleteDialog(event);
                    if (confirm == true && mounted) {
                      context.read<EventsBloc>().add(
                            DeleteEventEvent(
                                id: event.id, familyId: widget.familyId),
                          );
                    }
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(LucideIcons.edit3, size: 16),
                        SizedBox(width: 8),
                        Text('Sửa'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(LucideIcons.trash2, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Xoá', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getDay(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return parts[2];
      }
    } catch (_) {}
    return '--';
  }

  String _getMonthYear(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return '${parts[1]}/${parts[0]}';
      }
    } catch (_) {}
    return '';
  }

  Future<bool?> _showConfirmDeleteDialog(EventEntity event) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xoá sự kiện'),
        content: Text('Bạn có chắc chắn muốn xoá sự kiện "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Huỷ'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xoá', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
