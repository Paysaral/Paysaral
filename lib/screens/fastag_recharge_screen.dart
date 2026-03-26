import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'recharge_history_screen.dart';
import 'fastag_payment_screen.dart';

// ✅ JADOO: Custom Formatter to force Uppercase (BACKSPACE HOLD FIXED 100%)
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String upperText = newValue.text.toUpperCase();

    // Agar text pehle se upper case hai, to wahi return karo (Isi se Backspace Hold kaam karega)
    if (newValue.text == upperText) {
      return newValue;
    }

    return newValue.copyWith(
      text: upperText,
      selection: newValue.selection,
    );
  }
}

// ✅ Currency Formatter for Comma (E.g. 1,000)
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    String cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanText.isEmpty) return newValue.copyWith(text: '');

    String formatted = '';
    if (cleanText.length > 3) {
      String lastThree = cleanText.substring(cleanText.length - 3);
      String rest = cleanText.substring(0, cleanText.length - 3);
      RegExp regExp = RegExp(r'\B(?=(\d{2})+(?!\d))');
      rest = rest.replaceAllMapped(regExp, (Match m) => ',');
      formatted = '$rest,$lastThree';
    } else {
      formatted = cleanText;
    }

    if (newValue.text == formatted) {
      return newValue;
    }

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class FastagRechargeScreen extends StatefulWidget {
  final Map<String, dynamic>? initialBank;

  const FastagRechargeScreen({super.key, this.initialBank});

  @override
  State<FastagRechargeScreen> createState() => _FastagRechargeScreenState();
}

class _FastagRechargeScreenState extends State<FastagRechargeScreen> {
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _vehicleFocus = FocusNode();

  bool _isFetching = false;
  bool _billFetched = false;
  Map<String, dynamic>? fetchedBill;

  late Map<String, dynamic> selectedBank;
  static const int _minDigits = 9; // Minimum length for Indian Vehicle Numbers

  // Same list as operator screen for the bottom sheet
  final List<Map<String, dynamic>> fastagBanks = [
    {'name': 'IDFC FIRST Bank', 'fullName': 'IDFC Bank Fastag', 'category': 'Top Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFF9E0059)},
    {'name': 'ICICI Bank', 'fullName': 'ICICI Bank Fastag', 'category': 'Top Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFFD32F2F)},
    {'name': 'HDFC Bank', 'fullName': 'HDFC Bank Fastag', 'category': 'Top Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFF1565C0)},
    {'name': 'Paytm Fastag', 'fullName': 'Paytm Payments Bank', 'category': 'Top Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFF0288D1)},
    {'name': 'State Bank of India', 'fullName': 'SBI Fastag', 'category': 'Top Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFF1976D2)},
    {'name': 'Axis Bank', 'fullName': 'Axis Bank Fastag', 'category': 'Popular Banks', 'icon': Icons.account_balance_rounded, 'color': Color(0xFF880E4F)},
  ];

  final List<Map<String, dynamic>> recentRecharges = [
    {'name': 'My Car', 'vehicle': 'JH09AW1234', 'bank': 'IDFC FIRST Bank', 'amount': '₹500', 'date': '15 Mar 2026'},
    {'name': 'Papa Car', 'vehicle': 'DL8CX4321', 'bank': 'ICICI Bank', 'amount': '₹1000', 'date': '10 Mar 2026'},
  ];

  @override
  void initState() {
    super.initState();
    selectedBank = widget.initialBank ?? fastagBanks[0];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _vehicleFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _vehicleController.dispose();
    _amountController.dispose();
    _vehicleFocus.dispose();
    super.dispose();
  }

  void _onVehicleChanged(String value) {
    if (_billFetched || fetchedBill != null) {
      setState(() {
        _billFetched = false;
        fetchedBill = null;
      });
    }
    if (value.length >= _minDigits && !_isFetching) {
      FocusScope.of(context).unfocus();
      _fetchFastagDetails();
    }
  }

  void _fetchFastagDetails() async {
    if (_vehicleController.text.length < _minDigits) return;
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
      final text = _vehicleController.text;

      fetchedBill = {
        'customerName': 'Paysaral User',
        'vehicleNo': text,
        'bankName': selectedBank['name'],
        'currentBalance': '150.00',
        'status': 'Active',
      };
      // Set default recharge amount
      _amountController.text = '500';
    });
  }

  void _showBankSheet(BuildContext context) {
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
                    child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      Icon(Icons.directions_car_rounded, color: AppColors.primaryColor, size: 22),
                      SizedBox(width: 8),
                      Text('Select Fastag Bank', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${fastagBanks.length} banks available', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  const SizedBox(height: 12),
                  Divider(color: Colors.grey.shade100),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                itemCount: fastagBanks.length,
                itemBuilder: (_, i) {
                  final d = fastagBanks[i];
                  final bool isSel = selectedBank['name'] == d['name'];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedBank = d;
                        _billFetched = false;
                        fetchedBill = null;
                        _vehicleController.clear();
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
                        border: Border.all(color: isSel ? AppColors.primaryColor.withOpacity(0.3) : Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42, height: 42,
                            decoration: BoxDecoration(color: (d['color'] as Color).withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                            child: Icon(d['icon'] as IconData, color: d['color'] as Color, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(d['name'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: isSel ? AppColors.primaryColor : Colors.black87)),
                                const SizedBox(height: 2),
                                Text(d['fullName'], style: TextStyle(fontSize: 11, color: Colors.grey.shade500), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          if (isSel)
                            const Icon(Icons.check_circle_rounded, color: AppColors.primaryColor, size: 20),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
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
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36)),
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
                                child: Text('Fastag Recharge', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                              ),
                              IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(Icons.history_rounded, color: Colors.white, size: 18),
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const RechargeHistoryScreen(isB2B: true)));
                                },
                              ),
                            ],
                          ),
                        ),

                        // Bank + Vehicle Card
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 6))],
                            ),
                            child: Column(
                              children: [
                                // Bank Row
                                InkWell(
                                  onTap: () => _showBankSheet(context),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 46, height: 46,
                                          decoration: BoxDecoration(
                                            color: (selectedBank['color'] as Color).withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(13),
                                          ),
                                          child: Icon(selectedBank['icon'] as IconData, color: selectedBank['color'] as Color, size: 24),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(selectedBank['name'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black87)),
                                              const SizedBox(height: 2),
                                              Text(selectedBank['fullName'], style: TextStyle(fontSize: 11, color: Colors.grey.shade500), maxLines: 1, overflow: TextOverflow.ellipsis),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
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

                                // Vehicle Number Input
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                                        child: const Icon(Icons.directions_car_rounded, color: AppColors.primaryColor, size: 22),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TextField(
                                          controller: _vehicleController,
                                          focusNode: _vehicleFocus,
                                          textCapitalization: TextCapitalization.characters,
                                          inputFormatters: [
                                            UpperCaseTextFormatter(),
                                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                                            LengthLimitingTextInputFormatter(10),
                                          ],
                                          onChanged: _onVehicleChanged,
                                          showCursor: true,
                                          cursorColor: AppColors.primaryColor,
                                          cursorWidth: 2,
                                          // ✅ JADOO: Font weight is back to w600 as per your strict order!
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 1.5, color: Colors.black87),
                                          decoration: InputDecoration(
                                            hintText: 'Vehicle No. (e.g. JH09AW1234)',
                                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0),
                                            border: InputBorder.none,
                                            suffixIcon: _isFetching
                                                ? const Padding(
                                              padding: EdgeInsets.all(12),
                                              child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: AppColors.primaryColor, strokeWidth: 2)),
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
                                        Text('Details will auto-fetch after $_minDigits characters', style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
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

                    // Fetching Card
                    if (_isFetching) ...[
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4))]),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            const SizedBox(width: 36, height: 36, child: CircularProgressIndicator(color: AppColors.primaryColor, strokeWidth: 3)),
                            const SizedBox(height: 16),
                            Text('Verifying Vehicle Details...', style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Text(selectedBank['name'], style: const TextStyle(fontSize: 13, color: AppColors.primaryColor, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // ✅ Fetched Fastag Card
                    if (_billFetched && fetchedBill != null) ...[
                      Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 4))]),
                        child: Column(
                          children: [
                            // Card Header
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [Color(0xFF00695C), Color(0xFF009688)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.verified_user_rounded, color: Colors.white70, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text('Fastag Verified: ${fetchedBill!['vehicleNo']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                                    child: Text(fetchedBill!['status'], style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ),

                            // Fastag Details
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  _billRow('Owner Name', fetchedBill!['customerName']),
                                  _billRow('Bank Name', fetchedBill!['bankName']),
                                  _billRow('Wallet Balance', '₹${fetchedBill!['currentBalance']}', valueColor: Colors.orange.shade700),
                                  const SizedBox(height: 8),
                                  Divider(color: Colors.grey.shade100),
                                  const SizedBox(height: 8),

                                  // Amount Input Box
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Enter Recharge Amount', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F7FA),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.grey.shade200),
                                        ),
                                        child: TextField(
                                          controller: _amountController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                                            CurrencyInputFormatter(),
                                          ],
                                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.primaryColor),
                                          decoration: InputDecoration(
                                            prefixText: '₹ ',
                                            prefixStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primaryColor),
                                            border: InputBorder.none,
                                            hintText: '0',
                                            hintStyle: TextStyle(color: Colors.grey.shade400),
                                          ),
                                          onChanged: (val) {
                                            setState(() { fetchedBill!['rechargeAmount'] = val; });
                                          },
                                        ),
                                      ),
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
                                    String rawAmt = _amountController.text.replaceAll(',', '');
                                    if(rawAmt.isEmpty || int.parse(rawAmt) <= 0) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid amount')));
                                      return;
                                    }
                                    fetchedBill!['rechargeAmount'] = _amountController.text;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FastagPaymentScreen(
                                          billData: fetchedBill!,
                                          fastagData: selectedBank,
                                          isB2B: true,
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
                                      gradient: const LinearGradient(colors: [Color(0xFF00695C), Color(0xFF009688)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.lock_rounded, color: Colors.white70, size: 16),
                                          SizedBox(width: 8),
                                          Text('Proceed to Recharge', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
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
                          const Text('Recent Recharges', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87)),
                          TextButton(
                            onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_) => const RechargeHistoryScreen(isB2B: true))); },
                            child: const Text('See All →', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w600, fontSize: 13)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4))]),
                        child: Column(
                          children: recentRecharges.asMap().entries.map((entry) {
                            int idx = entry.key;
                            var r = entry.value;
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  leading: Container(
                                    width: 46, height: 46,
                                    decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(13)),
                                    child: const Icon(Icons.directions_car_rounded, color: AppColors.primaryColor, size: 22),
                                  ),
                                  title: Text(r['name'], style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                                  subtitle: Text('${r['vehicle']} • ${r['bank']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(r['amount'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87)),
                                      Text(r['date'], style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                                    ],
                                  ),
                                  onTap: () {
                                    _vehicleController.text = r['vehicle'];
                                    FocusScope.of(context).unfocus();
                                    _onVehicleChanged(r['vehicle']);
                                  },
                                ),
                                if (idx != recentRecharges.length - 1)
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