import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';

import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:fixxev_admin/core/services/cloudinary_service.dart';
import 'package:image_picker/image_picker.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ApiService _apiService = ApiService();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  late Future<List<dynamic>> _productsFuture;
  bool _isUploading = false;

  // Real Product Data matching user website (for seeding)
  final _defaultProducts = [
    {'name': 'Modular CKD Showroom', 'category': 'Infrastructure', 'price': '₹4,50,000', 'status': 'In Stock', 'stock': '5'},
    {'name': 'Smart Diagnostic Kit', 'category': 'Tools', 'price': '₹28,000', 'status': 'In Stock', 'stock': '150'},
    {'name': 'EV Spare Parts Hub', 'category': 'Components', 'price': 'Various', 'status': 'In Stock', 'stock': '5000+'},
    {'name': 'Portable EV Charger', 'category': 'Accessories', 'price': '₹15,000', 'status': 'Low Stock', 'stock': '12'},
  ];

  @override
  void initState() {
    super.initState();
    _refreshProducts();
  }

  void _refreshProducts() {
    setState(() {
      _productsFuture = _apiService.getProducts();
    });
  }

  Future<void> _seedData() async {
    for (var product in _defaultProducts) {
      await _apiService.createProduct(product);
    }
    _refreshProducts();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Default products seeded!')));
    }
  }

  Future<void> _deleteProduct(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text('Delete Product?', style: AppTextStyles.heading3),
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
        await _apiService.deleteProduct(id);
        _refreshProducts();
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _navigateToEdit([dynamic product]) async {
    final result = await Navigator.pushNamed(
      context, 
      product == null ? '/products/new' : '/products/edit',
      arguments: product,
    );
    if (result == true) {
      _refreshProducts();
    }
  }

  Widget _buildField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
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
          const AdminSidebar(currentRoute: '/products'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Products Inventory', style: AppTextStyles.heading1),
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
                            label: const Text('Add Product'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Products Table
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.sidebarDark)),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 3, child: Text('Product Name', style: AppTextStyles.label)),
                                Expanded(flex: 2, child: Text('Category', style: AppTextStyles.label)),
                                Expanded(flex: 2, child: Text('Price', style: AppTextStyles.label)),
                                Expanded(flex: 2, child: Text('Stock', style: AppTextStyles.label)),
                                Expanded(flex: 2, child: Text('Status', style: AppTextStyles.label)),
                                const SizedBox(width: 96), // Actions
                              ],
                            ),
                          ),
                          // List
                          Expanded(
                            child: FutureBuilder<List<dynamic>>(
                              future: _productsFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: AppColors.error)));
                                }

                                final products = snapshot.data ?? [];

                                if (products.isEmpty) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.shopping_bag_outlined, size: 48, color: AppColors.textGrey),
                                        const SizedBox(height: 16),
                                        Text('No products found.', style: AppTextStyles.bodyMedium),
                                      ],
                                    ),
                                  );
                                }

                                return ListView.separated(
                                  itemCount: products.length,
                                  separatorBuilder: (c, i) => const Divider(height: 1, color: AppColors.sidebarDark),
                                  itemBuilder: (context, index) {
                                    final p = products[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Image.network(
                                                    p['image'] ?? '',
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (_, __, ___) => Container(
                                                      width: 40, height: 40,
                                                      decoration: BoxDecoration(color: AppColors.sidebarDark, borderRadius: BorderRadius.circular(8)),
                                                      child: const Icon(Icons.two_wheeler, color: AppColors.textGrey, size: 20),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(p['name'] ?? '', style: AppTextStyles.bodyLarge),
                                              ],
                                            ),
                                          ),
                                          Expanded(flex: 2, child: Text(p['category'] ?? '', style: AppTextStyles.bodyMedium)),
                                          Expanded(flex: 2, child: Text(p['price'] ?? '', style: AppTextStyles.bodyMedium)),
                                          Expanded(flex: 2, child: Text(p['stock'] ?? '', style: AppTextStyles.bodyMedium)),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(p['status'] ?? '').withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                p['status'] ?? 'Unknown',
                                                style: AppTextStyles.bodySmall.copyWith(color: _getStatusColor(p['status'] ?? '')),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit, color: AppColors.textGrey, size: 20),
                                                 onPressed: () => _navigateToEdit(p),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                                                onPressed: () => _deleteProduct(p['_id']),
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
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Stock': return AppColors.success;
      case 'Low Stock': return AppColors.warning;
      case 'Out of Stock': return AppColors.error;
      default: return AppColors.textMuted;
    }
  }
}
