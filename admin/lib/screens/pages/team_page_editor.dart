import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';

class TeamPageEditor extends StatefulWidget {
  const TeamPageEditor({super.key});

  @override
  State<TeamPageEditor> createState() => _TeamPageEditorState();
}

class _TeamPageEditorState extends State<TeamPageEditor> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _membersFuture;
  bool _isLoading = true;
  bool _isSaving = false;

  final _heroTitleController = TextEditingController();
  final _heroTaglineController = TextEditingController();
  final _heroImageController = TextEditingController();
  final _sectionTitleController = TextEditingController();
  final _sectionSubtitleController = TextEditingController();

  final _defaultMembers = [
    {'name': 'Rajesh Kumar', 'role': 'Founder & CEO', 'image': 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=400'},
    {'name': 'Alex Rivera', 'role': 'EV Systems Engineer', 'image': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400'},
    {'name': 'Sarah Chen', 'role': 'Battery Specialist', 'image': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400'},
    {'name': 'Mark Thompson', 'role': 'Diagnostics Expert', 'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400'},
    {'name': 'Priya Singh', 'role': 'Operations Head', 'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400'},
    {'name': 'Vikram Malhotra', 'role': 'Service Manager', 'image': 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400'},
  ];

  @override
  void initState() {
    super.initState();
    _loadContent();
    _refreshTeam();
  }

  Future<void> _loadContent() async {
    try {
      final data = await _apiService.getPageContent('team');
      final content = data['content'] ?? {};
      
      setState(() {
        _heroTitleController.text = content['heroTitle'] ?? 'Meet Our Experts';
        _heroTaglineController.text = content['heroTagline'] ?? 'Technical Leadership';
        _heroImageController.text = content['heroImage'] ?? 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?ixlib=rb-4.0.3&auto=format&fit=crop&w=2560&h=1440&q=80';
        _sectionTitleController.text = content['sectionTitle'] ?? 'Technical Specialists';
        _sectionSubtitleController.text = content['sectionSubtitle'] ?? 'Certified engineers dedicated to your EV';
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveContent() async {
    setState(() => _isSaving = true);
    try {
      final content = {
        'heroTitle': _heroTitleController.text,
        'heroTagline': _heroTaglineController.text,
        'heroImage': _heroImageController.text,
        'sectionTitle': _sectionTitleController.text,
        'sectionSubtitle': _sectionSubtitleController.text,
      };
      
      await _apiService.updatePageContent('team', content);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Team page content updated!')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _refreshTeam() {
    setState(() {
      _membersFuture = _apiService.getTeam();
    });
  }

  Future<void> _seedData() async {
    for (var member in _defaultMembers) {
      await _apiService.createTeamMember(member);
    }
    await _apiService.updatePageContent('team', {
      'heroTitle': _heroTitleController.text,
      'heroTagline': _heroTaglineController.text,
      'heroImage': _heroImageController.text,
      'sectionTitle': _sectionTitleController.text,
      'sectionSubtitle': _sectionSubtitleController.text,
    });
    _refreshTeam();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Default team members seeded!')));
    }
  }

  Future<void> _navigateToEdit([dynamic member]) async {
    final result = await Navigator.pushNamed(
      context, 
      member == null ? '/team/new' : '/team/edit',
      arguments: member,
    );
    if (result == true) {
      await _apiService.updatePageContent('team', {
        'heroTitle': _heroTitleController.text,
        'heroTagline': _heroTaglineController.text,
        'heroImage': _heroImageController.text,
        'sectionTitle': _sectionTitleController.text,
        'sectionSubtitle': _sectionSubtitleController.text,
      });
      _refreshTeam();
    }
  }

  Future<void> _deleteMember(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text('Delete Member?', style: AppTextStyles.heading3),
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
        await _apiService.deleteTeamMember(id);
        await _apiService.updatePageContent('team', {
          'heroTitle': _heroTitleController.text,
          'heroTagline': _heroTaglineController.text,
          'heroImage': _heroImageController.text,
          'sectionTitle': _sectionTitleController.text,
          'sectionSubtitle': _sectionSubtitleController.text,
        });
        _refreshTeam();
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

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
        title: Text('Edit Team Page', style: AppTextStyles.heading3),
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
                              title: 'Team Section Header',
                              icon: Icons.text_fields,
                              children: [
                                _buildTextField('Main Heading', _sectionTitleController),
                                const SizedBox(height: 16),
                                _buildTextField('Subheading/Description', _sectionSubtitleController),
                              ],
                            ),
                            const SizedBox(height: 32),
                            // Header Row for Team Members
                            isMobile 
                              ? Column(
                                  children: [
                                    Text('Individual Team Members', style: AppTextStyles.heading3),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextButton.icon(
                                          onPressed: _seedData,
                                          icon: const Icon(Icons.cloud_upload, size: 18),
                                          label: const Text('Seed Defaults'),
                                        ),
                                        const SizedBox(width: 16),
                                        ElevatedButton.icon(
                                          onPressed: () => _navigateToEdit(),
                                          icon: const Icon(Icons.person_add, size: 18),
                                          label: const Text('Add Member'),
                                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentBlue),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Individual Team Members', style: AppTextStyles.heading3),
                                    Row(
                                      children: [
                                        TextButton.icon(
                                          onPressed: _seedData,
                                          icon: const Icon(Icons.cloud_upload, size: 18),
                                          label: const Text('Seed Defaults'),
                                        ),
                                        const SizedBox(width: 16),
                                        ElevatedButton.icon(
                                          onPressed: () => _navigateToEdit(),
                                          icon: const Icon(Icons.person_add, size: 18),
                                          label: const Text('Add Member'),
                                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentBlue),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                            const SizedBox(height: 24),
                            _buildTeamContent(isMobile),
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
              Text('Edit Team Page', style: AppTextStyles.heading2),
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

  Widget _buildTeamContent(bool isMobile) {
    return FutureBuilder<List<dynamic>>(
      future: _membersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          ));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: AppColors.error)));
        }

        final members = snapshot.data ?? [];

        if (members.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                const Icon(Icons.group_outlined, size: 64, color: AppColors.textGrey),
                const SizedBox(height: 16),
                Text('No team members found.', style: AppTextStyles.bodyMedium),
              ],
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 1 : 4,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: isMobile ? 1.0 : 0.85,
          ),
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            return Container(
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.sidebarDark),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.network(
                      member['image'] ?? '',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80, height: 80, color: AppColors.sidebarDark,
                        child: const Icon(Icons.person, size: 40, color: AppColors.textGrey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(member['name'] ?? '', style: AppTextStyles.heading3.copyWith(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(member['role'] ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentBlue)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.textGrey),
                        onPressed: () => _navigateToEdit(member),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                        onPressed: () => _deleteMember(member['_id']),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
