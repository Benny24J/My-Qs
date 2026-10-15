import 'package:flutter/material.dart';
import '../../core/calculator/qs_calculator_engine.dart';
import '../../core/models/calculation_result.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/diagram_painters.dart';
import '../../core/widgets/quick_calc_widgets.dart';

class BlocksCalcScreen extends StatefulWidget {
  const BlocksCalcScreen({super.key});

  @override
  State<BlocksCalcScreen> createState() => _BlocksCalcScreenState();
}

class _BlocksCalcScreenState extends State<BlocksCalcScreen> {
  final _lenCtrl = TextEditingController(text: '10.0');
  final _hgtCtrl = TextEditingController(text: '3.0');
  int _doors = 1, _windows = 2;
  String _blockType = '9-inch (225mm)';
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
    _hgtCtrl.dispose();
    super.dispose();
  }

  void _recalc() {
    final len = double.tryParse(_lenCtrl.text) ?? 10.0;
    final hgt = double.tryParse(_hgtCtrl.text) ?? 3.0;
    setState(() {
      _result = QsCalculatorEngine.calculateBlocks(
        length: len > 0 ? len : 10.0,
        height: hgt > 0 ? hgt : 3.0,
        doorsCount: _doors,
        windowsCount: _windows,
        blockType: _blockType,
        wastagePercent: _wastage,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final len = double.tryParse(_lenCtrl.text) ?? 10.0;
    final hgt = double.tryParse(_hgtCtrl.text) ?? 3.0;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(title: const Text('Wall Blocks & Mortar')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 160,
              width: double.infinity,
              child: CustomPaint(
                painter: WallDiagramPainter(length: len, height: hgt, doors: _doors, windows: _windows),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lenCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Wall Length', suffixText: 'm'),
                    onChanged: (_) => _recalc(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _hgtCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Wall Height', suffixText: 'm'),
                    onChanged: (_) => _recalc(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text('Block Thickness / Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark)),
            const SizedBox(height: 6),
            Row(
              children: ['9-inch (225mm)', '6-inch (150mm)'].map((t) {
                final sel = _blockType == t;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Center(child: Text(t)),
                      selected: sel,
                      selectedColor: AppTheme.headerBlue,
                      labelStyle: TextStyle(color: sel ? Colors.white : AppTheme.textDark, fontWeight: FontWeight.bold),
                      onSelected: (_) {
                        setState(() => _blockType = t);
                        _recalc();
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: CalcCounterBox(
                    title: 'Doors (0.9×2.1m)',
                    count: _doors,
                    onChanged: (v) {
                      setState(() => _doors = v);
                      _recalc();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CalcCounterBox(
                    title: 'Windows (1.2×1.2m)',
                    count: _windows,
                    onChanged: (v) {
                      setState(() => _windows = v);
                      _recalc();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            CalcWasteSlider(
              label: 'Wastage Allowance (Broken blocks & cuts)',
              value: _wastage,
              onChanged: (v) {
                setState(() => _wastage = v);
                _recalc();
              },
            ),
            CalcResultView(title: 'Materials to Buy (Blockwork)', result: _result, wastagePercent: _wastage),
          ],
        ),
      ),
    );
  }
}
