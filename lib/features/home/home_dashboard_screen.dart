import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/civil_grid_icons.dart';
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

  Widget _buildCard(_DashTile item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardIceBlue,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.cardIceBlueBorder),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Center(child: item.icon)),
            const SizedBox(height: 6),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.titleBlue, fontSize: 12.5, fontWeight: FontWeight.bold, height: 1.2),
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
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(ctx).openDrawer()),
        ),
        title: const Text('Civil Calculation App'),
        actions: [
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
      _DashTile('Paint', const Icon(Icons.brush_outlined, color: AppTheme.titleBlue, size: 36), () => _nav(const PaintCalcScreen())),
      _DashTile('Roofing', const Icon(Icons.roofing_outlined, color: Color(0xFF1E293B), size: 36), () => _nav(const RoofingCalcScreen())),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.88,
            children: items.map(_buildCard).toList(),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => _nav(const CreateProjectScreen()),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(color: AppTheme.cardIceBlue, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.cardIceBlueBorder)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline, color: AppTheme.titleBlue, size: 22),
                  SizedBox(width: 8),
                  Text('Estimate Whole Building / House', style: TextStyle(color: AppTheme.titleBlue, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.15,
            children: slabItems.map(_buildCard).toList(),
          ),
          const SizedBox(height: 18),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Text('Different Bar Beam Calculation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.15,
            children: beamItems.map(_buildCard).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStructureTab() {
    final structItems = [
      _DashTile('Concrete Batching', CivilGridIcons.concreteCylinder(), () => _nav(const ConcreteCalcScreen())),
      _DashTile('Concrete Slab', CivilGridIcons.slabMesh(), () => _nav(const ConcreteCalcScreen())),
      _DashTile('Wall Blocks & Mortar', CivilGridIcons.wallBlock(), () => _nav(const BlocksCalcScreen())),
      _DashTile('Depth of Footing', CivilGridIcons.foundationFooting(), () => _nav(const ConcreteCalcScreen())),
      _DashTile('Roof Framing', const Icon(Icons.roofing_outlined, color: Color(0xFF1E293B), size: 36), () => _nav(const RoofingCalcScreen())),
      _DashTile('Plaster Rendering', const Icon(Icons.format_paint_outlined, color: AppTheme.headerBlue, size: 36), () => _nav(const PlasterCalcScreen())),
    ];

    return GridView.count(
      padding: const EdgeInsets.all(12),
      crossAxisCount: 2,
      mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.15,
      children: structItems.map(_buildCard).toList(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
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
          ListTile(leading: const Icon(Icons.calculate_outlined, color: AppTheme.headerBlue), title: const Text('All Calculators', style: TextStyle(fontWeight: FontWeight.bold)), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.business_outlined, color: AppTheme.headerBlue), title: const Text('Multi-Room Projects', style: TextStyle(fontWeight: FontWeight.bold)), subtitle: const Text('Estimate complete houses or buildings'), onTap: () { Navigator.pop(context); _nav(const ProjectListScreen()); }),
          ListTile(leading: const Icon(Icons.menu_book_outlined, color: AppTheme.headerBlue), title: const Text('Layman Construction Guide', style: TextStyle(fontWeight: FontWeight.bold)), subtitle: const Text('Learn formulas and material terms in plain words'), onTap: () { Navigator.pop(context); _nav(const LaymanGlossaryScreen()); }),
          ListTile(leading: const Icon(Icons.settings_outlined, color: AppTheme.headerBlue), title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)), onTap: () { Navigator.pop(context); _nav(const SettingsScreen()); }),
        ],
      ),
    );
  }
}
