class RoomModel {
  final String id;
  String name;
  double length;
  double width;
  double height;
  int doorsCount;
  int windowsCount;
  bool includeWalls;
  String blockType;
  bool includeFloorTiles;
  String tilePreset;
  int tilesPerPack;
  bool includePlastering;
  bool includePainting;
  int paintCoats;
  bool includeSlab;
  double slabThickness;

  RoomModel({
    required this.id,
    required this.name,
    this.length = 4.0,
    this.width = 3.5,
    this.height = 3.0,
    this.doorsCount = 1,
    this.windowsCount = 2,
    this.includeWalls = true,
    this.blockType = '9-inch (225mm)',
    this.includeFloorTiles = true,
    this.tilePreset = '40x40 cm',
    this.tilesPerPack = 10,
    this.includePlastering = true,
    this.includePainting = true,
    this.paintCoats = 2,
    this.includeSlab = false,
    this.slabThickness = 0.15,
  });

  double get floorArea => length * width;
  double get perimeter => 2 * (length + width);
  double get grossWallArea => perimeter * height;
  double get openingDeductions => (doorsCount * (0.9 * 2.1)) + (windowsCount * (1.2 * 1.2));
  double get netWallArea => (grossWallArea - openingDeductions) > 0 ? (grossWallArea - openingDeductions) : 0;

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'length': length, 'width': width, 'height': height,
    'doorsCount': doorsCount, 'windowsCount': windowsCount, 'includeWalls': includeWalls,
    'blockType': blockType, 'includeFloorTiles': includeFloorTiles, 'tilePreset': tilePreset,
    'tilesPerPack': tilesPerPack, 'includePlastering': includePlastering, 'includePainting': includePainting,
    'paintCoats': paintCoats, 'includeSlab': includeSlab, 'slabThickness': slabThickness,
  };

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
    id: json['id'] as String,
    name: json['name'] as String,
    length: (json['length'] as num).toDouble(),
    width: (json['width'] as num).toDouble(),
    height: (json['height'] as num).toDouble(),
    doorsCount: json['doorsCount'] as int? ?? 1,
    windowsCount: json['windowsCount'] as int? ?? 2,
    includeWalls: json['includeWalls'] as bool? ?? true,
    blockType: json['blockType'] as String? ?? '9-inch (225mm)',
    includeFloorTiles: json['includeFloorTiles'] as bool? ?? true,
    tilePreset: json['tilePreset'] as String? ?? '40x40 cm',
    tilesPerPack: json['tilesPerPack'] as int? ?? 10,
    includePlastering: json['includePlastering'] as bool? ?? true,
    includePainting: json['includePainting'] as bool? ?? true,
    paintCoats: json['paintCoats'] as int? ?? 2,
    includeSlab: json['includeSlab'] as bool? ?? false,
    slabThickness: (json['slabThickness'] as num?)?.toDouble() ?? 0.15,
  );
}

class ProjectModel {
  final String id;
  String name;
  String clientName;
  String location;
  DateTime createdAt;
  double wastagePercent;
  List<RoomModel> rooms;

  ProjectModel({
    required this.id,
    required this.name,
    this.clientName = '',
    this.location = '',
    required this.createdAt,
    this.wastagePercent = 5.0,
    List<RoomModel>? rooms,
  }) : rooms = rooms ?? [];

  double get totalFloorArea => rooms.fold(0.0, (sum, r) => sum + r.floorArea);
  double get totalNetWallArea => rooms.fold(0.0, (sum, r) => sum + r.netWallArea);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'clientName': clientName,
    'location': location,
    'createdAt': createdAt.toIso8601String(),
    'wastagePercent': wastagePercent,
    'rooms': rooms.map((r) => r.toJson()).toList(),
  };

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    id: json['id'] as String,
    name: json['name'] as String,
    clientName: json['clientName'] as String? ?? '',
    location: json['location'] as String? ?? '',
    createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    wastagePercent: (json['wastagePercent'] as num?)?.toDouble() ?? 5.0,
    rooms: (json['rooms'] as List<dynamic>?)
        ?.map((r) => RoomModel.fromJson(r as Map<String, dynamic>))
        .toList() ?? [],
  );
}
