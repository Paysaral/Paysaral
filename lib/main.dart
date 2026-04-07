import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/validators.dart';
import 'screens/dashboard_screen.dart';
import 'services/auth_service.dart'; // 🔥 PAYSARAL BOSS FIX: Apna AuthService import kar liya

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// ==================== CUSTOM SCROLL BEHAVIOR ====================
// ✅ बस ये क्लास जोड़ी है ताकि पूरा ऐप रबर की तरह ना खिंचे
class NoStretchScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // ✅ बस ये 5 लाइन जोड़ी हैं पूरे ऐप में NoStretchScroll लागू करने के लिए
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: NoStretchScrollBehavior(),
          child: child!,
        );
      },
      home: const SplashScreen(),
    );
  }
}

// ==================== SMART FORMATTER ====================
class SmartMobileEmailFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (RegExp(r'^[0-9]+$').hasMatch(newValue.text)) {
      if (newValue.text.length > 10) {
        return oldValue;
      }
    }
    return newValue;
  }
}

// ==================== SPLASH SCREEN ====================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
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
    _logoCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _logoFade = CurvedAnimation(parent: _logoCtrl, curve: Curves.easeIn);
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _textCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _textFade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn);
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));
    _bottomCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _bottomFade = CurvedAnimation(parent: _bottomCtrl, curve: Curves.easeIn);

    _logoCtrl.forward();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _textCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) _bottomCtrl.forward();
    });

    Timer(const Duration(milliseconds: 3500), () async {
      if (!mounted) return;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        // ✅ JADOO: Removed 'const' from DashboardScreen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
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
              colors: [Color(0xFF004D40), Color(0xFF009688), Color(0xFF26A69A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              FadeTransition(
                  opacity: _logoFade,
                  child: ScaleTransition(
                      scale: _logoScale,
                      child: Image.asset('assets/images/welcome-logo.png', width: 260)
                  )
              ),
              const SizedBox(height: 20),
              FadeTransition(
                  opacity: _textFade,
                  child: SlideTransition(
                      position: _textSlide,
                      child: const Text(
                          "🇮🇳  India's No.1 Fintech Company",
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.8)
                      )
                  )
              ),
              const Spacer(flex: 2),
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
                                  const Icon(Icons.shield_rounded, color: Color(0xFF67C949), size: 30),
                                  Icon(Icons.shield, color: Colors.white.withOpacity(0.3), size: 16)
                                ]
                            ),
                            const SizedBox(width: 8),
                            const Text(
                                'Safe & Secure',
                                style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.5)
                            ),
                          ]
                      )
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== LOGIN SCREEN ====================
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
  bool _isLoading = false; // 🔥 PAYSARAL BOSS FIX: Loading state add kiya

  @override
  void dispose() {
    _mobile.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset('assets/images/login-bg.png', fit: BoxFit.fill)
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                        'Hi! Welcome Back',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: 1)
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 25, offset: const Offset(0, 12))
                          ]
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Image.asset('assets/images/paysaral-logo.png', height: 46),
                            const SizedBox(height: 22),
                            TextFormField(
                              controller: _mobile,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [SmartMobileEmailFormatter()],
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) return 'Required';
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              decoration: _loginInputDecoration('M.No/Email ID', Icons.person_outline),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _pass,
                              obscureText: _hidePass,
                              textInputAction: TextInputAction.done,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
                              style: const TextStyle(fontSize: 14),
                              decoration: _loginInputDecoration('Password', Icons.lock_outline).copyWith(
                                suffixIcon: IconButton(
                                    icon: Icon(_hidePass ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 22),
                                    onPressed: () => setState(() => _hidePass = !_hidePass)
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                      children: [
                                        SizedBox(
                                            width: 20, height: 20,
                                            child: Checkbox(
                                                value: _remember,
                                                onChanged: (v) => setState(() => _remember = v ?? false),
                                                activeColor: const Color(0xFF009688),
                                                side: const BorderSide(color: Color(0xFF009688), width: 1.5),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                                            )
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('Remember me', style: TextStyle(color: Color(0xFF009688), fontSize: 13, fontWeight: FontWeight.w500)),
                                      ]
                                  ),
                                  TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                      child: const Text('Forgot Password?', style: TextStyle(color: Colors.black87, fontSize: 13))
                                  ),
                                ]
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity, height: 50,
                              child: ElevatedButton(
                                // 🔥 PAYSARAL BOSS FIX: Agar loading ho raha hai, toh button disable ho jayega
                                onPressed: _isLoading ? null : () async {
                                  if (_formKey.currentState!.validate()) {

                                    // 1. Loading Start karo
                                    setState(() { _isLoading = true; });

                                    // 2. Real API Call
                                    final response = await AuthService.login(
                                      _mobile.text.trim(),
                                      _pass.text.trim(),
                                    );

                                    if (!context.mounted) return;

                                    // 3. Loading Stop karo
                                    setState(() { _isLoading = false; });

                                    // 4. API Response Check
                                    if (response['success'] == true) {
                                      // Token toh AuthService ne save kar liya, baaki aapka purana data save karte hain
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      String userMobile = _mobile.text.trim();

                                      await prefs.setString('currentUser', userMobile);
                                      await prefs.setBool('isLoggedIn', true);

                                      // Backend se aaye role ke hisaab se B2B set karte hain
                                      bool isB2B = false;
                                      if (response['user'] != null && response['user']['role'] == 'Retailer') {
                                        isB2B = true;
                                      }
                                      await prefs.setBool('isB2B', isB2B);

                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(response['message'] ?? 'Login Successful! 🎉'), backgroundColor: const Color(0xFF009688), duration: const Duration(seconds: 1))
                                      );

                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen()));
                                    } else {
                                      // Agar API se error aaya (galat password)
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(response['message'] ?? 'Login Failed!'), backgroundColor: Colors.red, duration: const Duration(seconds: 2))
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF67C949),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                                ),
                                // 🔥 PAYSARAL BOSS FIX: Loading ke time gol ghoomta hua loader dikhega
                                child: _isLoading
                                    ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                                )
                                    : const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ),
                            const SizedBox(height: 20),
                            RichText(
                                textAlign: TextAlign.center,
                                text: const TextSpan(
                                    style: TextStyle(color: Colors.black87, fontSize: 12.5),
                                    children: [
                                      TextSpan(text: 'By Login in, you agree to our! '),
                                      TextSpan(text: 'Privacy policy', style: TextStyle(color: Color(0xFF009688), fontWeight: FontWeight.bold))
                                    ]
                                )
                            ),
                            const SizedBox(height: 12),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an Account? ", style: TextStyle(color: Colors.black87, fontSize: 13)),
                                  GestureDetector(
                                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BasicRegisterStep1())),
                                      child: const Text('Register', style: TextStyle(color: Color(0xFF009688), fontWeight: FontWeight.bold, fontSize: 13))
                                  ),
                                ]
                            ),
                            const SizedBox(height: 16),
                            const _Footer(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== BASIC REGISTER STEP 1 ====================
class BasicRegisterStep1 extends StatefulWidget {
  const BasicRegisterStep1({super.key});
  @override
  State<BasicRegisterStep1> createState() => _BasicRegisterStep1State();
}

class _BasicRegisterStep1State extends State<BasicRegisterStep1> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _mobile = TextEditingController();
  final _email = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _mobile.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: Column(
          children: [
            const _StepHeader(currentStep: 1),
            Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                        key: _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoCard('Enter your basic details to create a free account.'),
                              const SizedBox(height: 20),
                              _buildCard(
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const _KycLabel('Full Name', isRequired: true),
                                        TextFormField(
                                            controller: _name,
                                            textInputAction: TextInputAction.next,
                                            textCapitalization: TextCapitalization.words,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: Validators.validateName,
                                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                                            decoration: _kycInputDecoration('Enter Your Name', Icons.person_outline)
                                        ),
                                        const SizedBox(height: 16),
                                        const _KycLabel('Mobile Number', isRequired: true),
                                        TextFormField(
                                            controller: _mobile,
                                            keyboardType: TextInputType.number,
                                            maxLength: 10,
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            textInputAction: TextInputAction.next,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: Validators.validateMobile,
                                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                                            decoration: _kycInputDecoration('Enter 10 Digit Number', Icons.phone_android)
                                        ),
                                        const SizedBox(height: 16),
                                        const _KycLabel('Your ID (Email)', isRequired: true),
                                        TextFormField(
                                            controller: _email,
                                            keyboardType: TextInputType.emailAddress,
                                            textInputAction: TextInputAction.done,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: Validators.validateEmail,
                                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                                            decoration: _kycInputDecoration('Enter Your Email', Icons.alternate_email)
                                        ),
                                        const _HelperText('Used for login & notifications'),
                                      ]
                                  )
                              ),
                              const SizedBox(height: 20),
                              _sslBadge(),
                              const SizedBox(height: 20),
                              _NextButton(
                                  label: 'Continue',
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => BasicRegisterStep2(name: _name.text, mobile: _mobile.text)));
                                    }
                                  }
                              ),
                              const SizedBox(height: 16),
                              _signInRow(context),
                              const SizedBox(height: 24),
                              const _Footer(),
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

// ==================== BASIC REGISTER STEP 2 ====================
class BasicRegisterStep2 extends StatefulWidget {
  final String name, mobile;
  const BasicRegisterStep2({super.key, required this.name, required this.mobile});
  @override
  State<BasicRegisterStep2> createState() => _BasicRegisterStep2State();
}

class _BasicRegisterStep2State extends State<BasicRegisterStep2> {
  final _formKey = GlobalKey<FormState>();
  final _pass = TextEditingController();
  final _sponsor = TextEditingController();
  bool _agree = false;
  bool _agreeError = false;
  bool _hidePass = true;

  @override
  void dispose() {
    _pass.dispose();
    _sponsor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: Column(
          children: [
            const _StepHeader(currentStep: 2),
            Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                        key: _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _summaryCard(widget.name, widget.mobile),
                              const SizedBox(height: 20),
                              _buildCard(
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const _KycLabel('Set Password', isRequired: true),
                                        TextFormField(
                                            controller: _pass,
                                            obscureText: _hidePass,
                                            textInputAction: TextInputAction.next,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: Validators.validatePassword,
                                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                                            decoration: _kycInputDecoration('Create Password', Icons.lock_outline).copyWith(
                                                suffixIcon: IconButton(
                                                    icon: Icon(_hidePass ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 20),
                                                    onPressed: () => setState(() => _hidePass = !_hidePass)
                                                )
                                            )
                                        ),
                                        const _HelperText('Min 6 chars. Make it secure!'),
                                        const SizedBox(height: 16),
                                        const _KycLabel('Referral / Sponsor ID', isRequired: false),
                                        TextFormField(
                                            controller: _sponsor,
                                            textInputAction: TextInputAction.done,
                                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                                            decoration: _kycInputDecoration('Enter ID (Optional)', Icons.people_outline)
                                        ),
                                        const _HelperText('Leave blank if you don\'t have one'),
                                      ]
                                  )
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: _agreeError ? Colors.red : Colors.transparent, width: 1.2),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5))
                                    ]
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          children: [
                                            SizedBox(
                                                width: 20, height: 20,
                                                child: Checkbox(
                                                    value: _agree,
                                                    onChanged: (v) => setState(() { _agree = v ?? false; _agreeError = false; }),
                                                    activeColor: const Color(0xFF009688),
                                                    side: const BorderSide(color: Color(0xFF009688), width: 1.5),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                                                )
                                            ),
                                            const SizedBox(width: 10),
                                            RichText(
                                                text: const TextSpan(
                                                    style: TextStyle(color: Colors.black87, fontSize: 13),
                                                    children: [
                                                      TextSpan(text: 'I agree to '),
                                                      TextSpan(text: 'Terms & Conditions', style: TextStyle(color: Color(0xFF009688), fontWeight: FontWeight.bold))
                                                    ]
                                                )
                                            )
                                          ]
                                      ),
                                      if (_agreeError)
                                        const Padding(
                                            padding: EdgeInsets.only(top: 6, left: 4),
                                            child: Text('Please agree to T&C to continue', style: TextStyle(color: Colors.red, fontSize: 12))
                                        ),
                                    ]
                                ),
                              ),
                              const SizedBox(height: 20),
                              _sslBadge(),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity, height: 52,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (!_agree) setState(() => _agreeError = true);
                                    if (_formKey.currentState!.validate() && _agree) {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();

                                      await prefs.setString('currentUser', widget.mobile);
                                      await prefs.setBool('role_${widget.mobile}', false);
                                      await prefs.setBool('isLoggedIn', true);
                                      await prefs.setBool('isB2B', false);

                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Account Created Successfully! 🎉'), backgroundColor: Color(0xFF009688))
                                      );
                                      // ✅ JADOO: Removed 'const' from DashboardScreen
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DashboardScreen()), (route) => false);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF67C949),
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                                  ),
                                  child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Create Account', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                                        SizedBox(width: 8),
                                        Icon(Icons.check_circle_outline, color: Colors.white, size: 20)
                                      ]
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              _signInRow(context),
                              const SizedBox(height: 24),
                              const _Footer(),
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

// ==================== COMMON WIDGETS ====================
class _StepHeader extends StatelessWidget {
  final int currentStep;
  const _StepHeader({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['Personal Details', 'Security'];
    return Container(
        color: const Color(0xFF009688),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
            children: [
              Row(
                  children: List.generate(2, (i) => Expanded(
                      child: Row(
                          children: [
                            Expanded(
                                child: Container(
                                    height: 4,
                                    decoration: BoxDecoration(color: i < currentStep ? Colors.white : Colors.white30, borderRadius: BorderRadius.circular(2))
                                )
                            ),
                            if (i < 1) const SizedBox(width: 5)
                          ]
                      )
                  ))
              ),
              const SizedBox(height: 14),
              FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(2, (i) {
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
                                          ? const Icon(Icons.check, color: Color(0xFF009688), size: 15)
                                          : Text('${i + 1}', style: TextStyle(color: isActive ? const Color(0xFF009688) : Colors.white70, fontWeight: FontWeight.bold, fontSize: 12))
                                  )
                              ),
                              const SizedBox(width: 5),
                              Text(
                                  steps[i],
                                  style: TextStyle(color: isActive ? Colors.white : Colors.white60, fontSize: 13, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal)
                              ),
                              if (i < 1) const SizedBox(width: 20)
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

class _KycLabel extends StatelessWidget {
  final String text;
  final bool isRequired;
  const _KycLabel(this.text, {required this.isRequired});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 2),
        child: Row(
            children: [
              Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
              if (isRequired) const Text(' *', style: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold))
            ]
        )
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
        child: Text(text, style: const TextStyle(color: Colors.grey, fontSize: 11))
    );
  }
}

class _NextButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _NextButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity, height: 52,
        child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009688),
                elevation: 3,
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
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(
            children: [
              Text('🇮🇳', style: TextStyle(fontSize: 28)),
              SizedBox(height: 5),
              Text('Made with ❤️ in India', style: TextStyle(color: Colors.black87, fontSize: 12))
            ]
        )
    );
  }
}

AppBar _buildAppBar() => AppBar(
    backgroundColor: const Color(0xFF009688),
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.white),
    title: const Text('Create Account', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
    centerTitle: true
);

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

InputDecoration _kycInputDecoration(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
    prefixIcon: Icon(icon, color: Colors.grey, size: 20),
    counterText: '',
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 1.2)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 1.2)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF009688), width: 1.8)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 1.2)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 1.8)),
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12)
);

InputDecoration _loginInputDecoration(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
    prefixIcon: Icon(icon, color: Colors.grey, size: 22),
    counterText: '',
    filled: true,
    fillColor: const Color(0xFFF0F0F0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1.2)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12)
);

Widget _infoCard(String msg) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF67C949), width: 1)
    ),
    child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF009688), size: 20),
          const SizedBox(width: 10),
          Expanded(
              child: Text(msg, style: const TextStyle(color: Color(0xFF009688), fontSize: 12.5, fontWeight: FontWeight.w500))
          )
        ]
    )
);

Widget _summaryCard(String name, String mobile) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF67C949), width: 1)
    ),
    child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Color(0xFF009688), size: 20),
          const SizedBox(width: 10),
          Expanded(
              child: Text('$name | $mobile', style: const TextStyle(color: Color(0xFF009688), fontSize: 12.5, fontWeight: FontWeight.w500))
          )
        ]
    )
);

Widget _sslBadge() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(Icons.lock_outline, color: Colors.grey, size: 14),
      const SizedBox(width: 5),
      Text('256-bit SSL Secured | Your data is safe', style: TextStyle(color: Colors.grey[500], fontSize: 11.5))
    ]
);

Widget _signInRow(BuildContext context) => Center(
    child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Already registered? ', style: TextStyle(color: Colors.grey, fontSize: 13)),
          GestureDetector(
              onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
              child: const Text('Sign In', style: TextStyle(color: Color(0xFF009688), fontWeight: FontWeight.bold, fontSize: 13))
          )
        ]
    )
);