import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/footer_widget.dart';
import '../../widgets/floating_connect_buttons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/subpage_hero.dart';
import '../../widgets/section_header.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  int _selectedFormIndex = 0; // 0: General, 1: Franchise

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final isScrolled = _scrollController.offset > 50;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
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
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Premium SubPage Hero
                const SubPageHero(
                  title: 'Contact Us',
                  tagline: 'Get In Touch',
                  imageUrl: 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?ixlib=rb-4.0.3&auto=format&fit=crop&w=2560&h=1440&q=80',
                ),
                
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 100,
                    horizontal: MediaQuery.of(context).size.width < 768 ? 20 : 80,
                  ),
                  color: Colors.white,
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        children: [
                          const SectionHeader(
                            title: 'Ready to Fix Your EV?',
                            subtitle: 'Visit our center or send us a message',
                            centered: true,
                          ),
                          const SizedBox(height: 60),
                          
                          // Form Toggle - Moved above the forms
                          Container(
                            constraints: const BoxConstraints(maxWidth: 600),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                _buildToggleButton(0, 'General Inquiry'),
                                _buildToggleButton(1, 'Franchise Application'),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 60),

                          LayoutBuilder(
                            builder: (context, constraints) {
                              // FRANCHISE MODE: Full width form
                              if (_selectedFormIndex == 1) {
                                return _buildFranchiseForm();
                              }

                              // GENERAL INQUIRY MODE: Contact Details + Form
                              if (constraints.maxWidth < 900) {
                                return Column(
                                  children: [
                                    _buildContactInfoGrid(),
                                    const SizedBox(height: 60),
                                    _buildContactForm(),
                                  ],
                                );
                              }
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left side: Contact Details
                                  Expanded(flex: 2, child: _buildContactInfoGrid()),
                                  const SizedBox(width: 80),
                                  // Right side: General Enquiry Form
                                  Expanded(flex: 3, child: _buildContactForm()),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Map Placeholder
                Container(
                  height: 400,
                  width: double.infinity,
                  color: AppColors.backgroundDark,
                  child: Stack(
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?ixlib=rb-4.0.3&auto=format&fit=crop&w=2560&q=80',
                        width: double.infinity,
                        height: 400,
                        fit: BoxFit.cover,
                        opacity: const AlwaysStoppedAnimation<double>(0.4),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on, color: AppColors.accentRed, size: 60),
                            const SizedBox(height: 20),
                            PrimaryButton(
                              text: 'OPEN IN GOOGLE MAPS',
                              onPressed: () {},
                              icon: Icons.map,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
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
              onMenuPressed: () {},
              onContactPressed: () {},
            ),
          ),
          
          FloatingConnectButtons(scrollController: _scrollController),
        ],
      ),
    );
  }

  Widget _buildContactInfoGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ContactInfoItem(
          icon: Icons.location_on,
          title: 'Visit Our HQ',
          detail: 'Plot No 24, IDA Nacharam, Hyderabad, Telangana - 500076',
        ),
        const SizedBox(height: 40),
        _ContactInfoItem(
          icon: Icons.phone_in_talk,
          title: 'Direct Support',
          detail: '+91 9848 123 456',
        ),
        const SizedBox(height: 40),
        _ContactInfoItem(
          icon: Icons.schedule,
          title: 'Working Hours',
          detail: 'Mon - Sat: 9:00 AM - 8:00 PM',
        ),
        const SizedBox(height: 40),
        _ContactInfoItem(
          icon: Icons.email_outlined,
          title: 'Email Inquiry',
          detail: 'info@evjazz.in',
        ),
        const SizedBox(height: 40),
        const Divider(),
        const SizedBox(height: 30),
        Text(
          'Connect With Us',
          style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _SocialIcon(Icons.facebook),
            const SizedBox(width: 16),
            _SocialIcon(Icons.camera_alt), // Instagram placeholder
            const SizedBox(width: 16),
            _SocialIcon(Icons.alternate_email), // Twitter/X placeholder
            const SizedBox(width: 16),
            _SocialIcon(Icons.business), // LinkedIn placeholder
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Follow us for the latest updates on EV technology and network expansion.',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey, height: 1.5),
        ),
      ],
    );
  }

  // Helper for Social Icons
  Widget _SocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primaryNavy,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }



  Widget _buildToggleButton(int index, String text) {
    final isSelected = _selectedFormIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFormIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryNavy : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))]
                : null,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppColors.textGrey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: AppColors.primaryNavy,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNavy.withAlpha(50),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SEND A MESSAGE',
            style: AppTextStyles.sectionTitleLight.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 40),
          _CustomTextField(hint: 'Full Name'),
          const SizedBox(height: 24),
          _CustomTextField(hint: 'Email Address'),
          const SizedBox(height: 24),
          _CustomTextField(hint: 'Subject'),
          const SizedBox(height: 24),
          _CustomTextField(hint: 'Message', maxLines: 5),
          const SizedBox(height: 40),
          PrimaryButton(
            text: 'SUBMIT REQUEST',
            onPressed: () {},
            icon: Icons.send_rounded,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

class _ContactInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;

  const _ContactInfoItem({required this.icon, required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.accentRed.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.accentRed),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
              Text(
                detail, 
                style: AppTextStyles.bodySmall,
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String hint;
  final int maxLines;

  const _CustomTextField({required this.hint, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}

  Widget _buildFranchiseForm() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800), // Limit width for better readability on desktop
        padding: const EdgeInsets.all(50),
        decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC), // Light Premium Grey Background
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNavy.withOpacity(0.1), // Blue-ish shadow
            blurRadius: 60,
            offset: const Offset(0, 20),
          ),
        ],
      ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryNavy.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Text('📝', style: TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Franchise Application',
                    style: AppTextStyles.sectionTitle.copyWith(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join the Fixx EV revolution. Fill in the details below.',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            
            _buildSectionContainer(
              title: 'Personal Details',
              icon: Icons.person_outline,
              child: Column(
                children: [
                  _FranchiseTextField(label: 'Full Name', placeholder: 'Enter your full name'),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 600) {
                         return Column(
                           children: [
                             _FranchiseTextField(label: 'Mobile Number', placeholder: '+91 00000 00000'),
                             const SizedBox(height: 16),
                             _FranchiseTextField(label: 'WhatsApp Number', placeholder: '+91 00000 00000'),
                           ],
                         );
                      }
                      return Row(
                        children: [
                          Expanded(child: _FranchiseTextField(label: 'Mobile Number', placeholder: '+91 00000 00000')),
                          const SizedBox(width: 20),
                          Expanded(child: _FranchiseTextField(label: 'WhatsApp Number', placeholder: '+91 00000 00000')),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _FranchiseTextField(label: 'Email ID', placeholder: 'yourname@example.com'),
                  const SizedBox(height: 16),
                  _FranchiseTextField(label: 'City & State', placeholder: 'e.g. Hyderabad, Telangana'),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            _buildSectionContainer(
              title: 'Investment Capacity',
              icon: Icons.attach_money,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('What is your planned investment?', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  _RadioGroup(
                    options: ['₹2 – 3 Lakhs', '₹3 – 5 Lakhs', '₹5 – 10 Lakhs', '₹10 Lakhs & above'],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            _buildSectionContainer(
              title: 'Business Interest',
              icon: Icons.business_center_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Which FIXX EV opportunity are you interested in?', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  _RadioGroup(
                    options: [
                      'EV Spares Franchise',
                      'EV Service Centre',
                      'Spares + Service Hub',
                      'District Franchise',
                      'Equity Partner'
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _buildSectionContainer(
              title: 'Location Details',
              icon: Icons.location_on_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _YesNoQuestion(question: 'Do you already have a commercial location?'),
                   const SizedBox(height: 20),
                   const Divider(height: 1),
                   const SizedBox(height: 20),
                   Text('If yes, size available:', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                   _RadioGroup(options: ['300–500 sq.ft', '500–1000 sq.ft', '1000+ sq.ft'], isHorizontal: true),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            _buildSectionContainer(
              title: 'Experience & Involvement',
              icon: Icons.work_outline,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _YesNoQuestion(question: 'Have you run a business before?'),
                   const SizedBox(height: 20),
                   _YesNoQuestion(question: 'Experience in automobile / EV / service industry?'),
                   const SizedBox(height: 20),
                   const Divider(height: 1),
                   const SizedBox(height: 20),
                   Text('How will you manage the franchise?', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                   const SizedBox(height: 12),
                   _RadioGroup(options: ['Full time', 'Part time', 'Through staff', 'With a partner']),
                ],
              ),
            ),
            
            const SizedBox(height: 30),

            _buildSectionContainer(
              title: 'Your Vision',
              icon: Icons.lightbulb_outline,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('Why do you want to join FIXX EV?', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                   const SizedBox(height: 12),
                   TextField(
                      maxLines: 4,
                      style: AppTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Share your business goals and why you think this is a good fit...',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryNavy, width: 2)),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryNavy.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryNavy.withOpacity(0.1)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: true, 
                      onChanged: (v) {}, 
                      activeColor: AppColors.primaryNavy,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'I confirm that I am genuinely interested in starting a FIXX EV Franchise and the information provided is above is correct to the best of my knowledge.',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 14, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            
            PrimaryButton(
              text: 'SUBMIT APPLICATION',
              onPressed: () {},
              width: double.infinity,
              backgroundColor: AppColors.primaryNavy,
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Our franchise team will contact you within 24 hours.',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContainer({required String title, required IconData icon, required Widget child}) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              color: AppColors.primaryNavy, // Dark Header!
              border: Border(bottom: BorderSide(color: AppColors.primaryNavy)),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.accentRed, size: 20), // Red Icon
                const SizedBox(width: 12),
                Text(
                  title,
                  style: AppTextStyles.cardTitle.copyWith(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White Text
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.cardTitle.copyWith(
        fontSize: 18, 
        color: AppColors.primaryNavy,
        fontWeight: FontWeight.bold
      ),
    );
  }

class _FranchiseTextField extends StatelessWidget {
  final String label;
  final String placeholder;

  const _FranchiseTextField({required this.label, required this.placeholder});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _RadioGroup extends StatefulWidget {
  final List<String> options;
  final bool isHorizontal;

  const _RadioGroup({required this.options, this.isHorizontal = false});

  @override
  State<_RadioGroup> createState() => _RadioGroupState();
}

class _RadioGroupState extends State<_RadioGroup> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    if (widget.isHorizontal) {
      return Wrap(
        spacing: 16,
        runSpacing: 8,
        children: widget.options.map((option) => _buildRadioItem(option)).toList(),
      );
    }
    return Column(
      children: widget.options.map((option) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: _buildRadioItem(option),
      )).toList(),
    );
  }

  Widget _buildRadioItem(String option) {
    final isSelected = _selected == option;
    return InkWell(
      onTap: () => setState(() => _selected = option),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryNavy : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? AppColors.primaryNavy.withOpacity(0.05) : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryNavy : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected 
                  ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.primaryNavy, shape: BoxShape.circle)))
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              option, 
              style: TextStyle(
                fontSize: 15, 
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primaryNavy : Colors.black87
              )
            ),
          ],
        ),
      ),
    );
  }
}

class _YesNoQuestion extends StatelessWidget {
  final String question;

  const _YesNoQuestion({required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 8),
        const _RadioGroup(options: ['Yes', 'No'], isHorizontal: true),
      ],
    );
  }
}


