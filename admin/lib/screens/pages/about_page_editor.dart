import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:file_picker/file_picker.dart';

class AboutPageEditor extends StatefulWidget {
  const AboutPageEditor({super.key});

  @override
  State<AboutPageEditor> createState() => _AboutPageEditorState();
}

class _AboutPageEditorState extends State<AboutPageEditor> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isSaving = false;

  // --- Hero Section ---
  final _heroTaglineController = TextEditingController();
  final _heroTitleController = TextEditingController();
  final _heroDesc1Controller = TextEditingController();
  final _heroDesc2Controller = TextEditingController();
  final _heroImageController = TextEditingController();
  final _heroBtnTextController = TextEditingController();
  final _heroBadgeTextController = TextEditingController();
  bool _heroIsRed = false;

  // --- Stats Section ---
  final List<Map<String, TextEditingController>> _stats = List.generate(4, (_) => {
    'value': TextEditingController(),
    'label': TextEditingController(),
  });

  // --- ZigZag Sections ---
  final List<Map<String, dynamic>> _zigzagSections = [];

  // --- CTA Section ---
  final _ctaTitleController = TextEditingController();
  final _ctaSubtitleController = TextEditingController();
  final _ctaBtnTextController = TextEditingController();
  bool _ctaIsRed = false;

  @override
  void initState() {
    super.initState();
    _heroImageController.addListener(() => setState(() {}));
    _loadContent();
  }

  @override
  void dispose() {
    _heroImageController.dispose();
    for (var s in _zigzagSections) {
      (s['imageUrl'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  void _addSection({String? label, String? title, String? subtitle, String? desc, String? desc2, String? image, List<String>? items}) {
    final imageController = TextEditingController(text: image ?? '');
    // Add listener for real-time preview
    imageController.addListener(() => setState(() {}));
    
    setState(() {
      _zigzagSections.add({
        'label': TextEditingController(text: label ?? ''),
        'title': TextEditingController(text: title ?? ''),
        'subtitle': TextEditingController(text: subtitle ?? ''),
        'description': TextEditingController(text: desc ?? ''),
        'description2': TextEditingController(text: desc2 ?? ''),
        'imageUrl': imageController,
        'items': TextEditingController(text: (items ?? []).join('\n')),
      });
    });
  }

  Future<void> _loadContent() async {
    try {
      final data = await _apiService.getPageContent('about');
      final content = data['content'] ?? {};

      setState(() {
        _heroTaglineController.text = content['heroTagline'] ?? 'LAUNCH ANNOUNCEMENT';
        _heroTitleController.text = content['heroTitle'] ?? 'Driving India’s EV Future 🔋';
        _heroDesc1Controller.text = content['heroDesc1'] ?? 'Fixx EV Technologies Pvt. Ltd. is on a mission to solve one of the biggest barriers to electric vehicle adoption in India.';
        _heroDesc2Controller.text = content['heroDesc2'] ?? 'As India rapidly moves towards electric mobility, the service ecosystem has remained fragmented.';
        _heroImageController.text = content['heroImage'] ?? 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e';
        _heroBtnTextController.text = content['heroBtnText'] ?? 'GET IN TOUCH →';
        _heroBadgeTextController.text = content['heroBadgeText'] ?? 'LAUNCH ANNOUNCEMENT';
        _heroIsRed = content['heroIsRed'] ?? false;

        for (int i = 0; i < 4; i++) {
          _stats[i]['value']!.text = content['stat${i+1}Value'] ?? (['20+', '500+', '50+', '10+'][i]);
          _stats[i]['label']!.text = content['stat${i+1}Label'] ?? (['Years Experience', 'Vehicles Serviced', 'Trained Technicians', 'Cities Covered'][i]);
        }

        final sections = content['zigzagSections'] as List?;
        _zigzagSections.clear();
        if (sections != null && sections.isNotEmpty) {
          for (var s in sections) {
            _addSection(
              label: s['label'],
              title: s['title'],
              subtitle: s['subtitle'],
              desc: s['description'],
              desc2: s['description2'],
              image: s['imageUrl'],
              items: (s['items'] as List?)?.cast<String>(),
            );
          }
        } else {
          // Migration Logic: Check if there are old individual sections
          _migrateOldSections();
        }

        _ctaTitleController.text = content['ctaTitle'] ?? 'Ready to Join the EV Revolution?';
        _ctaSubtitleController.text = content['ctaSubtitle'] ?? 'Partner with FIXXEV for reliable EV servicing and support.';
        _ctaBtnTextController.text = content['ctaBtnText'] ?? 'CONTACT US';
        _ctaIsRed = content['ctaIsRed'] ?? false;

        _isLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _migrateOldSections() async {
    try {
      final oldSections = await _apiService.getAboutSections();
      if (oldSections.isNotEmpty) {
        setState(() => _zigzagSections.clear());
        for (var s in oldSections) {
          if (s['isActive'] == true) {
            _addSection(
              label: s['label'],
              title: s['title'],
              desc: s['description'],
              image: s['imageUrl'],
              items: (s['items'] as List?)?.cast<String>(),
            );
          }
        }
      } else {
        // Fallback to defaults if truly nothing exists
        _addSection(
          label: '// INFRASTRUCTURE', 
          title: 'What We Are Building', 
          subtitle: 'EV Spares Hub – Powering India’s EV Ecosystem',
          desc: 'A nationwide, standardized EV after-sales network.', 
          image: 'https://images.unsplash.com/photo-1587352324982-d49d44f80877?auto=format&fit=crop&q=80&w=2000',
          items: ['Branding & onboarding support', 'Technical training', 'OEM-approved parts access', 'Digital tools']
        );
        _addSection(
          label: '// INNOVATION', 
          title: 'Technology as the Backbone', 
          image: 'https://images.unsplash.com/photo-1556155092-490a1ba16284?auto=format&fit=crop&q=80&w=2000',
          desc: 'Our mobile application connects EV owners to authorized service centres.'
        );
      }
    } catch (e) {
      // If migration fails, just show the defaults
      _addSection(
        label: '// INFRASTRUCTURE', 
        title: 'What We Are Building', 
        image: 'https://images.unsplash.com/photo-1587352324982-d49d44f80877?auto=format&fit=crop&q=80&w=2000',
        desc: 'A nationwide, standardized EV after-sales network.'
      );
    }
  }

  Future<void> _saveContent() async {
    setState(() => _isSaving = true);
    try {
      final Map<String, dynamic> content = {};

      content['heroTagline'] = _heroTaglineController.text;
      content['heroTitle'] = _heroTitleController.text;
      content['heroDesc1'] = _heroDesc1Controller.text;
      content['heroDesc2'] = _heroDesc2Controller.text;
      content['heroImage'] = _heroImageController.text;
      content['heroBtnText'] = _heroBtnTextController.text;
      content['heroBadgeText'] = _heroBadgeTextController.text;
      content['heroIsRed'] = _heroIsRed;

      for (int i = 0; i < 4; i++) {
        content['stat${i+1}Value'] = _stats[i]['value']!.text;
        content['stat${i+1}Label'] = _stats[i]['label']!.text;
      }

      content['zigzagSections'] = _zigzagSections.map((s) => {
        'label': (s['label'] as TextEditingController).text,
        'title': (s['title'] as TextEditingController).text,
        'subtitle': (s['subtitle'] as TextEditingController).text,
        'description': (s['description'] as TextEditingController).text,
        'description2': (s['description2'] as TextEditingController).text,
        'imageUrl': (s['imageUrl'] as TextEditingController).text,
        'items': (s['items'] as TextEditingController).text.split('\n').where((e) => e.trim().isNotEmpty).toList(),
      }).toList();

      content['ctaTitle'] = _ctaTitleController.text;
      content['ctaSubtitle'] = _ctaSubtitleController.text;
      content['ctaBtnText'] = _ctaBtnTextController.text;
      content['ctaIsRed'] = _ctaIsRed;

      await _apiService.updatePageContent('about', content);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('About page fully updated!')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving: $e')));
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
                            _buildHeroSection(),
                            const SizedBox(height: 32),
                            _buildStatsSection(),
                            const SizedBox(height: 32),
                            _buildZigZagSections(),
                            const SizedBox(height: 32),
                            _buildCTASection(),
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
              Text('About Page Editor', style: AppTextStyles.heading2),
            ],
          ),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveContent,
            icon: _isSaving 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.save),
            label: Text(_isSaving ? 'Saving...' : 'Save All Changes'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentBlue, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.sidebarDark)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.accentBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: AppColors.accentBlue, size: 22)),
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

  Widget _buildHeroSection() {
    return _buildSectionCard(
      title: '1. About Hero Section',
      icon: Icons.info_outline,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150, height: 150,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.1))),
              child: _heroImageController.text.isNotEmpty
                  ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(_heroImageController.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)))
                  : const Icon(Icons.image_outlined, color: Colors.white24),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [
                   _buildTextField('Tagline', _heroTaglineController),
                   const SizedBox(height: 16),
                   _buildTextField('Image URL', _heroImageController, isImage: true),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildTextField('Main Heading', _heroTitleController),
        const SizedBox(height: 16),
        _buildTextField('Paragraph 1', _heroDesc1Controller, maxLines: 3),
        const SizedBox(height: 16),
        _buildTextField('Paragraph 2', _heroDesc2Controller, maxLines: 3),
        const SizedBox(height: 16),
        _buildTextField('Hero Button Text', _heroBtnTextController),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('Badge Text (Launch Announcement)', _heroBadgeTextController)),
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

  Widget _buildStatsSection() {
    return _buildSectionCard(
      title: '2. Impact Stats Bar',
      icon: Icons.analytics_outlined,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 10, childAspectRatio: 4.5),
          itemCount: 4,
          itemBuilder: (context, i) => Row(children: [
            Expanded(child: _buildTextField('Value', _stats[i]['value']!)),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField('Label', _stats[i]['label']!)),
          ]),
        ),
      ],
    );
  }

  Widget _buildZigZagSections() {
    return _buildSectionCard(
      title: '3. Story ZigZag Blocks',
      icon: Icons.view_headline,
      children: [
        ...List.generate(_zigzagSections.length, (index) {
          final s = _zigzagSections[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.05))),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Block #${index+1}', style: const TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => setState(() => _zigzagSections.removeAt(index)), icon: const Icon(Icons.delete_outline, color: Colors.redAccent)),
                ]),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.1))),
                      child: s['imageUrl']!.text.isNotEmpty
                          ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(s['imageUrl']!.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)))
                          : const Icon(Icons.image_outlined, color: Colors.white24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(children: [
                        _buildTextField('Label (Small text above title)', s['label']!),
                        const SizedBox(height: 12),
                        _buildTextField('Image URL', s['imageUrl']!, isImage: true),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Heading Title', s['title']!)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField('Subheading (Optional)', s['subtitle']!)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField('Description Paragraph 1', s['description']!, maxLines: 3),
                const SizedBox(height: 16),
                _buildTextField('Description Paragraph 2 (Optional)', s['description2']!, maxLines: 3),
                const SizedBox(height: 16),
                _buildTextField('Checklist Items (One per line)', s['items']!, maxLines: 4),
              ],
            ),
          );
        }),
        Center(
          child: OutlinedButton.icon(onPressed: () => _addSection(), icon: const Icon(Icons.add), label: const Text('Add ZigZag Block')),
        ),
      ],
    );
  }

  Widget _buildCTASection() {
    return _buildSectionCard(
      title: '4. Join CTA Section',
      icon: Icons.campaign_outlined,
      children: [
        Row(
          children: [
            Expanded(child: _buildTextField('CTA Title', _ctaTitleController)),
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
        const SizedBox(height: 16),
        _buildTextField('CTA Subtitle', _ctaSubtitleController, maxLines: 2),
        const SizedBox(height: 16),
        _buildTextField('Button Text', _ctaBtnTextController),
      ],
    );
  }
}
