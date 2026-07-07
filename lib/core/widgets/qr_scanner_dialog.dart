import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../theme/theme_extensions.dart';
import 'app_snackbar.dart';
import '../../resources/app_localizations.dart';

class QrScannerDialog extends StatefulWidget {
  const QrScannerDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const QrScannerDialog(),
    );
  }

  @override
  State<QrScannerDialog> createState() => _QrScannerDialogState();
}

class _QrScannerDialogState extends State<QrScannerDialog> {
  final MobileScannerController _controller = MobileScannerController();
  bool _hasDetected = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _scanFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final BarcodeCapture? capture =
            await _controller.analyzeImage(image.path);
        if (capture != null && capture.barcodes.isNotEmpty) {
          final String? code = capture.barcodes.first.rawValue;
          if (code != null && code.isNotEmpty && mounted) {
            Navigator.of(context).pop(code);
          }
        } else {
          if (mounted) {
            AppSnackBar.warning(
                context, AppLocalizations.of(context)!.qrScannerNoCodeFound);
          }
        }
      }
    } catch (e) {
      debugPrint("Error scanning from gallery: $e");
      if (mounted) {
        AppSnackBar.error(context, AppLocalizations.of(context)!.qrScannerSelectImageError);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanAreaSize = size.width * 0.6;

    return Dialog(
      backgroundColor: AppColors.wood,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.qrScannerTitle,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Scanner view container
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black,
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // Scanner
                  MobileScanner(
                    controller: _controller,
                    onDetect: (BarcodeCapture capture) {
                      if (_hasDetected) return;
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        final String? code = barcode.rawValue;
                        if (code != null && code.isNotEmpty) {
                          _hasDetected = true;
                          Navigator.of(context).pop(code);
                          break;
                        }
                      }
                    },
                  ),
                  // Semi-transparent overlay with a clear scan window in the center
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 0.5),
                      BlendMode.srcOut,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: scanAreaSize,
                            height: scanAreaSize,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Border lines for scanning area
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: scanAreaSize,
                      height: scanAreaSize,
                      decoration: BoxDecoration(
                        border: Border.all(color: context.accent, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scanner Controls
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Gallery pick button
                IconButton(
                  icon: const Icon(LucideIcons.image, color: Colors.white70),
                  iconSize: 28,
                  onPressed: _scanFromGallery,
                ),
                const SizedBox(width: 24),
                // Flashlight toggle
                IconButton(
                  icon: ValueListenableBuilder<MobileScannerState>(
                    valueListenable: _controller,
                    builder: (context, state, child) {
                      switch (state.torchState) {
                        case TorchState.off:
                          return const Icon(LucideIcons.zapOff,
                              color: Colors.white70);
                        case TorchState.on:
                          return const Icon(LucideIcons.zap,
                              color: AppColors.gold);
                        case TorchState.unavailable:
                          return const Icon(LucideIcons.zapOff,
                              color: Colors.white30);
                        case TorchState.auto:
                          return const Icon(LucideIcons.zap,
                              color: AppColors.gold);
                      }
                    },
                  ),
                  iconSize: 28,
                  onPressed: () => _controller.toggleTorch(),
                ),
                const SizedBox(width: 24),
                // Camera switch (front/back)
                IconButton(
                  icon: const Icon(LucideIcons.switchCamera,
                      color: Colors.white70),
                  iconSize: 28,
                  onPressed: () => _controller.switchCamera(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Text(
              AppLocalizations.of(context)!.qrScannerInstruction,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white60,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
