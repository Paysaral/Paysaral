import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'recharge_history_screen.dart';
import 'gas_payment_screen.dart'; // ✅ Asli Payment screen jo abhi banayi thi

class GasBillScreen extends StatefulWidget {
  final Map<String, dynamic>? initialOperator;

  const GasBillScreen({
    super.key,
    this.initialOperator,
  });

  @override
  State<GasBillScreen> createState() => _GasBillScreenState();
}

class _GasBillScreenState extends State<GasBillScreen> {
  final TextEditingController _consumerController = TextEditingController();
  final FocusNode _consumerFocus = FocusNode();

  bool _isFetching = false;
  bool _billFetched = false;
  Map<String, dynamic>? fetchedBill;

  late Map<String, dynamic> selectedOperator;
  static const int _minDigits = 10;

  // ✅ Gas Operators List (LPG and PNG pipelines)
  final List<Map<String, dynamic>> gasOperators = [
    {'name': 'Indane Gas (IOCL)', 'fullName': 'Indian Oil Corporation Ltd.', 'type': 'LPG Cylinder', 'icon': Icons.local_fire_department_rounded, 'color': Color(0xFFF57C00)},
    {'name': 'Bharat Gas (BPCL)', 'fullName': 'Bharat Petroleum', 'type': 'LPG Cylinder', 'icon': Icons.local_fire_department_rounded, 'color': Color(0xFF1976D2)},
    {'name': 'HP Gas (HPCL)', 'fullName': 'Hindustan Petroleum', 'type': 'LPG Cylinder', 'icon': Icons.local_fire_department_rounded, 'color': Color(0xFFD32F2F)},
    {'name': 'Adani Total Gas', 'fullName': 'Adani Gas Pipeline', 'type': 'PNG Pipeline', 'icon': Icons.gas_meter_rounded, 'color': Color(0xFF388E3C)},
    {'name': 'IGL (Indraprastha)', 'fullName': 'Indraprastha Gas Limited Delhi', 'type': 'PNG Pipeline', 'icon': Icons.gas_meter_rounded, 'color': Color(0xFF0288D1)},
    {'name': 'MGL (Mahanagar)', 'fullName': 'Mahanagar Gas Mumbai', 'type': 'PNG Pipeline', 'icon': Icons.gas_meter_rounded, 'color': Color(0xFFFBC02D)},
    {'name': 'Gujarat Gas', 'fullName': 'Gujarat Gas Limited', 'type': 'PNG Pipeline', 'icon': Icons.gas_meter_rounded, 'color': Color(0xFF00796B)},
    {'name': 'Haryana City Gas', 'fullName': 'Haryana City Gas', 'type': 'PNG Pipeline', 'icon': Icons.gas_meter_rounded, 'color': Color(0xFF558B2F)},
  ];

  final List<Map<String, dynamic>> recentBookings = [
    {'name': 'Home Kitchen', 'consumer': '1700012345', 'operator': 'Indane Gas', 'amount': '₹1,103', 'date': '20 Feb 2026'},
    {'name': 'Mom (Delhi)', 'consumer': 'IGL9876543', 'operator': 'IGL', 'amount': '₹450', 'date': '15 Feb 2026'},
  ];

  // ✅ Grouping logic based on LPG vs PNG
  Map<String, List<Map<String, dynamic>>> get _groupedOperators {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var op in gasOperators) {
      final type = op['type'] as String;
      grouped[type] ??= [];
      grouped[type]!.add(op);
    }
    return grouped;
  }

  @override
  void initState() {
    super.initState();
    selectedOperator = widget.initialOperator ?? {
      'name': 'Indane Gas (IOCL)',
      'fullName': 'Indian Oil Corporation Ltd.',
      'type': 'LPG Cylinder',
      'icon': Icons.local_fire_department_rounded,
      'color': const Color(0xFFF57C00),
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
    // Auto Fetch when min digits reached
    if (value.length >= _minDigits && !_isFetching) {
      // ✅ JADOO: 10 Digits pure hote hi keyboard automatically neeche gir jayega!
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

    // Simulate API Delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      _isFetching = false;
      _billFetched = true;
      final text = _consumerController.text;

      // Dummy Response (Later replace with PHP Middleware response)
      fetchedBill = {
        'consumerName': 'Paysaral Gas User',
        'consumerNo': text,
        'operator': selectedOperator['name'],
        'billDate': '26 Mar 2026',
        'dueDate': 'Current Cycle',
        'billAmount': selectedOperator['type'] == 'LPG Cylinder' ? '1,103.00' : '540.00',
        'units': selectedOperator['type'] == 'LPG Cylinder' ? '14.2 Kg Cylinder' : 'PNG Pipeline',
        'billMonth': 'March 2026',
      };
    });
  }

  void _showOperatorSheet(BuildContext context) {
    final grouped = _groupedOperators;
    final types = grouped.keys.toList();

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
                      Icon(Icons.gas_meter_rounded, color: AppColors.primaryColor, size: 22),
                      SizedBox(width: 8),
                      Text('Select Gas Provider',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${gasOperators.length} operators available',
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
                itemCount: types.length,
                itemBuilder: (_, ti) {
                  final type = types[ti];
                  final ops = grouped[type]!;
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
                          child: Text(type, // Prints "LPG Cylinder" or "PNG Pipeline"
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryColor)),
                        ),
                      ),
                      ...ops.map((d) {
                        final bool isSel = selectedOperator['name'] == d['name'];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedOperator = d;
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
                              color: isSel ? AppColors.primaryColor.withOpacity(0.06) : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSel ? AppColors.primaryColor.withOpacity(0.3) : Colors.grey.shade200,
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
                                  child: Icon(d['icon'] as IconData, color: d['color'] as Color, size: 22),
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
                                              color: isSel ? AppColors.primaryColor : Colors.black87)),
                                      const SizedBox(height: 2),
                                      Text(d['fullName'],
                                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                          maxLines: 1, overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                                if (isSel)
                                  const Icon(Icons.check_circle_rounded, color: AppColors.primaryColor, size: 20),
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
          body: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [

              // ══ HEADER ════════════════════════════
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

                        // AppBar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const Expanded(
                                child: Text('Book Cylinder / Gas Bill',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                              ),
                              IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.history_rounded, color: Colors.white, size: 18),
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

                        // Operator + Consumer Card
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 6)),
                              ],
                            ),
                            child: Column(
                              children: [

                                // Operator Row
                                InkWell(
                                  onTap: () => _showOperatorSheet(context),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 46, height: 46,
                                          decoration: BoxDecoration(
                                            color: (selectedOperator['color'] as Color).withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(13),
                                          ),
                                          child: Icon(
                                            selectedOperator['icon'] as IconData,
                                            color: selectedOperator['color'] as Color,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(selectedOperator['name'],
                                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black87)),
                                              const SizedBox(height: 2),
                                              Text(selectedOperator['type'], // LPG or PNG
                                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor.withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Row(
                                            children: [
                                              Text('Change', style: TextStyle(color: AppColors.primaryColor, fontSize: 12, fontWeight: FontWeight.w600)),
                                              SizedBox(width: 4),
                                              Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryColor, size: 16),
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
                                        child: const Icon(Icons.badge_outlined, color: AppColors.primaryColor, size: 22),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TextField(
                                          controller: _consumerController,
                                          focusNode: _consumerFocus,
                                          keyboardType: TextInputType.text, // Alphanumeric for gas
                                          onChanged: _onConsumerChanged,
                                          showCursor: true,
                                          cursorColor: AppColors.primaryColor,
                                          cursorWidth: 2,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 1, color: Colors.black87),
                                          decoration: InputDecoration(
                                            hintText: 'Enter Consumer / Reg. M.No',
                                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0),
                                            border: InputBorder.none,
                                            suffixIcon: _isFetching
                                                ? const Padding(
                                              padding: EdgeInsets.all(12),
                                              child: SizedBox(
                                                width: 18, height: 18,
                                                child: CircularProgressIndicator(color: AppColors.primaryColor, strokeWidth: 2),
                                              ),
                                            )
                                                : _billFetched
                                                ? const Icon(Icons.check_circle_rounded, color: Colors.green, size: 22)
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
                                        Icon(Icons.info_outline_rounded, size: 13, color: Colors.grey.shade400),
                                        const SizedBox(width: 6),
                                        Text('Booking details will auto-fetch', style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
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
              ),

              // ══ BODY ═════════════════════════════════
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([

                    // Fetching Loader Card
                    if (_isFetching) ...[
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4))],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            const SizedBox(
                              width: 36, height: 36,
                              child: CircularProgressIndicator(color: AppColors.primaryColor, strokeWidth: 3),
                            ),
                            const SizedBox(height: 16),
                            Text('Fetching details from ${selectedOperator['name']}...',
                                style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
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
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 4))],
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
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.receipt_rounded, color: Colors.white70, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Booking details for ${fetchedBill!['consumerName']}',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
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
                                  _billRow('Operator', fetchedBill!['operator']),
                                  _billRow('Type', fetchedBill!['units']),
                                  _billRow('Due Date', fetchedBill!['dueDate'], valueColor: const Color(0xFFE53935)),
                                  const SizedBox(height: 8),
                                  Divider(color: Colors.grey.shade100),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Payable Amount', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87)),
                                      Text('₹${fetchedBill!['billAmount']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primaryColor)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // ✅ Proceed to Pay Button -> Navigates to GasPaymentScreen
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
                                        builder: (_) => GasPaymentScreen(
                                          billData: fetchedBill!,
                                          gasData: selectedOperator,
                                          isB2B: true, // Replace with logic
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                                          Icon(Icons.lock_rounded, color: Colors.white70, size: 16),
                                          SizedBox(width: 8),
                                          Text('Proceed to Pay', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
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

                    // Recent Bookings
                    if (!_isFetching) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Recent Bookings', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87)),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (_) => const RechargeHistoryScreen(isB2B: true),
                              ));
                            },
                            child: const Text('See All →', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w600, fontSize: 13)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4))],
                        ),
                        child: Column(
                          children: recentBookings.asMap().entries.map((entry) {
                            int idx = entry.key;
                            var r = entry.value;
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  leading: Container(
                                    width: 46, height: 46,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: const Icon(Icons.gas_meter_rounded, color: AppColors.primaryColor, size: 22),
                                  ),
                                  title: Text(r['name'], style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                                  subtitle: Text('${r['consumer']} • ${r['operator']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(r['amount'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87)),
                                      Text(r['date'], style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                                    ],
                                  ),
                                  // ✅ JADOO: Recent booking par click karne se bhi keyboard hat jayega
                                  onTap: () {
                                    _consumerController.text = r['consumer'];
                                    FocusScope.of(context).unfocus();
                                    _onConsumerChanged(r['consumer']);
                                  },
                                ),
                                if (idx != recentBookings.length - 1)
                                  Divider(height: 1, color: Colors.grey.shade100, indent: 74, endIndent: 16),
                              ],
                            );
                          }).toList(),
                        ),
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

  Widget _billRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: valueColor ?? Colors.black87)),
        ],
      ),
    );
  }
}