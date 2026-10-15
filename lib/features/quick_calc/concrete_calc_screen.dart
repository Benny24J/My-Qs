import 'package:flutter/material.dart';
import '../../core/calculator/qs_calculator_engine.dart';
import '../../core/models/calculation_result.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/diagram_painters.dart';
import '../../core/widgets/quick_calc_widgets.dart';

class ConcreteCalcScreen extends StatefulWidget {
  const ConcreteCalcScreen({super.key});

  @override
  State<ConcreteCalcScreen> createState() => _ConcreteCalcScreenState();
}

class _ConcreteCalcScreenState extends State<ConcreteCalcScreen> {
  final _lenCtrl = TextEditingController(text: '6.0');
  final _widCtrl = TextEditingController(text: '4.0');
  final _thickCtrl = TextEditingController(text: '150');
  String _mixRatio = '1:2:4 (Standard Structural)';
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
    _thickCtrl.dispose();
    super.dispose();
  }

  void _recalc() {
    final len = double.tryParse(_lenCtrl.text) ?? 6.0;
    final wid = double.tryParse(_widCtrl.text) ?? 4.0;
    final thickMm = double.tryParse(_thickCtrl.text) ?? 150.0;

    setState(() {
      _result = QsCalculatorEngine.calculateConcrete(
        length: len > 0 ? len : 6.0,
        width: wid > 0 ? wid : 4.0,
        thickness: (thickMm > 0 ? thickMm : 150.0) / 1000.0,
        mixRatio: _mixRatio,
        wastagePercent: _wastage,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final len = double.tryParse(_lenCtrl.text) ?? 6.0;
    final wid = double.tryParse(_widCtrl.text) ?? 4.0;
    final thickMm = double.tryParse(_thickCtrl.text) ?? 150.0;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(title: const Text('Concrete Batching Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 160,
              width: double.infinity,
              child: CustomPaint(
                painter: ConcreteSlabDiagramPainter(length: len, width: wid, depth: thickMm / 1000.0),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lenCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Length', suffixText: 'm'),
                    onChanged: (_) => _recalc(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _widCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Width', suffixText: 'm'),
                    onChanged: (_) => _recalc(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _thickCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Thickness', suffixText: 'mm'),
                    onChanged: (_) => _recalc(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text('Concrete Mix Ratio (Cement : Sand : Granite)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['1:2:4 (Standard Structural)', '1:1.5:3 (High Strength)', '1:3:6 (Lean / Footing Base)'].map((ratio) {
                final sel = _mixRatio == ratio;
                return ChoiceChip(
                  label: Text(ratio),
                  selected: sel,
                  selectedColor: AppTheme.headerBlue,
                  labelStyle: TextStyle(color: sel ? Colors.white : AppTheme.textDark, fontWeight: FontWeight.bold),
                  onSelected: (_) {
                    setState(() => _mixRatio = ratio);
                    _recalc();
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            CalcWasteSlider(
              label: 'Concrete Shrinkage & Spillage Buffer',
              value: _wastage,
              onChanged: (v) {
                setState(() => _wastage = v);
                _recalc();
              },
            ),
            CalcResultView(title: 'Materials to Buy (Cement, Sand & Granite)', result: _result, wastagePercent: _wastage),
          ],
        ),
      ),
    );
  }
}
