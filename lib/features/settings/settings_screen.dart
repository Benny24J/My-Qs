import 'package:flutter/material.dart';
import '../../core/storage/project_storage.dart';
import '../../core/theme/app_theme.dart';
import '../glossary/layman_glossary_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _defaultWastage = 5.0;
  String _unitSystem = 'Metric (m, cm, mm)';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final w = await ProjectStorage.getDefaultWastage();
    final u = await ProjectStorage.getUnitSystem();
    if (mounted) setState(() { _defaultWastage = w; _unitSystem = u; _isLoading = false; });
  }

  Future<void> _saveWastage(double val) async {
    setState(() => _defaultWastage = val);
    await ProjectStorage.setDefaultWastage(val);
  }

  Future<void> _saveUnit(String unit) async {
    setState(() => _unitSystem = unit);
    await ProjectStorage.setUnitSystem(unit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(title: const Text('Settings & Preferences')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.headerBlue))
          : ListView(
              padding: const EdgeInsets.all(14),
              children: [
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Default Wastage Cushion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textDark)),
                              Text('Applied automatically across new estimates', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                            child: Text('+${_defaultWastage.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF15803D), fontSize: 13)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: _defaultWastage,
                        min: 0,
                        max: 15,
                        divisions: 15,
                        activeColor: AppTheme.headerBlue,
                        onChanged: _saveWastage,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Measurement System', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textDark)),
                      const SizedBox(height: 2),
                      const Text('Choose standard measurement unit for calculations', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: _unitSystem,
                        items: const [
                          DropdownMenuItem(value: 'Metric (m, cm, mm)', child: Text('Metric (metres, cm, mm) - Active Civil Standard')),
                          DropdownMenuItem(value: 'Imperial (ft, in)', child: Text('Imperial (ft, in) - Coming in next release')),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            if (v.contains('Imperial')) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Note: Core engineering calculators use standard Civil Metric units (m, mm, m², m³, tonnes).')),
                              );
                            }
                            _saveUnit(v);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: AppTheme.borderSubtle)),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppTheme.cardIceBlue, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.menu_book_outlined, color: AppTheme.titleBlue, size: 20),
                  ),
                  title: const Text('Layman Construction Guide', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                  subtitle: const Text('Formulas, concrete mixes and material explanations', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                  trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LaymanGlossaryScreen())),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppTheme.cardIceBlue,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.cardIceBlueBorder),
                  ),
                  child: const Column(
                    children: [
                      Text('Civil Calculation App (My Qs)', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.titleBlue, fontSize: 14)),
                      SizedBox(height: 2),
                      Text('Version 1.0.0 • Offline Civil Engineering Tool', style: TextStyle(fontSize: 11.5, color: AppTheme.textDark)),
                      SizedBox(height: 2),
                      Text('Material Quantity Estimator for Site Engineers, Builders & Homeowners', style: TextStyle(fontSize: 10.5, color: AppTheme.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _card({required Widget child}) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppTheme.borderSubtle),
    ),
    child: child,
  );
}
