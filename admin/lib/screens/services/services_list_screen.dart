import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';

import 'package:fixxev_admin/core/services/api_service.dart';

class ServicesListScreen extends StatefulWidget {
  const ServicesListScreen({super.key});

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _servicesFuture;

  // Real Services Data matching website (for seeding)
  final _defaultServices = [
      {'title': 'Precision After-Sales Service & Preventive Maintenance', 'category': 'After-Sales', 'status': 'Active', 'description': 'Periodic maintenance checks, repair protocols, and specialized motor hub services.'},
      {'title': 'OEM Warranty Management & Dealer Assistance', 'category': 'Warranty', 'status': 'Active', 'description': 'Warranty audits, documentation assistance, and seamless claim processing.'},
      {'title': 'Intelligent Fleet Management & Corporate EV Solutions', 'category': 'Fleet', 'status': 'Active', 'description': 'Real-time health monitoring and priority service lanes for fleets.'},
      {'title': 'EV Refurbishment & Performance Upgrades', 'category': 'Refurbishment', 'status': 'Active', 'description': 'Battery upgrades, motor re-tuning, and aesthetic restoration.'},
      {'title': 'High-Tech EV Diagnostics & Software Solutions', 'category': 'Diagnostics', 'status': 'Active', 'description': 'CAN Bus analysis and BMS firmware updates.'},
      {'title': 'Advanced Battery Repairs, Replacement & Recycling', 'category': 'Energy Care', 'status': 'Active', 'description': 'Cell balancing and thermal management system repairs.'},
  ];

  @override
  void initState() {
    super.initState();
    _refreshServices();
  }

  void _refreshServices() {
    setState(() {
      _servicesFuture = _apiService.getServices();
    });
  }

  Future<void> _seedData() async {
    for (var service in _defaultServices) {
      await _apiService.createService(service);
    }
    _refreshServices();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Default services seeded successfully!')));
    }
  }

  Future<void> _deleteService(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text('Delete Service?', style: AppTextStyles.heading3),
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
        await _apiService.deleteService(id);
        _refreshServices();
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _navigateToEdit([dynamic service]) async {
    final result = await Navigator.pushNamed(
      context, 
      service == null ? '/services/new' : '/services/edit',
      arguments: service,
    );
    if (result == true) {
      _refreshServices();
    }
  }

  Widget _buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppTextStyles.bodyLarge,
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTextStyles.label,
      filled: true,
      fillColor: AppColors.sidebarDark,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          const AdminSidebar(currentRoute: '/services'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Services Management', style: AppTextStyles.heading1),
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
                            icon: const Icon(Icons.add),
                            label: const Text('Add Service'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Services List
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: FutureBuilder<List<dynamic>>(
                        future: _servicesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: AppColors.error)));
                          }
                          
                          final services = snapshot.data ?? [];
                          
                          if (services.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.info_outline, size: 48, color: AppColors.textGrey),
                                  const SizedBox(height: 16),
                                  Text('No services found. Click "Seed Default Data" to start.', style: AppTextStyles.bodyMedium),
                                ],
                              ),
                            );
                          }

                          return ListView.separated(
                            itemCount: services.length,
                            separatorBuilder: (c, i) => const Divider(height: 1, color: AppColors.sidebarDark),
                            itemBuilder: (context, index) {
                              final service = services[index];
                              return Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48, height: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.sidebarDark,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.build_circle_outlined, color: AppColors.accentBlue, size: 24),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(service['title'] ?? '', style: AppTextStyles.heading3.copyWith(fontSize: 16)),
                                          const SizedBox(height: 4),
                                          Text(service['description'] ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.sidebarDark,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(service['category'] ?? '', style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(service['status'] ?? '').withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: _getStatusColor(service['status'] ?? '').withOpacity(0.5)),
                                          ),
                                          child: Text(
                                            service['status'] ?? 'Draft',
                                            style: AppTextStyles.bodySmall.copyWith(
                                              color: _getStatusColor(service['status'] ?? ''),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(onPressed: () => _navigateToEdit(service), icon: const Icon(Icons.edit, color: AppColors.textGrey)),
                                        IconButton(onPressed: () => _deleteService(service['_id']), icon: const Icon(Icons.delete_outline, color: AppColors.error)),
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active': return AppColors.success;
      case 'Inactive': return AppColors.error;
      case 'Draft': return AppColors.warning;
      default: return AppColors.textMuted;
    }
  }
}
