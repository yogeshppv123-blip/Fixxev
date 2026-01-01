import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:fixxev_admin/core/services/cloudinary_service.dart';
import 'package:image_picker/image_picker.dart';

class BlogEditScreen extends StatefulWidget {
  final Map<String, dynamic>? blog;
  const BlogEditScreen({super.key, this.blog});

  @override
  State<BlogEditScreen> createState() => _BlogEditScreenState();
}

class _BlogEditScreenState extends State<BlogEditScreen> {
  final ApiService _apiService = ApiService();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  
  late TextEditingController _titleController;
  late TextEditingController _catController;
  late TextEditingController _imgController;
  late TextEditingController _excerptController;
  late TextEditingController _contentController;
  
  bool _isUploading = false;
  bool _isSaving = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.blog != null;
    _titleController = TextEditingController(text: _isEditing ? widget.blog!['title'] : '');
    _catController = TextEditingController(text: _isEditing ? widget.blog!['category'] : '');
    _imgController = TextEditingController(text: _isEditing ? widget.blog!['image'] : '');
    _excerptController = TextEditingController(text: _isEditing ? widget.blog!['excerpt'] : '');
    _contentController = TextEditingController(text: _isEditing ? (widget.blog!['content'] ?? '') : '');
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        setState(() => _isUploading = true);
        final url = await _cloudinaryService.uploadImage(image);
        
        if (mounted) {
          setState(() {
            _isUploading = false;
            if (url != null) {
              _imgController.text = url;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image uploaded!')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload failed. Check console for details.')));
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _saveBlog() async {
    if (_titleController.text.trim().isEmpty || 
        _catController.text.trim().isEmpty || 
        _excerptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in required fields (Title, Category, Excerpt)'))
      );
      return;
    }

    setState(() => _isSaving = true);
    
    final data = {
      'title': _titleController.text.trim(),
      'category': _catController.text.trim(),
      'image': _imgController.text.trim(),
      'excerpt': _excerptController.text.trim(),
      'content': _contentController.text.trim(),
      'date': _isEditing ? widget.blog!['date'] : _formatDate(DateTime.now()),
    };

    if (data['image']!.isEmpty) {
      data['image'] = 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800';
    }

    try {
      if (_isEditing) {
        await _apiService.updateBlog(widget.blog!['_id'], data);
      } else {
        await _apiService.createBlog(data);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? 'Post updated!' : 'Post created!'))
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          const AdminSidebar(currentRoute: '/blog'),
          Expanded(
            child: Column(
              children: [
                // Custom Header
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Edit Form
                        Expanded(flex: 3, child: _buildForm()),
                        const SizedBox(width: 32),
                        // Preview Card
                        Expanded(flex: 2, child: _buildPreview()),
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
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Text(_isEditing ? 'Edit Blog Post' : 'New Blog Post', style: AppTextStyles.heading2),
            ],
          ),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveBlog,
            icon: _isSaving 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.save),
            label: Text(_isSaving ? 'Saving...' : 'Save Post'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentRed,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Post Title'),
          _buildTextField(_titleController, 'Enter post title...', maxLines: 1),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Category'),
                    _buildTextField(_catController, 'e.g. TECHNOLOGY, NEWS'),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Image URL'),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(_imgController, 'Paste URL or upload...')),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _isUploading ? null : _pickAndUploadImage,
                          icon: _isUploading 
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.cloud_upload_outlined, size: 18),
                          label: Text(_isUploading ? 'Uploading...' : 'Upload'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.sidebarDark,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildLabel('Excerpt (Short Summary)'),
          _buildTextField(_excerptController, 'Brief description for the list view...', maxLines: 3),
          const SizedBox(height: 24),
          _buildLabel('Article Content'),
          _buildTextField(_contentController, 'Write your full article here...', maxLines: 10),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Live Preview'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.sidebarDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  _imgController.text.isNotEmpty ? _imgController.text : 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: AppColors.sidebarDark,
                    child: const Icon(Icons.image_not_supported, size: 48, color: AppColors.textMuted),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_catController.text.isEmpty ? 'CATEGORY' : _catController.text.toUpperCase(), 
                      style: AppTextStyles.label.copyWith(color: AppColors.accentBlue)),
                    const SizedBox(height: 12),
                    Text(_titleController.text.isEmpty ? 'Post Title' : _titleController.text, 
                      style: AppTextStyles.heading3),
                    const SizedBox(height: 12),
                    Text(_excerptController.text.isEmpty ? 'The excerpt will appear here...' : _excerptController.text, 
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: AppTextStyles.label.copyWith(color: Colors.white)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: (_) => setState(() {}),
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.sidebarDark,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}
