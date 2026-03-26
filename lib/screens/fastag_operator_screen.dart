import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'fastag_recharge_screen.dart';

class FastagOperatorScreen extends StatefulWidget {
  const FastagOperatorScreen({super.key});

  @override
  State<FastagOperatorScreen> createState() => _FastagOperatorScreenState();
}

class _FastagOperatorScreenState extends State<FastagOperatorScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> fastagBanks = [
    // Top Banks
    {'name': 'IDFC FIRST Bank', 'fullName': 'IDFC Bank Fastag', 'category': 'Top Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFF9E0059)},
    {'name': 'ICICI Bank', 'fullName': 'ICICI Bank Fastag', 'category': 'Top Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFFD32F2F)},
    {'name': 'HDFC Bank', 'fullName': 'HDFC Bank Fastag', 'category': 'Top Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFF1565C0)},
    {'name': 'Paytm Fastag', 'fullName': 'Paytm Payments Bank', 'category': 'Top Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFF0288D1)},
    {'name': 'State Bank of India', 'fullName': 'SBI Fastag', 'category': 'Top Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFF1976D2)},

    // Popular Banks
    {'name': 'Axis Bank', 'fullName': 'Axis Bank Fastag', 'category': 'Popular Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFF880E4F)},
    {'name': 'Kotak Mahindra Bank', 'fullName': 'Kotak Bank Fastag', 'category': 'Popular Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFFD50000)},
    {'name': 'Airtel Payments Bank', 'fullName': 'Airtel Fastag', 'category': 'Popular Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFFE53935)},
    {'name': 'Bank of Baroda', 'fullName': 'BOB Fastag', 'category': 'Popular Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFFF57C00)},

    // Other Banks
    {'name': 'Equitas Small Finance', 'fullName': 'Equitas Bank Fastag', 'category': 'Other Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFFFBC02D)},
    {'name': 'Federal Bank', 'fullName': 'Federal Bank Fastag', 'category': 'Other Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFF01579B)},
    {'name': 'IndusInd Bank', 'fullName': 'IndusInd Bank Fastag', 'category': 'Other Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFF6A1B9A)},
    {'name': 'South Indian Bank', 'fullName': 'SIB Fastag', 'category': 'Other Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFFD84315)},
    {'name': 'Union Bank of India', 'fullName': 'UBI Fastag', 'category': 'Other Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFFE65100)},
  ];

  List<Map<String, dynamic>> get _filteredBanks {
    if (_searchQuery.isEmpty) return fastagBanks;
    return fastagBanks.where((d) {
      return d['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d['fullName'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d['category'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Map<String, List<Map<String, dynamic>>> get _groupedBanks {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var d in _filteredBanks) {
      final category = d['category'] as String;
      grouped[category] ??= [];
      grouped[category]!.add(d);
    }
    return grouped;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ✅ JADOO: Fixed Bottom White Strip for Bharat Connect Logo
  Widget _buildFixedBharatConnectFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Powered by', style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/bharat_connect.png',
              height: 32,
              errorBuilder: (context, error, stackTrace) {
                return Row(
                  children: [
                    const Icon(Icons.hub_rounded, color: Color(0xFF003A70), size: 20),
                    const SizedBox(width: 4),
                    const Text('Bharat', style: TextStyle(color: Color(0xFF003A70), fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 0.3)),
                    const Text('Connect', style: TextStyle(color: Color(0xFFF37021), fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 0.3)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedBanks;
    final categories = grouped.keys.toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        bottomNavigationBar: _buildFixedBharatConnectFooter(), // ✅ Logo fix ho gaya
        body: Column(
          children: [

            // ══ HEADER ════════════════════════════════
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00695C), Color(0xFF009688)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [

                    // AppBar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Expanded(
                            child: Text(
                              'Fastag Recharge',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),

                    // Title + Count
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 6),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.directions_car_rounded, color: Colors.white, size: 26),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select Fastag Bank',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                '${fastagBanks.length} NETC issuer banks',
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 14),
                            Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (v) => setState(() => _searchQuery = v),
                                style: const TextStyle(fontSize: 14, color: Colors.black87),
                                decoration: InputDecoration(
                                  hintText: 'Search bank or category...',
                                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            if (_searchQuery.isNotEmpty)
                              IconButton(
                                icon: Icon(Icons.close_rounded, color: Colors.grey.shade400, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ══ LIST ══════════════════════════════════
            Expanded(
              child: _filteredBanks.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off_rounded, size: 60, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text('No bank found', style: TextStyle(color: Colors.grey.shade400, fontSize: 15)),
                  ],
                ),
              )
                  : ListView.builder(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                itemCount: categories.length,
                itemBuilder: (_, ci) {
                  final category = categories[ci];
                  final categoryBanks = grouped[category]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Header
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              category,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black87),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${categoryBanks.length}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bank Cards
                      ...categoryBanks.map((d) => _buildBankCard(d)),

                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankCard(Map<String, dynamic> d) {
    final Color color = d['color'] as Color;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FastagRechargeScreen(
              initialBank: d,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            // Icon Box
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(d['icon'] as IconData, color: color, size: 28),
            ),

            const SizedBox(width: 16),

            // Name + Full Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d['name'],
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    d['fullName'],
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500, height: 1.3),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Arrow
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.arrow_forward_ios_rounded, color: color, size: 14),
            ),
          ],
        ),
      ),
    );
  }
}