import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';

import 'package:fixxev_admin/core/services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ApiService _apiService = ApiService();
  final _siteNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = true;
  
  bool _maintenanceMode = false;
  bool _emailNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _apiService.getSettings();
      setState(() {
        _siteNameController.text = settings['siteName'] ?? '';
        _emailController.text = settings['contactEmail'] ?? '';
        _phoneController.text = settings['contactPhone'] ?? '';
        _maintenanceMode = settings['maintenanceMode'] ?? false;
        _emailNotifications = settings['emailNotifications'] ?? true;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading settings: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);
    try {
      await _apiService.updateSettings({
        'siteName': _siteNameController.text,
        'contactEmail': _emailController.text,
        'contactPhone': _phoneController.text,
        'maintenanceMode': _maintenanceMode,
        'emailNotifications': _emailNotifications,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved successfully!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving settings: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundDark,
      drawer: isMobile ? const Drawer(child: AdminSidebar(currentRoute: '/settings')) : null,
      appBar: isMobile ? AppBar(
        backgroundColor: AppColors.sidebarDark,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text('Settings', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save, color: Colors.white),
          ),
        ],
      ) : null,
      body: Row(
        children: [
          if (!isMobile) const AdminSidebar(currentRoute: '/settings'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMobile) ...[
                    Text('Settings', style: AppTextStyles.heading1),
                    const SizedBox(height: 32),
                  ],
                  
                  // General Settings Section
                  _buildSectionCard(
                    title: 'General Settings',
                    icon: Icons.settings,
                    children: [
                      _buildTextField('Site Name', _siteNameController),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // System Preferences
                  _buildSectionCard(
                    title: 'System Preferences',
                    icon: Icons.tune,
                    children: [
                      SwitchListTile(
                        title: Text('Maintenance Mode', style: AppTextStyles.bodyLarge),
                        subtitle: Text('Disable public access to the website temporarily', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey)),
                        value: _maintenanceMode,
                        onChanged: (val) => setState(() => _maintenanceMode = val),
                        activeColor: AppColors.accentRed,
                        contentPadding: EdgeInsets.zero,
                      ),
                      const Divider(color: AppColors.sidebarDark),
                      SwitchListTile(
                        title: Text('Email Notifications', style: AppTextStyles.bodyLarge),
                        subtitle: Text('Receive daily summaries of new leads', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey)),
                        value: _emailNotifications,
                        onChanged: (val) => setState(() => _emailNotifications = val),
                        activeColor: AppColors.accentRed,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Save Button (Desktop)
                  if (!isMobile)
                    SizedBox(
                      width: 200,
                      child: ElevatedButton.icon(
                        onPressed: _saveSettings,
                        icon: const Icon(Icons.save),
                        label: const Text('Save Changes'),
                      ),
                    ),
                ],
              ),
            ),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accentRed),
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
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
