import 'package:flutter/material.dart';
import '../../core/calculator/qs_calculator_engine.dart';
import '../../core/models/calculation_result.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/quick_calc_widgets.dart';

class PaintCalcScreen extends StatefulWidget {
  const PaintCalcScreen({super.key});

  @override
  State<PaintCalcScreen> createState() => _PaintCalcScreenState();
}

class _PaintCalcScreenState extends State<PaintCalcScreen> {
  final _areaCtrl = TextEditingController(text: '75.0');
  int _coats = 2;
  final double _coverage = 10.0;
  double _wastage = 5.0;
  CalculationResult? _result;

  @override
  void initState() {
    super.initState();
    _recalc();
  }

  @override
  void dispose() {
    _areaCtrl.dispose();
    super.dispose();
  }

  void _recalc() {
    final area = double.tryParse(_areaCtrl.text) ?? 75.0;
    setState(() {
      _result = QsCalculatorEngine.calculatePaint(
        wallArea: area > 0 ? area : 75.0,
        coats: _coats,
        coveragePerLitre: _coverage,
        wastagePercent: _wastage,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);
    final textPri = AppTheme.textPrimary(context);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor(context),
      appBar: AppBar(title: const Text('Wall Paint & Primer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CalcHeaderBanner(
              icon: Icons.brush_outlined,
              title: 'Paint Volume & Containers',
              subtitle: 'Calculates total litres in 20L drums & 4L gallons.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _areaCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Total Wall Surface Area', suffixText: 'm²'),
              onChanged: (_) => _recalc(),
            ),
            const SizedBox(height: 14),
            Text('Number of Paint Coats', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPri)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [1, 2, 3].map((c) {
                final sel = _coats == c;
                return ChoiceChip(
                  label: Text('$c Coat${c > 1 ? "s" : ""}'),
                  selected: sel,
                  backgroundColor: isDark ? const Color(0xFF1B2433) : Colors.white,
                  selectedColor: AppTheme.headerBlue,
                  labelStyle: TextStyle(color: sel ? Colors.white : textPri, fontWeight: FontWeight.bold),
                  onSelected: (_) {
                    setState(() => _coats = c);
                    _recalc();
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            CalcWasteSlider(
              label: 'Roller & Tray Absorption Buffer',
              value: _wastage,
              onChanged: (v) {
                setState(() => _wastage = v);
                _recalc();
              },
            ),
            CalcResultView(title: 'Materials to Buy (Paint)', result: _result, wastagePercent: _wastage),
          ],
        ),
      ),
    );
  }
}
