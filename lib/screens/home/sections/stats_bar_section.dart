import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Stats bar section with animated counters
class StatsBarSection extends StatefulWidget {
  final Map<String, dynamic> content;
  const StatsBarSection({super.key, required this.content});

  @override
  State<StatsBarSection> createState() => _StatsBarSectionState();
}

class _StatsBarSectionState extends State<StatsBarSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    final stats = [
      {
        'value': widget.content['stat1Value'] ?? '5,000+', 
        'label': widget.content['stat1Label'] ?? 'Total Satisfied Clients'
      },
      {
        'value': widget.content['stat2Value'] ?? '500+', 
        'label': widget.content['stat2Label'] ?? 'Authorized Centres'
      },
      {
        'value': widget.content['stat3Value'] ?? '90%', 
        'label': widget.content['stat3Label'] ?? 'Positive Response Rate'
      },
      {
        'value': widget.content['stat4Value'] ?? '100%', 
        'label': widget.content['stat4Label'] ?? 'Commitment To Sustainability'
      },
    ];

    return VisibilityDetector(
      key: const Key('stats_bar_visibility'),
      onVisibilityChanged: (info) {
        if (!mounted) return;
        if (info.visibleFraction > 0.2 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        } else if (info.visibleFraction < 0.1 && _isVisible) {
          setState(() {
            _isVisible = false;
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 60,
          vertical: isMobile ? 40 : 60,
        ),
        decoration: const BoxDecoration(
          color: AppColors.primaryNavy, // Darker theme like FIXXEV stats
        ),
        child: isMobile
            ? Column(
                children: stats.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: _StatItem(
                      value: entry.value['value']!,
                      label: entry.value['label']!,
                      animate: _isVisible,
                      delay: entry.key * 200,
                    ),
                  );
                }).toList(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: stats.asMap().entries.map((entry) {
                  return _StatItem(
                    value: entry.value['value']!,
                    label: entry.value['label']!,
                    animate: _isVisible,
                    delay: entry.key * 200,
                  );
                }).toList(),
              ),
      ),
    );
  }
}

class _StatItem extends StatefulWidget {
  final String value;
  final String label;
  final bool animate;
  final int delay;

  const _StatItem({
    required this.value,
    required this.label,
    required this.animate,
    this.delay = 0,
  });

  @override
  State<_StatItem> createState() => _StatItemState();
}

class _StatItemState extends State<_StatItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentValue = 0;
  int _targetValue = 0;
  String _prefix = '';
  String _suffix = '';

  @override
  void initState() {
    super.initState();
    _parseValue();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _animation = Tween<double>(begin: 0, end: _targetValue.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo),
    )..addListener(() {
        if (mounted) {
          setState(() {
            _currentValue = _animation.value.toInt();
          });
        }
      });
  }

  void _parseValue() {
    // Extract numbers and suffixes like +, %
    final numericString = widget.value.replaceAll(RegExp(r'[^0-9]'), '');
    _targetValue = int.tryParse(numericString) ?? 0;
    
    if (widget.value.contains('+')) {
      _suffix = '+';
    } else if (widget.value.contains('%')) {
      _suffix = '%';
    }
    
    // Check for comma in original string to maintain formatting
    if (widget.value.contains(',')) {
      _prefix = ''; // For comma we use number formatting
    }
  }

  String _formatNumber(int val) {
    if (widget.value.contains(',')) {
      // Very basic comma formatting for thousands
      String s = val.toString();
      if (s.length > 3) {
        return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
      }
      return s;
    }
    return val.toString();
  }

  @override
  void didUpdateWidget(_StatItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) _controller.forward();
      });
    } else if (!widget.animate && oldWidget.animate) {
      _controller.reset();
      setState(() {
        _currentValue = 0;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$_prefix${_formatNumber(_currentValue)}$_suffix',
          style: AppTextStyles.heroTitle.copyWith(
            color: AppColors.accentRed,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.label.toUpperCase(),
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withOpacity(0.8),
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
