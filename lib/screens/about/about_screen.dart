import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/footer_widget.dart';
import '../../widgets/floating_connect_buttons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../core/services/api_service.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();
  List<dynamic> _sections = [];
  Map<String, dynamic> _pageContent = {};
  bool _isLoading = true;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final sections = await _apiService.getAboutSections();
      final pageContent = await _apiService.getPageContent('about');
      if (mounted) {
        setState(() {
          _sections = sections.where((s) => s['isActive'] == true).toList();
          _pageContent = pageContent;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
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

  Map<String, dynamic>? _getSectionByType(String type) {
    try {
      return _sections.firstWhere((s) => s['type'] == type) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final valuesSection = _getSectionByType('Values');
    final csrSection = _getSectionByType('CSR');
    final visionSection = _getSectionByType('Vision');
    final futureSection = _getSectionByType('Future');

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      // 1. LIGHT HERO - Launch Announcement
                      _AboutHeroLight(
                        title: _pageContent['title'] ?? 'Driving India’s EV Future 🔋',
                        tagline: 'LAUNCH ANNOUNCEMENT',
                        description1: _pageContent['desc1'] ?? 'Fixx EV Technologies Pvt. Ltd. is on a mission to solve one of the biggest barriers to electric vehicle adoption in India — reliable after-sales service and spares availability.',
                        description2: _pageContent['desc2'] ?? 'As India rapidly moves towards electric mobility, the service ecosystem has remained fragmented. At Fixx EV we are building a nationwide, standardized EV after-sales network by appointing 500 Authorized Franchise Service Centres.',
                        imageUrl: 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?auto=format&fit=crop&q=80&w=2000',
                      ),

                      // 2. STATS BAR
                      _AboutStatsBar(),

                      // 3. SECTIONS (User Requested Content)
                      
                      // Dynamic Sections (Infrastructure, Franchise, Values, etc.)
                      ..._sections
                          .asMap()
                          .entries
                          .map((entry) {
                        final section = entry.value;
                        return _AboutZigZagBlock(
                          image: section['imageUrl']?.isNotEmpty == true 
                              ? section['imageUrl'] 
                              : 'https://images.unsplash.com/photo-1522071820081-009f0129c71c',
                          title: section['title'] ?? '',
                          label: section['label'] ?? '',
                          description: section['description'] ?? '',
                          items: (section['items'] as List?)?.cast<String>() ?? const [],
                          isReversed: entry.key.isOdd,
                        );
                      }),

                      // CTA Section
                      _AboutCTASection(),

                      const FooterWidget(),
                    ],
                  ),
                ),
                
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: CustomAppBar(
                    isTransparent: false,
                    backgroundColor: AppColors.navDark,
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
}

class _AboutHeroLight extends StatelessWidget {
  final String title;
  final String tagline;
  final String description1;
  final String description2;
  final String imageUrl;

  const _AboutHeroLight({
    required this.title,
    required this.tagline,
    required this.description1,
    required this.description2,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Container(
      padding: EdgeInsets.only(top: isMobile ? 80 : 120, bottom: 60),
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: isMobile ? 24 : 80, right: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tagline.toUpperCase(),
                        style: AppTextStyles.sectionLabel.copyWith(
                          color: AppColors.accentTeal,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        title,
                        style: AppTextStyles.heading1.copyWith(
                          color: AppColors.textDark,
                          fontSize: isMobile ? 32 : 48,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildRichParagraph(description1),
                      const SizedBox(height: 16),
                      _buildRichParagraph(description2),
                      const SizedBox(height: 32),
                      PrimaryButton(
                        text: 'GET IN TOUCH →',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              if (!isMobile)
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), bottomLeft: Radius.circular(24)),
                    child: Image.network(
                      imageUrl,
                      height: 500,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRichParagraph(String text) {
    final spans = <TextSpan>[];
    final boldRegex = RegExp(r'\*\*(.+?)\*\*');
    int lastEnd = 0;

    for (final match in boldRegex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(text: match.group(1), style: const TextStyle(fontWeight: FontWeight.bold)));
      lastEnd = match.end;
    }
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return RichText(
      text: TextSpan(
        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textMuted, height: 1.7),
        children: spans,
      ),
    );
  }
}

class _AboutStatsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final stats = [
      {'value': '20+', 'label': 'Years Experience'},
      {'value': '500+', 'label': 'Vehicles Serviced'},
      {'value': '50+', 'label': 'Trained Technicians'},
      {'value': '10+', 'label': 'Cities Covered'},
    ];
    return Container(
      width: double.infinity,
      color: AppColors.navDark,
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: isMobile ? 16 : 80),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: 32,
        runSpacing: 24,
        children: stats.map((stat) {
          return Column(
            children: [
              Text(stat['value']!, style: AppTextStyles.heading1.copyWith(color: AppColors.accentTeal, fontSize: isMobile ? 32 : 48)),
              const SizedBox(height: 8),
              Text(stat['label']!, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _AboutZigZagBlock extends StatelessWidget {
  final String image;
  final String title;
  final String label;
  final String description;
  final List<String> items;
  final bool isReversed;
  final Color? backgroundColor;

  const _AboutZigZagBlock({
    required this.image,
    required this.title,
    required this.label,
    required this.description,
    required this.items,
    required this.isReversed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    final textContent = Padding(
      padding: EdgeInsets.all(isMobile ? 24 : 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.sectionLabel.copyWith(
              color: AppColors.primary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.primary,
              fontSize: isMobile ? 24 : 32,
            ),
          ),
          Container(
            width: 60,
            height: 3,
            margin: const EdgeInsets.only(top: 12, bottom: 24),
            color: AppColors.primary,
          ),
          _buildRichParagraph(description),
          const SizedBox(height: 24),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, color: AppColors.accentTeal, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text(item, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted))),
              ],
            ),
          )),
        ],
      ),
    );

    final imageContent = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        image,
        height: isMobile ? 300 : 450,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: isMobile ? 300 : 450,
          color: Colors.grey[200],
          child: const Icon(Icons.image, size: 48, color: Colors.grey),
        ),
      ),
    );

    if (isMobile) {
      return Container(
        color: backgroundColor ?? Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(children: [imageContent, textContent]),
      );
    }

    return Container(
      color: backgroundColor ?? Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
      child: Row(
        children: isReversed
            ? [Expanded(child: imageContent), const SizedBox(width: 48), Expanded(child: textContent)]
            : [Expanded(child: textContent), const SizedBox(width: 48), Expanded(child: imageContent)],
      ),
    );
  }

  Widget _buildRichParagraph(String text) {
    final spans = <TextSpan>[];
    final boldRegex = RegExp(r'\*\*(.+?)\*\*');
    int lastEnd = 0;

    for (final match in boldRegex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(text: match.group(1), style: const TextStyle(fontWeight: FontWeight.bold)));
      lastEnd = match.end;
    }
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return RichText(
      text: TextSpan(
        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textMuted, height: 1.7),
        children: spans,
      ),
    );
  }
}

class _AboutCTASection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: AppColors.navDark,
      child: Column(
        children: [
          Text(
            'Ready to Join the EV Revolution?',
            style: AppTextStyles.heading2.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Partner with FIXXEV for reliable EV servicing and support.',
            style: AppTextStyles.bodyLarge.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: 'CONTACT US',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
