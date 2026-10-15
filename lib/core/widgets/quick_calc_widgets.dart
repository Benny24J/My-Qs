import 'package:flutter/material.dart';
import '../models/calculation_result.dart';
import '../theme/app_theme.dart';
import 'material_result_card.dart';
import 'working_step_view.dart';

class CalcHeaderBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const CalcHeaderBanner({super.key, required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardIceBlue,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.cardIceBlueBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.titleBlue, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textDark)),
                const SizedBox(height: 1),
                Text(subtitle, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CalcWasteSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const CalcWasteSlider({super.key, required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderStrong),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              Text('+${value.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.titleBlue)),
            ],
          ),
          Slider(
            value: value,
            min: 0,
            max: 15,
            divisions: 15,
            activeColor: AppTheme.headerBlue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class CalcCounterBox extends StatelessWidget {
  final String title;
  final int count;
  final ValueChanged<int> onChanged;

  const CalcCounterBox({super.key, required this.title, required this.count, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderStrong),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.remove_circle_outline, size: 20, color: AppTheme.textMuted),
                onPressed: count > 0 ? () => onChanged(count - 1) : null,
              ),
              Text('$count', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.add_circle_outline, size: 20, color: AppTheme.headerBlue),
                onPressed: () => onChanged(count + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CalcResultView extends StatelessWidget {
  final String title;
  final CalculationResult? result;
  final double wastagePercent;

  const CalcResultView({super.key, required this.title, required this.result, required this.wastagePercent});

  @override
  Widget build(BuildContext context) {
    if (result == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
        const SizedBox(height: 10),
        ...result!.materials.map((m) => MaterialResultCard(item: m, wastagePercent: wastagePercent)),
        const SizedBox(height: 14),
        WorkingStepView(steps: result!.steps, wastagePercent: wastagePercent),
      ],
    );
  }
}
