import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:fixxev_admin/core/services/cloudinary_service.dart';
import 'package:image_picker/image_picker.dart';

class MemberEditScreen extends StatefulWidget {
  final Map<String, dynamic>? member;
  const MemberEditScreen({super.key, this.member});

  @override
  State<MemberEditScreen> createState() => _MemberEditScreenState();
}

class _MemberEditScreenState extends State<MemberEditScreen> {
  final ApiService _apiService = ApiService();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _imgController;
  
  bool _isUploading = false;
  bool _isSaving = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.member != null;
    _nameController = TextEditingController(text: _isEditing ? widget.member!['name'] : '');
    _roleController = TextEditingController(text: _isEditing ? widget.member!['role'] : '');
    _imgController = TextEditingController(text: _isEditing ? (widget.member!['image'] ?? '') : '');
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

  Future<void> _saveMember() async {
    if (_nameController.text.trim().isEmpty || _roleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in Name and Role.'))
      );
      return;
    }

    setState(() => _isSaving = true);
    
    final data = {
      'name': _nameController.text.trim(),
      'role': _roleController.text.trim(),
      'image': _imgController.text.trim(),
    };

    try {
      if (_isEditing) {
        await _apiService.updateTeamMember(widget.member!['_id'], data);
      } else {
        await _apiService.createTeamMember(data);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? 'Member updated!' : 'Member added!'))
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
          const AdminSidebar(currentRoute: '/team'),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: SizedBox(
                        width: 800,
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
              Text(_isEditing ? 'Edit Team Member' : 'Add Team Member', style: AppTextStyles.heading2),
            ],
          ),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveMember,
            icon: _isSaving 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.save),
            label: Text(_isSaving ? 'Saving...' : 'Save Member'),
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
          _buildLabel('Full Name'),
          _buildTextField(_nameController, 'e.g. Vikram Malhotra'),
          const SizedBox(height: 24),
          _buildLabel('Role'),
          _buildTextField(_roleController, 'e.g. Service Manager'),
          const SizedBox(height: 24),
          _buildLabel('Profile Image'),
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
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Member Preview'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.sidebarDark),
          ),
          child: Column(
            children: [
              ClipOval(
                child: Image.network(
                  _imgController.text.isNotEmpty ? _imgController.text : 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, __, ___) => Container(
                    width: 120, height: 120,
                    color: AppColors.sidebarDark,
                    child: const Icon(Icons.person, size: 64, color: AppColors.textMuted),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _nameController.text.isEmpty ? 'Member Name' : _nameController.text, 
                style: AppTextStyles.heading3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _roleController.text.isEmpty ? 'Designation' : _roleController.text.toUpperCase(), 
                style: AppTextStyles.label.copyWith(color: AppColors.accentBlue, letterSpacing: 1.2),
                textAlign: TextAlign.center,
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

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
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
