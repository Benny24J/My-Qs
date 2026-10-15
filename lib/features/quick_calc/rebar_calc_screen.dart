import 'package:flutter/material.dart';
import '../../core/calculator/qs_calculator_engine.dart';
import '../../core/models/calculation_result.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/diagram_painters.dart';
import '../../core/widgets/quick_calc_widgets.dart';

class RebarCalcScreen extends StatefulWidget {
  final int initialBarsCount;
  final bool initialIsRound;
  final bool isBeam;

  const RebarCalcScreen({
    super.key,
    this.initialBarsCount = 4,
    this.initialIsRound = false,
    this.isBeam = false,
  });

  @override
  State<RebarCalcScreen> createState() => _RebarCalcScreenState();
}

class _RebarCalcScreenState extends State<RebarCalcScreen> {
  final _hgtCtrl = TextEditingController(text: '3.0');
  final _countCtrl = TextEditingController(text: '4');

  late int _barsCount = widget.initialBarsCount;
  late bool _isRound = widget.initialIsRound;
  late final bool _isBeam = widget.isBeam;
  int _mainDiameter = 16;
  int _linkDiameter = 8;
  final double _linkSpacing = 200.0;
  double _wastage = 5.0;
  CalculationResult? _result;

  @override
  void initState() {
    super.initState();
    _recalc();
  }

  @override
  void dispose() {
    _hgtCtrl.dispose();
    _countCtrl.dispose();
    super.dispose();
  }

  void _recalc() {
    final hgt = double.tryParse(_hgtCtrl.text) ?? 3.0;
    final count = int.tryParse(_countCtrl.text) ?? 1;

    setState(() {
      _result = QsCalculatorEngine.calculateRebarColumn(
        heightM: hgt > 0 ? hgt : 3.0,
        barsCount: _barsCount,
        mainBarDiameterMm: _mainDiameter,
        linkDiameterMm: _linkDiameter,
        linkSpacingMm: _linkSpacing,
        columnsCount: count > 0 ? count : 1,
        wastagePercent: _wastage,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);
    final cardBg = AppTheme.cardBg(context);
    final textPri = AppTheme.textPrimary(context);
    final textSec = AppTheme.textSecondary(context);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor(context),
      appBar: AppBar(title: Text(_isBeam ? 'RCC Beam Steel Calculator' : 'RCC Steel Rebar Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 160,
              width: double.infinity,
              child: CustomPaint(
                painter: ColumnRebarDiagramPainter(
                  barsCount: _barsCount,
                  barDiameter: _mainDiameter,
                  linkDiameter: _linkDiameter,
                  isRound: _isRound,
                  isDark: isDark,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _isBeam ? 'Beam Rebar Configuration' : 'Column Configuration',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPri),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!_isBeam)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Round', style: TextStyle(fontSize: 11, color: textSec)),
                      Switch(
                        value: _isRound,
                        activeThumbColor: AppTheme.headerBlue,
                        onChanged: (val) {
                          setState(() => _isRound = val);
                          _recalc();
                        },
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [4, 6, 8, 10].map((b) {
                  final sel = _barsCount == b;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('$b-Bar ${_isBeam ? "Beam" : "Column"}'),
                      selected: sel,
                      backgroundColor: isDark ? const Color(0xFF1B2433) : Colors.white,
                      selectedColor: AppTheme.headerBlue,
                      labelStyle: TextStyle(color: sel ? Colors.white : textPri, fontWeight: FontWeight.bold),
                      onSelected: (_) {
                        setState(() => _barsCount = b);
                        _recalc();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 330) {
                  return Column(
                    children: [
                      TextField(
                        controller: _hgtCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: _isBeam ? 'Beam Span / Length' : 'Column Height',
                          suffixText: 'm',
                        ),
                        onChanged: (_) => _recalc(),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _countCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: _isBeam ? 'Number of Beams' : 'Number of Columns',
                          suffixText: 'units',
                        ),
                        onChanged: (_) => _recalc(),
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _hgtCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: _isBeam ? 'Beam Span / Length' : 'Column Height',
                          suffixText: 'm',
                        ),
                        onChanged: (_) => _recalc(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _countCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: _isBeam ? 'Number of Beams' : 'Number of Columns',
                          suffixText: 'units',
                        ),
                        onChanged: (_) => _recalc(),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _mainDiameter,
                    dropdownColor: cardBg,
                    style: TextStyle(color: textPri, fontSize: 13),
                    decoration: const InputDecoration(labelText: 'Main Bar (Y)'),
                    items: const [
                      DropdownMenuItem(value: 12, child: Text('Y12 (12mm)')),
                      DropdownMenuItem(value: 16, child: Text('Y16 (16mm)')),
                      DropdownMenuItem(value: 20, child: Text('Y20 (20mm)')),
                      DropdownMenuItem(value: 25, child: Text('Y25 (25mm)')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _mainDiameter = val);
                        _recalc();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _linkDiameter,
                    dropdownColor: cardBg,
                    style: TextStyle(color: textPri, fontSize: 13),
                    decoration: const InputDecoration(labelText: 'Stirrup Ring (Y)'),
                    items: const [
                      DropdownMenuItem(value: 8, child: Text('Y8 (8mm)')),
                      DropdownMenuItem(value: 10, child: Text('Y10 (10mm)')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _linkDiameter = val);
                        _recalc();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            CalcWasteSlider(
              label: 'Rebar Offcut & Lap Wastage',
              value: _wastage,
              onChanged: (v) {
                setState(() => _wastage = v);
                _recalc();
              },
            ),
            CalcResultView(title: 'Materials to Buy (Steel Rebar)', result: _result, wastagePercent: _wastage),
          ],
        ),
      ),
    );
  }
}
