import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppCustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String activeText;
  final String inactiveText;
  final Widget activeIcon;
  final Widget inactiveIcon;
  final Color activeColor;
  final Color inactiveColor;

  const AppCustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.activeText,
    required this.inactiveText,
    required this.activeIcon,
    required this.inactiveIcon,
    this.activeColor = const Color(0xFFC02E2E), // crimson
    this.inactiveColor = const Color(0xFF6B7280), // gray
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 100,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: value ? activeColor : inactiveColor,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Text trạng thái
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              alignment: value ? const Alignment(-0.6, 0) : const Alignment(0.6, 0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  value ? activeText : inactiveText,
                  style: GoogleFonts.beVietnamPro(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Nút tròn chứa icon / flag
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: value ? activeIcon : inactiveIcon,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
