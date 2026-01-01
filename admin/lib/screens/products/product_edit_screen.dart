import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:fixxev_admin/core/services/cloudinary_service.dart';
import 'package:image_picker/image_picker.dart';

class ProductEditScreen extends StatefulWidget {
  final Map<String, dynamic>? product;
  const ProductEditScreen({super.key, this.product});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final ApiService _apiService = ApiService();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  
  late TextEditingController _nameController;
  late TextEditingController _catController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _imgController;
  late TextEditingController _subtitleController;
  String _status = 'In Stock';
  
  bool _isUploading = false;
  bool _isSaving = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.product != null;
    _nameController = TextEditingController(text: _isEditing ? widget.product!['name'] : '');
    _catController = TextEditingController(text: _isEditing ? widget.product!['category'] : '');
    _priceController = TextEditingController(text: _isEditing ? widget.product!['price'] : '');
    _stockController = TextEditingController(text: _isEditing ? widget.product!['stock'] : '');
    _imgController = TextEditingController(text: _isEditing ? (widget.product!['image'] ?? '') : '');
    _subtitleController = TextEditingController(text: _isEditing ? (widget.product!['subtitle'] ?? '') : '');
    _status = _isEditing ? (widget.product!['status'] ?? 'In Stock') : 'In Stock';
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        setState(() => _isUploading = true);
        final url = await _cloudinaryService.uploadImage(image);
        
        if (mounted) {
          setState(() {
            _isUploading = false;
            if (url != null) {
              _imgController.text = url;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image uploaded!')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload failed. Check console for details.')));
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _saveProduct() async {
    if (_nameController.text.trim().isEmpty || 
        _catController.text.trim().isEmpty || 
        _priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in Name, Category, and Price.'))
      );
      return;
    }

    setState(() => _isSaving = true);
    
    final data = {
      'name': _nameController.text.trim(),
      'category': _catController.text.trim(),
      'price': _priceController.text.trim(),
      'stock': _stockController.text.trim(),
      'image': _imgController.text.trim(),
      'subtitle': _subtitleController.text.trim(),
      'status': _status,
    };

    try {
      if (_isEditing) {
        await _apiService.updateProduct(widget.product!['_id'], data);
      } else {
        await _apiService.createProduct(data);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? 'Product updated!' : 'Product added!'))
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          const AdminSidebar(currentRoute: '/products'),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildForm()),
                        const SizedBox(width: 32),
                        Expanded(flex: 2, child: _buildPreview()),
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
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Text(_isEditing ? 'Edit Product' : 'Add New Product', style: AppTextStyles.heading2),
            ],
          ),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveProduct,
            icon: _isSaving 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.save),
            label: Text(_isSaving ? 'Saving...' : 'Save Product'),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Product Name'),
          _buildTextField(_nameController, 'e.g. Smart Diagnostic Kit'),
          const SizedBox(height: 24),
          _buildLabel('Subtitle / Brief Description'),
          _buildTextField(_subtitleController, 'e.g. Professional tool for EV diagnosis'),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Category'),
                    _buildTextField(_catController, 'e.g. Tools, Infrastructure'),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Status'),
                    DropdownButtonFormField<String>(
                      value: _status,
                      dropdownColor: AppColors.cardDark,
                      style: AppTextStyles.bodyLarge,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.sidebarDark,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      items: ['In Stock', 'Low Stock', 'Out of Stock'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (val) => setState(() => _status = val!),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Price'),
                    _buildTextField(_priceController, 'e.g. ₹28,000'),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Stock Count'),
                    _buildTextField(_stockController, 'e.g. 150'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildLabel('Product Image'),
          Row(
            children: [
              Expanded(child: _buildTextField(_imgController, 'Paste image URL or upload...')),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _pickAndUploadImage,
                icon: _isUploading 
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.cloud_upload_outlined, size: 18),
                label: Text(_isUploading ? 'Uploading...' : 'Upload'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sidebarDark,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Product Card Preview'),
        const SizedBox(height: 12),
        Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.sidebarDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _imgController.text.isNotEmpty ? _imgController.text : 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=800',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: AppColors.sidebarDark,
                    child: const Icon(Icons.shopping_bag_outlined, size: 48, color: AppColors.textMuted),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_catController.text.isEmpty ? 'Category' : _catController.text, style: AppTextStyles.label),
                  _buildStatusBadge(_status),
                ],
              ),
              const SizedBox(height: 8),
              Text(_nameController.text.isEmpty ? 'Product Name' : _nameController.text, style: AppTextStyles.heading3),
              const SizedBox(height: 4),
              Text(_subtitleController.text.isEmpty ? 'Short subtitle...' : _subtitleController.text, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_priceController.text.isEmpty ? '₹0.00' : _priceController.text, style: AppTextStyles.heading3.copyWith(color: AppColors.accentRed)),
                  Text('Stock: ${_stockController.text.isEmpty ? '0' : _stockController.text}', style: AppTextStyles.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = AppColors.accentBlue;
    if (status == 'Out of Stock') color = AppColors.error;
    if (status == 'Low Stock') color = Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(status.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: AppTextStyles.label.copyWith(color: Colors.white)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: (_) => setState(() {}),
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.sidebarDark,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}
