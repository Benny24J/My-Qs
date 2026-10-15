import 'dart:math';
import '../models/material_item.dart';
import '../models/calculation_result.dart';
import '../models/project_model.dart';

class QsCalculatorEngine {
  static CalculationStep _step(int n, String title, String desc, String formula, String res) =>
      CalculationStep(stepNumber: n, title: title, description: desc, formula: formula, result: res);

  static MaterialItem _mat(String name, double exact, double waste, String unit, String cat, String note) =>
      MaterialItem(name: name, exactQuantity: exact, withWastageQuantity: waste, unit: unit, category: cat, note: note);

  static CalculationResult calculateTiles({
    required double floorLength,
    required double floorWidth,
    double tileWidthCm = 40.0,
    double tileLengthCm = 40.0,
    int tilesPerPack = 10,
    double wastagePercent = 5.0,
  }) {
    final floorArea = max(0.01, floorLength * floorWidth);
    final singleTileM2 = max(0.0001, (tileWidthCm / 100) * (tileLengthCm / 100));
    final rawTiles = floorArea / singleTileM2;
    final wasteFactor = 1.0 + (wastagePercent / 100.0);
    final tilesWithWaste = rawTiles * wasteFactor;
    final totalPacks = (tilesWithWaste / max(1, tilesPerPack)).ceil();
    final adhesiveBags = (floorArea / 4.5).ceil();
    final groutBagsKg = (floorArea * 0.35).ceil();

    return CalculationResult(
      title: 'Floor Tiling Estimate',
      description: 'Complete tile packs, adhesive and grout breakdown for ${floorArea.toStringAsFixed(2)} m²',
      baseAreaOrVolume: floorArea,
      baseUnit: 'm²',
      wastagePercent: wastagePercent,
      materials: [
        _mat('Tiles (${tileWidthCm.toInt()}x${tileLengthCm.toInt()} cm)', rawTiles.ceilToDouble(),
            (totalPacks * tilesPerPack).toDouble(), 'Packs ($totalPacks packs = ${totalPacks * tilesPerPack} pcs)',
            'Finishes', 'Calculated with ${wastagePercent.toInt()}% safety cushion for cuts and breakage.'),
        _mat('Tile Adhesive (20kg bag)', floorArea / 4.5, adhesiveBags.toDouble(), 'Bags', 'Finishes',
            '1 bag of 20kg adhesive covers approx 4 to 5 m².'),
        _mat('Tile Grout Filler', floorArea * 0.35, groutBagsKg.toDouble(), 'Kg', 'Finishes', 'For filling tile joints.'),
      ],
      steps: [
        _step(1, 'Floor Area', 'Multiply room length by width to find total floor area.',
            '${floorLength.toStringAsFixed(2)}m × ${floorWidth.toStringAsFixed(2)}m', '${floorArea.toStringAsFixed(2)} m²'),
        _step(2, 'Single Tile Size', 'Convert tile size from cm to meters and calculate tile area.',
            '(${tileWidthCm}cm ÷ 100) × (${tileLengthCm}cm ÷ 100)', '${singleTileM2.toStringAsFixed(4)} m²'),
        _step(3, 'Base Tile Count & Wastage', 'Divide floor area by single tile area and add ${wastagePercent.toInt()}% waste.',
            '(${floorArea.toStringAsFixed(2)} ÷ ${singleTileM2.toStringAsFixed(4)}) × ${wasteFactor.toStringAsFixed(2)}',
            '${tilesWithWaste.ceil()} tiles (${rawTiles.ceil()} exact + ${(tilesWithWaste - rawTiles).ceil()} waste)'),
        _step(4, 'Market Purchase Packs', 'Divide total tiles by pack size and round up to whole packs.',
            '${tilesWithWaste.ceil()} tiles ÷ $tilesPerPack per pack',
            '$totalPacks Full Packs (${totalPacks * tilesPerPack} tiles total)'),
      ],
    );
  }

  static CalculationResult calculateBlocks({
    required double length,
    required double height,
    int doorsCount = 0,
    int windowsCount = 0,
    String blockType = '9-inch (225mm)',
    double wastagePercent = 5.0,
  }) {
    final grossArea = length * height;
    final deductions = (doorsCount * 1.89) + (windowsCount * 1.44);
    final netArea = max(0.1, grossArea - deductions);
    final rawBlocks = netArea * 10.0;
    final wasteFactor = 1.0 + (wastagePercent / 100.0);
    final blocksWithWaste = (rawBlocks * wasteFactor).ceil();
    final blocksPerCementBag = blockType.contains('6') ? 45.0 : 35.0;
    final cementBags = (blocksWithWaste / blocksPerCementBag).ceil();
    final sandTonnes = cementBags * 0.15;

    return CalculationResult(
      title: 'Wall Blocks & Mortar Estimate',
      description: 'Block pieces, mortar cement and sand for ${netArea.toStringAsFixed(2)} m² wall',
      baseAreaOrVolume: netArea,
      baseUnit: 'm²',
      wastagePercent: wastagePercent,
      materials: [
        _mat('Hollow Sandcrete Blocks ($blockType)', rawBlocks.ceilToDouble(), blocksWithWaste.toDouble(), 'Pieces',
            'Masonry', 'Includes ${wastagePercent.toInt()}% allowance for cracked or cut blocks.'),
        _mat('Mortar Cement (50kg Bag)', rawBlocks / blocksPerCementBag, cementBags.toDouble(), 'Bags', 'Masonry',
            'Used for joint bonding (~1 bag per ${blocksPerCementBag.toInt()} blocks).'),
        _mat('Sharp / Masonry Sand', (rawBlocks / blocksPerCementBag) * 0.15, double.parse(sandTonnes.toStringAsFixed(2)),
            'Tonnes (or ${(sandTonnes / 1.5).toStringAsFixed(2)} m³)', 'Masonry', 'Sand for mortar mix (~1 tonne per 7 bags).'),
      ],
      steps: [
        _step(1, 'Gross Wall Area', 'Calculate total wall face area (Length × Height).',
            '${length.toStringAsFixed(2)}m × ${height.toStringAsFixed(2)}m', '${grossArea.toStringAsFixed(2)} m²'),
        _step(2, 'Openings Deduction', 'Subtract $doorsCount door(s) and $windowsCount window(s).',
            '${grossArea.toStringAsFixed(2)}m² - ${deductions.toStringAsFixed(2)}m²', '${netArea.toStringAsFixed(2)} m² net'),
        _step(3, 'Block Quantity & Wastage', 'Standard wall requires 10 blocks/m² plus ${wastagePercent.toInt()}% waste.',
            '(${netArea.toStringAsFixed(2)} m² × 10) × ${wasteFactor.toStringAsFixed(2)}',
            '$blocksWithWaste Blocks (${rawBlocks.ceil()} exact + ${(blocksWithWaste - rawBlocks.ceil())} waste)'),
        _step(4, 'Mortar Cement & Sand', 'For $blockType wall, 1 cement bag lays approx ${blocksPerCementBag.toInt()} blocks.',
            '$blocksWithWaste blocks ÷ ${blocksPerCementBag.toInt()} blocks/bag',
            '$cementBags Bags Cement + ${sandTonnes.toStringAsFixed(2)} Tonnes Sand'),
      ],
    );
  }

  static CalculationResult calculateConcrete({
    required double length,
    required double width,
    required double thickness,
    String mixRatio = '1:2:4 (Standard Structural)',
    double wastagePercent = 5.0,
  }) {
    final wetVolumeM3 = length * width * thickness;
    final dryVolumeWithWaste = wetVolumeM3 * 1.54 * (1.0 + wastagePercent / 100.0);

    double cPart = 1.0, sPart = 2.0, gPart = 4.0;
    if (mixRatio.contains('1:1.5:3')) {
      sPart = 1.5; gPart = 3.0;
    } else if (mixRatio.contains('1:3:6')) {
      sPart = 3.0; gPart = 6.0;
    }
    final totalParts = cPart + sPart + gPart;

    final cementVol = (cPart / totalParts) * dryVolumeWithWaste;
    final cementBags = (cementVol / 0.035).ceil();
    final sandTonnes = (sPart / totalParts) * dryVolumeWithWaste * 1.55;
    final gravelTonnes = (gPart / totalParts) * dryVolumeWithWaste * 1.60;

    return CalculationResult(
      title: 'Concrete Batching Estimate',
      description: 'Batching quantities for ${wetVolumeM3.toStringAsFixed(2)} m³ concrete',
      baseAreaOrVolume: wetVolumeM3,
      baseUnit: 'm³',
      wastagePercent: wastagePercent,
      materials: [
        _mat('Portland Cement (50kg Bag)', (cementVol / 0.035), cementBags.toDouble(), 'Bags', 'Structure',
            'Mix ratio $mixRatio. 1 bag = 0.035 m³ volume.'),
        _mat('Sharp Sand (Fine Aggregate)', (sPart / totalParts) * wetVolumeM3 * 1.54 * 1.55,
            double.parse(sandTonnes.toStringAsFixed(2)), 'Tonnes (~${(sandTonnes / 1.55).toStringAsFixed(2)} m³)',
            'Structure', 'Clean sharp sand for dense concrete matrix.'),
        _mat('Granite Aggregate (3/4" Coarse)', (gPart / totalParts) * wetVolumeM3 * 1.54 * 1.60,
            double.parse(gravelTonnes.toStringAsFixed(2)), 'Tonnes (~${(gravelTonnes / 1.60).toStringAsFixed(2)} m³)',
            'Structure', 'Crushed granite stones for compressive structural strength.'),
        _mat('Water (Mixing / Hydration)', (cementBags * 28).toDouble(), (cementBags * 28).toDouble(), 'Litres',
            'Structure', 'Approx 28 litres clean water per bag cement.'),
      ],
      steps: [
        _step(1, 'Wet Concrete Volume', 'Length × Width × Thickness.',
            '${length.toStringAsFixed(2)}m × ${width.toStringAsFixed(2)}m × ${thickness.toStringAsFixed(3)}m',
            '${wetVolumeM3.toStringAsFixed(2)} m³ wet volume'),
        _step(2, 'Dry Shrinkage Multiplier', 'Multiply by 1.54 shrinkage factor and safety cushion.',
            '${wetVolumeM3.toStringAsFixed(2)} m³ × 1.54 × ${(1 + wastagePercent / 100).toStringAsFixed(2)}',
            '${dryVolumeWithWaste.toStringAsFixed(3)} m³ dry materials required'),
        _step(3, 'Mix Ratio Share', 'Divide dry volume into $mixRatio parts.',
            'Cement: ${(cPart / totalParts * 100).toStringAsFixed(0)}%, Sand: ${(sPart / totalParts * 100).toStringAsFixed(0)}%, Gravel: ${(gPart / totalParts * 100).toStringAsFixed(0)}%',
            '$cementBags Bags Cement, ${sandTonnes.toStringAsFixed(2)}T Sand, ${gravelTonnes.toStringAsFixed(2)}T Granite'),
      ],
    );
  }

  static CalculationResult calculatePlaster({
    required double wallArea,
    double thicknessMm = 15.0,
    bool bothSides = false,
    double wastagePercent = 5.0,
  }) {
    final effectiveArea = bothSides ? wallArea * 2 : wallArea;
    final dryVolWithWaste = effectiveArea * (thicknessMm / 1000.0) * 1.33 * (1.0 + wastagePercent / 100.0);
    final cementBags = (((1.0 / 5.0) * dryVolWithWaste) / 0.035).ceil();
    final sandTonnes = (4.0 / 5.0) * dryVolWithWaste * 1.55;

    return CalculationResult(
      title: 'Wall Plastering / Rendering',
      description: 'Cement and plaster sand for ${effectiveArea.toStringAsFixed(2)} m² surface',
      baseAreaOrVolume: effectiveArea,
      baseUnit: 'm²',
      wastagePercent: wastagePercent,
      materials: [
        _mat('Plastering Cement (50kg Bag)', ((1.0 / 5.0) * dryVolWithWaste) / 0.035, cementBags.toDouble(), 'Bags',
            'Finishes', '1 bag plasters ~8 to 10 m² at ${thicknessMm.toInt()}mm thickness.'),
        _mat('Plaster Sand (Soft / Screened)', (4.0 / 5.0) * dryVolWithWaste * 1.55, double.parse(sandTonnes.toStringAsFixed(2)),
            'Tonnes', 'Finishes', 'Clean, sieved fine sand for smooth wall rendering.'),
      ],
      steps: [
        _step(1, 'Plastering Surface Area', bothSides ? 'Wall face area × 2 (both internal & external sides).' : 'Single side wall face area.',
            bothSides ? '${wallArea.toStringAsFixed(2)}m² × 2' : '${wallArea.toStringAsFixed(2)}m²', '${effectiveArea.toStringAsFixed(2)} m²'),
        _step(2, 'Mortar Volume & Wastage', 'Multiply area by ${thicknessMm.toInt()}mm thickness and convert with 1.33 dry factor.',
            '${effectiveArea.toStringAsFixed(2)}m² × ${(thicknessMm / 1000).toStringAsFixed(3)}m × 1.33 × ${(1 + wastagePercent / 100).toStringAsFixed(2)}',
            '${dryVolWithWaste.toStringAsFixed(3)} m³ dry mortar'),
        _step(3, 'Cement & Sand Quantities (1:4 Mix)', 'Calculate 1-part cement and 4-parts sand.',
            '(${dryVolWithWaste.toStringAsFixed(3)} ÷ 5) ÷ 0.035 m³/bag',
            '$cementBags Bags Cement + ${sandTonnes.toStringAsFixed(2)} Tonnes Sand'),
      ],
    );
  }

  static CalculationResult calculatePaint({
    required double wallArea,
    int coats = 2,
    double coveragePerLitre = 10.0,
    double wastagePercent = 5.0,
  }) {
    final totalCoatingArea = wallArea * coats;
    final rawLitres = totalCoatingArea / coveragePerLitre;
    final litresWithWaste = rawLitres * (1.0 + wastagePercent / 100.0);

    int drums20L = (litresWithWaste / 20.0).floor();
    int gallons4L = ((litresWithWaste - (drums20L * 20)) / 4.0).ceil();
    if (gallons4L >= 4) {
      drums20L += 1;
      gallons4L = 0;
    }

    return CalculationResult(
      title: 'Wall Painting Estimate',
      description: 'Paint litres and container breakdown for ${wallArea.toStringAsFixed(2)} m²',
      baseAreaOrVolume: wallArea,
      baseUnit: 'm²',
      wastagePercent: wastagePercent,
      materials: [
        _mat('Wall Emulsion / Acrylic Paint', rawLitres, double.parse(litresWithWaste.toStringAsFixed(1)),
            'Litres ($drums20L × 20L Drums + $gallons4L × 4L Gallons)', 'Finishes',
            'Covers $coats coat(s) at ${coveragePerLitre.toInt()} m²/L coverage.'),
        _mat('Wall Primer / Sealer', wallArea / 12.0, (wallArea / 12.0 * (1 + wastagePercent / 100)).ceilToDouble(),
            'Litres', 'Finishes', 'Base coat to seal plaster before paint.'),
        _mat('Painter Rollers & Brushes', 2, 2, 'Sets (2 Rollers + 2 Brushes + Trays)', 'Finishes',
            'Standard application equipment.'),
      ],
      steps: [
        _step(1, 'Total Paint Surface', 'Multiply wall area by $coats coat(s).',
            '${wallArea.toStringAsFixed(2)} m² × $coats coat(s)', '${totalCoatingArea.toStringAsFixed(2)} m²'),
        _step(2, 'Paint Volume & Wastage', 'Standard emulsion coverage (10 m²/L) plus ${wastagePercent.toInt()}% waste.',
            '(${totalCoatingArea.toStringAsFixed(2)} ÷ 10) × ${(1 + wastagePercent / 100).toStringAsFixed(2)}',
            '${litresWithWaste.toStringAsFixed(1)} Litres'),
        _step(3, 'Market Packaging', 'Breakdown into commercial 20L drums and 4L gallons.',
            '${litresWithWaste.toStringAsFixed(1)}L packaging breakdown',
            '$drums20L Drums (20L) and $gallons4L Gallons (4L)'),
      ],
    );
  }

  static CalculationResult calculateRebarColumn({
    required double heightM,
    int barsCount = 4,
    int mainBarDiameterMm = 16,
    int linkDiameterMm = 8,
    double linkSpacingMm = 200,
    double colWidthMm = 225,
    double colBreadthMm = 225,
    int columnsCount = 1,
    double wastagePercent = 5.0,
  }) {
    final barLengthM = heightM + 0.9;
    final totalMainLengthM = barLengthM * barsCount * columnsCount;
    final wasteFactor = 1.0 + (wastagePercent / 100.0);
    final totalMainRods = (totalMainLengthM * wasteFactor / 12.0).ceil();

    final stirrupPerimeterM = (2 * ((colWidthMm - 50) + (colBreadthMm - 50)) + 200) / 1000.0;
    final numberOfLinksPerCol = (heightM / (linkSpacingMm / 1000.0)).ceil() + 1;
    final totalLinksCount = numberOfLinksPerCol * columnsCount;
    final totalLinkLengthM = totalLinksCount * stirrupPerimeterM;
    final totalLinkRods = (totalLinkLengthM * wasteFactor / 12.0).ceil();

    final mainWeightKg = (totalMainRods * 12.0) * ((mainBarDiameterMm * mainBarDiameterMm) / 162.0);
    final linkWeightKg = (totalLinkRods * 12.0) * ((linkDiameterMm * linkDiameterMm) / 162.0);
    final totalSteelWeightKg = mainWeightKg + linkWeightKg;
    final bindingWireKg = max(2.0, (totalSteelWeightKg / 1000.0) * 12.0).ceil();

    return CalculationResult(
      title: 'Column Rebar Reinforcement',
      description: 'Main rods, ring links, and binding wire for $columnsCount column(s)',
      baseAreaOrVolume: heightM * columnsCount,
      baseUnit: 'metres total height',
      wastagePercent: wastagePercent,
      materials: [
        _mat('Main Rebar (${mainBarDiameterMm}mm Rods)', totalMainLengthM / 12.0, totalMainRods.toDouble(),
            'Rods (12m standard = ${mainWeightKg.toStringAsFixed(1)} kg)', 'Structure',
            '$barsCount vertical bars per column for $columnsCount column(s).'),
        _mat('Stirrups / Ring Links (${linkDiameterMm}mm Rods)', totalLinkLengthM / 12.0, totalLinkRods.toDouble(),
            'Rods (12m standard = ${linkWeightKg.toStringAsFixed(1)} kg)', 'Structure',
            'Ties spaced at ${linkSpacingMm.toInt()}mm centers ($totalLinksCount total rings).'),
        _mat('Binding Wire (Annealed Tying Wire)', bindingWireKg.toDouble(), bindingWireKg.toDouble(), 'Kg', 'Structure',
            'For tying main rebar to stirrup rings.'),
      ],
      steps: [
        _step(1, 'Main Reinforcement Steel', 'Calculate vertical rod length (height + lap/bend) × $barsCount bars × $columnsCount column(s).',
            '${barLengthM.toStringAsFixed(2)}m × $barsCount bars × $columnsCount column(s)', '${totalMainLengthM.toStringAsFixed(1)} m total'),
        _step(2, 'Standard 12m Rebar Rods', 'Divide total length by 12m commercial rod length with waste.',
            '(${totalMainLengthM.toStringAsFixed(1)}m × ${wasteFactor.toStringAsFixed(2)}) ÷ 12m',
            '$totalMainRods Full 12m Rods of ${mainBarDiameterMm}mm'),
        _step(3, 'Ring Stirrups (${linkDiameterMm}mm)', 'Calculate ring perimeter and count based on ${linkSpacingMm.toInt()}mm spacing.',
            '$totalLinksCount rings × ${stirrupPerimeterM.toStringAsFixed(2)}m ÷ 12m',
            '$totalLinkRods Full 12m Rods of ${linkDiameterMm}mm ($totalLinksCount rings)'),
        _step(4, 'Total Steel Weight', 'Standard civil formula D² ÷ 162 kg/m.',
            '${mainWeightKg.toStringAsFixed(1)}kg main + ${linkWeightKg.toStringAsFixed(1)}kg links',
            '${totalSteelWeightKg.toStringAsFixed(1)} kg total (${(totalSteelWeightKg / 1000).toStringAsFixed(2)} Tonnes)'),
      ],
    );
  }

  static CalculationResult calculateRoofing({
    required double buildingLength,
    required double buildingWidth,
    double pitchMultiplier = 1.15,
    double overhang = 0.6,
    double sheetWidthM = 0.9,
    double sheetLengthM = 3.0,
    double wastagePercent = 5.0,
  }) {
    final totalLen = buildingLength + (2 * overhang);
    final totalWid = buildingWidth + (2 * overhang);
    final planArea = totalLen * totalWid;
    final pitchedRoofArea = planArea * pitchMultiplier;
    final singleSheetArea = sheetWidthM * sheetLengthM;
    final rawSheets = pitchedRoofArea / singleSheetArea;
    final wasteFactor = 1.0 + (wastagePercent / 100.0);
    final sheetsWithWaste = (rawSheets * wasteFactor).ceil();
    final ridgeCapPieces = (totalLen / 1.0).ceil();
    final roofingScrewsPacks = ((sheetsWithWaste * 6) / 100).ceil();
    final timberLengths = ((pitchedRoofArea * 3.5) / 3.6).ceil();

    return CalculationResult(
      title: 'Roofing & Framing Estimate',
      description: 'Roofing sheets, ridge caps, screws, and timber for ${pitchedRoofArea.toStringAsFixed(2)} m² roof',
      baseAreaOrVolume: pitchedRoofArea,
      baseUnit: 'm²',
      wastagePercent: wastagePercent,
      materials: [
        _mat('Corrugated / Longspan Roofing Sheets', rawSheets.ceilToDouble(), sheetsWithWaste.toDouble(),
            'Sheets ($sheetLengthM m length)', 'Roofing', 'Includes ${wastagePercent.toInt()}% overlap allowance.'),
        _mat('Ridge Caps / Valley Flashings', ridgeCapPieces.toDouble(), (ridgeCapPieces * 1.1).ceilToDouble(),
            'Pieces (1m lengths)', 'Roofing', 'Weather-tight caps for roof apex ridge.'),
        _mat('Roofing Self-Drilling Screws', (sheetsWithWaste * 6).toDouble(), (roofingScrewsPacks * 100).toDouble(),
            'Packs ($roofingScrewsPacks packs = ${roofingScrewsPacks * 100} screws)', 'Roofing', 'Hex-head screws with EPDM washers.'),
        _mat('Roofing Timber Purlins & Rafters (12ft lengths)', timberLengths.toDouble(), (timberLengths * 1.05).ceilToDouble(),
            'Timber Planks (3.6m / 12ft)', 'Roofing', 'Structural timber framing for sheet attachment.'),
      ],
      steps: [
        _step(1, 'Roof Plan Area with Overhangs', 'Add 0.6m eaves overhang to building footprint.',
            '(${buildingLength.toStringAsFixed(2)}m + 1.2m) × (${buildingWidth.toStringAsFixed(2)}m + 1.2m)',
            '${planArea.toStringAsFixed(2)} m² flat footprint'),
        _step(2, 'Pitched Slope Area', 'Multiply by pitch factor ($pitchMultiplier) for roof incline angle.',
            '${planArea.toStringAsFixed(2)} m² × $pitchMultiplier', '${pitchedRoofArea.toStringAsFixed(2)} m² pitched surface'),
        _step(3, 'Roofing Sheet Count', 'Divide pitched roof area by single sheet coverage (${singleSheetArea.toStringAsFixed(2)} m²).',
            '(${pitchedRoofArea.toStringAsFixed(2)} ÷ ${singleSheetArea.toStringAsFixed(2)}) × ${wasteFactor.toStringAsFixed(2)}',
            '$sheetsWithWaste Full Sheets (${rawSheets.ceil()} exact + ${(sheetsWithWaste - rawSheets.ceil())} waste)'),
        _step(4, 'Fixings & Timber', '6 screws per sheet + timber purlins along roof trusses.',
            '$sheetsWithWaste sheets × 6 screws', '$roofingScrewsPacks Packs Screws + $timberLengths Timber Planks'),
      ],
    );
  }

  static List<MaterialItem> calculateProjectSummary(ProjectModel project) {
    double totalBlocks = 0, totalCement = 0, totalSand = 0, totalGranite = 0;
    double totalTilePacks = 0, totalTilePcs = 0, totalAdhesive = 0;
    double totalPaint = 0, totalPrimer = 0;

    for (final room in project.rooms) {
      if (room.includeWalls && room.netWallArea > 0) {
        final bRes = calculateBlocks(
          length: room.perimeter, height: room.height, doorsCount: room.doorsCount,
          windowsCount: room.windowsCount, blockType: room.blockType, wastagePercent: project.wastagePercent,
        );
        for (final m in bRes.materials) {
          if (m.name.contains('Blocks')) totalBlocks += m.withWastageQuantity;
          if (m.name.contains('Mortar Cement')) totalCement += m.withWastageQuantity;
          if (m.name.contains('Sand')) totalSand += m.withWastageQuantity;
        }
      }

      if (room.includeFloorTiles && room.floorArea > 0) {
        double tw = 40, tl = 40;
        if (room.tilePreset.contains('30x30')) { tw = 30; tl = 30; }
        else if (room.tilePreset.contains('60x60')) { tw = 60; tl = 60; }
        else if (room.tilePreset.contains('60x120')) { tw = 60; tl = 120; }

        final tRes = calculateTiles(
          floorLength: room.length, floorWidth: room.width, tileWidthCm: tw,
          tileLengthCm: tl, tilesPerPack: room.tilesPerPack, wastagePercent: project.wastagePercent,
        );
        for (final m in tRes.materials) {
          if (m.name.contains('Tiles')) {
            totalTilePcs += m.withWastageQuantity;
            totalTilePacks += (m.withWastageQuantity / room.tilesPerPack).ceil();
          }
          if (m.name.contains('Tile Adhesive')) totalAdhesive += m.withWastageQuantity;
        }
      }

      if (room.includePlastering && room.netWallArea > 0) {
        final plRes = calculatePlaster(wallArea: room.netWallArea, bothSides: false, wastagePercent: project.wastagePercent);
        for (final m in plRes.materials) {
          if (m.name.contains('Cement')) totalCement += m.withWastageQuantity;
          if (m.name.contains('Sand')) totalSand += m.withWastageQuantity;
        }
      }

      if (room.includePainting && room.netWallArea > 0) {
        final ptRes = calculatePaint(wallArea: room.netWallArea, coats: room.paintCoats, wastagePercent: project.wastagePercent);
        for (final m in ptRes.materials) {
          if (m.name.contains('Paint')) totalPaint += m.withWastageQuantity;
          if (m.name.contains('Primer')) totalPrimer += m.withWastageQuantity;
        }
      }

      if (room.includeSlab && room.floorArea > 0) {
        final cRes = calculateConcrete(length: room.length, width: room.width, thickness: room.slabThickness, wastagePercent: project.wastagePercent);
        for (final m in cRes.materials) {
          if (m.name.contains('Cement')) totalCement += m.withWastageQuantity;
          if (m.name.contains('Sand')) totalSand += m.withWastageQuantity;
          if (m.name.contains('Granite')) totalGranite += m.withWastageQuantity;
        }
      }
    }

    final wasteRate = 1.0 + project.wastagePercent / 100;
    final wTag = '+${project.wastagePercent.toInt()}%';
    final summary = <MaterialItem>[];

    if (totalBlocks > 0) {
      summary.add(_mat('Hollow Sandcrete Blocks', totalBlocks / wasteRate, totalBlocks.ceilToDouble(),
          'Pieces', 'Masonry', 'Combined wall block requirement across all rooms ($wTag waste).'));
    }
    if (totalCement > 0) {
      summary.add(_mat('Portland Cement (50kg)', totalCement / wasteRate, totalCement.ceilToDouble(),
          'Bags', 'General Binding', 'Combined cement for blockwork mortar, plastering, and floor slab.'));
    }
    if (totalSand > 0) {
      summary.add(_mat('Sharp / Plastering Sand', totalSand / wasteRate, double.parse(totalSand.toStringAsFixed(1)),
          'Tonnes (~${(totalSand / 1.55).toStringAsFixed(1)} m³)', 'Aggregates', 'Combined sand for block mortar and plaster.'));
    }
    if (totalGranite > 0) {
      summary.add(_mat('Granite Aggregate (3/4")', totalGranite / wasteRate, double.parse(totalGranite.toStringAsFixed(1)),
          'Tonnes (~${(totalGranite / 1.60).toStringAsFixed(1)} m³)', 'Aggregates', 'Coarse stones for floor slab concrete.'));
    }
    if (totalTilePacks > 0) {
      summary.add(_mat('Floor Tiles', totalTilePcs / wasteRate, totalTilePacks.ceilToDouble(),
          'Packs (${totalTilePcs.toInt()} tiles)', 'Finishes', 'Combined floor tiles across tiled rooms ($wTag cut allowance).'));
    }
    if (totalAdhesive > 0) {
      summary.add(_mat('Tile Adhesive (20kg Bag)', totalAdhesive, totalAdhesive.ceilToDouble(),
          'Bags', 'Finishes', 'Tile cement for fixing floor tiles securely.'));
    }
    if (totalPaint > 0) {
      int drums = (totalPaint / 20).floor();
      int gals = ((totalPaint - (drums * 20)) / 4).ceil();
      if (gals >= 4) { drums += 1; gals = 0; }
      summary.add(_mat('Wall Finish Paint', totalPaint / wasteRate, double.parse(totalPaint.toStringAsFixed(1)),
          'Litres ($drums × 20L Drums + $gals × 4L Gallons)', 'Finishes', 'Internal and external emulsion paint coats.'));
    }
    if (totalPrimer > 0) {
      summary.add(_mat('Wall Primer / Sealer', totalPrimer / wasteRate, totalPrimer.ceilToDouble(),
          'Litres', 'Finishes', 'Sealing coat for new plaster before paint.'));
    }

    return summary;
  }
}
