import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:file_picker/file_picker.dart';

class ProductsPageEditor extends StatefulWidget {
  const ProductsPageEditor({super.key});

  @override
  State<ProductsPageEditor> createState() => _ProductsPageEditorState();
}

class _ProductsPageEditorState extends State<ProductsPageEditor> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isSaving = false;

  final _heroTitleController = TextEditingController();
  final _heroTaglineController = TextEditingController();
  final _heroImageController = TextEditingController();
  final _heroBtnTextController = TextEditingController();
  bool _heroIsRed = false;

  final List<Map<String, dynamic>> _productBlocks = [];

  @override
  void initState() {
    super.initState();
    _heroImageController.addListener(() => setState(() {}));
    _loadContent();
  }

  @override
  void dispose() {
    _heroTitleController.dispose();
    _heroTaglineController.dispose();
    _heroImageController.dispose();
    _heroBtnTextController.dispose();
    for (var p in _productBlocks) {
      (p['imageUrl'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  void _addProductBlock({String? title, String? subtitle, String? image, List<String>? features}) {
    final imageController = TextEditingController(text: image ?? '');
    imageController.addListener(() => setState(() {}));
    
    setState(() {
      _productBlocks.add({
        'title': TextEditingController(text: title ?? ''),
        'subtitle': TextEditingController(text: subtitle ?? ''),
        'imageUrl': imageController,
        'features': TextEditingController(text: (features ?? []).join('\n')),
      });
    });
  }

  Future<void> _loadContent() async {
    try {
      final data = await _apiService.getPageContent('products');
      final content = data['content'] ?? {};
      
      setState(() {
        _heroTitleController.text = content['heroTitle'] ?? 'Cutting-Edge EV Solutions';
        _heroTaglineController.text = content['heroTagline'] ?? 'PREMIUM INFRASTRUCTURE';
        _heroImageController.text = content['heroImage'] ?? 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d';
        _heroBtnTextController.text = content['heroBtnText'] ?? 'INQUIRE NOW';
        _heroIsRed = content['heroIsRed'] ?? false;

        final productBlocks = content['productBlocks'] as List?;
        _productBlocks.clear();
        if (productBlocks != null && productBlocks.isNotEmpty) {
          for (var p in productBlocks) {
            _addProductBlock(
              title: p['title'],
              subtitle: p['subtitle'],
              image: p['imageUrl'],
              features: (p['features'] as List?)?.cast<String>(),
            );
          }
        } else {
          _migrateOldProducts();
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

  Future<void> _migrateOldProducts() async {
    try {
      final oldProducts = await _apiService.getProducts();
      final fallbackImages = [
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
        'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d',
        'https://images.unsplash.com/photo-1581092160562-40aa08e78837',
      ];
      
      if (oldProducts.isNotEmpty) {
        for (int i = 0; i < oldProducts.length; i++) {
          final p = oldProducts[i];
          final dbImage = p['image']?.toString() ?? '';
          _addProductBlock(
            title: p['name'],
            subtitle: p['description'] ?? '${p['category']} - ${p['price']}',
            image: dbImage.isNotEmpty ? dbImage : fallbackImages[i % fallbackImages.length],
            features: [
              'Status: ${p['status'] ?? 'Active'}',
              'Stock: ${p['stock'] ?? 'In Stock'}',
              'Direct OEM Quality',
              'Nationwide Support'
            ],
          );
        }
      } else {
        _addProductBlock(title: 'Diagnostic Tool Kit', subtitle: 'Smart professional diagnostic kit for all EV types.', image: fallbackImages[0]);
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
        'productBlocks': _productBlocks.map((p) => {
          'title': (p['title'] as TextEditingController).text,
          'subtitle': (p['subtitle'] as TextEditingController).text,
          'imageUrl': (p['imageUrl'] as TextEditingController).text,
          'features': (p['features'] as TextEditingController).text.split('\n').where((f) => f.trim().isNotEmpty).toList(),
        }).toList(),
      };
      
      await _apiService.updatePageContent('products', content);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Products page header updated!')));
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
        title: Text('Edit Products Page', style: AppTextStyles.heading3),
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
                            _buildHeroSection(isMobile),
                            const SizedBox(height: 32),
                            _buildProductBlocks(isMobile),
                            const SizedBox(height: 100),
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

  Widget _buildHeroSection(bool isMobile) {
    return _buildSectionCard(
      title: '1. Products Hero',
      icon: Icons.store_outlined,
      children: [
        isMobile ? Column(
          children: [
            Container(
              height: 200, width: double.infinity,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.1))),
              child: _heroImageController.text.isNotEmpty
                  ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(_heroImageController.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)))
                  : const Icon(Icons.image_outlined, color: Colors.white24, size: 40),
            ),
            const SizedBox(height: 16),
            _buildTextField('Hero Tagline', _heroTaglineController),
            const SizedBox(height: 16),
            _buildTextField('Hero Image URL', _heroImageController, isImage: true),
          ],
        ) : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.1))),
              child: _heroImageController.text.isNotEmpty
                  ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(_heroImageController.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)))
                  : const Icon(Icons.image_outlined, color: Colors.white24, size: 40),
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
        const SizedBox(height: 16),
        _buildTextField('Main Title', _heroTitleController, maxLines: 2),
        const SizedBox(height: 16),
        isMobile ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Hero Button Text', _heroBtnTextController),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Red Theme', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                Switch(value: _heroIsRed, onChanged: (v) => setState(() => _heroIsRed = v), activeColor: Colors.redAccent),
              ],
            ),
          ],
        ) : Row(
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

  Widget _buildProductBlocks(bool isMobile) {
    return _buildSectionCard(
      title: '2. Product Management Blocks',
      icon: Icons.inventory_2_outlined,
      children: [
        ...List.generate(_productBlocks.length, (index) {
          final p = _productBlocks[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.05))),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Product Card #${index+1}', style: const TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => setState(() => _productBlocks.removeAt(index)), icon: const Icon(Icons.delete_outline, color: Colors.redAccent)),
                ]),
                const SizedBox(height: 16),
                isMobile ? Column(
                  children: [
                    Container(
                      height: 150, width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.1))),
                      child: p['imageUrl']!.text.isNotEmpty
                          ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(p['imageUrl']!.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)))
                          : const Icon(Icons.image_outlined, color: Colors.white24),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField('Image URL', p['imageUrl']!, isImage: true),
                  ],
                ) : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.1))),
                      child: p['imageUrl']!.text.isNotEmpty
                          ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(p['imageUrl']!.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white24)))
                          : const Icon(Icons.image_outlined, color: Colors.white24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField('Image URL', p['imageUrl']!, isImage: true),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField('Product Name', p['title']!),
                const SizedBox(height: 16),
                _buildTextField('Description / Subtitle', p['subtitle']!, maxLines: 2),
                const SizedBox(height: 16),
                _buildTextField('Features (One per line)', p['features']!, maxLines: 4),
              ],
            ),
          );
        }),
        Center(
          child: OutlinedButton.icon(
            onPressed: () => _addProductBlock(), 
            icon: const Icon(Icons.add), 
            label: const Text('Add New Product Card')
          ),
        ),
      ],
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
              Text('Edit Products Page', style: AppTextStyles.heading2),
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

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, bool isImage = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label.copyWith(color: AppColors.textGrey, fontSize: 12)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.sidebarDark,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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
