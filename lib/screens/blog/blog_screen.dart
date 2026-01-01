import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:fixxev/widgets/custom_app_bar.dart';
import 'package:fixxev/widgets/footer_widget.dart';
import 'package:fixxev/widgets/buttons/primary_button.dart';

import 'package:fixxev/core/services/api_service.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _blogsFuture;
  late Future<Map<String, dynamic>> _pageContentFuture;

  @override
  void initState() {
    super.initState();
    _blogsFuture = _apiService.getBlogs();
    _pageContentFuture = _apiService.getPageContent('blog');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        backgroundColor: AppColors.navDark,
        useLightText: true,
      ),
      endDrawer: isMobile ? const MobileDrawer() : null,
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([_blogsFuture, _pageContentFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final blogPosts = snapshot.data![0] as List<dynamic>;
          final content = snapshot.data![1] as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildBlogHero(context, isMobile, content),
                const SizedBox(height: 80),
                _buildBlogGrid(context, isMobile, blogPosts),
                const SizedBox(height: 100),
                const FooterWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBlogHero(BuildContext context, bool isMobile, Map<String, dynamic> content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 80,
      ),
      color: AppColors.backgroundLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            content['title'] ?? 'Insights & News',
            style: AppTextStyles.heroTitle.copyWith(
              fontSize: isMobile ? 40 : 64,
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 80,
            height: 6,
            decoration: BoxDecoration(
              gradient: AppColors.redGradient,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            content['subtitle'] ?? 'Stay updated with the latest in EV infrastructure, company milestones, and the future of Indian mobility.',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildBlogGrid(BuildContext context, bool isMobile, List<dynamic> blogPosts) {
    if (blogPosts.isEmpty) {
      return const Center(child: Text('No blog posts found.'));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80),
      child: isMobile 
        ? Column(
            children: blogPosts.map((post) => _buildBlogCard(_mapToMap(post))).toList(),
          )
        : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 40,
              mainAxisSpacing: 60,
              childAspectRatio: 0.8,
            ),
            itemCount: blogPosts.length,
            itemBuilder: (context, index) {
              return _buildBlogCard(_mapToMap(blogPosts[index]));
            },
          ),
    );
  }

  Map<String, String> _mapToMap(dynamic post) {
    return {
      'title': post['title']?.toString() ?? '',
      'date': post['date']?.toString() ?? '',
      'category': post['category']?.toString() ?? '',
      'image': post['image']?.toString() ?? '',
      'excerpt': post['excerpt']?.toString() ?? '',
    };
  }

  Widget _buildBlogCard(Map<String, String> post) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              post['image']!, 
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.backgroundLight,
                child: const Icon(Icons.article_outlined, size: 48, color: AppColors.textMuted),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                post['category']!.toUpperCase(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.accentRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
              const SizedBox(width: 12),
              Text(
                post['date']!,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            post['title']!,
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 22, height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Text(
                post['excerpt']!,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted, height: 1.5),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'READ MORE',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryNavy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_right, color: AppColors.primaryNavy, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
