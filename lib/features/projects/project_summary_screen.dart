import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/models/project_model.dart';
import '../../core/models/material_item.dart';
import '../../core/calculator/qs_calculator_engine.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/material_result_card.dart';
import '../reports/pdf_report_generator.dart';
import 'create_project_screen.dart';

class ProjectSummaryScreen extends StatefulWidget {
  final ProjectModel project;
  const ProjectSummaryScreen({super.key, required this.project});

  @override
  State<ProjectSummaryScreen> createState() => _ProjectSummaryScreenState();
}

class _ProjectSummaryScreenState extends State<ProjectSummaryScreen> {
  late List<MaterialItem> _summaryMaterials;
  bool _isGeneratingPdf = false;

  @override
  void initState() {
    super.initState();
    _summaryMaterials = QsCalculatorEngine.calculateProjectSummary(widget.project);
  }

  Future<void> _exportPdf() async {
    setState(() => _isGeneratingPdf = true);
    try {
      await PdfReportGenerator.printOrShareReport(widget.project);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error generating PDF: $e')));
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM dd, yyyy');
    final isDark = AppTheme.isDark(context);
    final cardBg = AppTheme.cardBg(context);
    final borderSubtle = AppTheme.borderSubtleColor(context);
    final textPri = AppTheme.textPrimary(context);
    final textSec = AppTheme.textSecondary(context);
    final accent = AppTheme.accentBlue(context);
    final iceBg = AppTheme.iceCardBg(context);
    final iceBorder = AppTheme.iceCardBorder(context);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor(context),
      appBar: AppBar(
        title: const Text('Combined Material Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CreateProjectScreen(initialProject: widget.project))),
          ),
          IconButton(
            icon: _isGeneratingPdf
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.share_outlined),
            tooltip: 'Share PDF',
            onPressed: _isGeneratingPdf ? null : _exportPdf,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.project.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPri)),
                            if (widget.project.clientName.isNotEmpty)
                              Text('Client: ${widget.project.clientName}', style: TextStyle(fontSize: 12, color: textSec)),
                            if (widget.project.location.isNotEmpty)
                              Text('Location: ${widget.project.location}', style: TextStyle(fontSize: 12, color: accent)),
                            Text('Created: ${dateFormatter.format(widget.project.createdAt)}', style: TextStyle(fontSize: 11, color: textSec)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF14532D) : const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: isDark ? const Color(0xFF166534) : const Color(0xFF86EFAC)),
                        ),
                        child: Text(
                          '+${widget.project.wastagePercent.toInt()}% Buffer',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: borderSubtle, height: 1),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _metric(context, 'Total Floor', '${widget.project.totalFloorArea.toStringAsFixed(1)} m²', Icons.crop_square_outlined)),
                      const SizedBox(width: 6),
                      Expanded(child: _metric(context, 'Net Wall', '${widget.project.totalNetWallArea.toStringAsFixed(1)} m²', Icons.foundation_outlined)),
                      const SizedBox(width: 6),
                      Expanded(child: _metric(context, 'Rooms', '${widget.project.rooms.length} Areas', Icons.meeting_room_outlined)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iceBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: iceBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppTheme.headerBlue, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.picture_as_pdf, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Export Schedule Report', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPri)),
                        Text('Share clean PDF with quantities and notes.', style: TextStyle(color: textSec, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: _isGeneratingPdf ? null : _exportPdf,
                    child: const Text('SHARE PDF', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            Text('Master Material Purchasing List (${_summaryMaterials.length} Items)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPri)),
            const SizedBox(height: 10),

            if (_summaryMaterials.isEmpty)
              Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('No materials calculated.', style: TextStyle(color: textSec))))
            else
              ..._summaryMaterials.map((m) => MaterialResultCard(item: m, wastagePercent: widget.project.wastagePercent)),
            const SizedBox(height: 14),

            ExpansionTile(
              backgroundColor: cardBg,
              collapsedBackgroundColor: cardBg,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: borderSubtle)),
              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: borderSubtle)),
              title: Text('Room by Room Breakdown (${widget.project.rooms.length} Areas)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPri)),
              children: widget.project.rooms.map((room) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: iceBg, borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(room.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: accent)),
                      Text('Size: ${room.length}m × ${room.width}m × ${room.height}m  •  Floor: ${room.floorArea.toStringAsFixed(1)} m²', style: TextStyle(fontSize: 11, color: textPri)),
                      Text('Openings: ${room.doorsCount}D / ${room.windowsCount}W  •  Net Wall: ${room.netWallArea.toStringAsFixed(1)} m²', style: TextStyle(fontSize: 11, color: textSec)),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _metric(BuildContext context, String label, String val, IconData icon) {
    final iceBg = AppTheme.iceCardBg(context);
    final accent = AppTheme.accentBlue(context);
    final textSec = AppTheme.textSecondary(context);
    final textPri = AppTheme.textPrimary(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(color: iceBg, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: accent),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 10, color: textSec),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: textPri)),
          ),
        ],
      ),
    );
  }
}
