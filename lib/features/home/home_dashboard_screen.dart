import 'package:flutter/material.dart';
import '../../core/storage/project_storage.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/civil_grid_icons.dart';
import '../../main.dart';
import '../quick_calc/blocks_calc_screen.dart';
import '../quick_calc/concrete_calc_screen.dart';
import '../quick_calc/paint_calc_screen.dart';
import '../quick_calc/plaster_calc_screen.dart';
import '../quick_calc/rebar_calc_screen.dart';
import '../quick_calc/roofing_calc_screen.dart';
import '../quick_calc/tiles_calc_screen.dart';
import '../projects/create_project_screen.dart';
import '../projects/project_list_screen.dart';
import '../glossary/layman_glossary_screen.dart';
import '../settings/settings_screen.dart';

class _DashTile {
  final String title;
  final Widget icon;
  final VoidCallback onTap;
  const _DashTile(this.title, this.icon, this.onTap);
}

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _nav(Widget page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  void _toggleTheme() async {
    final newMode = themeModeNotifier.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    themeModeNotifier.value = newMode;
    await ProjectStorage.setThemeMode(newMode);
    setState(() {});
  }

  Widget _buildCard(_DashTile item) {
    final iceBg = AppTheme.iceCardBg(context);
    final iceBorder = AppTheme.iceCardBorder(context);
    final accent = AppTheme.accentBlue(context);

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: iceBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: iceBorder),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: item.icon,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: TextStyle(color: accent, fontSize: 12, fontWeight: FontWeight.bold, height: 1.15),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor(context),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(ctx).openDrawer()),
        ),
        title: const Text('Civil Calculation App'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: _toggleTheme,
          ),
          IconButton(icon: const Icon(Icons.assignment_outlined), tooltip: 'Projects', onPressed: () => _nav(const ProjectListScreen())),
          IconButton(icon: const Icon(Icons.settings_outlined), tooltip: 'Settings', onPressed: () => _nav(const SettingsScreen())),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppTheme.tabIndicatorPink,
          indicatorWeight: 3.5,
          tabs: const [
            Tab(icon: Icon(Icons.view_headline_rounded, size: 20), text: 'Quantity'),
            Tab(icon: Icon(Icons.grid_on_rounded, size: 20), text: 'RCC'),
            Tab(icon: Icon(Icons.layers_outlined, size: 20), text: 'Structure'),
            Tab(icon: Icon(Icons.folder_shared_outlined, size: 20), text: 'Projects'),
          ],
        ),
      ),
      drawer: _buildDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildQuantityTab(),
          _buildRccTab(),
          _buildStructureTab(),
          const ProjectListScreen(isEmbeddedTab: true),
        ],
      ),
    );
  }

  Widget _buildQuantityTab() {
    final isDark = AppTheme.isDark(context);
    final roofIconColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
    final accent = AppTheme.accentBlue(context);
    final iceBg = AppTheme.iceCardBg(context);
    final iceBorder = AppTheme.iceCardBorder(context);

    final items = [
      _DashTile('Tiles', CivilGridIcons.tileGrid(), () => _nav(const TilesCalcScreen())),
      _DashTile('Steel', CivilGridIcons.steelRods(), () => _nav(const RebarCalcScreen())),
      _DashTile('Wall Blocks', CivilGridIcons.wallBlock(), () => _nav(const BlocksCalcScreen())),
      _DashTile('Water Tank', CivilGridIcons.waterTank(), () => _nav(const ConcreteCalcScreen())),
      _DashTile('BOQ', Container(
        width: 38, height: 38,
        decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(6)),
        child: const Icon(Icons.description, color: Colors.white, size: 24),
      ), () => _nav(const ProjectListScreen())),
      _DashTile('Diagonal', CivilGridIcons.diagonalTriangle(), () => _nav(const TilesCalcScreen())),
      _DashTile('Depth of Footing', CivilGridIcons.foundationFooting(), () => _nav(const ConcreteCalcScreen())),
      _DashTile('Concrete Test', CivilGridIcons.concreteCylinder(), () => _nav(const ConcreteCalcScreen())),
      _DashTile('Form Work', CivilGridIcons.formwork(), () => _nav(const ConcreteCalcScreen())),
      _DashTile('Plastering', const Icon(Icons.format_paint_outlined, color: AppTheme.headerBlue, size: 36), () => _nav(const PlasterCalcScreen())),
      _DashTile('Paint', Icon(Icons.brush_outlined, color: accent, size: 36), () => _nav(const PaintCalcScreen())),
      _DashTile('Roofing', Icon(Icons.roofing_outlined, color: roofIconColor, size: 36), () => _nav(const RoofingCalcScreen())),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width > 700 ? 5 : (width > 500 ? 4 : (width < 340 ? 2 : 3));
        final childAspectRatio = width < 340 ? 1.05 : (width < 400 ? 0.92 : 1.0);

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: childAspectRatio,
                children: items.map(_buildCard).toList(),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _nav(const CreateProjectScreen()),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: iceBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: iceBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline, color: accent, size: 22),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Estimate Whole Building / House',
                          style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRccTab() {
    final slabItems = [
      _DashTile('Simple Slab', CivilGridIcons.slabMesh(), () => _nav(const ConcreteCalcScreen())),
      _DashTile('One Way Slab', CivilGridIcons.slabMesh(), () => _nav(const ConcreteCalcScreen())),
      _DashTile('Two Way Slab', CivilGridIcons.slabMesh(), () => _nav(const ConcreteCalcScreen())),
      _DashTile('4 Bar Column', CivilGridIcons.columnSection(bars: 4), () => _nav(const RebarCalcScreen(initialBarsCount: 4))),
      _DashTile('6 Bar Column', CivilGridIcons.columnSection(bars: 6), () => _nav(const RebarCalcScreen(initialBarsCount: 6))),
      _DashTile('Round Column', CivilGridIcons.columnSection(bars: 6, isRound: true), () => _nav(const RebarCalcScreen(initialBarsCount: 6, initialIsRound: true))),
      _DashTile('8 Bar Column', CivilGridIcons.columnSection(bars: 8), () => _nav(const RebarCalcScreen(initialBarsCount: 8))),
      _DashTile('10 Bar Column', CivilGridIcons.columnSection(bars: 10), () => _nav(const RebarCalcScreen(initialBarsCount: 10))),
    ];

    final beamItems = [
      _DashTile('4 Bar Beam', CivilGridIcons.columnSection(bars: 4), () => _nav(const RebarCalcScreen(initialBarsCount: 4, isBeam: true))),
      _DashTile('6 Bar Beam', CivilGridIcons.columnSection(bars: 6), () => _nav(const RebarCalcScreen(initialBarsCount: 6, isBeam: true))),
      _DashTile('8 Bar Beam', CivilGridIcons.columnSection(bars: 8), () => _nav(const RebarCalcScreen(initialBarsCount: 8, isBeam: true))),
      _DashTile('10 Bar Beam', CivilGridIcons.columnSection(bars: 10), () => _nav(const RebarCalcScreen(initialBarsCount: 10, isBeam: true))),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width > 700 ? 4 : (width > 500 ? 3 : 2);
        final ratio = width < 350 ? 1.05 : 1.18;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: ratio,
                children: slabItems.map(_buildCard).toList(),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: Text(
                  'Different Bar Beam Calculation',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary(context)),
                ),
              ),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: ratio,
                children: beamItems.map(_buildCard).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStructureTab() {
    final isDark = AppTheme.isDark(context);
    final roofIconColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);

    final structItems = [
      _DashTile('Concrete Batching', CivilGridIcons.concreteCylinder(), () => _nav(const ConcreteCalcScreen())),
      _DashTile('Concrete Slab', CivilGridIcons.slabMesh(), () => _nav(const ConcreteCalcScreen())),
      _DashTile('Wall Blocks & Mortar', CivilGridIcons.wallBlock(), () => _nav(const BlocksCalcScreen())),
      _DashTile('Depth of Footing', CivilGridIcons.foundationFooting(), () => _nav(const ConcreteCalcScreen())),
      _DashTile('Roof Framing', Icon(Icons.roofing_outlined, color: roofIconColor, size: 36), () => _nav(const RoofingCalcScreen())),
      _DashTile('Plaster Rendering', const Icon(Icons.format_paint_outlined, color: AppTheme.headerBlue, size: 36), () => _nav(const PlasterCalcScreen())),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width > 700 ? 4 : (width > 500 ? 3 : 2);
        final ratio = width < 350 ? 1.05 : 1.18;

        return GridView.count(
          padding: const EdgeInsets.all(12),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: ratio,
          children: structItems.map(_buildCard).toList(),
        );
      },
    );
  }

  Widget _buildDrawer() {
    final cardBg = AppTheme.cardBg(context);
    final textPri = AppTheme.textPrimary(context);
    final textSec = AppTheme.textSecondary(context);

    return Drawer(
      backgroundColor: cardBg,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.headerBlue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.architecture, color: AppTheme.headerBlue, size: 28),
                ),
                const SizedBox(height: 10),
                const Text('My Qs', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('Civil Estimation & Quantity Surveying', style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 12)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calculate_outlined, color: AppTheme.headerBlue),
            title: Text('All Calculators', style: TextStyle(fontWeight: FontWeight.bold, color: textPri)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.business_outlined, color: AppTheme.headerBlue),
            title: Text('Multi-Room Projects', style: TextStyle(fontWeight: FontWeight.bold, color: textPri)),
            subtitle: Text('Estimate complete houses or buildings', style: TextStyle(color: textSec, fontSize: 11)),
            onTap: () { Navigator.pop(context); _nav(const ProjectListScreen()); },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book_outlined, color: AppTheme.headerBlue),
            title: Text('Layman Construction Guide', style: TextStyle(fontWeight: FontWeight.bold, color: textPri)),
            subtitle: Text('Learn formulas and material terms in plain words', style: TextStyle(color: textSec, fontSize: 11)),
            onTap: () { Navigator.pop(context); _nav(const LaymanGlossaryScreen()); },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined, color: AppTheme.headerBlue),
            title: Text('Settings & Preferences', style: TextStyle(fontWeight: FontWeight.bold, color: textPri)),
            onTap: () { Navigator.pop(context); _nav(const SettingsScreen()); },
          ),
        ],
      ),
    );
  }
}
