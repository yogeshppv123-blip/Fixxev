import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/buttons/primary_button.dart';

class WhyChooseUsSection extends StatefulWidget {
  final Map<String, dynamic> content;
  const WhyChooseUsSection({super.key, required this.content});

  @override
  State<WhyChooseUsSection> createState() => _WhyChooseUsSectionState();
}

class _WhyChooseUsSectionState extends State<WhyChooseUsSection> {
  final ApiService _apiService = ApiService();
  bool _isSubmitting = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.content;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1593941707882-a5bba14938c7?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80'), // Road/Nature theme
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.6), // Dark overlay
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 80,
          vertical: 100,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: isMobile
                ? Column(
                    children: [
                      _buildFeaturesList(true),
                      const SizedBox(height: 60),
                      _buildContactForm(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: _buildFeaturesList(false),
                      ),
                      const SizedBox(width: 80),
                      Expanded(
                        flex: 4,
                        child: _buildContactForm(),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesList(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.content['whyTitle'] ?? 'Why Choose Us',
          style: AppTextStyles.sectionTitleLight.copyWith(
            fontSize: isMobile ? 32 : 44,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Container(width: 60, height: 4, color: AppColors.accentRed),
        const SizedBox(height: 32),
        Text(
          widget.content['whyDesc'] ?? 'At FIXXEV, we provide an ecosystem that ensures your electric vehicle remains in peak condition through skilled engineering and genuine support.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white.withOpacity(0.9),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 48),
        _buildFeatureItem(
          icon: Icons.shield_outlined,
          title: widget.content['whyBullet1Title'] ?? 'Commitment To Sustainability',
          description: widget.content['whyBullet1Desc'] ?? 'Expanding high-quality EV support to accelerate green mobility.',
        ),
        const SizedBox(height: 32),
        _buildFeatureItem(
          icon: Icons.biotech_outlined,
          title: widget.content['whyBullet2Title'] ?? 'Advanced Diagnostics',
          description: widget.content['whyBullet2Desc'] ?? 'Using next-gen tools to ensure precise and efficient repairs.',
        ),
        const SizedBox(height: 32),
        _buildFeatureItem(
          icon: Icons.handyman_outlined,
          title: widget.content['whyBullet3Title'] ?? 'Skilled Technician Support',
          description: widget.content['whyBullet3Desc'] ?? 'Professionally trained experts dedicated to EV longevity.',
        ),
        const SizedBox(height: 32),
        _buildFeatureItem(
          icon: Icons.layers_outlined,
          title: widget.content['whyBullet4Title'] ?? 'Quality Controlled Spares',
          description: widget.content['whyBullet4Desc'] ?? 'OEM-certified components for reliable and safe performance.',
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.accentTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.accentTeal, size: 28),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.cardTitle.copyWith(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8), // Light Blue tint instead of green
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Book Your Service',
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 24, color: AppColors.primaryNavy),
          ),
          const SizedBox(height: 32),
          _buildField('Name', controller: _nameController),
          const SizedBox(height: 16),
          _buildField('Email', controller: _emailController),
          const SizedBox(height: 16),
          _buildField('Contact Number', controller: _phoneController),
          const SizedBox(height: 16),
          _buildField('Your Message', maxLines: 4, controller: _messageController),
          const SizedBox(height: 32),
          PrimaryButton(
            text: _isSubmitting ? 'SENDING...' : 'SEND REQUEST',
            onPressed: _isSubmitting ? () {} : _submitRequest,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildField(String hint, {int maxLines = 1, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Future<void> _submitRequest() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in Name and Contact Number')),
        );
      }
      return;
    }

    setState(() => _isSubmitting = true);
    
    final success = await _apiService.submitLead({
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'type': 'Contact',
      'message': 'Service Booking Request: ${_messageController.text}',
    });

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service request sent successfully!')),
        );
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _messageController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send request.')),
        );
      }
    }
  }
}

