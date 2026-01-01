import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';

class CKDListScreen extends StatefulWidget {
  const CKDListScreen({super.key});

  @override
  State<CKDListScreen> createState() => _CKDListScreenState();
}

class _CKDListScreenState extends State<CKDListScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _features = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeatures();
  }

  Future<void> _loadFeatures() async {
    try {
      final features = await _apiService.getCKDFeatures();
      if (mounted) {
        setState(() {
          _features = features;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading features: $e')),
        );
      }
    }
  }

  Future<void> _seedDefaultData() async {
    setState(() => _isLoading = true);
    try {
      await _apiService.seedCKDFeatures();
      await _loadFeatures();
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

  Future<void> _deleteFeature(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text('Delete Feature', style: AppTextStyles.heading3),
        content: Text('Are you sure you want to delete this feature?', style: AppTextStyles.bodyMedium),
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
        await _apiService.deleteCKDFeature(id);
        await _loadFeatures();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Feature deleted successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting feature: $e')),
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
          const AdminSidebar(currentRoute: '/ckd-content'),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _features.isEmpty
                          ? _buildEmptyState()
                          : _buildFeaturesList(),
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
          Text('CKD Container Features', style: AppTextStyles.heading1),
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
                onPressed: () => Navigator.pushNamed(context, '/ckd-content/new'),
                icon: const Icon(Icons.add),
                label: const Text('Add Feature'),
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
          Icon(Icons.store_outlined, size: 64, color: AppColors.textGrey),
          const SizedBox(height: 16),
          Text('No CKD features yet', style: AppTextStyles.heading3),
          const SizedBox(height: 8),
          Text('Click "Seed Default Data" to add default features', style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
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
                  Expanded(flex: 3, child: Text('Feature Name', style: AppTextStyles.label.copyWith(color: AppColors.textGrey))),
                  Expanded(flex: 2, child: Text('Category', style: AppTextStyles.label.copyWith(color: AppColors.textGrey))),
                  Expanded(flex: 2, child: Text('Status', style: AppTextStyles.label.copyWith(color: AppColors.textGrey))),
                  const SizedBox(width: 100),
                ],
              ),
            ),
            // Data Rows
            ..._features.map((feature) => _buildFeatureRow(feature)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(Map<String, dynamic> feature) {
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
                  child: Icon(Icons.store, color: AppColors.accentTeal, size: 20),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(feature['title'] ?? 'Untitled', style: AppTextStyles.bodyLarge),
                    Text(feature['subtitle'] ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey)),
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
              child: Text(feature['category'] ?? 'General', style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: feature['isActive'] == true ? AppColors.accentTeal.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                feature['isActive'] == true ? 'Active' : 'Inactive',
                style: AppTextStyles.bodySmall.copyWith(color: feature['isActive'] == true ? AppColors.accentTeal : Colors.grey),
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
                  onPressed: () => Navigator.pushNamed(context, '/ckd-content/edit', arguments: feature),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteFeature(feature['_id']),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
