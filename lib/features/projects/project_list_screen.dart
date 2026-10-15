import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/models/project_model.dart';
import '../../core/storage/project_storage.dart';
import '../../core/theme/app_theme.dart';
import 'create_project_screen.dart';
import 'project_summary_screen.dart';

class ProjectListScreen extends StatefulWidget {
  final bool isEmbeddedTab;
  const ProjectListScreen({super.key, this.isEmbeddedTab = false});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  List<ProjectModel> _projects = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() => _isLoading = true);
    final list = await ProjectStorage.getAllProjects();
    if (mounted) setState(() { _projects = list; _isLoading = false; });
  }

  Future<void> _deleteProject(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Project?'),
        content: const Text('This will remove this project estimate from your device.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.dangerRed, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ProjectStorage.deleteProject(id);
      _loadProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _searchQuery.toLowerCase();
    final filtered = _projects.where((p) =>
      p.name.toLowerCase().contains(q) ||
      p.clientName.toLowerCase().contains(q) ||
      p.location.toLowerCase().contains(q)
    ).toList();

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: widget.isEmbeddedTab ? null : AppBar(
        title: const Text('Saved Projects & Estimates'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadProjects)],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.headerBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('NEW PROJECT', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateProjectScreen()));
          _loadProjects();
        },
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.headerBlue))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search projects by name, client, or site...',
                      prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _searchQuery = ''))
                          : null,
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val),
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.folder_open_outlined, size: 52, color: AppTheme.textMuted),
                              const SizedBox(height: 10),
                              Text(
                                _searchQuery.isEmpty ? 'No saved projects yet' : 'No projects found',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                              ),
                              const SizedBox(height: 4),
                              const Text('Create a new project to start estimating.', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
                          itemCount: filtered.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (_, i) => _buildProjectCard(filtered[i]),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildProjectCard(ProjectModel project) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderSubtle),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.cardIceBlue,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.cardIceBlueBorder),
                ),
                child: const Icon(Icons.apartment_outlined, color: AppTheme.titleBlue, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                    const SizedBox(height: 2),
                    if (project.clientName.isNotEmpty)
                      Text('Client: ${project.clientName}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                    if (project.location.isNotEmpty)
                      Text('📍 ${project.location}', style: const TextStyle(fontSize: 11, color: AppTheme.titleBlue)),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppTheme.textMuted),
                color: Colors.white,
                onSelected: (val) async {
                  if (val == 'edit') {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => CreateProjectScreen(initialProject: project)));
                    _loadProjects();
                  } else if (val == 'delete') {
                    _deleteProject(project.id);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, size: 18, color: AppTheme.headerBlue), SizedBox(width: 8), Text('Edit Project')])),
                  PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 18, color: AppTheme.dangerRed), SizedBox(width: 8), Text('Delete', style: TextStyle(color: AppTheme.dangerRed))])),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: AppTheme.borderSubtle, height: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${project.rooms.length} Areas  •  ${project.totalFloorArea.toStringAsFixed(1)} m² floor', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
              Text(DateFormat('MMM dd, yyyy').format(project.createdAt), style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.visibility_outlined, size: 16, color: AppTheme.titleBlue),
              label: const Text('VIEW MATERIAL SCHEDULE & PDF', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.titleBlue)),
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => ProjectSummaryScreen(project: project)));
                _loadProjects();
              },
            ),
          ),
        ],
      ),
    );
  }
}
