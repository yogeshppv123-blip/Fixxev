import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/footer_widget.dart';
import '../../widgets/floating_connect_buttons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/subpage_hero.dart';
import '../../widgets/section_header.dart';

import '../../core/services/api_service.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _teamFuture;
  bool _isScrolled = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _teamFuture = _apiService.getTeam();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final isScrolled = _scrollController.offset > 50;
      if (isScrolled != _isScrolled) {
        setState(() {
          _isScrolled = isScrolled;
        });
      }
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
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                FutureBuilder<Map<String, dynamic>>(
                  future: _apiService.getPageContent('team'),
                  builder: (context, contentSnapshot) {
                    final content = contentSnapshot.data?['content'] ?? {};
                    return Column(
                      children: [
                        SubPageHero(
                          title: content['heroTitle'] ?? 'Meet Our Experts',
                          tagline: content['heroTagline'] ?? 'Technical Leadership',
                          imageUrl: content['heroImage'] ?? 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?ixlib=rb-4.0.3&auto=format&fit=crop&w=2560&h=1440&q=80',
                        ),
                        
                        FutureBuilder<List<dynamic>>(
                          future: _teamFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox(
                                height: 400,
                                child: Center(child: CircularProgressIndicator())
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            }

                            final members = snapshot.data ?? [];
                            
                            // Group members
                            final coreTeam = members.where((m) => (m['category'] ?? 'Our Core Team') == 'Our Core Team').toList();
                            final technicalTeam = members.where((m) => m['category'] == 'Technical Team').toList();

                            return Column(
                              children: [
                                // Core Team Section
                                if (coreTeam.isNotEmpty)
                                  _buildTeamGrid(
                                    title: 'Our Core Team',
                                    subtitle: 'The visionary leadership driving FIXXEV forward',
                                    members: coreTeam,
                                  ),

                                // Technical Team Section
                                if (technicalTeam.isNotEmpty)
                                  _buildTeamGrid(
                                    title: 'Technical Team',
                                    subtitle: 'Certified engineers and diagnostics experts',
                                    members: technicalTeam,
                                    bgColor: const Color(0xFFF8F9FA),
                                  ),
                                
                                if (members.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 100),
                                    child: Center(child: Text('No team members found.')),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  }
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
              isTransparent: false,
              useLightText: false,
              onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              onContactPressed: () {},
            ),
          ),
          
          FloatingConnectButtons(scrollController: _scrollController),
        ],
      ),
    );
  }

  Widget _buildTeamGrid({
    required String title,
    required String subtitle,
    required List<dynamic> members,
    Color bgColor = Colors.white,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: bgColor,
      child: Column(
        children: [
          SectionHeader(
            title: title,
            subtitle: subtitle,
            centered: true,
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: members.map((m) => _TeamMemberCard(
              name: m['name'] ?? '',
              role: m['role'] ?? '',
              image: m['image'],
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _TeamMemberCard extends StatefulWidget {
  final String name;
  final String role;
  final String? image;

  const _TeamMemberCard({required this.name, required this.role, this.image});

  @override
  State<_TeamMemberCard> createState() => _TeamMemberCardState();
}

class _TeamMemberCardState extends State<_TeamMemberCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: 300,
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -10.0 : 0.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(_isHovered ? 20 : 10),
              blurRadius: _isHovered ? 30 : 20,
              offset: Offset(0, _isHovered ? 15 : 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 320,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryNavy.withAlpha(10),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: widget.image != null && widget.image!.isNotEmpty
                    ? Image.network(
                        widget.image!,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(
                            Icons.person,
                            size: 100,
                            color: AppColors.primaryNavy.withAlpha(50),
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.person,
                          size: 100,
                          color: AppColors.primaryNavy.withAlpha(50),
                        ),
                      ),
                ),
                if (_isHovered)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryNavy.withAlpha(150),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialIcon(icon: Icons.link),
                          const SizedBox(width: 12),
                          _SocialIcon(icon: Icons.email_outlined),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(widget.name, style: AppTextStyles.cardTitle.copyWith(fontSize: 20)),
                  const SizedBox(height: 8),
                  Text(
                    widget.role.toUpperCase(),
                    style: AppTextStyles.sectionLabel.copyWith(
                      fontSize: 11,
                      letterSpacing: 1.5,
                      color: AppColors.accentRed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  const _SocialIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}
