import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';

import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:fixxev_admin/core/services/cloudinary_service.dart';
import 'package:image_picker/image_picker.dart';

class TeamListScreen extends StatefulWidget {
  const TeamListScreen({super.key});

  @override
  State<TeamListScreen> createState() => _TeamListScreenState();
}

class _TeamListScreenState extends State<TeamListScreen> {
  final ApiService _apiService = ApiService();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  late Future<List<dynamic>> _membersFuture;
  bool _isUploading = false;

  final _defaultMembers = [
    {'name': 'Rajesh Kumar', 'role': 'Founder & CEO', 'image': 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=400'},
    {'name': 'Alex Rivera', 'role': 'EV Systems Engineer', 'image': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400'},
    {'name': 'Sarah Chen', 'role': 'Battery Specialist', 'image': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400'},
    {'name': 'Mark Thompson', 'role': 'Diagnostics Expert', 'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400'},
    {'name': 'Priya Singh', 'role': 'Operations Head', 'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400'},
    {'name': 'Vikram Malhotra', 'role': 'Service Manager', 'image': 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400'},
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

  Widget _buildField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.label,
        filled: true,
        fillColor: AppColors.sidebarDark,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                            label: const Text('Seed Default Data'),
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
                  
                  // Team Grid
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                      future: _membersFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: AppColors.error)));
                        }

                        final members = snapshot.data ?? [];

                        if (members.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.group_outlined, size: 48, color: AppColors.textGrey),
                                const SizedBox(height: 16),
                                Text('No team members found.', style: AppTextStyles.bodyMedium),
                              ],
                            ),
                          );
                        }

                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: members.length,
                          itemBuilder: (context, index) {
                            final member = members[index];
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
                                      width: 96,
                                      height: 96,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 96,
                                        height: 96,
                                        color: AppColors.sidebarDark,
                                        child: const Icon(Icons.person, size: 48, color: AppColors.textGrey),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(member['name'] ?? '', style: AppTextStyles.heading3),
                                  const SizedBox(height: 4),
                                  Text(member['role'] ?? '', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accentBlue)),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20, color: AppColors.textGrey),
                                        onPressed: () => _navigateToEdit(member),
                                        tooltip: 'Edit',
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                                        onPressed: () => _deleteMember(member['_id']),
                                        tooltip: 'Delete',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
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
}
