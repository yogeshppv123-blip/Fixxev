import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';

class HomePageEditor extends StatefulWidget {
  const HomePageEditor({super.key});

  @override
  State<HomePageEditor> createState() => _HomePageEditorState();
}

class _HomePageEditorState extends State<HomePageEditor> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isSaving = false;

  final _heroTitleController = TextEditingController();
  final _heroSubtitleController = TextEditingController();
  
  final _stat1ValController = TextEditingController();
  final _stat1LabController = TextEditingController();
  final _stat2ValController = TextEditingController();
  final _stat2LabController = TextEditingController();
  final _stat3ValController = TextEditingController();
  final _stat3LabController = TextEditingController();
  final _stat4ValController = TextEditingController();
  final _stat4LabController = TextEditingController();

  final _wwdLabelController = TextEditingController();
  final _wwdTitleController = TextEditingController();
  final _wwdItem1TitleController = TextEditingController();
  final _wwdItem1DescController = TextEditingController();
  final _wwdItem2TitleController = TextEditingController();
  final _wwdItem2DescController = TextEditingController();
  final _wwdItem3TitleController = TextEditingController();
  final _wwdItem3DescController = TextEditingController();

  final _aboutLabelController = TextEditingController();
  final _aboutTitleController = TextEditingController();
  final _aboutDesc1Controller = TextEditingController();
  final _aboutDesc2Controller = TextEditingController();
  
  final _whyTitleController = TextEditingController();
  final _whyDescController = TextEditingController();
  
  final _whyItem1TitleController = TextEditingController();
  final _whyItem1DescController = TextEditingController();
  final _whyItem2TitleController = TextEditingController();
  final _whyItem2DescController = TextEditingController();
  final _whyItem3TitleController = TextEditingController();
  final _whyItem3DescController = TextEditingController();
  final _whyItem4TitleController = TextEditingController();
  final _whyItem4DescController = TextEditingController();

  final _joinTitleController = TextEditingController();
  final _joinSubtitleController = TextEditingController();

  final _partnersTitleController = TextEditingController();
  final _testimonialsTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final data = await _apiService.getPageContent('home');
      final content = data['content'] ?? {};
      
      setState(() {
        _heroTitleController.text = content['heroTitle'] ?? 'Leading the Multi-Brand EV Revolution';
        _heroSubtitleController.text = content['heroSubtitle'] ?? 'One-stop solution for 2W, L3, and L5 Electric Vehicles after-sales service and components.';
        
        _stat1ValController.text = content['stat1Value'] ?? '100+';
        _stat1LabController.text = content['stat1Label'] ?? 'Service Centers';
        _stat2ValController.text = content['stat2Value'] ?? '50+';
        _stat2LabController.text = content['stat2Label'] ?? 'Partner Brands';
        _stat3ValController.text = content['stat3Value'] ?? '10k+';
        _stat3LabController.text = content['stat3Label'] ?? 'Happy Customers';
        _stat4ValController.text = content['stat4Value'] ?? '100%';
        _stat4LabController.text = content['stat4Label'] ?? 'Sustainability';

        _wwdLabelController.text = content['whatWeDoLabel'] ?? '// FRANCHISE-LED GROWTH';
        _wwdTitleController.text = content['whatWeDoTitle'] ?? 'BUILDING INDIA’S LARGEST\nEV SERVICE NETWORK';
        _wwdItem1TitleController.text = content['wwdItem1Title'] ?? '500+ SERVICE CENTRES';
        _wwdItem1DescController.text = content['wwdItem1Desc'] ?? 'A pan-India network of 500+ EV service centres across key cities and towns.';
        _wwdItem2TitleController.text = content['wwdItem2Title'] ?? 'CERTIFIED SPARES';
        _wwdItem2DescController.text = content['wwdItem2Desc'] ?? 'Access to OEM-certified spares and standardized service processes nationwide.';
        _wwdItem3TitleController.text = content['wwdItem3Title'] ?? 'SKILLED TECHNICIANS';
        _wwdItem3DescController.text = content['wwdItem3Desc'] ?? 'Expertly trained technicians supported by Fixx EV for centralized quality control.';

        _aboutLabelController.text = content['aboutLabel'] ?? 'ANNOUNCING MISSION 500';
        _aboutTitleController.text = content['aboutTitle'] ?? 'SOLVING INDIA’S EV AFTER-SALES GAP';
        _aboutDesc1Controller.text = content['aboutDesc1'] ?? 'Fixx EV Technologies Pvt. Ltd. is on a mission to solve one of the biggest barriers to electric vehicle adoption in India.';
        _aboutDesc2Controller.text = content['aboutDesc2'] ?? 'We are building a nationwide, standardized EV after-sales network.';
        
        _whyTitleController.text = content['whyTitle'] ?? 'Why Choose Us';
        _whyDescController.text = content['whyDesc'] ?? 'At FIXXEV, we provide an ecosystem that ensures your electric vehicle remains in peak condition.';
        
        _whyItem1TitleController.text = content['whyItem1Title'] ?? 'Multi-Brand Expertise';
        _whyItem1DescController.text = content['whyItem1Desc'] ?? 'Complete service solutions for all EV brands under one roof.';
        _whyItem2TitleController.text = content['whyItem2Title'] ?? 'Standardized Spares';
        _whyItem2DescController.text = content['whyItem2Desc'] ?? 'Access to OEM-quality certified spare parts nationwide.';
        _whyItem3TitleController.text = content['whyItem3Title'] ?? 'Expert Care';
        _whyItem3DescController.text = content['whyItem3Desc'] ?? 'Trained professionals equipped with modern diagnostic tools.';
        _whyItem4TitleController.text = content['whyItem4Title'] ?? 'Rapid Deployment';
        _whyItem4DescController.text = content['whyItem4Desc'] ?? 'Quick setup of modular service centers within weeks.';

        _joinTitleController.text = content['joinTitle'] ?? 'Join The Mission';
        _joinSubtitleController.text = content['joinSubtitle'] ?? 'Partner with us to transform the EV service landscape.';
        
        _partnersTitleController.text = content['partnersTitle'] ?? 'TRUSTED BY INDUSTRY LEADERS';
        _testimonialsTitleController.text = content['testimonialsTitle'] ?? 'WHAT OUR PARTNERS SAY';

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
        'stat1Value': _stat1ValController.text,
        'stat1Label': _stat1LabController.text,
        'stat2Value': _stat2ValController.text,
        'stat2Label': _stat2LabController.text,
        'stat3Value': _stat3ValController.text,
        'stat3Label': _stat3LabController.text,
        'stat4Value': _stat4ValController.text,
        'stat4Label': _stat4LabController.text,
        'whatWeDoLabel': _wwdLabelController.text,
        'whatWeDoTitle': _wwdTitleController.text,
        'wwdItem1Title': _wwdItem1TitleController.text,
        'wwdItem1Desc': _wwdItem1DescController.text,
        'wwdItem2Title': _wwdItem2TitleController.text,
        'wwdItem2Desc': _wwdItem2DescController.text,
        'wwdItem3Title': _wwdItem3TitleController.text,
        'wwdItem3Desc': _wwdItem3DescController.text,
        'aboutLabel': _aboutLabelController.text,
        'aboutTitle': _aboutTitleController.text,
        'aboutDesc1': _aboutDesc1Controller.text,
        'aboutDesc2': _aboutDesc2Controller.text,
        'whyTitle': _whyTitleController.text,
        'whyDesc': _whyDescController.text,
        'whyItem1Title': _whyItem1TitleController.text,
        'whyItem1Desc': _whyItem1DescController.text,
        'whyItem2Title': _whyItem2TitleController.text,
        'whyItem2Desc': _whyItem2DescController.text,
        'whyItem3Title': _whyItem3TitleController.text,
        'whyItem3Desc': _whyItem3DescController.text,
        'whyItem4Title': _whyItem4TitleController.text,
        'whyItem4Desc': _whyItem4DescController.text,
        'joinTitle': _joinTitleController.text,
        'joinSubtitle': _joinSubtitleController.text,
        'partnersTitle': _partnersTitleController.text,
        'testimonialsTitle': _testimonialsTitleController.text,
      };
      
      await _apiService.updatePageContent('home', content);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Home page content updated!')));
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
                            _buildStatsSection(),
                            const SizedBox(height: 32),
                            _buildWhatWeDoSection(),
                            const SizedBox(height: 32),
                            _buildAboutSection(),
                            const SizedBox(height: 32),
                            _buildWhySection(),
                            const SizedBox(height: 32),
                            _buildPartnersSection(),
                            const SizedBox(height: 32),
                            _buildJoinSection(),
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

  Widget _buildWhatWeDoSection() {
    return _buildSectionCard(
      title: 'What We Do Section',
      icon: Icons.work_outline,
      children: [
        _buildTextField('Section Tagline', _wwdLabelController),
        const SizedBox(height: 16),
        _buildTextField('Main Heading', _wwdTitleController, maxLines: 2),
        const SizedBox(height: 24),
        const Text('Experience Cards', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildFeatureFields('Card 1', _wwdItem1TitleController, _wwdItem1DescController),
        const SizedBox(height: 16),
        _buildFeatureFields('Card 2', _wwdItem2TitleController, _wwdItem2DescController),
        const SizedBox(height: 16),
        _buildFeatureFields('Card 3', _wwdItem3TitleController, _wwdItem3DescController),
      ],
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
              Text('Edit Home Page', style: AppTextStyles.heading2),
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
        _buildTextField('Main Title', _heroTitleController, maxLines: 2),
        const SizedBox(height: 20),
        _buildTextField('Hero Subtitle', _heroSubtitleController, maxLines: 3),
      ],
    );
  }

  Widget _buildStatsSection() {
    return _buildSectionCard(
      title: 'Horizontal Stats Bar',
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

  Widget _buildAboutSection() {
    return _buildSectionCard(
      title: 'About Us (Mission 500)',
      icon: Icons.info_outline,
      children: [
        _buildTextField('Section Tagline', _aboutLabelController),
        const SizedBox(height: 16),
        _buildTextField('Main Heading', _aboutTitleController, maxLines: 2),
        const SizedBox(height: 16),
        _buildTextField('Description Paragraph 1', _aboutDesc1Controller, maxLines: 3),
        const SizedBox(height: 16),
        _buildTextField('Description Paragraph 2', _aboutDesc2Controller, maxLines: 3),
      ],
    );
  }

  Widget _buildWhySection() {
    return _buildSectionCard(
      title: 'Why Choose Us',
      icon: Icons.help_outline,
      children: [
        _buildTextField('Section Title', _whyTitleController),
        const SizedBox(height: 16),
        _buildTextField('Section Description', _whyDescController, maxLines: 2),
        const SizedBox(height: 24),
        const Text('Feature Items', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildFeatureFields('Feature 1', _whyItem1TitleController, _whyItem1DescController),
        const SizedBox(height: 16),
        _buildFeatureFields('Feature 2', _whyItem2TitleController, _whyItem2DescController),
        const SizedBox(height: 16),
        _buildFeatureFields('Feature 3', _whyItem3TitleController, _whyItem3DescController),
        const SizedBox(height: 16),
        _buildFeatureFields('Feature 4', _whyItem4TitleController, _whyItem4DescController),
      ],
    );
  }

  Widget _buildFeatureFields(String label, TextEditingController titleC, TextEditingController descC) {
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

  Widget _buildPartnersSection() {
    return _buildSectionCard(
      title: 'Partners & Testimonials',
      icon: Icons.business_outlined,
      children: [
        _buildTextField('Partners Section Title', _partnersTitleController),
        const SizedBox(height: 16),
        _buildTextField('Testimonials Section Title', _testimonialsTitleController),
      ],
    );
  }

  Widget _buildJoinSection() {
    return _buildSectionCard(
      title: 'Join The Mission (CTA)',
      icon: Icons.rocket_launch_outlined,
      children: [
        _buildTextField('CTA Title', _joinTitleController),
        const SizedBox(height: 16),
        _buildTextField('CTA Subtitle', _joinSubtitleController, maxLines: 2),
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
