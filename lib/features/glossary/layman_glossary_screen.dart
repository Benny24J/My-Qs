import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class LaymanGlossaryScreen extends StatelessWidget {
  const LaymanGlossaryScreen({super.key});

  static const _terms = [
    (
      'Wastage (5% - 10%)',
      'Why do we add extra material?',
      'During construction, blocks break when unloaded, tiles get cut to fit corners, and cement gets dropped or stuck to wheelbarrows. The 5% extra ensures you don\'t stop work halfway due to running out of materials.',
      Icons.security_outlined,
    ),
    (
      '1:2:4 Concrete Mix',
      'The standard recipe for strong concrete',
      '1 part Cement + 2 parts Sharp Sand + 4 parts Granite stones. Used for standard building columns, beams, and ground floor slabs.',
      Icons.layers_outlined,
    ),
    (
      'Sandcrete Blocks (6" vs 9")',
      'Hollow building blocks',
      '9-inch (225mm) blocks are standard for load-bearing external perimeter walls. 6-inch (150mm) blocks are lighter and used for internal partition walls.',
      Icons.foundation_outlined,
    ),
    (
      'Rebar / Iron Rods (Y12, Y16, Y20)',
      'Steel reinforcing rods inside concrete',
      'Concrete is great at holding compressive weight pushing down, but cracks easily when bending. Steel rods give concrete tensile strength to hold roofs, balconies, and upper floors.',
      Icons.view_column_outlined,
    ),
    (
      'Stirrups / Link Ties (Y8 or Y10)',
      'The rectangular steel rings',
      'Rings made of 8mm or 10mm steel spaced along columns and beams to hold the vertical rods together and prevent them from bulging outward under heavy load.',
      Icons.crop_square_outlined,
    ),
    (
      'Plaster Rendering (12-15mm)',
      'Smoothing over raw block walls',
      'A mortar mix of cement and soft screened sand applied over blockwork before painting. It protects the blocks from rain penetration and creates a clean flat surface.',
      Icons.format_paint_outlined,
    ),
    (
      'Dry Concrete Shrinkage (1.54 factor)',
      'Why 1m³ wet concrete needs 1.54m³ dry ingredients',
      'When you mix dry sand, cement, and stones with water, water fills the empty microscopic gaps between particles. The wet volume is smaller than the loose dry materials combined, so we multiply by 1.54.',
      Icons.science_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(title: const Text('Layman Construction Guide')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _terms.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final (title, subtitle, desc, icon) = _terms[i];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.borderSubtle),
              boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppTheme.cardIceBlue, borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: AppTheme.titleBlue, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textDark)),
                      const SizedBox(height: 1),
                      Text(subtitle, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppTheme.titleBlue)),
                      const SizedBox(height: 4),
                      Text(desc, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted, height: 1.35)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
