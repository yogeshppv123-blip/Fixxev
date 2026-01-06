import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:file_picker/file_picker.dart';

class NavbarEditor extends StatefulWidget {
  const NavbarEditor({super.key});

  @override
  State<NavbarEditor> createState() => _NavbarEditorState();
}

class _NavbarEditorState extends State<NavbarEditor> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isSaving = false;

  // Controllers
  final _logoUrlController = TextEditingController();
  final _bgColorController = TextEditingController();
  final _ctaTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final data = await _apiService.getPageContent('navbar');
      final content = data['content'] ?? {};

      setState(() {
        _logoUrlController.text = content['logoUrl'] ?? '';
        _bgColorController.text = content['bgColor'] ?? '0xFFFFFFFF'; // Default White
        _ctaTextController.text = content['ctaText'] ?? 'GET A QUOTE';
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveContent() async {
    setState(() => _isSaving = true);
    try {
      final content = {
        'logoUrl': _logoUrlController.text,
        'bgColor': _bgColorController.text,
        'ctaText': _ctaTextController.text,
      };

      await _apiService.updatePageContent('navbar', content);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navbar updated successfully!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving content: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _pickAndUploadImage(TextEditingController controller) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uploading image...')));
          final url = await _apiService.uploadImage(file.bytes!, file.name);
          setState(() {
            controller.text = url;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image uploaded successfully!')));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
        title: Text('Navbar Settings', style: AppTextStyles.heading3),
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
            child: Column(
              children: [
                // Header
                if (!isMobile) Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundDark,
                    border: Border(bottom: BorderSide(color: AppColors.sidebarDark)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const SizedBox(width: 8),
                              Text('Navbar Settings', style: AppTextStyles.heading2),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 48),
                            child: Text('Control logo, background color and CTA button', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: _isSaving ? null : _saveContent,
                        icon: _isSaving 
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.save, size: 18),
                        label: Text(_isSaving ? 'SAVING...' : 'SAVE CHANGES'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isMobile ? 16 : 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection(
                          title: 'Branding',
                          icon: Icons.branding_watermark,
                          children: [
                            _buildTextField('Logo URL', _logoUrlController, isImage: true, hint: 'https://example.com/logo.png'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSection(
                          title: 'Appearance',
                          icon: Icons.palette,
                          children: [
                            _buildTextField('Background Color (HEX)', _bgColorController, hint: 'e.g. 0xFFFFFFFF or 0xFF001F3F'),
                            const SizedBox(height: 20),
                            Text('Quick Presets', style: AppTextStyles.label.copyWith(fontSize: 11, letterSpacing: 1)),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _buildColorPreset('White', '0xFFFFFFFF', Colors.white),
                                _buildColorPreset('Navy', '0xFF001F3F', const Color(0xFF001F3F)),
                                _buildColorPreset('Blue', '0xFF007BFF', Colors.blue),
                                _buildColorPreset('L-Blue', '0xFFE3F2FD', Colors.blue[50]!),
                                _buildColorPreset('Green', '0xFF28A745', Colors.green),
                                _buildColorPreset('L-Green', '0xFFE8F5E9', Colors.green[50]!),
                                _buildColorPreset('Red', '0xFFDC3545', Colors.red),
                                _buildColorPreset('Amber', '0xFFFFC107', Colors.amber),
                                _buildColorPreset('Dark', '0xFF1A1A1A', const Color(0xFF1A1A1A)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Note: Use HEX format starting with 0xFF. Default is 0xFFFFFFFF (White).',
                              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSection(
                          title: 'Call to Action',
                          icon: Icons.touch_app,
                          children: [
                            _buildTextField('CTA Button Text', _ctaTextController, hint: 'GET A QUOTE'),
                          ],
                        ),
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

  Widget _buildColorPreset(String label, String hex, Color color) {
    return InkWell(
      onTap: () => setState(() => _bgColorController.text = hex),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required IconData icon, required List<Widget> children}) {
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

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, String? hint, bool isImage = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label.copyWith(fontSize: 11, letterSpacing: 1)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24),
            contentPadding: const EdgeInsets.all(16),
            filled: true,
            fillColor: AppColors.sidebarDark,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            suffixIcon: isImage 
              ? IconButton(
                  icon: const Icon(Icons.upload_file, color: AppColors.accentBlue),
                  onPressed: () => _pickAndUploadImage(controller),
                  tooltip: 'Upload Image',
                )
              : null,
          ),
        ),
      ],
    );
  }
}
