import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';

class CKDEditScreen extends StatefulWidget {
  final Map<String, dynamic>? feature;
  const CKDEditScreen({super.key, this.feature});

  @override
  State<CKDEditScreen> createState() => _CKDEditScreenState();
}

class _CKDEditScreenState extends State<CKDEditScreen> {
  final ApiService _apiService = ApiService();
  bool _isSaving = false;
  bool _isActive = true;

  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String _selectedCategory = 'Infrastructure';

  final List<String> _categories = ['Infrastructure', 'Technology', 'Design', 'Efficiency', 'Sustainability', 'Support'];

  @override
  void initState() {
    super.initState();
    if (widget.feature != null) {
      _titleController.text = widget.feature!['title'] ?? '';
      _subtitleController.text = widget.feature!['subtitle'] ?? '';
      _descriptionController.text = widget.feature!['description'] ?? '';
      _imageUrlController.text = widget.feature!['imageUrl'] ?? '';
      _selectedCategory = widget.feature!['category'] ?? 'Infrastructure';
      _isActive = widget.feature!['isActive'] ?? true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _showMediaPicker() {
    showDialog(
      context: context,
      builder: (context) => _MediaPickerDialog(
        onUrlSelected: (url) {
          setState(() {
            _imageUrlController.text = url;
          });
        },
      ),
    );
  }

  Future<void> _saveFeature() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title is required')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final data = {
        'title': _titleController.text,
        'subtitle': _subtitleController.text,
        'description': _descriptionController.text,
        'category': _selectedCategory,
        'imageUrl': _imageUrlController.text,
        'isActive': _isActive,
      };

      if (widget.feature != null) {
        await _apiService.updateCKDFeature(widget.feature!['_id'], data);
      } else {
        await _apiService.createCKDFeature(data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.feature != null ? 'Feature updated!' : 'Feature created!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.feature != null;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          const AdminSidebar(currentRoute: '/ckd-content'),
          Expanded(
            child: Column(
              children: [
                _buildHeader(isEditing),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        _buildSectionCard(
                          title: 'Feature Details',
                          icon: Icons.store_outlined,
                          children: [
                            _buildTextField('Title', _titleController, 'e.g., Modular Design'),
                            const SizedBox(height: 16),
                            _buildTextField('Subtitle', _subtitleController, 'e.g., Flexible & Scalable'),
                            const SizedBox(height: 16),
                            _buildDropdown(),
                            const SizedBox(height: 16),
                            _buildTextField('Description', _descriptionController, 'Describe this feature...', maxLines: 4),
                            const SizedBox(height: 16),
                            _buildImageField(),
                            const SizedBox(height: 16),
                            _buildActiveSwitch(),
                          ],
                        ),
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

  Widget _buildHeader(bool isEditing) {
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
              Text(isEditing ? 'Edit Feature' : 'Add Feature', style: AppTextStyles.heading2),
            ],
          ),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveFeature,
            icon: _isSaving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.save),
            label: Text(_isSaving ? 'Saving...' : 'Save'),
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

  Widget _buildTextField(String label, TextEditingController controller, String hint, {int maxLines = 1}) {
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
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
            filled: true,
            fillColor: AppColors.sidebarDark,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildImageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Image', style: AppTextStyles.label.copyWith(color: AppColors.textGrey)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _imageUrlController,
                style: AppTextStyles.bodyLarge,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Paste image URL here...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
                  filled: true,
                  fillColor: AppColors.sidebarDark,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.link, color: AppColors.textMuted),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _showMediaPicker,
              icon: const Icon(Icons.photo_library),
              label: const Text('Browse'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentTeal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ],
        ),
        if (_imageUrlController.text.isNotEmpty && _imageUrlController.text.startsWith('http'))
          Container(
            margin: const EdgeInsets.only(top: 12),
            height: 120,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.sidebarDark),
              color: AppColors.sidebarDark,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _imageUrlController.text,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, color: AppColors.textMuted),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: AppTextStyles.label.copyWith(color: AppColors.textGrey)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.sidebarDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              dropdownColor: AppColors.sidebarDark,
              style: AppTextStyles.bodyLarge,
              items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedCategory = value);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Active', style: AppTextStyles.bodyLarge),
        Switch(
          value: _isActive,
          onChanged: (value) => setState(() => _isActive = value),
          activeColor: AppColors.accentTeal,
        ),
      ],
    );
  }
}

// Media Picker Dialog
class _MediaPickerDialog extends StatefulWidget {
  final Function(String) onUrlSelected;
  const _MediaPickerDialog({required this.onUrlSelected});

  @override
  State<_MediaPickerDialog> createState() => _MediaPickerDialogState();
}

class _MediaPickerDialogState extends State<_MediaPickerDialog> {
  final ApiService _apiService = ApiService();
  List<dynamic> _media = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedia();
  }

  Future<void> _loadMedia() async {
    try {
      final media = await _apiService.getMedia();
      if (mounted) {
        setState(() {
          _media = media;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        height: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select from Media Library', style: AppTextStyles.heading3),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _media.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.photo_library_outlined, size: 48, color: AppColors.textGrey),
                              const SizedBox(height: 16),
                              Text('No media found', style: AppTextStyles.bodyMedium),
                              const SizedBox(height: 8),
                              Text('Add images in Media section first', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey)),
                            ],
                          ),
                        )
                      : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _media.length,
                          itemBuilder: (context, index) {
                            final item = _media[index];
                            return InkWell(
                              onTap: () {
                                widget.onUrlSelected(item['url'] ?? '');
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.sidebarDark),
                                  color: AppColors.sidebarDark,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item['url'] ?? '',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Center(
                                      child: Icon(Icons.broken_image, color: AppColors.textMuted),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
