import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_colors.dart';
import 'home_screen.dart';
import 'wallet_screen.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';
import 'add_money_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  bool isB2B = false;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        isB2B = prefs.getBool('isB2B') ?? false;
      });
    }
  }

  void _changeTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.paddingOf(context).top;
    final double headerHeight = statusBarHeight + 65;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (_currentIndex != 0) {
            setState(() => _currentIndex = 0);
          } else {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.bgColor,
          drawer: const MainSideDrawer(),
          body: Stack(
            children: [

              Positioned.fill(
                child: IndexedStack(
                  index: _currentIndex,
                  children: [
                    // ✅ JADOO: Ab hum HomeScreen ko bhi isB2B pass kar sakte hain
                    HomeScreen(
                      topPadding: headerHeight,
                      // isB2B: isB2B, // Agar HomeScreen me zarurat ho to ye un-comment kar lena
                    ),
                    WalletScreen(
                      topPadding: headerHeight,
                      onGoToReports: () => _changeTab(2),
                      onGoToAddMoney: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddMoneyScreen(isB2B: isB2B),
                          ),
                        );
                      },
                    ),
                    ReportsScreen(topPadding: headerHeight),
                    ProfileScreen(topPadding: headerHeight),
                  ],
                ),
              ),

              // ✅ HEADER
              Positioned(
                top: 0, left: 0, right: 0,
                child: Container(
                  height: headerHeight,
                  padding: EdgeInsets.only(
                    top: statusBarHeight,
                    left: 20,
                    right: 20,
                  ),
                  decoration: const BoxDecoration(
                      color: AppColors.primaryColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                        children: [
                          Builder(
                            builder: (ctx) => GestureDetector(
                              onTap: () => Scaffold.of(ctx).openDrawer(),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.accentColor,
                                      width: 2),
                                ),
                                child: const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white24,
                                  child: Icon(Icons.person,
                                      color: Colors.white, size: 22),
                                ),
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
                                    : 'My Profile',
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11),
                              ),
                              const Text(
                                'Paysaral User',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.help_outline,
                                color: Colors.white, size: 24),
                            onPressed: () {},
                          ),
                          const Icon(
                              Icons.notifications_active_outlined,
                              color: Colors.white,
                              size: 22),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomNav(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: AppColors.accentColor,
            elevation: 4,
            shape: const CircleBorder(),
            child: const Icon(Icons.qr_code_scanner,
                color: Colors.white, size: 28),
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      color: AppColors.deepMenuColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(0, Icons.home_filled, 'Home'),
            _navItem(
                1, Icons.account_balance_wallet_outlined, 'Wallet'),
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
      onTap: () => _changeTab(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: isActive ? 28 : 24),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: isActive
                      ? FontWeight.bold
                      : FontWeight.w500)),
        ],
      ),
    );
  }
}

// ==================== SIDE DRAWER ====================
class MainSideDrawer extends StatefulWidget {
  const MainSideDrawer({super.key});

  @override
  State<MainSideDrawer> createState() => _MainSideDrawerState();
}

class _MainSideDrawerState extends State<MainSideDrawer> {
  bool isB2B = false;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() => isB2B = prefs.getBool('isB2B') ?? false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [

          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
                top: 60, bottom: 20, left: 20),
            color: AppColors.primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person,
                      size: 35, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text('Hi, Welcome!',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 14)),
                Text(
                  isB2B
                      ? 'Paysaral Merchant'
                      : 'Paysaral Member',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(Icons.qr_code_scanner,
                    'My QR Code', Colors.black87),

                if (isB2B)
                  _drawerItem(Icons.verified_user_outlined,
                      'My Certificates', Colors.black87),

                _drawerItem(Icons.history,
                    'Transaction History', Colors.black87),

                _drawerItem(
                    Icons.account_balance_wallet_outlined,
                    'Add Money History',
                    Colors.black87),

                const Divider(),

                _drawerItem(Icons.menu_book_outlined,
                    'App Tour & Guide', Colors.black87),

                if (!isB2B)
                  _drawerItem(
                      Icons.card_giftcard_rounded,
                      'Refer & Earn 🎉',
                      Colors.orange.shade700),

                _drawerItem(
                    Icons.share, 'Share App', Colors.black87),

                _drawerItem(
                    Icons.star_rate,
                    'Rate Us on Play Store',
                    Colors.amber.shade700),

                const Divider(),

                _drawerItem(Icons.call_outlined,
                    'Contact Us', Colors.black87),

                _drawerItem(Icons.info_outline,
                    'About Paysaral', Colors.black87),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Made with ❤️ in India | Version 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, Color color) {
    return ListTile(
      leading: Icon(
        icon,
        color: color == Colors.black87
            ? AppColors.primaryColor
            : color,
        size: 22,
      ),
      title: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: color,
              fontSize: 14)),
      onTap: () {},
    );
  }
}