import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:file_picker/file_picker.dart';

class FooterEditor extends StatefulWidget {
  const FooterEditor({super.key});

  @override
  State<FooterEditor> createState() => _FooterEditorState();
}

class _FooterEditorState extends State<FooterEditor> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isSaving = false;

  // Controllers
  final _taglineController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _logoController = TextEditingController();
  
  // Social Links
  final _facebookController = TextEditingController();
  final _instagramController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _youtubeController = TextEditingController();
  final _whatsappController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final data = await _apiService.getPageContent('footer');
      final content = data['content'] ?? {};

      setState(() {
        _taglineController.text = content['tagline'] ?? 'India’s largest, nationwide standardized EV after-sales service and spares network. Solving the biggest barriers to EV adoption.';
        _phoneController.text = content['phone'] ?? '+91 93110 81137';
        _emailController.text = content['email'] ?? 'Sales@fixxev.in';
        _addressController.text = content['address'] ?? '704, 7th Floor, Palm Court, MG Road Sector 16, Gurugram 122001';
        _logoController.text = content['logo'] ?? '';
        
        _facebookController.text = content['facebook'] ?? '';
        _instagramController.text = content['instagram'] ?? 'https://www.instagram.com/fixxev/';
        _linkedinController.text = content['linkedin'] ?? 'https://www.linkedin.com/company/fixxev/';
        _youtubeController.text = content['youtube'] ?? '';
        _whatsappController.text = content['whatsapp'] ?? 'https://wa.me/917400444013';
        
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
        'tagline': _taglineController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'address': _addressController.text,
        'logo': _logoController.text,
        'facebook': _facebookController.text,
        'instagram': _instagramController.text,
        'linkedin': _linkedinController.text,
        'youtube': _youtubeController.text,
        'whatsapp': _whatsappController.text,
      };

      await _apiService.updatePageContent('footer', content);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Footer updated successfully!')));
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

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          const AdminSidebar(currentRoute: '/pages'),
          Expanded(
            child: Column(
              children: [
                // Fixed Header
                Container(
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
                              Text('Footer Settings', style: AppTextStyles.heading2),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 48),
                            child: Text('Global footer content and social links', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
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
                          backgroundColor: AppColors.accentRed,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection(
                          title: 'Company Information',
                          icon: Icons.business,
                          children: [
                            _buildTextField('Footer Tagline', _taglineController, maxLines: 3),
                            const SizedBox(height: 20),
                            _buildTextField('Logo URL (Optional)', _logoController, hint: 'https://example.com/logo.png', isImage: true),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSection(
                          title: 'Contact Information',
                          icon: Icons.contact_phone,
                          children: [
                            Row(
                              children: [
                                Expanded(child: _buildTextField('Phone Number', _phoneController)),
                                const SizedBox(width: 20),
                                Expanded(child: _buildTextField('Email Address', _emailController)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildTextField('Office Address', _addressController, maxLines: 2),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSection(
                          title: 'Social Media Links',
                          icon: Icons.share,
                          children: [
                            Row(
                              children: [
                                Expanded(child: _buildTextField('Facebook URL', _facebookController)),
                                const SizedBox(width: 20),
                                Expanded(child: _buildTextField('Instagram URL', _instagramController)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(child: _buildTextField('LinkedIn URL', _linkedinController)),
                                const SizedBox(width: 20),
                                Expanded(child: _buildTextField('WhatsApp URL', _whatsappController, hint: 'wa.me/number')),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildTextField('YouTube / Play Store URL', _youtubeController),
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
              Icon(icon, color: AppColors.accentRed, size: 20),
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
                  icon: const Icon(Icons.upload_file, color: AppColors.accentRed),
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
