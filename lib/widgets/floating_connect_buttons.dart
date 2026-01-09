import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class FloatingConnectButtons extends StatefulWidget {
  final ScrollController scrollController;

  const FloatingConnectButtons({
    super.key,
    required this.scrollController,
  });

  @override
  State<FloatingConnectButtons> createState() => _FloatingConnectButtonsState();
}

class _FloatingConnectButtonsState extends State<FloatingConnectButtons> {
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (widget.scrollController.offset > 400 && !_showBackToTop) {
      setState(() => _showBackToTop = true);
    } else if (widget.scrollController.offset <= 400 && _showBackToTop) {
      setState(() => _showBackToTop = false);
    }
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOutQuart,
    );
  }

  void _openWhatsApp() async {
    final phoneNumber = AppConstants.phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final whatsappUrl = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      right: 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Scroll to Top Button
          AnimatedScale(
            scale: _showBackToTop ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedOpacity(
              opacity: _showBackToTop ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: FloatingActionButton.small(
                heroTag: 'scrollTop',
                onPressed: _scrollToTop,
                backgroundColor: AppColors.primaryNavy,
                child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // WhatsApp Button with Local Asset
          GestureDetector(
            onTap: _openWhatsApp,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF25D366).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  'assets/images/whatsapp_icon.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to green container with phone icon
                    return Container(
                      color: const Color(0xFF25D366),
                      child: const Icon(Icons.phone, color: Colors.white, size: 28),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
