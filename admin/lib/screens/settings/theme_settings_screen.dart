import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isSaving = false;
  Map<String, dynamic>? _settings;
  // Colors - Default Fixxev Electric Blue Theme
  Color _primaryColor = const Color(0xFF437BDC);    // Electric Blue
  Color _secondaryColor = const Color(0xFF2BC155);  // Fresh Green
  Color _accentColor = const Color(0xFF4E8AFF);     // Vibrant Blue
  Color _backgroundColor = const Color(0xFFFFFFFF); // White
  Color _cardColor = const Color(0xFFF7F9FC);       // Light Grey

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _apiService.getSettings();
      setState(() {
        _settings = settings;
        if (settings['theme'] != null) {
          final theme = settings['theme'];
          _primaryColor = _parseColor(theme['primaryColor'], const Color(0xFF437BDC));
          _secondaryColor = _parseColor(theme['secondaryColor'], const Color(0xFF2BC155));
          _accentColor = _parseColor(theme['accentColor'], const Color(0xFF4E8AFF));
          _backgroundColor = _parseColor(theme['backgroundColor'], const Color(0xFFFFFFFF));
          _cardColor = _parseColor(theme['cardColor'], const Color(0xFFF7F9FC));
        }
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading settings: $e'), backgroundColor: AppColors.error),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Color _parseColor(dynamic hex, Color fallback) {
    if (hex == null || hex is! String || hex.isEmpty) return fallback;
    try {
      final buffer = StringBuffer();
      if (hex.length == 6 || hex.length == 7) buffer.write('ff');
      buffer.write(hex.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return fallback;
    }
  }

  String _toHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    try {
      await _apiService.updateSettings({
        'theme': {
          'primaryColor': _toHex(_primaryColor),
          'secondaryColor': _toHex(_secondaryColor),
          'accentColor': _toHex(_accentColor),
          'backgroundColor': _toHex(_backgroundColor),
          'cardColor': _toHex(_cardColor),
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Theme settings saved successfully'), backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _buildColorTile(String label, Color color, Function(Color) onColorChanged) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sidebarDark),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, spreadRadius: 2),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(_toHex(color), style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showColorPicker(label, color, onColorChanged),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sidebarDark,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(String title, Color currentColor, Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pick $title'),
        backgroundColor: AppColors.cardDark,
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: onColorChanged,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done', style: TextStyle(color: AppColors.accentTeal)),
          ),
        ],
      ),
    );
  }

  Widget _buildThemePreset(String name, Color primary, Color secondary, Color accent, Color bg, Color card) {
    final isSelected = _primaryColor == primary && _secondaryColor == secondary;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _primaryColor = primary;
          _secondaryColor = secondary;
          _accentColor = accent;
          _backgroundColor = bg;
          _cardColor = card;
        });
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accentTeal : AppColors.sidebarDark,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(color: AppColors.accentTeal.withOpacity(0.3), blurRadius: 12, spreadRadius: 2),
          ] : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(6)),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(color: secondary, borderRadius: BorderRadius.circular(6)),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(6)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20, height: 20,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.black12),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 20, height: 20,
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.black12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(name, style: AppTextStyles.bodySmall.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.accentTeal : Colors.white,
            )),
            if (isSelected) ...[
              const SizedBox(height: 4),
              const Icon(Icons.check_circle, color: AppColors.accentTeal, size: 16),
            ],
          ],
        ),
      ),
    );
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
      drawer: isMobile ? const Drawer(child: AdminSidebar(currentRoute: '/theme-settings')) : null,
      appBar: isMobile ? AppBar(
        backgroundColor: AppColors.sidebarDark,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text('Theme', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            onPressed: _isSaving ? null : _saveSettings,
            icon: _isSaving 
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.save_outlined, color: Colors.white),
          ),
        ],
      ) : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile) const AdminSidebar(currentRoute: '/theme-settings'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMobile)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Theme Customization', style: AppTextStyles.heading1),
                            const SizedBox(height: 4),
                            Text('Customize the visual identity of your website', style: AppTextStyles.bodyMedium),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: _isSaving ? null : _saveSettings,
                          icon: _isSaving 
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.save_outlined),
                          label: Text(_isSaving ? 'Saving...' : 'Save Theme'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentTeal,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  
                  if (!isMobile) const SizedBox(height: 40),
                  
                  // Theme Presets Section
                  Text('Theme Presets', style: AppTextStyles.heading3),
                  const SizedBox(height: 8),
                  Text('Choose a preset theme or customize your own colors below', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildThemePreset(
                          'Fixxev Default',
                          const Color(0xFF437BDC),
                          const Color(0xFF2BC155),
                          const Color(0xFF4E8AFF),
                          const Color(0xFFFFFFFF),
                          const Color(0xFFF7F9FC),
                        ),
                        _buildThemePreset(
                          'Dark Mode',
                          const Color(0xFF1A1A2E),
                          const Color(0xFFE94560),
                          const Color(0xFF16213E),
                          const Color(0xFF0F0F0F),
                          const Color(0xFF1A1A2E),
                        ),
                        _buildThemePreset(
                          'Ocean Blue',
                          const Color(0xFF0077B6),
                          const Color(0xFF00B4D8),
                          const Color(0xFF90E0EF),
                          const Color(0xFFF8F9FA),
                          const Color(0xFFE0F7FA),
                        ),
                        _buildThemePreset(
                          'Sunset',
                          const Color(0xFFFF6B35),
                          const Color(0xFFF7C59F),
                          const Color(0xFFEFEFEF),
                          const Color(0xFFFFFBF5),
                          const Color(0xFFFFF0E5),
                        ),
                        _buildThemePreset(
                          'Forest',
                          const Color(0xFF2D6A4F),
                          const Color(0xFF52B788),
                          const Color(0xFF95D5B2),
                          const Color(0xFFF8FAF9),
                          const Color(0xFFE8F5E9),
                        ),
                        _buildThemePreset(
                          'Royal Purple',
                          const Color(0xFF5A189A),
                          const Color(0xFF9D4EDD),
                          const Color(0xFFC77DFF),
                          const Color(0xFFFAF5FF),
                          const Color(0xFFF3E8FF),
                        ),
                        _buildThemePreset(
                          'Elegant Black',
                          const Color(0xFF212121),
                          const Color(0xFFD4AF37),
                          const Color(0xFF757575),
                          const Color(0xFFFFFFFF),
                          const Color(0xFFFAFAFA),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  Text('Custom Colors', style: AppTextStyles.heading3),
                  const SizedBox(height: 8),
                  Text('Fine-tune each color individually', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 24),
                  
                  GridView.count(
                    crossAxisCount: isMobile ? 1 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: isMobile ? 3.5 : 2.5,
                    children: [
                      _buildColorTile('Primary Color', _primaryColor, (c) => setState(() => _primaryColor = c)),
                      _buildColorTile('Secondary Color', _secondaryColor, (c) => setState(() => _secondaryColor = c)),
                      _buildColorTile('Accent Color', _accentColor, (c) => setState(() => _accentColor = c)),
                      _buildColorTile('Background Color', _backgroundColor, (c) => setState(() => _backgroundColor = c)),
                      _buildColorTile('Card/Section Color', _cardColor, (c) => setState(() => _cardColor = c)),
                    ],
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Preview Section
                  Text('Quick Preview', style: AppTextStyles.heading3),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isMobile ? 16 : 32),
                    decoration: BoxDecoration(
                      color: _backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Website Header', style: TextStyle(color: _primaryColor, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(color: _primaryColor, borderRadius: BorderRadius.circular(8)),
                                child: const Text('Primary Button', style: TextStyle(color: Colors.white)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(color: _secondaryColor, borderRadius: BorderRadius.circular(8)),
                                child: const Text('Secondary Button', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Flex(
                          direction: isMobile ? Axis.vertical : Axis.horizontal,
                          children: [
                            if (isMobile) ...[
                             Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withOpacity(0.05))),
                                child: Column(
                                  children: [
                                    Container(width: 40, height: 40, decoration: BoxDecoration(color: _accentColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.star, color: _accentColor)),
                                    const SizedBox(height: 12),
                                    const Text('Feature Card', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withOpacity(0.05))),
                                child: Column(
                                  children: [
                                    Container(width: 40, height: 40, decoration: BoxDecoration(color: _accentColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.flash_on, color: _accentColor)),
                                    const SizedBox(height: 12),
                                    const Text('Performance', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ), 
                            ] else ...[
                               Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withOpacity(0.05))),
                                  child: Column(
                                    children: [
                                      Container(width: 40, height: 40, decoration: BoxDecoration(color: _accentColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.star, color: _accentColor)),
                                      const SizedBox(height: 12),
                                      const Text('Feature Card', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withOpacity(0.05))),
                                  child: Column(
                                    children: [
                                      Container(width: 40, height: 40, decoration: BoxDecoration(color: _accentColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.flash_on, color: _accentColor)),
                                      const SizedBox(height: 12),
                                      const Text('Performance', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ],
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
}
