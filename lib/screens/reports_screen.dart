import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_colors.dart';
import 'transaction_history_screen.dart';
import 'recharge_history_screen.dart';
import 'aeps_ledger_screen.dart'; // ✅ JADOO: Nayi AEPS Ledger Screen import kar li

class ReportsScreen extends StatefulWidget {
  final double topPadding;
  const ReportsScreen({super.key, required this.topPadding});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool isB2B = false;
  bool _isLoading = true;
  String _searchQuery = '';

  List<Map<String, dynamic>> _allSections = [];
  List<Map<String, dynamic>> _filteredSections = [];

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      isB2B = prefs.getBool('isB2B') ?? false;
      _allSections = isB2B ? _getB2BSections() : _getB2CSections();
      _filteredSections = List.from(_allSections);
      setState(() => _isLoading = false);
    }
  }

  void _filterData(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchQuery = '';
        _filteredSections = List.from(_allSections);
      });
      return;
    }
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredSections = [];
      for (var section in _allSections) {
        List<Map<String, dynamic>> filtered =
        (section['items'] as List<Map<String, dynamic>>)
            .where((item) =>
        item['title']
            .toString()
            .toLowerCase()
            .contains(_searchQuery) ||
            item['subtitle']
                .toString()
                .toLowerCase()
                .contains(_searchQuery))
            .toList();
        if (filtered.isNotEmpty) {
          _filteredSections.add({
            'title': section['title'],
            'items': filtered,
          });
        }
      }
    });
  }

  List<Map<String, dynamic>> _getB2BSections() {
    return [
      {
        'title': 'FINANCIAL LEDGERS',
        'items': [
          {'icon': Icons.menu_book, 'title': 'Main Wallet Ledger', 'subtitle': 'Check all your wallet top-ups & debits', 'color': Colors.blue, 'target': const TransactionHistoryScreen(pageTitle: 'Main Wallet Ledger', isB2B: true)},
          {'icon': Icons.account_balance, 'title': 'AEPS Settlement Ledger', 'subtitle': 'History of wallet to bank transfers', 'color': Colors.orange, 'target': const TransactionHistoryScreen(pageTitle: 'AEPS Settlement Ledger', isB2B: true)},
        ],
      },
      {
        'title': 'SERVICE TRANSACTIONS',
        'items': [
          {'icon': Icons.phone_android, 'title': 'Recharge & BBPS History', 'subtitle': 'Mobile, DTH, Electricity bill status', 'color': Colors.purple, 'target': const RechargeHistoryScreen(isB2B: true)},

          // ✅ JADOO: Teeno ko alag-alag kar diya gaya hai!
          {'icon': Icons.fingerprint, 'title': 'AEPS Ledger', 'subtitle': 'Cash withdrawal & balance enquiry', 'color': Colors.teal, 'target': const AepsLedgerScreen(isB2B: true)},
          {'icon': Icons.point_of_sale, 'title': 'mATM Ledger', 'subtitle': 'Micro ATM transaction history', 'color': Colors.cyan.shade700, 'target': const TransactionHistoryScreen(pageTitle: 'mATM Ledger', isB2B: true)},
          {'icon': Icons.contactless, 'title': 'Aadhaar Pay Ledger', 'subtitle': 'Aadhaar pay transaction records', 'color': Colors.blueGrey, 'target': const TransactionHistoryScreen(pageTitle: 'Aadhaar Pay Ledger', isB2B: true)},

          {'icon': Icons.sync_alt, 'title': 'Money Transfer (DMT)', 'subtitle': 'Domestic money remittance status', 'color': Colors.indigo, 'target': const TransactionHistoryScreen(pageTitle: 'DMT History', isB2B: true)},
          {'icon': Icons.flight_takeoff, 'title': 'Travel & Services', 'subtitle': 'Flight, Train, PAN Card transaction history', 'color': Colors.redAccent, 'target': const TransactionHistoryScreen(pageTitle: 'Travel Services Report', isB2B: true)},
        ],
      },
      {
        'title': 'EARNINGS & TAXES',
        'items': [
          {'icon': Icons.savings, 'title': 'Commission Report', 'subtitle': 'Detailed report of earnings per service', 'color': Colors.green, 'target': const TransactionHistoryScreen(pageTitle: 'Commission Report', isB2B: true)},
          {'icon': Icons.request_quote, 'title': 'TDS Deduction Report', 'subtitle': 'Monthly & Yearly TDS statements', 'color': Colors.deepOrange, 'target': const TransactionHistoryScreen(pageTitle: 'TDS Report', isB2B: true)},
        ],
      },
    ];
  }

  List<Map<String, dynamic>> _getB2CSections() {
    return [
      {
        'title': 'MY PAYMENTS & WALLET',
        'items': [
          {'icon': Icons.account_balance_wallet, 'title': 'Wallet Passbook', 'subtitle': 'All your added funds and expenses', 'color': Colors.blue, 'target': const TransactionHistoryScreen(pageTitle: 'Wallet Passbook', isB2B: false)},
          {'icon': Icons.phone_android, 'title': 'Recharge & Bill Payments', 'subtitle': 'History of mobile, DTH & utilities', 'color': Colors.purple, 'target': const RechargeHistoryScreen(isB2B: false)},
          {'icon': Icons.send_outlined, 'title': 'Send Money History', 'subtitle': 'Funds transferred to bank or friends', 'color': Colors.indigo, 'target': const TransactionHistoryScreen(pageTitle: 'Send Money History', isB2B: false)},
        ],
      },
      {
        'title': 'REWARDS & OFFERS',
        'items': [
          {'icon': Icons.card_giftcard_rounded, 'title': 'Cashback Earned', 'subtitle': 'History of promo codes and cashback', 'color': Colors.orange, 'target': const TransactionHistoryScreen(pageTitle: 'Cashback Report', isB2B: false)},
          {'icon': Icons.people_outline, 'title': 'Referral Rewards', 'subtitle': 'Earnings from inviting your friends', 'color': Colors.green, 'target': const TransactionHistoryScreen(pageTitle: 'Referral Report', isB2B: false)},
        ],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor));
    }

    return ListView(
      physics: const ClampingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(
        top: widget.topPadding + 20,
        left: 20, right: 20, bottom: 40,
      ),
      children: [

        // ✅ NEW — Hero Stats Banner
        _buildHeroBanner(),

        const SizedBox(height: 20),

        // Header text (original)
        Text(
          isB2B ? 'Business Reports' : 'My Passbook',
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
        ),
        const SizedBox(height: 4),
        Text(
          'Track all your transactions & history',
          style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),

        // ✅ KEYBOARD FIX — SearchBar alag widget me
        _SearchBar(
          onChanged: _filterData,
          hasQuery: _searchQuery.isNotEmpty,
          onClear: () {
            _filterData('');
            FocusScope.of(context).unfocus();
          },
        ),

        const SizedBox(height: 24),

        // Sections (original)
        if (_filteredSections.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Icon(Icons.search_off_rounded,
                      size: 60, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text('No reports found!',
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          )
        else
          RepaintBoundary(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _filteredSections.map((section) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(section['title']),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10)
                        ],
                      ),
                      child: Column(
                        children: (section['items']
                        as List<Map<String, dynamic>>)
                            .asMap()
                            .entries
                            .map((entry) {
                          int idx = entry.key;
                          var item = entry.value;
                          return Column(
                            children: [
                              _reportMenuItem(
                                  context,
                                  item['icon'],
                                  item['title'],
                                  item['subtitle'],
                                  item['color'],
                                  item['target']),
                              if (idx <
                                  (section['items'] as List).length - 1)
                                _divider(),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),
            ),
          ),

        const SizedBox(height: 10),

        // Help card (original)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border:
            Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle),
                child: const Icon(Icons.support_agent,
                    color: AppColors.primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Need Help with a Transaction?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87)),
                    SizedBox(height: 4),
                    Text('Raise a ticket for failed payments.',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  color: AppColors.primaryColor, size: 16),
            ],
          ),
        ),
      ],
    );
  }

  // ✅ NEW: Hero Stats Banner
  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00695C), Color(0xFF009688)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Top row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isB2B
                      ? Icons.business_center_rounded
                      : Icons.person_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isB2B ? 'Business Summary' : 'My Summary',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    isB2B
                        ? 'Retailer / Merchant Dashboard'
                        : 'Personal Finance Overview',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 11.5),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Stats row
          Row(
            children: [
              _heroBadge(
                isB2B ? '₹1,43,200' : '₹32,500',
                isB2B ? 'Total Volume' : 'Total Spent',
                Icons.account_balance_wallet_rounded,
              ),
              _vLine(),
              _heroBadge(
                isB2B ? '₹3,280' : '₹890',
                isB2B ? 'Commission' : 'Cashback',
                isB2B ? Icons.savings_rounded : Icons.stars_rounded,
              ),
              _vLine(),
              _heroBadge(
                isB2B ? '892' : '124',
                'Transactions',
                Icons.receipt_long_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroBadge(String value, String label, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white60, size: 16),
          const SizedBox(height: 5),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.6), fontSize: 10)),
        ],
      ),
    );
  }

  Widget _vLine() =>
      Container(width: 1, height: 44, color: Colors.white.withOpacity(0.2));

  // Original helpers
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 10),
      child: Text(title,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              letterSpacing: 1.2)),
    );
  }

  Widget _reportMenuItem(BuildContext context, IconData icon, String title,
      String subtitle, Color iconColor, Widget targetScreen) {
    return ListTile(
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Colors.black87)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ),
      trailing:
      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => targetScreen));
      },
    );
  }

  Widget _divider() {
    return Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey.shade100,
        indent: 74,
        endIndent: 20);
  }
}

// ════════════════════════════════════════════════════
// ✅ KEYBOARD FIX — Alag StatefulWidget
// setState parent me hoga toh bhi TextField rebuild
// nahi hoga — keyboard stutter bilkul band!
// ════════════════════════════════════════════════════
class _SearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool hasQuery;

  const _SearchBar({
    required this.onChanged,
    required this.onClear,
    required this.hasQuery,
  });

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: TextField(
          controller: _ctrl,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: 'Search for a report...',
            hintStyle:
            TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: const Icon(Icons.search,
                color: AppColors.primaryColor, size: 22),
            suffixIcon: widget.hasQuery
                ? IconButton(
              icon: const Icon(Icons.clear,
                  color: Colors.grey, size: 20),
              onPressed: () {
                _ctrl.clear();
                widget.onClear();
              },
            )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}