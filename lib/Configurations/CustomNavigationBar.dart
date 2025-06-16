import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const CustomBottomBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Height is enough to show the arc and nav items
    return SizedBox(
      height: 130,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Arc background with white top border
          CustomPaint(
            size: const Size(double.infinity, 130),
            painter: ArcPainter(),
          ),
          // Navigation items at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.home_outlined, 0),
                _buildNavItem(Icons.qr_code_scanner, 1),
                _buildNavItem(Icons.percent_outlined, 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final bool isSelected = selectedIndex == index;
    final double size = isSelected ? 60 : 48; // Increase size if selected
    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Colors.white, width: 2)
              : null,
        ),
        child: Icon(
          icon,
          size: isSelected ? 32 : 24, // Larger icon if selected
          color: isSelected ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double arcHeight = 120;
    final double yOffset = 40;
    final double arcShiftUp = 30; // Only arc is shifted up

    // Draw the filled arc, shifted up
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height - arcShiftUp)
      ..quadraticBezierTo(
        size.width / 2, size.height - arcShiftUp,
        size.width, size.height - arcShiftUp,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);

    // Draw the white top border, shifted up
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final borderPath = Path()
      ..moveTo(0, size.height -arcShiftUp)
      ..quadraticBezierTo(
        size.width / 2, size.height - arcHeight - arcShiftUp,
        size.width, size.height - arcShiftUp,
      );

    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}