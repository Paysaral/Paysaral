import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'utils/validators.dart';
import 'utils/formatters.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

// ==================== SPLASH ====================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late final AnimationController _logoCtrl;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;

  late final AnimationController _textCtrl;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  late final AnimationController _bottomCtrl;
  late final Animation<double> _bottomFade;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _logoFade = CurvedAnimation(parent: _logoCtrl, curve: Curves.easeIn);
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));

    _textCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _textFade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn);
    _textSlide = Tween<Offset>(
        begin: const Offset(0, 0.5), end: Offset.zero).animate(
        CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));

    _bottomCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _bottomFade = CurvedAnimation(parent: _bottomCtrl, curve: Curves.easeIn);

    _logoCtrl.forward();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _textCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) _bottomCtrl.forward();
    });

    Timer(const Duration(milliseconds: 3500), () {
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _bottomCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF004D40),
              Color(0xFF009688),
              Color(0xFF26A69A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              const Spacer(flex: 2),

              // ✅ Logo
              FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Image.asset(
                    'assets/images/welcome-logo.png',
                    width: 260,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Tagline
              FadeTransition(
                opacity: _textFade,
                child: SlideTransition(
                  position: _textSlide,
                  child: const Text(
                    "🇮🇳  India's No.1 Fintech Company",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // ✅ Safe & Secure — ekdum neeche
              FadeTransition(
                opacity: _bottomFade,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.shield_rounded,
                            color: Color(0xFF67C949),
                            size: 30,
                          ),
                          Icon(
                            Icons.shield,
                            color: Colors.white.withValues(alpha: 0.3),
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Safe & Secure',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

// ==================== LOGIN ====================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobile  = TextEditingController();
  final _pass    = TextEditingController();
  bool _remember = false;
  bool _hidePass = true;

  @override
  void dispose() { _mobile.dispose(); _pass.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset('assets/images/login-bg.png', fit: BoxFit.fill),
        ),
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(children: [
                const SizedBox(height: 40),
                const Text('Hi! WELCOME BACK',
                    style: TextStyle(color: Colors.white, fontSize: 24,
                        fontWeight: FontWeight.w600, letterSpacing: 1)),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 25, offset: const Offset(0, 12))],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      Image.asset('assets/images/paysaral-logo.png', height: 46),
                      const SizedBox(height: 22),

                      // ✅ Mobile / Email Smart Field — Auto Detect
                      TextFormField(
                        controller: _mobile,
                        keyboardType: TextInputType.emailAddress,
                        maxLength: null,
                        inputFormatters: [],
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Mobile number or Email is required';
                          }
                          // Agar sirf numbers hain → Mobile validate
                          if (RegExp(r'^\d+$').hasMatch(value.trim())) {
                            return value.trim().length == 10
                                ? null
                                : 'Mobile number must be 10 digits';
                          }
                          // Warna Email validate
                          return RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(value.trim())
                              ? null
                              : 'Enter a Valid mobile number "or" email address';
                        },
                        style: const TextStyle(fontSize: 14),
                        decoration: _loginInputDecoration(
                          'M.No/Email ID',
                          Icons.person_outline,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ✅ Password Field
                      TextFormField(
                        controller: _pass,
                        obscureText: _hidePass,
                        textInputAction: TextInputAction.done,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        style: const TextStyle(fontSize: 14),
                        decoration: _loginInputDecoration(
                            'Password', Icons.lock_outline).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _hidePass ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey, size: 22,
                            ),
                            onPressed: () =>
                                setState(() => _hidePass = !_hidePass),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              SizedBox(width: 20, height: 20,
                                child: Checkbox(
                                  value: _remember,
                                  onChanged: (v) =>
                                      setState(() => _remember = v ?? false),
                                  activeColor: const Color(0xFF009688),
                                  side: const BorderSide(
                                      color: Color(0xFF009688), width: 1.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('Remember me',
                                  style: TextStyle(color: Color(0xFF009688),
                                      fontSize: 13, fontWeight: FontWeight.w500)),
                            ]),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              child: const Text('Forgot Password?',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 13)),
                            ),
                          ]),
                      const SizedBox(height: 18),

                      // ✅ Login Button
                      SizedBox(width: double.infinity, height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Logging in...'),
                                  backgroundColor: Color(0xFF009688),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF67C949),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Login',
                              style: TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      RichText(textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(color: Colors.black87, fontSize: 12.5),
                          children: [
                            TextSpan(text: 'By Login in, you agree to our! '),
                            TextSpan(text: 'Privacy policy',
                                style: TextStyle(color: Color(0xFF009688),
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have a Account? ",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 13)),
                            GestureDetector(
                              onTap: () => Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (_) => const RegisterStep1())),
                              child: const Text('Register',
                                  style: TextStyle(color: Color(0xFF009688),
                                      fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ]),
                      const SizedBox(height: 16),
                      const _Footer(),
                    ]),
                  ),
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

// ==================== REGISTER STEP 1 — Personal Info ====================
class RegisterStep1 extends StatefulWidget {
  const RegisterStep1({super.key});
  @override
  State<RegisterStep1> createState() => _RegisterStep1State();
}

class _RegisterStep1State extends State<RegisterStep1> {
  final _formKey = GlobalKey<FormState>();
  final _name    = TextEditingController();
  final _mobile  = TextEditingController();
  final _email   = TextEditingController();

  @override
  void dispose() {
    _name.dispose(); _mobile.dispose(); _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: Column(children: [
        _StepHeader(currentStep: 1),
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoCard('Please enter details as per your Aadhaar/PAN card.'),
                  const SizedBox(height: 20),
                  _buildCard(Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ✅ Name Field
                      const _KycLabel('Full Name', isRequired: true),
                      TextFormField(
                        controller: _name,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: Validators.validateName,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        decoration: _kycInputDecoration(
                            'Enter Your Name', Icons.person_outline),
                      ),
                      const SizedBox(height: 16),

                      // ✅ Mobile Field — Sirf Number, Max 10
                      const _KycLabel('Mobile Number', isRequired: true),
                      TextFormField(
                        controller: _mobile,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: Validators.validateMobile,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        decoration: _kycInputDecoration(
                            'Enter 10 Digit Number', Icons.phone_android),
                      ),
                      const SizedBox(height: 16),

                      // ✅ Email Field
                      const _KycLabel('Your ID (Email)', isRequired: true),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: Validators.validateEmail,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        decoration: _kycInputDecoration(
                            'Enter Your Email', Icons.alternate_email),
                      ),
                      const _HelperText('Used for login & notifications'),
                    ],
                  )),
                  const SizedBox(height: 20),
                  _sslBadge(),
                  const SizedBox(height: 20),
                  _NextButton(
                    label: 'Continue',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_) => RegisterStep2(
                              name: _name.text,
                              mobile: _mobile.text,
                              email: _email.text,
                            )));
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _signInRow(context),
                  const SizedBox(height: 24),
                  const _Footer(),
                ]),
          ),
        )),
      ]),
    );
  }
}

// ==================== REGISTER STEP 2 — Business Info ====================
class RegisterStep2 extends StatefulWidget {
  final String name, mobile, email;
  const RegisterStep2({super.key,
    required this.name, required this.mobile, required this.email});
  @override
  State<RegisterStep2> createState() => _RegisterStep2State();
}

class _RegisterStep2State extends State<RegisterStep2> {
  final _formKey       = GlobalKey<FormState>();
  final _shopName      = TextEditingController();
  String? _selectedCategory;
  bool _categoryError  = false;

  final List<String> _categories = [
    'Grocery Store', 'Medical Store', 'Electronics Shop',
    'Mobile Recharge Shop', 'Kirana Store', 'Stationery Shop',
    'Clothing Store', 'Hardware Store', 'Travel Agency', 'Other',
  ];

  @override
  void dispose() { _shopName.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: Column(children: [
        _StepHeader(currentStep: 2),
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _summaryCard(widget.name, widget.mobile),
                  const SizedBox(height: 20),
                  _buildCard(Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ✅ Shop Name
                      const _KycLabel('Business / Shop Name', isRequired: true),
                      TextFormField(
                        controller: _shopName,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.words,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (v) => Validators.validateRequired(v, 'Shop Name'),
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        decoration: _kycInputDecoration(
                            'Enter Shop Name', Icons.store_outlined),
                      ),
                      const _HelperText('As registered on GST / Trade License'),
                      const SizedBox(height: 16),

                      // ✅ Category Dropdown
                      const _KycLabel('Shop Category', isRequired: true),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _categoryError
                                ? Colors.red : const Color(0xFFDDDDDD),
                            width: 1.2,
                          ),
                          color: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCategory,
                            hint: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Select Category',
                                  style: TextStyle(
                                      color: Color(0xFFBBBBBB), fontSize: 13)),
                            ),
                            isExpanded: true,
                            icon: const Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(Icons.keyboard_arrow_down,
                                  color: Colors.grey),
                            ),
                            borderRadius: BorderRadius.circular(12),
                            items: _categories.map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(cat, style: const TextStyle(
                                    fontSize: 14, color: Colors.black87)),
                              ),
                            )).toList(),
                            onChanged: (val) => setState(() {
                              _selectedCategory = val;
                              _categoryError = false;
                            }),
                          ),
                        ),
                      ),
                      if (_categoryError)
                        const Padding(
                          padding: EdgeInsets.only(top: 6, left: 4),
                          child: Text('Please select shop category',
                              style: TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                    ],
                  )),
                  const SizedBox(height: 20),
                  _sslBadge(),
                  const SizedBox(height: 20),
                  _NextButton(
                    label: 'Continue',
                    onTap: () {
                      if (_selectedCategory == null) {
                        setState(() => _categoryError = true);
                      }
                      if (_formKey.currentState!.validate() &&
                          _selectedCategory != null) {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_) => RegisterStep3(
                              name: widget.name, mobile: widget.mobile,
                              email: widget.email, shopName: _shopName.text,
                              category: _selectedCategory ?? '',
                            )));
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _signInRow(context),
                  const SizedBox(height: 24),
                  const _Footer(),
                ]),
          ),
        )),
      ]),
    );
  }
}

// ==================== REGISTER STEP 3 — KYC Documents ====================
class RegisterStep3 extends StatefulWidget {
  final String name, mobile, email, shopName, category;
  const RegisterStep3({super.key,
    required this.name, required this.mobile, required this.email,
    required this.shopName, required this.category});
  @override
  State<RegisterStep3> createState() => _RegisterStep3State();
}

class _RegisterStep3State extends State<RegisterStep3> {
  final _formKey       = GlobalKey<FormState>();
  final _pan           = TextEditingController();
  final _aadhar        = TextEditingController();
  File? _panImage;
  File? _aadharFront;
  File? _aadharBack;
  bool _panImageError    = false;
  bool _aadharFrontError = false;
  bool _aadharBackError  = false;
  final _picker = ImagePicker();

  Future<void> _pickImage(String type) async {
    final picked = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        if (type == 'pan') {
          _panImage = File(picked.path);
          _panImageError = false;
        }
        if (type == 'aadhar_front') {
          _aadharFront = File(picked.path);
          _aadharFrontError = false;
        }
        if (type == 'aadhar_back') {
          _aadharBack = File(picked.path);
          _aadharBackError = false;
        }
      });
    }
  }

  bool _validateImages() {
    setState(() {
      _panImageError    = _panImage == null;
      _aadharFrontError = _aadharFront == null;
      _aadharBackError  = _aadharBack == null;
    });
    return _panImage != null && _aadharFront != null && _aadharBack != null;
  }

  @override
  void dispose() { _pan.dispose(); _aadhar.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: Column(children: [
        _StepHeader(currentStep: 3),
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoCard('Upload clear photos. File size max 2MB.'),
                  const SizedBox(height: 20),

                  // PAN Card Section
                  _buildCard(Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _docSectionTitle(Icons.credit_card, 'PAN Card Details'),
                        const SizedBox(height: 16),

                        // ✅ PAN Number
                        const _KycLabel('PAN Number', isRequired: true),
                        TextFormField(
                          controller: _pan,
                          keyboardType: TextInputType.text,
                          maxLength: 10,
                          textCapitalization: TextCapitalization.characters,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                            UpperCaseTextFormatter(), // ✅ Auto uppercase
                          ],
                          textInputAction: TextInputAction.done,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: Validators.validatePAN,
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                          decoration: _kycInputDecoration('eg. ABCDE1234F', Icons.credit_card),
                        ),
                        const SizedBox(height: 16),

                        const _KycLabel('Upload PAN Card', isRequired: true),
                        _UploadBox(
                          image: _panImage,
                          label: 'Tap to upload PAN Card',
                          hasError: _panImageError,
                          onTap: () => _pickImage('pan'),
                        ),
                        if (_panImageError)
                          const _ErrorText('Please upload PAN card image'),
                      ])),
                  const SizedBox(height: 16),

                  // Aadhaar Card Section
                  _buildCard(Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _docSectionTitle(Icons.badge_outlined, 'Aadhaar Card Details'),
                        const SizedBox(height: 16),

                        // ✅ Aadhaar
                        const _KycLabel('Aadhaar Number', isRequired: true),
                        TextFormField(
                          controller: _aadhar,
                          keyboardType: TextInputType.number,
                          maxLength: 14, // 12 digits + 2 dashes
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            AadhaarInputFormatter(), // ✅ XXXX-XXXX-XXXX
                          ],
                          textInputAction: TextInputAction.done,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: Validators.validateAadhaar,
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                          decoration: _kycInputDecoration('XXXX-XXXX-XXXX', Icons.numbers),
                        ),
                        const SizedBox(height: 16),

                        const _KycLabel('Aadhaar Front', isRequired: true),
                        _UploadBox(
                          image: _aadharFront,
                          label: 'Tap to upload Front Side',
                          hasError: _aadharFrontError,
                          onTap: () => _pickImage('aadhar_front'),
                        ),
                        if (_aadharFrontError)
                          const _ErrorText('Please upload Aadhaar front image'),
                        const SizedBox(height: 12),

                        const _KycLabel('Aadhaar Back', isRequired: true),
                        _UploadBox(
                          image: _aadharBack,
                          label: 'Tap to upload Back Side',
                          hasError: _aadharBackError,
                          onTap: () => _pickImage('aadhar_back'),
                        ),
                        if (_aadharBackError)
                          const _ErrorText('Please upload Aadhaar back image'),
                      ])),
                  const SizedBox(height: 20),
                  _sslBadge(),
                  const SizedBox(height: 20),
                  _NextButton(
                    label: 'Continue',
                    onTap: () {
                      final imagesValid = _validateImages();
                      if (_formKey.currentState!.validate() && imagesValid) {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_) => RegisterStepPhoto( // ✅ अब ये Photo स्टेप पर जाएगा
                              name: widget.name, mobile: widget.mobile,
                              email: widget.email,
                            )));
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _signInRow(context),
                  const SizedBox(height: 24),
                  const _Footer(),
                ]),
          ),
        )),
      ]),
    );
  }
}

// ==================== REGISTER STEP 4 — Live Verification ====================
class RegisterStepPhoto extends StatefulWidget {
  final String name, mobile, email;
  const RegisterStepPhoto({super.key, required this.name, required this.mobile, required this.email});

  @override
  State<RegisterStepPhoto> createState() => _RegisterStepPhotoState();
}

class _RegisterStepPhotoState extends State<RegisterStepPhoto> {
  File? _ownerSelfie;
  File? _shopPhoto;
  bool _selfieError = false;
  bool _shopError = false;
  final _picker = ImagePicker();

  Future<void> _pickImage(String type) async {
    // फिनटेक ऐप के लिए 'Camera' सोर्स बेहतर रहता है ताकि लाइव फोटो आए
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
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: Column(children: [
        _StepHeader(currentStep: 4), // ✅ अब यह 4th स्टेप है
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _infoCard('Please take a clear photo of yourself and your shop.'),
            const SizedBox(height: 20),

            _buildCard(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _docSectionTitle(Icons.face_retouching_natural, 'Owner Selfie'),
              const SizedBox(height: 16),
              const _KycLabel('Live Selfie', isRequired: true),
              _UploadBox(
                image: _ownerSelfie,
                label: 'Tap to open Camera',
                onTap: () => _pickImage('selfie'),
                hasError: _selfieError,
              ),
              if (_selfieError) const _ErrorText('Please take a clear selfie'),
              const _HelperText('Make sure your face is clearly visible'),

              const SizedBox(height: 24),

              _docSectionTitle(Icons.storefront_outlined, 'Shop / Office Photo'),
              const SizedBox(height: 16),
              const _KycLabel('Live Shop Photo', isRequired: true),
              _UploadBox(
                image: _shopPhoto,
                label: 'Tap to open Camera',
                onTap: () => _pickImage('shop'),
                hasError: _shopError,
              ),
              if (_shopError) const _ErrorText('Please take a shop photo'),
              const _HelperText('Photo should show the shop entrance/board'),
            ])),

            const SizedBox(height: 20),
            _sslBadge(),
            const SizedBox(height: 20),

            _NextButton(
              label: 'Continue',
              onTap: () {
                if (_ownerSelfie == null) setState(() => _selfieError = true);
                if (_shopPhoto == null) setState(() => _shopError = true);

                if (_ownerSelfie != null && _shopPhoto != null) {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (_) => RegisterStep4( // ✅ अब यह Security (Step 5) पर जाएगा
                        name: widget.name, mobile: widget.mobile, email: widget.email,
                      )));
                }
              },
            ),
            const SizedBox(height: 16),
            _signInRow(context),
            const SizedBox(height: 24),
            const _Footer(),
          ]),
        )),
      ]),
    );
  }
}

// ==================== REGISTER STEP 5 — Security ====================
class RegisterStep4 extends StatefulWidget {
  final String name, mobile, email;
  const RegisterStep4({super.key,
    required this.name, required this.mobile, required this.email});
  @override
  State<RegisterStep4> createState() => _RegisterStep4State();
}

class _RegisterStep4State extends State<RegisterStep4> {
  final _formKey   = GlobalKey<FormState>();
  final _pass      = TextEditingController();
  final _sponsor   = TextEditingController();
  bool _agree      = false;
  bool _agreeError = false;
  bool _hidePass   = true;

  @override
  void dispose() { _pass.dispose(); _sponsor.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: Column(children: [
        _StepHeader(currentStep: 5),
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _summaryCard(widget.name, widget.mobile),
                  const SizedBox(height: 20),
                  _buildCard(Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ✅ Password Field
                      const _KycLabel('Password', isRequired: true),
                      TextFormField(
                        controller: _pass,
                        obscureText: _hidePass,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: Validators.validatePassword,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        decoration: _kycInputDecoration(
                            'Create Password', Icons.lock_outline).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _hidePass
                                  ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey, size: 20,
                            ),
                            onPressed: () =>
                                setState(() => _hidePass = !_hidePass),
                          ),
                        ),
                      ),
                      const _HelperText('Min 8 chars with number & symbol'),
                      const SizedBox(height: 16),

                      // ✅ Sponsor ID (Optional)
                      const _KycLabel('Sponsor ID', isRequired: false),
                      TextFormField(
                        controller: _sponsor,
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        decoration: _kycInputDecoration(
                            'Enter Sponsor ID (Optional)', Icons.people_outline),
                      ),
                      const _HelperText('Leave blank if no sponsor'),
                    ],
                  )),
                  const SizedBox(height: 20),

                  // ✅ Terms & Conditions
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _agreeError ? Colors.red : Colors.transparent,
                        width: 1.2,
                      ),
                      boxShadow: [BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 15, offset: const Offset(0, 5))],
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            SizedBox(width: 20, height: 20,
                              child: Checkbox(
                                value: _agree,
                                onChanged: (v) => setState(() {
                                  _agree = v ?? false;
                                  _agreeError = false;
                                }),
                                activeColor: const Color(0xFF009688),
                                side: const BorderSide(
                                    color: Color(0xFF009688), width: 1.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            RichText(text: const TextSpan(
                              style: TextStyle(color: Colors.black87, fontSize: 13),
                              children: [
                                TextSpan(text: 'I agree to '),
                                TextSpan(text: 'Terms & Conditions',
                                    style: TextStyle(color: Color(0xFF009688),
                                        fontWeight: FontWeight.bold)),
                                TextSpan(text: ' & '),
                                TextSpan(text: 'Privacy Policy',
                                    style: TextStyle(color: Color(0xFF009688),
                                        fontWeight: FontWeight.bold)),
                              ],
                            )),
                          ]),
                          if (_agreeError)
                            const Padding(
                              padding: EdgeInsets.only(top: 6, left: 4),
                              child: Text(
                                  'Please agree to Terms & Conditions to continue',
                                  style: TextStyle(color: Colors.red, fontSize: 12)),
                            ),
                        ]),
                  ),
                  const SizedBox(height: 20),
                  _sslBadge(),
                  const SizedBox(height: 20),

                  // ✅ Create Account Button
                  SizedBox(width: double.infinity, height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_agree) setState(() => _agreeError = true);
                        if (_formKey.currentState!.validate() && _agree) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Account Created Successfully! 🎉'),
                              backgroundColor: Color(0xFF009688),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF67C949), elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Create Account', style: TextStyle(fontSize: 17,
                              fontWeight: FontWeight.bold, color: Colors.white)),
                          SizedBox(width: 8),
                          Icon(Icons.check_circle_outline,
                              color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _signInRow(context),
                  const SizedBox(height: 24),
                  const _Footer(),
                ]),
          ),
        )),
      ]),
    );
  }
}

// ==================== STEP HEADER ====================
class _StepHeader extends StatelessWidget {
  final int currentStep;
  const _StepHeader({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    // 5 स्टेप्स के नाम
    final steps = ['Personal', 'Business', 'KYC Docs', 'Verification', 'Security'];
    return Container(
      color: const Color(0xFF009688), // ✅ एकदम ओरिजिनल Teal कलर
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(children: [

        // ✅ ऊपर वाली 5 प्रोग्रेस लाइन्स
        Row(children: List.generate(5, (i) => Expanded(
          child: Row(children: [
            Expanded(child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: i < currentStep ? Colors.white : Colors.white30, // ✅ ओरिजिनल कलर
                borderRadius: BorderRadius.circular(2),
              ),
            )),
            if (i < 4) const SizedBox(width: 5),
          ]),
        ))),

        const SizedBox(height: 14),

        // ✅ नीचे वाले टेक्स्ट (FittedBox के साथ ताकि स्क्रीन से बाहर ना भागे)
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min, // जितना साइज़ चाहिए बस उतना ही लेगा
            children: List.generate(5, (i) {
              final isActive = i + 1 == currentStep;
              final isDone   = i + 1 < currentStep;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 26, height: 26, // ✅ ओरिजिनल गोल घेरा
                    decoration: BoxDecoration(
                      color: isDone || isActive ? Colors.white : Colors.white30,
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: isDone
                        ? const Icon(Icons.check,
                        color: Color(0xFF009688), size: 15) // ✅ ओरिजिनल हरा टिक
                        : Text('${i + 1}', style: TextStyle(
                        color: isActive
                            ? const Color(0xFF009688) : Colors.white70, // ✅ ओरिजिनल टेक्स्ट कलर
                        fontWeight: FontWeight.bold, fontSize: 12))),
                  ),
                  const SizedBox(width: 5), // घेरे और टेक्स्ट के बीच की दूरी
                  Text(steps[i], style: TextStyle(
                      color: isActive ? Colors.white : Colors.white60,
                      fontSize: 11, // ✅ ओरिजिनल फॉन्ट साइज़
                      fontWeight: isActive
                          ? FontWeight.w600 : FontWeight.normal)),

                  // 2 स्टेप्स के बीच की दूरी (आख़िरी वाले में नहीं आएगी)
                  if (i < 4) const SizedBox(width: 14),
                ],
              );
            }),
          ),
        ),

      ]),
    );
  }
}

// ==================== UPLOAD BOX ====================
class _UploadBox extends StatelessWidget {
  final File? image;
  final String label;
  final VoidCallback onTap;
  final bool hasError;
  const _UploadBox({required this.image, required this.label,
    required this.onTap, this.hasError = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasError ? Colors.red : const Color(0xFF009688),
            width: 1.5,
          ),
          color: hasError
              ? const Color(0xFFFFF0F0) : const Color(0xFFF0FAF9),
        ),
        child: image != null
            ? ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.file(image!, fit: BoxFit.cover))
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.cloud_upload_outlined,
              color: hasError ? Colors.red : const Color(0xFF009688),
              size: 36),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(
              color: hasError ? Colors.red : const Color(0xFF009688),
              fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          const Text('JPG, PNG • Max 2MB',
              style: TextStyle(color: Colors.grey, fontSize: 11)),
        ]),
      ),
    );
  }
}

// ==================== COMMON WIDGETS ====================
class _KycLabel extends StatelessWidget {
  final String text;
  final bool isRequired;
  const _KycLabel(this.text, {required this.isRequired});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Row(children: [
        Text(text, style: const TextStyle(fontSize: 13,
            fontWeight: FontWeight.w600, color: Colors.black87)),
        if (isRequired) const Text(' *',
            style: TextStyle(color: Colors.red, fontSize: 13,
                fontWeight: FontWeight.bold)),
      ]),
    );
  }
}

class _HelperText extends StatelessWidget {
  final String text;
  const _HelperText(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 4),
      child: Text(text,
          style: const TextStyle(color: Colors.grey, fontSize: 11)),
    );
  }
}

class _ErrorText extends StatelessWidget {
  final String text;
  const _ErrorText(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(text,
          style: const TextStyle(color: Colors.red, fontSize: 12)),
    );
  }
}

class _NextButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _NextButton({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity, height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF009688), elevation: 3,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(label, style: const TextStyle(fontSize: 17,
              fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
        ]),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Column(children: [
      Text('🇮🇳', style: TextStyle(fontSize: 28)),
      SizedBox(height: 5),
      Text('Made with ❤️ in India',
          style: TextStyle(color: Colors.black87, fontSize: 12)),
    ]));
  }
}

// ==================== HELPER FUNCTIONS ====================

AppBar _buildAppBar() => AppBar(
  backgroundColor: const Color(0xFF009688),
  elevation: 0,
  iconTheme: const IconThemeData(color: Colors.white),
  title: const Text('Create Account',
      style: TextStyle(color: Colors.white, fontSize: 18,
          fontWeight: FontWeight.w600)),
  centerTitle: true,
);

Widget _buildCard(Widget child) => Container(
  width: double.infinity,
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 15, offset: const Offset(0, 5))],
  ),
  child: child,
);

Widget _docSectionTitle(IconData icon, String title) => Row(children: [
  Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: const Color(0xFFE8F5E9),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(icon, color: const Color(0xFF009688), size: 20),
  ),
  const SizedBox(width: 10),
  Text(title, style: const TextStyle(fontSize: 15,
      fontWeight: FontWeight.bold, color: Colors.black87)),
]);

InputDecoration _kycInputDecoration(String hint, IconData icon) =>
    InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
      prefixIcon: Icon(icon, color: Colors.grey, size: 20),
      counterText: '', // ✅ maxLength counter hide
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF009688), width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1.8),
      ),
      contentPadding:
      const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    );

InputDecoration _loginInputDecoration(String hint, IconData icon) =>
    InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.grey, size: 22),
      counterText: '', // ✅ maxLength counter hide
      filled: true,
      fillColor: const Color(0xFFF0F0F0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      contentPadding:
      const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
    );

Widget _infoCard(String msg) => Container(
  width: double.infinity,
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: const Color(0xFFE8F5E9),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: const Color(0xFF67C949), width: 1),
  ),
  child: Row(children: [
    const Icon(Icons.info_outline, color: Color(0xFF009688), size: 20),
    const SizedBox(width: 10),
    Expanded(child: Text(msg, style: const TextStyle(
        color: Color(0xFF009688), fontSize: 12.5,
        fontWeight: FontWeight.w500))),
  ]),
);

Widget _summaryCard(String name, String mobile) => Container(
  width: double.infinity,
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: const Color(0xFFE8F5E9),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: const Color(0xFF67C949), width: 1),
  ),
  child: Row(children: [
    const Icon(Icons.check_circle_outline,
        color: Color(0xFF009688), size: 20),
    const SizedBox(width: 10),
    Expanded(child: Text('$name | $mobile',
        style: const TextStyle(color: Color(0xFF009688),
            fontSize: 12.5, fontWeight: FontWeight.w500))),
  ]),
);

Widget _sslBadge() => Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Icon(Icons.lock_outline, color: Colors.grey, size: 14),
    const SizedBox(width: 5),
    Text('256-bit SSL Secured | Your data is safe',
        style: TextStyle(color: Colors.grey[500], fontSize: 11.5)),
  ],
);

Widget _signInRow(BuildContext context) =>
    Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('Already registered? ',
          style: TextStyle(color: Colors.grey, fontSize: 13)),
      GestureDetector(
        onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
        child: const Text('Sign In', style: TextStyle(
            color: Color(0xFF009688),
            fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    ]));
