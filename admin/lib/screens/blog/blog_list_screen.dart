import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:fixxev_admin/core/services/cloudinary_service.dart';
import 'package:image_picker/image_picker.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  final ApiService _apiService = ApiService();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  late Future<List<dynamic>> _blogsFuture;
  bool _isUploading = false;

  // Default blogs for seeding
  final _defaultBlogs = [
    {
      'title': 'The Future of EV After-Sales in India',
      'date': 'Oct 24, 2024',
      'category': 'INDUSTRY',
      'image': 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800',
      'excerpt': 'Why a standardized service network is the key to unlocking mass EV adoption in the Indian market.',
    },
    {
      'title': 'Fixx EV Launches 50th Service Center',
      'date': 'Nov 12, 2024',
      'category': 'NEWS',
      'image': 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=800',
      'excerpt': 'Milestone achievement as we expand our footprint across North India cities.',
    },
    {
      'title': 'How Modular Showrooms are Changing Retail',
      'date': 'Dec 05, 2024',
      'category': 'TECHNOLOGY',
      'image': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800',
      'excerpt': 'Exploring the advantages of rapid deployment CKD containers for new franchisees.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshBlogs();
  }

  void _refreshBlogs() {
    setState(() {
      _blogsFuture = _apiService.getBlogs();
    });
  }

  Future<void> _seedData() async {
    for (var blog in _defaultBlogs) {
      await _apiService.createBlog(blog);
    }
    _refreshBlogs();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Default blog posts seeded!')));
    }
  }

  Future<void> _navigateToEdit([dynamic blog]) async {
    final result = await Navigator.pushNamed(
      context, 
      blog == null ? '/blog/new' : '/blog/edit',
      arguments: blog,
    );
    if (result == true) {
      _refreshBlogs();
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}";
  }

  Widget _buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
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
          const AdminSidebar(currentRoute: '/blog'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Blog Posts', style: AppTextStyles.heading1),
                        ],
                      ),
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
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text('New Post'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentRed,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Posts list
                  FutureBuilder<List<dynamic>>(
                    future: _blogsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: AppColors.error)));
                      }

                      final blogs = snapshot.data ?? [];

                      if (blogs.isEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 48),
                              const Icon(Icons.article_outlined, size: 48, color: AppColors.textGrey),
                              const SizedBox(height: 16),
                              Text('No blog posts found.', style: AppTextStyles.bodyMedium),
                            ],
                          ),
                        );
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardDark,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: blogs.map((post) => _buildPostRow(post)).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostRow(dynamic post) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.sidebarDark)),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              post['image'] ?? '',
              width: 80,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 60,
                color: AppColors.sidebarDark,
                child: const Icon(Icons.image, color: AppColors.textMuted),
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post['title'] ?? '', style: AppTextStyles.heading3),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        post['category'] ?? '',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.info),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      post['date'] ?? '',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'PUBLISHED',
              style: TextStyle(
                color: AppColors.success,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Actions
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                color: AppColors.textMuted,
                onPressed: () => _navigateToEdit(post),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                color: AppColors.error,
                onPressed: () => _deletePost(post['_id']),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _deletePost(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text('Delete Post?', style: AppTextStyles.heading3),
        content: Text('This action cannot be undone.', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _apiService.deleteBlog(id);
                _refreshBlogs();
                if (mounted) Navigator.pop(context);
              } catch (e) {
                if (mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
