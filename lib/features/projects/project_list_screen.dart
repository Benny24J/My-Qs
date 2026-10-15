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
        backgroundColor: AppTheme.cardBg(ctx),
        title: Text('Delete Project?', style: TextStyle(color: AppTheme.textPrimary(ctx), fontWeight: FontWeight.bold)),
        content: Text('This will remove this project estimate from your device.', style: TextStyle(color: AppTheme.textSecondary(ctx))),
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

    final textPri = AppTheme.textPrimary(context);
    final textSec = AppTheme.textSecondary(context);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor(context),
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
                      prefixIcon: Icon(Icons.search, color: textSec),
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
                              Icon(Icons.folder_open_outlined, size: 52, color: textSec),
                              const SizedBox(height: 10),
                              Text(
                                _searchQuery.isEmpty ? 'No saved projects yet' : 'No projects found',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textPri),
                              ),
                              const SizedBox(height: 4),
                              Text('Create a new project to start estimating.', style: TextStyle(fontSize: 12, color: textSec)),
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
    final cardBg = AppTheme.cardBg(context);
    final borderSubtle = AppTheme.borderSubtleColor(context);
    final textPri = AppTheme.textPrimary(context);
    final textSec = AppTheme.textSecondary(context);
    final accent = AppTheme.accentBlue(context);
    final iceBg = AppTheme.iceCardBg(context);
    final iceBorder = AppTheme.iceCardBorder(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderSubtle),
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
                  color: iceBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: iceBorder),
                ),
                child: Icon(Icons.apartment_outlined, color: accent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textPri), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    if (project.clientName.isNotEmpty)
                      Text('Client: ${project.clientName}', style: TextStyle(fontSize: 12, color: textSec), maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (project.location.isNotEmpty)
                      Text('📍 ${project.location}', style: TextStyle(fontSize: 11, color: accent), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: textSec),
                color: cardBg,
                onSelected: (val) async {
                  if (val == 'edit') {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => CreateProjectScreen(initialProject: project)));
                    _loadProjects();
                  } else if (val == 'delete') {
                    _deleteProject(project.id);
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(children: [const Icon(Icons.edit_outlined, size: 18, color: AppTheme.headerBlue), const SizedBox(width: 8), Text('Edit Project', style: TextStyle(color: textPri))]),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(children: [Icon(Icons.delete_outline, size: 18, color: AppTheme.dangerRed), SizedBox(width: 8), Text('Delete', style: TextStyle(color: AppTheme.dangerRed))]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: borderSubtle, height: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${project.rooms.length} Areas  •  ${project.totalFloorArea.toStringAsFixed(1)} m² floor',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPri),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(DateFormat('MMM dd, yyyy').format(project.createdAt), style: TextStyle(fontSize: 11, color: textSec)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: Icon(Icons.visibility_outlined, size: 16, color: accent),
              label: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('VIEW MATERIAL SCHEDULE & PDF', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: accent)),
              ),
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
