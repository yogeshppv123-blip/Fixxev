import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';

class FranchiseListScreen extends StatefulWidget {
  const FranchiseListScreen({super.key});

  @override
  State<FranchiseListScreen> createState() => _FranchiseListScreenState();
}

class _FranchiseListScreenState extends State<FranchiseListScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _franchiseTypes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFranchiseTypes();
  }

  Future<void> _loadFranchiseTypes() async {
    try {
      final types = await _apiService.getFranchiseTypes();
      if (mounted) {
        setState(() {
          _franchiseTypes = types;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading franchise types: $e')),
        );
      }
    }
  }

  Future<void> _seedDefaultData() async {
    setState(() => _isLoading = true);
    try {
      await _apiService.seedFranchiseTypes();
      await _loadFranchiseTypes();
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

  Future<void> _deleteFranchiseType(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text('Delete Franchise Type', style: AppTextStyles.heading3),
        content: Text('Are you sure you want to delete this franchise type?', style: AppTextStyles.bodyMedium),
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
        await _apiService.deleteFranchiseType(id);
        await _loadFranchiseTypes();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Franchise type deleted successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting franchise type: $e')),
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
          const AdminSidebar(currentRoute: '/franchise'),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _franchiseTypes.isEmpty
                          ? _buildEmptyState()
                          : _buildFranchiseList(),
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
          Text('Franchise Management', style: AppTextStyles.heading1),
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
                onPressed: () => Navigator.pushNamed(context, '/franchise/new'),
                icon: const Icon(Icons.add),
                label: const Text('Add Franchise Type'),
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
          Icon(Icons.handshake_outlined, size: 64, color: AppColors.textGrey),
          const SizedBox(height: 16),
          Text('No franchise types yet', style: AppTextStyles.heading3),
          const SizedBox(height: 8),
          Text('Click "Seed Default Data" to add default types', style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildFranchiseList() {
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
                  Expanded(flex: 3, child: Text('Franchise Type', style: AppTextStyles.label.copyWith(color: AppColors.textGrey))),
                  Expanded(flex: 2, child: Text('Benefits Count', style: AppTextStyles.label.copyWith(color: AppColors.textGrey))),
                  Expanded(flex: 2, child: Text('Status', style: AppTextStyles.label.copyWith(color: AppColors.textGrey))),
                  const SizedBox(width: 100),
                ],
              ),
            ),
            // Data Rows
            ..._franchiseTypes.map((type) => _buildFranchiseRow(type)),
          ],
        ),
      ),
    );
  }

  Widget _buildFranchiseRow(Map<String, dynamic> type) {
    final benefits = type['benefits'] as List? ?? [];
    
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
                    color: AppColors.accentBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    type['type'] == 'Spare Parts' ? Icons.inventory_2 : Icons.build_circle,
                    color: AppColors.accentBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(type['title'] ?? 'Untitled', style: AppTextStyles.bodyLarge),
                    Text(type['type'] ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text('${benefits.length} benefits', style: AppTextStyles.bodyMedium),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: type['isActive'] == true ? AppColors.accentTeal.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                type['isActive'] == true ? 'Active' : 'Inactive',
                style: AppTextStyles.bodySmall.copyWith(color: type['isActive'] == true ? AppColors.accentTeal : Colors.grey),
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
                  onPressed: () => Navigator.pushNamed(context, '/franchise/edit', arguments: type),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteFranchiseType(type['_id']),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
