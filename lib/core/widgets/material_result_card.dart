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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppTheme.cardIceBlue, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppTheme.cardIceBlueBorder)),
                child: Text(item.category.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.titleBlue, letterSpacing: 0.5)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                child: Text('+${wastagePercent.toInt()}% Buffer', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(item.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _box('Exact Quantity', _format(item.exactQuantity), AppTheme.textDark, const Color(0xFFF8FAFC), AppTheme.borderStrong)),
              const SizedBox(width: 8),
              Expanded(child: _box('To Buy (With Buffer)', _format(item.withWastageQuantity), AppTheme.titleBlue, const Color(0xFFEFF6FF), const Color(0xFF93C5FD))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.shopping_bag_outlined, size: 14, color: AppTheme.headerBlue),
              const SizedBox(width: 6),
              Expanded(child: Text('Unit: ${item.unit}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.titleBlue))),
            ],
          ),
          if (item.note.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('💡 ${item.note}', style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted, fontStyle: FontStyle.italic)),
          ],
        ],
      ),
    );
  }

  Widget _box(String label, String val, Color valColor, Color bg, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(val, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: valColor)),
        ],
      ),
    );
  }
}
