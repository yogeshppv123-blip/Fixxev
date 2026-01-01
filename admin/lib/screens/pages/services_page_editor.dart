import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';

class ServicesPageEditor extends StatefulWidget {
  const ServicesPageEditor({super.key});

  @override
  State<ServicesPageEditor> createState() => _ServicesPageEditorState();
}

class _ServicesPageEditorState extends State<ServicesPageEditor> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isSaving = false;

  final _heroTitleController = TextEditingController();
  final _heroSubtitleController = TextEditingController();
  final _heroImageController = TextEditingController();

  final _introTitleController = TextEditingController();
  final _introDescController = TextEditingController();

  final _processTitleController = TextEditingController();
  final _processSubtitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final data = await _apiService.getPageContent('services');
      final content = data['content'] ?? {};
      
      setState(() {
        _heroTitleController.text = content['heroTitle'] ?? 'Our Services';
        _heroSubtitleController.text = content['heroSubtitle'] ?? 'We offer a wide range of EV services to keep you moving.';
        _heroImageController.text = content['heroImage'] ?? '';

        _introTitleController.text = content['introTitle'] ?? 'Comprehensive EV Care';
        _introDescController.text = content['introDesc'] ?? 'From routine maintenance to complex repairs, our team of experts is here to help.';

        _processTitleController.text = content['processTitle'] ?? 'Our Process';
        _processSubtitleController.text = content['processSubtitle'] ?? 'Simple, transparent, and efficient service process.';

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
        'heroTitle': _heroTitleController.text,
        'heroSubtitle': _heroSubtitleController.text,
        'heroImage': _heroImageController.text,
        'introTitle': _introTitleController.text,
        'introDesc': _introDescController.text,
        'processTitle': _processTitleController.text,
        'processSubtitle': _processSubtitleController.text,
      };
      
      await _apiService.updatePageContent('services', content);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Services page updated!')));
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
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          const AdminSidebar(currentRoute: '/pages'),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeroSection(),
                            const SizedBox(height: 32),
                            _buildIntroSection(),
                            const SizedBox(height: 32),
                            _buildProcessSection(),
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
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white)),
              const SizedBox(width: 16),
              Text('Edit Services Page', style: AppTextStyles.heading2),
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

  Widget _buildHeroSection() {
    return _buildSectionCard(
      title: 'Hero Section',
      icon: Icons.title,
      children: [
        _buildTextField('Hero Title', _heroTitleController),
        const SizedBox(height: 16),
        _buildTextField('Hero Subtitle', _heroSubtitleController, maxLines: 2),
        const SizedBox(height: 16),
        _buildTextField('Background Image URL', _heroImageController),
      ],
    );
  }

  Widget _buildIntroSection() {
    return _buildSectionCard(
      title: 'Introduction',
      icon: Icons.info_outline,
      children: [
        _buildTextField('Intro Title', _introTitleController),
        const SizedBox(height: 16),
        _buildTextField('Intro Description', _introDescController, maxLines: 3),
      ],
    );
  }

  Widget _buildProcessSection() {
    return _buildSectionCard(
      title: 'Process Section',
      icon: Icons.timeline,
      children: [
        _buildTextField('Process Title', _processTitleController),
        const SizedBox(height: 16),
        _buildTextField('Process Subtitle', _processSubtitleController, maxLines: 2),
      ],
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
