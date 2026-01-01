import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';

class AboutPageEditor extends StatefulWidget {
  const AboutPageEditor({super.key});

  @override
  State<AboutPageEditor> createState() => _AboutPageEditorState();
}

class _AboutPageEditorState extends State<AboutPageEditor> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isSaving = false;

  final _titleController = TextEditingController();
  final _desc1Controller = TextEditingController();
  final _desc2Controller = TextEditingController();

  final _missionTitleController = TextEditingController();
  final _missionDescController = TextEditingController();
  
  final _visionTitleController = TextEditingController();
  final _visionDescController = TextEditingController();

  final _csrTitleController = TextEditingController();
  final _csrDescController = TextEditingController();

  final _futureTitleController = TextEditingController();
  final _futureDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final data = await _apiService.getPageContent('about');
      final content = data['content'] ?? {};
      
      setState(() {
        _titleController.text = content['title'] ?? 'The Hub of Multi-Brand EV Ecosystem';
        _desc1Controller.text = content['desc1'] ?? 'At FIXXEV, we are committed to revolutionizing the electric vehicle (EV) service industry.';
        _desc2Controller.text = content['desc2'] ?? 'As the demand for sustainable mobility grows, FIXXEV stands at the forefront of after-sales service.';
        
        _missionTitleController.text = content['missionTitle'] ?? 'Our Core Values';
        _missionDescController.text = content['missionDesc'] ?? 'At FIXXEV, we are driven by integrity, excellence, and a deep commitment to the environment.';
        
        _visionTitleController.text = content['visionTitle'] ?? 'Our Goal';
        _visionDescController.text = content['visionDesc'] ?? 'Our goal is to build India\'s most reliable EV support ecosystem.';
        
        _csrTitleController.text = content['csrTitle'] ?? 'Corporate Social Responsibility (CSR)';
        _csrDescController.text = content['csrDesc'] ?? 'FIXXEV is committed to making a positive impact on the environment and society.';
        
        _futureTitleController.text = content['futureTitle'] ?? 'Future Plans & Expansion';
        _futureDescController.text = content['futureDesc'] ?? 'We are rapidly expanding our footprint across India.';
        
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
        'desc1': _desc1Controller.text,
        'desc2': _desc2Controller.text,
        'missionTitle': _missionTitleController.text,
        'missionDesc': _missionDescController.text,
        'visionTitle': _visionTitleController.text,
        'visionDesc': _visionDescController.text,
        'csrTitle': _csrTitleController.text,
        'csrDesc': _csrDescController.text,
        'futureTitle': _futureTitleController.text,
        'futureDesc': _futureDescController.text,
      };
      
      await _apiService.updatePageContent('about', content);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('About page content updated!')));
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
                          children: [
                            _buildSectionCard(
                              title: 'Overview (Hero)',
                              icon: Icons.info_outline,
                              children: [
                                _buildTextField('Page Heading', _titleController, maxLines: 2),
                                const SizedBox(height: 16),
                                _buildTextField('Description Paragraph 1', _desc1Controller, maxLines: 3),
                                const SizedBox(height: 16),
                                _buildTextField('Description Paragraph 2', _desc2Controller, maxLines: 3),
                              ],
                            ),
                            const SizedBox(height: 32),
                            _buildSectionCard(
                              title: 'Core Values',
                              icon: Icons.lightbulb_outline,
                              children: [
                                _buildTextField('Values Title', _missionTitleController),
                                const SizedBox(height: 16),
                                _buildTextField('Values Description', _missionDescController, maxLines: 3),
                              ],
                            ),
                            const SizedBox(height: 32),
                            _buildSectionCard(
                              title: 'Our Goal',
                              icon: Icons.flag_outlined,
                              children: [
                                _buildTextField('Goal Title', _visionTitleController),
                                const SizedBox(height: 16),
                                _buildTextField('Goal Description', _visionDescController, maxLines: 3),
                              ],
                            ),
                            const SizedBox(height: 32),
                            _buildSectionCard(
                              title: 'CSR Section',
                              icon: Icons.favorite_outline,
                              children: [
                                _buildTextField('CSR Title', _csrTitleController),
                                const SizedBox(height: 16),
                                _buildTextField('CSR Description', _csrDescController, maxLines: 3),
                              ],
                            ),
                            const SizedBox(height: 32),
                            _buildSectionCard(
                              title: 'Expansion Section',
                              icon: Icons.trending_up,
                              children: [
                                _buildTextField('Future Plans Title', _futureTitleController),
                                const SizedBox(height: 16),
                                _buildTextField('Future Plans Description', _futureDescController, maxLines: 3),
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
              Text('Edit About Page', style: AppTextStyles.heading2),
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
