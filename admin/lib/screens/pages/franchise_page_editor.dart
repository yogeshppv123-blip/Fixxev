import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:file_picker/file_picker.dart';

class FranchisePageEditor extends StatefulWidget {
  const FranchisePageEditor({super.key});

  @override
  State<FranchisePageEditor> createState() => _FranchisePageEditorState();
}

class _FranchisePageEditorState extends State<FranchisePageEditor> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isSaving = false;

  // Hero Section
  final _heroTaglineController = TextEditingController();
  final _heroTitleController = TextEditingController();
  final _heroSubtitleController = TextEditingController();
  final _heroImageController = TextEditingController();

  // What We Do Section
  final _missionLabelController = TextEditingController();
  final _missionTitleController = TextEditingController();
  final _missionDescController = TextEditingController();
  final _missionFeaturesController = TextEditingController();
  final _missionImageController = TextEditingController();

  // Franchise Options Section
  final _optionsLabelController = TextEditingController();
  final _optionsTitleController = TextEditingController();

  // Spare Parts Dealer
  final _sparePartsTitleController = TextEditingController();
  final _sparePartsDescController = TextEditingController();
  final _sparePartsBenefitsController = TextEditingController();
  final _sparePartsImageController = TextEditingController();

  // Service Center Dealer
  final _serviceCenterTitleController = TextEditingController();
  final _serviceCenterDescController = TextEditingController();
  final _serviceCenterBenefitsController = TextEditingController();
  final _serviceCenterImageController = TextEditingController();

  // Why Partner Section
  final _whyPartnerLabelController = TextEditingController();
  final _whyPartnerTitleController = TextEditingController();
  final _whyPartnerDescController = TextEditingController();
  
  // Stats
  final _stat1ValueController = TextEditingController();
  final _stat1LabelController = TextEditingController();
  final _stat2ValueController = TextEditingController();
  final _stat2LabelController = TextEditingController();
  final _stat3ValueController = TextEditingController();
  final _stat3LabelController = TextEditingController();
  final _stat4ValueController = TextEditingController();
  final _stat4LabelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  @override
  void dispose() {
    _heroTaglineController.dispose();
    _heroTitleController.dispose();
    _heroSubtitleController.dispose();
    _heroImageController.dispose();
    _missionLabelController.dispose();
    _missionTitleController.dispose();
    _missionDescController.dispose();
    _missionFeaturesController.dispose();
    _missionImageController.dispose();
    _sparePartsTitleController.dispose();
    _sparePartsDescController.dispose();
    _sparePartsBenefitsController.dispose();
    _sparePartsImageController.dispose();
    _serviceCenterTitleController.dispose();
    _serviceCenterDescController.dispose();
    _serviceCenterBenefitsController.dispose();
    _serviceCenterImageController.dispose();
    _optionsLabelController.dispose();
    _optionsTitleController.dispose();
    _whyPartnerLabelController.dispose();
    _whyPartnerTitleController.dispose();
    _whyPartnerDescController.dispose();
    _stat1ValueController.dispose();
    _stat1LabelController.dispose();
    _stat2ValueController.dispose();
    _stat2LabelController.dispose();
    _stat3ValueController.dispose();
    _stat3LabelController.dispose();
    _stat4ValueController.dispose();
    _stat4LabelController.dispose();
    super.dispose();
  }

  Future<void> _loadContent() async {
    try {
      final data = await _apiService.getPageContent('franchise');
      final content = data['content'] ?? {};
      
      setState(() {
        String getVal(dynamic val, String fallback) => (val == null || val.toString().isEmpty) ? fallback : val.toString();

        // Hero
        _heroTaglineController.text = getVal(content['heroTagline'], 'BE THE PART OF');
        _heroTitleController.text = getVal(content['heroTitle'], 'FIXXEV Franchise');
        _heroSubtitleController.text = getVal(content['heroSubtitle'], 'Join India\'s fastest-growing EV service ecosystem. Partner with us as a Spare Parts Dealer or Service Center and be at the forefront of the electric mobility revolution.');
        _heroImageController.text = getVal(content['heroImage'], 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=1600');
        
        // Mission
        _missionLabelController.text = getVal(content['missionLabel'], '// OUR MISSION');
        _missionTitleController.text = getVal(content['missionTitle'], 'What We Are Doing');
        _missionDescController.text = getVal(content['missionDesc'], 'FIXXEV is building India\'s most comprehensive EV after-sales service network. We provide:');
        _missionFeaturesController.text = getVal(content['missionFeatures'], 'Multi-brand EV servicing and repairs\nGenuine spare parts distribution\nBattery diagnostics and refurbishment\n24/7 roadside assistance network\nPan-India service coverage');
        _missionImageController.text = getVal(content['missionImage'], 'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=800');
        
        // Spare Parts
        _sparePartsTitleController.text = getVal(content['sparePartsTitle'], 'Spare Parts Dealer');
        _sparePartsDescController.text = getVal(content['sparePartsDesc'], 'Become an authorized FIXXEV spare parts distributor. Access our extensive inventory of genuine EV components.');
        _sparePartsBenefitsController.text = getVal(content['sparePartsBenefits'], 'Direct OEM partnerships\nCompetitive wholesale pricing\nInventory management support\nMarketing & branding assistance\nTraining on EV components');
        _sparePartsImageController.text = getVal(content['sparePartsImage'], 'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?w=800');
        
        // Service Center
        _serviceCenterTitleController.text = getVal(content['serviceCenterTitle'], 'Service Center Dealer');
        _serviceCenterDescController.text = getVal(content['serviceCenterDesc'], 'Open an authorized FIXXEV service center. Get complete setup support and technical training.');
        _serviceCenterBenefitsController.text = getVal(content['serviceCenterBenefits'], 'Complete center setup support\nAIOT diagnostic tools access\nCertified technician training\nLead generation support\nFleet management contracts');
        _serviceCenterImageController.text = getVal(content['serviceCenterImage'], 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800');
        
        // Options Header
        _optionsLabelController.text = getVal(content['optionsLabel'], '// FRANCHISE OPTIONS');
        _optionsTitleController.text = getVal(content['optionsTitle'], 'Choose Your Partnership Model');

        // Why Partner
        _whyPartnerLabelController.text = getVal(content['whyPartnerLabel'], '// WHY CHOOSE US');
        _whyPartnerTitleController.text = getVal(content['whyPartnerTitle'], 'Why Partner With FIXXEV?');
        _whyPartnerDescController.text = getVal(content['whyPartnerDesc'], 'FIXXEV is backed by industry veterans with over 20 years of experience in the EV space. Our partners get access to cutting-edge technology, comprehensive training, and continuous support to build a successful business.');
        
        // Stats
        _stat1ValueController.text = getVal(content['stat1Value'], '20+');
        _stat1LabelController.text = getVal(content['stat1Label'], 'Years Combined Experience');
        _stat2ValueController.text = getVal(content['stat2Value'], '50+');
        _stat2LabelController.text = getVal(content['stat2Label'], 'Cities Covered');
        _stat3ValueController.text = getVal(content['stat3Value'], '5000+');
        _stat3LabelController.text = getVal(content['stat3Label'], 'Happy Customers');
        _stat4ValueController.text = getVal(content['stat4Value'], '24/7');
        _stat4LabelController.text = getVal(content['stat4Label'], 'Support Available');

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
        'heroTagline': _heroTaglineController.text,
        'heroTitle': _heroTitleController.text,
        'heroSubtitle': _heroSubtitleController.text,
        'heroImage': _heroImageController.text,
        'missionLabel': _missionLabelController.text,
        'missionTitle': _missionTitleController.text,
        'missionDesc': _missionDescController.text,
        'missionFeatures': _missionFeaturesController.text,
        'missionImage': _missionImageController.text,
        'sparePartsTitle': _sparePartsTitleController.text,
        'sparePartsDesc': _sparePartsDescController.text,
        'sparePartsBenefits': _sparePartsBenefitsController.text,
        'sparePartsImage': _sparePartsImageController.text,
        'serviceCenterTitle': _serviceCenterTitleController.text,
        'serviceCenterDesc': _serviceCenterDescController.text,
        'serviceCenterBenefits': _serviceCenterBenefitsController.text,
        'serviceCenterImage': _serviceCenterImageController.text,
        'optionsLabel': _optionsLabelController.text,
        'optionsTitle': _optionsTitleController.text,
        'whyPartnerLabel': _whyPartnerLabelController.text,
        'whyPartnerTitle': _whyPartnerTitleController.text,
        'whyPartnerDesc': _whyPartnerDescController.text,
        'stat1Value': _stat1ValueController.text,
        'stat1Label': _stat1LabelController.text,
        'stat2Value': _stat2ValueController.text,
        'stat2Label': _stat2LabelController.text,
        'stat3Value': _stat3ValueController.text,
        'stat3Label': _stat3LabelController.text,
        'stat4Value': _stat4ValueController.text,
        'stat4Label': _stat4LabelController.text,
      };
      
      await _apiService.updatePageContent('franchise', content);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Franchise page updated!')));
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
      final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false, withData: true);
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uploading image...')));
          final url = await _apiService.uploadImage(file.bytes!, file.name);
          setState(() => controller.text = url);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image uploaded successfully!')));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Edit Franchise', style: AppTextStyles.heading3),
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
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    if (!isMobile) _buildHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(isMobile ? 16 : 32),
                        child: Column(
                          children: [
                            _buildHeroSection(isMobile),
                            const SizedBox(height: 32),
                            _buildMissionSection(isMobile),
                            const SizedBox(height: 32),
                            _buildOptionsHeaderSection(),
                            const SizedBox(height: 16),
                            _buildSparePartsSection(isMobile),
                            const SizedBox(height: 32),
                            _buildServiceCenterSection(isMobile),
                            const SizedBox(height: 32),
                            _buildWhySection(),
                            const SizedBox(height: 32),
                            _buildStatsSection(isMobile),
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
              Text('Edit Franchise Page', style: AppTextStyles.heading2),
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

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, bool isImage = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label.copyWith(color: AppColors.textGrey, fontSize: 12)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.sidebarDark,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            suffixIcon: isImage ? IconButton(icon: const Icon(Icons.upload_file, color: AppColors.accentBlue), onPressed: () => _pickAndUploadImage(controller)) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(TextEditingController controller, bool isMobile) {
    return Container(
      height: isMobile ? 180 : 120, 
      width: isMobile ? double.infinity : 200,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.sidebarDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: controller.text.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(controller.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)),
            )
          : const Icon(Icons.image_outlined, color: Colors.white24, size: 40),
    );
  }

  Widget _buildHeroSection(bool isMobile) {
    return _buildSectionCard(
      title: '1. Hero Section',
      icon: Icons.star_outline,
      children: [
        isMobile ? Column(
          children: [
            _buildImagePreview(_heroImageController, isMobile),
            const SizedBox(height: 16),
            _buildTextField('Hero Tagline', _heroTaglineController),
            const SizedBox(height: 12),
            _buildTextField('Background Image URL', _heroImageController, isImage: true),
          ],
        ) : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagePreview(_heroImageController, isMobile),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [
                  _buildTextField('Hero Tagline', _heroTaglineController),
                  const SizedBox(height: 12),
                  _buildTextField('Background Image URL', _heroImageController, isImage: true),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField('Hero Title', _heroTitleController),
        const SizedBox(height: 16),
        _buildTextField('Hero Subtitle', _heroSubtitleController, maxLines: 3),
      ],
    );
  }

  Widget _buildMissionSection(bool isMobile) {
    return _buildSectionCard(
      title: '2. Our Mission Section',
      icon: Icons.lightbulb_outline,
      children: [
        isMobile ? Column(
          children: [
            _buildImagePreview(_missionImageController, isMobile),
            const SizedBox(height: 16),
            _buildTextField('Section Label', _missionLabelController),
            const SizedBox(height: 12),
            _buildTextField('Section Image URL', _missionImageController, isImage: true),
          ],
        ) : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagePreview(_missionImageController, isMobile),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [
                  _buildTextField('Section Label', _missionLabelController),
                  const SizedBox(height: 12),
                  _buildTextField('Section Image URL', _missionImageController, isImage: true),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField('Section Title', _missionTitleController),
        const SizedBox(height: 16),
        _buildTextField('Description', _missionDescController, maxLines: 2),
        const SizedBox(height: 16),
        _buildTextField('Features (One per line)', _missionFeaturesController, maxLines: 5),
      ],
    );
  }

  Widget _buildOptionsHeaderSection() {
    return _buildSectionCard(
      title: '3. Franchise Options Header',
      icon: Icons.title,
      children: [
        _buildTextField('Section Label', _optionsLabelController),
        const SizedBox(height: 16),
        _buildTextField('Section Title', _optionsTitleController),
      ],
    );
  }

  Widget _buildSparePartsSection(bool isMobile) {
    return _buildSectionCard(
      title: '4. Spare Parts Dealer Card',
      icon: Icons.inventory_2_outlined,
      children: [
        isMobile ? Column(
          children: [
            _buildImagePreview(_sparePartsImageController, isMobile),
            const SizedBox(height: 16),
            _buildTextField('Card Image URL', _sparePartsImageController, isImage: true),
          ],
        ) : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagePreview(_sparePartsImageController, isMobile),
            const SizedBox(width: 24),
            Expanded(
              child: _buildTextField('Card Image URL', _sparePartsImageController, isImage: true),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField('Card Title', _sparePartsTitleController),
        const SizedBox(height: 16),
        _buildTextField('Description', _sparePartsDescController, maxLines: 3),
        const SizedBox(height: 16),
        _buildTextField('Key Benefits (One per line)', _sparePartsBenefitsController, maxLines: 5),
      ],
    );
  }

  Widget _buildServiceCenterSection(bool isMobile) {
    return _buildSectionCard(
      title: '5. Service Center Dealer Card',
      icon: Icons.build_circle_outlined,
      children: [
        isMobile ? Column(
          children: [
            _buildImagePreview(_serviceCenterImageController, isMobile),
            const SizedBox(height: 16),
            _buildTextField('Card Image URL', _serviceCenterImageController, isImage: true),
          ],
        ) : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagePreview(_serviceCenterImageController, isMobile),
            const SizedBox(width: 24),
            Expanded(
              child: _buildTextField('Card Image URL', _serviceCenterImageController, isImage: true),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField('Card Title', _serviceCenterTitleController),
        const SizedBox(height: 16),
        _buildTextField('Description', _serviceCenterDescController, maxLines: 3),
        const SizedBox(height: 16),
        _buildTextField('Key Benefits (One per line)', _serviceCenterBenefitsController, maxLines: 5),
      ],
    );
  }

  Widget _buildWhySection() {
    return _buildSectionCard(
      title: '6. What We Do Section',
      icon: Icons.handshake_outlined,
      children: [
        _buildTextField('Section Label', _whyPartnerLabelController),
        const SizedBox(height: 16),
        _buildTextField('Section Title', _whyPartnerTitleController),
        const SizedBox(height: 16),
        _buildTextField('Description', _whyPartnerDescController, maxLines: 4),
      ],
    );
  }

  Widget _buildStatsSection(bool isMobile) {
    return _buildSectionCard(
      title: '7. Statistics Bar',
      icon: Icons.bar_chart,
      children: [
        isMobile ? Column(
          children: [
            _buildStatPair(_stat1ValueController, _stat1LabelController),
            const SizedBox(height: 12),
            _buildStatPair(_stat2ValueController, _stat2LabelController),
            const SizedBox(height: 12),
            _buildStatPair(_stat3ValueController, _stat3LabelController),
            const SizedBox(height: 12),
            _buildStatPair(_stat4ValueController, _stat4LabelController),
          ],
        ) : Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildTextField('Stat 1 Value', _stat1ValueController)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField('Stat 1 Label', _stat1LabelController)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextField('Stat 2 Value', _stat2ValueController)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField('Stat 2 Label', _stat2LabelController)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextField('Stat 3 Value', _stat3ValueController)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField('Stat 3 Label', _stat3LabelController)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextField('Stat 4 Value', _stat4ValueController)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField('Stat 4 Label', _stat4LabelController)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatPair(TextEditingController val, TextEditingController lab) {
    return Row(
      children: [
        Expanded(child: _buildTextField('Value', val)),
        const SizedBox(width: 12),
        Expanded(child: _buildTextField('Label', lab)),
      ],
    );
  }
}
