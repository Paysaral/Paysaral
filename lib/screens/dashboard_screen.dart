import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:paysaral/main.dart'; // Logout के बाद LoginScreen पर जाने के लिए

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // ✅ Theme Colors
  final Color primaryColor = const Color(0xFF009688); // Main Teal Color
  final Color deepMenuColor = const Color(0xFF004D40); // Dark Green
  final Color accentColor = const Color(0xFF67C949); // Logo Second Color (Light Green)
  final Color bgColor = const Color(0xFFF5F6FA);

  int _currentIndex = 0;
  bool _isBiometricEnabled = false;

  // ==========================================
  // ✅ SECTIONS DATA (Home के लिए)
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
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double headerHeight = statusBarHeight + 65;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            Positioned.fill(
              child: _currentIndex == 0
                  ? _buildHomeScreen(headerHeight)
                  : _currentIndex == 1
                  ? _buildWalletScreen(headerHeight)
                  : _currentIndex == 2
                  ? _buildReportsScreen(headerHeight)
                  : _currentIndex == 3
                  ? _buildProfileScreen(headerHeight)
                  : _buildComingSoon(headerHeight),
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: headerHeight,
                padding: EdgeInsets.only(
                  top: statusBarHeight,
                  left: 20,
                  right: 20,
                ),
                decoration: BoxDecoration(
                  color: primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: accentColor,
                              width: 2,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white24,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentIndex == 0
                                  ? 'Welcome Back,'
                                  : _currentIndex == 1
                                  ? 'My Wallet'
                                  : _currentIndex == 2
                                  ? 'My Reports'
                                  : _currentIndex == 3
                                  ? 'My Profile'
                                  : 'Paysaral',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                            const Text(
                              'Paysaral User',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.help_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {},
                        ),
                        const Icon(
                          Icons.notifications_active_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: accentColor,
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.qr_code_scanner,
            color: Colors.white,
            size: 28,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

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

  Widget _buildWalletScreen(double topPadding) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: topPadding + 20,
        left: 20,
        right: 20,
        bottom: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage Balances',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF009688), Color(0xFF004D40)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Main Wallet',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white.withValues(alpha: 0.5),
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '₹ 45,230.50',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _walletButton(Icons.add_circle, 'Add Money', true),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _walletButton(Icons.send, 'Send Money', false),
                    ),
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
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'AEPS Balance',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Settlement',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '₹ 12,500.00',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.sync_alt, size: 18),
                    label: const Text(
                      'Transfer to Main Wallet',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8F5E9),
                      foregroundColor: primaryColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.account_balance, size: 18),
                    label: const Text(
                      'Move to Bank (Settlement)',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
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

  Widget _buildReportsScreen(double topPadding) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: topPadding + 20,
        left: 20,
        right: 20,
        bottom: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Business Reports',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          _sectionTitle('FINANCIAL LEDGERS'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              children: [
                // ✅ Colorful Icons Passed Here
                _reportMenuItem(Icons.menu_book, 'Main Wallet Ledger', 'Check all your wallet top-ups & debits', Colors.blue),
                _divider(),
                _reportMenuItem(Icons.account_balance, 'AEPS Settlement Ledger', 'History of wallet to bank transfers', Colors.orange),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _sectionTitle('SERVICE TRANSACTIONS'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              children: [
                _reportMenuItem(Icons.phone_android, 'Recharge & BBPS History', 'Mobile, DTH, Electricity bill status', Colors.purple),
                _divider(),
                _reportMenuItem(Icons.fingerprint, 'AEPS & mATM Report', 'Cash withdrawal & balance enquiry info', Colors.teal),
                _divider(),
                _reportMenuItem(Icons.sync_alt, 'Money Transfer (DMT)', 'Domestic money remittance status', Colors.indigo),
                _divider(),
                _reportMenuItem(Icons.flight_takeoff, 'Travel & Services', 'Flight, Train, PAN Card transaction history', Colors.redAccent),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _sectionTitle('EARNINGS & TAXES'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              children: [
                _reportMenuItem(Icons.savings, 'Commission Report', 'Detailed report of earnings per service', Colors.green),
                _divider(),
                _reportMenuItem(Icons.request_quote, 'TDS Deduction Report', 'Monthly & Yearly TDS statements', Colors.deepOrange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileScreen(double topPadding) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: topPadding + 20,
        left: 20,
        right: 20,
        bottom: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: deepMenuColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: accentColor,
                      width: 2.5,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Paysaral User',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '+91 9876543210',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'KYC Verified',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.qr_code,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {},
                )
              ],
            ),
          ),

          const SizedBox(height: 24),

          _sectionTitle('PAYMENTS & BUSINESS'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              children: [
                // ✅ Colorful Icons Passed Here
                _profileMenuItem(Icons.account_balance, 'Bank Accounts', 'Manage settlement banks', Colors.blue),
                _divider(),
                _profileMenuItem(Icons.storefront, 'Business Details', 'Shop, GST & Trade License', Colors.orange),
                _divider(),
                _profileMenuItem(Icons.speed, 'Transaction Limits', 'Check daily & monthly limits', Colors.purple),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _sectionTitle('SECURITY & SETTINGS'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              children: [
                _profileSwitchItem(Icons.fingerprint, 'Fingerprint Login', 'Unlock app with biometric', _isBiometricEnabled, (val) {
                  setState(() { _isBiometricEnabled = val; });
                }, Colors.teal),
                _divider(),
                _profileMenuItem(Icons.lock_outline, 'Change MPIN / Password', 'Update your security pin', Colors.redAccent),
                _divider(),
                _profileMenuItem(Icons.devices, 'Manage Devices', 'Devices logged into your account', Colors.indigo),
                _divider(),
                _profileMenuItem(Icons.language, 'App Language', 'English, Hindi & more', Colors.lightBlue),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _sectionTitle('HELP & LEGAL'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              children: [
                _profileMenuItem(Icons.support_agent, '24/7 Support', 'Raise a ticket or chat with us', Colors.green),
                _divider(),
                _profileMenuItem(Icons.description_outlined, 'Terms & Policies', 'Read our rules and privacy policy', Colors.blueGrey),
              ],
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: OutlinedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(
                Icons.power_settings_new,
                color: Colors.red,
              ),
              label: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Colors.red,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Center(
            child: Text(
              'App Version 1.0.0',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        bottom: 10,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // ✅ Updated to accept Icon Color
  Widget _profileMenuItem(IconData icon, String title, String subtitle, Color iconColor) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12), // ✅ Dynamic light background
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: iconColor, // ✅ Dynamic vibrant color
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      onTap: () {},
    );
  }

  // ✅ Updated to accept Icon Color
  Widget _reportMenuItem(IconData icon, String title, String subtitle, Color iconColor) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12), // ✅ Dynamic light background
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: iconColor, // ✅ Dynamic vibrant color
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      onTap: () {},
    );
  }

  // ✅ Updated to accept Icon Color
  Widget _profileSwitchItem(IconData icon, String title, String subtitle, bool value, ValueChanged<bool> onChanged, Color iconColor) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12), // ✅ Dynamic light background
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: iconColor, // ✅ Dynamic vibrant color
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 46,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: value ? primaryColor : Colors.grey.shade300,
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            curve: Curves.easeInOut,
            child: Container(
              margin: const EdgeInsets.all(2),
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade100,
      indent: 60,
      endIndent: 20,
    );
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  Widget _buildComingSoon(double topPadding) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Section Coming Soon',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _walletButton(IconData icon, String label, bool isPrimary) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(
        icon,
        size: 16,
      ),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? accentColor : Colors.white.withValues(alpha: 0.15),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Stack(
      children: [
        Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _topActionIcon(Icons.add_card, 'Add Money', onTap: () {}),
              _topActionIcon(Icons.send_to_mobile, 'To Mobile', onTap: () {}),
              _topActionIcon(Icons.account_balance, 'To Bank', onTap: () {}),
              _topActionIcon(Icons.history_edu, 'History', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
                );
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
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
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
                colors: index == 0
                    ? [const Color(0xFF009688), const Color(0xFF004D40)]
                    : [const Color(0xFFF2994A), const Color(0xFFF2C94C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Icon(
                    Icons.campaign,
                    color: Colors.white.withValues(alpha: 0.2),
                    size: 90,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'MEGA OFFER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        index == 0 ? 'Flat ₹50 Cashback' : 'Free Bank Settlement',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        index == 0
                            ? 'On your first AEPS transaction'
                            : 'For all premium users',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
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
      options: CarouselOptions(
        height: 130,
        viewportFraction: 0.88,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
      itemBuilder: (context, index, realIndex) {
        String imagePath = images[index];

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: imagePath.startsWith('http')
                ? Image.network(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            )
                : Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }

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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              InkWell(
                onTap: () => _toggleSectionPin(id),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isPinned ? accentColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isPinned ? accentColor : Colors.grey.shade400,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                        size: 14,
                        color: isPinned ? Colors.white : Colors.grey.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isPinned ? 'Pinned' : 'Pin to top',
                        style: TextStyle(
                          color: isPinned ? Colors.white : Colors.grey.shade700,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(top: 18, left: 16, right: 16, bottom: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                )
              ],
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: services.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 4,
                childAspectRatio: 0.74,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (services[index]['name'] == 'Mobile') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MobileRechargeScreen()),
                      );
                    } else if (services[index]['name'] == 'DTH') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DthRechargeScreen()),
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FAF9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          services[index]['icon'] as IconData,
                          color: primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Text(
                          services[index]['name'] as String,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            height: 1.1,
                          ),
                        ),
                      ),
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

  Widget _buildBottomNav() {
    return BottomAppBar(
      color: deepMenuColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(0, Icons.home_filled, 'Home'),
            _navItem(1, Icons.account_balance_wallet_outlined, 'Wallet'),
            const SizedBox(width: 40),
            _navItem(2, Icons.receipt_long, 'Reports'),
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
          Icon(
            icon,
            color: color,
            size: isActive ? 28 : 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// ✅ TRANSACTION HISTORY SCREEN
// =========================================================================
class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final Color primaryColor = const Color(0xFF009688);
  final Color accentColor = const Color(0xFF67C949);
  final Color bgColor = const Color(0xFFF5F6FA);

  String _selectedDate = '7 Days';
  String _selectedCategory = 'All';
  String _selectedPaymentType = 'All';
  String _selectedStatus = 'All';

  final List<Map<String, dynamic>> _transactions = [
    {
      'title': 'Cashback Received',
      'date': '20 Mar 2026, 10:30 AM',
      'amount': '+ ₹50.00',
      'isCredit': true,
      'icon': Icons.card_giftcard,
      'status': 'Success'
    },
    {
      'title': 'Mobile Recharge (Jio)',
      'date': '19 Mar 2026, 06:15 PM',
      'amount': '- ₹299.00',
      'isCredit': false,
      'icon': Icons.phone_android,
      'status': 'Success'
    },
    {
      'title': 'Money sent to Rahul',
      'date': '18 Mar 2026, 02:45 PM',
      'amount': '- ₹1,500.00',
      'isCredit': false,
      'icon': Icons.send,
      'status': 'Success'
    },
    {
      'title': 'AEPS Settlement',
      'date': '18 Mar 2026, 11:20 AM',
      'amount': '+ ₹12,000.00',
      'isCredit': true,
      'icon': Icons.fingerprint,
      'status': 'Success'
    },
    {
      'title': 'Electricity Bill (JBVNL)',
      'date': '15 Mar 2026, 09:00 PM',
      'amount': '- ₹850.00',
      'isCredit': false,
      'icon': Icons.lightbulb_outline,
      'status': 'Failed'
    },
    {
      'title': 'Wallet Topup (UPI)',
      'date': '12 Mar 2026, 01:10 PM',
      'amount': '+ ₹5,000.00',
      'isCredit': true,
      'icon': Icons.account_balance_wallet,
      'status': 'Success'
    },
  ];

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Container(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            height: 5,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Filter Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Divider(height: 30),

                        const Text('Date Range', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ['Today', 'Yesterday', '7 Days', '1 Month', '3 Months', '1 Year'].map((date) {
                            return ChoiceChip(
                              label: Text(date),
                              selected: _selectedDate == date,
                              selectedColor: accentColor,
                              labelStyle: TextStyle(
                                color: _selectedDate == date ? Colors.white : Colors.black87,
                                fontWeight: _selectedDate == date ? FontWeight.bold : FontWeight.normal,
                              ),
                              onSelected: (bool selected) {
                                if (selected) setModalState(() => _selectedDate = date);
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        const Text('Service Category', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ['All', 'Recharge', 'DTH', 'Electricity', 'Water', 'Gas', 'Fastag'].map((category) {
                            return ChoiceChip(
                              label: Text(category),
                              selected: _selectedCategory == category,
                              selectedColor: accentColor,
                              labelStyle: TextStyle(
                                color: _selectedCategory == category ? Colors.white : Colors.black87,
                                fontWeight: _selectedCategory == category ? FontWeight.bold : FontWeight.normal,
                              ),
                              onSelected: (bool selected) {
                                if (selected) setModalState(() => _selectedCategory = category);
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        const Text('Payment Type', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ['All', 'Payment', 'Received'].map((type) {
                            return ChoiceChip(
                              label: Text(type),
                              selected: _selectedPaymentType == type,
                              selectedColor: accentColor,
                              labelStyle: TextStyle(
                                color: _selectedPaymentType == type ? Colors.white : Colors.black87,
                                fontWeight: _selectedPaymentType == type ? FontWeight.bold : FontWeight.normal,
                              ),
                              onSelected: (bool selected) {
                                if (selected) setModalState(() => _selectedPaymentType = type);
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        const Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ['All', 'Success', 'Failed', 'Pending'].map((status) {
                            return ChoiceChip(
                              label: Text(status),
                              selected: _selectedStatus == status,
                              selectedColor: accentColor,
                              labelStyle: TextStyle(
                                color: _selectedStatus == status ? Colors.white : Colors.black87,
                                fontWeight: _selectedStatus == status ? FontWeight.bold : FontWeight.normal,
                              ),
                              onSelected: (bool selected) {
                                if (selected) setModalState(() => _selectedStatus = status);
                              },
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            onPressed: () {
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          'Recent Transactions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing: $_selectedDate',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                OutlinedButton.icon(
                  onPressed: () => _showFilterBottomSheet(context),
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: const Text('Filter & Sort'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                  )
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: _transactions.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey.shade100,
                  indent: 60,
                ),
                itemBuilder: (context, index) {
                  var txn = _transactions[index];
                  return _transactionTile(txn);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionTile(Map<String, dynamic> txn) {
    bool isCredit = txn['isCredit'];
    bool isFailed = txn['status'] == 'Failed';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: isFailed
              ? Colors.red.shade50
              : const Color(0xFFF0FAF9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          txn['icon'],
          color: isFailed ? Colors.red : primaryColor,
          size: 22,
        ),
      ),
      title: Text(
        txn['title'],
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Colors.black87,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          txn['date'],
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            txn['amount'],
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: isFailed
                  ? Colors.grey
                  : (isCredit ? Colors.green.shade600 : Colors.black87),
            ),
          ),
          if (isFailed) ...[
            const SizedBox(height: 2),
            const Text(
              'Failed',
              style: TextStyle(
                fontSize: 10,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]
        ],
      ),
      onTap: () {},
    );
  }
}

// =========================================================================
// ✅ MOBILE RECHARGE SCREEN (With Prepaid/Postpaid Toggle & Slider logic)
// =========================================================================
class MobileRechargeScreen extends StatefulWidget {
  const MobileRechargeScreen({super.key});

  @override
  State<MobileRechargeScreen> createState() => _MobileRechargeScreenState();
}

class _MobileRechargeScreenState extends State<MobileRechargeScreen> {
  final Color primaryColor = const Color(0xFF009688);
  final Color accentColor = const Color(0xFF67C949);
  final Color bgColor = const Color(0xFFF5F6FA);

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();

  bool isPrepaid = true;
  int _currentOfferIndex = 0; // ✅ Slider के लिए

  final List<Map<String, dynamic>> operatorsList = [
    {'name': 'Airtel', 'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Airtel_logo.png/512px-Airtel_logo.png', 'color': Colors.red},
    {'name': 'Jio', 'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Reliance_Jio_Logo_%28October_2015%29.svg/512px-Reliance_Jio_Logo_%28October_2015%29.svg.png', 'color': Colors.blue.shade700},
    {'name': 'Vi', 'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Vodafone_Idea_logo.svg/512px-Vodafone_Idea_logo.svg.png', 'color': Colors.redAccent},
    {'name': 'BSNL', 'logo': 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e0/BSNL_logo.svg/512px-BSNL_logo.svg.png', 'color': Colors.blueAccent},
  ];

  final List<String> circlesList = ['Jharkhand', 'Bihar', 'Delhi', 'Mumbai', 'West Bengal', 'Assam', 'Odisha', 'UP East', 'UP West'];

  final List<Map<String, dynamic>> recentRecharges = [
    {'name': 'Rahul Singh', 'number': '9876543210', 'operator': 'Jio'},
    {'name': 'Mom', 'number': '9123456789', 'operator': 'Airtel'},
    {'name': 'Shop WiFi', 'number': '9988776655', 'operator': 'Vi'},
    {'name': 'Papa', 'number': '9431000000', 'operator': 'Airtel'},
    {'name': 'Amit', 'number': '9123412345', 'operator': 'Jio'},
    {'name': 'Office', 'number': '9988001122', 'operator': 'Vi'},
    {'name': 'Rakesh Bhai', 'number': '9898989898', 'operator': 'BSNL'},
  ];

  final List<String> quickAmounts = ['₹199', '₹299', '₹349', '₹666'];

  // ✅ Postpaid Slider के लिए इमेजेस
  final List<String> offerImages = [
    'assets/images/bg1.png',
    'https://img.freepik.com/premium-photo/digital-payment-technology-graphic_53876-113543.jpg',
    'https://img.freepik.com/premium-photo/online-shopping-digital-marketing_53876-113539.jpg',
    'https://img.freepik.com/premium-photo/mobile-banking-money-transfer_53876-113538.jpg'
  ];

  // ✅ Colorful Dots
  final List<Color> dotColors = [
    Colors.orange,
    Colors.blue,
    Colors.purple,
    Colors.redAccent,
    Colors.teal
  ];

  String selectedOperator = 'Airtel';
  String selectedCircle = 'Jharkhand';

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  Widget _buildLogo(String name, String url, Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.network(
            url,
            fit: BoxFit.contain,
            errorBuilder: (c, e, s) => Center(
              child: Text(
                name[0],
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: size * 0.4),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showOperatorCircleBottomSheet(BuildContext context) {
    int step = 1;
    String tempOp = selectedOperator;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.55,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      height: 5, width: 50,
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      if (step == 2)
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => setModalState(() => step = 1),
                        ),
                      if (step == 2) const SizedBox(width: 10),
                      Text(
                        step == 1 ? 'Select Operator' : 'Select Circle',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: step == 1
                        ? ListView.separated(
                      itemCount: operatorsList.length,
                      separatorBuilder: (c, i) => const Divider(height: 1),
                      itemBuilder: (c, i) {
                        var op = operatorsList[i];
                        return ListTile(
                          leading: _buildLogo(op['name'], op['logo'], op['color'], 40),
                          title: Text(op['name'], style: const TextStyle(fontWeight: FontWeight.w500)),
                          trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                          onTap: () {
                            setModalState(() {
                              tempOp = op['name'];
                              step = 2;
                            });
                          },
                        );
                      },
                    )
                        : ListView.separated(
                      itemCount: circlesList.length,
                      separatorBuilder: (c, i) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(circlesList[index]),
                          onTap: () {
                            setState(() {
                              selectedOperator = tempOp;
                              selectedCircle = circlesList[index];
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var opData = operatorsList.firstWhere((o) => o['name'] == selectedOperator);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          title: const Text(
            'Mobile Recharge',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    // ✅ Prepaid / Postpaid Custom Toggle
                    Container(
                      height: 45,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPrepaid = true;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  color: isPrepaid ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: isPrepaid ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
                                ),
                                child: Center(
                                  child: Text(
                                    'Prepaid',
                                    style: TextStyle(
                                      color: isPrepaid ? primaryColor : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPrepaid = false;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  color: !isPrepaid ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: !isPrepaid ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
                                ),
                                child: Center(
                                  child: Text(
                                    'Postpaid',
                                    style: TextStyle(
                                      color: !isPrepaid ? primaryColor : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // ✅ Number Input Box
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 10)
                        ],
                      ),
                      child: TextField(
                        controller: _phoneController,
                        focusNode: _phoneFocus,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: 'Enter Your M.No',
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w400, fontSize: 17),
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                          suffixIcon: Icon(Icons.contact_phone, color: primaryColor),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _buildLogo(selectedOperator, opData['logo'], opData['color'], 45),
                            const SizedBox(width: 12),
                            Text(
                              '$selectedOperator • $selectedCircle',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => _showOperatorCircleBottomSheet(context),
                          child: Text(
                            'Change',
                            style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 25),

                    // ✅ Smart Text Update based on Toggle
                    Text(isPrepaid ? 'Recharge Amount' : 'Bill Amount', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.currency_rupee, color: Colors.black87),
                        hintText: '0',
                        suffixIcon: TextButton(
                          onPressed: () {},
                          // ✅ Smart Button Update
                          child: Text(isPrepaid ? 'Browse Plans' : 'View Bill', style: TextStyle(color: primaryColor)),
                        ),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2)),
                      ),
                    ),

                    // ✅ Quick Amounts only for Prepaid
                    if (isPrepaid) ...[
                      const SizedBox(height: 15),
                      Wrap(
                        spacing: 10,
                        children: quickAmounts.map((a) => ActionChip(
                          label: Text(a),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFE0E0E0)),
                          onPressed: () => _amountController.text = a.replaceAll('₹', ''),
                        )).toList(),
                      ),
                    ],

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: Text(
                          // ✅ Smart Pay Button Update
                          isPrepaid ? 'Proceed to Pay' : 'Pay Bill',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ✅ Smart Logic: Show Recent list if Prepaid, Show Slider if Postpaid
                    if (isPrepaid) ...[
                      const Text(
                        'Recent Recharges',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 15),
                      ...recentRecharges.map((recent) {
                        var opD = operatorsList.firstWhere((o) => o['name'] == recent['operator']);
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: _buildLogo(recent['operator'], opD['logo'], opD['color'], 40),
                          title: Text(recent['name'], style: const TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text('${recent['number']} • ${recent['operator']}', style: const TextStyle(fontSize: 12)),
                          trailing: const Icon(Icons.chevron_right, size: 20),
                          onTap: () {
                            _phoneController.text = recent['number'];
                            setState(() => selectedOperator = recent['operator']);
                          },
                        );
                      }).toList(),
                    ] else ...[
                      // ✅ Postpaid Slider Logic
                      Column(
                        children: [
                          CarouselSlider.builder(
                            itemCount: offerImages.length,
                            options: CarouselOptions(
                                height: 100,
                                viewportFraction: 1.0,
                                enlargeCenterPage: false,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentOfferIndex = index;
                                  });
                                }
                            ),
                            itemBuilder: (context, index, realIndex) {
                              String imagePath = offerImages[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: imagePath.startsWith('http')
                                      ? Image.network(
                                    imagePath,
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.grey.shade300,
                                      child: const Center(child: Icon(Icons.image, color: Colors.grey)),
                                    ),
                                  )
                                      : Image.asset(
                                    imagePath,
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.grey.shade300,
                                      child: const Center(child: Icon(Icons.image, color: Colors.grey)),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: offerImages.asMap().entries.map((entry) {
                              Color activeDotColor = dotColors[entry.key % dotColors.length];
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: _currentOfferIndex == entry.key ? 18.0 : 8.0,
                                height: 8.0,
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: _currentOfferIndex == entry.key
                                      ? activeDotColor
                                      : Colors.grey.shade300,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// ✅ DTH RECHARGE SCREEN (With Fixed Operator Sheet)
// =========================================================================
class DthRechargeScreen extends StatefulWidget {
  const DthRechargeScreen({super.key});

  @override
  State<DthRechargeScreen> createState() => _DthRechargeScreenState();
}

class _DthRechargeScreenState extends State<DthRechargeScreen> {
  final Color primaryColor = const Color(0xFF009688);
  final Color accentColor = const Color(0xFF67C949);
  final Color bgColor = const Color(0xFFF5F6FA);

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _idFocus = FocusNode();

  int _currentOfferIndex = 0;

  // ✅ DTH Operators
  final List<Map<String, dynamic>> operatorsList = [
    {'name': 'Tata Play', 'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7b/Tata_Play_2022_logo.svg/512px-Tata_Play_2022_logo.svg.png', 'color': Colors.purple},
    {'name': 'Airtel Digital TV', 'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Airtel_logo.png/512px-Airtel_logo.png', 'color': Colors.red},
    {'name': 'Dish TV', 'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Dish_TV_India_logo.svg/512px-Dish_TV_India_logo.svg.png', 'color': Colors.orange},
    {'name': 'Sun Direct', 'logo': 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e6/Sun_Direct_logo.svg/512px-Sun_Direct_logo.svg.png', 'color': Colors.yellow.shade700},
    {'name': 'Videocon D2H', 'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Videocon_d2h_Logo.svg/512px-Videocon_d2h_Logo.svg.png', 'color': Colors.green},
  ];

  // ✅ Slider Images List
  final List<String> dthOfferImages = [
    'assets/images/bg1.png',
    'https://img.freepik.com/premium-photo/digital-payment-technology-graphic_53876-113543.jpg',
    'https://img.freepik.com/premium-photo/online-shopping-digital-marketing_53876-113539.jpg',
    'https://img.freepik.com/premium-photo/mobile-banking-money-transfer_53876-113538.jpg'
  ];

  // ✅ Colorful Dots List
  final List<Color> dotColors = [
    Colors.orange,
    Colors.blue,
    Colors.purple,
    Colors.redAccent,
    Colors.teal
  ];

  String selectedOperator = 'Tata Play';
  final List<String> quickAmounts = ['₹200', '₹300', '₹500', '₹1000'];

  @override
  void dispose() {
    _idController.dispose();
    _amountController.dispose();
    _idFocus.dispose();
    super.dispose();
  }

  Widget _buildLogo(String name, String url, Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.network(
            url,
            fit: BoxFit.contain,
            errorBuilder: (c, e, s) => Center(
              child: Text(
                name[0],
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: size * 0.4),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Fixed _showOperatorSheet just like MobileRechargeScreen
  void _showOperatorSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.55,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5, width: 50,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Select DTH Operator', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              Expanded(
                child: ListView.separated(
                  itemCount: operatorsList.length,
                  separatorBuilder: (c, i) => const Divider(height: 1),
                  itemBuilder: (c, i) {
                    var op = operatorsList[i];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                      leading: _buildLogo(op['name'], op['logo'], op['color'], 40),
                      title: Text(op['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                      onTap: () {
                        setState(() => selectedOperator = op['name']);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var opData = operatorsList.firstWhere((o) => o['name'] == selectedOperator);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          title: const Text(
            'DTH Recharge',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 10)
                    ],
                  ),
                  child: TextField(
                    controller: _idController,
                    focusNode: _idFocus,
                    keyboardType: TextInputType.text,
                    maxLength: 20,
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Enter Subscriber ID / VC No.',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w400, fontSize: 17),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.tv, color: Colors.grey),
                      suffixIcon: Icon(Icons.contact_mail, color: primaryColor),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _buildLogo(selectedOperator, opData['logo'], opData['color'], 45),
                            const SizedBox(width: 12),
                            Text(
                              selectedOperator,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => _showOperatorSheet(context),
                          child: Text(
                            'Change',
                            style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 25),

                    const Text('Recharge Amount', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.currency_rupee, color: Colors.black87),
                        hintText: '0',
                        suffixIcon: TextButton(
                          onPressed: () {},
                          child: Text('Customer Info', style: TextStyle(color: primaryColor)),
                        ),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2)),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Wrap(
                      spacing: 10,
                      children: quickAmounts.map((a) => ActionChip(
                        label: Text(a),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                        onPressed: () => _amountController.text = a.replaceAll('₹', ''),
                      )).toList(),
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text(
                          'Proceed to Pay',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    Column(
                      children: [
                        CarouselSlider.builder(
                          itemCount: dthOfferImages.length,
                          options: CarouselOptions(
                              height: 100,
                              viewportFraction: 1.0,
                              enlargeCenterPage: false,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentOfferIndex = index;
                                });
                              }
                          ),
                          itemBuilder: (context, index, realIndex) {
                            String imagePath = dthOfferImages[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: imagePath.startsWith('http')
                                    ? Image.network(
                                  imagePath,
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: Colors.grey.shade300,
                                    child: const Center(child: Icon(Icons.image, color: Colors.grey)),
                                  ),
                                )
                                    : Image.asset(
                                  imagePath,
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: Colors.grey.shade300,
                                    child: const Center(child: Icon(Icons.image, color: Colors.grey)),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        // ✅ Colorful Slide Dots Indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: dthOfferImages.asMap().entries.map((entry) {
                            Color activeDotColor = dotColors[entry.key % dotColors.length];
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: _currentOfferIndex == entry.key ? 18.0 : 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: _currentOfferIndex == entry.key
                                    ? activeDotColor
                                    : Colors.grey.shade300,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}