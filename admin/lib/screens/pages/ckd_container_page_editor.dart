import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';

class CKDContainerPageEditor extends StatefulWidget {
  const CKDContainerPageEditor({super.key});

  @override
  State<CKDContainerPageEditor> createState() => _CKDContainerPageEditorState();
}

class _CKDContainerPageEditorState extends State<CKDContainerPageEditor> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isSaving = false;

  // Hero Section
  final _heroTitleController = TextEditingController();
  final _heroSubtitleController = TextEditingController();
  final _heroImageController = TextEditingController();

  // Join Community Section
  final _communityTitleController = TextEditingController();
  final _communityDescController = TextEditingController();
  final _communityImageController = TextEditingController();

  // Why Choose Section
  final _whyTitleController = TextEditingController();
  final _whySubtitleController = TextEditingController();
  final _whyItem1Controller = TextEditingController();
  final _whyItem2Controller = TextEditingController();
  final _whyItem3Controller = TextEditingController();
  final _whyItem4Controller = TextEditingController();

  // Smarter Showrooms Section
  final _smarterTitleController = TextEditingController();
  final _smarterSubtitleController = TextEditingController();
  final _smarterDescController = TextEditingController();
  final _smarterImageController = TextEditingController();

  // Stats Section
  final _stat1ValController = TextEditingController();
  final _stat1LabController = TextEditingController();
  final _stat2ValController = TextEditingController();
  final _stat2LabController = TextEditingController();
  final _stat3ValController = TextEditingController();
  final _stat3LabController = TextEditingController();
  final _stat4ValController = TextEditingController();
  final _stat4LabController = TextEditingController();

  // Process Steps
  final _step1TitleController = TextEditingController();
  final _step1DescController = TextEditingController();
  final _step2TitleController = TextEditingController();
  final _step2DescController = TextEditingController();
  final _step3TitleController = TextEditingController();
  final _step3DescController = TextEditingController();
  final _step4TitleController = TextEditingController();
  final _step4DescController = TextEditingController();

  // Network Section
  final _networkTitleController = TextEditingController();
  final _networkDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final data = await _apiService.getPageContent('ckd-container');
      final content = data['content'] ?? {};
      
      setState(() {
        // Hero
        _heroTitleController.text = content['heroTitle'] ?? 'CKD Container Showrooms';
        _heroSubtitleController.text = content['heroSubtitle'] ?? 'Modular, scalable, and ready to deploy EV showrooms';
        _heroImageController.text = content['heroImage'] ?? '';

        // Community
        _communityTitleController.text = content['communityTitle'] ?? 'Join the Fixx EV Community Get Your CKD Container!';
        _communityDescController.text = content['communityDesc'] ?? 'Our CKD showrooms offer a turnkey solution for entrepreneurs looking to enter the electric mobility market. Fast, efficient, and ready to deploy.';
        _communityImageController.text = content['communityImage'] ?? '';

        // Why Choose
        _whyTitleController.text = content['whyTitle'] ?? 'Why Choose CKD Containers?';
        _whySubtitleController.text = content['whySubtitle'] ?? 'The smart way to start your EV business';
        _whyItem1Controller.text = content['whyItem1'] ?? 'Quick 30-day deployment';
        _whyItem2Controller.text = content['whyItem2'] ?? 'Pre-fabricated infrastructure';
        _whyItem3Controller.text = content['whyItem3'] ?? 'Cost-effective solution';
        _whyItem4Controller.text = content['whyItem4'] ?? 'Fully customizable design';

        // Smarter Showrooms
        _smarterTitleController.text = content['smarterTitle'] ?? 'Modular CKD Showroom';
        _smarterSubtitleController.text = content['smarterSubtitle'] ?? 'Smarter Showrooms, Built for Performance.';
        _smarterDescController.text = content['smarterDesc'] ?? 'Our CKD containers are engineered to simplify dealership setup while maximizing efficiency.';
        _smarterImageController.text = content['smarterImage'] ?? '';

        // Stats
        _stat1ValController.text = content['stat1Value'] ?? '30';
        _stat1LabController.text = content['stat1Label'] ?? 'Days Setup';
        _stat2ValController.text = content['stat2Value'] ?? '500+';
        _stat2LabController.text = content['stat2Label'] ?? 'Sq Ft Space';
        _stat3ValController.text = content['stat3Value'] ?? '100%';
        _stat3LabController.text = content['stat3Label'] ?? 'Customizable';
        _stat4ValController.text = content['stat4Value'] ?? '50+';
        _stat4LabController.text = content['stat4Label'] ?? 'Cities Ready';

        // Process Steps
        _step1TitleController.text = content['step1Title'] ?? 'Contact Us';
        _step1DescController.text = content['step1Desc'] ?? 'Reach out to discuss your requirements';
        _step2TitleController.text = content['step2Title'] ?? 'Site Survey';
        _step2DescController.text = content['step2Desc'] ?? 'We evaluate your location';
        _step3TitleController.text = content['step3Title'] ?? 'Customization';
        _step3DescController.text = content['step3Desc'] ?? 'Design your container layout';
        _step4TitleController.text = content['step4Title'] ?? 'Deployment';
        _step4DescController.text = content['step4Desc'] ?? 'Launch your showroom';

        // Network
        _networkTitleController.text = content['networkTitle'] ?? 'Pan-India Network';
        _networkDescController.text = content['networkDesc'] ?? 'Our CKD containers are deployed across major cities in India';

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
        'communityTitle': _communityTitleController.text,
        'communityDesc': _communityDescController.text,
        'communityImage': _communityImageController.text,
        'whyTitle': _whyTitleController.text,
        'whySubtitle': _whySubtitleController.text,
        'whyItem1': _whyItem1Controller.text,
        'whyItem2': _whyItem2Controller.text,
        'whyItem3': _whyItem3Controller.text,
        'whyItem4': _whyItem4Controller.text,
        'smarterTitle': _smarterTitleController.text,
        'smarterSubtitle': _smarterSubtitleController.text,
        'smarterDesc': _smarterDescController.text,
        'smarterImage': _smarterImageController.text,
        'stat1Value': _stat1ValController.text,
        'stat1Label': _stat1LabController.text,
        'stat2Value': _stat2ValController.text,
        'stat2Label': _stat2LabController.text,
        'stat3Value': _stat3ValController.text,
        'stat3Label': _stat3LabController.text,
        'stat4Value': _stat4ValController.text,
        'stat4Label': _stat4LabController.text,
        'step1Title': _step1TitleController.text,
        'step1Desc': _step1DescController.text,
        'step2Title': _step2TitleController.text,
        'step2Desc': _step2DescController.text,
        'step3Title': _step3TitleController.text,
        'step3Desc': _step3DescController.text,
        'step4Title': _step4TitleController.text,
        'step4Desc': _step4DescController.text,
        'networkTitle': _networkTitleController.text,
        'networkDesc': _networkDescController.text,
      };
      
      await _apiService.updatePageContent('ckd-container', content);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CKD Container page updated!')));
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
                            _buildCommunitySection(),
                            const SizedBox(height: 32),
                            _buildWhySection(),
                            const SizedBox(height: 32),
                            _buildSmarterSection(),
                            const SizedBox(height: 32),
                            _buildStatsSection(),
                            const SizedBox(height: 32),
                            _buildProcessSection(),
                            const SizedBox(height: 32),
                            _buildNetworkSection(),
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
              Text('Edit CKD Container Page', style: AppTextStyles.heading2),
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

  Widget _buildCommunitySection() {
    return _buildSectionCard(
      title: 'Join Community Section',
      icon: Icons.people_outline,
      children: [
        _buildTextField('Section Title', _communityTitleController, maxLines: 2),
        const SizedBox(height: 16),
        _buildTextField('Description', _communityDescController, maxLines: 3),
        const SizedBox(height: 16),
        _buildTextField('Image URL', _communityImageController),
      ],
    );
  }

  Widget _buildWhySection() {
    return _buildSectionCard(
      title: 'Why Choose Section',
      icon: Icons.help_outline,
      children: [
        _buildTextField('Section Title', _whyTitleController),
        const SizedBox(height: 16),
        _buildTextField('Subtitle', _whySubtitleController),
        const SizedBox(height: 24),
        const Text('Benefit Items', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildTextField('Item 1', _whyItem1Controller),
        const SizedBox(height: 12),
        _buildTextField('Item 2', _whyItem2Controller),
        const SizedBox(height: 12),
        _buildTextField('Item 3', _whyItem3Controller),
        const SizedBox(height: 12),
        _buildTextField('Item 4', _whyItem4Controller),
      ],
    );
  }

  Widget _buildSmarterSection() {
    return _buildSectionCard(
      title: 'Smarter Showrooms Section',
      icon: Icons.business,
      children: [
        _buildTextField('Title', _smarterTitleController),
        const SizedBox(height: 16),
        _buildTextField('Subtitle', _smarterSubtitleController),
        const SizedBox(height: 16),
        _buildTextField('Description', _smarterDescController, maxLines: 3),
        const SizedBox(height: 16),
        _buildTextField('Image URL', _smarterImageController),
      ],
    );
  }

  Widget _buildStatsSection() {
    return _buildSectionCard(
      title: 'Stats Bar',
      icon: Icons.bar_chart,
      children: [
        Row(
          children: [
            Expanded(child: _buildTextField('Stat 1 Value', _stat1ValController)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Stat 1 Label', _stat1LabController)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('Stat 2 Value', _stat2ValController)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Stat 2 Label', _stat2LabController)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('Stat 3 Value', _stat3ValController)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Stat 3 Label', _stat3LabController)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('Stat 4 Value', _stat4ValController)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Stat 4 Label', _stat4LabController)),
          ],
        ),
      ],
    );
  }

  Widget _buildProcessSection() {
    return _buildSectionCard(
      title: 'Process Steps',
      icon: Icons.timeline,
      children: [
        _buildStepFields('Step 1', _step1TitleController, _step1DescController),
        const SizedBox(height: 16),
        _buildStepFields('Step 2', _step2TitleController, _step2DescController),
        const SizedBox(height: 16),
        _buildStepFields('Step 3', _step3TitleController, _step3DescController),
        const SizedBox(height: 16),
        _buildStepFields('Step 4', _step4TitleController, _step4DescController),
      ],
    );
  }

  Widget _buildNetworkSection() {
    return _buildSectionCard(
      title: 'Network Section',
      icon: Icons.map_outlined,
      children: [
        _buildTextField('Section Title', _networkTitleController),
        const SizedBox(height: 16),
        _buildTextField('Description', _networkDescController, maxLines: 2),
      ],
    );
  }

  Widget _buildStepFields(String label, TextEditingController titleC, TextEditingController descC) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.accentBlue, fontSize: 12)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildTextField('Title', titleC)),
            const SizedBox(width: 16),
            Expanded(flex: 2, child: _buildTextField('Description', descC)),
          ],
        ),
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
