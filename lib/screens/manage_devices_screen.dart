import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:paysaral/main.dart'; // LoginScreen ke liye
import 'app_colors.dart';

class ManageDevicesScreen extends StatelessWidget {
  const ManageDevicesScreen({super.key});

  // ✅ JADOO: Logout Function is here now!
  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Manage Devices', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Where you\'re logged in',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),

              // ── Current Device Card ──
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryColor.withOpacity(0.3), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.phone_android_rounded, color: AppColors.primaryColor, size: 28),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Android Smartphone', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                              SizedBox(height: 4),
                              Text('Bokaro Steel City, Jharkhand', style: TextStyle(fontSize: 13, color: Colors.grey)),
                              SizedBox(height: 2),
                              Text('Active now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ✅ Logout Button for Current Device
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () => _logout(context),
                        icon: const Icon(Icons.power_settings_new_rounded, color: Colors.red, size: 20),
                        label: const Text('Log Out', style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red.shade200, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          backgroundColor: Colors.red.shade50.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text(
                'Other Devices',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),

              // ── Other Device Card ──
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                    child: Icon(Icons.computer_rounded, color: Colors.grey.shade600, size: 22),
                  ),
                  title: const Text('Windows PC (Chrome)', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black87)),
                  subtitle: const Text('Ranchi, Jharkhand • Yesterday', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  trailing: IconButton(
                    icon: const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out from Windows PC')));
                    },
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ── Logout from all devices ──
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Log out from all devices', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w600, fontSize: 14)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}