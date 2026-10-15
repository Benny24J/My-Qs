import 'package:flutter/material.dart';
import '../../core/calculator/qs_calculator_engine.dart';
import '../../core/models/calculation_result.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/diagram_painters.dart';
import '../../core/widgets/quick_calc_widgets.dart';

class TilesCalcScreen extends StatefulWidget {
  const TilesCalcScreen({super.key});

  @override
  State<TilesCalcScreen> createState() => _TilesCalcScreenState();
}

class _TilesCalcScreenState extends State<TilesCalcScreen> {
  final _lenCtrl = TextEditingController(text: '4.0');
  final _widCtrl = TextEditingController(text: '3.0');
  final _packSizeCtrl = TextEditingController(text: '10');

  String _preset = '40x40 cm';
  double _tileW = 40.0, _tileL = 40.0, _wastage = 5.0;
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
    _packSizeCtrl.dispose();
    super.dispose();
  }

  void _recalc() {
    final len = double.tryParse(_lenCtrl.text) ?? 4.0;
    final wid = double.tryParse(_widCtrl.text) ?? 3.0;
    final pack = int.tryParse(_packSizeCtrl.text) ?? 10;

    setState(() {
      _result = QsCalculatorEngine.calculateTiles(
        floorLength: len > 0 ? len : 4.0,
        floorWidth: wid > 0 ? wid : 3.0,
        tileWidthCm: _tileW,
        tileLengthCm: _tileL,
        tilesPerPack: pack > 0 ? pack : 10,
        wastagePercent: _wastage,
      );
    });
  }

  void _onPresetChanged(String preset) {
    setState(() {
      _preset = preset;
      if (preset == '30x30 cm') { _tileW = 30; _tileL = 30; }
      else if (preset == '40x40 cm') { _tileW = 40; _tileL = 40; }
      else if (preset == '60x60 cm') { _tileW = 60; _tileL = 60; }
      else if (preset == '60x120 cm') { _tileW = 60; _tileL = 120; }
    });
    _recalc();
  }

  @override
  Widget build(BuildContext context) {
    final len = double.tryParse(_lenCtrl.text) ?? 4.0;
    final wid = double.tryParse(_widCtrl.text) ?? 3.0;
    final isDark = AppTheme.isDark(context);
    final textPri = AppTheme.textPrimary(context);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor(context),
      appBar: AppBar(title: const Text('Floor & Wall Tiles')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 160,
              width: double.infinity,
              child: CustomPaint(
                painter: TileGridDiagramPainter(
                  floorLength: len,
                  floorWidth: wid,
                  tileW: _tileW,
                  tileL: _tileL,
                  isDark: isDark,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lenCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Floor Length', suffixText: 'm'),
                    onChanged: (_) => _recalc(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _widCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Floor Width', suffixText: 'm'),
                    onChanged: (_) => _recalc(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text('Select Tile Size', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPri)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['30x30 cm', '40x40 cm', '60x60 cm', '60x120 cm'].map((p) {
                final sel = _preset == p;
                return ChoiceChip(
                  label: Text(p),
                  selected: sel,
                  backgroundColor: isDark ? const Color(0xFF1B2433) : Colors.white,
                  selectedColor: AppTheme.headerBlue,
                  labelStyle: TextStyle(color: sel ? Colors.white : textPri, fontWeight: FontWeight.bold),
                  onSelected: (_) => _onPresetChanged(p),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 340) {
                  return Column(
                    children: [
                      TextField(
                        controller: _packSizeCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Tiles Per Pack', suffixText: 'pcs'),
                        onChanged: (_) => _recalc(),
                      ),
                      const SizedBox(height: 10),
                      CalcWasteSlider(
                        label: 'Tile Offcut Wastage',
                        value: _wastage,
                        onChanged: (v) {
                          setState(() => _wastage = v);
                          _recalc();
                        },
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _packSizeCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Tiles Per Pack', suffixText: 'pcs'),
                        onChanged: (_) => _recalc(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CalcWasteSlider(
                        label: 'Tile Offcut Wastage',
                        value: _wastage,
                        onChanged: (v) {
                          setState(() => _wastage = v);
                          _recalc();
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            CalcResultView(title: 'Materials to Buy (With Wastage)', result: _result, wastagePercent: _wastage),
          ],
        ),
      ),
    );
  }
}
