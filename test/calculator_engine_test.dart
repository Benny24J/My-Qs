import 'package:flutter_test/flutter_test.dart';
import 'package:my_qs/core/calculator/qs_calculator_engine.dart';
import 'package:my_qs/core/models/project_model.dart';

void main() {
  group('QsCalculatorEngine Unit Tests', () {
    test('calculateBlocks correctly deducts doors and windows and computes materials', () {
      final res = QsCalculatorEngine.calculateBlocks(
        length: 10.0,
        height: 3.0,
        doorsCount: 1,
        windowsCount: 2,
        blockType: '9-inch (225mm)',
        wastagePercent: 5.0,
      );

      final grossArea = 10.0 * 3.0; // 30.0 m2
      final deductions = (1 * 1.89) + (2 * 1.44); // 4.77 m2
      final netArea = grossArea - deductions; // 25.23 m2

      expect(res.baseAreaOrVolume, closeTo(netArea, 0.01));
      final blocks = res.materials.firstWhere((m) => m.name.contains('Blocks'));
      final expectedBlocksWithWaste = (netArea * 10.0 * 1.05).ceilToDouble();
      expect(blocks.withWastageQuantity, equals(expectedBlocksWithWaste));

      final cement = res.materials.firstWhere((m) => m.name.contains('Cement'));
      expect(cement.withWastageQuantity, equals((expectedBlocksWithWaste / 35.0).ceilToDouble()));
    });

    test('calculateConcrete computes dry shrinkage and 1:2:4 ratio parts', () {
      final res = QsCalculatorEngine.calculateConcrete(
        length: 6.0,
        width: 4.0,
        thickness: 0.15,
        mixRatio: '1:2:4 (Standard Structural)',
        wastagePercent: 5.0,
      );

      final wetVol = 6.0 * 4.0 * 0.15; // 3.6 m3
      expect(res.baseAreaOrVolume, closeTo(wetVol, 0.001));

      final dryVolWithWaste = wetVol * 1.54 * 1.05; // 5.8212 m3
      final cementVol = (1.0 / 7.0) * dryVolWithWaste;
      final expectedCementBags = (cementVol / 0.035).ceilToDouble();

      final cement = res.materials.firstWhere((m) => m.name.contains('Cement'));
      expect(cement.withWastageQuantity, equals(expectedCementBags));

      final sand = res.materials.firstWhere((m) => m.name.contains('Sand'));
      final granite = res.materials.firstWhere((m) => m.name.contains('Granite'));
      expect(sand.withWastageQuantity, greaterThan(0));
      expect(granite.withWastageQuantity, greaterThan(sand.withWastageQuantity));
    });

    test('calculateTiles computes tile packs and rounding correctly', () {
      final res = QsCalculatorEngine.calculateTiles(
        floorLength: 4.0,
        floorWidth: 3.0,
        tileWidthCm: 60.0,
        tileLengthCm: 60.0,
        tilesPerPack: 4,
        wastagePercent: 5.0,
      );

      final floorArea = 12.0;
      final singleTileM2 = 0.36;
      final rawTiles = floorArea / singleTileM2; // 33.333
      final tilesWithWaste = rawTiles * 1.05; // 35.0
      final expectedPacks = (tilesWithWaste / 4).ceil(); // 9 packs = 36 pcs

      final tiles = res.materials.firstWhere((m) => m.name.contains('Tiles'));
      expect(tiles.withWastageQuantity, equals((expectedPacks * 4).toDouble()));
    });

    test('calculatePaint rolls over 4+ gallons into full 20L drum', () {
      final res = QsCalculatorEngine.calculatePaint(
        wallArea: 100.0,
        coats: 2,
        coveragePerLitre: 10.0,
        wastagePercent: 5.0,
      );

      final paintMat = res.materials.firstWhere((m) => m.name.contains('Paint'));
      expect(paintMat.unit, contains('Drums'));
      expect(paintMat.unit, contains('Gallons'));
    });

    test('calculatePlaster correctly doubles area when bothSides is true', () {
      final singleRes = QsCalculatorEngine.calculatePlaster(wallArea: 40.0, bothSides: false);
      final doubleRes = QsCalculatorEngine.calculatePlaster(wallArea: 40.0, bothSides: true);

      expect(doubleRes.baseAreaOrVolume, equals(singleRes.baseAreaOrVolume * 2));
      final singleCement = singleRes.materials.firstWhere((m) => m.name.contains('Cement'));
      final doubleCement = doubleRes.materials.firstWhere((m) => m.name.contains('Cement'));
      expect(doubleCement.withWastageQuantity, greaterThanOrEqualTo(singleCement.withWastageQuantity * 2 - 1));
    });

    test('calculateRebarColumn computes standard 12m length rods and stirrup ties', () {
      final res = QsCalculatorEngine.calculateRebarColumn(
        heightM: 3.0,
        barsCount: 4,
        columnsCount: 4,
        wastagePercent: 5.0,
      );

      final mainBar = res.materials.firstWhere((m) => m.name.contains('Main Rebar'));
      final rings = res.materials.firstWhere((m) => m.name.contains('Stirrups'));

      expect(mainBar.withWastageQuantity, greaterThan(0));
      expect(rings.withWastageQuantity, greaterThan(0));
    });

    test('calculateProjectSummary aggregates multi-room project materials', () {
      final project = ProjectModel(
        id: 'test-proj',
        name: 'Test House',
        createdAt: DateTime.now(),
        wastagePercent: 5.0,
        rooms: [
          RoomModel(
            id: 'r1',
            name: 'Room 1',
            length: 4.0,
            width: 3.0,
            height: 3.0,
            includeWalls: true,
            includeFloorTiles: true,
            includePlastering: true,
            includePainting: true,
            includeSlab: true,
          ),
          RoomModel(
            id: 'r2',
            name: 'Room 2',
            length: 5.0,
            width: 4.0,
            height: 3.0,
            includeWalls: true,
            includeFloorTiles: true,
            includePlastering: true,
            includePainting: true,
            includeSlab: true,
          ),
        ],
      );

      final summary = QsCalculatorEngine.calculateProjectSummary(project);
      expect(summary, isNotEmpty);

      final blocks = summary.firstWhere((m) => m.name.contains('Blocks'));
      final tiles = summary.firstWhere((m) => m.name.contains('Tiles'));
      final cement = summary.firstWhere((m) => m.name.contains('Cement'));

      expect(blocks.withWastageQuantity, greaterThan(0));
      expect(tiles.withWastageQuantity, greaterThan(0));
      expect(cement.withWastageQuantity, greaterThan(0));
    });
  });
}
