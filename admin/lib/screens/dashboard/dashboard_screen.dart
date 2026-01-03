import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/widgets/stat_card.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:fixxev_admin/core/utils/time_utils.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  late Future<dynamic> _statsFuture;

  @override
  void initState() {
    super.initState();
    _refreshStats();
  }

  void _refreshStats() {
    setState(() {
      _statsFuture = _apiService.getDashboardStats();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundDark,
      drawer: isMobile ? const Drawer(child: AdminSidebar(currentRoute: '/dashboard')) : null,
      appBar: isMobile ? AppBar(
        backgroundColor: AppColors.sidebarDark,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text('Dashboard', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshStats,
          ),
        ],
      ) : null,
      body: Row(
        children: [
          if (!isMobile) const AdminSidebar(currentRoute: '/dashboard'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: FutureBuilder<dynamic>(
                future: _statsFuture,
                builder: (context, snapshot) {
                  final stats = snapshot.data ?? {
                    'servicesCount': 0,
                    'productsCount': 0,
                    'teamCount': 0,
                    'blogsCount': 0,
                  };

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header (desktop only)
                      if (!isMobile)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dashboard', style: AppTextStyles.heading1),
                                const SizedBox(height: 4),
                                Text('Welcome back, ${_apiService.currentAdmin?['name'] ?? 'Admin'}', style: AppTextStyles.bodyMedium),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.refresh, color: Colors.white),
                                  onPressed: _refreshStats,
                                  tooltip: 'Refresh Stats',
                                ),
                                const SizedBox(width: 16),
                                _buildUserMenu(),
                              ],
                            ),
                          ],
                        ),
                      if (!isMobile) const SizedBox(height: 40),
                      
                      // Mobile welcome message
                      if (isMobile) ...[
                        Text('Welcome back, ${_apiService.currentAdmin?['name'] ?? 'Admin'}', style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 24),
                      ],

                      if (snapshot.hasError)
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.error.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: AppColors.error),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Error loading stats: ${snapshot.error}',
                                  style: TextStyle(color: AppColors.error),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Stats - responsive grid
                      if (isMobile)
                        _buildMobileStats(stats)
                      else
                        Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                title: 'Total Services',
                                value: stats['servicesCount'].toString(),
                                icon: Icons.settings_suggest_outlined,
                                color: AppColors.info,
                                trend: 'Live',
                                trendUp: true,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: StatCard(
                                title: 'Blog Posts',
                                value: stats['blogsCount'].toString(),
                                icon: Icons.article_outlined,
                                color: AppColors.success,
                                trend: 'Live',
                                trendUp: true,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: StatCard(
                                title: 'Products',
                                value: stats['productsCount'].toString(),
                                icon: Icons.inventory_2_outlined,
                                color: AppColors.warning,
                                trend: 'Live',
                                trendUp: null,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: StatCard(
                                title: 'Team Members',
                                value: stats['teamCount'].toString(),
                                icon: Icons.people_outline,
                                color: AppColors.accentRed,
                                trend: 'Live',
                                trendUp: true,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 32),
                      _buildOverviewChart(stats['leadsChartData'] ?? []),
                      const SizedBox(height: 32),
                      
                      // Recent leads and quick actions - responsive
                      if (isMobile) ...[
                        _buildQuickActions(context),
                        const SizedBox(height: 24),
                        _buildRecentLeads(stats['recentLeads'] ?? []),
                      ] else
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: _buildRecentLeads(stats['recentLeads'] ?? [])),
                            const SizedBox(width: 24),
                            Expanded(child: _buildQuickActions(context)),
                          ],
                        ),
                    ],
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileStats(Map<String, dynamic> stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Services',
                value: stats['servicesCount'].toString(),
                icon: Icons.settings_suggest_outlined,
                color: AppColors.info,
                trend: 'Live',
                trendUp: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Blog Posts',
                value: stats['blogsCount'].toString(),
                icon: Icons.article_outlined,
                color: AppColors.success,
                trend: 'Live',
                trendUp: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Products',
                value: stats['productsCount'].toString(),
                icon: Icons.inventory_2_outlined,
                color: AppColors.warning,
                trend: 'Live',
                trendUp: null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Team',
                value: stats['teamCount'].toString(),
                icon: Icons.people_outline,
                color: AppColors.accentRed,
                trend: 'Live',
                trendUp: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserMenu() {
    final admin = _apiService.currentAdmin;
    final name = admin?['name'] ?? 'Admin';
    final imageUrl = admin?['profileImage'];

    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      color: AppColors.cardDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'profile') {
          Navigator.pushNamed(context, '/profile').then((_) => setState(() {}));
        } else if (value == 'logout') {
          _apiService.logout();
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              const Icon(Icons.person_outline, size: 18, color: Colors.white),
              const SizedBox(width: 12),
              Text('My Profile', style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout, size: 18, color: AppColors.error),
              const SizedBox(width: 12),
              Text('Logout', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.sidebarDark),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.accentRed,
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
              child: imageUrl == null 
                ? const Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                : null,
            ),
            const SizedBox(width: 12),
            Text(name, style: AppTextStyles.bodyLarge),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentLeads(List<dynamic> leads) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Leads', style: AppTextStyles.heading3),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/leads'),
                child: Text('View All', style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentRed)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Table header
          if (leads.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text('No recent leads found.', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
              ),
            )
          else ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.sidebarDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text('Name', style: AppTextStyles.label)),
                  Expanded(child: Text('Type', style: AppTextStyles.label)),
                  Expanded(child: Text('Date', style: AppTextStyles.label)),
                  Expanded(child: Text('Status', style: AppTextStyles.label)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Table rows
            ...leads.map((lead) => Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.sidebarDark)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primaryNavy,
                          child: Text(
                            (lead['name'] ?? 'U')[0],
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(lead['name'] ?? 'Unknown', style: AppTextStyles.bodyLarge, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getTypeColor(lead['type'] ?? 'Other').withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        lead['type'] ?? 'Other',
                        style: AppTextStyles.bodySmall.copyWith(color: _getTypeColor(lead['type'] ?? 'Other')),
                      ),
                    ),
                  ),
                  Expanded(child: Text(formatRelativeTime(lead['createdAt']), style: AppTextStyles.bodyMedium)),
                  Expanded(child: _buildStatusBadge(lead['status'] ?? 'New')),
                ],
              ),
            )).toList(),
          ],
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Franchise': return AppColors.success;
      case 'Contact': return AppColors.info;
      case 'Quote': return AppColors.warning;
      default: return AppColors.textMuted;
    }
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'New': color = AppColors.success; break;
      case 'Pending': color = AppColors.warning; break;
      case 'Contacted': color = AppColors.info; break;
      case 'Closed': color = AppColors.textMuted; break;
      default: color = AppColors.textMuted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.add_circle_outline, 'label': 'New Blog Post', 'route': '/blog/new'},
      {'icon': Icons.inventory_2_outlined, 'label': 'Add Product', 'route': '/products/new'},
      {'icon': Icons.edit_outlined, 'label': 'Edit Home Page', 'route': '/pages/home'},
      {'icon': Icons.settings_outlined, 'label': 'Settings', 'route': '/settings'},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: AppTextStyles.heading3),
          const SizedBox(height: 20),
          ...actions.map((action) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, action['route'] as String),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.sidebarDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.textMuted.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.accentRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(action['icon'] as IconData, color: AppColors.accentRed, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Text(action['label'] as String, style: AppTextStyles.bodyLarge),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, color: AppColors.textMuted, size: 14),
                    ],
                  ),
                ),
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildOverviewChart(List<dynamic> leadsData) {
    // Generate labels for the last 7 days
    final now = DateTime.now();
    final dayLabels = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return DateFormat('E').format(date); // Mon, Tue, etc.
    });

    // Create spots from leads data
    final List<FlSpot> spots = [];
    double maxVal = 10; // Default min maxY
    for (int i = 0; i < leadsData.length; i++) {
        final val = (leadsData[i] as num).toDouble();
        spots.add(FlSpot(i.toDouble(), val));
        if (val > maxVal) maxVal = val;
    }

    // Add 20% padding to maxY if there's data
    final maxY = maxVal == 0 ? 10.0 : (maxVal * 1.2).ceilToDouble();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Inquiry Analytics', style: AppTextStyles.heading3),
                  const SizedBox(height: 4),
                  Text('Weekly leads and inquiries activity', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.sidebarDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: AppColors.accentTeal), // Fixed color to teal
                    const SizedBox(width: 8),
                    Text('Last 7 Days', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 300,
            child: spots.isEmpty 
              ? Center(child: Text('No data available', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)))
              : LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.textMuted.withOpacity(0.05),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < dayLabels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(dayLabels[index], style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: (maxY / 4).ceilToDouble(),
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString(), style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted));
                      },
                      reservedSize: 30,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: const LinearGradient(colors: [AppColors.accentBlue, AppColors.accentTeal]),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accentBlue.withOpacity(0.2),
                          AppColors.accentTeal.withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
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
