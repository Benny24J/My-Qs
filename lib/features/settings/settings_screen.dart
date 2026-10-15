import 'package:flutter/material.dart';
import '../../core/storage/project_storage.dart';
import '../../core/theme/app_theme.dart';
import '../../main.dart';
import '../glossary/layman_glossary_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _defaultWastage = 5.0;
  String _unitSystem = 'Metric (m, cm, mm)';
  ThemeMode _currentThemeMode = ThemeMode.dark;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final w = await ProjectStorage.getDefaultWastage();
    final u = await ProjectStorage.getUnitSystem();
    final tm = await ProjectStorage.getThemeMode();
    if (mounted) {
      setState(() {
        _defaultWastage = w;
        _unitSystem = u;
        _currentThemeMode = tm;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveWastage(double val) async {
    setState(() => _defaultWastage = val);
    await ProjectStorage.setDefaultWastage(val);
  }

  Future<void> _saveUnit(String unit) async {
    setState(() => _unitSystem = unit);
    await ProjectStorage.setUnitSystem(unit);
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    setState(() => _currentThemeMode = mode);
    themeModeNotifier.value = mode;
    await ProjectStorage.setThemeMode(mode);
  }

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

    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor(context),
      appBar: AppBar(title: const Text('Settings & Preferences')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.headerBlue))
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              children: [
                // Theme Appearance Section
                _card(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: accent, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('App Theme & Appearance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPri)),
                                Text('Client dark mode default with light option', style: TextStyle(fontSize: 11, color: textSec)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _themeOption(
                              label: 'Dark (Default)',
                              icon: Icons.dark_mode_outlined,
                              mode: ThemeMode.dark,
                              isSelected: _currentThemeMode == ThemeMode.dark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _themeOption(
                              label: 'Light Mode',
                              icon: Icons.light_mode_outlined,
                              mode: ThemeMode.light,
                              isSelected: _currentThemeMode == ThemeMode.light,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _themeOption(
                              label: 'System',
                              icon: Icons.brightness_auto_outlined,
                              mode: ThemeMode.system,
                              isSelected: _currentThemeMode == ThemeMode.system,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Wastage Cushion Card
                _card(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Default Wastage Cushion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPri)),
                                Text('Applied automatically across new estimates', style: TextStyle(fontSize: 11, color: textSec), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
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
                              '+${_defaultWastage.toInt()}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D),
                                fontSize: 13,
                              ),
                            ),
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

                // Measurement System Card
                _card(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Measurement System', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPri)),
                      const SizedBox(height: 2),
                      Text('Choose standard measurement unit for calculations', style: TextStyle(fontSize: 11, color: textSec)),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: _unitSystem,
                        isExpanded: true,
                        dropdownColor: cardBg,
                        style: TextStyle(color: textPri, fontSize: 13),
                        items: const [
                          DropdownMenuItem(
                            value: 'Metric (m, cm, mm)',
                            child: Text('Metric (metres, cm, mm) - Active Standard', overflow: TextOverflow.ellipsis),
                          ),
                          DropdownMenuItem(
                            value: 'Imperial (ft, in)',
                            child: Text('Imperial (ft, in) - Coming in next release', overflow: TextOverflow.ellipsis),
                          ),
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

                // Glossary ListTile
                ListTile(
                  tileColor: cardBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: borderSubtle),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: iceBg, borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.menu_book_outlined, color: accent, size: 20),
                  ),
                  title: Text('Layman Construction Guide', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: textPri)),
                  subtitle: Text('Formulas, concrete mixes and material explanations', style: TextStyle(fontSize: 11, color: textSec), maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Icon(Icons.chevron_right, color: textSec),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LaymanGlossaryScreen())),
                ),
                const SizedBox(height: 20),

                // App Info Box
                Container(
                  padding: const EdgeInsets.all(14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: iceBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: iceBorder),
                  ),
                  child: Column(
                    children: [
                      Text('Civil Calculation App (My Qs)', style: TextStyle(fontWeight: FontWeight.bold, color: accent, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text('Version 1.0.0 • Offline Civil Engineering Tool', style: TextStyle(fontSize: 11.5, color: textPri)),
                      const SizedBox(height: 2),
                      Text('Material Quantity Estimator for Site Engineers, Builders & Homeowners', textAlign: TextAlign.center, style: TextStyle(fontSize: 10.5, color: textSec)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _themeOption({
    required String label,
    required IconData icon,
    required ThemeMode mode,
    required bool isSelected,
  }) {
    final activeColor = AppTheme.headerBlue;
    final isDark = AppTheme.isDark(context);
    final border = isSelected
        ? activeColor
        : (isDark ? const Color(0xFF2E3A4E) : const Color(0xFFE2E8F0));
    final bg = isSelected
        ? activeColor.withValues(alpha: 0.15)
        : (isDark ? const Color(0xFF131924) : const Color(0xFFF8FAFC));

    return InkWell(
      onTap: () => _saveThemeMode(mode),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border, width: isSelected ? 1.8 : 1.0),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: isSelected ? activeColor : AppTheme.textSecondary(context)),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? activeColor : AppTheme.textPrimary(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(BuildContext context, {required Widget child}) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppTheme.cardBg(context),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppTheme.borderSubtleColor(context)),
    ),
    child: child,
  );
}
