import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'credit_card_bill_screen.dart';

class CreditCardOperatorScreen extends StatefulWidget {
  const CreditCardOperatorScreen({super.key});

  @override
  State<CreditCardOperatorScreen> createState() => _CreditCardOperatorScreenState();
}

class _CreditCardOperatorScreenState extends State<CreditCardOperatorScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // ✅ List of all Banks
  final List<Map<String, dynamic>> ccBanks = [
    {'name': 'HDFC Bank', 'fullName': 'HDFC Bank Credit Card', 'isPopular': true, 'icon': Icons.account_balance_rounded, 'color': const Color(0xFF1565C0)},
    {'name': 'SBI', 'fullName': 'State Bank of India Credit Card', 'isPopular': true, 'icon': Icons.account_balance_rounded, 'color': const Color(0xFF1976D2)},
    {'name': 'Axis Bank', 'fullName': 'Axis Bank Credit Card', 'isPopular': true, 'icon': Icons.account_balance_rounded, 'color': const Color(0xFF880E4F)},
    {'name': 'ICICI Bank', 'fullName': 'ICICI Bank Credit Card', 'isPopular': true, 'icon': Icons.account_balance_rounded, 'color': const Color(0xFFD32F2F)},
    {'name': 'RBL Bank', 'fullName': 'RBL Credit Card', 'isPopular': true, 'icon': Icons.account_balance_rounded, 'color': const Color(0xFF1565C0)},
    {'name': 'Kotak Mahindra', 'fullName': 'Kotak Mahindra Bank Credit Card', 'isPopular': true, 'icon': Icons.account_balance_rounded, 'color': const Color(0xFFD50000)},
    {'name': 'IndusInd Bank', 'fullName': 'IndusInd Bank Credit Card', 'isPopular': true, 'icon': Icons.account_balance_rounded, 'color': const Color(0xFF6A1B9A)},
    {'name': 'Yes Bank', 'fullName': 'Yes Bank Credit Card', 'isPopular': true, 'icon': Icons.account_balance_rounded, 'color': const Color(0xFF1976D2)},
    {'name': 'Bank of Baroda', 'fullName': 'BOB Financial Credit Card', 'isPopular': true, 'icon': Icons.account_balance_rounded, 'color': const Color(0xFFF57C00)},
    {'name': 'IDFC Bank', 'fullName': 'IDFC FIRST Bank Credit Card', 'isPopular': true, 'icon': Icons.account_balance_rounded, 'color': const Color(0xFF9E0059)},
    {'name': 'Punjab National', 'fullName': 'PNB Credit Card', 'isPopular': true, 'icon': Icons.account_balance_rounded, 'color': const Color(0xFFD32F2F)},
    {'name': 'AU Small Finance', 'fullName': 'AU Small Finance Bank Credit Card', 'isPopular': true, 'icon': Icons.account_balance_rounded, 'color': const Color(0xFFE65100)},
    {'name': 'Bandhan Bank', 'fullName': 'Bandhan Bank Credit Card', 'isPopular': false, 'icon': Icons.account_balance_rounded, 'color': const Color(0xFFD32F2F)},
    {'name': 'Bank of India', 'fullName': 'BOI Credit Card', 'isPopular': false, 'icon': Icons.account_balance_rounded, 'color': const Color(0xFF1565C0)},
    {'name': 'Canara Bank', 'fullName': 'Canara Bank Credit Card', 'isPopular': false, 'icon': Icons.account_balance_rounded, 'color': const Color(0xFF00838F)},
    {'name': 'Federal Bank', 'fullName': 'Federal Bank Credit Card', 'isPopular': false, 'icon': Icons.account_balance_rounded, 'color': const Color(0xFF01579B)},
    {'name': 'Standard Chartered', 'fullName': 'SCB Credit Card', 'isPopular': false, 'icon': Icons.account_balance_rounded, 'color': const Color(0xFF2E7D32)},
  ];

  List<Map<String, dynamic>> get _filteredBanks {
    if (_searchQuery.isEmpty) return ccBanks;
    return ccBanks.where((d) {
      return d['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d['fullName'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ✅ JADOO: Fixed Bottom White Strip with Bigger Bharat Connect Logo
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
            // ✅ Logo ki height 24 se badhakar 32 kar di hai
            Image.asset(
              'assets/images/bharat_connect.png',
              height: 32,
              errorBuilder: (context, error, stackTrace) {
                // Agar image nahi milti (error aati hai), to fallback bhi thoda bada dikhega
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
    final List<Map<String, dynamic>> popularBanks = ccBanks.where((b) => b['isPopular'] == true).toList();
    final List<Map<String, dynamic>> allBanks = ccBanks;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        // ✅ JADOO: bottomNavigationBar me daalne se ye hamesha screen ke bottom par fix rahega!
        bottomNavigationBar: _buildFixedBharatConnectFooter(),
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
                              'Select Credit Card Bank',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
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
                                style: const TextStyle(fontSize: 15, color: Colors.black87),
                                decoration: InputDecoration(
                                  hintText: 'Search Your bank',
                                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15, fontWeight: FontWeight.w400),
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

            // ══ BODY (LIST & GRID) ══════════════════════════════════
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
                  : SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ✅ GRID VIEW (Screenshot Jaisa)
                    if (_searchQuery.isEmpty) ...[
                      const Text('Popular banks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: popularBanks.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, // 4 items per row like screenshot
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.65, // Adjust for text below
                          ),
                          itemBuilder: (context, index) {
                            final d = popularBanks[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => CreditCardBillScreen(initialBank: d)));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 52, width: 52,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey.shade200),
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5, offset: const Offset(0, 2))],
                                    ),
                                    child: Icon(d['icon'] as IconData, color: d['color'] as Color, size: 26),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    d['name'],
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.2),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text('All banks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87)),
                      const SizedBox(height: 12),
                    ],

                    // ✅ ALL BANKS LIST
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: _searchQuery.isEmpty ? allBanks.length : _filteredBanks.length,
                        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100, indent: 64),
                        itemBuilder: (context, index) {
                          final d = _searchQuery.isEmpty ? allBanks[index] : _filteredBanks[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Icon(d['icon'] as IconData, color: d['color'] as Color, size: 22),
                            ),
                            title: Text(d['fullName'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => CreditCardBillScreen(initialBank: d)));
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}