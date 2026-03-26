import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  final bool isB2B;
  const EditProfileScreen({super.key, required this.isB2B});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isSaving = false;

  // Controllers with pre-filled dummy data
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Paysaral User');
    _mobileController = TextEditingController(text: '+91 9876543210');
    _emailController = TextEditingController(text: 'user@paysaral.com');
    _dobController = TextEditingController(text: '15 Aug 1995');
    _addressController = TextEditingController(
        text: 'Sector 4, Bokaro Steel City\nJharkhand - 827004');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // ✅ JADOO: Save Profile Logic
  Future<void> _saveProfile() async {
    FocusScope.of(context).unfocus(); // Keyboard band karo
    setState(() => _isSaving = true);

    // API Call Simulate kar rahe hain (1.5 seconds)
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() => _isSaving = false);

    // Success Message & Pop
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text('Profile updated successfully!', style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.pop(context); // Go back to My Profile
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Tap outside to dismiss keyboard
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            title: const Text('Edit Profile',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      // ── Header Background with Avatar ──
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            height: 80,
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
                                    border: Border.all(color: widget.isB2B ? AppColors.accentColor : Colors.blueAccent, width: 2),
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
                                child: GestureDetector(
                                  onTap: () {
                                    // Image Picker Logic
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.accentColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                      boxShadow: [
                                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3)),
                                      ],
                                    ),
                                    child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      const Text(
                        'Update Your Details',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      Text(
                        'Keep your profile information up to date',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 24),

                      // ── Form Fields Card ──
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // ✅ NAME (Locked for B2B)
                              _buildTextField(
                                label: 'Full Name',
                                controller: _nameController,
                                icon: Icons.badge_outlined,
                                isReadOnly: widget.isB2B, // Locked for KYC Retailers
                                readOnlyMessage: 'Name cannot be changed after KYC',
                              ),
                              const SizedBox(height: 20),

                              // ✅ MOBILE (Always Locked)
                              _buildTextField(
                                label: 'Mobile Number',
                                controller: _mobileController,
                                icon: Icons.phone_android_rounded,
                                isReadOnly: true, // ID cannot be changed
                                readOnlyMessage: 'Registered mobile number cannot be changed',
                              ),
                              const SizedBox(height: 20),

                              // ✅ EMAIL (Editable)
                              _buildTextField(
                                label: 'Email Address',
                                controller: _emailController,
                                icon: Icons.email_outlined,
                                isReadOnly: false,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 20),

                              // ✅ DOB (Locked for B2B)
                              _buildTextField(
                                label: 'Date of Birth',
                                controller: _dobController,
                                icon: Icons.calendar_today_rounded,
                                isReadOnly: widget.isB2B,
                                readOnlyMessage: 'DOB cannot be changed after KYC',
                              ),
                              const SizedBox(height: 20),

                              // ✅ ADDRESS (Editable, Multiline)
                              _buildTextField(
                                label: 'Current Address',
                                controller: _addressController,
                                icon: Icons.location_on_outlined,
                                isReadOnly: false,
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // ── BOTTOM SAVE BUTTON ──
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, -5)),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      disabledBackgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isSaving
                              ? [Colors.grey.shade400, Colors.grey.shade500]
                              : [const Color(0xFF00695C), const Color(0xFF009688)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: _isSaving
                            ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                            : const Text(
                          'Save Changes',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ JADOO: Sleek and Smart Text Field Generator
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isReadOnly,
    String? readOnlyMessage,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isReadOnly ? Colors.grey.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isReadOnly ? Colors.grey.shade200 : Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            readOnly: isReadOnly,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isReadOnly ? Colors.grey.shade600 : Colors.black87,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20, color: isReadOnly ? Colors.grey.shade400 : AppColors.primaryColor),
              suffixIcon: isReadOnly
                  ? Tooltip(
                message: readOnlyMessage ?? 'This field cannot be edited',
                triggerMode: TooltipTriggerMode.tap,
                child: Icon(Icons.lock_rounded, size: 16, color: Colors.grey.shade400),
              )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: maxLines > 1 ? 12 : 16),
            ),
          ),
        ),
      ],
    );
  }
}