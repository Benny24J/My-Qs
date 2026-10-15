import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../core/models/project_model.dart';
import '../../core/calculator/qs_calculator_engine.dart';

class PdfReportGenerator {
  static Future<Uint8List> generateProjectReportPdf(ProjectModel project) async {
    final pdf = pw.Document();
    final summaryMaterials = QsCalculatorEngine.calculateProjectSummary(project);
    final dateFormatter = DateFormat('MMMM dd, yyyy');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 16),
            decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.amber, width: 2.5))),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('MY QS', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                    pw.Text('Material Estimation & Quantity Survey Schedule', style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: pw.BoxDecoration(color: PdfColors.amber50, borderRadius: pw.BorderRadius.circular(6), border: pw.Border.all(color: PdfColors.amber)),
                  child: pw.Text('+${project.wastagePercent.toStringAsFixed(0)}% Waste Included', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.amber900)),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 18),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(color: PdfColors.grey100, borderRadius: pw.BorderRadius.circular(8)),
            child: pw.Row(
              children: [
                pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  _meta('PROJECT NAME', project.name),
                  pw.SizedBox(height: 6),
                  _meta('CLIENT', project.clientName.isEmpty ? 'N/A' : project.clientName),
                ])),
                pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  _meta('SITE LOCATION', project.location.isEmpty ? 'Not Specified' : project.location),
                  pw.SizedBox(height: 6),
                  _meta('DATE GENERATED', dateFormatter.format(project.createdAt)),
                ])),
                pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  _meta('TOTAL ROOMS / AREAS', '${project.rooms.length} Areas'),
                  pw.SizedBox(height: 6),
                  _meta('TOTAL FLOOR AREA', '${project.totalFloorArea.toStringAsFixed(1)} m²'),
                ])),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text('1. Master Material Schedule & Purchasing List', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: ['Category', 'Material Description', 'Exact Math', 'To Buy (+${project.wastagePercent.toStringAsFixed(0)}% Waste)', 'Market Unit', 'Note'],
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 9),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
            cellHeight: 26,
            cellAlignments: {0: pw.Alignment.centerLeft, 1: pw.Alignment.centerLeft, 2: pw.Alignment.centerRight, 3: pw.Alignment.centerRight, 4: pw.Alignment.centerLeft, 5: pw.Alignment.centerLeft},
            cellStyle: const pw.TextStyle(fontSize: 8.5),
            data: summaryMaterials.map((m) => [m.category, m.name, _formatNum(m.exactQuantity), _formatNum(m.withWastageQuantity), m.unit, m.note]).toList(),
          ),
          pw.SizedBox(height: 22),
          pw.Text('2. Room & Area Dimensions Breakdown', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: ['Room / Area', 'Dimensions (L × W × H)', 'Floor Area', 'Net Wall Area', 'Openings', 'Scope Works'],
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 9),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey700),
            cellHeight: 24,
            cellAlignments: {0: pw.Alignment.centerLeft, 1: pw.Alignment.center, 2: pw.Alignment.centerRight, 3: pw.Alignment.centerRight, 4: pw.Alignment.center, 5: pw.Alignment.centerLeft},
            cellStyle: const pw.TextStyle(fontSize: 8.5),
            data: project.rooms.map((r) {
              final works = <String>[];
              if (r.includeWalls) works.add('Walls (${r.blockType.split(" ").first})');
              if (r.includeFloorTiles) works.add('Tiles (${r.tilePreset})');
              if (r.includePlastering) works.add('Plaster');
              if (r.includePainting) works.add('Paint (${r.paintCoats} coats)');
              if (r.includeSlab) works.add('Slab');
              return [r.name, '${r.length}m × ${r.width}m × ${r.height}m', '${r.floorArea.toStringAsFixed(1)} m²', '${r.netWallArea.toStringAsFixed(1)} m²', '${r.doorsCount}D / ${r.windowsCount}W', works.join(', ')];
            }).toList(),
          ),
          pw.SizedBox(height: 24),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(color: PdfColors.amber50, borderRadius: pw.BorderRadius.circular(6), border: pw.Border.all(color: PdfColors.amber300)),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Notes on Quantities & Layman Math:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.amber900)),
                pw.SizedBox(height: 4),
                pw.Text(
                  '• A safety allowance of ${project.wastagePercent.toStringAsFixed(0)}% has been automatically factored into the "To Buy" column to compensate for site offcuts, broken blocks, and spillage.\n'
                  '• Door openings are calculated at standard 0.9m × 2.1m (1.89m² each) and Windows at standard 1.2m × 1.2m (1.44m² each) deducted from total wall face area.\n'
                  '• Cement bags are calculated based on standard 50kg bags.\n'
                  '• Take this schedule directly to your building material supplier for supply and delivery.',
                  style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey800, lineSpacing: 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static Future<void> printOrShareReport(ProjectModel project) async {
    final pdfData = await generateProjectReportPdf(project);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
      name: '${project.name.replaceAll(" ", "_")}_MyQS_Estimate.pdf',
    );
  }

  static pw.Widget _meta(String label, String value) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(label, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600, letterSpacing: 0.5)),
      pw.SizedBox(height: 2),
      pw.Text(value, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
    ],
  );

  static String _formatNum(double val) => val % 1 == 0 ? val.toInt().toString() : val.toStringAsFixed(1);
}
