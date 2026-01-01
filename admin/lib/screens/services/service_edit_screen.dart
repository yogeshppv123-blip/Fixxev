import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:fixxev_admin/core/services/cloudinary_service.dart';
import 'package:image_picker/image_picker.dart';

class ServiceEditScreen extends StatefulWidget {
  final Map<String, dynamic>? service;
  const ServiceEditScreen({super.key, this.service});

  @override
  State<ServiceEditScreen> createState() => _ServiceEditScreenState();
}

class _ServiceEditScreenState extends State<ServiceEditScreen> {
  final ApiService _apiService = ApiService();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  
  late TextEditingController _titleController;
  late TextEditingController _catController;
  late TextEditingController _descController;
  late TextEditingController _imgController;
  String _status = 'Active';
  
  bool _isSaving = false;
  bool _isUploading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.service != null;
    _titleController = TextEditingController(text: _isEditing ? widget.service!['title'] : '');
    _catController = TextEditingController(text: _isEditing ? widget.service!['category'] : '');
    _descController = TextEditingController(text: _isEditing ? (widget.service!['description'] ?? '') : '');
    _imgController = TextEditingController(text: _isEditing ? (widget.service!['image'] ?? '') : '');
    _status = _isEditing ? (widget.service!['status'] ?? 'Active') : 'Active';
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
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload failed.')));
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

  Future<void> _saveService() async {
    if (_titleController.text.trim().isEmpty || 
        _catController.text.trim().isEmpty || 
        _descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in Title, Category, and Description.'))
      );
      return;
    }

    setState(() => _isSaving = true);
    
    final data = {
      'title': _titleController.text.trim(),
      'category': _catController.text.trim(),
      'description': _descController.text.trim(),
      'image': _imgController.text.trim(),
      'status': _status,
    };

    try {
      if (_isEditing) {
        await _apiService.updateService(widget.service!['_id'], data);
      } else {
        await _apiService.createService(data);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? 'Service updated!' : 'Service added!'))
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          const AdminSidebar(currentRoute: '/services'),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildForm()),
                        const SizedBox(width: 32),
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
              Text(_isEditing ? 'Edit Service' : 'Add New Service', style: AppTextStyles.heading2),
            ],
          ),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveService,
            icon: _isSaving 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.save),
            label: Text(_isSaving ? 'Saving...' : 'Save Service'),
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
          _buildLabel('Service Title'),
          _buildTextField(_titleController, 'e.g. Precision After-Sales Service'),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Category'),
                    _buildTextField(_catController, 'e.g. After-Sales, Warranty'),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Status'),
                    DropdownButtonFormField<String>(
                      value: _status,
                      dropdownColor: AppColors.cardDark,
                      style: AppTextStyles.bodyLarge,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.sidebarDark,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      items: ['Active', 'Draft', 'Inactive'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (val) => setState(() => _status = val!),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildLabel('Service Image'),
          Row(
            children: [
              Expanded(child: _buildTextField(_imgController, 'Paste image URL or upload...')),
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
          const SizedBox(height: 24),
          _buildLabel('Full Description'),
          _buildTextField(_descController, 'Detailed explanation of the service...', maxLines: 5),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Service Card Preview'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.sidebarDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Preview
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _imgController.text.isNotEmpty ? _imgController.text : 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=800',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    width: double.infinity,
                    color: AppColors.sidebarDark,
                    child: const Icon(Icons.image_outlined, size: 48, color: AppColors.textMuted),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
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
                  _buildStatusBadge(_status),
                ],
              ),
              const SizedBox(height: 24),
              Text(_titleController.text.isEmpty ? 'Service Title' : _titleController.text, style: AppTextStyles.heading3),
              const SizedBox(height: 12),
              Text(
                _descController.text.isEmpty ? 'The description will appear here...' : _descController.text, 
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey, height: 1.5),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.sidebarDark,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _catController.text.isEmpty ? 'CATEGORY' : _catController.text.toUpperCase(),
                  style: AppTextStyles.label.copyWith(fontSize: 10, letterSpacing: 1.2),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = AppColors.success;
    if (status == 'Inactive') color = AppColors.error;
    if (status == 'Draft') color = AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(status.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
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
