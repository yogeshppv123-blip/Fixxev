import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/footer_widget.dart';
import '../../widgets/floating_connect_buttons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/buttons/primary_button.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/api_service.dart';

class CKDealershipScreen extends StatefulWidget {
  const CKDealershipScreen({super.key});

  @override
  State<CKDealershipScreen> createState() => _CKDealershipScreenState();
}

class _CKDealershipScreenState extends State<CKDealershipScreen> {
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();
  bool _isScrolled = false;
  Map<String, dynamic> _content = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final data = await _apiService.getPageContent('franchise');
      if (mounted) {
        setState(() {
          _content = data;
        });
      }
    } catch (e) {
      debugPrint('Error loading franchise content: $e');
    }
  }

  void _onScroll() {
    final isScrolled = _scrollController.offset > 50;
    if (isScrolled != _isScrolled) {
      setState(() => _isScrolled = isScrolled);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MobileDrawer(),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // 1. Hero Section
                _FranchiseHero(content: _content),

                // 2. What We Are Doing
                _WhatWeDoSection(content: _content),

                // 3. Franchise Options (Cards)
                _FranchiseOptionsSection(content: _content),

                // 4. Why Partner With Us
                _WhyPartnerSection(content: _content),

                // 5. Inquiry Form
                const _InquiryFormSection(),

                const FooterWidget(),
              ],
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomAppBar(
              isTransparent: !_isScrolled,
              backgroundColor: _isScrolled ? AppColors.navDark : null,
              useLightText: true,
              onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              onContactPressed: () {},
            ),
          ),

          FloatingConnectButtons(scrollController: _scrollController),
        ],
      ),
    );
  }
}

// 1. Hero Section
class _FranchiseHero extends StatelessWidget {
  final Map<String, dynamic> content;
  const _FranchiseHero({required this.content});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 120,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryNavy, Color(0xFF1B3A5C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        image: DecorationImage(
          image: (content['heroImage'] != null && content['heroImage'].toString().isNotEmpty)
              ? NetworkImage(content['heroImage'])
              : const NetworkImage('https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=1600') as ImageProvider,
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Text(
            content['heroTagline'] ?? 'BE THE PART OF',
            style: AppTextStyles.sectionLabel.copyWith(
              color: AppColors.accentTeal,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            content['heroTitle'] ?? 'FIXXEV Franchise',
            style: AppTextStyles.heroTitle.copyWith(
              fontSize: isMobile ? 42 : 64,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              content['heroSubtitle'] ?? 'Join India\'s fastest-growing EV service ecosystem. Partner with us as a Spare Parts Dealer or Service Center and be at the forefront of the electric mobility revolution.',
              style: AppTextStyles.heroSubtitle.copyWith(
                fontSize: 18,
                color: Colors.white.withOpacity(0.85),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          PrimaryButton(
            text: 'BECOME A PARTNER',
            onPressed: () => context.go('/contact'),
            icon: Icons.handshake_outlined,
          ),
        ],
      ),
    );
  }
}

// 2. What We Are Doing Section
class _WhatWeDoSection extends StatelessWidget {
  final Map<String, dynamic> content;
  const _WhatWeDoSection({required this.content});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    
    // Parse features from multiline/comma string
    String featuresStr = content['missionFeatures'] ?? 'Multi-brand EV servicing and repairs\nGenuine spare parts distribution\nBattery diagnostics and refurbishment\n24/7 roadside assistance network\nPan-India service coverage';
    List<String> features = featuresStr.split(RegExp(r'[\n,]')).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: isMobile ? 24 : 80,
      ),
      color: Colors.white,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isMobile
              ? Column(
                  children: [
                    _buildImage(content['missionImage']),
                    const SizedBox(height: 40),
                    _buildContent(isMobile, features),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildImage(content['missionImage'])),
                    const SizedBox(width: 80),
                    Expanded(child: _buildContent(isMobile, features)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: (imageUrl != null && imageUrl.isNotEmpty)
              ? (imageUrl.startsWith('http') ? NetworkImage(imageUrl) : AssetImage(imageUrl) as ImageProvider)
              : const AssetImage('assets/images/franchise_mission.png'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isMobile, List<String> features) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content['missionLabel'] ?? '// OUR MISSION',
          style: AppTextStyles.sectionLabel.copyWith(
            color: AppColors.accentBlue,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          content['missionTitle'] ?? 'What We Are Doing',
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: isMobile ? 32 : 40,
          ),
        ),
        const SizedBox(height: 8),
        Container(width: 50, height: 4, color: AppColors.accentBlue),
        const SizedBox(height: 24),
        Text(
          content['missionDesc'] ?? 'FIXXEV is building India\'s most comprehensive EV after-sales service network. We provide:',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textGrey,
            height: 1.7,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 24),
        ...features.map((feature) => _buildFeatureItem(Icons.check_circle_outline, feature)),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accentTeal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.accentTeal, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 3. Franchise Options Section
class _FranchiseOptionsSection extends StatelessWidget {
  final Map<String, dynamic> content;
  const _FranchiseOptionsSection({required this.content});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: isMobile ? 24 : 80,
      ),
      color: AppColors.backgroundLight,
      child: Column(
        children: [
          Text(
            content['optionsLabel'] ?? '// FRANCHISE OPTIONS',
            style: AppTextStyles.sectionLabel.copyWith(
              color: AppColors.accentBlue,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            content['optionsTitle'] ?? 'Choose Your Partnership Model',
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: isMobile ? 28 : 36,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          _buildStaticCards(context, isMobile),
        ],
      ),
    );
  }


  Widget _buildStaticCards(BuildContext context, bool isMobile) {
    // Fallback to old static content
    String sparePartsBenefitsStr = content['sparePartsBenefits'] ?? 'Direct OEM partnerships\nCompetitive wholesale pricing\nInventory management support\nMarketing & branding assistance\nTraining on EV components';
    List<String> sparePartsBenefits = sparePartsBenefitsStr.split(RegExp(r'[\n,]')).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    
    String serviceCenterBenefitsStr = content['serviceCenterBenefits'] ?? 'Complete center setup support\nAIOT diagnostic tools access\nCertified technician training\nLead generation support\nFleet management contracts';
    List<String> serviceCenterBenefits = serviceCenterBenefitsStr.split(RegExp(r'[\n,]')).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    if (isMobile) {
      return Column(
        children: [
          _buildFranchiseCard(
            context,
            title: content['sparePartsTitle'] ?? 'Spare Parts Dealer',
            description: content['sparePartsDesc'] ?? 'Become an authorized FIXXEV spare parts distributor.',
            imageUrl: content['sparePartsImage'] ?? 'assets/images/franchise_parts.png',
            benefits: sparePartsBenefits,
            icon: Icons.inventory_2,
          ),
          const SizedBox(height: 40),
          _buildFranchiseCard(
            context,
            title: content['serviceCenterTitle'] ?? 'Service Center Dealer',
            description: content['serviceCenterDesc'] ?? 'Open an authorized FIXXEV service center.',
            imageUrl: content['serviceCenterImage'] ?? 'assets/images/franchise_service.png',
            benefits: serviceCenterBenefits,
            icon: Icons.build_circle,
          ),
        ],
      );
    }
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildFranchiseCard(
            context,
            title: content['sparePartsTitle'] ?? 'Spare Parts Dealer',
            description: content['sparePartsDesc'] ?? 'Become an authorized FIXXEV spare parts distributor.',
            imageUrl: content['sparePartsImage'] ?? 'assets/images/franchise_parts.png',
            benefits: sparePartsBenefits,
            icon: Icons.inventory_2,
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: _buildFranchiseCard(
            context,
            title: content['serviceCenterTitle'] ?? 'Service Center Dealer',
            description: content['serviceCenterDesc'] ?? 'Open an authorized FIXXEV service center.',
            imageUrl: content['serviceCenterImage'] ?? 'assets/images/franchise_service.png',
            benefits: serviceCenterBenefits,
            icon: Icons.build_circle,
          ),
        ),
      ],
    );
  }

  Widget _buildFranchiseCard(
    BuildContext context, {
    required String title,
    required String description,
    required String imageUrl,
    required List<String> benefits,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 220,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageUrl.startsWith('http') ? NetworkImage(imageUrl) : AssetImage(imageUrl) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryNavy.withOpacity(0.7),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accentBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textGrey,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Key Benefits:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
                const SizedBox(height: 16),
                ...benefits.map((benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: AppColors.accentTeal, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              benefit,
                              style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'ENQUIRE NOW',
                    onPressed: () => context.go('/contact'),
                    icon: Icons.arrow_forward,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 4. Why Partner Section
class _WhyPartnerSection extends StatelessWidget {
  final Map<String, dynamic> content;
  const _WhyPartnerSection({required this.content});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: isMobile ? 24 : 80,
      ),
      color: AppColors.primaryNavy,
      child: Column(
        children: [
          Text(
            content['whyPartnerLabel'] ?? '// WHY CHOOSE US',
            style: AppTextStyles.sectionLabel.copyWith(
              color: AppColors.accentTeal,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            content['whyPartnerTitle'] ?? 'Why Partner With FIXXEV?',
            style: AppTextStyles.sectionTitleLight.copyWith(
              fontSize: isMobile ? 28 : 36,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _buildStatCard(content['stat1Value'] ?? '20+', content['stat1Label'] ?? 'Years Combined Experience'),
              _buildStatCard(content['stat2Value'] ?? '50+', content['stat2Label'] ?? 'Cities Covered'),
              _buildStatCard(content['stat3Value'] ?? '5000+', content['stat3Label'] ?? 'Happy Customers'),
              _buildStatCard(content['stat4Value'] ?? '24/7', content['stat4Label'] ?? 'Support Available'),
            ],
          ),
          const SizedBox(height: 60),
          Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Text(
              content['whyPartnerDesc'] ?? 'FIXXEV is backed by industry veterans with over 20 years of experience in the EV space. Our partners get access to cutting-edge technology, comprehensive training, and continuous support to build a successful business.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withOpacity(0.8),
                height: 1.7,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: 40,
              color: AppColors.accentTeal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// 5. Inquiry Form Section
class _InquiryFormSection extends StatefulWidget {
  const _InquiryFormSection();

  @override
  State<_InquiryFormSection> createState() => _InquiryFormSectionState();
}

class _InquiryFormSectionState extends State<_InquiryFormSection> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  String _selectedType = 'Spare Parts Dealer';
  bool _isSubmitting = false;
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _submitInquiry() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in Name and Phone')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final success = await _apiService.submitLead({
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'type': 'Franchise',
      'message': 'Franchise Inquiry: $_selectedType from ${_cityController.text}',
      'details': {
        'city': _cityController.text,
        'franchiseType': _selectedType,
      },
    });

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inquiry submitted successfully!')),
        );
        _nameController.clear();
        _phoneController.clear();
        _emailController.clear();
        _cityController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: isMobile ? 24 : 80,
      ),
      color: Colors.white,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentBlue.withOpacity(0.1),
                blurRadius: 40,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Start Your Franchise Journey',
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Fill in your details and we\'ll get back to you',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
              ),
              const SizedBox(height: 32),
              _buildTextField(_nameController, 'Full Name', Icons.person_outline),
              const SizedBox(height: 16),
              _buildTextField(_emailController, 'Email Address', Icons.email_outlined),
              const SizedBox(height: 16),
              _buildTextField(_phoneController, 'Phone Number', Icons.phone_outlined),
              const SizedBox(height: 16),
              _buildTextField(_cityController, 'City', Icons.location_city_outlined),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedType,
                    isExpanded: true,
                    items: ['Spare Parts Dealer', 'Service Center Dealer']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedType = value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: _isSubmitting ? 'SUBMITTING...' : 'SUBMIT INQUIRY',
                  onPressed: _isSubmitting ? null : _submitInquiry,
                  icon: Icons.send,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textMuted),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentBlue, width: 2),
        ),
      ),
    );
  }
}
