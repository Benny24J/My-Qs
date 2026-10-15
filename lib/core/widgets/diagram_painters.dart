import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

void _drawCardBg(Canvas canvas, Size size) {
  final rect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(10));
  canvas.drawRRect(rect, Paint()..color = Colors.white);
  canvas.drawRRect(rect, Paint()..color = AppTheme.cardIceBlueBorder..style = PaintingStyle.stroke..strokeWidth = 1.0);
}

void _drawText(Canvas canvas, String text, Offset center, Color color, {double size = 10, bool isVertical = false}) {
  final tp = TextPainter(
    text: TextSpan(text: text, style: TextStyle(color: color, fontSize: size, fontWeight: FontWeight.bold)),
    textDirection: TextDirection.ltr,
  )..layout();
  if (isVertical) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-pi / 2);
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  } else {
    tp.paint(canvas, Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2)));
  }
}

class WallDiagramPainter extends CustomPainter {
  final double length;
  final double height;
  final int doors;
  final int windows;

  WallDiagramPainter({required this.length, required this.height, required this.doors, required this.windows});

  @override
  void paint(Canvas canvas, Size size) {
    _drawCardBg(canvas, size);
    const pad = 24.0;
    final wallW = size.width - (pad * 2);
    final wallH = size.height - (pad * 2);
    final wallRect = Rect.fromLTWH(pad, pad, wallW, wallH);

    canvas.drawRect(wallRect, Paint()..color = const Color(0xFFF1F5F9));

    final gridPaint = Paint()..color = const Color(0xFFCBD5E1)..strokeWidth = 1.0;
    for (int i = 1; i < 5; i++) {
      final y = pad + (wallH / 5) * i;
      canvas.drawLine(Offset(pad, y), Offset(pad + wallW, y), gridPaint);
    }

    if (doors > 0) {
      final dW = min(36.0, wallW * 0.22);
      final dH = wallH * 0.75;
      final dRect = Rect.fromLTWH(pad + (wallW * 0.2) - (dW / 2), pad + wallH - dH, dW, dH);
      canvas.drawRect(dRect, Paint()..color = Colors.white);
      canvas.drawRect(dRect, Paint()..color = AppTheme.headerBlue..style = PaintingStyle.stroke..strokeWidth = 1.5);
      _drawText(canvas, 'DOOR', dRect.center, AppTheme.titleBlue, size: 9);
    }

    if (windows > 0) {
      final wW = min(42.0, wallW * 0.25);
      final wH = wallH * 0.45;
      final wRect = Rect.fromLTWH(pad + (wallW * 0.72) - (wW / 2), pad + (wallH * 0.22), wW, wH);
      canvas.drawRect(wRect, Paint()..color = Colors.white);
      final winBorder = Paint()..color = AppTheme.headerBlue..style = PaintingStyle.stroke..strokeWidth = 1.5;
      canvas.drawRect(wRect, winBorder);
      canvas.drawLine(Offset(wRect.center.dx, wRect.top), Offset(wRect.center.dx, wRect.bottom), winBorder);
      _drawText(canvas, 'WIN', wRect.center, AppTheme.titleBlue, size: 9);
    }

    canvas.drawRect(wallRect, Paint()..color = const Color(0xFF334155)..style = PaintingStyle.stroke..strokeWidth = 2.0);
    _drawText(canvas, 'Length: ${length.toStringAsFixed(1)}m', Offset(size.width / 2, size.height - 10), AppTheme.titleBlue, size: 11);
    _drawText(canvas, 'Height: ${height.toStringAsFixed(1)}m', Offset(12, size.height / 2), AppTheme.textMuted, size: 10, isVertical: true);
  }

  @override
  bool shouldRepaint(covariant WallDiagramPainter oldDelegate) =>
      oldDelegate.length != length || oldDelegate.height != height || oldDelegate.doors != doors || oldDelegate.windows != windows;
}

class TileGridDiagramPainter extends CustomPainter {
  final double floorLength;
  final double floorWidth;
  final double tileW;
  final double tileL;

  TileGridDiagramPainter({required this.floorLength, required this.floorWidth, required this.tileW, required this.tileL});

  @override
  void paint(Canvas canvas, Size size) {
    _drawCardBg(canvas, size);
    const pad = 24.0;
    final gridW = size.width - (pad * 2);
    final gridH = size.height - (pad * 2);
    final gridRect = Rect.fromLTWH(pad, pad, gridW, gridH);

    canvas.drawRect(gridRect, Paint()..color = const Color(0xFFF8FAFC));

    final linePaint = Paint()..color = const Color(0xFF94A3B8)..strokeWidth = 1.0;
    for (int i = 0; i <= 6; i++) {
      final x = pad + (gridW / 6) * i;
      canvas.drawLine(Offset(x, pad), Offset(x, pad + gridH), linePaint);
    }
    for (int j = 0; j <= 5; j++) {
      final y = pad + (gridH / 5) * j;
      canvas.drawLine(Offset(pad, y), Offset(pad + gridW, y), linePaint);
    }

    canvas.drawRect(Rect.fromLTWH(pad, pad, gridW / 6, gridH / 5), Paint()..color = AppTheme.headerBlue.withValues(alpha: 0.25));
    canvas.drawRect(gridRect, Paint()..color = const Color(0xFF1E293B)..style = PaintingStyle.stroke..strokeWidth = 2.0);

    _drawText(canvas, '${floorLength.toStringAsFixed(1)}m', Offset(size.width / 2, size.height - 10), AppTheme.titleBlue);
    _drawText(canvas, '${floorWidth.toStringAsFixed(1)}m', Offset(12, size.height / 2), AppTheme.textMuted, isVertical: true);
    _drawText(canvas, '${tileW.toInt()}×${tileL.toInt()}cm tile', Offset(pad + (gridW / 6) / 2, pad + (gridH / 5) / 2), AppTheme.headerBlueDark, size: 9.5);
  }

  @override
  bool shouldRepaint(covariant TileGridDiagramPainter oldDelegate) =>
      oldDelegate.floorLength != floorLength || oldDelegate.floorWidth != floorWidth || oldDelegate.tileW != tileW || oldDelegate.tileL != tileL;
}

class ColumnRebarDiagramPainter extends CustomPainter {
  final int barsCount;
  final int barDiameter;
  final int linkDiameter;
  final bool isRound;

  ColumnRebarDiagramPainter({required this.barsCount, required this.barDiameter, required this.linkDiameter, this.isRound = false});

  @override
  void paint(Canvas canvas, Size size) {
    _drawCardBg(canvas, size);
    final center = Offset(size.width / 2, size.height / 2);
    final colSize = min(size.width, size.height) * 0.65;
    final tieSize = colSize * 0.78;

    final concPaint = Paint()..color = const Color(0xFFF1F5F9);
    final concBorder = Paint()..color = const Color(0xFF1E293B)..style = PaintingStyle.stroke..strokeWidth = 2.0;
    final tiePaint = Paint()..color = const Color(0xFF475569)..style = PaintingStyle.stroke..strokeWidth = 2.0;
    final dotPaint = Paint()..color = const Color(0xFF0F172A)..style = PaintingStyle.fill;
    final rebarPositions = <Offset>[];

    if (isRound) {
      canvas.drawCircle(center, colSize / 2, concPaint);
      canvas.drawCircle(center, colSize / 2, concBorder);
      canvas.drawCircle(center, tieSize / 2, tiePaint);
      final tieRadius = (tieSize / 2) - 6;
      final count = max(4, barsCount);
      for (int i = 0; i < count; i++) {
        final angle = (2 * pi / count) * i - (pi / 2);
        rebarPositions.add(Offset(center.dx + tieRadius * cos(angle), center.dy + tieRadius * sin(angle)));
      }
    } else {
      final colRect = Rect.fromCenter(center: center, width: colSize, height: colSize);
      canvas.drawRect(colRect, concPaint);
      canvas.drawRect(colRect, concBorder);

      final tieRect = Rect.fromCenter(center: center, width: tieSize, height: tieSize);
      canvas.drawRect(tieRect, tiePaint);
      canvas.drawLine(Offset(tieRect.left + 2, tieRect.top + 2), Offset(tieRect.left + 16, tieRect.top + 16), tiePaint);

      final l = tieRect.left + 6, r = tieRect.right - 6, t = tieRect.top + 6, b = tieRect.bottom - 6;
      final mx = (l + r) / 2, my = (t + b) / 2;
      rebarPositions.addAll([Offset(l, t), Offset(r, t), Offset(l, b), Offset(r, b)]);
      if (barsCount >= 6) rebarPositions.addAll([Offset(mx, t), Offset(mx, b)]);
      if (barsCount >= 8) rebarPositions.addAll([Offset(l, my), Offset(r, my)]);
      if (barsCount >= 10) rebarPositions.addAll([Offset(l + (mx - l) / 2, t), Offset(mx + (r - mx) / 2, t)]);
    }

    for (final pos in rebarPositions) {
      canvas.drawCircle(pos, 6.0, dotPaint);
    }

    final shapeName = isRound ? 'Circular Column' : 'Rectangular Column';
    _drawText(canvas, '$barsCount × Y$barDiameter Main ($shapeName)', Offset(size.width / 2, 14), AppTheme.titleBlue, size: 11);
    _drawText(canvas, 'Y$linkDiameter Stirrups @ 200mm c/c', Offset(size.width / 2, size.height - 12), const Color(0xFF334155), size: 11);
  }

  @override
  bool shouldRepaint(covariant ColumnRebarDiagramPainter oldDelegate) =>
      oldDelegate.barsCount != barsCount || oldDelegate.barDiameter != barDiameter || oldDelegate.linkDiameter != linkDiameter || oldDelegate.isRound != isRound;
}

class ConcreteSlabDiagramPainter extends CustomPainter {
  final double length;
  final double width;
  final double depth;

  ConcreteSlabDiagramPainter({required this.length, required this.width, required this.depth});

  @override
  void paint(Canvas canvas, Size size) {
    _drawCardBg(canvas, size);
    final linePaint = Paint()..color = const Color(0xFF1E293B)..style = PaintingStyle.stroke..strokeWidth = 1.8;

    final pTopLeft = Offset(size.width * 0.25, size.height * 0.22);
    final pTopRight = Offset(size.width * 0.78, size.height * 0.22);
    final pFrontLeft = Offset(size.width * 0.12, size.height * 0.58);
    final pFrontRight = Offset(size.width * 0.65, size.height * 0.58);
    const th = 28.0;

    final topPath = Path()..moveTo(pTopLeft.dx, pTopLeft.dy)..lineTo(pTopRight.dx, pTopRight.dy)..lineTo(pFrontRight.dx, pFrontRight.dy)..lineTo(pFrontLeft.dx, pFrontLeft.dy)..close();
    final frontPath = Path()..moveTo(pFrontLeft.dx, pFrontLeft.dy)..lineTo(pFrontRight.dx, pFrontRight.dy)..lineTo(pFrontRight.dx, pFrontRight.dy + th)..lineTo(pFrontLeft.dx, pFrontLeft.dy + th)..close();
    final sidePath = Path()..moveTo(pFrontRight.dx, pFrontRight.dy)..lineTo(pTopRight.dx, pTopRight.dy)..lineTo(pTopRight.dx, pTopRight.dy + th)..lineTo(pFrontRight.dx, pFrontRight.dy + th)..close();

    canvas.drawPath(topPath, Paint()..color = const Color(0xFFE2E8F0));
    canvas.drawPath(frontPath, Paint()..color = const Color(0xFF94A3B8));
    canvas.drawPath(sidePath, Paint()..color = const Color(0xFFCBD5E1));

    canvas.drawPath(topPath, linePaint);
    canvas.drawPath(frontPath, linePaint);
    canvas.drawPath(sidePath, linePaint);

    _drawText(canvas, 'L = ${length.toStringAsFixed(1)}m', Offset(pFrontLeft.dx + (pFrontRight.dx - pFrontLeft.dx) / 2, pFrontLeft.dy - 10), AppTheme.titleBlue);
    _drawText(canvas, 'W = ${width.toStringAsFixed(1)}m', Offset(pTopRight.dx + 20, pTopRight.dy + 15), const Color(0xFF334155));
    _drawText(canvas, 'T = ${(depth * 1000).toStringAsFixed(0)}mm', Offset(pFrontLeft.dx - 18, pFrontLeft.dy + th / 2), AppTheme.headerBlueDark);
  }

  @override
  bool shouldRepaint(covariant ConcreteSlabDiagramPainter oldDelegate) =>
      oldDelegate.length != length || oldDelegate.width != width || oldDelegate.depth != depth;
}
