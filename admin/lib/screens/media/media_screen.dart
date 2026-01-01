import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:fixxev_admin/core/services/cloudinary_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  final ApiService _apiService = ApiService();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  late Future<List<dynamic>> _mediaFuture;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _refreshMedia();
  }

  void _refreshMedia() async {
    setState(() {
      _mediaFuture = _apiService.getMedia();
    });
    
    // Auto-seed if empty
    final items = await _mediaFuture;
    if (items.isEmpty && mounted) {
      await _apiService.seedMedia();
      _refreshMedia();
    }
  }

  Future<void> _uploadMedia() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        setState(() => _isUploading = true);
        final url = await _cloudinaryService.uploadImage(image);
        
        if (url != null) {
          await _apiService.createMedia({
            'url': url,
            'fileName': image.name,
            'fileType': 'image',
          });
          _refreshMedia();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Media uploaded and saved!')));
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload failed.')));
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _deleteMedia(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text('Delete Media?', style: AppTextStyles.heading3),
        content: const Text('This will remove it from the library.', style: TextStyle(color: AppColors.textGrey)),
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
        await _apiService.deleteMedia(id);
        _refreshMedia();
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _copyToClipboard(String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard!'), duration: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          const AdminSidebar(currentRoute: '/media'),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Media Library', style: AppTextStyles.heading1),
                          const SizedBox(height: 4),
                          Text('Manage your images and assets', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey)),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: _isUploading ? null : _uploadMedia,
                        icon: _isUploading 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.upload_file),
                        label: Text(_isUploading ? 'Uploading...' : 'Upload New'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentRed,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Media Grid
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: _mediaFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: AppColors.error)));
                      }

                      final mediaItems = snapshot.data ?? [];

                      if (mediaItems.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_search, size: 64, color: AppColors.textGrey.withOpacity(0.5)),
                              const SizedBox(height: 16),
                              Text('No media found', style: AppTextStyles.heading3.copyWith(color: AppColors.textGrey)),
                              const SizedBox(height: 8),
                              const Text('Upload your first asset to get started', style: TextStyle(color: AppColors.textMuted)),
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: 1,
                        ),
                        itemCount: mediaItems.length,
                        itemBuilder: (context, index) {
                          final item = mediaItems[index];
                          return _MediaCard(
                            url: item['url'] ?? '',
                            onDelete: () => _deleteMedia(item['_id']),
                            onCopy: () => _copyToClipboard(item['url'] ?? ''),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaCard extends StatefulWidget {
  final String url;
  final VoidCallback onDelete;
  final VoidCallback onCopy;

  const _MediaCard({
    required this.url,
    required this.onDelete,
    required this.onCopy,
  });

  @override
  State<_MediaCard> createState() => _MediaCardState();
}

class _MediaCardState extends State<_MediaCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _isHovered ? AppColors.accentRed.withOpacity(0.5) : AppColors.sidebarDark),
          boxShadow: _isHovered ? [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))] : [],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                widget.url,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, color: AppColors.textMuted)),
              ),
            ),
            
            // Overlay on hover
            if (_isHovered)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: widget.onCopy,
                        icon: const Icon(Icons.copy, color: Colors.white),
                        tooltip: 'Copy Link',
                      ),
                      const SizedBox(height: 8),
                      IconButton(
                        onPressed: widget.onDelete,
                        icon: const Icon(Icons.delete_outline, color: AppColors.error),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ),
              ),
            
            // Small badge if not hovered to show it's interactive
            if (!_isHovered)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.more_horiz, color: Colors.white, size: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
