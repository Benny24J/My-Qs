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
    final iceBg = AppTheme.iceCardBg(context);
    final iceBorder = AppTheme.iceCardBorder(context);
    final accent = AppTheme.accentBlue(context);
    final textPri = AppTheme.textPrimary(context);
    final textSec = AppTheme.textSecondary(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iceBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: iceBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: accent, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPri)),
                const SizedBox(height: 1),
                Text(subtitle, style: TextStyle(color: textSec, fontSize: 11)),
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
    final cardBg = AppTheme.cardBg(context);
    final border = AppTheme.borderStrongColor(context);
    final textSec = AppTheme.textSecondary(context);
    final accent = AppTheme.accentBlue(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 11, color: textSec),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text('+${value.toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: accent)),
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
    final cardBg = AppTheme.cardBg(context);
    final border = AppTheme.borderStrongColor(context);
    final textPri = AppTheme.textPrimary(context);
    final textSec = AppTheme.textSecondary(context);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 11, color: textSec, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                icon: Icon(Icons.remove_circle_outline, size: 20, color: textSec),
                onPressed: count > 0 ? () => onChanged(count - 1) : null,
              ),
              Text('$count', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textPri)),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
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
    final textPri = AppTheme.textPrimary(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPri)),
        const SizedBox(height: 10),
        ...result!.materials.map((m) => MaterialResultCard(item: m, wastagePercent: wastagePercent)),
        const SizedBox(height: 14),
        WorkingStepView(steps: result!.steps, wastagePercent: wastagePercent),
      ],
    );
  }
}
