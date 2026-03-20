import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ Status Bar की परछाई हटाने के लिए
import 'package:carousel_slider/carousel_slider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // ✅ Theme Colors
  final Color primaryColor = const Color(0xFF009688); // Original Teal
  final Color deepMenuColor = const Color(0xFF004D40); // Deep Dark Green
  final Color bgColor = const Color(0xFFF5F6FA);

  // ✅ Bottom Navigation Tab Index
  int _currentIndex = 0;

  // ==========================================
  // ✅ SECTIONS DATA (अब Mall सबसे नीचे है)
  // ==========================================
  List<Map<String, dynamic>> categorySections = [
    {
      'id': 'banking',
      'order': 1,
      'title': 'Banking & AEPS',
      'isPinned': false,
      'services': [
        {'icon': Icons.fingerprint, 'name': 'AEPS'},
        {'icon': Icons.point_of_sale, 'name': 'mATM'},
        {'icon': Icons.sync_alt, 'name': 'Money Transfer'},
        {'icon': Icons.account_balance, 'name': 'Payout'},
        {'icon': Icons.receipt_long, 'name': 'Statement'},
        {'icon': Icons.contactless, 'name': 'Aadhar Pay'},
      ]
    },
    {
      'id': 'recharge',
      'order': 2,
      'title': 'Recharge & Bill Pay',
      'isPinned': false,
      'services': [
        {'icon': Icons.phone_android, 'name': 'Mobile'},
        {'icon': Icons.tv, 'name': 'DTH'},
        {'icon': Icons.lightbulb_outline, 'name': 'Electricity'},
        {'icon': Icons.credit_card, 'name': 'Credit Card'},
        {'icon': Icons.directions_car, 'name': 'Fastag'},
        {'icon': Icons.water_drop_outlined, 'name': 'Water'},
        {'icon': Icons.gas_meter_outlined, 'name': 'Gas'},
        {'icon': Icons.grid_view, 'name': 'View All'},
      ]
    },
    // ✅ 2. Travel को ऊपर कर दिया है (Order 3)
    {
      'id': 'travel',
      'order': 3,
      'title': 'Travel & More',
      'isPinned': false,
      'services': [
        {'icon': Icons.flight_takeoff, 'name': 'Flight'},
        {'icon': Icons.train, 'name': 'Train'},
        {'icon': Icons.directions_bus, 'name': 'Bus'},
        {'icon': Icons.health_and_safety, 'name': 'Insurance'},
        {'icon': Icons.credit_score, 'name': 'Loan'},
        {'icon': Icons.badge_outlined, 'name': 'PAN Card'},
      ]
    },
    // ✅ 3. Mall को सबसे नीचे कर दिया है (Order 4)
    {
      'id': 'mall',
      'order': 4,
      'title': 'Paysaral Mall (Shopping)',
      'isPinned': false,
      'services': [
        {'icon': Icons.shopping_bag_outlined, 'name': 'Electronics'},
        {'icon': Icons.checkroom, 'name': 'Fashion'},
        {'icon': Icons.kitchen, 'name': 'Home Apps'},
        {'icon': Icons.local_mall_outlined, 'name': 'Groceries'},
        {'icon': Icons.card_giftcard, 'name': 'Gift Cards'},
        {'icon': Icons.percent, 'name': 'Top Offers'},
      ]
    },
  ];

  void _toggleSectionPin(String id) {
    setState(() {
      var section = categorySections.firstWhere((s) => s['id'] == id);
      section['isPinned'] = !section['isPinned'];
      categorySections.sort((a, b) {
        if (a['isPinned'] && !b['isPinned']) return -1;
        if (!a['isPinned'] && b['isPinned']) return 1;
        return a['order'].compareTo(b['order']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double headerHeight = statusBarHeight + 65;

    // ✅ जादू यहाँ है: AnnotatedRegion जो Status Bar की परछाई हटाएगा
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // बैकग्राउंड एकदम क्लियर
        statusBarIconBrightness: Brightness.light, // बैटरी/टाइम सफ़ेद रंग में
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            // ==========================================
            // 1. DYNAMIC BODY
            // ==========================================
            Positioned.fill(
              child: _currentIndex == 0
                  ? _buildHomeScreen(headerHeight)
                  : _currentIndex == 1
                  ? _buildWalletScreen(headerHeight)
                  : _buildComingSoon(headerHeight),
            ),

            // ==========================================
            // 2. FIXED CUSTOM HEADER
            // ==========================================
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: headerHeight,
                padding: EdgeInsets.only(top: statusBarHeight, left: 20, right: 20),
                decoration: BoxDecoration(color: primaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                          child: const CircleAvatar(radius: 18, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white, size: 22)),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_currentIndex == 0 ? 'Welcome Back,' : 'My Wallet', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                            const Text('Paysaral User', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.help_outline, color: Colors.white, size: 24),
                          onPressed: () {},
                        ),
                        const Icon(Icons.notifications_active_outlined, color: Colors.white, size: 22),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),

        // ✅ Bottom Nav
        bottomNavigationBar: _buildBottomNav(),

        // ✅ Floating QR Scanner
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFF67C949),
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  // ==================== 🏠 HOME SCREEN BODY ====================
  Widget _buildHomeScreen(double topPadding) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: topPadding - 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickActionsCard(),
          const SizedBox(height: 20),
          _buildPromoBanner(),
          const SizedBox(height: 15),

          ...categorySections.asMap().entries.map((entry) {
            int index = entry.key;
            var section = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategorySection(section),
                if (index == 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 15),
                    child: _buildImageSliderBanner(),
                  ),
              ],
            );
          }),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ==================== 💳 WALLET SCREEN BODY ====================
  Widget _buildWalletScreen(double topPadding) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: topPadding + 20, left: 20, right: 20, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Manage Balances', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF009688), Color(0xFF004D40)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Main Wallet', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    Icon(Icons.account_balance_wallet, color: Colors.white.withValues(alpha: 0.5), size: 20),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('₹ 45,230.50', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _walletButton(Icons.add_circle, 'Add Money', true)),
                    const SizedBox(width: 12),
                    Expanded(child: _walletButton(Icons.send, 'Send Money', false)),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))],
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('AEPS Balance', style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w600)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(10)),
                      child: const Text('Settlement', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                const Text('₹ 12,500.00', style: TextStyle(color: Colors.black87, fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.sync_alt, size: 18),
                    label: const Text('Transfer to Main Wallet', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8F5E9),
                      foregroundColor: primaryColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.account_balance, size: 18),
                    label: const Text('Move to Bank (Settlement)', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(foregroundColor: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _walletButton(IconData icon, String label, bool isPrimary) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.white : Colors.white.withValues(alpha: 0.15),
        foregroundColor: isPrimary ? primaryColor : Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ==================== COMING SOON SCREEN ====================
  Widget _buildComingSoon(double topPadding) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text('Section Coming Soon', style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ==================== QUICK ACTIONS (HOME) ====================
  Widget _buildQuickActionsCard() {
    return Stack(
      children: [
        Container(
          height: 60, width: double.infinity,
          decoration: BoxDecoration(color: primaryColor, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _topActionIcon(Icons.add_card, 'Add Money'),
              _topActionIcon(Icons.send_to_mobile, 'To Mobile'),
              _topActionIcon(Icons.account_balance, 'To Bank'),
              _topActionIcon(Icons.history_edu, 'History'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _topActionIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 50, width: 50,
          decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))]),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }

  // ==================== OFFERS BANNER (HOME) ====================
  Widget _buildPromoBanner() {
    return SizedBox(
      height: 120,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: 2,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: index == 0 ? [const Color(0xFF009688), const Color(0xFF004D40)] : [const Color(0xFFF2994A), const Color(0xFFF2C94C)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Stack(
              children: [
                Positioned(right: -10, bottom: -10, child: Icon(Icons.campaign, color: Colors.white.withValues(alpha: 0.2), size: 90)),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)),
                        child: const Text('MEGA OFFER', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      ),
                      const SizedBox(height: 8),
                      Text(index == 0 ? 'Flat ₹50 Cashback' : 'Free Bank Settlement', style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(index == 0 ? 'On your first AEPS transaction' : 'For all premium users', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ==================== IMAGE SLIDER BANNER ====================
  Widget _buildImageSliderBanner() {
    final List<String> images = [
      'https://img.freepik.com/premium-photo/digital-payment-technology-graphic_53876-113543.jpg',
      'https://img.freepik.com/premium-photo/online-shopping-digital-marketing_53876-113539.jpg',
      'https://img.freepik.com/premium-photo/mobile-banking-money-transfer_53876-113538.jpg'
    ];

    return CarouselSlider.builder(
      itemCount: images.length,
      options: CarouselOptions(
        height: 130,
        viewportFraction: 0.88,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
      itemBuilder: (context, index, realIndex) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey));
              },
            ),
          ),
        );
      },
    );
  }

  // ==================== CATEGORY GRID ====================
  Widget _buildCategorySection(Map<String, dynamic> sectionData) {
    String id = sectionData['id'];
    String title = sectionData['title'];
    bool isPinned = sectionData['isPinned'];
    List<Map<String, dynamic>> services = sectionData['services'];

    return Padding(
      key: ValueKey(id),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87)),
              InkWell(
                onTap: () => _toggleSectionPin(id),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: isPinned ? primaryColor : Colors.transparent, borderRadius: BorderRadius.circular(20), border: Border.all(color: isPinned ? primaryColor : Colors.grey.shade400)),
                  child: Row(
                    children: [
                      Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined, size: 14, color: isPinned ? Colors.white : Colors.grey.shade700),
                      const SizedBox(width: 4),
                      Text(isPinned ? 'Pinned' : 'Pin to top', style: TextStyle(color: isPinned ? Colors.white : Colors.grey.shade700, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)]),
            child: GridView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), padding: EdgeInsets.zero, itemCount: services.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 15, childAspectRatio: 0.75),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(height: 48, width: 48, decoration: BoxDecoration(color: const Color(0xFFF0FAF9), borderRadius: BorderRadius.circular(12)), child: Icon(services[index]['icon'] as IconData, color: primaryColor, size: 24)),
                    const SizedBox(height: 6),
                    Expanded(child: Text(services[index]['name'] as String, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.1))),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==================== BOTTOM NAV BAR ====================
  Widget _buildBottomNav() {
    return BottomAppBar(
      color: deepMenuColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(0, Icons.home_filled, 'Home'),
            _navItem(1, Icons.account_balance_wallet_outlined, 'Wallet'),
            const SizedBox(width: 40),
            _navItem(2, Icons.history, 'History'),
            _navItem(3, Icons.person_outline, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    bool isActive = _currentIndex == index;
    final color = isActive ? Colors.white : Colors.white54;

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: isActive ? 28 : 24),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: isActive ? FontWeight.bold : FontWeight.w500)),
        ],
      ),
    );
  }
}