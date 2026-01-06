import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';

class ContactPageEditor extends StatefulWidget {
  const ContactPageEditor({super.key});

  @override
  State<ContactPageEditor> createState() => _ContactPageEditorState();
}

class _ContactPageEditorState extends State<ContactPageEditor> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isSaving = false;

  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _mapUrlController = TextEditingController();
  
  final _heroTitleController = TextEditingController();
  final _heroTaglineController = TextEditingController();
  final _heroImageController = TextEditingController();
  
  final _sectionTitleController = TextEditingController();
  final _sectionSubtitleController = TextEditingController();
  final _workingHoursController = TextEditingController();
  final _mapImageController = TextEditingController();
  
  final _facebookController = TextEditingController();
  final _instagramController = TextEditingController();
  final _twitterController = TextEditingController();
  final _linkedinController = TextEditingController();
  
  final _addressTitleController = TextEditingController();
  final _phoneTitleController = TextEditingController();
  final _workingHoursTitleController = TextEditingController();
  final _emailTitleController = TextEditingController();
  final _mapButtonTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final data = await _apiService.getPageContent('contact');
      final content = data['content'] ?? {};
      
      setState(() {
        _addressController.text = content['address'] ?? 'Plot No. 45, Sector 18, Gurgaon, Haryana';
        _emailController.text = content['email'] ?? 'support@fixxev.com';
        _phoneController.text = content['phone'] ?? '+91 9876543210';
        _mapUrlController.text = content['mapUrl'] ?? '';
        
        _heroTitleController.text = content['heroTitle'] ?? 'Contact Us';
        _heroTaglineController.text = content['heroTagline'] ?? 'Get In Touch';
        _heroImageController.text = content['heroImage'] ?? 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?ixlib=rb-4.0.3&auto=format&fit=crop&w=2560&h=1440&q=80';
        
        _sectionTitleController.text = content['sectionTitle'] ?? 'Ready to Fix Your EV?';
        _sectionSubtitleController.text = content['sectionSubtitle'] ?? 'Visit our center or send us a message';
        _workingHoursController.text = content['workingHours'] ?? 'Mon - Sat: 9:00 AM - 8:00 PM';
        _mapImageController.text = content['mapImage'] ?? 'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?ixlib=rb-4.0.3&auto=format&fit=crop&w=2560&q=80';
        
        _facebookController.text = content['facebook'] ?? '';
        _instagramController.text = content['instagram'] ?? '';
        _twitterController.text = content['twitter'] ?? '';
        _linkedinController.text = content['linkedin'] ?? '';
        
        _addressTitleController.text = content['addressTitle'] ?? 'Visit Our HQ';
        _phoneTitleController.text = content['phoneTitle'] ?? 'Direct Support';
        _workingHoursTitleController.text = content['workingHoursTitle'] ?? 'Working Hours';
        _emailTitleController.text = content['emailTitle'] ?? 'Email Inquiry';
        _mapButtonTextController.text = content['mapButtonText'] ?? 'OPEN IN GOOGLE MAPS';
        
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
        'address': _addressController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'mapUrl': _mapUrlController.text,
        'heroTitle': _heroTitleController.text,
        'heroTagline': _heroTaglineController.text,
        'heroImage': _heroImageController.text,
        'sectionTitle': _sectionTitleController.text,
        'sectionSubtitle': _sectionSubtitleController.text,
        'workingHours': _workingHoursController.text,
        'mapImage': _mapImageController.text,
        'facebook': _facebookController.text,
        'instagram': _instagramController.text,
        'twitter': _twitterController.text,
        'linkedin': _linkedinController.text,
        'addressTitle': _addressTitleController.text,
        'phoneTitle': _phoneTitleController.text,
        'workingHoursTitle': _workingHoursTitleController.text,
        'emailTitle': _emailTitleController.text,
        'mapButtonText': _mapButtonTextController.text,
      };
      
      await _apiService.updatePageContent('contact', content);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact page content updated!')));
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
        title: Text('Edit Contact Page', style: AppTextStyles.heading3),
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
                            _buildSectionCard(
                              title: 'Hero Section',
                              icon: Icons.image_outlined,
                              children: [
                                _buildTextField('Hero Title', _heroTitleController),
                                const SizedBox(height: 16),
                                _buildTextField('Hero Tagline', _heroTaglineController),
                                const SizedBox(height: 16),
                                _buildTextField('Hero Image URL', _heroImageController),
                              ],
                            ),
                            const SizedBox(height: 32),
                            _buildSectionCard(
                              title: 'Section Header',
                              icon: Icons.text_fields,
                              children: [
                                _buildTextField('Main Title', _sectionTitleController),
                                const SizedBox(height: 16),
                                _buildTextField('Subtitle/Description', _sectionSubtitleController),
                              ],
                            ),
                            const SizedBox(height: 32),
                            _buildSectionCard(
                              title: 'Contact Information',
                              icon: Icons.contact_page_outlined,
                              children: [
                                if (isMobile) ...[
                                  _buildTextField('Address Section Title', _addressTitleController),
                                  const SizedBox(height: 12),
                                  _buildTextField('Office Address', _addressController, maxLines: 2),
                                  const SizedBox(height: 16),
                                  _buildTextField('Phone Section Title', _phoneTitleController),
                                  const SizedBox(height: 12),
                                  _buildTextField('Phone Number', _phoneController),
                                  const SizedBox(height: 16),
                                  _buildTextField('Email Section Title', _emailTitleController),
                                  const SizedBox(height: 12),
                                  _buildTextField('Support Email', _emailController),
                                  const SizedBox(height: 16),
                                  _buildTextField('Working Hours Title', _workingHoursTitleController),
                                  const SizedBox(height: 12),
                                  _buildTextField('Working Hours', _workingHoursController),
                                ] else ...[
                                  Row(
                                    children: [
                                      Expanded(child: _buildTextField('Address Section Title', _addressTitleController)),
                                      const SizedBox(width: 16),
                                      Expanded(child: _buildTextField('Office Address', _addressController, maxLines: 2)),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(child: _buildTextField('Phone Section Title', _phoneTitleController)),
                                      const SizedBox(width: 16),
                                      Expanded(child: _buildTextField('Phone Number', _phoneController)),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(child: _buildTextField('Email Section Title', _emailTitleController)),
                                      const SizedBox(width: 16),
                                      Expanded(child: _buildTextField('Support Email', _emailController)),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(child: _buildTextField('Working Hours Title', _workingHoursTitleController)),
                                      const SizedBox(width: 16),
                                      Expanded(child: _buildTextField('Working Hours', _workingHoursController)),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 24),
                                _buildTextField('Google Maps Link', _mapUrlController, maxLines: 2),
                                const SizedBox(height: 16),
                                _buildTextField('Map Button Text', _mapButtonTextController),
                                const SizedBox(height: 16),
                                _buildTextField('Map Section Background Image URL', _mapImageController),
                              ],
                            ),
                            const SizedBox(height: 32),
                            _buildSectionCard(
                              title: 'Social Media Links',
                              icon: Icons.share_outlined,
                              children: [
                                _buildTextField('Facebook URL', _facebookController),
                                const SizedBox(height: 16),
                                _buildTextField('Instagram URL', _instagramController),
                                const SizedBox(height: 16),
                                _buildTextField('Twitter/X URL', _twitterController),
                                const SizedBox(height: 16),
                                _buildTextField('LinkedIn URL', _linkedinController),
                                const SizedBox(height: 100),
                              ],
                            ),
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
              Text('Edit Contact Page', style: AppTextStyles.heading2),
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
