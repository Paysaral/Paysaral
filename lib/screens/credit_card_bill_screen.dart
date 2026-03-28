import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'recharge_history_screen.dart';
import 'credit_card_payment_screen.dart';

// ✅ Custom Formatter for Indian Currency (Commas: 15,500)
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

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class CreditCardBillScreen extends StatefulWidget {
  final Map<String, dynamic>? initialBank;

  const CreditCardBillScreen({super.key, this.initialBank});

  @override
  State<CreditCardBillScreen> createState() => _CreditCardBillScreenState();
}

class _CreditCardBillScreenState extends State<CreditCardBillScreen> {
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _cardFocus = FocusNode();

  bool _isFetching = false;
  bool _billFetched = false;
  Map<String, dynamic>? fetchedBill;

  late Map<String, dynamic> selectedBank;

  static const int _targetLength = 4;

  final List<Map<String, dynamic>> ccBanks = [
    {'name': 'HDFC Bank', 'fullName': 'HDFC Credit Card', 'category': 'Top Banks', 'icon': Icons.credit_card_rounded, 'color': const Color(0xFF1565C0)},
    {'name': 'SBI Card', 'fullName': 'SBI Credit Card', 'category': 'Top Banks', 'icon': Icons.credit_card_rounded, 'color': const Color(0xFF1976D2)},
    {'name': 'ICICI Bank', 'fullName': 'ICICI Credit Card', 'category': 'Top Banks', 'icon': Icons.credit_card_rounded, 'color': const Color(0xFFD32F2F)},
    {'name': 'Axis Bank', 'fullName': 'Axis Bank Credit Card', 'category': 'Top Banks', 'icon': Icons.credit_card_rounded, 'color': const Color(0xFF880E4F)},
  ];

  final List<Map<String, dynamic>> recentPayments = [
    {'name': 'My HDFC Card', 'cardNo': '**** 4567', 'bank': 'HDFC Bank', 'amount': '₹12,500', 'date': '05 Mar 2026'},
    {'name': 'Wife SBI Card', 'cardNo': '**** 8901', 'bank': 'SBI Card', 'amount': '₹4,200', 'date': '01 Mar 2026'},
  ];

  @override
  void initState() {
    super.initState();
    selectedBank = widget.initialBank ?? ccBanks[0];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cardFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _cardController.dispose();
    _amountController.dispose();
    _cardFocus.dispose();
    super.dispose();
  }

  void _onCardChanged(String value) {
    if (_billFetched || fetchedBill != null) {
      setState(() {
        _billFetched = false;
        fetchedBill = null;
      });
    }
    // Auto Fetch triggered when 4 digits are entered
    if (value.length >= _targetLength && !_isFetching) {
      // ✅ JADOO: 4 Digit pure hote hi Keyboard automatically neeche gir jayega!
      FocusScope.of(context).unfocus();
      _fetchBillDetails();
    }
  }

  void _fetchBillDetails() async {
    if (_cardController.text.length < _targetLength) return;
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

      final last4 = _cardController.text;

      fetchedBill = {
        'customerName': 'Paysaral User',
        'cardNo': '**** **** **** $last4',
        'bankName': selectedBank['name'],
        'totalDue': '15,500',
        'minDue': '750',
        'dueDate': '18 Apr 2026',
      };
      // Set default payment amount to total due (with comma)
      _amountController.text = '15,500';
    });
  }

  void _showBankSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75, minChildSize: 0.5, maxChildSize: 0.95, expand: false,
        builder: (_, scrollCtrl) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      Icon(Icons.credit_card_rounded, color: AppColors.primaryColor, size: 22),
                      SizedBox(width: 8),
                      Text('Select Credit Card Bank', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Popular banks available', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  const SizedBox(height: 12),
                  Divider(color: Colors.grey.shade100),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                itemCount: ccBanks.length,
                itemBuilder: (_, i) {
                  final d = ccBanks[i];
                  final bool isSel = selectedBank['name'] == d['name'];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedBank = d;
                        _billFetched = false;
                        fetchedBill = null;
                        _cardController.clear(); // Reset input when bank changes
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
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36)),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Expanded(
                              child: Text('Credit Card Bill', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
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

                      // Bank + Card Input Card
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

                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                                      child: const Icon(Icons.credit_card_rounded, color: AppColors.primaryColor, size: 22),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextField(
                                        controller: _cardController,
                                        focusNode: _cardFocus,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(4),
                                        ],
                                        onChanged: _onCardChanged,
                                        showCursor: true,
                                        cursorColor: AppColors.primaryColor,
                                        cursorWidth: 2,
                                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: 2.0, color: Colors.black87),
                                        decoration: InputDecoration(
                                          prefixText: '**** **** **** ',
                                          prefixStyle: TextStyle(color: Colors.grey.shade500, fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: 2.0),
                                          hintText: '1234',
                                          hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 2.0),
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
                                      Text('Enter last 4 digits of your credit card', style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
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
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4))]),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              const SizedBox(width: 36, height: 36, child: CircularProgressIndicator(color: AppColors.primaryColor, strokeWidth: 3)),
                              const SizedBox(height: 16),
                              Text('Fetching Bill Details...', style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 4),
                              Text(selectedBank['name'], style: const TextStyle(fontSize: 13, color: AppColors.primaryColor, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // ✅ Fetched Bill Card
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
                                    const Icon(Icons.credit_score_rounded, color: Colors.white70, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text('Card Verified: ${fetchedBill!['cardNo']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                                    ),
                                  ],
                                ),
                              ),

                              // Bill Details
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    _billRow('Card Holder', fetchedBill!['customerName']),
                                    _billRow('Total Due', '₹${fetchedBill!['totalDue']}', valueColor: Colors.black87),
                                    _billRow('Minimum Due', '₹${fetchedBill!['minDue']}', valueColor: Colors.orange.shade700),
                                    _billRow('Due Date', fetchedBill!['dueDate'], valueColor: const Color(0xFFE53935)),
                                    const SizedBox(height: 8),
                                    Divider(color: Colors.grey.shade100),
                                    const SizedBox(height: 8),

                                    // Custom Amount Input Box
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Enter Amount to Pay', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
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
                                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primaryColor),
                                            decoration: const InputDecoration(
                                              prefixText: '₹ ',
                                              prefixStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primaryColor),
                                              border: InputBorder.none,
                                              hintText: '0',
                                            ),
                                            onChanged: (val) {
                                              setState(() { fetchedBill!['payAmount'] = val; });
                                            },
                                          ),
                                        ),
                                        // Quick chips
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            _quickAmountChip('Total Due', fetchedBill!['totalDue']),
                                            const SizedBox(width: 8),
                                            _quickAmountChip('Min Due', fetchedBill!['minDue']),
                                          ],
                                        )
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
                                      String rawAmt = _amountController.text.replaceAll(',', '');
                                      if(rawAmt.isEmpty || int.parse(rawAmt) <= 0) return;

                                      fetchedBill!['payAmount'] = _amountController.text;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CreditCardPaymentScreen(
                                            billData: fetchedBill!,
                                            bankData: selectedBank,
                                            isB2B: true,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    ),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [Color(0xFF00695C), Color(0xFF009688)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: const Text('Proceed to Pay', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
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

                      // ✅ Recent Bills
                      if (!_isFetching && !_billFetched) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Recent Bills', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87)),
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
                            children: recentPayments.asMap().entries.map((entry) {
                              int idx = entry.key;
                              var r = entry.value;
                              return Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    leading: Container(
                                      width: 46, height: 46,
                                      decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(13)),
                                      child: const Icon(Icons.credit_card_rounded, color: AppColors.primaryColor, size: 22),
                                    ),
                                    title: Text(r['name'], style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                                    subtitle: Text('${r['cardNo']} • ${r['bank']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(r['amount'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87)),
                                        Text(r['date'], style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                                      ],
                                    ),
                                    // ✅ JADOO: Recent Bill par tap karte hi autofill aur keyboard dismiss hoga
                                    onTap: () {
                                      // Extract digits using regex (just in case)
                                      String digits = r['cardNo'].toString().replaceAll(RegExp(r'[^0-9]'), '');

                                      // Match bank
                                      var bank;
                                      try {
                                        bank = ccBanks.firstWhere((b) => b['name'] == r['bank']);
                                      } catch(e) {
                                        bank = ccBanks[0];
                                      }

                                      setState(() {
                                        selectedBank = bank;
                                        _cardController.text = digits;
                                      });

                                      // Trigger fetch manually since onChanged won't catch programmatic change
                                      FocusScope.of(context).unfocus();
                                      _fetchBillDetails();
                                    },
                                  ),
                                  if (idx != recentPayments.length - 1)
                                    Divider(height: 1, color: Colors.grey.shade100, indent: 74, endIndent: 16),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),
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
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor ?? Colors.black87)),
        ],
      ),
    );
  }

  Widget _quickAmountChip(String label, String amount) {
    return InkWell(
      onTap: () {
        setState(() {
          _amountController.text = amount;
          fetchedBill!['payAmount'] = amount;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
        ),
        child: Text('$label (₹$amount)', style: const TextStyle(color: AppColors.primaryColor, fontSize: 11, fontWeight: FontWeight.w600)),
      ),
    );
  }
}