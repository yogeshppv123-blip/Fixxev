import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:fixxev/widgets/custom_app_bar.dart';
import 'package:fixxev/widgets/footer_widget.dart';
import 'package:fixxev/widgets/buttons/primary_button.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBlogHero(context, isMobile),
            const SizedBox(height: 80),
            _buildBlogGrid(context, isMobile),
            const SizedBox(height: 100),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogHero(BuildContext context, bool isMobile) {
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
            'Insights & News',
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
            'Stay updated with the latest in EV infrastructure, company milestones, and the future of Indian mobility.',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildBlogGrid(BuildContext context, bool isMobile) {
    final blogPosts = [
      {
        'title': 'The Future of EV After-Sales in India',
        'date': 'Oct 24, 2024',
        'category': 'INDUSTRY',
        'image': 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'excerpt': 'Why a standardized service network is the key to unlocking mass EV adoption in the Indian market.',
      },
      {
        'title': 'Fixx EV Launches 50th Service Center',
        'date': 'Nov 12, 2024',
        'category': 'NEWS',
        'image': 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'excerpt': 'Milestone achievement as we expand our footprint across North India cities.',
      },
      {
        'title': 'How Modular Showrooms are Changing Retail',
        'date': 'Dec 05, 2024',
        'category': 'TECHNOLOGY',
        'image': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'excerpt': 'Exploring the advantages of rapid deployment CKD containers for new franchisees.',
      },
      {
        'title': 'Battery Diagnostics: The Core of EV Health',
        'date': 'Dec 20, 2024',
        'category': 'TECH TIPS',
        'image': 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'excerpt': 'Understanding the importance of real-time battery monitoring for long-term vehicle performance.',
      },
      {
        'title': 'Why Choose a Certified EV Service Partner?',
        'date': 'Jan 10, 2025',
        'category': 'GUIDE',
        'image': 'https://images.unsplash.com/photo-1581092160562-40aa08e78837?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'excerpt': 'Comparing OEM-grade service versus local workshops for electric two-wheelers.',
      },
      {
        'title': 'Sustainability in EV Logistics',
        'date': 'Jan 28, 2025',
        'category': 'IMPACT',
        'image': 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'excerpt': 'Reducing the carbon footprint of the spare parts supply chain using smart storage solutions.',
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80),
      child: isMobile 
        ? Column(
            children: blogPosts.map((post) => _buildBlogCard(post)).toList(),
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
              return _buildBlogCard(blogPosts[index]);
            },
          ),
    );
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
            child: Image.network(post['image']!, fit: BoxFit.cover),
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
