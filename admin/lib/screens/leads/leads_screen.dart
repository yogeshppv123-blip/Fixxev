import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';
import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:fixxev_admin/core/utils/time_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<dynamic> _leads = [];
  String _companyEmail = 'support@fixxev.com';

  @override
  void initState() {
    super.initState();
    _loadLeads();
    _loadCompanyEmail();
  }

  Future<void> _loadCompanyEmail() async {
    try {
      final contactData = await _apiService.getPageContent('contact');
      if (contactData['content'] != null && contactData['content']['email'] != null) {
        setState(() {
          _companyEmail = contactData['content']['email'];
        });
      }
    } catch (e) {
      // Keep default
    }
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    if (_isLoading) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.backgroundDark,
        drawer: isMobile ? const Drawer(child: AdminSidebar(currentRoute: '/leads')) : null,
        appBar: isMobile ? AppBar(
          backgroundColor: AppColors.sidebarDark,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          title: Text('Leads & Inquiries', style: AppTextStyles.heading3),
        ) : null,
        body: Row(
          children: [
            if (!isMobile) const AdminSidebar(currentRoute: '/leads'),
            const Expanded(child: Center(child: CircularProgressIndicator())),
          ],
        ),
      );
    }

    final filteredLeads = _selectedFilter == 'All'
        ? _leads
        : _leads.where((l) => l['type'] == _selectedFilter).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundDark,
      drawer: isMobile ? const Drawer(child: AdminSidebar(currentRoute: '/leads')) : null,
      appBar: isMobile ? AppBar(
        backgroundColor: AppColors.sidebarDark,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text('Leads & Inquiries', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            onPressed: _loadLeads,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ) : null,
      body: Row(
        children: [
          if (!isMobile) const AdminSidebar(currentRoute: '/leads'),
          Expanded(
            child: Column(
              children: [
                if (!isMobile) _buildFixedHeader(),
                if (isMobile) _buildMobileHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 32,
                      vertical: isMobile ? 16 : 24,
                    ),
                    child: Column(
                      children: [
                        isMobile
                            ? _buildMobileLeadsList(filteredLeads)
                            : _buildLeadsTable(filteredLeads),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_leads.length} TOTAL INQUIRIES',
              style: AppTextStyles.label.copyWith(color: AppColors.accentBlue, fontSize: 10),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter, style: const TextStyle(fontSize: 12)),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedFilter = filter);
                    },
                    selectedColor: AppColors.accentBlue,
                    backgroundColor: AppColors.cardDark,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textMuted),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLeadsList(List<dynamic> leads) {
    if (leads.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 48, color: AppColors.textMuted),
              const SizedBox(height: 16),
              Text('No leads yet', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textMuted)),
            ],
          ),
        ),
      );
    }

    return Column(
      children: leads.map((lead) => _buildMobileLeadCard(lead)).toList(),
    );
  }

  Widget _buildMobileLeadCard(Map<String, dynamic> lead) {
    final name = lead['name'] ?? 'Unknown';
    final type = lead['type'] ?? 'Contact';
    final status = lead['status'] ?? 'new';
    final createdAt = lead['createdAt'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildStatusBadge(status),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildTypeBadge(type),
              const SizedBox(width: 12),
              Text(
                formatRelativeTime(createdAt),
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
          if (lead['email'] != null || lead['phone'] != null) ...[
            const SizedBox(height: 12),
            if (lead['email'] != null)
              Text(lead['email'], style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
            if (lead['phone'] != null)
              Text(lead['phone'], style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => _showLeadDetails(lead),
                child: const Text('View Details'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFixedHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        border: Border(bottom: BorderSide(color: AppColors.sidebarDark)),
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
                  Text('Leads & Inquiries', style: AppTextStyles.heading2),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accentBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_leads.length} TOTAL INQUIRIES',
                      style: AppTextStyles.label.copyWith(color: AppColors.accentBlue, fontSize: 10),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _loadLeads,
                    icon: const Icon(Icons.refresh, color: AppColors.textMuted),
                    tooltip: 'Refresh',
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('Export CSV'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sidebarDark,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: _filters.map((filter) {
              final isSelected = _selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _selectedFilter = filter);
                  },
                  backgroundColor: AppColors.sidebarDark,
                  selectedColor: AppColors.accentRed,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textMuted,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadsTable(List<dynamic> filteredLeads) {
    if (filteredLeads.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Icon(Icons.inbox_outlined, size: 64, color: AppColors.textMuted.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text('No inquiries found', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textMuted)),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sidebarDark),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: const BoxDecoration(
              color: AppColors.sidebarDark,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text('NAME / CONTACT', style: AppTextStyles.label.copyWith(fontSize: 10))),
                const SizedBox(width: 100, child: Text('TYPE', style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.bold))),
                Expanded(flex: 4, child: Text('MESSAGE PREVIEW', style: AppTextStyles.label.copyWith(fontSize: 10))),
                Expanded(flex: 2, child: Text('RECEIVED', style: AppTextStyles.label.copyWith(fontSize: 10))),
                Expanded(flex: 2, child: Text('STATUS', style: AppTextStyles.label.copyWith(fontSize: 10))),
                const SizedBox(width: 80, child: Text('ACTIONS', style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              ],
            ),
          ),
          // Table rows
          ...filteredLeads.map((lead) => _buildLeadRow(lead)).toList(),
        ],
      ),
    );
  }

  Widget _buildLeadRow(dynamic lead) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.sidebarDark)),
      ),
      child: Row(
        children: [
          // Contact info - Flex 3
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lead['name'] ?? '', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.email_outlined, size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 6),
                    Text(lead['email'] ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined, size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 6),
                    Text(lead['phone'] ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
          // Type - Fixed small width 100
          SizedBox(
            width: 100,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTypeColor(lead['type']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: _getTypeColor(lead['type']).withOpacity(0.3)),
                  ),
                  child: Text(
                    (lead['type'] ?? 'Contact').toUpperCase(),
                    style: TextStyle(
                      color: _getTypeColor(lead['type']),
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Message - Flex 4
          Expanded(
            flex: 4,
            child: Text(
              lead['message'] ?? '',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight.withOpacity(0.8)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Date - Flex 2
          Expanded(
            flex: 2,
            child: Text(
              formatRelativeTime(lead['createdAt']), 
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)
            ),
          ),
          // Status - Flex 2
          Expanded(flex: 2, child: _buildStatusDropdown(lead)),
          // Actions - 80 width
          SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility_outlined, size: 20),
                  color: AppColors.accentBlue,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _showLeadDetails(lead),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: AppColors.error,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
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

  Widget _buildTypeBadge(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getTypeColor(type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _getTypeColor(type).withOpacity(0.3)),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          color: _getTypeColor(type),
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
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


  void _showLeadDetails(Map<String, dynamic> lead) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 600,
          decoration: BoxDecoration(
            color: AppColors.backgroundDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.sidebarDark),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.sidebarDark,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.accentBlue.withOpacity(0.1),
                      child: Text(
                        (lead['name'] ?? 'U')[0].toUpperCase(),
                        style: AppTextStyles.heading2.copyWith(color: AppColors.accentBlue),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lead['name'] ?? 'Unknown Sender', style: AppTextStyles.heading2),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildMiniBadge(lead['type'] ?? 'General', _getTypeColor(lead['type'])),
                              const SizedBox(width: 12),
                              _buildMiniBadge(lead['status'] ?? 'NEW', _getStatusColor(lead['status'])),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              
              // Content Section
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Contact Info Cards
                      Row(
                        children: [
                          _buildContactCard(Icons.email_outlined, 'Email Address', lead['email'] ?? 'N/A'),
                          const SizedBox(width: 20),
                          _buildContactCard(Icons.phone_outlined, 'Phone Number', lead['phone'] ?? 'N/A'),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Message Section
                      Text('INQUIRY MESSAGE', style: AppTextStyles.label.copyWith(letterSpacing: 1.5, fontSize: 10)),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.cardDark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.sidebarDark),
                        ),
                        child: Text(
                          lead['message'] ?? 'No message provided.',
                          style: AppTextStyles.bodyLarge.copyWith(height: 1.6),
                        ),
                      ),
                      
                      if (lead['details'] != null && (lead['details'] as Map).isNotEmpty) ...[
                        const SizedBox(height: 32),
                        Text('ADDITIONAL SPECIFICATIONS', style: AppTextStyles.label.copyWith(letterSpacing: 1.5, fontSize: 10)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.cardDark.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: (lead['details'] as Map<String, dynamic>).entries.map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 140, 
                                    child: Text(e.key.toUpperCase(), style: AppTextStyles.label.copyWith(fontSize: 9, color: AppColors.textMuted)),
                                  ),
                                  Expanded(
                                    child: Text(e.value.toString(), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            )).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              // Action Bar
              Padding(
                padding: const EdgeInsets.all(32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      ),
                      child: Text('Dismiss', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          final String query = encodeQueryParameters({
                            'subject': 'RE: Inquiry from Fixxev - ${lead['type']}',
                            'body': 'Hi ${lead['name']},\n\nThank you for reaching out to Fixxev.\n\n---\nBest Regards,\nFixxev Team\nEmail: $_companyEmail'
                          }) ?? '';
                          
                          final Uri emailLaunchUri = Uri.parse('mailto:${lead['email']}?$query');
                          
                          await launchUrl(
                            emailLaunchUri,
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Could not open email client. Please email manually to: ${lead['email']}')),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.reply, size: 18),
                      label: const Text('Reply via Email'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.sidebarDark),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textMuted, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(value, style: AppTextStyles.bodyMedium, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'NEW': return AppColors.success;
      case 'PENDING': return AppColors.warning;
      case 'CONTACTED': return AppColors.info;
      case 'CLOSED': return AppColors.textMuted;
      default: return AppColors.textMuted;
    }
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
