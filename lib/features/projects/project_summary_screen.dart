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

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        title: const Text('Combined Material Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined), tooltip: 'Edit',
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CreateProjectScreen(initialProject: widget.project))),
          ),
          IconButton(
            icon: _isGeneratingPdf ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.share_outlined),
            tooltip: 'Share PDF', onPressed: _isGeneratingPdf ? null : _exportPdf,
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
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.borderSubtle)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.project.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                            if (widget.project.clientName.isNotEmpty) Text('Client: ${widget.project.clientName}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                            if (widget.project.location.isNotEmpty) Text('Location: ${widget.project.location}', style: const TextStyle(fontSize: 12, color: AppTheme.titleBlue)),
                            Text('Created: ${dateFormatter.format(widget.project.createdAt)}', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFF86EFAC))),
                        child: Text('+${widget.project.wastagePercent.toInt()}% Buffer', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppTheme.borderSubtle, height: 1),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _metric('Total Floor', '${widget.project.totalFloorArea.toStringAsFixed(1)} m²', Icons.crop_square_outlined),
                      const SizedBox(width: 8),
                      _metric('Net Wall Area', '${widget.project.totalNetWallArea.toStringAsFixed(1)} m²', Icons.foundation_outlined),
                      const SizedBox(width: 8),
                      _metric('Rooms', '${widget.project.rooms.length} Areas', Icons.meeting_room_outlined),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.cardIceBlue, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.cardIceBlueBorder)),
              child: Row(
                children: [
                  Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.headerBlue, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.picture_as_pdf, color: Colors.white, size: 22)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Export Schedule Report', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark)),
                        Text('Share clean PDF with quantities and notes.', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                      ],
                    ),
                  ),
                  ElevatedButton(onPressed: _isGeneratingPdf ? null : _exportPdf, child: const Text('SHARE PDF', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            const SizedBox(height: 18),

            Text('Master Material Purchasing List (${_summaryMaterials.length} Items)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const SizedBox(height: 10),

            if (_summaryMaterials.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('No materials calculated.', style: TextStyle(color: AppTheme.textMuted))))
            else
              ..._summaryMaterials.map((m) => MaterialResultCard(item: m, wastagePercent: widget.project.wastagePercent)),
            const SizedBox(height: 14),

            ExpansionTile(
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: AppTheme.borderSubtle)),
              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: AppTheme.borderSubtle)),
              title: Text('Room by Room Breakdown (${widget.project.rooms.length} Areas)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textDark)),
              children: widget.project.rooms.map((room) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppTheme.cardIceBlue, borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(room.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.titleBlue)),
                      Text('Size: ${room.length}m × ${room.width}m × ${room.height}m  •  Floor: ${room.floorArea.toStringAsFixed(1)} m²', style: const TextStyle(fontSize: 11, color: AppTheme.textDark)),
                      Text('Openings: ${room.doorsCount}D / ${room.windowsCount}W  •  Net Wall: ${room.netWallArea.toStringAsFixed(1)} m²', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
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

  Widget _metric(String label, String val, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppTheme.cardIceBlue, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon, size: 14, color: AppTheme.titleBlue), const SizedBox(width: 4), Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted))]),
            const SizedBox(height: 2),
            Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: AppTheme.textDark)),
          ],
        ),
      ),
    );
  }
}
