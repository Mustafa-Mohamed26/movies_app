import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/banner_renderer.dart';

void main() {
  testWidgets('Generate project banner', (WidgetTester tester) async {
    // 1. Setup the banner widget in a specific size
    await tester.binding.setSurfaceSize(const Size(1200, 480));
    
    // Use RepaintBoundary to capture the widget
    final GlobalKey boundaryKey = GlobalKey();
    
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: Brightness.dark),
        home: Scaffold(
          backgroundColor: const Color(0xFF121112),
          body: RepaintBoundary(
            key: boundaryKey,
            child: const BannerWidget(),
          ),
        ),
      ),
    );

    // Wait for everything to settle (especially fonts if possible, though flutter test fonts are limited)
    await tester.pumpAndSettle();

    // 2. Capture the image
    final RenderRepaintBoundary boundary = 
        boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 2.0); // High res
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    // 3. Save to branding folder
    final directory = Directory('assets/branding');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    
    final file = File('assets/branding/banner.png');
    await file.writeAsBytes(pngBytes);
    
    print('Banner successfully generated at ${file.absolute.path}');
  });
}
