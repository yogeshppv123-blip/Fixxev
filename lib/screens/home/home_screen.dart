import 'package:flutter/material.dart';
import 'package:fixxev/widgets/custom_app_bar.dart';
import 'package:fixxev/widgets/footer_widget.dart';
import 'sections/hero_slider_section.dart';
import 'sections/stats_bar_section.dart';
import 'sections/what_we_do_section.dart';
import 'sections/why_choose_us_section.dart';
import 'sections/about_us_section.dart';
import 'sections/services_section.dart';
import 'sections/testimonials_section.dart';
import 'sections/partners_carousel_section.dart';
import 'sections/join_mission_section.dart';

import 'package:fixxev/widgets/floating_connect_buttons.dart';

/// Main Home Screen with AUTORIX-style design and premium animations
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final isScrolled = _scrollController.offset > 50;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      drawer: const MobileDrawer(),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            controller: _scrollController,
            child: const Column(
              children: [
                // 1. Hero Carousel (High-res 4K)
                HeroSliderSection(),
                
                // 1.5 Stats Bar (Directly under Hero like Reference)
                StatsBarSection(),
                
                // 2. Why Choose Us (Experience Cards with Staggered Animation)
                WhatWeDoSection(),
                
                // 2.5 Why FIXXEV (Features + Book Service Form)
                WhyChooseUsSection(),
                
                // 3. About Us (Stats with Counter Animation)
                AboutUsSection(),
                
                // 4. Services Grid (Grid with Hover Color Shifts)
                ServicesSection(),
                
                // 5. Partners (Auto-scrolling logos)
                PartnersCarouselSection(),
                
                // 6. Testimonials (Animated Feedback Cards)
                TestimonialsSection(),
                
                // 7. Join the Mission (Opportunity Section)
                JoinMissionSection(),
                
                // 8. Footer (Hover links)
                FooterWidget(),
              ],
            ),
          ),
          
          // App Bar (Overlaid with nav link animations)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: CustomAppBar(
                isTransparent: !_isScrolled,
                onMenuPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                onContactPressed: () {
                  // Navigate to contact
                },
              ),
            ),
          ),

          // Floating Connect Buttons (Sticky and animated)
          FloatingConnectButtons(scrollController: _scrollController),
        ],
      ),
    );
  }
}
