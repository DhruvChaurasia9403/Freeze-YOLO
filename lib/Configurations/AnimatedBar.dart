// File: lib/Configurations/AnimatedArcBar.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class ArcPainter extends CustomPainter {
  final int selectedIndex;
  final double animationValue;

  ArcPainter({required this.selectedIndex, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final double waveHeight = 20;
    final double waveFrequency = 2 * math.pi / size.width;
    final double bumpWidth = size.width / 3;

    final double bumpCenter = bumpWidth * selectedIndex + bumpWidth / 2;

    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height-50);

    for (double x = 0; x <= size.width; x++) {
      double distance = (x - bumpCenter).abs();
      double normalized = 1 - (distance / bumpWidth).clamp(0, 1);
      double bump = waveHeight * normalized * animationValue;
      double y = size.height - 40 - bump;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant ArcPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.animationValue != animationValue;
  }
}

class AnimatedArcBar extends StatefulWidget {
  final int selectedIndex;

  const AnimatedArcBar({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<AnimatedArcBar> createState() => _AnimatedArcBarState();
}

class _AnimatedArcBarState extends State<AnimatedArcBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int oldIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedArcBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _controller.forward(from: 0);
      oldIndex = oldWidget.selectedIndex;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, 250),
          painter: ArcPainter(
            selectedIndex: widget.selectedIndex,
            animationValue: _animation.value,
          ),
        );
      },
    );
  }
}
