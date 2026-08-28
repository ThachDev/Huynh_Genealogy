import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/heritage_place_entity.dart';
import '../../domain/usecases/delete_heritage_place.dart';
import '../../domain/usecases/get_heritage_places.dart';
import '../../domain/usecases/save_heritage_place.dart';
import '../bloc/heritage_map_bloc.dart';
import '../bloc/heritage_map_event.dart';
import '../bloc/heritage_map_state.dart';
import '../widgets/location_picker_dialog.dart';

class HeritagePlaceFormPage extends StatelessWidget {
  const HeritagePlaceFormPage({
    super.key,
    required this.familyId,
    this.placeToEdit,
    this.initialMemberId,
    this.initialMemberName,
    this.initialGeneration,
  });

  final int familyId;
  final HeritagePlaceEntity? placeToEdit;
  final int? initialMemberId;
  final String? initialMemberName;
  final int? initialGeneration;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HeritageMapBloc(
        getHeritagePlaces: sl<GetHeritagePlaces>(),
        saveHeritagePlace: sl<SaveHeritagePlace>(),
        deleteHeritagePlace: sl<DeleteHeritagePlace>(),
      ),
      child: _HeritagePlaceFormView(
        familyId: familyId,
        placeToEdit: placeToEdit,
        initialMemberId: initialMemberId,
        initialMemberName: initialMemberName,
        initialGeneration: initialGeneration,
      ),
    );
  }
}

class _HeritagePlaceFormView extends StatefulWidget {
  const _HeritagePlaceFormView({
    required this.familyId,
    this.placeToEdit,
    this.initialMemberId,
    this.initialMemberName,
    this.initialGeneration,
  });

  final int familyId;
  final HeritagePlaceEntity? placeToEdit;
  final int? initialMemberId;
  final String? initialMemberName;
  final int? initialGeneration;

  @override
  State<_HeritagePlaceFormView> createState() => _HeritagePlaceFormViewState();
}

class _HeritagePlaceFormViewState extends State<_HeritagePlaceFormView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _landmarkGuideController;
  late final TextEditingController _generationController;
  late final TextEditingController _descriptionController;

  late HeritagePlaceType _selectedType;
  late double _latitude;
  late double _longitude;
  bool _isLocationPicked = false;

  @override
  void initState() {
    super.initState();
    final edit = widget.placeToEdit;

    _nameController = TextEditingController(
      text: edit?.name ?? (widget.initialMemberName != null ? 'Mộ ${widget.initialMemberName}' : ''),
    );
    _addressController = TextEditingController(text: edit?.address ?? '');
    _landmarkGuideController = TextEditingController(text: edit?.landmarkGuide ?? '');
    _generationController = TextEditingController(
      text: edit?.generation?.toString() ?? widget.initialGeneration?.toString() ?? '',
    );
    _descriptionController = TextEditingController(text: edit?.description ?? '');

    _selectedType = edit?.type ??
        (widget.initialMemberId != null ? HeritagePlaceType.memberGrave : HeritagePlaceType.ancestralHouse);

    _latitude = edit?.latitude ?? 21.028511;
    _longitude = edit?.longitude ?? 105.854444;
    _isLocationPicked = edit != null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _landmarkGuideController.dispose();
    _generationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _openMapPicker() async {
    final picked = await LocationPickerDialog.show(
      context,
      initialLocation: LatLng(_latitude, _longitude),
    );

    if (picked != null) {
      setState(() {
        _latitude = picked.latitude;
        _longitude = picked.longitude;
        _isLocationPicked = true;
      });
    }
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    if (!_isLocationPicked && widget.placeToEdit == null) {
      AppSnackBar.error(context, 'Vui lòng bấm chọn vị trí trên bản đồ');
      return;
    }

    final entity = HeritagePlaceEntity(
      id: widget.placeToEdit?.id ?? 0,
      familyId: widget.familyId,
      memberId: widget.placeToEdit?.memberId ?? widget.initialMemberId,
      name: _nameController.text.trim(),
      type: _selectedType,
      latitude: _latitude,
      longitude: _longitude,
      address: _addressController.text.trim().isNotEmpty ? _addressController.text.trim() : null,
      landmarkGuide: _landmarkGuideController.text.trim().isNotEmpty
          ? _landmarkGuideController.text.trim()
          : null,
      generation: int.tryParse(_generationController.text.trim()),
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      imageUrls: widget.placeToEdit?.imageUrls ?? [],
    );

    context.read<HeritageMapBloc>().add(HeritageMapSavePlaceEvent(entity));
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.placeToEdit != null;

    return BlocConsumer<HeritageMapBloc, HeritageMapState>(
      listener: (context, state) {
        if (state is HeritageMapLoaded && state.saveSuccessMessage != null) {
          AppSnackBar.success(context, state.saveSuccessMessage!);
          Navigator.pop(context, state.selectedPlace ?? true);
        }
      },
      builder: (context, state) {
        final isSaving = state is HeritageMapLoaded && state.isSaving;

        return Scaffold(
          backgroundColor: context.background,
          appBar: AppAppBar(
            title: isEditing ? 'Chỉnh sửa Địa điểm' : 'Thêm Địa điểm / Mộ phần',
          ),
          body: AppBackgroundBody(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Tên địa điểm
                  AppTextField(
                    controller: _nameController,
                    label: 'Tên địa điểm / Mộ phần *',
                    hintText: 'VD: Nhà thờ họ Huỳnh, Mộ Cụ Huỳnh Văn A',
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Vui lòng nhập tên địa điểm';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 2. Phân loại địa điểm
                  Text(
                    'Phân loại địa điểm *',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<HeritagePlaceType>(
                    initialValue: _selectedType,
                    dropdownColor: context.surface,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: context.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: context.accent.withValues(alpha: 0.3)),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: HeritagePlaceType.ancestralHouse,
                        child: Text('🏛️ Nhà thờ họ / Từ đường'),
                      ),
                      DropdownMenuItem(
                        value: HeritagePlaceType.patriarchTomb,
                        child: Text('👑 Lăng mộ tổ'),
                      ),
                      DropdownMenuItem(
                        value: HeritagePlaceType.memberGrave,
                        child: Text('🪦 Mộ phần tiền nhân'),
                      ),
                      DropdownMenuItem(
                        value: HeritagePlaceType.shrine,
                        child: Text('⛩️ Miếu / Đình làng dòng họ'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedType = val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // 3. Đời thứ mấy (Generation)
                  AppTextField(
                    controller: _generationController,
                    label: 'Thuộc đời thứ (Thế hệ)',
                    hintText: 'VD: 1, 2, 3...',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),

                  // 4. Chọn tọa độ bản đồ & vệ tinh (Cực kỳ quan trọng)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isLocationPicked ? Colors.green : context.accent.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _isLocationPicked ? LucideIcons.checkCircle : LucideIcons.mapPin,
                              color: _isLocationPicked ? Colors.green : context.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Vị trí GPS trên Bản đồ *',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: context.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _isLocationPicked
                              ? 'Tọa độ đã chọn: ${_latitude.toStringAsFixed(6)}, ${_longitude.toStringAsFixed(6)}'
                              : 'Chưa chọn vị trí. Hãy mở bản đồ vệ tinh để cắm ghim chính xác.',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: _isLocationPicked ? Colors.green : context.textSecondary,
                            fontWeight: _isLocationPicked ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          icon: const Icon(LucideIcons.map, size: 16),
                          label: Text(
                            _isLocationPicked ? 'Chỉnh lại ghim trên bản đồ' : 'Chấm vị trí trên bản đồ vệ tinh',
                            style: GoogleFonts.beVietnamPro(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: context.primary,
                            side: BorderSide(color: context.primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _openMapPicker,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 5. Chỉ dẫn mốc thực địa (Landmark Guide)
                  AppTextField(
                    controller: _landmarkGuideController,
                    label: 'Chỉ dẫn mốc thực địa (Dân dã / Dễ nhận biết)',
                    hintText: 'VD: Đi từ cổng làng vào 100m, đối diện cây đa cổ thụ rẽ phải, ngôi mộ đá xanh hàng thứ 2...',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // 6. Địa chỉ hành chính
                  AppTextField(
                    controller: _addressController,
                    label: 'Địa chỉ hành chính',
                    hintText: 'VD: Thôn Thượng, Xã An Ninh, Can Lộc, Hà Tĩnh',
                  ),
                  const SizedBox(height: 16),

                  // 7. Mô tả / Tiểu sử
                  AppTextField(
                    controller: _descriptionController,
                    label: 'Mô tả & Lịch sử',
                    hintText: 'Ghi chú thêm về năm tôn tạo, người phụ trách chăm nom...',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 28),

                  // Nút Lưu
                  AppButton(
                    label: isEditing ? 'Cập nhật địa điểm' : 'Lưu địa điểm vào bản đồ',
                    prefixIcon: const Icon(LucideIcons.save, size: 18, color: Colors.white),
                    isLoading: isSaving,
                    onPressed: isSaving ? null : _onSave,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
}
