import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<dynamic> _leads = [];

  @override
  void initState() {
    super.initState();
    _loadLeads();
  }

  Future<void> _loadLeads() async {
    setState(() => _isLoading = true);
    try {
      final leads = await _apiService.getLeads();
      setState(() {
        _leads = leads;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading leads: $e')),
        );
      }
    }
  }

  // Removed mock data
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Contact', 'Franchise', 'Quote', 'Dealership'];

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Row(
          children: [
            const AdminSidebar(currentRoute: '/leads'),
            const Expanded(child: Center(child: CircularProgressIndicator())),
          ],
        ),
      );
    }

    final filteredLeads = _selectedFilter == 'All'
        ? _leads
        : _leads.where((l) => l['type'] == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          const AdminSidebar(currentRoute: '/leads'),
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
                          Text('Leads & Inquiries', style: AppTextStyles.heading1),
                          const SizedBox(height: 4),
                          Text(
                            '${_leads.length} total leads',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // Export button
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.download, size: 18),
                            label: const Text('Export CSV'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textLight,
                              side: BorderSide(color: AppColors.textMuted.withOpacity(0.3)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Filters
                  Row(
                    children: _filters.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _selectedFilter = filter);
                          },
                          backgroundColor: AppColors.cardDark,
                          selectedColor: AppColors.accentRed.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.accentRed : AppColors.textMuted,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected ? AppColors.accentRed : Colors.transparent,
                          ),
                          checkmarkColor: AppColors.accentRed,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Leads table
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        // Table header
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          decoration: BoxDecoration(
                            color: AppColors.sidebarDark,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text('Contact', style: AppTextStyles.label)),
                              Expanded(child: Text('Type', style: AppTextStyles.label)),
                              Expanded(flex: 2, child: Text('Message', style: AppTextStyles.label)),
                              Expanded(child: Text('Date', style: AppTextStyles.label)),
                              Expanded(child: Text('Status', style: AppTextStyles.label)),
                              const SizedBox(width: 100, child: Text('Actions', style: TextStyle(fontSize: 12, color: AppColors.textMuted))),
                            ],
                          ),
                        ),
                        // Table rows
                        ...filteredLeads.map((lead) => _buildLeadRow(lead)).toList(),
                      ],
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

  Widget _buildLeadRow(dynamic lead) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.sidebarDark)),
      ),
      child: Row(
        children: [
          // Contact info
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lead['name'] ?? '', style: AppTextStyles.bodyLarge),
                const SizedBox(height: 4),
                Text(lead['email'] ?? '', style: AppTextStyles.bodySmall),
                Text(lead['phone'] ?? '', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          // Type
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getTypeColor(lead['type']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                lead['type'] ?? 'Contact',
                style: AppTextStyles.bodySmall.copyWith(
                  color: _getTypeColor(lead['type']),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Message
          Expanded(
            flex: 2,
            child: Text(
              lead['message'] ?? '',
              style: AppTextStyles.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Date
          Expanded(
            child: Text(
              _formatDate(lead['createdAt'] != null ? DateTime.parse(lead['createdAt']) : DateTime.now()), 
              style: AppTextStyles.bodyMedium
            ),
          ),
          // Status
          Expanded(child: _buildStatusDropdown(lead)),
          // Actions
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility_outlined, size: 20),
                  color: AppColors.textMuted,
                  onPressed: () => _showLeadDetails(lead),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: AppColors.error,
                  onPressed: () => _deleteLead(lead['_id']),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Franchise': return AppColors.success;
      case 'Contact': return AppColors.info;
      case 'Quote': return AppColors.warning;
      case 'Dealership': return const Color(0xFF8B5CF6);
      default: return AppColors.textMuted;
    }
  }

  Widget _buildStatusDropdown(dynamic lead) {
    final statuses = ['NEW', 'PENDING', 'CONTACTED', 'CLOSED'];
    
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: lead['status']?.toUpperCase() ?? 'NEW',
        dropdownColor: AppColors.cardDark,
        borderRadius: BorderRadius.circular(8),
        items: statuses.map((status) {
          return DropdownMenuItem(
            value: status,
            child: _buildStatusBadge(status),
          );
        }).toList(),
        onChanged: (value) async {
          if (value != null) {
            try {
              await _apiService.updateLeadStatus(lead['_id'], value);
              _loadLeads();
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating status: $e')),
                );
              }
            }
          }
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'NEW': color = AppColors.success; break;
      case 'PENDING': color = AppColors.warning; break;
      case 'CONTACTED': color = AppColors.info; break;
      case 'CLOSED': color = AppColors.textMuted; break;
      default: color = AppColors.textMuted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showLeadDetails(Map<String, dynamic> lead) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text(lead['name'], style: AppTextStyles.heading2),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Email', lead['email']),
            _detailRow('Phone', lead['phone']),
            _detailRow('Type', lead['type']),
            _detailRow('Status', lead['status']),
            const SizedBox(height: 16),
            Text('Message:', style: AppTextStyles.label),
            const SizedBox(height: 8),
            Text(lead['message'] ?? '', style: AppTextStyles.bodyMedium),
            if (lead['details'] != null && (lead['details'] as Map).isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Additional Information:', style: AppTextStyles.label),
              const SizedBox(height: 8),
              ...(lead['details'] as Map<String, dynamic>).entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 140, child: Text('${e.key}:', style: AppTextStyles.label.copyWith(fontSize: 12))),
                    Expanded(child: Text('${e.value}', style: AppTextStyles.bodyMedium)),
                  ],
                ),
              )).toList(),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text('$label:', style: AppTextStyles.label)),
          Text(value, style: AppTextStyles.bodyLarge),
        ],
      ),
    );
  }

  void _deleteLead(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text('Delete Lead?', style: AppTextStyles.heading3),
        content: Text('This action cannot be undone.', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _apiService.deleteLead(id);
                if (mounted) {
                  Navigator.pop(context);
                  _loadLeads();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting lead: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
