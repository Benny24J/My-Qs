import 'package:flutter/material.dart';
import '../../core/models/project_model.dart';
import '../../core/storage/project_storage.dart';
import '../../core/theme/app_theme.dart';
import 'room_editor_screen.dart';
import 'project_summary_screen.dart';

class CreateProjectScreen extends StatefulWidget {
  final ProjectModel? initialProject;
  const CreateProjectScreen({super.key, this.initialProject});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _clientController;
  late final TextEditingController _locationController;
  late double _wastagePercent;
  late List<RoomModel> _rooms;

  @override
  void initState() {
    super.initState();
    final p = widget.initialProject;
    _nameController = TextEditingController(text: p?.name ?? 'Residential House Project');
    _clientController = TextEditingController(text: p?.clientName ?? '');
    _locationController = TextEditingController(text: p?.location ?? '');
    _wastagePercent = p?.wastagePercent ?? 5.0;
    _rooms = p != null
        ? List<RoomModel>.from(p.rooms)
        : [
            RoomModel(id: 'room-1', name: 'Master Bedroom', length: 4.5, width: 4.0, height: 3.0),
            RoomModel(id: 'room-2', name: 'Living Room', length: 6.0, width: 4.5, height: 3.0, windowsCount: 3),
          ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _clientController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _addOrEditRoom([RoomModel? existing, int? index]) async {
    final result = await Navigator.push<RoomModel>(
      context,
      MaterialPageRoute(builder: (_) => RoomEditorScreen(initialRoom: existing)),
    );
    if (result != null) {
      setState(() => (index != null && index >= 0) ? _rooms[index] = result : _rooms.add(result));
    }
  }

  Future<void> _saveAndNavigateToSummary() async {
    final name = _nameController.text.trim().isEmpty ? 'Untitled Project' : _nameController.text.trim();
    if (_rooms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one room to the project.')));
      return;
    }

    final project = ProjectModel(
      id: widget.initialProject?.id ?? 'proj-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      clientName: _clientController.text.trim(),
      location: _locationController.text.trim(),
      createdAt: widget.initialProject?.createdAt ?? DateTime.now(),
      wastagePercent: _wastagePercent,
      rooms: _rooms,
    );

    await ProjectStorage.saveProject(project);
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProjectSummaryScreen(project: project)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalFloor = _rooms.fold(0.0, (sum, r) => sum + r.floorArea);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        title: Text(widget.initialProject == null ? 'Estimate Whole Building' : 'Edit Project'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveAndNavigateToSummary, tooltip: 'Calculate'),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.borderSubtle)),
              child: Column(
                children: [
                  TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Project Name', hintText: 'e.g. 3-Bedroom Flat')),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: _clientController, decoration: const InputDecoration(labelText: 'Client Name (Optional)'))),
                      const SizedBox(width: 8),
                      Expanded(child: TextField(controller: _locationController, decoration: const InputDecoration(labelText: 'Site Location (Optional)'))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.borderSubtle)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Project Wastage Cushion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                        child: Text('+${_wastagePercent.toInt()}% Extra', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF15803D), fontSize: 12)),
                      ),
                    ],
                  ),
                  Slider(value: _wastagePercent, min: 0, max: 15, divisions: 15, activeColor: AppTheme.headerBlue, onChanged: (v) => setState(() => _wastagePercent = v)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rooms & Areas (${_rooms.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                    Text('Combined Floor: ${totalFloor.toStringAsFixed(1)} m²', style: const TextStyle(fontSize: 11, color: AppTheme.titleBlue, fontWeight: FontWeight.bold)),
                  ],
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('ADD ROOM'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                  onPressed: () => _addOrEditRoom(),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (_rooms.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.borderSubtle)),
                child: const Text('No rooms added yet. Tap "+ ADD ROOM" above.', style: TextStyle(color: AppTheme.textMuted)),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _rooms.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final room = _rooms[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.borderSubtle)),
                    child: Row(
                      children: [
                        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.cardIceBlue, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.meeting_room_outlined, color: AppTheme.titleBlue, size: 20)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(room.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textDark)),
                              Text('${room.length}m × ${room.width}m × ${room.height}m  •  ${room.floorArea.toStringAsFixed(1)} m²', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                            ],
                          ),
                        ),
                        IconButton(icon: const Icon(Icons.edit_outlined, size: 18, color: AppTheme.headerBlue), onPressed: () => _addOrEditRoom(room, index)),
                        IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.dangerRed), onPressed: () => setState(() => _rooms.removeAt(index))),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.analytics_outlined),
                label: const Text('CALCULATE FULL ESTIMATE'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: _saveAndNavigateToSummary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
