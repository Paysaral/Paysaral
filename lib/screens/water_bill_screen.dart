import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'recharge_history_screen.dart';
import 'water_payment_screen.dart';

class WaterBillScreen extends StatefulWidget {
  final Map<String, dynamic>? initialBoard;

  const WaterBillScreen({
    super.key,
    this.initialBoard,
  });

  @override
  State<WaterBillScreen> createState() => _WaterBillScreenState();
}

class _WaterBillScreenState extends State<WaterBillScreen> {
  final TextEditingController _consumerController = TextEditingController();
  final FocusNode _consumerFocus = FocusNode();

  bool _isFetching = false;
  bool _billFetched = false;
  Map<String, dynamic>? fetchedBill;

  late Map<String, dynamic> selectedBoard;
  static const int _minDigits = 8;

  final List<Map<String, dynamic>> waterBoards = [
    {'name': 'JUSNL', 'fullName': 'Jharkhand Urban Services Nigam Ltd', 'state': 'Jharkhand', 'icon': Icons.water_drop_rounded, 'color': Color(0xFF0288D1)},
    {'name': 'BUIDCO', 'fullName': 'Bihar Urban Infrastructure Dev Corp', 'state': 'Bihar', 'icon': Icons.water_rounded, 'color': Color(0xFF1565C0)},
    {'name': 'PHED Bihar', 'fullName': 'Public Health Engg Dept - Bihar', 'state': 'Bihar', 'icon': Icons.water_drop_rounded, 'color': Color(0xFF0277BD)},
    {'name': 'Delhi Jal Board', 'fullName': 'Delhi Jal Board', 'state': 'Delhi', 'icon': Icons.water_drop_rounded, 'color': Color(0xFF01579B)},
    {'name': 'MCGM', 'fullName': 'Municipal Corp of Greater Mumbai', 'state': 'Maharashtra', 'icon': Icons.water_rounded, 'color': Color(0xFF1565C0)},
    {'name': 'PCMC', 'fullName': 'Pimpri Chinchwad Municipal Corp', 'state': 'Maharashtra', 'icon': Icons.water_drop_rounded, 'color': Color(0xFF0288D1)},
    {'name': 'BWSSB', 'fullName': 'Bangalore Water Supply & Sewerage Board', 'state': 'Karnataka', 'icon': Icons.water_drop_rounded, 'color': Color(0xFF00695C)},
    {'name': 'HMWSSB', 'fullName': 'Hyderabad Metro Water Supply Board', 'state': 'Telangana', 'icon': Icons.water_rounded, 'color': Color(0xFF00838F)},
    {'name': 'CMWSSB', 'fullName': 'Chennai Metro Water Supply & Sewerage', 'state': 'Tamil Nadu', 'icon': Icons.water_drop_rounded, 'color': Color(0xFF006064)},
    {'name': 'KUWS&DB', 'fullName': 'Karnataka Urban Water Supply & Drainage', 'state': 'Karnataka', 'icon': Icons.water_drop_rounded, 'color': Color(0xFF00796B)},
    {'name': 'GWSSB', 'fullName': 'Gujarat Water Supply & Sewerage Board', 'state': 'Gujarat', 'icon': Icons.water_rounded, 'color': Color(0xFF0277BD)},
    {'name': 'PHED Rajasthan', 'fullName': 'Public Health Engg Dept - Rajasthan', 'state': 'Rajasthan', 'icon': Icons.water_drop_rounded, 'color': Color(0xFF1976D2)},
    {'name': 'UPJN', 'fullName': 'Uttar Pradesh Jal Nigam', 'state': 'Uttar Pradesh', 'icon': Icons.water_drop_rounded, 'color': Color(0xFF283593)},
    {'name': 'LWMC Lucknow', 'fullName': 'Lucknow Water Management Corp', 'state': 'Uttar Pradesh', 'icon': Icons.water_rounded, 'color': Color(0xFF303F9F)},
    {'name': 'PHED MP', 'fullName': 'Public Health Engg Dept - MP', 'state': 'Madhya Pradesh', 'icon': Icons.water_drop_rounded, 'color': Color(0xFF1565C0)},
    {'name': 'KMC Water', 'fullName': 'Kolkata Municipal Corp - Water', 'state': 'West Bengal', 'icon': Icons.water_drop_rounded, 'color': Color(0xFF0288D1)},
    {'name': 'PHED Punjab', 'fullName': 'Public Health Engg Dept - Punjab', 'state': 'Punjab', 'icon': Icons.water_rounded, 'color': Color(0xFF01579B)},
    {'name': 'PHED Haryana', 'fullName': 'Public Health Engg Dept - Haryana', 'state': 'Haryana', 'icon': Icons.water_drop_rounded, 'color': Color(0xFF0277BD)},
  ];

  final List<Map<String, dynamic>> recentPayments = [
    {'name': 'Home', 'consumer': 'WB12345678', 'board': 'JUSNL', 'amount': '₹450', 'date': '12 Mar 2026'},
    {'name': 'Office', 'consumer': 'WB98765432', 'board': 'BUIDCO', 'amount': '₹1,200', 'date': '08 Mar 2026'},
  ];

  Map<String, List<Map<String, dynamic>>> get _groupedBoards {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var b in waterBoards) {
      final state = b['state'] as String;
      grouped[state] ??= [];
      grouped[state]!.add(b);
    }
    return grouped;
  }

  @override
  void initState() {
    super.initState();
    selectedBoard = widget.initialBoard ?? {
      'name': 'JUSNL',
      'fullName': 'Jharkhand Urban Services Nigam Ltd',
      'state': 'Jharkhand',
      'icon': Icons.water_drop_rounded,
      'color': Color(0xFF0288D1),
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
      // ✅ Yahan se Unfocus HATA DIYA HAI. Ab typing disturb nahi hogi.
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

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // ✅ JADOO: Bill fetch hone ke BAAD keyboard neeche girega.
    FocusScope.of(context).unfocus();

    setState(() {
      _isFetching = false;
      _billFetched = true;
      final text = _consumerController.text;
      fetchedBill = {
        'consumerName': 'Suresh Prasad',
        'consumerNo': text,
        'board': selectedBoard['name'],
        'billDate': '01 Mar 2026',
        'dueDate': '25 Mar 2026',
        'billAmount': '620.00',
        'usage': '18',
        'billMonth': 'February 2026',
        'connectionNo': 'CN${text.substring(0, text.length >= 4 ? 4 : text.length)}XXX',
      };
    });
  }

  void _showBoardSheet(BuildContext context) {
    final grouped = _groupedBoards;
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
                      Icon(Icons.water_drop_rounded,
                          color: AppColors.primaryColor, size: 22),
                      SizedBox(width: 8),
                      Text('Select Water Board',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${waterBoards.length} boards available',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500)),
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
                  final stateBoards = grouped[state]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
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
                      ...stateBoards.map((b) {
                        final bool isSel = selectedBoard['name'] == b['name'];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedBoard = b;
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
                                    color: (b['color'] as Color).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(b['icon'] as IconData,
                                      color: b['color'] as Color, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(b['name'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: isSel
                                                  ? AppColors.primaryColor
                                                  : Colors.black87)),
                                      const SizedBox(height: 2),
                                      Text(b['fullName'],
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
          body: CustomScrollView(
            slivers: [

              // ══ HEADER ════════════════════════════════
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
                                child: Text('Water Bill',
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
                                    builder: (_) => const RechargeHistoryScreen(
                                        isB2B: true),
                                  ));
                                },
                              ),
                            ],
                          ),
                        ),

                        // Board + Consumer Card
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

                                // Board Row
                                InkWell(
                                  onTap: () => _showBoardSheet(context),
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 46, height: 46,
                                          decoration: BoxDecoration(
                                            color: (selectedBoard['color'] as Color)
                                                .withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(13),
                                          ),
                                          child: Icon(
                                            selectedBoard['icon'] as IconData,
                                            color: selectedBoard['color'] as Color,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(selectedBoard['name'],
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 15,
                                                      color: Colors.black87)),
                                              const SizedBox(height: 2),
                                              Text(selectedBoard['fullName'],
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
                                            color: AppColors.primaryColor
                                                .withOpacity(0.08),
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
                                              Icon(
                                                  Icons.keyboard_arrow_down_rounded,
                                                  color: AppColors.primaryColor,
                                                  size: 16),
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
                                          color: AppColors.primaryColor
                                              .withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                            Icons.water_drop_rounded,
                                            color: AppColors.primaryColor,
                                            size: 22),
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
                                                ? const Icon(
                                                Icons.check_circle_rounded,
                                                color: Colors.green,
                                                size: 22)
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                if (!_isFetching && !_billFetched)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                                    child: Row(
                                      children: [
                                        Icon(Icons.info_outline_rounded,
                                            size: 13,
                                            color: Colors.grey.shade400),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Bill will auto-fetch after $_minDigits digits',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade400),
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
              ),

              // ══ BODY ══════════════════════════════════
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([

                    // Fetching Card
                    if (_isFetching) ...[
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
                            Text(selectedBoard['name'],
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
                                  _billRow('Connection No.', fetchedBill!['connectionNo']),
                                  _billRow('Water Board', fetchedBill!['board']),
                                  _billRow('Bill Date', fetchedBill!['billDate']),
                                  _billRow('Due Date', fetchedBill!['dueDate'],
                                      valueColor: const Color(0xFFE53935)),
                                  _billRow('Water Usage',
                                      '${fetchedBill!['usage']} KL'),
                                  const SizedBox(height: 8),
                                  Divider(color: Colors.grey.shade100),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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

                            // Proceed to Pay Button
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
                                        builder: (_) => WaterPaymentScreen(
                                          billData: fetchedBill!,
                                          boardData: selectedBoard,
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
                                        colors: [
                                          Color(0xFF00695C),
                                          Color(0xFF009688)
                                        ],
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
                                builder: (_) => const RechargeHistoryScreen(
                                    isB2B: true),
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
                                    child: const Icon(Icons.water_drop_rounded,
                                        color: AppColors.primaryColor, size: 22),
                                  ),
                                  title: Text(r['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  subtitle: Text(
                                      '${r['consumer']} • ${r['board']}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500)),
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
                                  // ✅ JADOO: Recent par click karne se bhi keyboard hat jayega
                                  onTap: () {
                                    _consumerController.text = r['consumer'];
                                    FocusScope.of(context).unfocus();
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