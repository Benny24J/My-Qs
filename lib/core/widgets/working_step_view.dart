import 'package:flutter/material.dart';
import '../models/material_item.dart';
import '../theme/app_theme.dart';

class WorkingStepView extends StatefulWidget {
  final List<CalculationStep> steps;
  final double wastagePercent;

  const WorkingStepView({super.key, required this.steps, this.wastagePercent = 5.0});

  @override
  State<WorkingStepView> createState() => _WorkingStepViewState();
}

class _WorkingStepViewState extends State<WorkingStepView> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);
    final cardBg = AppTheme.cardBg(context);
    final borderSubtle = AppTheme.borderSubtleColor(context);
    final textPri = AppTheme.textPrimary(context);
    final textSec = AppTheme.textSecondary(context);
    final accent = AppTheme.accentBlue(context);
    final iceBg = AppTheme.iceCardBg(context);
    final iceBorder = AppTheme.iceCardBorder(context);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(color: iceBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: iceBorder)),
                    child: Icon(Icons.calculate_outlined, color: accent, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Show The Working', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: textPri)),
                        Text('Step-by-step mathematical derivation', style: TextStyle(fontSize: 11, color: textSec), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF14532D) : const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: isDark ? const Color(0xFF166534) : const Color(0xFF86EFAC)),
                    ),
                    child: Text(
                      '+${widget.wastagePercent.toInt()}% Waste',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: textSec),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Divider(color: borderSubtle, height: 1),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: widget.steps.map((step) => _buildStepItem(context, step)).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepItem(BuildContext context, CalculationStep step) {
    final isDark = AppTheme.isDark(context);
    final textPri = AppTheme.textPrimary(context);
    final textSec = AppTheme.textSecondary(context);
    final accent = AppTheme.accentBlue(context);
    final iceBg = AppTheme.iceCardBg(context);
    final boxBg = AppTheme.subtleBoxBg(context);
    final borderStrong = AppTheme.borderStrongColor(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iceBg,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.headerBlue, width: 1.5),
            ),
            child: Text(
              '${step.stepNumber}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: accent),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPri)),
                const SizedBox(height: 2),
                Text(step.description, style: TextStyle(fontSize: 12, color: textSec, height: 1.3)),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: boxBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: borderStrong),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.formula,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontFamily: 'monospace',
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '= ',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: accent),
                          ),
                          Expanded(
                            child: Text(
                              step.result,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: accent),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
