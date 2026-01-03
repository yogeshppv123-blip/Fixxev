import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:file_picker/file_picker.dart';

class ServicesPageEditor extends StatefulWidget {
  const ServicesPageEditor({super.key});

  @override
  State<ServicesPageEditor> createState() => _ServicesPageEditorState();
}

class _ServicesPageEditorState extends State<ServicesPageEditor> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isSaving = false;

  final _heroTitleController = TextEditingController();
  final _heroTaglineController = TextEditingController();
  final _heroImageController = TextEditingController();
  final _heroBtnTextController = TextEditingController();
  bool _heroIsRed = false;

  final _whyChooseTitleController = TextEditingController();
  final _whyChooseLabelController = TextEditingController();
  final _whyChoosePointsController = TextEditingController();

  final _ctaTitleController = TextEditingController();
  final _ctaBtnTextController = TextEditingController();
  bool _ctaIsRed = false;

  final List<Map<String, dynamic>> _zigzagServices = [];

  late Future<List<dynamic>> _servicesFuture;
  final _defaultServices = [
      {'title': 'After-Sales Service & Preventive Maintenance', 'category': 'After-Sales', 'status': 'Active', 'description': 'Complete after-sales servicing for EVs, ensuring smooth performance and long-term reliability.'},
      {'title': 'EXTENDED WARRANTY', 'category': 'Warranty', 'status': 'Active', 'description': 'Custom extended warranty programs for EV OEMs, covering critical components.'},
      {'title': 'High-Tech EV Diagnostics & Software Solutions', 'category': 'Diagnostics', 'status': 'Active', 'description': 'CAN Bus analysis and BMS firmware updates.'},
      {'title': 'Battery Repairs, Replacement & Recycling', 'category': 'Energy Care', 'status': 'Active', 'description': 'Expert repair and refurbishment for Lithium-Ion EV batteries.'},
      {'title': 'Road Side Assistance', 'category': 'Service', 'status': 'Active', 'description': '24/7 EV Roadside Assistance ensures you\'re never left stranded.'},
      {'title': 'AMC', 'category': 'Service', 'status': 'Active', 'description': 'Custom Annual Maintenance Contract (AMC) plans for single or fleet operators.'},
  ];

  @override
  void initState() {
    super.initState();
    _heroImageController.addListener(() => setState(() {}));
    _loadContent();
    _refreshServices();
  }

  void _refreshServices() {
    setState(() {
      _servicesFuture = _apiService.getServices();
    });
  }

  @override
  void dispose() {
    _heroTitleController.dispose();
    _heroTaglineController.dispose();
    _heroImageController.dispose();
    _heroBtnTextController.dispose();
    for (var s in _zigzagServices) {
      (s['imageUrl'] as TextEditingController).dispose();
    }
    _whyChooseTitleController.dispose();
    _whyChooseLabelController.dispose();
    _whyChoosePointsController.dispose();
    _ctaTitleController.dispose();
    _ctaBtnTextController.dispose();
    super.dispose();
  }

  void _addServiceBlock({String? label, String? title, String? desc, String? image, List<String>? items}) {
    final imageController = TextEditingController(text: image ?? '');
    imageController.addListener(() => setState(() {}));
    
    setState(() {
      _zigzagServices.add({
        'label': TextEditingController(text: label ?? ''),
        'title': TextEditingController(text: title ?? ''),
        'description': TextEditingController(text: desc ?? ''),
        'imageUrl': imageController,
        'items': TextEditingController(text: (items ?? []).join('\n')),
      });
    });
  }

  Future<void> _loadContent() async {
    try {
      final data = await _apiService.getPageContent('services');
      final content = data['content'] ?? {};
      
      setState(() {
        _heroTitleController.text = content['heroTitle'] ?? 'Advanced Multi-Brand\nEV Solutions';
        _heroTaglineController.text = content['heroTagline'] ?? 'SERVICE EXCELLENCE';
        _heroImageController.text = content['heroImage'] ?? 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7';
        _heroBtnTextController.text = content['heroBtnText'] ?? 'CONTACT US';
        _heroIsRed = content['heroIsRed'] ?? false;

        _whyChooseTitleController.text = content['whyChooseTitle'] ?? 'Why Choose FIXXEV?';
        _whyChooseLabelController.text = content['whyChooseLabel'] ?? '// THE ADVANTAGE';
        _whyChoosePointsController.text = (content['whyChoosePoints'] as List?)?.join('\n') ?? 
          'Specialized for 2W, L3 and L5 Multi-brand electric vehicles.\nHigh-end diagnostics for CAN Bus and LIN protocols.\nISO-certified workshops ensuring dust-free environments.\nNational network of 100+ stores for cross-city warranty support.';

        _ctaTitleController.text = content['ctaTitle'] ?? 'Optimize Your EV’s Performance\nWith Precision Engineering';
        _ctaBtnTextController.text = content['ctaBtnText'] ?? 'BOOK AN APPOINTMENT';
        _ctaIsRed = content['ctaIsRed'] ?? false;

        final serviceBlocks = content['serviceBlocks'] as List?;
        _zigzagServices.clear();
        if (serviceBlocks != null && serviceBlocks.isNotEmpty) {
          for (var s in serviceBlocks) {
            _addServiceBlock(
              label: s['label'],
              title: s['title'],
              desc: s['description'],
              image: s['imageUrl'],
              items: (s['items'] as List?)?.cast<String>(),
            );
          }
        } else {
          _migrateOldServices();
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

  Future<void> _migrateOldServices() async {
    try {
      final oldServices = await _apiService.getServices();
      final fallbackImages = [
        'https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d',
        'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158',
        'https://images.unsplash.com/photo-1497366216548-37526070297c',
        'https://images.unsplash.com/photo-1593941707882-a5bba14938c7',
        'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158',
        'https://images.unsplash.com/photo-1497366216548-37526070297c',
      ];

      if (oldServices.isNotEmpty) {
        for (int i = 0; i < oldServices.length; i++) {
          final s = oldServices[i];
          if (s['status'] == 'Active') {
            final dbImage = s['image']?.toString() ?? '';
            _addServiceBlock(
              label: '// ${s['category']?.toUpperCase() ?? 'SERVICE'}',
              title: s['title'],
              desc: s['description'],
              image: dbImage.isNotEmpty ? dbImage : fallbackImages[i % fallbackImages.length],
              items: ['Professional Service', 'Certified Experts', 'Quality Parts'],
            );
          }
        }
      } else {
        _addServiceBlock(label: '// MAINTENANCE', title: 'Periodic Maintenance', desc: 'Comprehensive checkup and servicing.', image: fallbackImages[0]);
      }
    } catch (e) {}
  }

  Future<void> _saveContent() async {
    setState(() => _isSaving = true);
    try {
      final content = {
        'heroTitle': _heroTitleController.text,
        'heroTagline': _heroTaglineController.text,
        'heroImage': _heroImageController.text,
        'heroBtnText': _heroBtnTextController.text,
        'heroIsRed': _heroIsRed,
        'whyChooseTitle': _whyChooseTitleController.text,
        'whyChooseLabel': _whyChooseLabelController.text,
        'whyChoosePoints': _whyChoosePointsController.text.split('\n').where((s) => s.trim().isNotEmpty).toList(),
        'ctaTitle': _ctaTitleController.text,
        'ctaBtnText': _ctaBtnTextController.text,
        'ctaIsRed': _ctaIsRed,
        'serviceBlocks': _zigzagServices.map((s) => {
          'label': (s['label'] as TextEditingController).text,
          'title': (s['title'] as TextEditingController).text,
          'description': (s['description'] as TextEditingController).text,
          'imageUrl': (s['imageUrl'] as TextEditingController).text,
          'items': (s['items'] as TextEditingController).text.split('\n').where((item) => item.trim().isNotEmpty).toList(),
        }).toList(),
      };
      
      await _apiService.updatePageContent('services', content);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Services page updated!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving content: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _seedData() async {
    for (var service in _defaultServices) {
      await _apiService.createService(service);
    }
    _refreshServices();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Default services seeded successfully!')));
    }
  }

  Future<void> _deleteService(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text('Delete Service?', style: AppTextStyles.heading3),
        content: Text('This action cannot be undone.', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _apiService.deleteService(id);
        _refreshServices();
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _navigateToEdit([dynamic service]) async {
    final result = await Navigator.pushNamed(
      context, 
      service == null ? '/services/new' : '/services/edit',
      arguments: service,
    );
    if (result == true) {
      _refreshServices();
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
                            _buildServiceBlocks(),
                            const SizedBox(height: 32),
                            _buildWhyChooseSection(),
                            const SizedBox(height: 32),
                            _buildCTASection(),
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
              Text('Edit Services Page', style: AppTextStyles.heading2),
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
      title: '1. Services Hero',
      icon: Icons.title,
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
                   _buildTextField('Hero Tagline', _heroTaglineController),
                   const SizedBox(height: 16),
                   _buildTextField('Hero Image URL', _heroImageController, isImage: true),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildTextField('Main Title', _heroTitleController, maxLines: 2),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('Hero Button Text', _heroBtnTextController)),
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

  Widget _buildWhyChooseSection() {
    return _buildSectionCard(
      title: '2. Why Choose Section',
      icon: Icons.check_circle_outline,
      children: [
        _buildTextField('Section Title', _whyChooseTitleController),
        const SizedBox(height: 16),
        _buildTextField('Section Label', _whyChooseLabelController),
        const SizedBox(height: 16),
        _buildTextField('Points (One per line)', _whyChoosePointsController, maxLines: 5),
      ],
    );
  }

  Widget _buildCTASection() {
    return _buildSectionCard(
      title: '3. CTA Section',
      icon: Icons.campaign_outlined,
      children: [
        Row(
          children: [
            Expanded(child: _buildTextField('CTA Title', _ctaTitleController, maxLines: 2)),
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
        _buildTextField('Button Text', _ctaBtnTextController),
      ],
    );
  }

  Widget _buildServiceBlocks() {
    return _buildSectionCard(
      title: '4. Service Management Blocks',
      icon: Icons.electrical_services_outlined,
      children: [
        ...List.generate(_zigzagServices.length, (index) {
          final s = _zigzagServices[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.05))),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Service Card #${index+1}', style: const TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => setState(() => _zigzagServices.removeAt(index)), icon: const Icon(Icons.delete_outline, color: Colors.redAccent)),
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
                        _buildTextField('Service Category (Label)', s['label']!),
                        const SizedBox(height: 12),
                        _buildTextField('Image URL', s['imageUrl']!, isImage: true),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField('Service Title', s['title']!),
                const SizedBox(height: 16),
                _buildTextField('Description', s['description']!, maxLines: 3),
                const SizedBox(height: 16),
                _buildTextField('Features Checklist (One per line)', s['items']!, maxLines: 4),
              ],
            ),
          );
        }),
        Center(
          child: OutlinedButton.icon(
            onPressed: () => _addServiceBlock(), 
            icon: const Icon(Icons.add), 
            label: const Text('Add New Service Card')
          ),
        ),
      ],
    );
  }

  Widget _buildServicesManagementSection() {
    return _buildSectionCard(
      title: '4. Service Blocks (The Actual Services)',
      icon: Icons.grid_view_rounded,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Manage individual service cards displayed on the page', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
            Row(
              children: [
                TextButton.icon(
                  onPressed: _seedData,
                  icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                  label: const Text('Seed Default Data'),
                  style: TextButton.styleFrom(foregroundColor: Colors.orangeAccent),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _navigateToEdit(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add New Service'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          constraints: const BoxConstraints(minHeight: 200, maxHeight: 600),
          decoration: BoxDecoration(
            color: AppColors.sidebarDark.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: FutureBuilder<List<dynamic>>(
            future: _servicesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: AppColors.error)));
              }
              
              final services = snapshot.data ?? [];
              
              if (services.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline, size: 32, color: AppColors.textGrey),
                      const SizedBox(height: 12),
                      const Text('No services found. Click "Seed Default Data" to start.', style: TextStyle(color: AppColors.textGrey)),
                    ],
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                itemCount: services.length,
                separatorBuilder: (c, i) => Divider(height: 1, color: Colors.white.withOpacity(0.05)),
                itemBuilder: (context, index) {
                  final service = services[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: AppColors.backgroundDark, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.build_circle_outlined, color: AppColors.accentBlue, size: 20),
                    ),
                    title: Text(service['title'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: Text(service['description'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(service['status'] ?? '').withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: _getStatusColor(service['status'] ?? '').withOpacity(0.5)),
                          ),
                          child: Text(
                            service['status'] ?? 'Draft',
                            style: TextStyle(color: _getStatusColor(service['status'] ?? ''), fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(onPressed: () => _navigateToEdit(service), icon: const Icon(Icons.edit, color: AppColors.textGrey, size: 20)),
                        IconButton(onPressed: () => _deleteService(service['_id']), icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20)),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active': return AppColors.success;
      case 'Inactive': return AppColors.error;
      case 'Draft': return AppColors.warning;
      default: return AppColors.textMuted;
    }
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
}
