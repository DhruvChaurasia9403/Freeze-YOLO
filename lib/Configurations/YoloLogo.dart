import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YoloText extends StatelessWidget {
  const YoloText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          // Stroke
          Text(
            'YOLO',
            style: GoogleFonts.orbitron(
              fontSize: 60,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3
                ..color = Colors.red,
            ),
          ),
          // Fill (black or transparent for hollow)
          Text(
            'YOLO',
            style: GoogleFonts.orbitron(
              fontSize: 60,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
