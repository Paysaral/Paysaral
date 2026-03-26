import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:paysaral/main.dart'; // LoginScreen ke liye
import 'edit_profile_screen.dart'; // ✅ JADOO: Edit Profile Screen yahan import kar li hai
import 'app_colors.dart';

class MyProfileScreen extends StatelessWidget {
  final bool isB2B;
  const MyProfileScreen({super.key, required this.isB2B});

  // ✅ Logout hidden from here (will only be used during account deletion)
  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
  }

  // ✅ Delete Account stays here
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                SizedBox(width: 10),
                Text('Delete Account?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            content: const Text(
              'Are you sure you want to permanently delete your Paysaral account? This action cannot be undone and you will lose all your wallet balance and history.',
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _logout(context); // Simulated delete behavior
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          title: const Text('My Profile', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            // ✅ JADOO: Edit Button ab directly EditProfileScreen kholega
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen(isB2B: isB2B)));
              },
              child: const Text('Edit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [

              // ── Header Background with Avatar ──
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 120,
                    margin: const EdgeInsets.only(bottom: 50),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: isB2B ? AppColors.accentColor : Colors.blueAccent, width: 2),
                          ),
                          child: const CircleAvatar(
                            radius: 45,
                            backgroundColor: Color(0xFFE8F5F3),
                            child: Icon(Icons.person, size: 50, color: AppColors.primaryColor),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.accentColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // ✅ Verified Tick Next to Name (Premium Feel)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Paysaral User',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  if (isB2B) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.verified_rounded, color: Colors.green, size: 20),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                isB2B ? 'Retailer / Merchant' : 'Regular Member',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 8),

              // Loyalty Tag (Member Since)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Member since Jan 2025',
                  style: TextStyle(color: AppColors.primaryColor, fontSize: 11.5, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 24),

              // ── Personal Details Card ──
              _sectionTitle('PERSONAL DETAILS'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.badge_outlined, 'Full Name', 'Paysaral User', isLocked: isB2B),
                      _divider(),
                      _buildInfoRow(Icons.phone_android_rounded, 'Mobile Number', '+91 9876543210', isLocked: true),
                      _divider(),
                      _buildInfoRow(Icons.email_outlined, 'Email Address', 'user@paysaral.com'),
                      _divider(),
                      _buildInfoRow(Icons.calendar_today_rounded, 'Date of Birth', '15 Aug 1995', isLocked: isB2B),
                      _divider(),
                      _buildInfoRow(Icons.male_rounded, 'Gender', 'Male', isLocked: isB2B),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ✅ ONLY B2B (Retailers) will see KYC Documents & Nominee Details
              if (isB2B) ...[
                // ── KYC & Documents Card ──
                _sectionTitle('KYC & DOCUMENTS'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.credit_card_rounded, 'PAN Number', 'ABC****34F', isLocked: true),
                        _divider(),
                        _buildInfoRow(Icons.fingerprint_rounded, 'Aadhaar Number', '********1234', isLocked: true),
                        _divider(),
                        // Tick mark added to "Verified" text
                        _buildInfoRow(
                            Icons.account_balance_rounded,
                            'KYC Status',
                            'Verified',
                            valueColor: Colors.green,
                            valueIcon: Icons.verified_rounded
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Nominee Details ──
                _sectionTitle('NOMINEE DETAILS'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.person_add_alt_1_outlined, 'Nominee Name', 'Rahul Kumar'),
                        _divider(),
                        _buildInfoRow(Icons.family_restroom_rounded, 'Relation', 'Brother'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],

              // ── Address Card ──
              _sectionTitle('ADDRESS DETAILS'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.location_on_outlined, 'Current Address', 'Sector 4, Bokaro Steel City\nJharkhand - 827004', isMultiline: true),

                      // Agar B2C hai, toh yahan dikhayenge ki KYC Pending hai
                      if (!isB2B) ...[
                        _divider(),
                        _buildInfoRow(Icons.account_balance_rounded, 'KYC Status', 'Min-KYC (Upgrade to Retailer)', valueColor: Colors.orange.shade700),
                      ]
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // ── ACCOUNT ACTIONS (ONLY DELETE) ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                  onPressed: () => _showDeleteConfirmation(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Delete Account permanently', style: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500)),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 36, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 1.2),
        ),
      ),
    );
  }

  // supports valueIcon for Tick marks
  Widget _buildInfoRow(IconData icon, String label, String value, {bool isMultiline = false, Color? valueColor, bool isLocked = false, IconData? valueIcon}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w400)),
                    if (isLocked) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.lock_rounded, size: 11, color: Colors.grey.shade400),
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: valueColor ?? Colors.black87,
                        height: isMultiline ? 1.4 : 1.0,
                      ),
                    ),
                    if (valueIcon != null) ...[
                      const SizedBox(width: 4),
                      Icon(valueIcon, size: 16, color: valueColor ?? Colors.black87),
                    ]
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey.shade100, indent: 56, endIndent: 20);
  }
}