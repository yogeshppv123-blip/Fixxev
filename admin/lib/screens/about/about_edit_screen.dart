import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';

class AboutEditScreen extends StatefulWidget {
  final Map<String, dynamic>? section;
  const AboutEditScreen({super.key, this.section});

  @override
  State<AboutEditScreen> createState() => _AboutEditScreenState();
}

class _AboutEditScreenState extends State<AboutEditScreen> {
  final ApiService _apiService = ApiService();
  bool _isSaving = false;
  bool _isActive = true;

  final _titleController = TextEditingController();
  final _labelController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _itemsController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String _selectedType = 'Values';

  final List<String> _types = ['Values', 'Vision', 'CSR', 'Future', 'Custom'];

  @override
  void initState() {
    super.initState();
    if (widget.section != null) {
      _titleController.text = widget.section!['title'] ?? '';
      _labelController.text = widget.section!['label'] ?? '';
      _descriptionController.text = widget.section!['description'] ?? '';
      _imageUrlController.text = widget.section!['imageUrl'] ?? '';
      _selectedType = widget.section!['type'] ?? 'Values';
      _isActive = widget.section!['isActive'] ?? true;
      if (widget.section!['items'] != null) {
        _itemsController.text = (widget.section!['items'] as List).join(', ');
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _labelController.dispose();
    _descriptionController.dispose();
    _itemsController.dispose();
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

  Future<void> _saveSection() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title is required')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final sectionData = {
        'title': _titleController.text,
        'label': _labelController.text,
        'description': _descriptionController.text,
        'imageUrl': _imageUrlController.text,
        'type': _selectedType,
        'isActive': _isActive,
        'items': _itemsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      };

      if (widget.section != null) {
        await _apiService.updateAboutSection(widget.section!['_id'], sectionData);
      } else {
        await _apiService.createAboutSection(sectionData);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.section != null ? 'Section updated!' : 'Section created!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving section: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.section != null;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          const AdminSidebar(currentRoute: '/about'),
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
                          title: 'Section Details',
                          icon: Icons.info_outline,
                          children: [
                            _buildTextField('Title', _titleController, 'e.g., Our Core Values'),
                            const SizedBox(height: 16),
                            _buildTextField('Label', _labelController, 'e.g., // VALUES'),
                            const SizedBox(height: 16),
                            _buildDropdown(),
                            const SizedBox(height: 16),
                            _buildTextField('Description', _descriptionController, 'Section description...', maxLines: 4),
                            const SizedBox(height: 16),
                            _buildTextField('Items (Comma separated)', _itemsController, 'Item 1, Item 2, Item 3', maxLines: 3),
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
              Text(isEditing ? 'Edit Section' : 'Add Section', style: AppTextStyles.heading2),
            ],
          ),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveSection,
            icon: _isSaving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.save),
            label: Text(_isSaving ? 'Saving...' : 'Save Section'),
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
        Text('Type', style: AppTextStyles.label.copyWith(color: AppColors.textGrey)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.sidebarDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedType,
              isExpanded: true,
              dropdownColor: AppColors.sidebarDark,
              style: AppTextStyles.bodyLarge,
              items: _types.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedType = value);
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
