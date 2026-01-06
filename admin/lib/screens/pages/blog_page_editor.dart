import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';

class BlogPageEditor extends StatefulWidget {
  const BlogPageEditor({super.key});

  @override
  State<BlogPageEditor> createState() => _BlogPageEditorState();
}

class _BlogPageEditorState extends State<BlogPageEditor> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isSaving = false;

  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  late Future<List<dynamic>> _blogsFuture;

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
    _loadContent();
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

  Future<void> _loadContent() async {
    try {
      final data = await _apiService.getPageContent('blog');
      final content = data['content'] ?? {};
      
      setState(() {
        _titleController.text = content['title'] ?? 'Insights & News';
        _subtitleController.text = content['subtitle'] ?? 'Stay updated with the latest in EV infrastructure, company milestones, and the future of Indian mobility.';
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading content: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveContent() async {
    setState(() => _isSaving = true);
    try {
      final content = {
        'title': _titleController.text,
        'subtitle': _subtitleController.text,
      };
      
      await _apiService.updatePageContent('blog', content);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Blog page header updated!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving content: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1100;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      drawer: isMobile ? const Drawer(child: AdminSidebar(currentRoute: '/pages')) : null,
      appBar: isMobile ? AppBar(
        backgroundColor: AppColors.sidebarDark,
        elevation: 0,
        leading: Builder(builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        )),
        title: Text('Edit Blog Page', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            onPressed: _isSaving ? null : _saveContent,
            icon: _isSaving 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.save),
          ),
        ],
      ) : null,
      body: Row(
        children: [
          if (!isMobile) const AdminSidebar(currentRoute: '/pages'),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    if (!isMobile) _buildHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(isMobile ? 16 : 32),
                        child: Column(
                          children: [
                            _buildSectionCard(
                              title: 'Blog Listing Header',
                              icon: Icons.article_outlined,
                              children: [
                                _buildTextField('Main Heading', _titleController),
                                const SizedBox(height: 16),
                                _buildTextField('Subheading / Description', _subtitleController, maxLines: 3),
                              ],
                            ),
                            const SizedBox(height: 32),
                            _buildPostManagementSection(isMobile),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostManagementSection(bool isMobile) {
    return _buildSectionCard(
      title: 'Individual Blog Posts',
      icon: Icons.article_outlined,
      children: [
        isMobile ? Column(
          children: [
            Text('Manage all posts displayed on the blog page.', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: _seedData,
                  icon: const Icon(Icons.cloud_upload, size: 18),
                  label: const Text('Seed Defaults'),
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12)),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _navigateToEdit(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New Post'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
          ],
        ) : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Manage all posts displayed on the blog page.', style: AppTextStyles.bodyMedium),
            Row(
              children: [
                TextButton.icon(
                  onPressed: _seedData,
                  icon: const Icon(Icons.cloud_upload, size: 18),
                  label: const Text('Seed Defaults'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _navigateToEdit(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New Post'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        FutureBuilder<List<dynamic>>(
          future: _blogsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ));
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: AppColors.error)));
            }

            final blogs = snapshot.data ?? [];

            if (blogs.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Column(
                    children: [
                      const Icon(Icons.article_outlined, size: 48, color: AppColors.textGrey),
                      const SizedBox(height: 16),
                      Text('No blog posts found.', style: AppTextStyles.bodyMedium),
                    ],
                  ),
                ),
              );
            }

            return Container(
              decoration: BoxDecoration(
                color: AppColors.sidebarDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: blogs.map((post) => _buildPostRow(post, isMobile)).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPostRow(dynamic post, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.cardDark)),
      ),
      child: isMobile ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  post['image'] ?? '',
                  width: 60,
                  height: 45,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 60, height: 45, color: AppColors.cardDark,
                    child: const Icon(Icons.article, size: 20, color: AppColors.textMuted),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post['title'] ?? '', style: AppTextStyles.heading3.copyWith(fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('${post['category']} • ${post['date']}', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.textGrey),
                onPressed: () => _navigateToEdit(post),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                onPressed: () => _deletePost(post['_id']),
              ),
            ],
          ),
        ],
      ) : Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              post['image'] ?? '',
              width: 60,
              height: 45,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 60, height: 45, color: AppColors.cardDark,
                child: const Icon(Icons.article, size: 20, color: AppColors.textMuted),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post['title'] ?? '', style: AppTextStyles.heading3.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text('${post['category']} • ${post['date']}', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.textGrey),
            onPressed: () => _navigateToEdit(post),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
            onPressed: () => _deletePost(post['_id']),
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
          Row(
            children: [
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white)),
              const SizedBox(width: 16),
              Text('Edit Blog Page', style: AppTextStyles.heading2),
            ],
          ),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveContent,
            icon: _isSaving 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.save),
            label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sidebarDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accentBlue, size: 20),
              const SizedBox(width: 12),
              Text(title, style: AppTextStyles.heading3),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label.copyWith(color: AppColors.textGrey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.sidebarDark,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
