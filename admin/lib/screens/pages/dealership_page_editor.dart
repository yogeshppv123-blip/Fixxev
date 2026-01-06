import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';

class DealershipPageEditor extends StatefulWidget {
  const DealershipPageEditor({super.key});

  @override
  State<DealershipPageEditor> createState() => _DealershipPageEditorState();
}

class _DealershipPageEditorState extends State<DealershipPageEditor> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isSaving = false;

  // Hero Section
  final _heroTitleController = TextEditingController();
  final _heroSubtitleController = TextEditingController();

  // What We Do Section
  final _missionTitleController = TextEditingController();
  final _missionDescController = TextEditingController();
  final _missionFeaturesController = TextEditingController();

  // Spare Parts Dealer
  final _sparePartsTitleController = TextEditingController();
  final _sparePartsDescController = TextEditingController();
  final _sparePartsBenefitsController = TextEditingController();

  // Service Center Dealer
  final _serviceCenterTitleController = TextEditingController();
  final _serviceCenterDescController = TextEditingController();
  final _serviceCenterBenefitsController = TextEditingController();

  // Why Partner Section
  final _whyPartnerTitleController = TextEditingController();
  final _whyPartnerDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final data = await _apiService.getPageContent('franchise');
      final content = data['content'] ?? {};
      
      setState(() {
        // Hero
        _heroTitleController.text = content['heroTitle'] ?? 'FIXXEV Franchise';
        _heroSubtitleController.text = content['heroSubtitle'] ?? 'Join India\'s fastest-growing EV service ecosystem. Partner with us as a Spare Parts Dealer or Service Center.';
        
        // Mission
        _missionTitleController.text = content['missionTitle'] ?? 'What We Are Doing';
        _missionDescController.text = content['missionDesc'] ?? 'FIXXEV is building India\'s most comprehensive EV after-sales service network.';
        _missionFeaturesController.text = content['missionFeatures'] ?? 'Multi-brand EV servicing, Genuine spare parts distribution, Battery diagnostics, 24/7 roadside assistance, Pan-India coverage';
        
        // Spare Parts
        _sparePartsTitleController.text = content['sparePartsTitle'] ?? 'Spare Parts Dealer';
        _sparePartsDescController.text = content['sparePartsDesc'] ?? 'Become an authorized FIXXEV spare parts distributor. Access our extensive inventory of genuine EV components.';
        _sparePartsBenefitsController.text = content['sparePartsBenefits'] ?? 'Direct OEM partnerships, Competitive wholesale pricing, Inventory management support, Marketing assistance, Training on EV components';
        
        // Service Center
        _serviceCenterTitleController.text = content['serviceCenterTitle'] ?? 'Service Center Dealer';
        _serviceCenterDescController.text = content['serviceCenterDesc'] ?? 'Open an authorized FIXXEV service center. Get complete setup support and technical training.';
        _serviceCenterBenefitsController.text = content['serviceCenterBenefits'] ?? 'Complete center setup support, AIOT diagnostic tools, Certified technician training, Lead generation support, Fleet management contracts';
        
        // Why Partner
        _whyPartnerTitleController.text = content['whyPartnerTitle'] ?? 'Why Partner With FIXXEV?';
        _whyPartnerDescController.text = content['whyPartnerDesc'] ?? 'FIXXEV is backed by industry veterans with over 20 years of experience in the EV space.';
        
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
        'missionTitle': _missionTitleController.text,
        'missionDesc': _missionDescController.text,
        'missionFeatures': _missionFeaturesController.text,
        'sparePartsTitle': _sparePartsTitleController.text,
        'sparePartsDesc': _sparePartsDescController.text,
        'sparePartsBenefits': _sparePartsBenefitsController.text,
        'serviceCenterTitle': _serviceCenterTitleController.text,
        'serviceCenterDesc': _serviceCenterDescController.text,
        'serviceCenterBenefits': _serviceCenterBenefitsController.text,
        'whyPartnerTitle': _whyPartnerTitleController.text,
        'whyPartnerDesc': _whyPartnerDescController.text,
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
        title: Text('Edit Dealership Page', style: AppTextStyles.heading3),
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
                            // Hero Section
                            _buildSectionCard(
                              title: 'Hero Section',
                              icon: Icons.star_outline,
                              children: [
                                _buildTextField('Hero Title', _heroTitleController),
                                const SizedBox(height: 16),
                                _buildTextField('Hero Subtitle', _heroSubtitleController, maxLines: 3),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // What We Do Section
                            _buildSectionCard(
                              title: 'What We Are Doing Section',
                              icon: Icons.lightbulb_outline,
                              children: [
                                _buildTextField('Section Title', _missionTitleController),
                                const SizedBox(height: 16),
                                _buildTextField('Description', _missionDescController, maxLines: 3),
                                const SizedBox(height: 16),
                                _buildTextField('Features (Comma Separated)', _missionFeaturesController, maxLines: 3),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Spare Parts Dealer
                            _buildSectionCard(
                              title: 'Spare Parts Dealer Card',
                              icon: Icons.inventory_2_outlined,
                              children: [
                                _buildTextField('Card Title', _sparePartsTitleController),
                                const SizedBox(height: 16),
                                _buildTextField('Description', _sparePartsDescController, maxLines: 3),
                                const SizedBox(height: 16),
                                _buildTextField('Key Benefits (Comma Separated)', _sparePartsBenefitsController, maxLines: 3),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Service Center Dealer
                            _buildSectionCard(
                              title: 'Service Center Dealer Card',
                              icon: Icons.build_circle_outlined,
                              children: [
                                _buildTextField('Card Title', _serviceCenterTitleController),
                                const SizedBox(height: 16),
                                _buildTextField('Description', _serviceCenterDescController, maxLines: 3),
                                const SizedBox(height: 16),
                                _buildTextField('Key Benefits (Comma Separated)', _serviceCenterBenefitsController, maxLines: 3),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Why Partner Section
                            _buildSectionCard(
                              title: 'Why Partner Section',
                              icon: Icons.handshake_outlined,
                              children: [
                                _buildTextField('Section Title', _whyPartnerTitleController),
                                const SizedBox(height: 16),
                                _buildTextField('Description', _whyPartnerDescController, maxLines: 4),
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
