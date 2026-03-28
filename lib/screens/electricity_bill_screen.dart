import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'recharge_history_screen.dart';
import 'electricity_payment_screen.dart';

class ElectricityBillScreen extends StatefulWidget {
  final Map<String, dynamic>? initialDiscom;

  const ElectricityBillScreen({
    super.key,
    this.initialDiscom,
  });

  @override
  State<ElectricityBillScreen> createState() =>
      _ElectricityBillScreenState();
}

class _ElectricityBillScreenState extends State<ElectricityBillScreen> {
  final TextEditingController _consumerController = TextEditingController();
  final FocusNode _consumerFocus = FocusNode();

  bool _isFetching = false;
  bool _billFetched = false;
  Map<String, dynamic>? fetchedBill;

  late Map<String, dynamic> selectedDiscom;
  static const int _minDigits = 10;

  final List<Map<String, dynamic>> discoms = [
    {'name': 'JBVNL', 'fullName': 'Jharkhand Bijli Vitran Nigam Ltd', 'state': 'Jharkhand', 'icon': Icons.bolt_rounded, 'color': Color(0xFF00897B)},
    {'name': 'SBPDCL', 'fullName': 'South Bihar Power Distribution Co. Ltd', 'state': 'Bihar', 'icon': Icons.electric_meter_rounded, 'color': Color(0xFF1565C0)},
    {'name': 'NBPDCL', 'fullName': 'North Bihar Power Distribution Co. Ltd', 'state': 'Bihar', 'icon': Icons.electric_meter_rounded, 'color': Color(0xFF0288D1)},
    {'name': 'UPPCL (Urban)', 'fullName': 'Uttar Pradesh Power Corp Ltd - Urban', 'state': 'Uttar Pradesh', 'icon': Icons.bolt_rounded, 'color': Color(0xFF6A1B9A)},
    {'name': 'UPPCL (Rural)', 'fullName': 'Uttar Pradesh Power Corp Ltd - Rural', 'state': 'Uttar Pradesh', 'icon': Icons.bolt_rounded, 'color': Color(0xFF7B1FA2)},
    {'name': 'PVVNL', 'fullName': 'Paschimanchal Vidyut Vitran Nigam Ltd', 'state': 'Uttar Pradesh', 'icon': Icons.electric_bolt_rounded, 'color': Color(0xFF4527A0)},
    {'name': 'BSES Rajdhani', 'fullName': 'BSES Rajdhani Power Limited', 'state': 'Delhi', 'icon': Icons.location_city_rounded, 'color': Color(0xFFE53935)},
    {'name': 'BSES Yamuna', 'fullName': 'BSES Yamuna Power Limited', 'state': 'Delhi', 'icon': Icons.location_city_rounded, 'color': Color(0xFFD81B60)},
    {'name': 'TPDDL', 'fullName': 'Tata Power Delhi Distribution Ltd', 'state': 'Delhi', 'icon': Icons.flash_on_rounded, 'color': Color(0xFF1565C0)},
    {'name': 'MSEDCL', 'fullName': 'Maharashtra State Electricity Dist. Co.', 'state': 'Maharashtra', 'icon': Icons.bolt_rounded, 'color': Color(0xFFE65100)},
    {'name': 'TATA Power Mumbai', 'fullName': 'Tata Power Company Ltd - Mumbai', 'state': 'Maharashtra', 'icon': Icons.flash_on_rounded, 'color': Color(0xFF1565C0)},
    {'name': 'Adani Electricity', 'fullName': 'Adani Electricity Mumbai Ltd', 'state': 'Maharashtra', 'icon': Icons.electric_bolt_rounded, 'color': Color(0xFF2E7D32)},
    {'name': 'WBSEDCL', 'fullName': 'West Bengal State Electricity Dist. Co.', 'state': 'West Bengal', 'icon': Icons.bolt_rounded, 'color': Color(0xFF00838F)},
    {'name': 'CESC', 'fullName': 'Calcutta Electric Supply Corp.', 'state': 'West Bengal', 'icon': Icons.electric_meter_rounded, 'color': Color(0xFF37474F)},
    {'name': 'MPPKVVCL', 'fullName': 'MP Paschim Kshetra Vidyut Vitaran Co.', 'state': 'Madhya Pradesh', 'icon': Icons.bolt_rounded, 'color': Color(0xFFF57F17)},
    {'name': 'MPEZ', 'fullName': 'MP Poorv Kshetra Vidyut Vitaran Co.', 'state': 'Madhya Pradesh', 'icon': Icons.bolt_rounded, 'color': Color(0xFFF9A825)},
    {'name': 'JVVNL', 'fullName': 'Jaipur Vidyut Vitran Nigam Ltd', 'state': 'Rajasthan', 'icon': Icons.bolt_rounded, 'color': Color(0xFFBF360C)},
    {'name': 'AVVNL', 'fullName': 'Ajmer Vidyut Vitran Nigam Ltd', 'state': 'Rajasthan', 'icon': Icons.bolt_rounded, 'color': Color(0xFFD84315)},
    {'name': 'DGVCL', 'fullName': 'Dakshin Gujarat Vij Co. Ltd', 'state': 'Gujarat', 'icon': Icons.bolt_rounded, 'color': Color(0xFF00695C)},
    {'name': 'UGVCL', 'fullName': 'Uttar Gujarat Vij Co. Ltd', 'state': 'Gujarat', 'icon': Icons.bolt_rounded, 'color': Color(0xFF00796B)},
    {'name': 'TPCODL', 'fullName': 'TP Central Odisha Distribution Ltd', 'state': 'Odisha', 'icon': Icons.bolt_rounded, 'color': Color(0xFF558B2F)},
    {'name': 'TPSODL', 'fullName': 'TP Southern Odisha Distribution Ltd', 'state': 'Odisha', 'icon': Icons.bolt_rounded, 'color': Color(0xFF33691E)},
    {'name': 'APDCL', 'fullName': 'Assam Power Distribution Co. Ltd', 'state': 'Assam', 'icon': Icons.bolt_rounded, 'color': Color(0xFF4E342E)},
    {'name': 'UHBVN', 'fullName': 'Uttar Haryana Bijli Vitran Nigam', 'state': 'Haryana', 'icon': Icons.bolt_rounded, 'color': Color(0xFF01579B)},
    {'name': 'DHBVN', 'fullName': 'Dakshin Haryana Bijli Vitran Nigam', 'state': 'Haryana', 'icon': Icons.bolt_rounded, 'color': Color(0xFF0277BD)},
    {'name': 'PSPCL', 'fullName': 'Punjab State Power Corp. Ltd', 'state': 'Punjab', 'icon': Icons.bolt_rounded, 'color': Color(0xFF1A237E)},
  ];

  final List<Map<String, dynamic>> recentPayments = [
    {'name': 'Home', 'consumer': 'CA123456789', 'discom': 'JBVNL', 'amount': '₹1,250', 'date': '15 Mar 2026'},
    {'name': 'Office', 'consumer': 'CA987654321', 'discom': 'SBPDCL', 'amount': '₹3,400', 'date': '10 Mar 2026'},
    {'name': 'Shop', 'consumer': 'CA112233445', 'discom': 'JBVNL', 'amount': '₹890', 'date': '05 Mar 2026'},
  ];

  Map<String, List<Map<String, dynamic>>> get _groupedDiscoms {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var d in discoms) {
      final state = d['state'] as String;
      grouped[state] ??= [];
      grouped[state]!.add(d);
    }
    return grouped;
  }

  @override
  void initState() {
    super.initState();
    selectedDiscom = widget.initialDiscom ?? {
      'name': 'JBVNL',
      'fullName': 'Jharkhand Bijli Vitran Nigam Ltd',
      'state': 'Jharkhand',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFF00897B),
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _consumerFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _consumerController.dispose();
    _consumerFocus.dispose();
    super.dispose();
  }

  void _onConsumerChanged(String value) {
    if (_billFetched || fetchedBill != null) {
      setState(() {
        _billFetched = false;
        fetchedBill = null;
      });
    }
    if (value.length >= _minDigits && !_isFetching) {
      FocusScope.of(context).unfocus();
      _fetchBill();
    }
  }

  void _fetchBill() async {
    if (_consumerController.text.length < _minDigits) return;
    setState(() {
      _isFetching = true;
      _billFetched = false;
      fetchedBill = null;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isFetching = false;
      _billFetched = true;
      final text = _consumerController.text;
      fetchedBill = {
        'consumerName': 'Rajesh Kumar',
        'consumerNo': text,
        'discom': selectedDiscom['name'],
        'billDate': '01 Mar 2026',
        'dueDate': '20 Mar 2026',
        'billAmount': '1,450.00',
        'units': '245',
        'billMonth': 'February 2026',
        'meterNo': 'MTR${text.substring(0, text.length >= 4 ? 4 : text.length)}XXX',
      };
    });
  }

  void _showDiscomSheet(BuildContext context) {
    final grouped = _groupedDiscoms;
    final states = grouped.keys.toList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollCtrl) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      Icon(Icons.flash_on_rounded, color: AppColors.primaryColor, size: 22),
                      SizedBox(width: 8),
                      Text('Select Electricity Board',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${discoms.length} operators available',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  const SizedBox(height: 12),
                  Divider(color: Colors.grey.shade100),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                itemCount: states.length,
                itemBuilder: (_, si) {
                  final state = states[si];
                  final stateDiscoms = grouped[state]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(state,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryColor)),
                        ),
                      ),
                      ...stateDiscoms.map((d) {
                        final bool isSel = selectedDiscom['name'] == d['name'];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedDiscom = d;
                              _billFetched = false;
                              fetchedBill = null;
                            });
                            Navigator.pop(ctx);
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? AppColors.primaryColor.withOpacity(0.06)
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSel
                                    ? AppColors.primaryColor.withOpacity(0.3)
                                    : Colors.grey.shade200,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 42, height: 42,
                                  decoration: BoxDecoration(
                                    color: (d['color'] as Color).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(d['icon'] as IconData,
                                      color: d['color'] as Color, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(d['name'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: isSel
                                                  ? AppColors.primaryColor
                                                  : Colors.black87)),
                                      const SizedBox(height: 2),
                                      Text(d['fullName'],
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade500),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                                if (isSel)
                                  const Icon(Icons.check_circle_rounded,
                                      color: AppColors.primaryColor, size: 20),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
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
          // ✅ JADOO: CustomScrollView hata kar Column laga diya gaya hai. Top fixed rahega!
          body: Column(
            children: [
              // ══ FIXED HEADER HERO SECTION ════════════════════════════
              Container(
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
                      // AppBar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white, size: 20),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Expanded(
                              child: Text('Electricity Bill',
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
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => const RechargeHistoryScreen(isB2B: true),
                                ));
                              },
                            ),
                          ],
                        ),
                      ),

                      // Discom + Consumer Card
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
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
                              // Discom Row
                              InkWell(
                                onTap: () => _showDiscomSheet(context),
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 46, height: 46,
                                        decoration: BoxDecoration(
                                          color: (selectedDiscom['color'] as Color)
                                              .withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(13),
                                        ),
                                        child: Icon(
                                          selectedDiscom['icon'] as IconData,
                                          color: selectedDiscom['color'] as Color,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(selectedDiscom['name'],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 15,
                                                    color: Colors.black87)),
                                            const SizedBox(height: 2),
                                            Text(selectedDiscom['fullName'],
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey.shade500),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor.withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Row(
                                          children: [
                                            Text('Change',
                                                style: TextStyle(
                                                    color: AppColors.primaryColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600)),
                                            SizedBox(width: 4),
                                            Icon(Icons.keyboard_arrow_down_rounded,
                                                color: AppColors.primaryColor, size: 16),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Divider(height: 1, color: Colors.grey.shade100),

                              // Consumer Number Input
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.electric_meter_rounded,
                                          color: AppColors.primaryColor, size: 22),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextField(
                                        controller: _consumerController,
                                        focusNode: _consumerFocus,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(15),
                                        ],
                                        onChanged: _onConsumerChanged,
                                        showCursor: true,
                                        cursorColor: AppColors.primaryColor,
                                        cursorWidth: 2,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1,
                                            color: Colors.black87),
                                        decoration: InputDecoration(
                                          hintText: 'Enter Consumer Number',
                                          hintStyle: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0),
                                          border: InputBorder.none,
                                          suffixIcon: _isFetching
                                              ? const Padding(
                                            padding: EdgeInsets.all(12),
                                            child: SizedBox(
                                              width: 18, height: 18,
                                              child: CircularProgressIndicator(
                                                  color: AppColors.primaryColor,
                                                  strokeWidth: 2),
                                            ),
                                          )
                                              : _billFetched
                                              ? const Icon(Icons.check_circle_rounded,
                                              color: Colors.green, size: 22)
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Hint text
                              if (!_isFetching && !_billFetched)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline_rounded,
                                          size: 13, color: Colors.grey.shade400),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Bill will auto-fetch after $_minDigits digits',
                                        style: TextStyle(
                                            fontSize: 11, color: Colors.grey.shade400),
                                      ),
                                    ],
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

              // ══ SCROLLABLE BODY ═════════════════════════════════
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                  physics: const ClampingScrollPhysics(), // Premium smooth scroll
                  child: Column(
                    children: [
                      // Fetching Card
                      if (_isFetching) ...[
                        Container(
                          width: double.infinity,
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
                            children: [
                              const SizedBox(height: 8),
                              const SizedBox(
                                width: 36, height: 36,
                                child: CircularProgressIndicator(
                                    color: AppColors.primaryColor, strokeWidth: 3),
                              ),
                              const SizedBox(height: 16),
                              Text('Fetching your bill...',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 4),
                              Text(selectedDiscom['name'],
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // ✅ Fetched Bill Card
                      if (_billFetched && fetchedBill != null) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 15,
                                  offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Card Header
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF00695C), Color(0xFF009688)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.receipt_rounded,
                                        color: Colors.white70, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Bill for ${fetchedBill!['billMonth']}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text('Due',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ],
                                ),
                              ),

                              // Bill Details
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    _billRow('Consumer Name', fetchedBill!['consumerName']),
                                    _billRow('Consumer No.', fetchedBill!['consumerNo']),
                                    _billRow('Meter No.', fetchedBill!['meterNo']),
                                    _billRow('Discom', fetchedBill!['discom']),
                                    _billRow('Bill Date', fetchedBill!['billDate']),
                                    _billRow('Due Date', fetchedBill!['dueDate'],
                                        valueColor: const Color(0xFFE53935)),
                                    _billRow('Units Consumed', '${fetchedBill!['units']} kWh'),
                                    const SizedBox(height: 8),
                                    Divider(color: Colors.grey.shade100),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Total Amount',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black87)),
                                        Text('₹${fetchedBill!['billAmount']}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primaryColor)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // ✅ Proceed to Pay Button
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ElectricityPaymentScreen(
                                            billData: fetchedBill!,
                                            discomData: selectedDiscom,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14)),
                                    ),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF00695C), Color(0xFF009688)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.lock_rounded,
                                                color: Colors.white70, size: 16),
                                            SizedBox(width: 8),
                                            Text('Proceed to Pay',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.5)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Recent Payments
                      if (!_isFetching) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Recent Payments',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87)),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => const RechargeHistoryScreen(isB2B: true),
                                ));
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
                            children: recentPayments.asMap().entries.map((entry) {
                              int idx = entry.key;
                              var r = entry.value;
                              return Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    leading: Container(
                                      width: 46, height: 46,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      child: const Icon(Icons.lightbulb_rounded,
                                          color: AppColors.primaryColor, size: 22),
                                    ),
                                    title: Text(r['name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400, fontSize: 14)),
                                    subtitle: Text(
                                        '${r['consumer']} • ${r['discom']}',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey.shade500)),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(r['amount'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color: Colors.black87)),
                                        Text(r['date'],
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey.shade400)),
                                      ],
                                    ),
                                    onTap: () {
                                      _consumerController.text = r['consumer'];
                                      FocusScope.of(context).unfocus(); // Keyboard dismiss
                                      _onConsumerChanged(r['consumer']);
                                    },
                                  ),
                                  if (idx != recentPayments.length - 1)
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
                      ],
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

  Widget _billRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          Text(value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: valueColor ?? Colors.black87)),
        ],
      ),
    );
  }
}