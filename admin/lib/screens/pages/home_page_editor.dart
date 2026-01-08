import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:file_picker/file_picker.dart';

class HomePageEditor extends StatefulWidget {
  const HomePageEditor({super.key});

  @override
  State<HomePageEditor> createState() => _HomePageEditorState();
}

class _HomePageEditorState extends State<HomePageEditor> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isSaving = false;
  bool get isMobile => MediaQuery.of(context).size.width < 1100;

  // --- Hero Section ---
  final List<Map<String, TextEditingController>> _heroSlides = [];

  // --- Stats Bar (Horizontal) ---
  final _barStatControllers = List.generate(4, (_) => {
    'value': TextEditingController(),
    'label': TextEditingController(),
  });

  // --- What We Do (Innovation) ---
  final _wwdTaglineController = TextEditingController();
  final _wwdTitleController = TextEditingController();
  final _wwdCardControllers = List.generate(3, (_) => {
    'title': TextEditingController(),
    'desc': TextEditingController(),
  });

  // --- Services Section (6 Spares Cards) ---
  final _servicesTaglineController = TextEditingController();
  final _servicesTitleController = TextEditingController();
  final List<Map<String, TextEditingController>> _serviceCards = [];

  // --- Why Choose Us ---
  final _whyTitleController = TextEditingController();
  final _whyDescController = TextEditingController();
  final _whyBulletControllers = List.generate(4, (_) => {
    'title': TextEditingController(),
    'desc': TextEditingController(),
  });

  // --- Testimonials Section ---
  final _testimonialsTitleController = TextEditingController();
  final List<Map<String, TextEditingController>> _testimonialItems = [];

  // --- About Us ---
  final _aboutTaglineController = TextEditingController();
  final _aboutTitleController = TextEditingController();
  final _aboutDesc1Controller = TextEditingController();
  final _aboutDesc2Controller = TextEditingController();
  final _aboutImageController = TextEditingController();

  // --- Join Mission ---
  final _joinTitleController = TextEditingController();
  final _joinSubtitleController = TextEditingController();
  final _joinBgImageController = TextEditingController();
  final _joinCardControllers = List.generate(3, (_) => {
    'title': TextEditingController(),
  });

  // --- Partners Carousel ---
  final List<Map<String, TextEditingController>> _partnerLogos = [];

  // --- Brands We Serve ---
  final _brandsTitleController = TextEditingController();
  final List<Map<String, TextEditingController>> _brandItems = [];


  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  void _addHeroSlide({String? image, String? tagline, String? title, String? subtitle, String? btnText}) {
    setState(() {
      _heroSlides.add({
        'image': TextEditingController(text: image ?? ''),
        'tagline': TextEditingController(text: tagline ?? ''),
        'title': TextEditingController(text: title ?? ''),
        'subtitle': TextEditingController(text: subtitle ?? ''),
        'btnText': TextEditingController(text: btnText ?? ''),
      });
    });
  }

  void _addServiceCard({String? title, String? desc}) {
    setState(() {
      _serviceCards.add({
        'title': TextEditingController(text: title ?? ''),
        'desc': TextEditingController(text: desc ?? ''),
      });
    });
  }

  void _addTestimonial({String? name, String? role, String? content, String? rating, String? image}) {
    setState(() {
      _testimonialItems.add({
        'name': TextEditingController(text: name ?? ''),
        'role': TextEditingController(text: role ?? ''),
        'content': TextEditingController(text: content ?? ''),
        'rating': TextEditingController(text: rating ?? '5'),
        'image': TextEditingController(text: image ?? ''),
      });
    });
  }

  void _addPartnerLogo({String? name, String? image}) {
    setState(() {
      _partnerLogos.add({
        'name': TextEditingController(text: name ?? ''),
        'image': TextEditingController(text: image ?? ''),
      });
    });
  }

  void _addBrandItem({String? title, String? desc, String? image}) {
    setState(() {
      _brandItems.add({
        'title': TextEditingController(text: title ?? ''),
        'desc': TextEditingController(text: desc ?? ''),
        'image': TextEditingController(text: image ?? ''),
      });
    });
  }

  Future<void> _loadContent() async {
    try {
      final data = await _apiService.getPageContent('home');
      final content = data['content'] ?? {};

      setState(() {
        // 1. Hero Slides
        final slides = content['heroSlides'] as List?;
        _heroSlides.clear();
        if (slides != null && slides.isNotEmpty) {
          for (var s in slides) {
            _addHeroSlide(image: s['image'], tagline: s['tagline'], title: s['title'], subtitle: s['subtitle'], btnText: s['buttonText']);
          }
        } else {
          // Defaults if DB is empty
          _addHeroSlide(
            image: 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7',
            tagline: 'LAUNCH ANNOUNCEMENT',
            title: 'Driving India’s EV Future ⚡',
            subtitle: 'Fixx EV is solving the biggest barriers to electric vehicle adoption in India — reliable after-sales service and spares availability.',
            btnText: 'JOIN THE MISSION'
          );
          _addHeroSlide(
            image: 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e',
            tagline: 'SERVICE ECOSYSTEM',
            title: '500+ Authorized Service Centres',
            subtitle: 'We are building a nationwide, standardized EV after-sales network across key cities and towns in India.',
            btnText: 'FRANCHISE OPPORTUNITY'
          );
          _addHeroSlide(
            image: 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158',
            tagline: 'TECHNOLOGY BACKBONE',
            title: 'Seamless Ownership Experience',
            subtitle: 'Our mobile application connects EV owners to authorized service centres for bookings, diagnostics, and real-time support.',
            btnText: 'DOWNLOAD THE APP'
          );
        }

        // 2. Stats Bar (Horizontal)
        _barStatControllers[0]['value']!.text = content['barStat1Value'] ?? '5,000+';
        _barStatControllers[0]['label']!.text = content['barStat1Label'] ?? 'Service Centers';
        _barStatControllers[1]['value']!.text = content['barStat2Value'] ?? '500+';
        _barStatControllers[1]['label']!.text = content['barStat2Label'] ?? 'Partner Brands';
        _barStatControllers[2]['value']!.text = content['barStat3Value'] ?? '8k+';
        _barStatControllers[2]['label']!.text = content['barStat3Label'] ?? 'Happy Customers';
        _barStatControllers[3]['value']!.text = content['barStat4Value'] ?? '100%';
        _barStatControllers[3]['label']!.text = content['barStat4Label'] ?? 'Sustainability';

        // 3. What We Do
        _wwdTaglineController.text = content['wwdTagline'] ?? 'FRANCHISE-LED GROWTH';
        _wwdTitleController.text = content['wwdTitle'] ?? 'BUILDING INDIA’S LARGEST\nEV SERVICE NETWORK';
        _wwdCardControllers[0]['title']!.text = content['wwdCard1Title'] ?? '500+ SERVICE CENTRES';
        _wwdCardControllers[0]['desc']!.text = content['wwdCard1Desc'] ?? 'A pan-India network of 500+ EV service centres across key cities and towns.';
        _wwdCardControllers[1]['title']!.text = content['wwdCard2Title'] ?? 'CERTIFIED SPARES';
        _wwdCardControllers[1]['desc']!.text = content['wwdCard2Desc'] ?? 'Access to OEM-certified spares and standardized service processes nationwide.';
        _wwdCardControllers[2]['title']!.text = content['wwdCard3Title'] ?? 'SKILLED TECHNICIANS';
        _wwdCardControllers[2]['desc']!.text = content['wwdCard3Desc'] ?? 'Expertly trained technicians supported by Fixx EV for centralized quality control.';

        // 4. Services (6 cards)
        _servicesTaglineController.text = content['servicesTagline'] ?? '// GENUINE PARTS';
        _servicesTitleController.text = content['servicesTitle'] ?? 'COMPLETE RANGE OF\nEV SPARES & TOOLS';
        final sCards = content['serviceCards'] as List?;
        _serviceCards.clear();
        if (sCards != null && sCards.isNotEmpty) {
          for (var c in sCards) _addServiceCard(title: c['title'], desc: c['desc']);
        } else {
          _addServiceCard(title: 'Controllers & Chargers', desc: 'High-performance controllers for smooth acceleration and intelligent chargers for fast energy replenishment.');
          _addServiceCard(title: 'Motors & Parts', desc: 'Durable BLDC and PMSM motors designed for maximum torque and efficiency across all terrains.');
          _addServiceCard(title: 'Lithium Batteries', desc: 'Long-life lithium-ion battery packs with advanced BMS for safety and reliability.');
          _addServiceCard(title: 'Sensors & Wiring', desc: 'Precision throttle sensors, brake switches, and high-grade wiring harnesses for seamless connectivity.');
          _addServiceCard(title: 'Tyres & Body Parts', desc: 'Rugged tyres for Indian roads and premium body panels for L3 and L5 vehicles.');
          _addServiceCard(title: 'Consumables & Tools', desc: 'Professional-grade service tools, lubricants, and essential consumables for EV workshops.');
        }

        // 5. Why Choose Us
        _whyTitleController.text = content['whyTitle'] ?? 'Why Choose Us';
        _whyDescController.text = content['whyDesc'] ?? 'At FIXXEV, we provide an ecosystem that ensures your electric vehicle remains in peak condition.';
        _whyBulletControllers[0]['title']!.text = content['whyBullet1Title'] ?? 'Commitment To Sustainability';
        _whyBulletControllers[0]['desc']!.text = content['whyBullet1Desc'] ?? 'Expanding high-quality EV support to accelerate green mobility.';
        _whyBulletControllers[1]['title']!.text = content['whyBullet2Title'] ?? 'Advanced Diagnostics';
        _whyBulletControllers[1]['desc']!.text = content['whyBullet2Desc'] ?? 'Using next-gen tools to ensure precise and efficient repairs.';
        _whyBulletControllers[2]['title']!.text = content['whyBullet3Title'] ?? 'Skilled Technician Support';
        _whyBulletControllers[2]['desc']!.text = content['whyBullet3Desc'] ?? 'Professionally trained experts dedicated to EV longevity.';
        _whyBulletControllers[3]['title']!.text = content['whyBullet4Title'] ?? 'Quality Controlled Spares';
        _whyBulletControllers[3]['desc']!.text = content['whyBullet4Desc'] ?? 'OEM-certified components for reliable and safe performance.';

        // 6. Testimonials
        _testimonialsTitleController.text = content['testimonialsTitle'] ?? 'WHAT OUR CLIENTS SAY\nABOUT OUR SERVICES';
        final tItems = content['testimonials'] as List?;
        _testimonialItems.clear();
        if (tItems != null && tItems.isNotEmpty) {
          for (var t in tItems) _addTestimonial(name: t['name'], role: t['role'], content: t['content'], rating: t['rating']?.toString(), image: t['image']);
        } else {
          _addTestimonial(name: 'Rahul Sharma', role: 'Tesla Owner', content: 'The AIOT diagnostics at FIXXEV saved me from a major battery failure.', rating: '5', image: '');
          _addTestimonial(name: 'Ananya Patel', role: 'Nexon EV User', content: 'Top-notch service! The technicians really know their way around electric vehicles.', rating: '5', image: '');
          _addTestimonial(name: 'Vikram Singh', role: 'Fleet Manager', content: 'Our proactive support has increased our vehicle uptime by 40%.', rating: '5', image: '');
        }

        // 7. About Us
        _aboutTaglineController.text = content['aboutTagline'] ?? 'ANNOUNCING MISSION 500';
        _aboutTitleController.text = content['aboutTitle'] ?? 'SOLVING INDIA’S EV AFTER-SALES GAP';
        _aboutDesc1Controller.text = content['aboutDesc1'] ?? 'Fixx EV Technologies Pvt. Ltd. is on a mission to solve one of the biggest barriers to electric vehicle adoption in India.';
        _aboutDesc2Controller.text = content['aboutDesc2'] ?? 'We are building a nationwide, standardized EV after-sales network.';
        _aboutImageController.text = content['aboutImage'] ?? 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158';

        // 8. Join Mission
        _joinTitleController.text = content['joinTitle'] ?? 'Join The Mission';
        _joinSubtitleController.text = content['joinSubtitle'] ?? 'Partner with us to transform the EV spares & service landscape.';
        _joinBgImageController.text = content['joinBgImage'] ?? 'https://images.unsplash.com/photo-1531983412531-1f49a365ffed';
        _joinCardControllers[0]['title']!.text = content['joinCard1Title'] ?? 'Strategic Investors';
        _joinCardControllers[1]['title']!.text = content['joinCard2Title'] ?? 'Franchisees';
        _joinCardControllers[2]['title']!.text = content['joinCard3Title'] ?? 'Franchise Partners';

        // 7. Partners
        final partners = content['partnerLogos'] as List?;
        _partnerLogos.clear();
        if (partners != null && partners.isNotEmpty) {
          for (var p in partners) _addPartnerLogo(name: p['name'], image: p['image']);
        } else {
          _addPartnerLogo(name: 'EV CORE', image: '');
          _addPartnerLogo(name: 'BATTERIX', image: '');
        }

        // 8. Brands We Serve
        _brandsTitleController.text = content['brandsTitle'] ?? 'BRANDS WE SERVE';
        final brands = content['brandsCards'] as List?;
        _brandItems.clear();
        if (brands != null && brands.isNotEmpty) {
          for (var b in brands) _addBrandItem(title: b['title'], desc: b['desc'], image: b['image']);
        } else {
          _addBrandItem(title: 'Ola Electric', desc: 'Complete diagnostics, battery health check, and motor repairs for all Ola S1 and S1 Pro models.', image: '');
          _addBrandItem(title: 'TVS iQube', desc: 'Expert care for TVS iQube, Bajaj Chetak, and other leading electric two-wheelers.', image: '');
          _addBrandItem(title: 'Bajaj Chetak', desc: 'Premium service for the iconic Chetak electric scooter.', image: '');
          _addBrandItem(title: 'Ather Energy', desc: 'Specialized service for Ather 450X and 450 Plus, including belt tensioning and software updates.', image: '');
          _addBrandItem(title: 'Hero Electric', desc: 'Comprehensive repairs for the entire Hero Electric range.', image: '');
          _addBrandItem(title: 'Okinawa', desc: 'Genuine parts and service for all Okinawa scooters.', image: '');
          _addBrandItem(title: 'Ampere', desc: 'Reliable maintenance for Ampere Magnus and Zeal.', image: '');
          _addBrandItem(title: 'Revolt', desc: 'Expert bike care for Revolt RV400 and RV300.', image: '');
        }

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
      final Map<String, dynamic> content = {};

      // Hero Slides
      content['heroSlides'] = _heroSlides.map((s) => {
        'image': s['image']!.text,
        'tagline': s['tagline']!.text,
        'title': s['title']!.text,
        'subtitle': s['subtitle']!.text,
        'buttonText': s['btnText']!.text,
      }).toList();

      // Stats Bar
      for (int i = 0; i < 4; i++) {
        content['barStat${i + 1}Value'] = _barStatControllers[i]['value']!.text;
        content['barStat${i + 1}Label'] = _barStatControllers[i]['label']!.text;
      }

      // What We Do
      content['wwdTagline'] = _wwdTaglineController.text;
      content['wwdTitle'] = _wwdTitleController.text;
      for (int i = 0; i < 3; i++) {
        content['wwdCard${i + 1}Title'] = _wwdCardControllers[i]['title']!.text;
        content['wwdCard${i + 1}Desc'] = _wwdCardControllers[i]['desc']!.text;
      }

      // Services
      content['servicesTagline'] = _servicesTaglineController.text;
      content['servicesTitle'] = _servicesTitleController.text;
      content['serviceCards'] = _serviceCards.map((c) => {'title': c['title']!.text, 'desc': c['desc']!.text}).toList();

      // Why Choose Us
      content['whyTitle'] = _whyTitleController.text;
      content['whyDesc'] = _whyDescController.text;
      for (int i = 0; i < 4; i++) {
        content['whyBullet${i + 1}Title'] = _whyBulletControllers[i]['title']!.text;
        content['whyBullet${i + 1}Desc'] = _whyBulletControllers[i]['desc']!.text;
      }

      // Testimonials
      content['testimonialsTitle'] = _testimonialsTitleController.text;
      content['testimonials'] = _testimonialItems.map((t) => {
        'name': t['name']!.text,
        'role': t['role']!.text,
        'content': t['content']!.text,
        'rating': int.tryParse(t['rating']!.text) ?? 5,
        'image': t['image']!.text,
      }).toList();

      // About Us
      content['aboutTagline'] = _aboutTaglineController.text;
      content['aboutTitle'] = _aboutTitleController.text;
      content['aboutDesc1'] = _aboutDesc1Controller.text;
      content['aboutDesc2'] = _aboutDesc2Controller.text;
      content['aboutImage'] = _aboutImageController.text;

      // Join Mission
      content['joinTitle'] = _joinTitleController.text;
      content['joinSubtitle'] = _joinSubtitleController.text;
      content['joinBgImage'] = _joinBgImageController.text;
      for (int i = 0; i < 3; i++) {
        content['joinCard${i + 1}Title'] = _joinCardControllers[i]['title']!.text;
      }

      // Partners
      content['partnerLogos'] = _partnerLogos.map((p) => {
        'name': p['name']!.text,
        'image': p['image']!.text,
      }).toList();

      // Brands
      content['brandsTitle'] = _brandsTitleController.text;
      content['brandsCards'] = _brandItems.map((b) => {
        'title': b['title']!.text,
        'desc': b['desc']!.text,
        'image': b['image']!.text,
        'id': '0${_brandItems.indexOf(b) + 1}',
      }).toList();

      await _apiService.updatePageContent('home', content);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Home page fully updated!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving: $e')));
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Threshold defined in isMobile getter
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundDark,
      drawer: isMobile ? const Drawer(child: AdminSidebar(currentRoute: '/pages')) : null,
      appBar: isMobile ? AppBar(
        backgroundColor: AppColors.sidebarDark,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text('Home Page Editor', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            onPressed: _isSaving ? null : _saveContent,
            icon: _isSaving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.save),
          )
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeroSection(),
                              const SizedBox(height: 32),
                              _buildStatsSection(),
                              const SizedBox(height: 32),
                              _buildWhatWeDoSection(),
                              const SizedBox(height: 32),
                              _buildWhySection(),
                              const SizedBox(height: 32),
                              _buildAboutSection(),
                              const SizedBox(height: 32),
                              _buildServicesSection(),
                              const SizedBox(height: 32),
                              _buildPartnersSection(),
                              const SizedBox(height: 32),
                              _buildTestimonialsSection(),
                              const SizedBox(height: 32),
                              _buildBrandsSection(),
                              const SizedBox(height: 32),
                              _buildJoinSection(),
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
              Text('Home Page Editor', style: AppTextStyles.heading2),
            ],
          ),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveContent,
            icon: _isSaving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.save),
            label: Text(_isSaving ? 'Saving...' : 'Save All Changes'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.sidebarDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.accentBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: AppColors.accentBlue, size: 22),
              ),
              const SizedBox(width: 16),
              Text(title, style: AppTextStyles.heading3.copyWith(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 32),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, bool isImage = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.sidebarDark,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
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

  Widget _buildHeroSection() {
    return _buildSectionCard(
      title: '1. Hero Carousel Slides',
      icon: Icons.view_carousel,
      children: [
        ...List.generate(_heroSlides.length, (index) {
          final s = _heroSlides[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.05))),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Slide #${index+1}', style: const TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => setState(() => _heroSlides.removeAt(index)), icon: const Icon(Icons.delete_outline, color: Colors.redAccent)),
                ]),
                const SizedBox(height: 16),
                isMobile ? Column(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.1))),
                      child: s['image']!.text.isNotEmpty
                          ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(s['image']!.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)))
                          : const Icon(Icons.image_outlined, color: Colors.white24),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField('Image URL', s['image']!, isImage: true),
                  ],
                ) : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 80,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.1))),
                      child: s['image']!.text.isNotEmpty
                          ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(s['image']!.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)))
                          : const Icon(Icons.image_outlined, color: Colors.white24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField('Image URL', s['image']!, isImage: true)),
                  ],
                ),
                const SizedBox(height: 16),
                isMobile ? Column(
                  children: [
                    _buildTextField('Tagline', s['tagline']!),
                    const SizedBox(height: 16),
                    _buildTextField('Button Text', s['btnText']!),
                  ],
                ) : Row(children: [
                  Expanded(child: _buildTextField('Tagline', s['tagline']!)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Button Text', s['btnText']!)),
                ]),
                const SizedBox(height: 16),
                _buildTextField('Heading', s['title']!),
                const SizedBox(height: 16),
                _buildTextField('Subtitle', s['subtitle']!, maxLines: 2),
              ],
            ),
          );
        }),
        OutlinedButton.icon(onPressed: () => _addHeroSlide(), icon: const Icon(Icons.add), label: const Text('Add Slide')),
      ],
    );
  }

  Widget _buildStatsSection() {
    return _buildSectionCard(
      title: '2. Horizontal Stats Bar',
      icon: Icons.analytics_outlined,
      children: [
        const Text('These appear in the thin white bar directly under the Hero image.', style: TextStyle(color: AppColors.textGrey, fontSize: 13, fontStyle: FontStyle.italic)),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 1 : 2, 
            crossAxisSpacing: 20, 
            mainAxisSpacing: 10, 
            childAspectRatio: isMobile ? 4.0 : 4.5
          ),
          itemCount: 4,
          itemBuilder: (context, i) => Row(children: [
            Expanded(child: _buildTextField('Value', _barStatControllers[i]['value']!)),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField('Label', _barStatControllers[i]['label']!)),
          ]),
        ),
      ],
    );
  }

  Widget _buildWhatWeDoSection() {
    return _buildSectionCard(
      title: '3. What We Do / Innovation',
      icon: Icons.lightbulb_outline,
      children: [
        _buildTextField('Tagline', _wwdTaglineController),
        const SizedBox(height: 16),
        _buildTextField('Title', _wwdTitleController),
        const SizedBox(height: 24),
        ...List.generate(3, (i) => Padding(
          padding: const EdgeInsets.only(bottom: 16), 
          child: isMobile ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.accentBlue.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                    child: Icon(_getWwdIcon(i), color: AppColors.accentBlue, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Text('Innovation #${i+1}', style: const TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              _buildTextField('Card Title', _wwdCardControllers[i]['title']!),
              const SizedBox(height: 12),
              _buildTextField('Description', _wwdCardControllers[i]['desc']!, maxLines: 2),
            ],
          ) : Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.accentBlue.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
              child: Icon(_getWwdIcon(i), color: AppColors.accentBlue, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Card ${i+1} Title', _wwdCardControllers[i]['title']!)),
            const SizedBox(width: 16),
            Expanded(flex: 2, child: _buildTextField('Description', _wwdCardControllers[i]['desc']!)),
          ])
        )),
      ],
    );
  }

  Widget _buildWhySection() {
    return _buildSectionCard(
      title: '4. Why Choose Us Checklist',
      icon: Icons.fact_check_outlined,
      children: [
        _buildTextField('Title', _whyTitleController),
        const SizedBox(height: 16),
        _buildTextField('Description', _whyDescController, maxLines: 2),
        const SizedBox(height: 24),
        ...List.generate(4, (i) => Padding(
          padding: const EdgeInsets.only(bottom: 16), 
          child: isMobile ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.accentBlue.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                    child: Icon(_getWhyIcon(i), color: AppColors.accentBlue, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Text('Reason #${i+1}', style: const TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              _buildTextField('Bullet Title', _whyBulletControllers[i]['title']!),
              const SizedBox(height: 12),
              _buildTextField('Description', _whyBulletControllers[i]['desc']!, maxLines: 2),
            ],
          ) : Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.accentBlue.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
              child: Icon(_getWhyIcon(i), color: AppColors.accentBlue, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Bullet ${i+1} Title', _whyBulletControllers[i]['title']!)),
            const SizedBox(width: 16),
            Expanded(flex: 2, child: _buildTextField('Description', _whyBulletControllers[i]['desc']!)),
          ])
        )),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _buildSectionCard(
      title: '5. About Mission 500',
      icon: Icons.info_outline,
      children: [
        isMobile ? Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.1))),
              child: _aboutImageController.text.isNotEmpty
                  ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(_aboutImageController.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)))
                  : const Icon(Icons.image_outlined, color: Colors.white24),
            ),
            const SizedBox(height: 16),
            _buildTextField('Tagline', _aboutTaglineController),
            const SizedBox(height: 16),
            _buildTextField('Side Image URL', _aboutImageController, isImage: true),
          ],
        ) : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.1))),
              child: _aboutImageController.text.isNotEmpty
                  ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(_aboutImageController.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)))
                  : const Icon(Icons.image_outlined, color: Colors.white24),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [
                  _buildTextField('Tagline', _aboutTaglineController),
                  const SizedBox(height: 16),
                  _buildTextField('Side Image URL', _aboutImageController, isImage: true),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildTextField('Heading Title', _aboutTitleController),
        const SizedBox(height: 16),
        _buildTextField('Paragraph 1', _aboutDesc1Controller, maxLines: 3),
        const SizedBox(height: 16),
        _buildTextField('Paragraph 2', _aboutDesc2Controller, maxLines: 3),
      ],
    );
  }

  Widget _buildServicesSection() {
    return _buildSectionCard(
      title: '6. Genuine Parts Grid',
      icon: Icons.settings_suggest_outlined,
      children: [
        _buildTextField('Tagline', _servicesTaglineController),
        const SizedBox(height: 16),
        _buildTextField('Title', _servicesTitleController),
        const SizedBox(height: 24),
        ...List.generate(_serviceCards.length, (index) {
           final c = _serviceCards[index];
           return Padding(
             padding: const EdgeInsets.only(bottom: 24), 
             child: isMobile ? Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Row(
                       children: [
                         Container(
                           padding: const EdgeInsets.all(10),
                           decoration: BoxDecoration(color: AppColors.accentBlue.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                           child: Icon(_getServiceIcon(index), color: AppColors.accentBlue, size: 20),
                         ),
                         const SizedBox(width: 16),
                         Text('Part #${index+1}', style: const TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.bold)),
                       ],
                     ),
                     IconButton(onPressed: () => setState(() => _serviceCards.removeAt(index)), icon: const Icon(Icons.delete_outline, color: Colors.redAccent)),
                   ],
                 ),
                 const SizedBox(height: 12),
                 _buildTextField('Card Title', c['title']!),
                 const SizedBox(height: 12),
                 _buildTextField('Card Description', c['desc']!, maxLines: 2),
               ],
             ) : Row(children: [
               Container(
                 padding: const EdgeInsets.all(10),
                 decoration: BoxDecoration(color: AppColors.accentBlue.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                 child: Icon(_getServiceIcon(index), color: AppColors.accentBlue, size: 20),
               ),
               const SizedBox(width: 16),
               Expanded(child: _buildTextField('Card Title', c['title']!)),
               const SizedBox(width: 16),
               Expanded(flex: 2, child: _buildTextField('Card Description', c['desc']!)),
               IconButton(onPressed: () => setState(() => _serviceCards.removeAt(index)), icon: const Icon(Icons.delete_outline, color: Colors.redAccent)),
             ])
           );
        }),
        OutlinedButton.icon(onPressed: () => _addServiceCard(), icon: const Icon(Icons.add), label: const Text('Add Service Item')),
      ],
    );
  }

  Widget _buildPartnersSection() {
    return _buildSectionCard(
      title: '7. Partners Carousel',
      icon: Icons.handshake_outlined,
      children: [
        ...List.generate(_partnerLogos.length, (index) {
          final p = _partnerLogos[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: isMobile ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.1))),
                      child: p['image']!.text.isNotEmpty
                          ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(p['image']!.text, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)))
                          : const Icon(Icons.image_outlined, color: Colors.white24),
                    ),
                    IconButton(onPressed: () => setState(() => _partnerLogos.removeAt(index)), icon: const Icon(Icons.delete_outline, color: Colors.redAccent)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField('Partner Name', p['name']!),
                const SizedBox(height: 12),
                _buildTextField('Logo Link', p['image']!, isImage: true),
              ],
            ) : Row(children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.1))),
                child: p['image']!.text.isNotEmpty
                    ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(p['image']!.text, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)))
                    : const Icon(Icons.image_outlined, color: Colors.white24),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField('Partner Name', p['name']!)),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: _buildTextField('Logo Link', p['image']!, isImage: true)),
              IconButton(onPressed: () => setState(() => _partnerLogos.removeAt(index)), icon: const Icon(Icons.delete_outline, color: Colors.redAccent)),
            ]),
          );
        }),
        OutlinedButton.icon(onPressed: () => _addPartnerLogo(), icon: const Icon(Icons.add), label: const Text('Add Partner')),
      ],
    );
  }

  Widget _buildTestimonialsSection() {
    return _buildSectionCard(
      title: '8. Testimonials Reviews',
      icon: Icons.reviews_outlined,
      children: [
        _buildTextField('Section Title', _testimonialsTitleController),
        const SizedBox(height: 24),
        ...List.generate(_testimonialItems.length, (index) {
          final t = _testimonialItems[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(10)),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: t['image']!.text.isNotEmpty
                        ? Image.network(t['image']!.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.person, color: Colors.white24))
                        : const Icon(Icons.person_outline, color: Colors.white24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        Row(children: [
                          Expanded(child: _buildTextField('Name', t['name']!)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildTextField('Role', t['role']!)),
                        ]),
                        const SizedBox(height: 12),
                        _buildTextField('Profile Image URL', t['image']!, isImage: true),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () => setState(() => _testimonialItems.removeAt(index)), icon: const Icon(Icons.delete_outline, color: Colors.redAccent)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(width: 100, child: _buildTextField('Rating (1-5)', t['rating']!)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Feedback Content', t['content']!, maxLines: 2)),
                ],
              ),
            ]),
          );
        }),
        OutlinedButton.icon(onPressed: () => _addTestimonial(), icon: const Icon(Icons.add), label: const Text('Add Testimonial')),
      ],
    );
  }

  Widget _buildJoinSection() {
    return _buildSectionCard(
      title: '10. Join The Mission Footer',
      icon: Icons.campaign_outlined,
      children: [
        _buildTextField('Title', _joinTitleController),
        const SizedBox(height: 16),
        _buildTextField('Subtitle', _joinSubtitleController, maxLines: 2),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 70,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.1))),
              child: _joinBgImageController.text.isNotEmpty
                  ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(_joinBgImageController.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)))
                  : const Icon(Icons.image_outlined, color: Colors.white24),
            ),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Background Image URL', _joinBgImageController, isImage: true)),
          ],
        ),
        const SizedBox(height: 24),
        Row(children: List.generate(3, (i) => Expanded(child: Padding(padding: EdgeInsets.only(right: i==2?0:16), child: _buildTextField('Card ${i+1} Title', _joinCardControllers[i]['title']!))))),
      ],
    );
  }

  Widget _buildBrandsSection() {
    return _buildSectionCard(
      title: '9. Brands We Serve (Cards)',
      icon: Icons.electric_bike_outlined,
      children: [
        _buildTextField('Section Title', _brandsTitleController),
        const SizedBox(height: 24),
        ...List.generate(_brandItems.length, (index) {
          final b = _brandItems[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.05))),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Brand #${index+1}', style: const TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => setState(() => _brandItems.removeAt(index)), icon: const Icon(Icons.delete_outline, color: Colors.redAccent)),
                ]),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.1))),
                      child: b['image']!.text.isNotEmpty
                          ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(b['image']!.text, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)))
                          : const Icon(Icons.image_outlined, color: Colors.white24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField('Logo/Image URL', b['image']!, isImage: true)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField('Brand Name', b['title']!),
                const SizedBox(height: 16),
                _buildTextField('Description', b['desc']!, maxLines: 2),
              ],
            ),
          );
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton.icon(
              onPressed: () => _addBrandItem(),
              icon: const Icon(Icons.add),
              label: const Text('Add Brand Card'),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _brandItems.clear();
                  _addBrandItem(title: 'Ola Electric', desc: 'Complete diagnostics, battery health check, and motor repairs for all Ola S1 and S1 Pro models.', image: '');
                  _addBrandItem(title: 'TVS iQube', desc: 'Expert care for TVS iQube, Bajaj Chetak, and other leading electric two-wheelers.', image: '');
                  _addBrandItem(title: 'Bajaj Chetak', desc: 'Premium service for the iconic Chetak electric scooter.', image: '');
                  _addBrandItem(title: 'Ather Energy', desc: 'Specialized service for Ather 450X and 450 Plus, including belt tensioning and software updates.', image: '');
                  _addBrandItem(title: 'Hero Electric', desc: 'Comprehensive repairs for the entire Hero Electric range.', image: '');
                  _addBrandItem(title: 'Okinawa', desc: 'Genuine parts and service for all Okinawa scooters.', image: '');
                  _addBrandItem(title: 'Ampere', desc: 'Reliable maintenance for Ampere Magnus and Zeal.', image: '');
                  _addBrandItem(title: 'Revolt', desc: 'Expert bike care for Revolt RV400 and RV300.', image: '');
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reset brands to defaults. Click "Save" to apply.')));
              },
              icon: const Icon(Icons.restore, color: Colors.amber),
              label: const Text('Reset to Defaults', style: TextStyle(color: Colors.amber)),
            ),
          ],
        ),
      ],
    );
  }

  IconData _getWwdIcon(int index) {
    switch (index) {
      case 0: return Icons.location_on_outlined;
      case 1: return Icons.verified_user_outlined;
      case 2: return Icons.engineering_outlined;
      default: return Icons.bolt;
    }
  }

  IconData _getWhyIcon(int index) {
    switch (index) {
      case 0: return Icons.eco_outlined;
      case 1: return Icons.biotech_outlined;
      case 2: return Icons.people_outline;
      case 3: return Icons.check_circle_outline;
      default: return Icons.star_outline;
    }
  }

  IconData _getServiceIcon(int index) {
    final icons = [
      Icons.settings_input_component,
      Icons.electric_moped,
      Icons.battery_charging_full,
      Icons.sensors,
      Icons.tire_repair,
      Icons.build,
    ];
    return icons[index % icons.length];
  }
}
