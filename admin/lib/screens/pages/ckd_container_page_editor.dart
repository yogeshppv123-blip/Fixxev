import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:file_picker/file_picker.dart';

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
  final _heroTaglineController = TextEditingController();
  final _heroImageController = TextEditingController();
  bool _heroIsRed = false;

  // Join Community Section
  final _communityTitleController = TextEditingController();
  final _communityDescController = TextEditingController();
  final _communityItemsController = TextEditingController();
  final _communityConclusionController = TextEditingController();
  final _communityImageController = TextEditingController();
  bool _joinIsRed = false;

  // Why Choose Section (unused - keeping for compatibility)
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
  final _smarterItemsController = TextEditingController();
  final _smarterImageController = TextEditingController();
  bool _smarterIsRed = false;

  // Stats Section (unused currently)
  final _stat1ValController = TextEditingController();
  final _stat1LabController = TextEditingController();
  final _stat2ValController = TextEditingController();
  final _stat2LabController = TextEditingController();
  final _stat3ValController = TextEditingController();
  final _stat3LabController = TextEditingController();
  final _stat4ValController = TextEditingController();
  final _stat4LabController = TextEditingController();

  // Process Steps Section
  final _processTitleController = TextEditingController();
  final _processDescController = TextEditingController();
  final _step1TitleController = TextEditingController();
  final _step1DescController = TextEditingController();
  final _step2TitleController = TextEditingController();
  final _step2DescController = TextEditingController();
  final _step3TitleController = TextEditingController();
  final _step3DescController = TextEditingController();
  final _step4TitleController = TextEditingController();
  final _step4DescController = TextEditingController();
  final _processTaglineController = TextEditingController();
  final _processSloganController = TextEditingController();
  final _processCtaController = TextEditingController();
  bool _ctaIsRed = false;

  // Network Section
  final _networkTitleController = TextEditingController();
  final _networkDescController = TextEditingController();
  final _networkDesc2Controller = TextEditingController();
  final _networkBulletTitleController = TextEditingController();
  final _networkItemsController = TextEditingController();
  final _networkConclusionController = TextEditingController();
  
  // End-to-End Section
  final _endToEndTitleController = TextEditingController();
  final _endToEndDescController = TextEditingController();

  // Scalable Future / Why Fixx Section
  final _whyFixxTitleController = TextEditingController();
  final _whyFixxSubtitleController = TextEditingController();
  final _whyFixxChipsController = TextEditingController();
  final _whyFixxConclusionController = TextEditingController();
  final _missionLabelController = TextEditingController();
  final _missionTextController = TextEditingController();
  final _scalableImageController = TextEditingController();
  bool _scalableIsRed = false;
  
  // Model Models
  final _model1NameController = TextEditingController();
  final _model1ImageController = TextEditingController();
  final _model2NameController = TextEditingController();
  final _model2ImageController = TextEditingController();
  final _model3NameController = TextEditingController();
  final _model3ImageController = TextEditingController();

  // Dynamic Models List
  List<Map<String, TextEditingController>> _ckdModelControllers = [];
  
  void _addModel([String? name, String? image]) {
    setState(() {
      final imgC = TextEditingController(text: image ?? '');
      imgC.addListener(() => setState(() {})); // Rebuild for preview
      _ckdModelControllers.add({
        'name': TextEditingController(text: name ?? ''),
        'image': imgC,
      });
    });
  }

  void _removeModel(int index) {
    setState(() {
      _ckdModelControllers[index]['name']?.dispose();
      _ckdModelControllers[index]['image']?.dispose();
      _ckdModelControllers.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _heroImageController.addListener(() => setState(() {}));
    _communityImageController.addListener(() => setState(() {}));
    _smarterImageController.addListener(() => setState(() {}));
    _scalableImageController.addListener(() => setState(() {}));
    _model1ImageController.addListener(() => setState(() {}));
    _model2ImageController.addListener(() => setState(() {}));
    _model3ImageController.addListener(() => setState(() {}));
    _loadContent();
  }

  @override
  void dispose() {
    _heroTitleController.dispose();
    _heroSubtitleController.dispose();
    _heroTaglineController.dispose();
    _heroImageController.dispose();
    _communityTitleController.dispose();
    _communityDescController.dispose();
    _communityItemsController.dispose();
    _communityConclusionController.dispose();
    _communityImageController.dispose();
    _smarterTitleController.dispose();
    _smarterSubtitleController.dispose();
    _smarterDescController.dispose();
    _smarterItemsController.dispose();
    _smarterImageController.dispose();
    _nextDispose();
    super.dispose();
  }

  void _nextDispose() {
     _whyTitleController.dispose();
     _whySubtitleController.dispose();
     _whyItem1Controller.dispose();
     _whyItem2Controller.dispose();
     _whyItem3Controller.dispose();
     _whyItem4Controller.dispose();
     _processTitleController.dispose();
     _processDescController.dispose();
     _step1TitleController.dispose();
     _step1DescController.dispose();
     _step2TitleController.dispose();
     _step2DescController.dispose();
     _step3TitleController.dispose();
     _step3DescController.dispose();
     _step4TitleController.dispose();
     _step4DescController.dispose();
     _processTaglineController.dispose();
     _processSloganController.dispose();
     _processCtaController.dispose();
     _networkTitleController.dispose();
     _networkDescController.dispose();
     _networkDesc2Controller.dispose();
     _networkBulletTitleController.dispose();
     _networkItemsController.dispose();
     _networkConclusionController.dispose();
     _endToEndTitleController.dispose();
     _endToEndDescController.dispose();
     _whyFixxTitleController.dispose();
     _whyFixxSubtitleController.dispose();
     _whyFixxChipsController.dispose();
     _whyFixxConclusionController.dispose();
     _missionLabelController.dispose();
     _missionTextController.dispose();
     _scalableImageController.dispose();
     _model1NameController.dispose();
     _model1ImageController.dispose();
     _model2NameController.dispose();
     _model2ImageController.dispose();
     _model3NameController.dispose();
     _model3ImageController.dispose();
     
     for (var c in _ckdModelControllers) {
       c['name']?.dispose();
       c['image']?.dispose();
     }
  }

  Future<void> _loadContent() async {
    try {
      final data = await _apiService.getPageContent('ckd-container');
      final content = data['content'] ?? {};
      
      setState(() {
        // Hero
        String getVal(dynamic val, String fallback) {
          if (val == null) return fallback;
          final s = val.toString();
          return s.isEmpty ? fallback : s;
        }

        _heroTitleController.text = getVal(content['heroTitle'], 'Build Your Own EV Brand with Fixx EV');
        _heroTaglineController.text = getVal(content['heroTagline'], 'START OR SCALE');
        _heroSubtitleController.text = getVal(content['heroSubtitle'], 'At Fixx EV, we don\'t just service electric vehicles — we help create EV brands.');
        _heroImageController.text = getVal(content['heroImage'], 'http://127.0.0.1:5001/uploads/1767433414306-758152587.jpg');
        _heroIsRed = content['heroIsRed'] ?? false;

        // Community
        _communityTitleController.text = getVal(content['communityTitle'], 'CKD Import & Assembly Solutions');
        _communityDescController.text = getVal(content['communityDesc'], 'Fixx EV offers complete CKD (Completely Knocked Down) import solutions for both low-speed and high speed electric scooters.');
        _communityItemsController.text = getVal(content['communityItems'], 'Launch your own EV brand\nControl product quality\nImprove margins\nBuild long-term market presence');
        _communityConclusionController.text = getVal(content['communityConclusion'], 'We handle everything — from factory sourcing in China to assembly, testing and go-to-market support in India.');
        _communityImageController.text = getVal(content['communityImage'], 'http://127.0.0.1:5001/uploads/1767433442237-739399020.png');
        _joinIsRed = content['joinIsRed'] ?? false;

        // Why Choose (legacy)
        _whyTitleController.text = getVal(content['whyTitle'], 'Why Choose CKD Containers?');
        _whySubtitleController.text = getVal(content['whySubtitle'], 'We provide end-to-end support for your EV brand.');
        _whyItem1Controller.text = getVal(content['whyItem1'], 'Quick 30-day deployment');
        _whyItem2Controller.text = getVal(content['whyItem2'], 'Pre-fabricated infrastructure');
        _whyItem3Controller.text = getVal(content['whyItem3'], 'Cost-effective solution');
        _whyItem4Controller.text = getVal(content['whyItem4'], 'Fully customizable design');

        // Smarter Showrooms (Sales, Service & Spare Parts)
        _smarterTitleController.text = getVal(content['smarterTitle'], 'Sales, Service & Spare Parts Support');
        _smarterSubtitleController.text = getVal(content['smarterSubtitle'], 'Smarter Electric Scooters, Built for Performance.');
        _smarterDescController.text = getVal(content['smarterDesc'], 'Launching a brand is not just about selling — it\'s about supporting customers after sale.');
        _smarterItemsController.text = getVal(content['smarterItems'], 'Service infrastructure\nGenuine spare parts\nTrained technicians\nWarranty support\nNationwide coverage');
        _smarterImageController.text = getVal(content['smarterImage'], 'http://127.0.0.1:5001/uploads/1767433442244-156836670.png');
        _smarterIsRed = content['smarterIsRed'] ?? false;

        // Stats (unused currently)
        _stat1ValController.text = getVal(content['stat1Value'], '30');
        _stat1LabController.text = getVal(content['stat1Label'], 'Cities');
        _stat2ValController.text = getVal(content['stat2Value'], '500+');
        _stat2LabController.text = getVal(content['stat2Label'], 'Scoters Daily');
        _stat3ValController.text = getVal(content['stat3Value'], '50+');
        _stat3LabController.text = getVal(content['stat3Label'], 'Service Centers');
        _stat4ValController.text = getVal(content['stat4Value'], '10+');
        _stat4LabController.text = getVal(content['stat4Label'], 'Brands');

        // Process Steps
        _processTitleController.text = getVal(content['processTitle'], 'From Import to Indian Roads — We Make It Simple');
        _processDescController.text = getVal(content['processDesc'], 'Fixx EV helps you go from factory to showroom to customer with one trusted partner.');
        _step1TitleController.text = getVal(content['step1Title'], 'Contact Us');
        _step1DescController.text = getVal(content['step1Desc'], 'Get in touch with our team to discuss your EV business goals.');
        _step2TitleController.text = getVal(content['step2Title'], 'Share Requirements');
        _step2DescController.text = getVal(content['step2Desc'], 'Tell us about your target market and preferred volume.');
        _step3TitleController.text = getVal(content['step3Title'], 'Order Placement');
        _step3DescController.text = getVal(content['step3Desc'], 'Place your orders through our secure portal.');
        _step4TitleController.text = getVal(content['step4Title'], 'Delivery Support');
        _step4DescController.text = getVal(content['step4Desc'], 'We deliver your CKD containers on time to your facility.');
        _processTaglineController.text = getVal(content['processTagline'], 'Fixx EV — Your EV Brand, Built Right');
        _processSloganController.text = getVal(content['processSlogan'], 'Import. Assemble. Brand. Sell. Service.');
        _processCtaController.text = getVal(content['processCta'], 'We do it all — so you can focus on growing your business.');
        _ctaIsRed = content['ctaIsRed'] ?? false;

        // Network
        _networkTitleController.text = getVal(content['networkTitle'], 'We are reaching every corner of India');
        _networkDescController.text = getVal(content['networkDesc'], 'At Fixx EV, our vision is to make clean mobility accessible everywhere.');
        _networkDesc2Controller.text = getVal(content['networkDesc2'], 'From metros to Tier-2 cities.');
        _networkBulletTitleController.text = getVal(content['networkBulletTitle'], 'Our dealer-first model ensures:');
        _networkItemsController.text = getVal(content['networkItems'], 'Exclusive territory rights\nFaster installation timelines\nAffordable infrastructure\nReliable supply and service support');
        _networkConclusionController.text = getVal(content['networkConclusion'], 'This PAN-India strategy gives dealers a powerful competitive edge.');

        // End to End
        _endToEndTitleController.text = getVal(content['endToEndTitle'], 'End-to-End EV Brand Launch Support');
        _endToEndDescController.text = getVal(content['endToEndDesc'], 'When you partner with Fixx EV, you get a full-stack EV business solution.');
        
        // Why Fixx / Scalable Future
        _whyFixxTitleController.text = getVal(content['whyFixxTitle'], 'Why Fixx EV?');
        _whyFixxSubtitleController.text = getVal(content['whyFixxSubtitle'], 'With 10+ years of EV industry experience.');
        _whyFixxChipsController.text = getVal(content['whyFixxChips'], 'Manufacturing\nImport & sourcing\nSales & distribution\nService & spare parts\nFleet operations');
        _whyFixxConclusionController.text = getVal(content['whyFixxConclusion'], 'We know what works — and what fails — in the Indian EV market.');
        _missionLabelController.text = getVal(content['missionLabel'], 'OUR MISSION');
        _missionTextController.text = getVal(content['missionText'], 'Help 100s of entrepreneurs build profitable, sustainable EV brands.');
        _scalableImageController.text = getVal(content['whyImage'], 'http://127.0.0.1:5001/uploads/1767433442254-188363033.png');
        _scalableIsRed = content['whyIsRed'] ?? false;
        
        // Models
        _model1NameController.text = getVal(content['model1Name'], 'Vector X');
        _model1ImageController.text = getVal(content['model1Image'], 'http://127.0.0.1:5001/uploads/1767433466429-104872347.png');
        _model2NameController.text = getVal(content['model2Name'], 'Urban S');
        _model2ImageController.text = getVal(content['model2Image'], 'http://127.0.0.1:5001/uploads/1767433466436-466069146.png');
        _model3NameController.text = getVal(content['model3Name'], 'Metro Glide');
        _model3ImageController.text = getVal(content['model3Image'], 'http://127.0.0.1:5001/uploads/1767433466442-920385781.png');

        // Dynamic Models
        _ckdModelControllers.clear();
        if (content['ckdModels'] != null && (content['ckdModels'] as List).isNotEmpty) {
           for (var m in (content['ckdModels'] as List)) {
             _addModel(getVal(m['name'], ''), getVal(m['image'], ''));
           }
        } else {
           // Initialize with legacy if dynamic is empty
           _addModel(_model1NameController.text, _model1ImageController.text);
           _addModel(_model2NameController.text, _model2ImageController.text);
           _addModel(_model3NameController.text, _model3ImageController.text);
        }

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
        // Hero
        'heroTitle': _heroTitleController.text,
        'heroTagline': _heroTaglineController.text,
        'heroSubtitle': _heroSubtitleController.text,
        'heroImage': _heroImageController.text,
        'heroIsRed': _heroIsRed,
        
        // Community
        'communityTitle': _communityTitleController.text,
        'communityDesc': _communityDescController.text,
        'communityItems': _communityItemsController.text,
        'communityConclusion': _communityConclusionController.text,
        'communityImage': _communityImageController.text,
        'joinIsRed': _joinIsRed,
        
        // Why Choose (legacy)
        'whyTitle': _whyTitleController.text,
        'whySubtitle': _whySubtitleController.text,
        'whyItem1': _whyItem1Controller.text,
        'whyItem2': _whyItem2Controller.text,
        'whyItem3': _whyItem3Controller.text,
        'whyItem4': _whyItem4Controller.text,
        
        // Smarter Showrooms
        'smarterTitle': _smarterTitleController.text,
        'smarterSubtitle': _smarterSubtitleController.text,
        'smarterDesc': _smarterDescController.text,
        'smarterItems': _smarterItemsController.text,
        'smarterImage': _smarterImageController.text,
        'smarterIsRed': _smarterIsRed,
        
        // Stats
        'stat1Value': _stat1ValController.text,
        'stat1Label': _stat1LabController.text,
        'stat2Value': _stat2ValController.text,
        'stat2Label': _stat2LabController.text,
        'stat3Value': _stat3ValController.text,
        'stat3Label': _stat3LabController.text,
        'stat4Value': _stat4ValController.text,
        'stat4Label': _stat4LabController.text,
        
        // Process Section
        'processTitle': _processTitleController.text,
        'processDesc': _processDescController.text,
        'step1Title': _step1TitleController.text,
        'step1Desc': _step1DescController.text,
        'step2Title': _step2TitleController.text,
        'step2Desc': _step2DescController.text,
        'step3Title': _step3TitleController.text,
        'step3Desc': _step3DescController.text,
        'step4Title': _step4TitleController.text,
        'step4Desc': _step4DescController.text,
        'processTagline': _processTaglineController.text,
        'processSlogan': _processSloganController.text,
        'processCta': _processCtaController.text,
        'ctaIsRed': _ctaIsRed,
        
        // Network Section
        'networkTitle': _networkTitleController.text,
        'networkDesc': _networkDescController.text,
        'networkDesc2': _networkDesc2Controller.text,
        'networkBulletTitle': _networkBulletTitleController.text,
        'networkItems': _networkItemsController.text,
        'networkConclusion': _networkConclusionController.text,
        
        // End-to-End
        'endToEndTitle': _endToEndTitleController.text,
        'endToEndDesc': _endToEndDescController.text,
        
        // Why Fixx / Scalable
        'whyFixxTitle': _whyFixxTitleController.text,
        'whyFixxSubtitle': _whyFixxSubtitleController.text,
        'whyFixxChips': _whyFixxChipsController.text,
        'whyFixxConclusion': _whyFixxConclusionController.text,
        'missionLabel': _missionLabelController.text,
        'missionText': _missionTextController.text,
        'whyImage': _scalableImageController.text,
        'whyIsRed': _scalableIsRed,

        // Models
        'model1Name': _model1NameController.text,
        'model1Image': _model1ImageController.text,
        'model2Name': _model2NameController.text,
        'model2Image': _model2ImageController.text,
        'model3Name': _model3NameController.text,
        'model3Image': _model3ImageController.text,
        'ckdModels': _ckdModelControllers.map((c) => {
          'name': c['name']!.text,
          'image': c['image']!.text,
        }).toList(),
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
                            _buildEndToEndSection(),
                            const SizedBox(height: 32),
                            _buildWhySection(),
                            const SizedBox(height: 32),
                            _buildSmarterSection(),
                            const SizedBox(height: 32),
                            _buildScalableSection(),
                            const SizedBox(height: 32),
                            _buildModelsSection(),
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
          Row(
            children: [
              TextButton.icon(
                onPressed: () => _loadContent(), // This will reload with defaults if empty
                icon: const Icon(Icons.sync, color: AppColors.textGrey, size: 18),
                label: const Text('Restore Defaults', style: TextStyle(color: AppColors.textGrey)),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveContent,
                icon: _isSaving 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save),
                label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
              ),
            ],
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.1))),
              child: _heroImageController.text.isNotEmpty
                  ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(_heroImageController.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)))
                  : const Icon(Icons.image_outlined, color: Colors.white24, size: 40),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [
                  _buildTextField('Hero Tagline', _heroTaglineController),
                  const SizedBox(height: 16),
                  _buildTextField('Background Image URL', _heroImageController, isImage: true),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField('Hero Title', _heroTitleController),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('Hero Subtitle', _heroSubtitleController, maxLines: 2)),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Red Theme', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                Switch(value: _heroIsRed, onChanged: (v) => setState(() => _heroIsRed = v), activeColor: Colors.redAccent),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommunitySection() {
    return _buildSectionCard(
      title: 'CKD Import & Assembly Section',
      icon: Icons.people_outline,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.1))),
              child: _communityImageController.text.isNotEmpty
                  ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(_communityImageController.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)))
                  : const Icon(Icons.image_outlined, color: Colors.white24, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  _buildTextField('Section Title', _communityTitleController, maxLines: 2),
                  const SizedBox(height: 12),
                  _buildTextField('Image URL', _communityImageController, isImage: true),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField('Description', _communityDescController, maxLines: 3),
        const SizedBox(height: 16),
        _buildTextField('Bullet Items (One per line)', _communityItemsController, maxLines: 5),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('Conclusion Text', _communityConclusionController, maxLines: 2)),
            const SizedBox(width: 24),
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Red Theme', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                Switch(value: _joinIsRed, onChanged: (v) => setState(() => _joinIsRed = v), activeColor: Colors.redAccent),
              ],
            ),
          ],
        ),
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.1))),
              child: _smarterImageController.text.isNotEmpty
                  ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(_smarterImageController.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)))
                  : const Icon(Icons.image_outlined, color: Colors.white24, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  _buildTextField('Title', _smarterTitleController),
                  const SizedBox(height: 12),
                  _buildTextField('Image URL', _smarterImageController, isImage: true),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField('Subtitle', _smarterSubtitleController),
        const SizedBox(height: 16),
        _buildTextField('Description', _smarterDescController, maxLines: 3),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('Checklist Items (One per line)', _smarterItemsController, maxLines: 6)),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Red Theme', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                Switch(value: _smarterIsRed, onChanged: (v) => setState(() => _smarterIsRed = v), activeColor: Colors.redAccent),
              ],
            ),
          ],
        ),
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
      title: 'Process Section (Dark)',
      icon: Icons.timeline,
      children: [
        _buildTextField('Section Title', _processTitleController, maxLines: 2),
        const SizedBox(height: 16),
        _buildTextField('Section Description', _processDescController, maxLines: 2),
        const SizedBox(height: 24),
        const Text('Steps (Cards)', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildStepFields('Step 1', _step1TitleController, _step1DescController),
        const SizedBox(height: 16),
        _buildStepFields('Step 2', _step2TitleController, _step2DescController),
        const SizedBox(height: 16),
        _buildStepFields('Step 3', _step3TitleController, _step3DescController),
        const SizedBox(height: 16),
        _buildStepFields('Step 4', _step4TitleController, _step4DescController),
        const SizedBox(height: 24),
        const Text('Bottom Taglines', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildTextField('Tagline', _processTaglineController),
        const SizedBox(height: 16),
        _buildTextField('Slogan', _processSloganController),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('CTA Text', _processCtaController)),
             const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Red Theme', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                Switch(value: _ctaIsRed, onChanged: (v) => setState(() => _ctaIsRed = v), activeColor: Colors.redAccent),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNetworkSection() {
    return _buildSectionCard(
      title: 'Network Map Section',
      icon: Icons.map_outlined,
      children: [
        _buildTextField('Section Title', _networkTitleController),
        const SizedBox(height: 16),
        _buildTextField('Description Paragraph 1', _networkDescController, maxLines: 3),
        const SizedBox(height: 16),
        _buildTextField('Description Paragraph 2', _networkDesc2Controller, maxLines: 3),
        const SizedBox(height: 16),
        _buildTextField('Bullet Title', _networkBulletTitleController),
        const SizedBox(height: 16),
        _buildTextField('Bullet Items (One per line)', _networkItemsController, maxLines: 5),
        const SizedBox(height: 16),
        _buildTextField('Conclusion Text', _networkConclusionController, maxLines: 2),
      ],
    );
  }

  Widget _buildEndToEndSection() {
    return _buildSectionCard(
      title: 'End-to-End Support Section',
      icon: Icons.layers,
      children: [
        _buildTextField('Section Title', _endToEndTitleController),
        const SizedBox(height: 16),
        _buildTextField('Description', _endToEndDescController, maxLines: 5),
      ],
    );
  }

  Widget _buildScalableSection() {
    return _buildSectionCard(
      title: 'Why Fixx EV Section',
      icon: Icons.trending_up,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Container(
              width: 100, height: 100,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.1))),
              child: _scalableImageController.text.isNotEmpty
                  ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(_scalableImageController.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)))
                  : const Icon(Icons.image_outlined, color: Colors.white24, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  _buildTextField('Section Title', _whyFixxTitleController),
                  const SizedBox(height: 12),
                  _buildTextField('Section Image URL', _scalableImageController, isImage: true),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField('Subtitle / Experience Text', _whyFixxSubtitleController, maxLines: 2),
        const SizedBox(height: 16),
        _buildTextField('Expertise Chips (One per line)', _whyFixxChipsController, maxLines: 6),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('Conclusion / Expertise Statement', _whyFixxConclusionController, maxLines: 2)),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Red Theme', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                Switch(value: _scalableIsRed, onChanged: (v) => setState(() => _scalableIsRed = v), activeColor: Colors.redAccent),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Mission Box', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildTextField('Mission Label', _missionLabelController),
        const SizedBox(height: 16),
        _buildTextField('Mission Text', _missionTextController, maxLines: 3),
      ],
    );
  }

  Widget _buildModelsSection() {
    return _buildSectionCard(
      title: 'Our CKD Container Models (Dynamic)',
      icon: Icons.electric_scooter,
      children: [
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            ..._ckdModelControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final map = entry.value;
              return Container(
                width: 300,
                child: Stack(
                  children: [
                    _buildSingleModelEdit(
                      'Model ${index + 1}', 
                      map['name']!, 
                      map['image']!
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                        onPressed: () => _removeModel(index),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            Container(
              width: 300,
              height: 360,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () => _addModel(),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_circle_outline, color: AppColors.accentBlue, size: 48),
                      const SizedBox(height: 16),
                      Text('Add New Model', style: AppTextStyles.bodyMedium),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSingleModelEdit(String label, TextEditingController nameC, TextEditingController imageC) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: imageC.text.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(imageC.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)),
                  )
                : const Icon(Icons.image_outlined, color: Colors.white24, size: 40),
          ),
          const SizedBox(height: 16),
          _buildTextField('Model Name', nameC),
          const SizedBox(height: 12),
          _buildTextField('Image URL', imageC, isImage: true),
        ],
      ),
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
}
