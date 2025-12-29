import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';

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
                onPressed: _scrollToTop,
                backgroundColor: AppColors.primaryNavy,
                child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // WhatsApp / Connect Button
          FloatingActionButton(
            onPressed: () {
              // Action for connect
            },
            backgroundColor: const Color(0xFF25D366), // WhatsApp Green
            child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
