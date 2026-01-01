import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';

class AboutListScreen extends StatefulWidget {
  const AboutListScreen({super.key});

  @override
  State<AboutListScreen> createState() => _AboutListScreenState();
}

class _AboutListScreenState extends State<AboutListScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _sections = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSections();
  }

  Future<void> _loadSections() async {
    try {
      final sections = await _apiService.getAboutSections();
      if (mounted) {
        setState(() {
          _sections = sections;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading sections: $e')),
        );
      }
    }
  }

  Future<void> _seedDefaultData() async {
    setState(() => _isLoading = true);
    try {
      await _apiService.seedAboutSections();
      await _loadSections();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Default data seeded successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error seeding data: $e')),
        );
      }
    }
  }

  Future<void> _deleteSection(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text('Delete Section', style: AppTextStyles.heading3),
        content: Text('Are you sure you want to delete this section?', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _apiService.deleteAboutSection(id);
        await _loadSections();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Section deleted successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting section: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          const AdminSidebar(currentRoute: '/about'),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _sections.isEmpty
                          ? _buildEmptyState()
                          : _buildSectionsList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: const BoxDecoration(
        color: AppColors.backgroundDark,
        border: Border(bottom: BorderSide(color: AppColors.sidebarDark)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('About Page Sections', style: AppTextStyles.heading1),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _seedDefaultData,
                icon: const Icon(Icons.auto_fix_high),
                label: const Text('Seed Default Data'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/about/new'),
                icon: const Icon(Icons.add),
                label: const Text('Add Section'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 64, color: AppColors.textGrey),
          const SizedBox(height: 16),
          Text('No about sections yet', style: AppTextStyles.heading3),
          const SizedBox(height: 8),
          Text('Click "Seed Default Data" to add default sections', style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildSectionsList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.sidebarDark),
        ),
        child: Column(
          children: [
            // Header Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.sidebarDark)),
              ),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text('Section Title', style: AppTextStyles.label.copyWith(color: AppColors.textGrey))),
                  Expanded(flex: 2, child: Text('Type', style: AppTextStyles.label.copyWith(color: AppColors.textGrey))),
                  Expanded(flex: 2, child: Text('Status', style: AppTextStyles.label.copyWith(color: AppColors.textGrey))),
                  const SizedBox(width: 100),
                ],
              ),
            ),
            // Data Rows
            ..._sections.map((section) => _buildSectionRow(section)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionRow(Map<String, dynamic> section) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.sidebarDark)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.accentTeal.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_getIconForType(section['type']), color: AppColors.accentTeal, size: 20),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(section['title'] ?? 'Untitled', style: AppTextStyles.bodyLarge),
                    Text(section['label'] ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.sidebarDark,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(section['type'] ?? 'Section', style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: section['isActive'] == true ? AppColors.accentTeal.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                section['isActive'] == true ? 'Active' : 'Inactive',
                style: AppTextStyles.bodySmall.copyWith(color: section['isActive'] == true ? AppColors.accentTeal : Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.textMuted),
                  onPressed: () => Navigator.pushNamed(context, '/about/edit', arguments: section),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteSection(section['_id']),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(String? type) {
    switch (type) {
      case 'Values': return Icons.favorite;
      case 'Vision': return Icons.visibility;
      case 'CSR': return Icons.eco;
      case 'Future': return Icons.rocket_launch;
      default: return Icons.info_outline;
    }
  }
}
