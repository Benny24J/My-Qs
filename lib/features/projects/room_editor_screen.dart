import 'package:flutter/material.dart';
import '../../core/models/project_model.dart';
import '../../core/theme/app_theme.dart';

class RoomEditorScreen extends StatefulWidget {
  final RoomModel? initialRoom;
  const RoomEditorScreen({super.key, this.initialRoom});

  @override
  State<RoomEditorScreen> createState() => _RoomEditorScreenState();
}

class _RoomEditorScreenState extends State<RoomEditorScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _lengthController;
  late final TextEditingController _widthController;
  late final TextEditingController _heightController;

  late int _doorsCount, _windowsCount, _tilesPerPack, _paintCoats;
  late bool _includeWalls, _includeFloorTiles, _includePlastering, _includePainting, _includeSlab;
  late String _blockType, _tilePreset;
  late double _slabThickness;

  @override
  void initState() {
    super.initState();
    final r = widget.initialRoom;
    _nameController = TextEditingController(text: r?.name ?? 'Master Bedroom');
    _lengthController = TextEditingController(text: r != null ? r.length.toString() : '4.0');
    _widthController = TextEditingController(text: r != null ? r.width.toString() : '3.5');
    _heightController = TextEditingController(text: r != null ? r.height.toString() : '3.0');

    _doorsCount = r?.doorsCount ?? 1;
    _windowsCount = r?.windowsCount ?? 2;
    _includeWalls = r?.includeWalls ?? true;
    _blockType = r?.blockType ?? '9-inch (225mm)';
    _includeFloorTiles = r?.includeFloorTiles ?? true;
    _tilePreset = r?.tilePreset ?? '40x40 cm';
    _tilesPerPack = r?.tilesPerPack ?? 10;
    _includePlastering = r?.includePlastering ?? true;
    _includePainting = r?.includePainting ?? true;
    _paintCoats = r?.paintCoats ?? 2;
    _includeSlab = r?.includeSlab ?? false;
    _slabThickness = r?.slabThickness ?? 0.15;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _saveRoom() {
    final rawLen = double.tryParse(_lengthController.text);
    final rawWid = double.tryParse(_widthController.text);
    final rawHgt = double.tryParse(_heightController.text);

    if (rawLen == null || rawLen <= 0 || rawWid == null || rawWid <= 0 || rawHgt == null || rawHgt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter positive length, width, and height values.'), backgroundColor: AppTheme.dangerRed),
      );
      return;
    }

    final name = _nameController.text.trim().isEmpty ? 'Room' : _nameController.text.trim();
    Navigator.pop(context, RoomModel(
      id: widget.initialRoom?.id ?? 'room-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      length: rawLen,
      width: rawWid,
      height: rawHgt,
      doorsCount: _doorsCount,
      windowsCount: _windowsCount,
      includeWalls: _includeWalls,
      blockType: _blockType,
      includeFloorTiles: _includeFloorTiles,
      tilePreset: _tilePreset,
      tilesPerPack: _tilesPerPack,
      includePlastering: _includePlastering,
      includePainting: _includePainting,
      paintCoats: _paintCoats,
      includeSlab: _includeSlab,
      slabThickness: _slabThickness,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final len = double.tryParse(_lengthController.text) ?? 4.0;
    final wid = double.tryParse(_widthController.text) ?? 3.5;
    final floorArea = len * wid;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        title: Text(widget.initialRoom == null ? 'Add Room / Area' : 'Edit Room'),
        actions: [
          TextButton(onPressed: _saveRoom, child: const Text('SAVE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Room Name', hintText: 'e.g. Master Bedroom, Living Room'),
            ),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Master Bed', 'Living Room', 'Kitchen', 'Dining', 'Office', 'Veranda', 'Store'].map((preset) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ActionChip(
                      label: Text(preset, style: const TextStyle(fontSize: 11)),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: AppTheme.borderSubtle),
                      onPressed: () => setState(() => _nameController.text = preset),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.borderSubtle)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Room Dimensions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textDark)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.cardIceBlue, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppTheme.cardIceBlueBorder)),
                        child: Text('Floor Area: ${floorArea.toStringAsFixed(1)} m²', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.titleBlue)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: _lengthController, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Length', suffixText: 'm'), onChanged: (_) => setState(() {}))),
                      const SizedBox(width: 8),
                      Expanded(child: TextField(controller: _widthController, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Width', suffixText: 'm'), onChanged: (_) => setState(() {}))),
                      const SizedBox(width: 8),
                      Expanded(child: TextField(controller: _heightController, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Height', suffixText: 'm'), onChanged: (_) => setState(() {}))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _buildCounter('Doors (0.9x2.1m)', _doorsCount, (v) => setState(() => _doorsCount = v))),
                      const SizedBox(width: 8),
                      Expanded(child: _buildCounter('Windows (1.2x1.2m)', _windowsCount, (v) => setState(() => _windowsCount = v))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Works Included for this Room', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textDark)),
            const SizedBox(height: 8),

            _buildScopeTile(
              title: 'Wall Blocks & Mortar', subtitle: 'Sandcrete blocks and joint mortar',
              icon: Icons.foundation_outlined, value: _includeWalls, onChanged: (v) => setState(() => _includeWalls = v),
              extra: _includeWalls ? DropdownButtonFormField<String>(
                initialValue: _blockType, decoration: const InputDecoration(labelText: 'Block Thickness'),
                items: const [DropdownMenuItem(value: '9-inch (225mm)', child: Text('9-inch (225mm)')), DropdownMenuItem(value: '6-inch (150mm)', child: Text('6-inch (150mm)'))],
                onChanged: (v) => v != null ? setState(() => _blockType = v) : null,
              ) : null,
            ),
            const SizedBox(height: 8),

            _buildScopeTile(
              title: 'Floor Tiles & Adhesive', subtitle: 'Tile packs and adhesive bags',
              icon: Icons.grid_on_outlined, value: _includeFloorTiles, onChanged: (v) => setState(() => _includeFloorTiles = v),
              extra: _includeFloorTiles ? Row(
                children: [
                  Expanded(child: DropdownButtonFormField<String>(
                    initialValue: _tilePreset, decoration: const InputDecoration(labelText: 'Tile Size'),
                    items: const [DropdownMenuItem(value: '30x30 cm', child: Text('30x30 cm')), DropdownMenuItem(value: '40x40 cm', child: Text('40x40 cm')), DropdownMenuItem(value: '60x60 cm', child: Text('60x60 cm')), DropdownMenuItem(value: '60x120 cm', child: Text('60x120 cm'))],
                    onChanged: (v) => v != null ? setState(() => _tilePreset = v) : null,
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: TextFormField(
                    initialValue: _tilesPerPack.toString(), keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Tiles/Pack', suffixText: 'pcs'),
                    onChanged: (v) => _tilesPerPack = int.tryParse(v) ?? 10,
                  )),
                ],
              ) : null,
            ),
            const SizedBox(height: 8),

            _buildScopeTile(title: 'Wall Plastering', subtitle: 'Internal wall surface rendering', icon: Icons.format_paint_outlined, value: _includePlastering, onChanged: (v) => setState(() => _includePlastering = v)),
            const SizedBox(height: 8),

            _buildScopeTile(
              title: 'Wall Painting', subtitle: 'Emulsion & primer coats',
              icon: Icons.brush_outlined, value: _includePainting, onChanged: (v) => setState(() => _includePainting = v),
              extra: _includePainting ? DropdownButtonFormField<int>(
                initialValue: _paintCoats, decoration: const InputDecoration(labelText: 'Number of Coats'),
                items: const [DropdownMenuItem(value: 1, child: Text('1 Coat')), DropdownMenuItem(value: 2, child: Text('2 Coats (Standard)')), DropdownMenuItem(value: 3, child: Text('3 Coats (Premium)'))],
                onChanged: (v) => v != null ? setState(() => _paintCoats = v) : null,
              ) : null,
            ),
            const SizedBox(height: 8),

            _buildScopeTile(title: 'Concrete Floor Slab', subtitle: 'Oversite concrete casting (1:2:4)', icon: Icons.layers_outlined, value: _includeSlab, onChanged: (v) => setState(() => _includeSlab = v)),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text('SAVE ROOM DETAILS'),
                onPressed: _saveRoom,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildScopeTile({required String title, required String subtitle, required IconData icon, required bool value, required ValueChanged<bool> onChanged, Widget? extra}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: value ? AppTheme.headerBlue : AppTheme.borderSubtle)),
      child: Column(
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.cardIceBlue, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: AppTheme.titleBlue, size: 20)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark)), const SizedBox(height: 1), Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted))])),
              Switch(value: value, activeThumbColor: AppTheme.headerBlue, onChanged: onChanged),
            ],
          ),
          if (extra != null) ...[const SizedBox(height: 10), extra],
        ],
      ),
    );
  }

  Widget _buildCounter(String title, int count, ValueChanged<int> onChanged) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.borderStrong)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(onTap: count > 0 ? () => onChanged(count - 1) : null, child: const Icon(Icons.remove, size: 18, color: AppTheme.textMuted)),
              Text('$count', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark)),
              InkWell(onTap: () => onChanged(count + 1), child: const Icon(Icons.add, size: 18, color: AppTheme.headerBlue)),
            ],
          ),
        ],
      ),
    );
  }
}
