import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          // Sidebar
          const AdminSidebar(currentRoute: '/dashboard'),
          
          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dashboard', style: AppTextStyles.heading1),
                          const SizedBox(height: 4),
                          Text(
                            'Welcome back, Admin',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                      // User menu
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.cardDark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.accentRed,
                              child: const Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 12),
                            Text('Admin', style: AppTextStyles.bodyLarge),
                            const SizedBox(width: 8),
                            const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Stats row
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Total Leads',
                          value: '127',
                          icon: Icons.people_outline,
                          color: AppColors.info,
                          trend: '+12%',
                          trendUp: true,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: StatCard(
                          title: 'Blog Posts',
                          value: '24',
                          icon: Icons.article_outlined,
                          color: AppColors.success,
                          trend: '+3',
                          trendUp: true,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: StatCard(
                          title: 'Products',
                          value: '12',
                          icon: Icons.inventory_2_outlined,
                          color: AppColors.warning,
                          trend: '0',
                          trendUp: null,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: StatCard(
                          title: 'Pending',
                          value: '8',
                          icon: Icons.pending_actions,
                          color: AppColors.accentRed,
                          trend: '-2',
                          trendUp: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Recent leads section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recent Leads
                      Expanded(
                        flex: 2,
                        child: _buildRecentLeads(),
                      ),
                      const SizedBox(width: 24),
                      // Quick Actions
                      Expanded(
                        child: _buildQuickActions(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentLeads() {
    final leads = [
      {'name': 'Rahul Sharma', 'type': 'Franchise', 'date': '2 hours ago', 'status': 'New'},
      {'name': 'Priya Patel', 'type': 'Contact', 'date': '5 hours ago', 'status': 'New'},
      {'name': 'Amit Kumar', 'type': 'Quote', 'date': '1 day ago', 'status': 'Pending'},
      {'name': 'Sneha Reddy', 'type': 'Franchise', 'date': '2 days ago', 'status': 'Contacted'},
      {'name': 'Vijay Singh', 'type': 'Contact', 'date': '3 days ago', 'status': 'Closed'},
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Leads', style: AppTextStyles.heading3),
              TextButton(
                onPressed: () {},
                child: Text('View All', style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentRed)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Table header
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
                          lead['name']![0],
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(lead['name']!, style: AppTextStyles.bodyLarge),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTypeColor(lead['type']!).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      lead['type']!,
                      style: AppTextStyles.bodySmall.copyWith(color: _getTypeColor(lead['type']!)),
                    ),
                  ),
                ),
                Expanded(child: Text(lead['date']!, style: AppTextStyles.bodyMedium)),
                Expanded(child: _buildStatusBadge(lead['status']!)),
              ],
            ),
          )).toList(),
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
}
