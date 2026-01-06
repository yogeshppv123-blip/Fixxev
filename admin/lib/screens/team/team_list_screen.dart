import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';

class TeamListScreen extends StatefulWidget {
  const TeamListScreen({super.key});

  @override
  State<TeamListScreen> createState() => _TeamListScreenState();
}

class _TeamListScreenState extends State<TeamListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _membersFuture;

  final _defaultMembers = [
    {'name': 'Rajesh Kumar', 'role': 'Founder & CEO', 'category': 'Our Core Team', 'image': 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=400'},
    {'name': 'Priya Singh', 'role': 'Operations Head', 'category': 'Our Core Team', 'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400'},
    {'name': 'Alex Rivera', 'role': 'EV Systems Engineer', 'category': 'Technical Team', 'image': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400'},
    {'name': 'Sarah Chen', 'role': 'Battery Specialist', 'category': 'Technical Team', 'image': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400'},
    {'name': 'Mark Thompson', 'role': 'Diagnostics Expert', 'category': 'Technical Team', 'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400'},
    {'name': 'Vikram Malhotra', 'role': 'Service Manager', 'category': 'Technical Team', 'image': 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400'},
  ];

  @override
  void initState() {
    super.initState();
    _refreshTeam();
  }

  void _refreshTeam() {
    setState(() {
      _membersFuture = _apiService.getTeam();
    });
  }

  Future<void> _seedData() async {
    for (var member in _defaultMembers) {
      await _apiService.createTeamMember(member);
    }
    _refreshTeam();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Default team members seeded!')));
    }
  }

  Future<void> _deleteMember(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text('Delete Member?', style: AppTextStyles.heading3),
        content: Text('This action cannot be undone.', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _apiService.deleteTeamMember(id);
        _refreshTeam();
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _navigateToEdit([dynamic member]) async {
    final result = await Navigator.pushNamed(
      context, 
      member == null ? '/team/new' : '/team/edit',
      arguments: member,
    );
    if (result == true) {
      _refreshTeam();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1100;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          const AdminSidebar(currentRoute: '/team'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Team Members', style: AppTextStyles.heading1),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _seedData,
                            icon: const Icon(Icons.cloud_upload),
                            label: const Text('Seed Defaults'),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.sidebarDark),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () => _navigateToEdit(),
                            icon: const Icon(Icons.person_add),
                            label: const Text('Add Member'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                      future: _membersFuture,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                        
                        final members = snapshot.data!;
                        final coreTeam = members.where((m) => (m['category'] ?? 'Our Core Team') == 'Our Core Team').toList();
                        final techTeam = members.where((m) => m['category'] == 'Technical Team').toList();

                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildCategoryGrid('Our Core Team', coreTeam),
                              const SizedBox(height: 40),
                              _buildCategoryGrid('Technical Team', techTeam),
                              const SizedBox(height: 100),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(String title, List<dynamic> team) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 24, decoration: BoxDecoration(color: AppColors.accentRed, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 12),
            Text(title, style: AppTextStyles.heading2),
            const SizedBox(width: 12),
            Text('(${team.length})', style: const TextStyle(color: Colors.white38)),
          ],
        ),
        const SizedBox(height: 24),
        if (team.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.sidebarDark)),
            child: const Center(child: Text('No members in this category.', style: TextStyle(color: Colors.white38, fontStyle: FontStyle.italic))),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 0.85,
            ),
            itemCount: team.length,
            itemBuilder: (context, index) {
              final member = team[index];
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.sidebarDark),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Image.network(
                        member['image'] ?? '',
                        width: 80, height: 80, fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Icon(Icons.person, size: 40),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(member['name'] ?? '', style: AppTextStyles.heading3.copyWith(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(member['role'] ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentBlue)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, size: 18), onPressed: () => _navigateToEdit(member)),
                        IconButton(icon: const Icon(Icons.delete, size: 18, color: Colors.redAccent), onPressed: () => _deleteMember(member['_id'])),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
