import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_colors.dart';

// 👇 ये तीनों स्क्रीन अब इस्तेमाल होंगी, इसलिए ग्रे से कलरफुल हो जाएंगी
import 'mobile_recharge_screen.dart';
import 'dth_recharge_screen.dart';
import 'transaction_history_screen.dart';

class HomeScreen extends StatefulWidget {
  final double topPadding;
  const HomeScreen({super.key, required this.topPadding});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> categorySections = [
    {
      'id': 'banking', 'order': 1, 'title': 'Banking & AEPS', 'isPinned': false,
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
      'id': 'recharge', 'order': 2, 'title': 'Recharge & Bill Pay', 'isPinned': false,
      'services': [
        {'icon': Icons.phone_android, 'name': 'Mobile'}, // ✅ Mobile Screen खुलेगी
        {'icon': Icons.tv, 'name': 'DTH'}, // ✅ DTH Screen खुलेगी
        {'icon': Icons.lightbulb_outline, 'name': 'Electricity'},
        {'icon': Icons.credit_card, 'name': 'Credit Card'},
        {'icon': Icons.directions_car, 'name': 'Fastag'},
        {'icon': Icons.water_drop_outlined, 'name': 'Water'},
        {'icon': Icons.gas_meter_outlined, 'name': 'Gas'},
        {'icon': Icons.grid_view, 'name': 'View All'},
      ]
    },
    {
      'id': 'travel', 'order': 3, 'title': 'Travel & More', 'isPinned': false,
      'services': [
        {'icon': Icons.flight_takeoff, 'name': 'Flight'},
        {'icon': Icons.train, 'name': 'Train'},
        {'icon': Icons.directions_bus, 'name': 'Bus'},
        {'icon': Icons.health_and_safety, 'name': 'Insurance'},
        {'icon': Icons.credit_score, 'name': 'Loan'},
        {'icon': Icons.badge_outlined, 'name': 'PAN Card'},
      ]
    },
    {
      'id': 'mall', 'order': 4, 'title': 'Paysaral Mall (Shopping)', 'isPinned': false,
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

  @override
  void initState() {
    super.initState();
    _loadPinnedPreferences();
  }

  Future<void> _loadPinnedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var section in categorySections) {
        section['isPinned'] = prefs.getBool('pinned_${section['id']}') ?? false;
      }
      _sortCategories();
    });
  }

  void _toggleSectionPin(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var section = categorySections.firstWhere((s) => s['id'] == id);
      section['isPinned'] = !section['isPinned'];
      prefs.setBool('pinned_$id', section['isPinned']);
      _sortCategories();
    });
  }

  void _sortCategories() {
    categorySections.sort((a, b) {
      if (a['isPinned'] && !b['isPinned']) return -1;
      if (!a['isPinned'] && b['isPinned']) return 1;
      return a['order'].compareTo(b['order']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: widget.topPadding - 2, bottom: 40),
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
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Stack(
      children: [
        Container(
          height: 60, width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _topActionIcon(Icons.add_card, 'Add Money', onTap: () {}),
              _topActionIcon(Icons.send_to_mobile, 'To Mobile', onTap: () {}),
              _topActionIcon(Icons.account_balance, 'To Bank', onTap: () {}),
              // ✅ HISTORY पर क्लिक करने पर खुलेगा
              _topActionIcon(Icons.history_edu, 'History', onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()));
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _topActionIcon(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50, width: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: AppColors.primaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    );
  }

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
                colors: index == 0 ? [AppColors.primaryColor, AppColors.deepMenuColor] : [const Color(0xFFF2994A), const Color(0xFFF2C94C)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Stack(
              children: [
                Positioned(right: -10, bottom: -10, child: Icon(Icons.campaign, color: Colors.white.withOpacity(0.2), size: 90)),
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

  Widget _buildImageSliderBanner() {
    final List<String> images = [
      'assets/images/bg1.png',
      'https://img.freepik.com/premium-photo/digital-payment-technology-graphic_53876-113543.jpg',
      'https://img.freepik.com/premium-photo/online-shopping-digital-marketing_53876-113539.jpg',
      'https://img.freepik.com/premium-photo/mobile-banking-money-transfer_53876-113538.jpg'
    ];

    return CarouselSlider.builder(
      itemCount: images.length,
      options: CarouselOptions(height: 130, viewportFraction: 0.88, enlargeCenterPage: true, autoPlay: true, autoPlayInterval: const Duration(seconds: 4)),
      itemBuilder: (context, index, realIndex) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: images[index].startsWith('http') ? Image.network(images[index], fit: BoxFit.cover) : Image.asset(images[index], fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  Widget _buildCategorySection(Map<String, dynamic> sectionData) {
    String id = sectionData['id'];
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
              Text(sectionData['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87)),
              InkWell(
                onTap: () => _toggleSectionPin(id),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: sectionData['isPinned'] ? AppColors.accentColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: sectionData['isPinned'] ? AppColors.accentColor : Colors.grey.shade400),
                  ),
                  child: Row(
                    children: [
                      Icon(sectionData['isPinned'] ? Icons.push_pin : Icons.push_pin_outlined, size: 14, color: sectionData['isPinned'] ? Colors.white : Colors.grey.shade700),
                      const SizedBox(width: 4),
                      Text(sectionData['isPinned'] ? 'Pinned' : 'Pin to top', style: TextStyle(color: sectionData['isPinned'] ? Colors.white : Colors.grey.shade700, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(top: 18, left: 16, right: 16, bottom: 4),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
            child: GridView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), padding: EdgeInsets.zero, itemCount: services.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 4, childAspectRatio: 0.74),
              itemBuilder: (context, index) {
                return GestureDetector(
                  // ✅ यहाँ क्लिक करने पर Mobile और DTH पेज खुलेगा
                  onTap: () {
                    if (services[index]['name'] == 'Mobile') {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MobileRechargeScreen()));
                    } else if (services[index]['name'] == 'DTH') {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DthRechargeScreen()));
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 48, width: 48,
                        decoration: BoxDecoration(color: const Color(0xFFF0FAF9), borderRadius: BorderRadius.circular(12)),
                        child: Icon(services[index]['icon'] as IconData, color: AppColors.primaryColor, size: 24),
                      ),
                      const SizedBox(height: 6),
                      Expanded(child: Text(services[index]['name'] as String, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.1))),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}