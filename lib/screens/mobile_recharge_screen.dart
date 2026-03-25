import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'app_colors.dart';
import 'recharge_history_screen.dart';
import 'recharge_details_screen.dart';

class MobileRechargeScreen extends StatefulWidget {
  final bool isB2B;
  const MobileRechargeScreen({super.key, this.isB2B = false});

  @override
  State<MobileRechargeScreen> createState() => _MobileRechargeScreenState();
}

class _MobileRechargeScreenState extends State<MobileRechargeScreen> {
  final TextEditingController _prepaidPhoneController = TextEditingController();
  final TextEditingController _postpaidPhoneController = TextEditingController();
  final TextEditingController _prepaidAmountController = TextEditingController();
  final TextEditingController _postpaidAmountController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();

  bool isPrepaid = true;
  int _currentOfferIndex = 0;
  bool _isLoading = false;
  bool _isPhoneValid = false;

  String selectedPrepaidOperator = 'Airtel';
  String selectedPrepaidCircle = 'Jharkhand';
  String selectedPostpaidOperator = 'Jio';
  String selectedPostpaidCircle = 'Jharkhand';

  final List<Map<String, dynamic>> operatorsList = [
    {
      'name': 'Airtel',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Airtel_logo.png/512px-Airtel_logo.png',
      'color': const Color(0xFFE53935),
    },
    {
      'name': 'Jio',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Reliance_Jio_Logo_%28October_2015%29.svg/512px-Reliance_Jio_Logo_%28October_2015%29.svg.png',
      'color': const Color(0xFF1565C0),
    },
    {
      'name': 'Vi',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Vodafone_Idea_logo.svg/512px-Vodafone_Idea_logo.svg.png',
      'color': const Color(0xFFAD1457),
    },
    {
      'name': 'BSNL',
      'logo': 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e0/BSNL_logo.svg/512px-BSNL_logo.svg.png',
      'color': const Color(0xFF1565C0),
    },
  ];

  final List<String> circlesList = [
    'Jharkhand', 'Bihar', 'Delhi', 'Mumbai',
    'West Bengal', 'Assam', 'Odisha', 'UP East', 'UP West',
  ];

  final List<Map<String, dynamic>> recentRecharges = [
    {'name': 'Rahul Singh', 'number': '9876543210', 'operator': 'Jio',    'amount': '299'},
    {'name': 'Mom',         'number': '9123456789', 'operator': 'Airtel', 'amount': '199'},
    {'name': 'Shop WiFi',   'number': '9988776655', 'operator': 'Vi',     'amount': '349'},
    {'name': 'Papa',        'number': '9431000000', 'operator': 'Airtel', 'amount': '666'},
    {'name': 'Amit',        'number': '9123412345', 'operator': 'Jio',    'amount': '199'},
  ];

  final List<Map<String, dynamic>> quickPlans = [
    {'amount': '199', 'validity': '28 Days', 'data': '1.5GB/day'},
    {'amount': '299', 'validity': '28 Days', 'data': '2GB/day'},
    {'amount': '349', 'validity': '28 Days', 'data': '2.5GB/day'},
    {'amount': '666', 'validity': '56 Days', 'data': '2GB/day'},
  ];

  final List<String> offerImages = [
    'assets/images/bg1.png',
    'https://img.freepik.com/premium-photo/digital-payment-technology-graphic_53876-113543.jpg',
    'https://img.freepik.com/premium-photo/online-shopping-digital-marketing_53876-113539.jpg',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _phoneFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _prepaidPhoneController.dispose();
    _postpaidPhoneController.dispose();
    _prepaidAmountController.dispose();
    _postpaidAmountController.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  void _onNumberChanged(String value) {
    if (value.length == 10) {
      String detectedOp = 'Airtel';
      if (value.startsWith('98') || value.startsWith('99')) {
        detectedOp = 'Airtel';
      } else if (value.startsWith('7') || value.startsWith('8')) {
        detectedOp = 'Jio';
      } else if (value.startsWith('6')) {
        detectedOp = 'Vi';
      } else {
        detectedOp = 'BSNL';
      }

      setState(() {
        _isPhoneValid = true;
        if (isPrepaid) {
          selectedPrepaidOperator = detectedOp;
        } else {
          selectedPostpaidOperator = detectedOp;
        }
      });
      HapticFeedback.lightImpact();
    } else {
      if (_isPhoneValid) {
        setState(() {
          _isPhoneValid = false;
        });
      }
    }
  }

  Future<void> _processRecharge() async {
    FocusScope.of(context).unfocus();

    String amount = isPrepaid ? _prepaidAmountController.text : _postpaidAmountController.text;
    String number = isPrepaid ? _prepaidPhoneController.text : _postpaidPhoneController.text;
    String opName = isPrepaid ? selectedPrepaidOperator : selectedPostpaidOperator;

    if (number.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid 10-digit number')));
      return;
    }
    if (amount.isEmpty || amount == '0') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    var opData = operatorsList.firstWhere((o) => o['name'] == opName);

    // ✅ Yahan hum ensures karte hain ki parent se aayi hui 'isB2B' value aage pass ho
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RechargeDetailsScreen(
          isB2B: widget.isB2B,
          category: isPrepaid ? 'Prepaid' : 'Postpaid',
          amount: amount,
          operatorName: opName,
          rechargeNumber: '+91 $number',
          txnId: 'TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
          date: '25 Mar 2026, 04:30 PM',
          rewardAmount: widget.isB2B ? '4.50' : '0.00',
          operatorLogoText: opName[0],
          operatorLogoBg: opData['color'] as Color,
        ),
      ),
    );
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
              color: color.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Image.network(url, fit: BoxFit.contain,
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

  Widget _buildOperatorList(
      String tempOp, StateSetter setS, Function(String) onSelect) {
    return ListView.separated(
      key: const ValueKey('operators'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: operatorsList.length,
      separatorBuilder: (_, __) => Divider(
        height: 1, thickness: 1,
        color: Colors.grey.shade200,
        indent: 84, endIndent: 20,
      ),
      itemBuilder: (ctx, i) {
        var op = operatorsList[i];
        final bool isSel = tempOp == op['name'];
        return InkWell(
          onTap: () => onSelect(op['name']),
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
                        fontSize: 16,
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
    );
  }

  Widget _buildCircleList(
      String tempOp, String tempCircle, BuildContext ctx, StateSetter setS) {
    return ListView.separated(
      key: const ValueKey('circles'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: circlesList.length,
      separatorBuilder: (_, __) => Divider(
        height: 1, thickness: 1,
        color: Colors.grey.shade200,
        indent: 20, endIndent: 20,
      ),
      itemBuilder: (_, index) {
        final bool isSel = tempCircle == circlesList[index];
        return InkWell(
          onTap: () {
            setState(() {
              if (isPrepaid) {
                selectedPrepaidOperator = tempOp;
                selectedPrepaidCircle = circlesList[index];
              } else {
                selectedPostpaidOperator = tempOp;
                selectedPostpaidCircle = circlesList[index];
              }
            });
            Navigator.pop(ctx);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: isSel
                        ? AppColors.primaryColor.withOpacity(0.1)
                        : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.location_on_outlined,
                      size: 18,
                      color: isSel
                          ? AppColors.primaryColor
                          : Colors.grey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(circlesList[index],
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
                      color: AppColors.primaryColor, size: 22),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOperatorSheet(BuildContext context) {
    int step = 1;
    String tempOp =
    isPrepaid ? selectedPrepaidOperator : selectedPostpaidOperator;
    String tempCircle =
    isPrepaid ? selectedPrepaidCircle : selectedPostpaidCircle;

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
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => SafeArea(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 20, 8),
                  child: Row(
                    children: [
                      if (step == 2)
                        IconButton(
                          icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 20, color: Colors.black87),
                          onPressed: () => setS(() => step = 1),
                        ),
                      Padding(
                        padding:
                        EdgeInsets.only(left: step == 1 ? 12 : 0),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Text(
                            step == 1
                                ? 'Select Operator'
                                : 'Select Circle for $tempOp',
                            key: ValueKey(step),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  child: step == 1
                      ? _buildOperatorList(tempOp, setS, (op) {
                    setS(() {
                      tempOp = op;
                      step = 2;
                    });
                  })
                      : _buildCircleList(
                      tempOp, tempCircle, ctx, setS),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentOperator =
    isPrepaid ? selectedPrepaidOperator : selectedPostpaidOperator;
    String currentCircle =
    isPrepaid ? selectedPrepaidCircle : selectedPostpaidCircle;
    var opData =
    operatorsList.firstWhere((o) => o['name'] == currentOperator);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: CustomScrollView(
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
                                child: Text('Mobile Recharge',
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
                                    borderRadius:
                                    BorderRadius.circular(10),
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
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: 46,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: ['Prepaid', 'Postpaid']
                                  .asMap()
                                  .entries
                                  .map((e) {
                                final bool active =
                                isPrepaid ? e.key == 0 : e.key == 1;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(
                                            () => isPrepaid = e.key == 0),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                          milliseconds: 300),
                                      decoration: BoxDecoration(
                                        color: active
                                            ? Colors.white
                                            : Colors.transparent,
                                        borderRadius:
                                        BorderRadius.circular(11),
                                        boxShadow: active
                                            ? [
                                          const BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 6)
                                        ]
                                            : [],
                                      ),
                                      child: Center(
                                        child: Text(e.value,
                                            style: TextStyle(
                                              color: active
                                                  ? AppColors.primaryColor
                                                  : Colors.white70,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            )),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20),
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
                                  padding: const EdgeInsets.fromLTRB(
                                      16, 16, 16, 16),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.08),
                                          borderRadius:
                                          BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.smartphone_rounded,
                                          color: AppColors.primaryColor,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TextField(
                                          controller: isPrepaid
                                              ? _prepaidPhoneController
                                              : _postpaidPhoneController,
                                          focusNode: _phoneFocus,
                                          keyboardType:
                                          TextInputType.number,
                                          maxLength: 10,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          showCursor: true,
                                          cursorColor:
                                          AppColors.primaryColor,
                                          cursorWidth: 2,
                                          cursorRadius:
                                          const Radius.circular(2),
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.5,
                                            color: Colors.black87,
                                          ),
                                          decoration: InputDecoration(
                                            counterText: '',
                                            hintText: 'Enter your M.No',
                                            hintStyle: TextStyle(
                                                color: Colors.grey.shade400,
                                                fontSize: 15,
                                                fontWeight:
                                                FontWeight.w400),
                                            border: InputBorder.none,
                                          ),
                                          onChanged: _onNumberChanged,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Container(
                                          padding:
                                          const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor
                                                .withOpacity(0.1),
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: const Icon(
                                              Icons.contacts_outlined,
                                              color:
                                              AppColors.primaryColor,
                                              size: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOutCubic,
                                  child: _isPhoneValid
                                      ? Column(
                                    children: [
                                      Divider(
                                          color: Colors.grey.shade100,
                                          thickness: 1,
                                          height: 1),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 14, 8, 14),
                                        child: Row(
                                          children: [
                                            _buildLogo(
                                                currentOperator,
                                                opData['logo'],
                                                opData['color'] as Color,
                                                38),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(currentOperator,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight.w700,
                                                          fontSize: 14)),
                                                  Text(currentCircle,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .grey.shade500)),
                                                ],
                                              ),
                                            ),
                                            TextButton.icon(
                                              onPressed: () =>
                                                  _showOperatorSheet(context),
                                              icon: const Icon(
                                                  Icons.swap_horiz_rounded,
                                                  size: 16),
                                              label: const Text('Change'),
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                AppColors.primaryColor,
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                      : const SizedBox(width: double.infinity, height: 0),
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
                          Text(
                            isPrepaid ? 'Recharge Amount' : 'Bill Amount',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                                letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor
                                      .withOpacity(0.08),
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
                                  controller: isPrepaid
                                      ? _prepaidAmountController
                                      : _postpaidAmountController,
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
                                      child: Text(
                                        isPrepaid
                                            ? 'Browse Plans'
                                            : 'View Bill',
                                        style: const TextStyle(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12),
                                      ),
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
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.lock_rounded, color: Colors.white70, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  isPrepaid ? 'Proceed to Pay' : 'Pay Bill',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (isPrepaid) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Quick Plans',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87)),
                          TextButton(
                            onPressed: () {},
                            child: const Text('All Plans →',
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _QuickPlanSelector(
                        plans: quickPlans,
                        amountController: _prepaidAmountController,
                      ),
                      const SizedBox(height: 28),
                    ],
                    if (isPrepaid) ...[
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
                          children: recentRecharges
                              .asMap()
                              .entries
                              .map((entry) {
                            int idx = entry.key;
                            var r = entry.value;
                            var opD = operatorsList.firstWhere(
                                    (o) => o['name'] == r['operator']);
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  leading: _buildLogo(
                                      r['operator'],
                                      opD['logo'],
                                      opD['color'] as Color,
                                      42),
                                  title: Text(r['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                  subtitle: Text(
                                      '${r['number']} • ${r['operator']}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500)),
                                  trailing: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                    children: [
                                      Text('₹${r['amount']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: Colors.black87)),
                                      Text('Tap to recharge',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.7))),
                                    ],
                                  ),
                                  onTap: () {
                                    _prepaidPhoneController.text = r['number'];
                                    _prepaidAmountController.text = r['amount'].replaceAll('₹', '');
                                    setState(() {
                                      _isPhoneValid = true;
                                      selectedPrepaidOperator = r['operator'];
                                    });
                                  },
                                ),
                                if (idx != recentRecharges.length - 1)
                                  Divider(
                                      height: 1,
                                      color: Colors.grey.shade100,
                                      indent: 74,
                                      endIndent: 16),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ] else ...[
                      CarouselSlider.builder(
                        itemCount: offerImages.length,
                        options: CarouselOptions(
                          height: 110,
                          viewportFraction: 1.0,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          onPageChanged: (i, _) =>
                              setState(() => _currentOfferIndex = i),
                        ),
                        itemBuilder: (ctx, i, _) => Container(
                          margin:
                          const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12, blurRadius: 6)
                              ]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: offerImages[i].startsWith('http')
                                ? Image.network(offerImages[i],
                                fit: BoxFit.fill,
                                width: double.infinity,
                                errorBuilder: (c, e, s) => Container(
                                    color: Colors.grey.shade200))
                                : Image.asset(offerImages[i],
                                fit: BoxFit.fill,
                                width: double.infinity,
                                errorBuilder: (c, e, s) => Container(
                                    color: Colors.grey.shade200)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: offerImages.asMap().entries.map((e) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: _currentOfferIndex == e.key ? 20 : 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: _currentOfferIndex == e.key
                                  ? AppColors.primaryColor
                                  : Colors.grey.shade300,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickPlanSelector extends StatefulWidget {
  final List<Map<String, dynamic>> plans;
  final TextEditingController amountController;

  const _QuickPlanSelector({
    required this.plans,
    required this.amountController,
  });

  @override
  State<_QuickPlanSelector> createState() => _QuickPlanSelectorState();
}

class _QuickPlanSelectorState extends State<_QuickPlanSelector> {
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
                          horizontal: 14, vertical: 10),
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
                          Text('${plan['data']} • ${plan['validity']}',
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
                              colors: [
                                Color(0xFF00695C),
                                Color(0xFF009688)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color:
                              isSel ? Colors.white : Colors.black87,
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
                            child: Text(
                                '${plan['data']} • ${plan['validity']}'),
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