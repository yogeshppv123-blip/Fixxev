import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:fixxev/widgets/custom_app_bar.dart';
import 'package:fixxev/widgets/footer_widget.dart';
import 'package:fixxev/widgets/buttons/primary_button.dart';
import 'package:go_router/go_router.dart';

import 'package:fixxev/core/services/api_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _productsFuture;
  late Future<Map<String, dynamic>> _pageContentFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _apiService.getProducts();
    _pageContentFuture = _apiService.getPageContent('products');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: const CustomAppBar(
        backgroundColor: AppColors.navDark,
        useLightText: true,
      ),
      endDrawer: isMobile ? const MobileDrawer() : null,
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([_productsFuture, _pageContentFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final products = snapshot.data![0] as List<dynamic>;
          final content = snapshot.data![1] as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildProductsHero(context, isMobile, content),
                const SizedBox(height: 80),
                _buildProductList(context, isMobile, products),
                const SizedBox(height: 100),
                const FooterWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsHero(BuildContext context, bool isMobile, Map<String, dynamic> content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 100,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primaryNavy,
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=2560&q=80'),
          fit: BoxFit.cover,
          opacity: 0.2,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            content['title'] ?? 'Cutting-Edge EV Solutions',
            style: AppTextStyles.heroTitle.copyWith(
              fontSize: isMobile ? 36 : 56,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 800,
            child: Text(
              content['subtitle'] ?? 'From smart diagnostic tools to modular showroom containers, we provide the infrastructure needed for the next generation of electric mobility.',
              style: AppTextStyles.heroSubtitle.copyWith(
                fontSize: 18,
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(BuildContext context, bool isMobile, List<dynamic> products) {
    if (products.isEmpty) {
      return const Center(child: Text('No products available at the moment.'));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80),
      child: Column(
        children: products.map((product) {
          final index = products.indexOf(product);
          final isEven = index % 2 == 0;

          // Map backend fields to UI expected fields
          final uiProduct = {
            'title': product['name'] ?? '',
            'subtitle': (product['subtitle'] != null && product['subtitle'].toString().isNotEmpty) 
                ? product['subtitle'] 
                : '${product['category'] ?? ''} - ${product['price'] ?? ''}',
            'image': (product['image'] != null && product['image'].toString().isNotEmpty) 
                ? product['image'] 
                : _getProductImage(index),
            'features': [
              'Status: ${product['status'] ?? ''}',
              'Stock: ${product['stock'] ?? ''}',
              'Direct OEM Quality',
              'Nationwide Support'
            ],
          };

          if (isMobile) {
            return _buildProductCardMobile(uiProduct);
          }

          return _buildProductCardDesktop(uiProduct, isEven);
        }).toList(),
      ),
    );
  }

  String _getProductImage(int index) {
    final images = [
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
      'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d',
      'https://images.unsplash.com/photo-1581092160562-40aa08e78837',
    ];
    return images[index % images.length];
  }

  Widget _buildProductCardDesktop(Map<String, dynamic> product, bool isEven) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: Row(
        children: isEven
            ? [
                Expanded(flex: 1, child: _buildProductImage(product['image'])),
                const SizedBox(width: 80),
                Expanded(flex: 1, child: _buildProductInfo(product)),
              ]
            : [
                Expanded(flex: 1, child: _buildProductInfo(product)),
                const SizedBox(width: 80),
                Expanded(flex: 1, child: _buildProductImage(product['image'])),
              ],
      ),
    );
  }

  Widget _buildProductCardMobile(Map<String, dynamic> product) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductImage(product['image']),
          const SizedBox(height: 32),
          _buildProductInfo(product),
        ],
      ),
    );
  }

  Widget _buildProductImage(String imageUrl) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        imageUrl, 
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.backgroundLight,
          child: const Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.textMuted),
        ),
      ),
    );
  }

  Widget _buildProductInfo(Map<String, dynamic> product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.accentRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'FEATURED PRODUCT',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.accentRed,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          product['title'],
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 40),
        ),
        const SizedBox(height: 12),
        Text(
          product['subtitle'],
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 32),
        ... (product['features'] as List<String>).map((feature) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.accentRed, size: 24),
                const SizedBox(width: 16),
                Text(
                  feature,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 40),
        PrimaryButton(
          text: 'INQUIRE NOW',
          onPressed: () => context.go('/contact'),
          icon: Icons.arrow_forward,
        ),
      ],
    );
  }
}
