import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:paysaral/main.dart'; // Logout के बाद LoginScreen पर जाने के लिए
import 'upgrade_retailer_screen.dart';
import 'app_colors.dart';

class ProfileScreen extends StatefulWidget {
  final double topPadding;
  const ProfileScreen({super.key, required this.topPadding});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isBiometricEnabled = false;
  bool isB2B = false;
  bool _isLoading = true; // ✅ स्मूथ लोडिंग के लिए

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // हल्का सा डिले ताकि स्क्रीन जंप ना मारे
    await Future.delayed(const Duration(milliseconds: 50));
    if (mounted) {
      setState(() {
        isB2B = prefs.getBool('isB2B') ?? false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // ✅ FIX: यहाँ भी ClampingScrollPhysics लगा दिया ताकि रबर इफ़ेक्ट न आए
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.only(
        top: widget.topPadding + 20,
        left: 20, right: 20, bottom: 40,
      ),
      // ✅ JADOO: AnimatedOpacity लगा दी गई है (तुम्हारा पूरा कोड इसके अंदर है)
      child: AnimatedOpacity(
        opacity: _isLoading ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= PROFILE HEADER =================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.deepMenuColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: isB2B ? AppColors.accentColor : Colors.blueAccent, width: 2.5),
                    ),
                    child: const CircleAvatar(
                      radius: 35, backgroundColor: Colors.white24,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isB2B ? 'Paysaral Merchant' : 'Paysaral User', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        const Text('+91 9876543210', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isB2B ? AppColors.accentColor : Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(isB2B ? Icons.verified : Icons.person_outline, color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text(isB2B ? 'KYC Verified' : 'Regular User', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.qr_code, color: Colors.white, size: 28), onPressed: () {})
                ],
              ),
            ),

            // ================= UPGRADE BANNER (FIERY ORANGE) =================
            if (!isB2B) ...[
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const UpgradeRetailerStep1()));
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: const Color(0xFFFF4B2B).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 7))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                        child: const Icon(Icons.storefront, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Become a Retailer', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('Complete KYC & earn daily commission!', style: TextStyle(color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // ================= PERSONAL PROFILE =================
            _sectionTitle('PERSONAL PROFILE'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  _profileMenuItem(Icons.person_pin_outlined, 'My Profile Information', 'Name, Email, Phone, Address', Colors.orange),
                  _divider(),
                  if (!isB2B) _profileMenuItem(Icons.card_giftcard_rounded, 'Refer & Earn', 'Invite friends and earn cashback', Colors.green),
                  if (!isB2B) _divider(),
                  _profileMenuItem(Icons.notifications_active_outlined, 'Notification Settings', 'Manage app & email alerts', Colors.blue),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= PAYMENTS & BUSINESS (ONLY FOR B2B) =================
            if (isB2B) ...[
              _sectionTitle('PAYMENTS & BUSINESS'),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    _profileMenuItem(Icons.account_balance, 'Bank Accounts', 'Manage settlement banks', Colors.blue),
                    _divider(),
                    _profileMenuItem(Icons.storefront, 'Business Details', 'Shop, GST & Trade License', Colors.orange),
                    _divider(),
                    _profileMenuItem(Icons.speed, 'Transaction Limits', 'Check daily & monthly limits', Colors.purple),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // ================= SECURITY & SETTINGS =================
            _sectionTitle('SECURITY & SETTINGS'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
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

            // ================= HELP & LEGAL =================
            _sectionTitle('HELP & LEGAL'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
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

            // ================= LOGOUT BUTTON =================
            SizedBox(
              width: double.infinity, height: 55,
              child: OutlinedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.power_settings_new, color: Colors.red),
                label: const Text('Logout', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Center(child: Text('App Version 1.0.0', style: TextStyle(color: Colors.grey, fontSize: 12))),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 10),
      child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 1.2)),
    );
  }

  Widget _profileMenuItem(IconData icon, String title, String subtitle, Color iconColor) {
    return ListTile(
      // ✅ FIX: यहाँ vertical: 8 लगा दिया जिससे एकदम मस्त और खुला गैप आ जाएगा
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black87)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: () {},
    );
  }

  // ✅ तुम्हारा ओरिजिनल कस्टम एनिमेटेड स्विच विजेट
  Widget _profileSwitchItem(IconData icon, String title, String subtitle, bool value, ValueChanged<bool> onChanged, Color iconColor) {
    return ListTile(
      // ✅ FIX: यहाँ भी vertical: 8 का गैप
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black87)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ),
      trailing: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 46, height: 24,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: value ? AppColors.primaryColor : Colors.grey.shade300),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            curve: Curves.easeInOut,
            child: Container(
              margin: const EdgeInsets.all(2), width: 20, height: 20,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    // ✅ FIX: लाइन को भी बैलेंस कर दिया (indent 74) ताकि आइकॉन के गैप से मैच कर जाए
    return Divider(height: 1, thickness: 1, color: Colors.grey.shade100, indent: 74, endIndent: 20);
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
  }
}