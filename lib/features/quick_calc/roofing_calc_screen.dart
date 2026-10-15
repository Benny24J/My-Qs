import 'package:flutter/material.dart';
import '../../core/calculator/qs_calculator_engine.dart';
import '../../core/models/calculation_result.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/quick_calc_widgets.dart';

class RoofingCalcScreen extends StatefulWidget {
  const RoofingCalcScreen({super.key});

  @override
  State<RoofingCalcScreen> createState() => _RoofingCalcScreenState();
}

class _RoofingCalcScreenState extends State<RoofingCalcScreen> {
  final _lenCtrl = TextEditingController(text: '12.0');
  final _widCtrl = TextEditingController(text: '8.0');
  final _overhangCtrl = TextEditingController(text: '0.6');

  final double _pitch = 1.15;
  double _sheetLength = 3.0;
  double _wastage = 5.0;
  CalculationResult? _result;

  @override
  void initState() {
    super.initState();
    _recalc();
  }

  @override
  void dispose() {
    _lenCtrl.dispose();
    _widCtrl.dispose();
    _overhangCtrl.dispose();
    super.dispose();
  }

  void _recalc() {
    final len = double.tryParse(_lenCtrl.text) ?? 12.0;
    final wid = double.tryParse(_widCtrl.text) ?? 8.0;
    final ovh = double.tryParse(_overhangCtrl.text) ?? 0.6;

    setState(() {
      _result = QsCalculatorEngine.calculateRoofing(
        buildingLength: len > 0 ? len : 12.0,
        buildingWidth: wid > 0 ? wid : 8.0,
        pitchMultiplier: _pitch,
        overhang: ovh >= 0 ? ovh : 0.6,
        sheetLengthM: _sheetLength,
        wastagePercent: _wastage,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = AppTheme.cardBg(context);
    final textPri = AppTheme.textPrimary(context);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor(context),
      appBar: AppBar(title: const Text('Roofing & Timber Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CalcHeaderBanner(
              icon: Icons.roofing_outlined,
              title: 'Roof Cover & Timber Framing',
              subtitle: 'Calculates longspan sheets, ridge caps & timber purlins.',
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 330) {
                  return Column(
                    children: [
                      TextField(
                        controller: _lenCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Building Length', suffixText: 'm'),
                        onChanged: (_) => _recalc(),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _widCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Building Width', suffixText: 'm'),
                        onChanged: (_) => _recalc(),
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _lenCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Building Length', suffixText: 'm'),
                        onChanged: (_) => _recalc(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _widCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Building Width', suffixText: 'm'),
                        onChanged: (_) => _recalc(),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 340) {
                  return Column(
                    children: [
                      TextField(
                        controller: _overhangCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Eaves Overhang', suffixText: 'm'),
                        onChanged: (_) => _recalc(),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<double>(
                        initialValue: _sheetLength,
                        dropdownColor: cardBg,
                        style: TextStyle(color: textPri, fontSize: 13),
                        decoration: const InputDecoration(labelText: 'Sheet Length'),
                        items: const [
                          DropdownMenuItem(value: 2.4, child: Text('2.4m (8 ft)')),
                          DropdownMenuItem(value: 3.0, child: Text('3.0m (10 ft)')),
                          DropdownMenuItem(value: 3.6, child: Text('3.6m (12 ft)')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _sheetLength = val);
                            _recalc();
                          }
                        },
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _overhangCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Eaves Overhang', suffixText: 'm'),
                        onChanged: (_) => _recalc(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<double>(
                        initialValue: _sheetLength,
                        dropdownColor: cardBg,
                        style: TextStyle(color: textPri, fontSize: 13),
                        decoration: const InputDecoration(labelText: 'Sheet Length'),
                        items: const [
                          DropdownMenuItem(value: 2.4, child: Text('2.4m (8 ft)')),
                          DropdownMenuItem(value: 3.0, child: Text('3.0m (10 ft)')),
                          DropdownMenuItem(value: 3.6, child: Text('3.6m (12 ft)')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _sheetLength = val);
                            _recalc();
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 14),
            CalcWasteSlider(
              label: 'End & Side Overlap Cushion',
              value: _wastage,
              onChanged: (v) {
                setState(() => _wastage = v);
                _recalc();
              },
            ),
            CalcResultView(title: 'Materials to Buy (Roofing)', result: _result, wastagePercent: _wastage),
          ],
        ),
      ),
    );
  }
}
