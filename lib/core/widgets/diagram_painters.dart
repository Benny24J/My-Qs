import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

void _drawCardBg(Canvas canvas, Size size, {bool isDark = false}) {
  final rect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(10));
  canvas.drawRRect(rect, Paint()..color = isDark ? const Color(0xFF161D27) : Colors.white);
  canvas.drawRRect(
    rect,
    Paint()
      ..color = isDark ? const Color(0xFF2A3A52) : AppTheme.cardIceBlueBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0,
  );
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
  final bool isDark;

  WallDiagramPainter({
    required this.length,
    required this.height,
    required this.doors,
    required this.windows,
    this.isDark = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawCardBg(canvas, size, isDark: isDark);
    const pad = 24.0;
    final wallW = size.width - (pad * 2);
    final wallH = size.height - (pad * 2);
    final wallRect = Rect.fromLTWH(pad, pad, wallW, wallH);

    final wallFill = isDark ? const Color(0xFF1E2838) : const Color(0xFFF1F5F9);
    final gridColor = isDark ? const Color(0xFF2D3C52) : const Color(0xFFCBD5E1);
    final wallBorder = isDark ? const Color(0xFF64748B) : const Color(0xFF334155);
    final blueText = isDark ? const Color(0xFF60A5FA) : AppTheme.titleBlue;
    final mutedText = isDark ? const Color(0xFF94A3B8) : AppTheme.textMuted;
    final openingFill = isDark ? const Color(0xFF131923) : Colors.white;

    canvas.drawRect(wallRect, Paint()..color = wallFill);

    final gridPaint = Paint()..color = gridColor..strokeWidth = 1.0;
    for (int i = 1; i < 5; i++) {
      final y = pad + (wallH / 5) * i;
      canvas.drawLine(Offset(pad, y), Offset(pad + wallW, y), gridPaint);
    }

    if (doors > 0) {
      final dW = min(36.0, wallW * 0.22);
      final dH = wallH * 0.75;
      final dRect = Rect.fromLTWH(pad + (wallW * 0.2) - (dW / 2), pad + wallH - dH, dW, dH);
      canvas.drawRect(dRect, Paint()..color = openingFill);
      canvas.drawRect(dRect, Paint()..color = AppTheme.headerBlue..style = PaintingStyle.stroke..strokeWidth = 1.5);
      _drawText(canvas, 'DOOR', dRect.center, blueText, size: 9);
    }

    if (windows > 0) {
      final wW = min(42.0, wallW * 0.25);
      final wH = wallH * 0.45;
      final wRect = Rect.fromLTWH(pad + (wallW * 0.72) - (wW / 2), pad + (wallH * 0.22), wW, wH);
      canvas.drawRect(wRect, Paint()..color = openingFill);
      final winBorder = Paint()..color = AppTheme.headerBlue..style = PaintingStyle.stroke..strokeWidth = 1.5;
      canvas.drawRect(wRect, winBorder);
      canvas.drawLine(Offset(wRect.center.dx, wRect.top), Offset(wRect.center.dx, wRect.bottom), winBorder);
      _drawText(canvas, 'WIN', wRect.center, blueText, size: 9);
    }

    canvas.drawRect(wallRect, Paint()..color = wallBorder..style = PaintingStyle.stroke..strokeWidth = 2.0);
    _drawText(canvas, 'Length: ${length.toStringAsFixed(1)}m', Offset(size.width / 2, size.height - 10), blueText, size: 11);
    _drawText(canvas, 'Height: ${height.toStringAsFixed(1)}m', Offset(12, size.height / 2), mutedText, size: 10, isVertical: true);
  }

  @override
  bool shouldRepaint(covariant WallDiagramPainter oldDelegate) =>
      oldDelegate.length != length ||
      oldDelegate.height != height ||
      oldDelegate.doors != doors ||
      oldDelegate.windows != windows ||
      oldDelegate.isDark != isDark;
}

class TileGridDiagramPainter extends CustomPainter {
  final double floorLength;
  final double floorWidth;
  final double tileW;
  final double tileL;
  final bool isDark;

  TileGridDiagramPainter({
    required this.floorLength,
    required this.floorWidth,
    required this.tileW,
    required this.tileL,
    this.isDark = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawCardBg(canvas, size, isDark: isDark);
    const pad = 24.0;
    final gridW = size.width - (pad * 2);
    final gridH = size.height - (pad * 2);
    final gridRect = Rect.fromLTWH(pad, pad, gridW, gridH);

    final bgFill = isDark ? const Color(0xFF131923) : const Color(0xFFF8FAFC);
    final gridLineColor = isDark ? const Color(0xFF2C3C54) : const Color(0xFF94A3B8);
    final borderColor = isDark ? const Color(0xFF64748B) : const Color(0xFF1E293B);
    final blueText = isDark ? const Color(0xFF60A5FA) : AppTheme.titleBlue;
    final mutedText = isDark ? const Color(0xFF94A3B8) : AppTheme.textMuted;

    canvas.drawRect(gridRect, Paint()..color = bgFill);

    final linePaint = Paint()..color = gridLineColor..strokeWidth = 1.0;
    for (int i = 0; i <= 6; i++) {
      final x = pad + (gridW / 6) * i;
      canvas.drawLine(Offset(x, pad), Offset(x, pad + gridH), linePaint);
    }
    for (int j = 0; j <= 5; j++) {
      final y = pad + (gridH / 5) * j;
      canvas.drawLine(Offset(pad, y), Offset(pad + gridW, y), linePaint);
    }

    canvas.drawRect(Rect.fromLTWH(pad, pad, gridW / 6, gridH / 5), Paint()..color = AppTheme.headerBlue.withValues(alpha: 0.35));
    canvas.drawRect(gridRect, Paint()..color = borderColor..style = PaintingStyle.stroke..strokeWidth = 2.0);

    _drawText(canvas, '${floorLength.toStringAsFixed(1)}m', Offset(size.width / 2, size.height - 10), blueText);
    _drawText(canvas, '${floorWidth.toStringAsFixed(1)}m', Offset(12, size.height / 2), mutedText, isVertical: true);
    _drawText(canvas, '${tileW.toInt()}×${tileL.toInt()}cm tile', Offset(pad + (gridW / 6) / 2, pad + (gridH / 5) / 2), isDark ? const Color(0xFF93C5FD) : AppTheme.headerBlueDark, size: 9.5);
  }

  @override
  bool shouldRepaint(covariant TileGridDiagramPainter oldDelegate) =>
      oldDelegate.floorLength != floorLength ||
      oldDelegate.floorWidth != floorWidth ||
      oldDelegate.tileW != tileW ||
      oldDelegate.tileL != tileL ||
      oldDelegate.isDark != isDark;
}

class ColumnRebarDiagramPainter extends CustomPainter {
  final int barsCount;
  final int barDiameter;
  final int linkDiameter;
  final bool isRound;
  final bool isDark;

  ColumnRebarDiagramPainter({
    required this.barsCount,
    required this.barDiameter,
    required this.linkDiameter,
    this.isRound = false,
    this.isDark = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawCardBg(canvas, size, isDark: isDark);
    final center = Offset(size.width / 2, size.height / 2);
    final colSize = min(size.width, size.height) * 0.65;
    final tieSize = colSize * 0.78;

    final concPaint = Paint()..color = isDark ? const Color(0xFF1B2433) : const Color(0xFFF1F5F9);
    final concBorder = Paint()..color = isDark ? const Color(0xFF64748B) : const Color(0xFF1E293B)..style = PaintingStyle.stroke..strokeWidth = 2.0;
    final tiePaint = Paint()..color = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)..style = PaintingStyle.stroke..strokeWidth = 2.0;
    final dotPaint = Paint()..color = isDark ? const Color(0xFF38BDF8) : const Color(0xFF0F172A)..style = PaintingStyle.fill;
    final blueText = isDark ? const Color(0xFF60A5FA) : AppTheme.titleBlue;
    final subText = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);

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
    _drawText(canvas, '$barsCount × Y$barDiameter Main ($shapeName)', Offset(size.width / 2, 14), blueText, size: 11);
    _drawText(canvas, 'Y$linkDiameter Stirrups @ 200mm c/c', Offset(size.width / 2, size.height - 12), subText, size: 11);
  }

  @override
  bool shouldRepaint(covariant ColumnRebarDiagramPainter oldDelegate) =>
      oldDelegate.barsCount != barsCount ||
      oldDelegate.barDiameter != barDiameter ||
      oldDelegate.linkDiameter != linkDiameter ||
      oldDelegate.isRound != isRound ||
      oldDelegate.isDark != isDark;
}

class ConcreteSlabDiagramPainter extends CustomPainter {
  final double length;
  final double width;
  final double depth;
  final bool isDark;

  ConcreteSlabDiagramPainter({
    required this.length,
    required this.width,
    required this.depth,
    this.isDark = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawCardBg(canvas, size, isDark: isDark);
    final linePaint = Paint()..color = (isDark ? const Color(0xFF64748B) : const Color(0xFF1E293B))..style = PaintingStyle.stroke..strokeWidth = 1.8;

    final pTopLeft = Offset(size.width * 0.25, size.height * 0.22);
    final pTopRight = Offset(size.width * 0.78, size.height * 0.22);
    final pFrontLeft = Offset(size.width * 0.12, size.height * 0.58);
    final pFrontRight = Offset(size.width * 0.65, size.height * 0.58);
    const th = 28.0;

    final topPath = Path()..moveTo(pTopLeft.dx, pTopLeft.dy)..lineTo(pTopRight.dx, pTopRight.dy)..lineTo(pFrontRight.dx, pFrontRight.dy)..lineTo(pFrontLeft.dx, pFrontLeft.dy)..close();
    final frontPath = Path()..moveTo(pFrontLeft.dx, pFrontLeft.dy)..lineTo(pFrontRight.dx, pFrontRight.dy)..lineTo(pFrontRight.dx, pFrontRight.dy + th)..lineTo(pFrontLeft.dx, pFrontLeft.dy + th)..close();
    final sidePath = Path()..moveTo(pFrontRight.dx, pFrontRight.dy)..lineTo(pTopRight.dx, pTopRight.dy)..lineTo(pTopRight.dx, pTopRight.dy + th)..lineTo(pFrontRight.dx, pFrontRight.dy + th)..close();

    final topColor = isDark ? const Color(0xFF263348) : const Color(0xFFE2E8F0);
    final frontColor = isDark ? const Color(0xFF1E2838) : const Color(0xFF94A3B8);
    final sideColor = isDark ? const Color(0xFF182230) : const Color(0xFFCBD5E1);

    canvas.drawPath(topPath, Paint()..color = topColor);
    canvas.drawPath(frontPath, Paint()..color = frontColor);
    canvas.drawPath(sidePath, Paint()..color = sideColor);

    canvas.drawPath(topPath, linePaint);
    canvas.drawPath(frontPath, linePaint);
    canvas.drawPath(sidePath, linePaint);

    final blueText = isDark ? const Color(0xFF60A5FA) : AppTheme.titleBlue;
    final neutralText = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    final darkBlueText = isDark ? const Color(0xFF93C5FD) : AppTheme.headerBlueDark;

    _drawText(canvas, 'L = ${length.toStringAsFixed(1)}m', Offset(pFrontLeft.dx + (pFrontRight.dx - pFrontLeft.dx) / 2, pFrontLeft.dy - 10), blueText);
    _drawText(canvas, 'W = ${width.toStringAsFixed(1)}m', Offset(pTopRight.dx + 20, pTopRight.dy + 15), neutralText);
    _drawText(canvas, 'T = ${(depth * 1000).toStringAsFixed(0)}mm', Offset(pFrontLeft.dx - 18, pFrontLeft.dy + th / 2), darkBlueText);
  }

  @override
  bool shouldRepaint(covariant ConcreteSlabDiagramPainter oldDelegate) =>
      oldDelegate.length != length ||
      oldDelegate.width != width ||
      oldDelegate.depth != depth ||
      oldDelegate.isDark != isDark;
}
