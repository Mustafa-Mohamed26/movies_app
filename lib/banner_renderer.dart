import 'dart:io';
import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1200,
      height: 480,
      decoration: BoxDecoration(
        color: const Color(0xFF121112),
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            const Color(0xFF1E1D1E),
            const Color(0xFF121112),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background effects
          Positioned(
            top: -100,
            left: -50,
            child: _BlurSphere(color: const Color(0xFFF6BD00).withOpacity(0.15), size: 300),
          ),
          Positioned(
            bottom: -200,
            right: -100,
            child: _BlurSphere(color: const Color(0xFFF6BD00).withOpacity(0.15), size: 400),
          ),
          
          // Grid lines
          CustomPaint(
            size: const Size(1200, 480),
            painter: _GridPainter(),
          ),

          // Content
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6BD00),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.play_arrow, size: 100, color: Colors.black,),
                    ),
                  ),
                ),
                const SizedBox(width: 50),
                // Text
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Movies App',
                      style: TextStyle(
                        fontSize: 90,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        fontFamily: 'Roboto', // Fallback to standard
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            color: Colors.black38,
                            offset: Offset(0, 10),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'The Ultimate Cinematic Experience',
                          style: TextStyle(
                            fontSize: 28,
                            fontFamily: 'Roboto',
                            color: Colors.white70,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF02569B).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF40C4FF).withOpacity(0.4)),
                          ),
                          child: const Text(
                            'BUILT WITH FLUTTER',
                            style: TextStyle(
                              color: Color(0xFF40C4FF),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurSphere extends StatelessWidget {
  final Color color;
  final double size;

  const _BlurSphere({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF6BD00).withOpacity(0.04)
      ..strokeWidth = 1.0;

    const gap = 60.0;
    for (double i = 0; i < size.width; i += gap) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += gap) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
