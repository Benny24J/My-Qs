import 'material_item.dart';

class CalculationResult {
  final String title;
  final String description;
  final double baseAreaOrVolume;
  final String baseUnit;
  final double wastagePercent;
  final List<MaterialItem> materials;
  final List<CalculationStep> steps;

  const CalculationResult({
    required this.title,
    required this.description,
    required this.baseAreaOrVolume,
    required this.baseUnit,
    required this.wastagePercent,
    required this.materials,
    required this.steps,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'baseAreaOrVolume': baseAreaOrVolume,
    'baseUnit': baseUnit,
    'wastagePercent': wastagePercent,
    'materials': materials.map((m) => m.toJson()).toList(),
    'steps': steps.map((s) => s.toJson()).toList(),
  };

  factory CalculationResult.fromJson(Map<String, dynamic> json) => CalculationResult(
    title: json['title'] as String,
    description: json['description'] as String,
    baseAreaOrVolume: (json['baseAreaOrVolume'] as num).toDouble(),
    baseUnit: json['baseUnit'] as String,
    wastagePercent: (json['wastagePercent'] as num).toDouble(),
    materials: (json['materials'] as List<dynamic>)
        .map((e) => MaterialItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    steps: (json['steps'] as List<dynamic>)
        .map((e) => CalculationStep.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
