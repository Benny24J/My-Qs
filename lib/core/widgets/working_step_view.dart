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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderSubtle),
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
                    decoration: BoxDecoration(color: AppTheme.cardIceBlue, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.cardIceBlueBorder)),
                    child: const Icon(Icons.calculate_outlined, color: AppTheme.titleBlue, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Show The Working', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                        Text('Step-by-step mathematical derivation', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFF86EFAC))),
                    child: Text('+${widget.wastagePercent.toInt()}% Waste', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                  ),
                  const SizedBox(width: 6),
                  Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppTheme.textMuted),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(color: AppTheme.borderSubtle, height: 1),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: widget.steps.map((step) => _buildStepItem(step)).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepItem(CalculationStep step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24, height: 24, alignment: Alignment.center,
            decoration: BoxDecoration(color: AppTheme.cardIceBlue, shape: BoxShape.circle, border: Border.all(color: AppTheme.headerBlue, width: 1.5)),
            child: Text('${step.stepNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppTheme.titleBlue)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                const SizedBox(height: 2),
                Text(step.description, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted, height: 1.3)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(6), border: Border.all(color: AppTheme.borderStrong)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(step.formula, style: const TextStyle(fontSize: 12, fontFamily: 'monospace', color: Color(0xFF334155), fontWeight: FontWeight.w600)),
                      Text('= ${step.result}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.titleBlue)),
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
