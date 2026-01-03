import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:file_picker/file_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  final _nameController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String? _profileImageUrl;
  bool _isLoading = true;
  bool _isSavingProfile = false;
  bool _isChangingPassword = false;

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _apiService.getProfile();
      setState(() {
        _nameController.text = profile['name'] ?? 'Admin';
        _profileImageUrl = profile['profileImage'];
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading profile: $e')));
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uploading image...')));
          final url = await _apiService.uploadImage(file.bytes!, file.name);
          setState(() {
            _profileImageUrl = url;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image uploaded successfully!')));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  Future<void> _updateProfile() async {
    setState(() => _isSavingProfile = true);
    try {
      await _apiService.updateProfile({
        'name': _nameController.text,
        'profileImage': _profileImageUrl,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSavingProfile = false);
    }
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    if (_newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password must be at least 6 characters')));
      return;
    }

    setState(() => _isChangingPassword = true);
    try {
      await _apiService.changePassword(
        _oldPasswordController.text,
        _newPasswordController.text,
      );
      if (mounted) {
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed successfully!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isChangingPassword = false);
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
      drawer: isMobile ? const Drawer(child: AdminSidebar(currentRoute: '/profile')) : null,
      appBar: isMobile ? AppBar(
        backgroundColor: AppColors.sidebarDark,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text('Admin Profile', style: AppTextStyles.heading3),
      ) : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile) const AdminSidebar(currentRoute: '/profile'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMobile)
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Text('Admin Profile', style: AppTextStyles.heading1),
                      ],
                    ),
                  const SizedBox(height: 32),
                  
                  Flex(
                    direction: isMobile ? Axis.vertical : Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Left Column: Profile Info
                      Container(
                        width: isMobile ? double.infinity : null,
                        constraints: isMobile ? null : const BoxConstraints(maxWidth: 600),
                        child:  _buildCard(
                          title: 'Profile Information',
                          icon: Icons.person_outline,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor: AppColors.sidebarDark,
                                  backgroundImage: _profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null,
                                  child: _profileImageUrl == null 
                                    ? const Icon(Icons.person, size: 60, color: AppColors.textMuted)
                                    : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 60,
                                  right: 0,
                                  child: Center(
                                    child: InkWell(
                                      onTap: _pickAndUploadImage,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                          color: AppColors.accentRed,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            _buildTextField('Full Name', _nameController),
                            const SizedBox(height: 12),
                            const Text('Note: This name and image will be visible in the dashboard.', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isSavingProfile ? null : _updateProfile,
                                child: _isSavingProfile ? const CircularProgressIndicator(color: Colors.white) : const Text('Save Profile'),
                              ),
                            ),
                          ],
                        ),
                      ),
                       // Added resizing logic indirectly by using container wrapper
                       if (!isMobile) const SizedBox(width: 32),
                       if (isMobile) const SizedBox(height: 24),

                      // Right Column: Change Password
                      Container(
                        width: isMobile ? double.infinity : null,
                         constraints: isMobile ? null : const BoxConstraints(maxWidth: 400),
                        child: _buildCard(
                          title: 'Security',
                          icon: Icons.lock_outline,
                          children: [
                            _buildTextField(
                              'Current Password', 
                              _oldPasswordController, 
                              obscureText: _obscureOld,
                              onToggle: () => setState(() => _obscureOld = !_obscureOld),
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              'New Password', 
                              _newPasswordController, 
                              obscureText: _obscureNew,
                              onToggle: () => setState(() => _obscureNew = !_obscureNew),
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              'Confirm New Password', 
                              _confirmPasswordController, 
                              obscureText: _obscureConfirm,
                              onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isChangingPassword ? null : _changePassword,
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.sidebarDark),
                                child: _isChangingPassword ? const CircularProgressIndicator(color: Colors.white) : const Text('Update Password'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.sidebarDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accentRed, size: 24),
              const SizedBox(width: 12),
              Text(title, style: AppTextStyles.heading3),
            ],
          ),
          const SizedBox(height: 32),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false, VoidCallback? onToggle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label.copyWith(fontSize: 12)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.sidebarDark,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: onToggle != null ? IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: AppColors.textMuted),
              onPressed: onToggle,
            ) : null,
          ),
        ),
      ],
    );
  }
}
