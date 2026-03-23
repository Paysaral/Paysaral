import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/validators.dart';
import '../utils/formatters.dart';
import 'app_colors.dart';
import 'dashboard_screen.dart';

// ==================== UPGRADE STEP 1 — Business Info ====================
class UpgradeRetailerStep1 extends StatefulWidget {
  const UpgradeRetailerStep1({super.key});
  @override
  State<UpgradeRetailerStep1> createState() => _UpgradeRetailerStep1State();
}

class _UpgradeRetailerStep1State extends State<UpgradeRetailerStep1> {
  final _formKey = GlobalKey<FormState>();
  final _shopName = TextEditingController();
  String? _selectedCategory;
  bool _categoryError = false;
  final List<String> _categories = [
    'Grocery Store', 'Medical Store', 'Electronics Shop',
    'Mobile Recharge Shop', 'Kirana Store', 'Stationery Shop',
    'Clothing Store', 'Hardware Store', 'Travel Agency', 'Other'
  ];

  @override
  void dispose() {
    _shopName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: _buildAppBar('Upgrade to Retailer'),
      body: Column(
          children: [
            const _UpgradeStepHeader(currentStep: 1),
            Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                        key: _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoCard('Enter your business details to start earning commissions.'),
                              const SizedBox(height: 20),
                              _buildCard(
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const _KycLabel('Business / Shop Name', isRequired: true),
                                        TextFormField(
                                            controller: _shopName,
                                            textInputAction: TextInputAction.done,
                                            textCapitalization: TextCapitalization.words,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                                            decoration: _kycInputDecoration('Enter Shop Name', Icons.store_outlined)
                                        ),
                                        const _HelperText('As registered on GST / Trade License (If any)'),
                                        const SizedBox(height: 16),
                                        const _KycLabel('Shop Category', isRequired: true),
                                        Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: _categoryError ? Colors.red : const Color(0xFFDDDDDD), width: 1.2),
                                                color: Colors.white
                                            ),
                                            child: DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                    value: _selectedCategory,
                                                    hint: const Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                                        child: Text('Select Category', style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 13))
                                                    ),
                                                    isExpanded: true,
                                                    icon: const Padding(
                                                        padding: EdgeInsets.only(right: 12),
                                                        child: Icon(Icons.keyboard_arrow_down, color: Colors.grey)
                                                    ),
                                                    items: _categories.map((cat) => DropdownMenuItem(
                                                        value: cat,
                                                        child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                                            child: Text(cat, style: const TextStyle(fontSize: 14))
                                                        )
                                                    )).toList(),
                                                    onChanged: (val) => setState(() { _selectedCategory = val; _categoryError = false; })
                                                )
                                            )
                                        ),
                                        if (_categoryError)
                                          const Padding(
                                              padding: EdgeInsets.only(top: 6, left: 4),
                                              child: Text('Please select shop category', style: TextStyle(color: Colors.red, fontSize: 12))
                                          ),
                                      ]
                                  )
                              ),
                              const SizedBox(height: 20),
                              _sslBadge(),
                              const SizedBox(height: 20),
                              _NextButton(
                                  label: 'Continue to KYC',
                                  onTap: () {
                                    if (_selectedCategory == null) setState(() => _categoryError = true);
                                    if (_formKey.currentState!.validate() && _selectedCategory != null) {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => const UpgradeRetailerStep2()));
                                    }
                                  }
                              ),
                            ]
                        )
                    )
                )
            ),
          ]
      ),
    );
  }
}

// ==================== UPGRADE STEP 2 — KYC Documents ====================
class UpgradeRetailerStep2 extends StatefulWidget {
  const UpgradeRetailerStep2({super.key});
  @override
  State<UpgradeRetailerStep2> createState() => _UpgradeRetailerStep2State();
}

class _UpgradeRetailerStep2State extends State<UpgradeRetailerStep2> {
  final _formKey = GlobalKey<FormState>();
  final _pan = TextEditingController();
  final _aadhar = TextEditingController();
  File? _panImage;
  File? _aadharFront;
  File? _aadharBack;
  bool _panError = false;
  bool _aadharFrontError = false;
  bool _aadharBackError = false;
  final _picker = ImagePicker();

  Future<void> _pickImage(String type) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        if (type == 'pan') { _panImage = File(picked.path); _panError = false; }
        if (type == 'aadhar_front') { _aadharFront = File(picked.path); _aadharFrontError = false; }
        if (type == 'aadhar_back') { _aadharBack = File(picked.path); _aadharBackError = false; }
      });
    }
  }

  @override
  void dispose() {
    _pan.dispose();
    _aadhar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: _buildAppBar('KYC Details'),
      body: Column(
          children: [
            const _UpgradeStepHeader(currentStep: 2),
            Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                        key: _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoCard('Upload clear photos. File size max 2MB.'),
                              const SizedBox(height: 20),
                              _buildCard(
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _docSectionTitle(Icons.credit_card, 'PAN Card Details'),
                                        const SizedBox(height: 16),
                                        const _KycLabel('PAN Number', isRequired: true),
                                        TextFormField(
                                            controller: _pan,
                                            maxLength: 10,
                                            textCapitalization: TextCapitalization.characters,
                                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')), UpperCaseTextFormatter()],
                                            validator: Validators.validatePAN,
                                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                                            decoration: _kycInputDecoration('eg. ABCDE1234F', Icons.credit_card)
                                        ),
                                        const SizedBox(height: 16),
                                        const _KycLabel('Upload PAN Card', isRequired: true),
                                        _UploadBox(
                                            image: _panImage,
                                            label: 'Tap to upload PAN Card',
                                            hasError: _panError,
                                            onTap: () => _pickImage('pan')
                                        ),
                                        if (_panError) const _ErrorText('Please upload PAN image'),
                                      ]
                                  )
                              ),
                              const SizedBox(height: 16),
                              _buildCard(
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _docSectionTitle(Icons.badge_outlined, 'Aadhaar Card Details'),
                                        const SizedBox(height: 16),
                                        const _KycLabel('Aadhaar Number', isRequired: true),
                                        TextFormField(
                                            controller: _aadhar,
                                            keyboardType: TextInputType.number,
                                            maxLength: 14,
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, AadhaarInputFormatter()],
                                            validator: Validators.validateAadhaar,
                                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                                            decoration: _kycInputDecoration('XXXX-XXXX-XXXX', Icons.numbers)
                                        ),
                                        const SizedBox(height: 16),
                                        const _KycLabel('Aadhaar Front', isRequired: true),
                                        _UploadBox(
                                            image: _aadharFront,
                                            label: 'Tap to upload Front Side',
                                            hasError: _aadharFrontError,
                                            onTap: () => _pickImage('aadhar_front')
                                        ),
                                        if (_aadharFrontError) const _ErrorText('Please upload Aadhaar Front'),
                                        const SizedBox(height: 12),
                                        const _KycLabel('Aadhaar Back', isRequired: true),
                                        _UploadBox(
                                            image: _aadharBack,
                                            label: 'Tap to upload Back Side',
                                            hasError: _aadharBackError,
                                            onTap: () => _pickImage('aadhar_back')
                                        ),
                                        if (_aadharBackError) const _ErrorText('Please upload Aadhaar Back'),
                                      ]
                                  )
                              ),
                              const SizedBox(height: 20),
                              _sslBadge(),
                              const SizedBox(height: 20),
                              _NextButton(
                                  label: 'Continue to Photo',
                                  onTap: () {
                                    setState(() {
                                      _panError = _panImage == null;
                                      _aadharFrontError = _aadharFront == null;
                                      _aadharBackError = _aadharBack == null;
                                    });
                                    if (_formKey.currentState!.validate() && !_panError && !_aadharFrontError && !_aadharBackError) {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => const UpgradeRetailerStep3()));
                                    }
                                  }
                              ),
                            ]
                        )
                    )
                )
            ),
          ]
      ),
    );
  }
}

// ==================== UPGRADE STEP 3 — Live Verification ====================
class UpgradeRetailerStep3 extends StatefulWidget {
  const UpgradeRetailerStep3({super.key});
  @override
  State<UpgradeRetailerStep3> createState() => _UpgradeRetailerStep3State();
}

class _UpgradeRetailerStep3State extends State<UpgradeRetailerStep3> {
  File? _ownerSelfie;
  File? _shopPhoto;
  bool _selfieError = false;
  bool _shopError = false;
  final _picker = ImagePicker();

  Future<void> _pickImage(String type) async {
    final picked = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (picked != null) {
      setState(() {
        if (type == 'selfie') { _ownerSelfie = File(picked.path); _selfieError = false; }
        if (type == 'shop') { _shopPhoto = File(picked.path); _shopError = false; }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: _buildAppBar('Live Verification'),
      body: Column(
          children: [
            const _UpgradeStepHeader(currentStep: 3),
            Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoCard('Please take a clear live photo of yourself and your shop.'),
                          const SizedBox(height: 20),
                          _buildCard(
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _docSectionTitle(Icons.face_retouching_natural, 'Owner Selfie'),
                                    const SizedBox(height: 16),
                                    const _KycLabel('Live Selfie', isRequired: true),
                                    _UploadBox(
                                        image: _ownerSelfie,
                                        label: 'Tap to open Camera',
                                        onTap: () => _pickImage('selfie'),
                                        hasError: _selfieError
                                    ),
                                    if (_selfieError) const _ErrorText('Please take a clear selfie'),
                                    const SizedBox(height: 24),
                                    _docSectionTitle(Icons.storefront_outlined, 'Shop / Office Photo'),
                                    const SizedBox(height: 16),
                                    const _KycLabel('Live Shop Photo', isRequired: true),
                                    _UploadBox(
                                        image: _shopPhoto,
                                        label: 'Tap to open Camera',
                                        onTap: () => _pickImage('shop'),
                                        hasError: _shopError
                                    ),
                                    if (_shopError) const _ErrorText('Please take a shop photo'),
                                  ]
                              )
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity, height: 52,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_ownerSelfie == null) setState(() => _selfieError = true);
                                if (_shopPhoto == null) setState(() => _shopError = true);

                                if (_ownerSelfie != null && _shopPhoto != null) {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();

                                  // ✅ JADOO YAHAN HAI: Login check logic
                                  String? currentUser = prefs.getString('currentUser');
                                  if (currentUser != null) {
                                    await prefs.setBool('role_$currentUser', true);
                                  }
                                  await prefs.setBool('isB2B', true);

                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('KYC Submitted! Welcome to Retailer Club 🎉'), backgroundColor: Colors.green)
                                  );
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const DashboardScreen()), (route) => false);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accentColor,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                              ),
                              child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Submit KYC Request', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                                    SizedBox(width: 8),
                                    Icon(Icons.check_circle, color: Colors.white, size: 20)
                                  ]
                              ),
                            ),
                          ),
                        ]
                    )
                )
            ),
          ]
      ),
    );
  }
}

// ==================== COMMON UI WIDGETS ====================
AppBar _buildAppBar(String title) => AppBar(
    backgroundColor: AppColors.primaryColor,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.white),
    title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
    centerTitle: true
);

class _UpgradeStepHeader extends StatelessWidget {
  final int currentStep;
  const _UpgradeStepHeader({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['Business', 'KYC Docs', 'Verification'];
    return Container(
        color: AppColors.primaryColor,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
            children: [
              Row(
                  children: List.generate(3, (i) => Expanded(
                      child: Row(
                          children: [
                            Expanded(
                                child: Container(
                                    height: 4,
                                    decoration: BoxDecoration(color: i < currentStep ? Colors.white : Colors.white30, borderRadius: BorderRadius.circular(2))
                                )
                            ),
                            if (i < 2) const SizedBox(width: 5)
                          ]
                      )
                  ))
              ),
              const SizedBox(height: 14),
              FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (i) {
                        final isActive = i + 1 == currentStep;
                        final isDone = i + 1 < currentStep;
                        return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  width: 26, height: 26,
                                  decoration: BoxDecoration(color: isDone || isActive ? Colors.white : Colors.white30, shape: BoxShape.circle),
                                  child: Center(
                                      child: isDone
                                          ? const Icon(Icons.check, color: AppColors.primaryColor, size: 15)
                                          : Text('${i + 1}', style: TextStyle(color: isActive ? AppColors.primaryColor : Colors.white70, fontWeight: FontWeight.bold, fontSize: 12))
                                  )
                              ),
                              const SizedBox(width: 5),
                              Text(
                                  steps[i],
                                  style: TextStyle(color: isActive ? Colors.white : Colors.white60, fontSize: 11, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal)
                              ),
                              if (i < 2) const SizedBox(width: 14)
                            ]
                        );
                      })
                  )
              )
            ]
        )
    );
  }
}

Widget _buildCard(Widget child) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5))
        ]
    ),
    child: child
);

Widget _docSectionTitle(IconData icon, String title) => Row(
    children: [
      Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppColors.primaryColor, size: 20)
      ),
      const SizedBox(width: 10),
      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87))
    ]
);

InputDecoration _kycInputDecoration(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
    prefixIcon: Icon(icon, color: Colors.grey, size: 20),
    counterText: '',
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 1.2)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 1.2)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.8)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 1.2)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 1.8)),
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12)
);

Widget _infoCard(String msg) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.accentColor, width: 1)
    ),
    child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primaryColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
              child: Text(msg, style: const TextStyle(color: AppColors.primaryColor, fontSize: 12.5, fontWeight: FontWeight.w500))
          )
        ]
    )
);

class _UploadBox extends StatelessWidget {
  final File? image;
  final String label;
  final VoidCallback onTap;
  final bool hasError;
  const _UploadBox({required this.image, required this.label, required this.onTap, this.hasError = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: hasError ? Colors.red : AppColors.primaryColor, width: 1.5),
                color: hasError ? const Color(0xFFFFF0F0) : AppColors.primaryColor.withOpacity(0.05)
            ),
            child: image != null
                ? ClipRRect(borderRadius: BorderRadius.circular(9), child: Image.file(image!, fit: BoxFit.cover))
                : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined, color: hasError ? Colors.red : AppColors.primaryColor, size: 36),
                  const SizedBox(height: 8),
                  Text(label, style: TextStyle(color: hasError ? Colors.red : AppColors.primaryColor, fontSize: 13, fontWeight: FontWeight.w500))
                ]
            )
        )
    );
  }
}

class _KycLabel extends StatelessWidget {
  final String text;
  final bool isRequired;
  const _KycLabel(this.text, {required this.isRequired});

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Row(
          children: [
            Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            if (isRequired) const Text(' *', style: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold))
          ]
      )
  );
}

class _HelperText extends StatelessWidget {
  final String text;
  const _HelperText(this.text);

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 4, left: 4),
      child: Text(text, style: const TextStyle(color: Colors.grey, fontSize: 11))
  );
}

class _ErrorText extends StatelessWidget {
  final String text;
  const _ErrorText(this.text);

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(text, style: const TextStyle(color: Colors.red, fontSize: 12))
  );
}

class _NextButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _NextButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
      width: double.infinity, height: 52,
      child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: Colors.white, size: 20)
              ]
          )
      )
  );
}

Widget _sslBadge() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(Icons.security, color: Colors.teal, size: 15),
      const SizedBox(width: 5),
      Text('256-bit SSL Secured | Your data is safe', style: TextStyle(color: Colors.grey.shade600, fontSize: 11.5, fontWeight: FontWeight.w500))
    ]
);