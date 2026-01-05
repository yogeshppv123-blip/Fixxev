import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:fixxev/widgets/custom_app_bar.dart';
import 'package:fixxev/widgets/footer_widget.dart';
import 'package:fixxev/widgets/buttons/primary_button.dart';
import 'package:fixxev/widgets/floating_connect_buttons.dart';
import 'package:fixxev/widgets/section_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fixxev/core/services/api_service.dart';

class CKDContainerScreen extends StatefulWidget {
  const CKDContainerScreen({super.key});

  @override
  State<CKDContainerScreen> createState() => _CKDContainerScreenState();
}

class _CKDContainerScreenState extends State<CKDContainerScreen> {
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _pageContentFuture;

  bool _isSubmitting = false;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();

  final _countryController = TextEditingController();
  final _stateController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageContentFuture = _loadAllContent();
  }

  Future<Map<String, dynamic>> _loadAllContent() async {
    final content = await _apiService.getPageContent('ckd-container');
    final features = await _apiService.getCKDFeatures();
    // Store features in content for easy access
    content['ckdFeatures'] = features.where((f) => f['isActive'] == true).toList();
    return content;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _descController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MobileDrawer(),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: _pageContentFuture,
            builder: (context, snapshot) {
              final content = snapshot.data ?? {};
              
              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // 1. Hero Section with Form
                    _HeroWithFormSection(
                      content: content,
                      nameController: _nameController,
                      phoneController: _phoneController,
                      emailController: _emailController,
                      cityController: _cityController,
                      isSubmitting: _isSubmitting,
                      onSubmit: _submitInquiry,
                    ),
                    
                    // 2. Join Community
                    _CommunitySection(content: content),
                    
                    // 3. Why Choose (Dark)
                    _WhyChooseDarkSection(content: content),
                    
                    // 4. CKD Features (Container Image)
                    _SmarterShowroomsSection(content: content),
                    
                    // 5. Scalable Future (Stacked Cards)
                    _ScalableFutureSection(content: content),
                    
                    // 6. Process (Dark Steps)
                    _ProcessDarkSection(content: content),
                    
                    // 7. Network Map (Map Left, Text Right)
                    _NetworkMapSection(content: content),
                    
                    // 8. Models Grid
                    _ModelsGridSection(content: content),
                    
                    // 9. Bottom CTA Form
                    _BottomFormSection(
                      nameController: _nameController,
                      countryController: _countryController,
                      emailController: _emailController,
                      stateController: _stateController,
                      phoneController: _phoneController,
                      cityController: _cityController,
                      descController: _descController,
                      isSubmitting: _isSubmitting,
                      isRed: content['ctaIsRed'] ?? false,
                      onSubmit: _submitInquiry,
                    ),
                    
                    const FooterWidget(),
                  ],
                ),
              );
            }
          ),
          
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomAppBar(
              isTransparent: false,
              backgroundColor: AppColors.navDark,
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
      'type': 'Quote',
      'message': 'CKD Container Inquiry from ${_cityController.text}',
      'details': {
        'city': _cityController.text,
        'state': _stateController.text,
        'country': _countryController.text,
        'description': _descController.text,
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
        _stateController.clear();
        _countryController.clear();
        _descController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit inquiry. Please try again.')),
        );
      }
    }
  }
}

// 1. Hero Section: Text Left, Form Right
class _HeroWithFormSection extends StatelessWidget {
  final Map<String, dynamic> content;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController cityController;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const _HeroWithFormSection({
    required this.content,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.cityController,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final heroImage = content['heroImage']?.toString() ?? '';
    final isRed = content['heroIsRed'] ?? false;
    
    return Container(
      padding: EdgeInsets.only(
        top: 140, // Space for navbar
        bottom: 80,
        left: isMobile ? 24 : 80,
        right: isMobile ? 24 : 80,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA), // Light greyish white
        image: DecorationImage(
          image: heroImage.isNotEmpty 
              ? NetworkImage(heroImage) 
              : const AssetImage('assets/images/c14_v2.png') as ImageProvider,
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isMobile
              ? Column(
                  children: [
                    _buildHeroText(),
                    const SizedBox(height: 40),
                    _buildHeroForm(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: _buildHeroText()),
                    const SizedBox(width: 60),
                    Expanded(flex: 4, child: _buildHeroForm()),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeroText() {
    final isRed = content['heroIsRed'] ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isRed ? Colors.redAccent : AppColors.accentTeal,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            content['heroTagline'] ?? 'START OR SCALE',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          content['heroTitle'] ?? 'Build Your Own EV Brand\nwith Fixx EV',
          style: AppTextStyles.heroTitle.copyWith(
            color: isRed ? Colors.redAccent : AppColors.primary, 
            fontSize: 48,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          content['heroSubtitle'] ?? 'At Fixx EV, we don’t just service electric vehicles — we help create EV brands.\n\nWith over 10 years of deep industry expertise in electric mobility, manufacturing, sourcing and after-sales, we enable entrepreneurs, dealers, fleet operators and startups to launch their own EV brand without the heavy risk and complexity of setting up everything alone.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textDark,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Get a Quote',
            style: AppTextStyles.cardTitle.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 24),
          _SimpleTextField(label: 'Name', controller: nameController),
          const SizedBox(height: 16),
          _SimpleTextField(label: 'Phone', controller: phoneController),
          const SizedBox(height: 16),
          _SimpleTextField(label: 'Email', controller: emailController),
          const SizedBox(height: 16),
          _SimpleTextField(label: 'City', controller: cityController),
          const SizedBox(height: 24),
          PrimaryButton(
            text: isSubmitting ? 'SUBMITTING...' : 'SUBMIT',
            backgroundColor: (content['heroIsRed'] ?? false) ? Colors.redAccent : null,
            onPressed: isSubmitting ? () {} : onSubmit,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

class _SimpleTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  const _SimpleTextField({required this.label, this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textGrey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            isDense: true,
          ),
        ),
      ],
    );
  }
}

// 2. Join Community: Text Left, Image Right
class _CommunitySection extends StatelessWidget {
  final Map<String, dynamic> content;
  const _CommunitySection({required this.content});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final isRed = content['joinIsRed'] ?? false;
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: isMobile ? 24 : 80,
      ),
      color: Colors.white,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content['communityTitle'] ?? 'CKD Import & Assembly\nSolutions',
                          style: AppTextStyles.sectionTitle.copyWith(fontSize: 42, color: isRed ? Colors.redAccent : AppColors.primary),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          content['communityDesc'] ?? 'Fixx EV offers complete CKD (Completely Knocked Down) import solutions for both low-speed and high speed electric scooters.',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (content['communityItems'] != null
                              ? (content['communityItems'] as String).split('\n').where((s) => s.trim().isNotEmpty).toList()
                              : ['Launch your own EV brand', 'Control product quality', 'Improve margins', 'Build long-term market presence'])
                              .map((item) => _buildBullet(item.trim())).toList(),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          content['communityConclusion'] ?? 'We handle everything — from factory sourcing in China to assembly, testing and go-to-market support in India.',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  ),
                  if (!isMobile) ...[
                    const SizedBox(width: 60),
                    Expanded(
                      flex: 6,
                      child: Container(
                        height: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: content['communityImage'] != null && content['communityImage'].toString().isNotEmpty
                                ? NetworkImage(content['communityImage'])
                                : const AssetImage('assets/images/fixx_community_v3.png') as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.accentTeal, size: 20),
          const SizedBox(width: 12),
          Text(text, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark)),
        ],
      ),
    );
  }
}

// 3. Why Choose: Dark Section
class _WhyChooseDarkSection extends StatelessWidget {
  final Map<String, dynamic> content;
  const _WhyChooseDarkSection({required this.content});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    
    final List<dynamic> ckdf = (content['ckdFeatures'] as List?) ?? [];
    final supportFeatures = ckdf.where((f) => f['category'] == 'Support' && f['isActive'] == true).toList();

    // Map to UI format
    final features = supportFeatures.isNotEmpty 
        ? supportFeatures.map((f) => {
            'title': f['title'] ?? '',
            'desc': f['description'] ?? '',
          }).toList()
        : [
      {
        'title': content['whyItem1Title'] ?? '🔹 Product Sourcing & Compatibility Testing',
        'desc': content['whyItem1Desc'] ?? 'We connect you with reliable, audited EV factories producing proven low-speed scooter platforms. Our team handles rigorous compatibility testing to ensure components meet Indian road conditions and user expectations before you commit to a brand launch.'
      },
      {
        'title': content['whyItem2Title'] ?? '🔹 CKD Import & Logistics Handling',
        'desc': content['whyItem2Desc'] ?? 'Our team manages the entire complex import chain, including factory coordination, professional CKD packing, export documentation, international shipping, and customs clearance. We ensure secure port-to-factory movement for your kits.'
      },
      {
        'title': content['whyItem3Title'] ?? '🔹 Local Assembly & Quality Assurance',
        'desc': content['whyItem3Desc'] ?? 'Fixx EV provides hands-on support for assembly line setup, technician training, and standard operating procedures (SOPs). We implement multi-stage quality inspections and rigorous testing to ensure every vehicle is market-ready and reliable.'
      },
      {
        'title': content['whyItem4Title'] ?? '🔹 Branding, Marketing & GTM Support',
        'desc': content['whyItem4Desc'] ?? 'We help you transform generic kits into a premium brand. This includes designing your brand identity, model-specific decals, Indianized packaging, and user manuals. Beyond product, we assist in market positioning and dealer strategies.'
      },
    ];

    return Container(
      color: AppColors.primary, // Electric Blue
      padding: EdgeInsets.symmetric(vertical: 65, horizontal: isMobile ? 24 : 80),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content['endToEndTitle'] ?? 'End-to-End EV Brand Launch Support',
                style: AppTextStyles.sectionTitleLight.copyWith(fontSize: 36),
              ),
              const SizedBox(height: 16),
              Text(
                content['endToEndDesc'] ?? 'When you partner with Fixx EV, you get a full-stack EV business solution:',
                style: AppTextStyles.bodyLarge.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 50),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = isMobile ? 1 : (constraints.maxWidth > 900 ? 2 : 1);
                  final itemWidth = (constraints.maxWidth - (crossAxisCount - 1) * 24) / crossAxisCount;
                  
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: isMobile ? 1.6 : (constraints.maxWidth > 1000 ? 2.5 : 2.1),
                    ),
                    itemCount: features.length,
                    itemBuilder: (context, index) {
                      final f = features[index];
                      return Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.15)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              f['title']!, 
                              style: AppTextStyles.cardTitle.copyWith(
                                color: Colors.white, 
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: Text(
                                f['desc']!, 
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white.withOpacity(0.85), 
                                  height: 1.6,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. CKD Features: Text Left, Container Image Right
class _SmarterShowroomsSection extends StatelessWidget {
  final Map<String, dynamic> content;
  const _SmarterShowroomsSection({required this.content});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final isRed = content['smarterIsRed'] ?? false;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 100, horizontal: isMobile ? 24 : 80),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.sectionTitle.copyWith(fontSize: 36, height: 1.2, color: isRed ? Colors.redAccent : AppColors.primary),
                        children: [
                          TextSpan(text: content['smarterTitle'] ?? 'Sales, Service & Spare Parts Support'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      content['smarterDesc'] ?? 'Launching a brand is not just about selling — it’s about supporting customers after sale.\n\nThrough Fixx EV’s nationwide EV Service Centres and India’s largest EV spares network, your brand gets:',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey, height: 1.6),
                    ),
                    const SizedBox(height: 24),
                    // Dynamic Checklist
                    ...(content['smarterItems'] != null 
                        ? (content['smarterItems'] as String).split('\n')
                        : [
                            'Service infrastructure',
                            'Genuine spare parts',
                            'Trained technicians',
                            'Warranty support',
                            'Nationwide coverage'
                          ]).where((item) => item.trim().isNotEmpty).map((item) => _CheckList(text: item.trim(), boldText: '', isRed: isRed)),
                    
                    const SizedBox(height: 24),
                    Text(
                      'This gives your brand instant credibility and trust in the market.',
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textDark, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 60),
                Expanded(
                  flex: 5,
                  child: Container(
                    height: 500,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: content['smarterImage'] != null && content['smarterImage'].toString().isNotEmpty
                        ? Image.network(content['smarterImage'], fit: BoxFit.cover)
                        : Image.asset('assets/images/your_ev_brand_v3.png', fit: BoxFit.cover),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckList extends StatelessWidget {
  final String text;
  final String boldText;
  final bool isRed;
  
  const _CheckList({required this.text, required this.boldText, required this.isRed});
  
  @override
  Widget build(BuildContext context) {
    // Split text to bold specific parts if needed
    List<TextSpan> spans = [];
    if (boldText.isNotEmpty && text.contains(boldText)) {
      final parts = text.split(boldText);
      spans.add(TextSpan(text: parts[0]));
      spans.add(TextSpan(text: boldText, style: TextStyle(fontWeight: FontWeight.bold, color: isRed ? Colors.redAccent : AppColors.primaryNavy)));
      if (parts.length > 1) spans.add(TextSpan(text: parts[1]));
    } else {
      spans.add(TextSpan(text: text));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(Icons.check_circle, size: 20, color: AppColors.accentTeal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark),
                children: spans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ... existing code ...



// 5. Scalable Future: Image Left, Stacked Cards Right
class _ScalableFutureSection extends StatelessWidget {
  final Map<String, dynamic> content;
  const _ScalableFutureSection({required this.content});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final isRed = content['whyIsRed'] ?? false;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 100, horizontal: isMobile ? 24 : 80),
      color: Colors.white,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            children: [
              if (!isMobile)
                Expanded(
                  flex: 5,
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: content['whyImage'] != null && content['whyImage'].toString().isNotEmpty
                            ? NetworkImage(content['whyImage'])
                            : const AssetImage('assets/images/why_fixx_ev_v3.png') as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 60),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content['whyFixxTitle'] ?? 'Why Fixx EV?',
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 36, color: isRed ? Colors.redAccent : AppColors.primary),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      content['whyFixxSubtitle'] ?? 'With 10+ years of EV industry experience, Fixx EV has worked across:',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: (content['whyFixxChips'] != null
                          ? (content['whyFixxChips'] as String).split('\n').where((s) => s.trim().isNotEmpty).toList()
                          : ['Manufacturing', 'Import & sourcing', 'Sales & distribution', 'Service & spare parts', 'Fleet operations'])
                          .map((chip) => _Chip(chip.trim())).toList(),
                    ),
                    const SizedBox(height: 32),
                     Text(
                      content['whyFixxConclusion'] ?? 'We know what works — and what fails — in the Indian EV market.',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(content['missionLabel'] ?? 'OUR MISSION', style: AppTextStyles.bodySmall.copyWith(color: isRed ? Colors.redAccent : AppColors.accentTeal, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(
                            content['missionText'] ?? 'Help 100s of entrepreneurs build profitable, sustainable EV brands — without burning money or time.',
                            style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textDark)),
    );
  }
}

class _StackedCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const _StackedCard({required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.cardTitle.copyWith(color: Colors.white, fontSize: 18)),
          Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
        ],
      ),
    );
  }
}

// 6. Process: Dark Steps
class _ProcessDarkSection extends StatelessWidget {
  final Map<String, dynamic> content;
  const _ProcessDarkSection({required this.content});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.symmetric(vertical: 65, horizontal: isMobile ? 24 : 80),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content['processTitle'] ?? 'From Import to Indian Roads — We Make It Simple',
                style: AppTextStyles.sectionTitleLight.copyWith(fontSize: 36),
              ),
              const SizedBox(height: 16),
              Text(
                content['processDesc'] ?? 'Fixx EV helps you go from factory to showroom to customer with one trusted partner, whether you are:',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 50),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = isMobile ? 1 : (constraints.maxWidth > 900 ? 4 : 2);
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: isMobile ? 1.7 : (constraints.maxWidth > 1000 ? 1.05 : 0.85),
                    children: [
                      _DarkStep(
                        num: '01', 
                        title: content['step1Title'] ?? 'Contact Us', 
                        desc: content['step1Desc'] ?? 'Get in touch with our team to discuss your EV business goals. We provide initial consulting on market trends, sourcing needs, and capital planning to ensure your business starts on the right path.'
                      ),
                      _DarkStep(
                        num: '02', 
                        title: content['step2Title'] ?? 'Share Requirements', 
                        desc: content['step2Desc'] ?? 'Tell us about your target market, preferred vehicle types, and expected volume. We evaluate your requirements to create a customized CKD solution that fits your regional demand and technical specs.'
                      ),
                      _DarkStep(
                        num: '03', 
                        title: content['step3Title'] ?? 'Order Placement', 
                        desc: content['step3Desc'] ?? 'Once the strategy is finalized, you place your orders through our secure portal. We coordinate with factory partners for component production and manage all export-import documentation for your team.'
                      ),
                      _DarkStep(
                        num: '04', 
                        title: content['step4Title'] ?? 'Delivery Support', 
                        desc: content['step4Desc'] ?? 'We deliver your CKD containers on time to your facility. Our support doesn\'t end there—we provide assembly guidance, quality audit checklists, and logistics support to get your new EV brand moving.'
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 60),
              Center(
                child: Column(
                  children: [
                    Text(
                      content['processTagline'] ?? 'Fixx EV — Your EV Brand, Built Right',
                      style: AppTextStyles.heading2.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      content['processSlogan'] ?? 'Import. Assemble. Brand. Sell. Service.',
                      style: AppTextStyles.bodyLarge.copyWith(color: (content['ctaIsRed'] ?? false) ? Colors.redAccent : AppColors.accentTeal, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      content['processCta'] ?? 'We do it all — so you can focus on growing your business.',
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DarkStep extends StatelessWidget {
  final String num;
  final String title;
  final String desc;

  const _DarkStep({required this.num, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24), // Increased padding
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16), // Softer corners
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(num, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.accentTeal)),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyles.cardTitle.copyWith(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              desc, 
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.8), height: 1.5),
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }
}

// 7. Network Map Section
class _NetworkMapSection extends StatelessWidget {
  final Map<String, dynamic> content;
  const _NetworkMapSection({required this.content});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    
    // Parse dynamic bullet points
    final bulletItems = content['networkItems'] != null
        ? (content['networkItems'] as String).split('\n').where((s) => s.trim().isNotEmpty).toList()
        : ['Exclusive territory rights', 'Faster installation timelines', 'Affordable infrastructure', 'Reliable supply and service support'];
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 100, horizontal: isMobile ? 24 : 80),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            children: [
              // Map Left - Using generic map image to match visual style requested
              Expanded(
                flex: 6,
                child: Container(
                  height: 450,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xFFE3F2FD), // Light blue background
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
                    image: const DecorationImage(
                      image: const NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/India_map_blank.svg/800px-India_map_blank.svg.png'),
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(child: _LeafletMapEmbed()),
                    ],
                  ),
                ),
              ),
              if (!isMobile) const SizedBox(width: 60),
              // Text Right
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content['networkTitle'] ?? 'We are reaching every corner of India',
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 36, color: AppColors.primaryNavy, height: 1.2),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      content['networkDesc'] ?? 'At Fixx EV, our vision is to make clean mobility accessible everywhere—not just in big cities. Through modular CKD container showrooms, we enable fast deployment, lower setup costs, and seamless expansion across India.',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey, height: 1.6),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      content['networkDesc2'] ?? 'From metros like Mumbai, Delhi, and Bengaluru, to fast-growing Tier-2 and Tier-3 cities, Fixx EV empowers entrepreneurs to build profitable EV businesses where demand is rising fastest.',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey, height: 1.6),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      content['networkBulletTitle'] ?? 'Our dealer-first model ensures every partner gets:',
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...bulletItems.map((item) => _BulletPoint(item)),
                    const SizedBox(height: 16),
                    Text(
                      content['networkConclusion'] ?? 'This PAN-India strategy gives dealers a powerful competitive edge, while customers benefit from quick service, better availability, and trusted EV solutions.',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey, height: 1.6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeafletMapEmbed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Exact Leaflet HTML/JS provided by user, wrapped in HTML structure
    const String leafletHtml = '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
        <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
        <style>
          body { margin: 0; padding: 0; }
          #indiaMap { height: 100vh; width: 100%; }
        </style>
      </head>
      <body>
        <div id="indiaMap"></div>
        <script>
          var map = L.map('indiaMap').setView([22.9734, 78.6569], 5);
          L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors'
          }).addTo(map);
          var cities = [
            { name: "New Delhi", lat: 28.6139, lng: 77.2090 },
            { name: "Mumbai", lat: 19.0760, lng: 72.8777 },
            { name: "Bangalore", lat: 12.9716, lng: 77.5946 },
            { name: "Hyderabad", lat: 17.3850, lng: 78.4867 },
            { name: "Chennai", lat: 13.0827, lng: 80.2707 },
            { name: "Kolkata", lat: 22.5726, lng: 88.3639 },
            { name: "Ahmedabad", lat: 23.0225, lng: 72.5714 },
            { name: "Pune", lat: 18.5204, lng: 73.8567 },
            { name: "Jaipur", lat: 26.9124, lng: 75.7873 },
            { name: "Lucknow", lat: 26.8467, lng: 80.9462 },
            { name: "Chandigarh", lat: 30.7333, lng: 76.7794 },
            { name: "Bhopal", lat: 23.2599, lng: 77.4126 }
          ];
          cities.forEach(function(city) {
            L.marker([city.lat, city.lng]).addTo(map).bindPopup("<b>" + city.name + "</b>");
          });
        </script>
      </body>
      </html>
    ''';

    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      'leaflet-map-embed',
      (int viewId) {
        final iframe = html.IFrameElement()
          ..style.border = 'none'
          ..style.height = '100%'
          ..style.width = '100%';
        iframe.srcdoc = leafletHtml;
        return iframe;
      },
    );

    return const HtmlElementView(viewType: 'leaflet-map-embed');
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.primaryNavy, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Text(text, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}



class _HighlightStat extends StatelessWidget {
  final String val;
  final String label;
  final bool isRed;
  const _HighlightStat(this.val, this.label, {this.isRed = false});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4, height: 40, color: AppColors.accentBlue,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(val, style: AppTextStyles.cardTitle.copyWith(fontSize: 24, color: isRed ? Colors.redAccent : AppColors.primaryNavy)),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        )
      ],
    );
  }
}

// 8. Models Grid Section
class _ModelsGridSection extends StatelessWidget {
  final Map<String, dynamic> content;
  const _ModelsGridSection({required this.content});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: isMobile ? 24 : 80),
      color: const Color(0xFFF9F9F9),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text('Our CKD Container Models', style: AppTextStyles.sectionTitle.copyWith(fontSize: 32)),
              const SizedBox(height: 50),
              isMobile ? 
              Column(
                children: [
                  _ModelCard(content['model1Image'] ?? 'assets/images/vector_x.png', content['model1Name'] ?? 'Vector X'),
                  const SizedBox(height: 24),
                  _ModelCard(content['model2Image'] ?? 'assets/images/urban_s.png', content['model2Name'] ?? 'Urban S'),
                  const SizedBox(height: 24),
                  _ModelCard(content['model3Image'] ?? 'assets/images/metro_glide.png', content['model3Name'] ?? 'Metro Glide'),
                ],
              ) :
              Row(
                children: [
                  Expanded(child: _ModelCard(content['model1Image'] ?? 'assets/images/vector_x.png', content['model1Name'] ?? 'Vector X')),
                  const SizedBox(width: 24),
                  Expanded(child: _ModelCard(content['model2Image'] ?? 'assets/images/urban_s.png', content['model2Name'] ?? 'Urban S')),
                  const SizedBox(width: 24),
                  Expanded(child: _ModelCard(content['model3Image'] ?? 'assets/images/metro_glide.png', content['model3Name'] ?? 'Metro Glide')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  final String img;
  final String name;
  const _ModelCard(this.img, this.name);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 300,
            width: double.infinity,
            color: Colors.grey[200],
            child: img.startsWith('assets')
                ? Image.asset(
                    img,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.broken_image, color: Colors.grey, size: 48),
                            const SizedBox(height: 8),
                            Text('Image not found\n$img', 
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey, fontSize: 10)
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Image.network(
                    img,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Text(name, style: AppTextStyles.cardTitle),
      ],
    );
  }
}

// 9. Bottom Form Section
class _BottomFormSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController countryController;
  final TextEditingController emailController;
  final TextEditingController stateController;
  final TextEditingController phoneController;
  final TextEditingController cityController;
  final TextEditingController descController;
  final bool isSubmitting;
  final bool isRed;
  final VoidCallback onSubmit;

  const _BottomFormSection({
    required this.nameController,
    required this.countryController,
    required this.emailController,
    required this.stateController,
    required this.phoneController,
    required this.cityController,
    required this.descController,
    required this.isSubmitting,
    required this.isRed,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 100, horizontal: isMobile ? 24 : 80),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Be part of India\'s electric future. Start your own EV journey with Fixx EV today.',
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 50),
              Wrap(
                spacing: 24, runSpacing: 24,
                children: [
                  SizedBox(width: 350, child: _SimpleTextField(label: 'Name', controller: nameController)),
                  SizedBox(width: 350, child: _SimpleTextField(label: 'Country', controller: countryController)),
                  SizedBox(width: 350, child: _SimpleTextField(label: 'Email', controller: emailController)),
                  SizedBox(width: 350, child: _SimpleTextField(label: 'State', controller: stateController)),
                  SizedBox(width: 350, child: _SimpleTextField(label: 'Phone', controller: phoneController)),
                  SizedBox(width: 350, child: _SimpleTextField(label: 'City', controller: cityController)),
                ],
              ),
              const SizedBox(height: 24),
              _SimpleTextField(label: 'Description', controller: descController),
              const SizedBox(height: 40),
              PrimaryButton(
                text: isSubmitting ? 'SUBMITTING...' : 'SUBMIT', 
                width: 200, 
                backgroundColor: isRed ? Colors.redAccent : null,
                onPressed: isSubmitting ? () {} : onSubmit
              ),
            ],
          ),
        ),
      ),
    );
  }
}
