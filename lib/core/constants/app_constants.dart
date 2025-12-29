/// FIXXEV App Constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'FIXXEV';
  static const String appTagline = 'Complete EV Care';
  static const String appDescription =
      'India\'s first tech-driven ecosystem for electric vehicles, providing seamless services, innovative solutions, and expert support for EV owners and operators.';

  // Contact Info
  static const String phoneNumber = '+91 74004 44013';
  static const String email = 'support@fixxev.com';
  static const String website = 'www.fixxev.com';
  static const String address = 'Mumbai, Maharashtra, India';

  // Social Media
  static const String instagramUrl = 'https://www.instagram.com/fixxev/';
  static const String linkedinUrl = 'https://www.linkedin.com/company/fixxev/';
  static const String whatsappUrl = 'https://wa.me/917400444013';

  // Hero Slides Content
  static const List<Map<String, String>> heroSlides = [
    {
      'title': 'FIXXEV – The Future of\nElectric Vehicle Service',
      'subtitle':
          'India\'s first AIOT-powered EV service platform, designed to provide seamless maintenance, real-time diagnostics, and expert support.',
      'buttonText': 'Contact Us',
    },
    {
      'title': 'One Platform,\nComplete EV Care',
      'subtitle':
          'From advanced diagnostics to 24/7 roadside assistance, FIXXEV offers a full spectrum of services to keep your EV running smoothly.',
      'buttonText': 'Know More',
    },
    {
      'title': 'Smart, Reliable &\nFuture-Ready Solutions',
      'subtitle':
          'AIOT-based predictive maintenance, reducing turnaround time and enhancing service efficiency for all EV users.',
      'buttonText': 'Our Services',
    },
  ];

  // Stats
  static const List<Map<String, dynamic>> stats = [
    {'value': 5000, 'suffix': '+', 'label': 'Happy Customers'},
    {'value': 90, 'suffix': '%', 'label': 'Resolution Rate'},
    {'value': 100, 'suffix': '%', 'label': 'Sustainability'},
  ];

  // Services
  static const List<Map<String, String>> services = [
    {
      'icon': 'settings',
      'title': 'Technology-Driven Maintenance',
      'description':
          'Advanced AIOT-powered systems for real-time tracking and diagnostics.',
    },
    {
      'icon': 'engineering',
      'title': 'Expert Technicians',
      'description':
          'Skilled professionals with over 20 years of combined experience in EV maintenance.',
    },
    {
      'icon': 'support_agent',
      'title': 'Roadside Assistance',
      'description':
          'Quick and reliable support, including mobile charging vans, whenever needed.',
    },
    {
      'icon': 'security',
      'title': 'Insurance Solutions',
      'description':
          'Comprehensive coverage for both electric vehicles and their batteries.',
    },
    {
      'icon': 'ev_station',
      'title': 'Charging Network',
      'description':
          'Convenient charging stations integrated across all service points.',
    },
    {
      'icon': 'inventory_2',
      'title': 'Spare Parts Availability',
      'description': 'A one-stop platform for sourcing EV components and parts.',
    },
  ];

  // Why Choose Us
  static const List<Map<String, String>> whyChooseUs = [
    {
      'icon': 'lightbulb',
      'title': 'Innovation at the Core',
      'description':
          'First to introduce AIOT-powered service platform with real-time tracking and optimized delivery.',
    },
    {
      'icon': 'speed',
      'title': 'Seamless & Efficient Service',
      'description':
          'Guaranteed turnaround times with a zero-failure service record.',
    },
    {
      'icon': 'verified',
      'title': 'Expertise You Can Trust',
      'description': 'A team of experts with over 20 years of experience in EVs.',
    },
    {
      'icon': 'eco',
      'title': 'Commitment to Sustainability',
      'description':
          'Supporting electric mobility with eco-friendly and future-ready solutions.',
    },
  ];

  // Testimonials
  static const List<Map<String, dynamic>> testimonials = [
    {
      'name': 'Rahul Sharma',
      'review':
          'FIXXEV transformed my EV ownership experience. Quick service, transparent pricing, and professional technicians!',
      'rating': 5,
      'reviews': 642,
    },
    {
      'name': 'Priya Patel',
      'review':
          'The roadside assistance saved me twice! Their response time is incredible and the team is very helpful.',
      'rating': 5,
      'reviews': 356,
    },
    {
      'name': 'Amit Kumar',
      'review':
          'Best EV service platform in India. The AIOT diagnostics helped identify issues before they became problems.',
      'rating': 5,
      'reviews': 853,
    },
    {
      'name': 'Sneha Reddy',
      'review':
          'Reliable, efficient, and eco-conscious. FIXXEV is exactly what the EV industry needed!',
      'rating': 5,
      'reviews': 248,
    },
  ];

  // Navigation Items
  static const List<Map<String, String>> navItems = [
    {'label': 'Home', 'route': '/'},
    {'label': 'About', 'route': '/about'},
    {'label': 'Services', 'route': '/services'},
    {'label': 'Products', 'route': '/products'},
    {'label': 'Blog', 'route': '/blog'},
    {'label': 'Contact', 'route': '/contact'},
  ];
}
