import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Stats bar section with animated counters.
/// Disabled animations for mobile view for robust rendering.
class StatsBarSection extends StatefulWidget {
  final Map<String, dynamic> content;
  const StatsBarSection({super.key, required this.content});

  @override
  State<StatsBarSection> createState() => _StatsBarSectionState();
}

class _StatsBarSectionState extends State<StatsBarSection> {
  bool _shouldAnimate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _shouldAnimate = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    final stats = [
      {
        'value': widget.content['barStat1Value'] ?? '5,000+', 
        'label': widget.content['barStat1Label'] ?? 'Service Centers'
      },
      {
        'value': widget.content['barStat2Value'] ?? '500+', 
        'label': widget.content['barStat2Label'] ?? 'Partner Brands'
      },
      {
        'value': widget.content['barStat3Value'] ?? '8k+', 
        'label': widget.content['barStat3Label'] ?? 'Happy Customers'
      },
      {
        'value': widget.content['barStat4Value'] ?? '100%', 
        'label': widget.content['barStat4Label'] ?? 'Sustainability'
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 40 : 25,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: isMobile
          ? Column(
              children: stats.map((stat) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: _StaticStatItem(
                    value: stat['value']!,
                    label: stat['label']!,
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
                  animate: _shouldAnimate,
                  delay: entry.key * 100,
                );
              }).toList(),
            ),
    );
  }
}

class _StaticStatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StaticStatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.heroTitle.copyWith(
            color: AppColors.primaryNavy,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label.toUpperCase(),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textGrey,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
    final numericString = widget.value.replaceAll(RegExp(r'[^0-9]'), '');
    _targetValue = int.tryParse(numericString) ?? 0;
    
    if (widget.value.contains('+')) {
      _suffix = '+';
    } else if (widget.value.contains('%')) {
      _suffix = '%';
    }
  }

  String _formatNumber(int val) {
    if (widget.value.contains(',')) {
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
            color: AppColors.primaryNavy,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.label.toUpperCase(),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textGrey,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
