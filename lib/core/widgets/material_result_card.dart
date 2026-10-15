import 'package:flutter/material.dart';
import '../models/material_item.dart';
import '../theme/app_theme.dart';

class MaterialResultCard extends StatelessWidget {
  final MaterialItem item;
  final double wastagePercent;

  const MaterialResultCard({super.key, required this.item, this.wastagePercent = 5.0});

  String _format(double v) => v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(1);

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

    final exactBg = isDark ? const Color(0xFF131924) : const Color(0xFFF8FAFC);
    final exactBorder = isDark ? const Color(0xFF283447) : AppTheme.borderStrong;

    final buyBg = isDark ? const Color(0xFF172439) : const Color(0xFFEFF6FF);
    final buyBorder = isDark ? const Color(0xFF2E466B) : const Color(0xFF93C5FD);
    final buyValColor = isDark ? const Color(0xFF60A5FA) : AppTheme.titleBlue;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: iceBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: iceBorder),
                  ),
                  child: Text(
                    item.category.toUpperCase(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: accent, letterSpacing: 0.5),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF14532D) : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '+${wastagePercent.toInt()}% Buffer',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(item.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textPri)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _box(
                  label: 'Exact Quantity',
                  val: _format(item.exactQuantity),
                  valColor: textPri,
                  bg: exactBg,
                  border: exactBorder,
                  mutedColor: textSec,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _box(
                  label: 'To Buy (+Buffer)',
                  val: _format(item.withWastageQuantity),
                  valColor: buyValColor,
                  bg: buyBg,
                  border: buyBorder,
                  mutedColor: textSec,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.shopping_bag_outlined, size: 14, color: AppTheme.headerBlue),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Unit: ${item.unit}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: accent),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (item.note.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('💡 ${item.note}', style: TextStyle(fontSize: 11.5, color: textSec, fontStyle: FontStyle.italic)),
          ],
        ],
      ),
    );
  }

  Widget _box({
    required String label,
    required String val,
    required Color valColor,
    required Color bg,
    required Color border,
    required Color mutedColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(label, style: TextStyle(fontSize: 11, color: mutedColor, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(val, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: valColor)),
          ),
        ],
      ),
    );
  }
}
