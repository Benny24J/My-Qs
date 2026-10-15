class MaterialItem {
  final String name;
  final double exactQuantity;
  final double withWastageQuantity;
  final String unit;
  final String category;
  final String note;

  const MaterialItem({
    required this.name,
    required this.exactQuantity,
    required this.withWastageQuantity,
    required this.unit,
    required this.category,
    this.note = '',
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'exactQuantity': exactQuantity,
    'withWastageQuantity': withWastageQuantity,
    'unit': unit,
    'category': category,
    'note': note,
  };

  factory MaterialItem.fromJson(Map<String, dynamic> json) => MaterialItem(
    name: json['name'] as String,
    exactQuantity: (json['exactQuantity'] as num).toDouble(),
    withWastageQuantity: (json['withWastageQuantity'] as num).toDouble(),
    unit: json['unit'] as String,
    category: json['category'] as String,
    note: json['note'] as String? ?? '',
  );
}

class CalculationStep {
  final int stepNumber;
  final String title;
  final String description;
  final String formula;
  final String result;

  const CalculationStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.formula,
    required this.result,
  });

  Map<String, dynamic> toJson() => {
    'stepNumber': stepNumber,
    'title': title,
    'description': description,
    'formula': formula,
    'result': result,
  };

  factory CalculationStep.fromJson(Map<String, dynamic> json) => CalculationStep(
    stepNumber: json['stepNumber'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    formula: json['formula'] as String,
    result: json['result'] as String,
  );
}
