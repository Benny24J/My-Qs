import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project_model.dart';

class ProjectStorage {
  static const String _keyProjects = 'my_qs_saved_projects';
  static const String _keyWastageDefault = 'my_qs_default_wastage';
  static const String _keyUnitSystem = 'my_qs_unit_system';
  static const String _keyThemeMode = 'my_qs_theme_mode';

  static Future<void> saveProject(ProjectModel project) async {
    final prefs = await SharedPreferences.getInstance();
    final projects = await getAllProjects();
    final index = projects.indexWhere((p) => p.id == project.id);
    if (index >= 0) {
      projects[index] = project;
    } else {
      projects.insert(0, project);
    }
    await prefs.setString(_keyProjects, jsonEncode(projects.map((p) => p.toJson()).toList()));
  }

  static Future<List<ProjectModel>> getAllProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final rawString = prefs.getString(_keyProjects);
    if (rawString == null || rawString.isEmpty) {
      final seed = _getInitialSampleProjects();
      await prefs.setString(_keyProjects, jsonEncode(seed.map((p) => p.toJson()).toList()));
      return seed;
    }
    try {
      final List<dynamic> decoded = jsonDecode(rawString) as List<dynamic>;
      final List<ProjectModel> result = [];
      for (final item in decoded) {
        try {
          if (item is Map<String, dynamic>) result.add(ProjectModel.fromJson(item));
        } catch (_) {}
      }
      return result.isNotEmpty ? result : _getInitialSampleProjects();
    } catch (_) {
      return _getInitialSampleProjects();
    }
  }

  static Future<void> deleteProject(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final projects = await getAllProjects();
    projects.removeWhere((p) => p.id == id);
    await prefs.setString(_keyProjects, jsonEncode(projects.map((p) => p.toJson()).toList()));
  }

  static Future<double> getDefaultWastage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyWastageDefault) ?? 5.0;
  }

  static Future<void> setDefaultWastage(double val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyWastageDefault, val);
  }

  static Future<String> getUnitSystem() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUnitSystem) ?? 'Metric (m, cm, mm)';
  }

  static Future<void> setUnitSystem(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUnitSystem, unit);
  }

  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeStr = prefs.getString(_keyThemeMode);
    if (modeStr == 'light') return ThemeMode.light;
    if (modeStr == 'system') return ThemeMode.system;
    // Default is dark mode as requested by client
    return ThemeMode.dark;
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    String val = 'dark';
    if (mode == ThemeMode.light) val = 'light';
    if (mode == ThemeMode.system) val = 'system';
    await prefs.setString(_keyThemeMode, val);
  }

  static List<ProjectModel> _getInitialSampleProjects() => [
    ProjectModel(
      id: 'proj-demo-1',
      name: '3-Bedroom Modern Bungalow',
      clientName: 'Chief Okonkwo',
      location: 'Lekki Phase 2, Lagos',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      wastagePercent: 5.0,
      rooms: [
        _room('room-1', 'Master Bedroom', 4.5, 4.0, 3.0, 1, 2, '9-inch (225mm)', '60x60 cm', 4),
        _room('room-2', 'Living & Dining Room', 6.5, 4.5, 3.0, 2, 4, '9-inch (225mm)', '60x60 cm', 4),
        _room('room-3', 'Kitchen & Pantry', 3.5, 3.0, 3.0, 2, 1, '6-inch (150mm)', '40x40 cm', 10),
      ],
    ),
    ProjectModel(
      id: 'proj-demo-2',
      name: 'Office Complex - Block B',
      clientName: 'Apex Logistics Ltd',
      location: 'Victoria Island',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      wastagePercent: 5.0,
      rooms: [
        _room('room-101', 'Conference Room', 8.0, 5.0, 3.2, 2, 3, '9-inch (225mm)', '60x60 cm', 4),
      ],
    ),
  ];

  static RoomModel _room(String id, String name, double l, double w, double h, int d, int win, String block, String tile, int pack) =>
    RoomModel(
      id: id, name: name, length: l, width: w, height: h,
      doorsCount: d, windowsCount: win, includeWalls: true,
      blockType: block, includeFloorTiles: true, tilePreset: tile,
      tilesPerPack: pack, includePlastering: true, includePainting: true,
      includeSlab: true,
    );
}
