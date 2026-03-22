import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'home_screen.dart';
import 'wallet_screen.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // ✅ दूसरे पेज से वापस रिपोर्ट या वॉलेट पर जाने के लिए फंक्शन
  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
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
        backgroundColor: AppColors.bgColor,
        body: Stack(
          children: [
            // ✅ यहाँ अलग-अलग पेजों की फाइलें लिंक की गई हैं
            Positioned.fill(
              child: _buildBody(headerHeight),
            ),

            // ✅ HEADER (100% Original Design)
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
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
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
                              color: AppColors.accentColor,
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
          backgroundColor: AppColors.accentColor,
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

  // बॉडी में पेज बदलने का लॉजिक
  Widget _buildBody(double topPadding) {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(topPadding: topPadding);
      case 1:
        return WalletScreen(topPadding: topPadding, onGoToReports: () => _changeTab(2));
      case 2:
        return ReportsScreen(topPadding: topPadding);
      case 3:
        return ProfileScreen(topPadding: topPadding);
      default:
        return HomeScreen(topPadding: topPadding);
    }
  }

  // ✅ BOTTOM NAVIGATION (100% Original Design)
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
      onTap: () => _changeTab(index),
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