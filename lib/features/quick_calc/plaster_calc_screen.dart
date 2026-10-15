import 'package:flutter/material.dart';
import '../../core/calculator/qs_calculator_engine.dart';
import '../../core/models/calculation_result.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/quick_calc_widgets.dart';

class PlasterCalcScreen extends StatefulWidget {
  const PlasterCalcScreen({super.key});

  @override
  State<PlasterCalcScreen> createState() => _PlasterCalcScreenState();
}

class _PlasterCalcScreenState extends State<PlasterCalcScreen> {
  final _areaCtrl = TextEditingController(text: '45.0');
  final _thickCtrl = TextEditingController(text: '15');
  bool _bothSides = false;
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
    _thickCtrl.dispose();
    super.dispose();
  }

  void _recalc() {
    final area = double.tryParse(_areaCtrl.text) ?? 45.0;
    final thickMm = double.tryParse(_thickCtrl.text) ?? 15.0;

    setState(() {
      _result = QsCalculatorEngine.calculatePlaster(
        wallArea: area > 0 ? area : 45.0,
        thicknessMm: thickMm > 0 ? thickMm : 15.0,
        bothSides: _bothSides,
        wastagePercent: _wastage,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(title: const Text('Plastering & Rendering')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CalcHeaderBanner(
              icon: Icons.format_paint_outlined,
              title: 'Smooth Wall Rendering',
              subtitle: 'Calculates cement bags and screened fine sand.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _areaCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Wall Surface Area', suffixText: 'm²'),
              onChanged: (_) => _recalc(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _thickCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Plaster Thickness', suffixText: 'mm'),
                    onChanged: (_) => _recalc(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.borderStrong),
                    ),
                    child: CheckboxListTile(
                      value: _bothSides,
                      title: const Text('Both Sides', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                      subtitle: const Text('In & Out', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                      activeColor: AppTheme.headerBlue,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                      onChanged: (val) {
                        setState(() => _bothSides = val ?? false);
                        _recalc();
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CalcWasteSlider(
              label: 'Rebound & Floor Dropping Wastage',
              value: _wastage,
              onChanged: (v) {
                setState(() => _wastage = v);
                _recalc();
              },
            ),
            CalcResultView(title: 'Materials to Buy (Plastering)', result: _result, wastagePercent: _wastage),
          ],
        ),
      ),
    );
  }
}
