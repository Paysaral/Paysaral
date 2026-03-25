import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'app_colors.dart';
import 'recharge_history_screen.dart';
import 'recharge_details_screen.dart'; // ✅ LINKED SUCCESS SCREEN

class DthRechargeScreen extends StatefulWidget {
  final bool isB2B; // ✅ Added B2B support
  const DthRechargeScreen({super.key, this.isB2B = false});

  @override
  State<DthRechargeScreen> createState() => _DthRechargeScreenState();
}

class _DthRechargeScreenState extends State<DthRechargeScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _idFocus = FocusNode();

  bool _operatorSelected = false;
  String selectedOperator = '';
  int _bannerIndex = 0;
  bool _isLoading = false; // ✅ Added Loading State

  final List<Map<String, dynamic>> operatorsList = [
    {
      'name': 'Tata Play (formerly Tata Sky)',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7b/Tata_Play_2022_logo.svg/512px-Tata_Play_2022_logo.svg.png',
      'color': const Color(0xFF6A1B9A),
    },
    {
      'name': 'Airtel Digital TV',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Airtel_logo.png/512px-Airtel_logo.png',
      'color': const Color(0xFFE53935),
    },
    {
      'name': 'D2H',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Videocon_d2h_Logo.svg/512px-Videocon_d2h_Logo.svg.png',
      'color': const Color(0xFF7B1FA2),
    },
    {
      'name': 'Dish TV',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Dish_TV_India_logo.svg/512px-Dish_TV_India_logo.svg.png',
      'color': const Color(0xFFE65100),
    },
    {
      'name': 'Sun Direct',
      'logo': 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e6/Sun_Direct_logo.svg/512px-Sun_Direct_logo.svg.png',
      'color': const Color(0xFFF9A825),
    },
  ];

  final List<String> bannerImages = [
    'assets/images/bg1.png',
    'https://img.freepik.com/premium-photo/digital-payment-technology-graphic_53876-113543.jpg',
    'https://img.freepik.com/premium-photo/online-shopping-digital-marketing_53876-113539.jpg',
  ];

  final List<Map<String, dynamic>> quickPlans = [
    {'amount': '200', 'label': 'Basic'},
    {'amount': '300', 'label': 'Standard'},
    {'amount': '500', 'label': 'Popular'},
    {'amount': '1000', 'label': 'Premium'},
  ];

  final List<Map<String, dynamic>> recentTransactions = [
    {
      'name': 'Papa',
      'id': 'VC1234567890',
      'operator': 'Tata Play (formerly Tata Sky)',
      'operatorLogo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7b/Tata_Play_2022_logo.svg/512px-Tata_Play_2022_logo.svg.png',
      'operatorColor': const Color(0xFF6A1B9A),
      'amount': '500',
      'date': '20 Mar 2026',
    },
    {
      'name': 'Home TV',
      'id': 'VC9876543210',
      'operator': 'Airtel Digital TV',
      'operatorLogo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Airtel_logo.png/512px-Airtel_logo.png',
      'operatorColor': const Color(0xFFE53935),
      'amount': '300',
      'date': '15 Mar 2026',
    },
    {
      'name': 'Office',
      'id': 'VC1122334455',
      'operator': 'Dish TV',
      'operatorLogo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Dish_TV_India_logo.svg/512px-Dish_TV_India_logo.svg.png',
      'operatorColor': const Color(0xFFE65100),
      'amount': '200',
      'date': '10 Mar 2026',
    },
  ];

  @override
  void dispose() {
    _idController.dispose();
    _amountController.dispose();
    _idFocus.dispose();
    super.dispose();
  }

  // ✅ JADOO: Process Recharge & Send Data to Success Screen
  Future<void> _processRecharge() async {
    FocusScope.of(context).unfocus(); // Keyboard band karo

    String amount = _amountController.text.trim();
    String subId = _idController.text.trim();

    if (subId.isEmpty || subId.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid Subscriber ID')));
      return;
    }
    if (amount.isEmpty || amount == '0') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    setState(() => _isLoading = true);

    // Simulated API delay (2 seconds)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Get operator details for logo passing
    var opData = operatorsList.firstWhere((o) => o['name'] == selectedOperator);

    // ✅ Pura data bhej rahe hain apne drawing wale Success Screen ko
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RechargeDetailsScreen(
          isB2B: widget.isB2B,
          category: 'DTH', // Category change ki hai
          amount: amount,
          operatorName: selectedOperator,
          rechargeNumber: 'Sub ID: $subId', // Sub ID format
          txnId: 'DTH${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
          date: '25 Mar 2026, 05:15 PM',
          rewardAmount: widget.isB2B ? '12.50' : '0.00', // Dummy commission
          operatorLogoText: selectedOperator[0],
          operatorLogoBg: opData['color'] as Color,
        ),
      ),
    );
  }

  void _selectOperator(String name) {
    setState(() {
      selectedOperator = name;
      _operatorSelected = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _idFocus.requestFocus();
    });
  }

  Widget _buildLogo(String name, String url, Color color, double size) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Image.network(url,
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => Center(
                child: Text(name[0],
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: size * 0.4)),
              )),
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: bannerImages.length,
          options: CarouselOptions(
            height: 90,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (i, _) =>
                setState(() => _bannerIndex = i),
          ),
          itemBuilder: (ctx, i, _) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 3)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: bannerImages[i].startsWith('http')
                  ? Image.network(
                  bannerImages[i],
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: 90,
                  errorBuilder: (c, e, s) =>
                      Container(color: Colors.grey.shade200))
                  : Image.asset(
                  bannerImages[i],
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: 90,
                  errorBuilder: (c, e, s) =>
                      Container(color: Colors.grey.shade200)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: bannerImages.asMap().entries.map((e) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _bannerIndex == e.key ? 16 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _bannerIndex == e.key
                    ? Colors.white
                    : Colors.white.withOpacity(0.4),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showOperatorSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 350),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 6),
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 8),
              child: Text(
                'Select DTH Operator',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: operatorsList.length,
              separatorBuilder: (_, __) => Divider(
                height: 1, thickness: 1,
                color: Colors.grey.shade100,
                indent: 84, endIndent: 20,
              ),
              itemBuilder: (ctx, i) {
                var op = operatorsList[i];
                final bool isSel = selectedOperator == op['name'];
                return InkWell(
                  onTap: () {
                    setState(() => selectedOperator = op['name']);
                    Navigator.pop(ctx);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSel
                                  ? AppColors.primaryColor
                                  : Colors.grey.shade200,
                              width: isSel ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Image.network(op['logo'],
                                  fit: BoxFit.contain,
                                  errorBuilder: (c, e, s) => Center(
                                    child: Text(op['name'][0],
                                        style: TextStyle(
                                            color: op['color'],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22)),
                                  )),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(op['name'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSel
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: isSel
                                    ? AppColors.primaryColor
                                    : Colors.black87,
                              )),
                        ),
                        if (isSel)
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.primaryColor, size: 22)
                        else
                          Icon(Icons.arrow_forward_ios_rounded,
                              size: 14, color: Colors.grey.shade400),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
            child: _operatorSelected
                ? _buildScreen2()
                : _buildScreen1(),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════
  // SCREEN 1 (Select Operator)
  // ══════════════════════════════════════
  Widget _buildScreen1() {
    return CustomScrollView(
      key: const ValueKey('screen1'),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00695C), Color(0xFF009688)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 6),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text('DTH Recharge',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.history_rounded,
                                color: Colors.white, size: 18),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RechargeHistoryScreen(isB2B: widget.isB2B),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                    child: _buildBannerSlider(),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('DTH Operators',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 4)),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: operatorsList.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1, thickness: 1,
                      color: Colors.grey.shade100,
                      indent: 82, endIndent: 0,
                    ),
                    itemBuilder: (ctx, i) {
                      var op = operatorsList[i];
                      return InkWell(
                        borderRadius: BorderRadius.vertical(
                          top: i == 0
                              ? const Radius.circular(20)
                              : Radius.zero,
                          bottom: i == operatorsList.length - 1
                              ? const Radius.circular(20)
                              : Radius.zero,
                        ),
                        onTap: () => _selectOperator(op['name']),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              _buildLogo(
                                  op['name'],
                                  op['logo'],
                                  op['color'] as Color,
                                  50),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(op['name'],
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87)),
                              ),
                              Icon(Icons.arrow_forward_ios_rounded,
                                  size: 13,
                                  color: Colors.grey.shade300),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════
  // SCREEN 2 (Enter ID and Amount)
  // ══════════════════════════════════════
  Widget _buildScreen2() {
    var opData = operatorsList.firstWhere((o) => o['name'] == selectedOperator);

    return CustomScrollView(
      key: const ValueKey('screen2'),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00695C), Color(0xFF009688)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 6),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 20),
                          onPressed: () => setState(() {
                            _operatorSelected = false;
                            _idController.clear();
                            _amountController.clear();
                          }),
                        ),
                        const Expanded(
                          child: Text('DTH Recharge',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.history_rounded,
                                color: Colors.white, size: 18),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RechargeHistoryScreen(isB2B: widget.isB2B),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.tv_rounded,
                                      color: AppColors.primaryColor, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _idController,
                                    focusNode: _idFocus,
                                    showCursor: true,
                                    cursorColor: AppColors.primaryColor,
                                    cursorWidth: 2,
                                    cursorRadius: const Radius.circular(2),
                                    keyboardType: TextInputType.text,
                                    maxLength: 20,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5,
                                      color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      hintText: 'Enter Subscriber ID / VC No.',
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 14),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                        Icons.contact_mail_outlined,
                                        color: AppColors.primaryColor,
                                        size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                              color: Colors.grey.shade100,
                              thickness: 1,
                              height: 20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 8, 14),
                            child: Row(
                              children: [
                                _buildLogo(
                                    selectedOperator,
                                    opData['logo'],
                                    opData['color'] as Color,
                                    38),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(selectedOperator,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13)),
                                ),
                                TextButton.icon(
                                  onPressed: () => _showOperatorSheet(context),
                                  icon: const Icon(
                                      Icons.swap_horiz_rounded, size: 16),
                                  label: const Text('Change'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.primaryColor,
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          sliver: SliverList(
            delegate: SliverChildListDelegate([

              // Amount Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recharge Amount',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                            letterSpacing: 0.5)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('₹',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(5),
                            ],
                            cursorColor: AppColors.primaryColor,
                            cursorWidth: 2,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: '0',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                              ),
                              border: InputBorder.none,
                              suffixIcon: TextButton(
                                onPressed: () {},
                                child: const Text('Customer Info',
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ✅ JADOO: Animated Pay Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _processRecharge,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isLoading
                            ? [Colors.grey.shade400, Colors.grey.shade500]
                            : [const Color(0xFF00695C), const Color(0xFF009688)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: _isLoading
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                          : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_rounded,
                              color: Colors.white70, size: 16),
                          SizedBox(width: 8),
                          Text('Proceed to Pay',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Quick Amounts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Quick Amounts',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87)),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View Plans →',
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _DthQuickAmountSelector(
                plans: quickPlans,
                amountController: _amountController,
              ),

              const SizedBox(height: 28),

              // Recent Recharges
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Recharges',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RechargeHistoryScreen(isB2B: widget.isB2B),
                        ),
                      );
                    },
                    child: const Text('See All →',
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: recentTransactions.asMap().entries.map((entry) {
                    int idx = entry.key;
                    var t = entry.value;
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          leading: _buildLogo(
                              t['operator'],
                              t['operatorLogo'],
                              t['operatorColor'] as Color,
                              44),
                          title: Text(t['name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                          subtitle: Text(
                              '${t['id']} • ${t['operator']}',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500)),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('₹${t['amount']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Colors.black87)),
                              Text(t['date'],
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade400)),
                            ],
                          ),
                          onTap: () {
                            _idController.text = t['id'];
                            _amountController.text = t['amount'];
                            setState(() {
                              selectedOperator = t['operator'];
                              _operatorSelected = true; // Auto skip to screen 2
                            });
                          },
                        ),
                        if (idx != recentTransactions.length - 1)
                          Divider(
                              height: 1,
                              color: Colors.grey.shade100,
                              indent: 76,
                              endIndent: 16),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),
            ]),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════
// Quick Amount Selector
// ════════════════════════════════════════════════════
class _DthQuickAmountSelector extends StatefulWidget {
  final List<Map<String, dynamic>> plans;
  final TextEditingController amountController;

  const _DthQuickAmountSelector({
    required this.plans,
    required this.amountController,
  });

  @override
  State<_DthQuickAmountSelector> createState() =>
      _DthQuickAmountSelectorState();
}

class _DthQuickAmountSelectorState extends State<_DthQuickAmountSelector> {
  String _selected = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.plans.map((plan) {
          final bool isSel = _selected == plan['amount'];
          return GestureDetector(
            onTap: () {
              setState(() => _selected = plan['amount']);
              widget.amountController.text = plan['amount'];
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('₹${plan['amount']}',
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.transparent)),
                          const SizedBox(height: 3),
                          Text(plan['label'],
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.transparent)),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        opacity: isSel ? 1.0 : 0.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF00695C), Color(0xFF009688)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isSel ? Colors.white : Colors.black87,
                            ),
                            child: Text('₹${plan['amount']}'),
                          ),
                          const SizedBox(height: 3),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            style: TextStyle(
                              fontSize: 11,
                              color: isSel
                                  ? Colors.white70
                                  : Colors.grey.shade500,
                            ),
                            child: Text(plan['label']),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}