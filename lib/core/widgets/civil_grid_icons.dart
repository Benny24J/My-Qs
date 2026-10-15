import 'dart:math';
import 'package:flutter/material.dart';

class CivilGridIcons {
  static Widget waterTank() => const CustomPaint(size: Size(44, 44), painter: _WaterTankPainter());
  static Widget diagonalTriangle() => const CustomPaint(size: Size(44, 44), painter: _TrianglePainter());
  static Widget foundationFooting() => const CustomPaint(size: Size(44, 44), painter: _FootingPainter());
  static Widget steelRods() => const CustomPaint(size: Size(44, 44), painter: _SteelRodsPainter());
  static Widget concreteCylinder() => const CustomPaint(size: Size(40, 44), painter: _CylinderPainter());
  static Widget formwork() => const CustomPaint(size: Size(44, 44), painter: _FormworkPainter());
  static Widget columnSection({required int bars, bool isRound = false}) => CustomPaint(size: const Size(48, 48), painter: _ColumnSectionPainter(bars: bars, isRound: isRound));
  static Widget slabMesh() => const CustomPaint(size: Size(48, 48), painter: _SlabMeshPainter());
  static Widget wallBlock() => const CustomPaint(size: Size(44, 44), painter: _WallBlockPainter());
  static Widget tileGrid() => const CustomPaint(size: Size(44, 44), painter: _TileGridPainter());
}

class _WaterTankPainter extends CustomPainter {
  const _WaterTankPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()..color = const Color(0xFF1E293B)..style = PaintingStyle.stroke..strokeWidth = 1.2;
    const pad = 6.0;
    final w = size.width - (pad * 2), h = size.height - (pad * 2);
    final rect = Rect.fromLTWH(pad, pad, w, h);
    canvas.drawRect(Rect.fromLTWH(pad, pad + (h * 0.45), w, h * 0.55), Paint()..color = const Color(0xFF60A5FA));
    canvas.drawRect(rect, border);
    canvas.drawOval(Rect.fromLTWH(pad, pad - 3, w, 6), border);
    canvas.drawOval(Rect.fromLTWH(pad, pad + h - 3, w, 6), border);
    final red = Paint()..color = const Color(0xFFEF4444)..strokeWidth = 1.0;
    canvas.drawLine(Offset(pad - 3, pad), Offset(pad - 3, pad + h), red);
    canvas.drawLine(Offset(pad, pad - 5), Offset(pad + w, pad - 5), red);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrianglePainter extends CustomPainter {
  const _TrianglePainter();
  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()..color = const Color(0xFF1E293B)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    final path = Path()..moveTo(size.width - 6, 6)..lineTo(size.width - 6, size.height - 6)..lineTo(6, size.height - 6)..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFF1F5F9));
    canvas.drawPath(path, border);
    _label(canvas, 'b', Offset(size.width / 2, size.height - 4));
    _label(canvas, 'h', Offset(size.width - 3, size.height / 2));
  }

  void _label(Canvas canvas, String t, Offset c) {
    final tp = TextPainter(text: TextSpan(text: t, style: const TextStyle(color: Color(0xFF1E293B), fontSize: 9, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
    tp.paint(canvas, Offset(c.dx - tp.width / 2, c.dy - tp.height / 2));
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FootingPainter extends CustomPainter {
  const _FootingPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()..color = const Color(0xFF1E293B)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    final path = Path()
      ..moveTo(size.width * 0.35, 6)..lineTo(size.width * 0.65, 6)..lineTo(size.width * 0.65, size.height * 0.55)
      ..lineTo(size.width - 6, size.height * 0.55)..lineTo(size.width - 6, size.height - 6)..lineTo(6, size.height - 6)
      ..lineTo(6, size.height * 0.55)..lineTo(size.width * 0.35, size.height * 0.55)..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFF94A3B8));
    canvas.drawPath(path, border);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SteelRodsPainter extends CustomPainter {
  const _SteelRodsPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final rod = Paint()..color = const Color(0xFF475569)..strokeWidth = 3.5..strokeCap = StrokeCap.round;
    final rib = Paint()..color = const Color(0xFF94A3B8)..strokeWidth = 1.0;
    for (int i = 0; i < 3; i++) {
      final y = 10.0 + (i * 12.0);
      canvas.drawLine(Offset(6, y), Offset(size.width - 6, y), rod);
      for (double x = 10; x < size.width - 10; x += 6) {
        canvas.drawLine(Offset(x, y - 2), Offset(x + 2, y + 2), rib);
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CylinderPainter extends CustomPainter {
  const _CylinderPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = const Color(0xFF94A3B8);
    final border = Paint()..color = const Color(0xFF1E293B)..style = PaintingStyle.stroke..strokeWidth = 1.2;
    const pad = 4.0;
    final w = size.width - (pad * 2), h = size.height - (pad * 2);
    canvas.drawRect(Rect.fromLTWH(pad, pad + 4, w, h - 8), fill);
    canvas.drawOval(Rect.fromLTWH(pad, pad, w, 8), fill);
    canvas.drawOval(Rect.fromLTWH(pad, pad + h - 8, w, 8), fill);
    canvas.drawLine(Offset(pad, pad + 4), Offset(pad, pad + h - 4), border);
    canvas.drawLine(Offset(pad + w, pad + 4), Offset(pad + w, pad + h - 4), border);
    canvas.drawOval(Rect.fromLTWH(pad, pad, w, 8), border);
    canvas.drawOval(Rect.fromLTWH(pad, pad + h - 8, w, 8), border);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FormworkPainter extends CustomPainter {
  const _FormworkPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()..color = const Color(0xFF1E293B)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    const pad = 6.0;
    final w = size.width - (pad * 2), h = size.height - (pad * 2);
    canvas.drawRect(Rect.fromLTWH(pad, pad, w, h), border);
    canvas.drawRect(Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: w * 0.45, height: h * 0.45), Paint()..color = const Color(0xFF334155));
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ColumnSectionPainter extends CustomPainter {
  final int bars;
  final bool isRound;
  _ColumnSectionPainter({required this.bars, this.isRound = false});

  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()..color = const Color(0xFF1E293B)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    final concrete = Paint()..color = const Color(0xFFF8FAFC);
    final stirrup = Paint()..color = const Color(0xFF475569)..style = PaintingStyle.stroke..strokeWidth = 1.0;
    final dot = Paint()..color = const Color(0xFF0F172A)..style = PaintingStyle.fill;
    const pad = 4.0;
    final w = size.width - (pad * 2), h = size.height - (pad * 2);
    final center = Offset(size.width / 2, size.height / 2);

    if (isRound) {
      canvas.drawCircle(center, w / 2, concrete);
      canvas.drawCircle(center, w / 2, border);
      canvas.drawCircle(center, (w / 2) - 4, stirrup);
      for (int i = 0; i < 6; i++) {
        final angle = (i * 60) * (pi / 180), r = (w / 2) - 7;
        canvas.drawCircle(Offset(center.dx + r * cos(angle), center.dy + r * sin(angle)), 2.8, dot);
      }
    } else {
      canvas.drawRect(Rect.fromLTWH(pad, pad, w, h), concrete);
      canvas.drawRect(Rect.fromLTWH(pad, pad, w, h), border);
      final sRect = Rect.fromCenter(center: center, width: w - 8, height: h - 8);
      canvas.drawRect(sRect, stirrup);

      final l = sRect.left + 3, r = sRect.right - 3, t = sRect.top + 3, b = sRect.bottom - 3;
      final mx = (l + r) / 2, my = (t + b) / 2;
      List<Offset> pos = [Offset(l, t), Offset(r, t), Offset(l, b), Offset(r, b)];
      if (bars >= 6) pos.addAll([Offset(mx, t), Offset(mx, b)]);
      if (bars >= 8) pos.addAll([Offset(l, my), Offset(r, my)]);
      for (final p in pos) {
        canvas.drawCircle(p, 2.5, dot);
      }
    }
  }
  @override
  bool shouldRepaint(covariant _ColumnSectionPainter oldDelegate) => oldDelegate.bars != bars || oldDelegate.isRound != isRound;
}

class _SlabMeshPainter extends CustomPainter {
  const _SlabMeshPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()..color = const Color(0xFF1E293B)..style = PaintingStyle.stroke..strokeWidth = 1.2;
    final grid = Paint()..color = const Color(0xFF334155)..strokeWidth = 1.0;
    const pad = 4.0;
    final w = size.width - (pad * 2), h = size.height - (pad * 2);
    canvas.drawRect(Rect.fromLTWH(pad, pad, w, h), border);
    for (int i = 1; i <= 4; i++) {
      canvas.drawLine(Offset(pad + (w / 5) * i, pad), Offset(pad + (w / 5) * i, pad + h), grid);
      canvas.drawLine(Offset(pad, pad + (h / 5) * i), Offset(pad + w, pad + (h / 5) * i), grid);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WallBlockPainter extends CustomPainter {
  const _WallBlockPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()..color = const Color(0xFF1E293B)..style = PaintingStyle.stroke..strokeWidth = 1.2;
    const pad = 6.0;
    final w = size.width - (pad * 2), h = size.height - (pad * 2);
    final rect = Rect.fromLTWH(pad, pad + 4, w, h - 8);
    canvas.drawRect(rect, Paint()..color = const Color(0xFFCBD5E1));
    canvas.drawRect(rect, border);
    final coreW = (w - 16) / 2;
    canvas.drawRect(Rect.fromLTWH(pad + 5, pad + 8, coreW, h - 16), border);
    canvas.drawRect(Rect.fromLTWH(pad + 11 + coreW, pad + 8, coreW, h - 16), border);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TileGridPainter extends CustomPainter {
  const _TileGridPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()..color = const Color(0xFF1E293B)..style = PaintingStyle.stroke..strokeWidth = 1.2;
    const pad = 6.0;
    final w = size.width - (pad * 2), h = size.height - (pad * 2);
    canvas.drawRect(Rect.fromLTWH(pad, pad, w, h), border);
    canvas.drawLine(Offset(pad + (w / 2), pad), Offset(pad + (w / 2), pad + h), border);
    canvas.drawLine(Offset(pad, pad + (h / 2)), Offset(pad + w, pad + (h / 2)), border);
    canvas.drawRect(Rect.fromLTWH(pad + 1, pad + 1, (w / 2) - 1, (h / 2) - 1), Paint()..color = const Color(0xFF60A5FA));
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
