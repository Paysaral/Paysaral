import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'payment_success_screen.dart'; // ✅ JADOO: Success Screen Import kar li!

class AddMoneyScreen extends StatefulWidget {
  final bool isB2B;

  const AddMoneyScreen({
    super.key,
    this.isB2B = false,
  });

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  String _selectedPaymentMethod = 'upi';

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) FocusScope.of(context).requestFocus(_amountFocusNode);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _addQuickAmount(int amount) {
    setState(() {
      String cleanText = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
      int currentAmount = int.tryParse(cleanText) ?? 0;
      int newAmount = currentAmount + amount;

      if (newAmount > 9999999) newAmount = 9999999;

      String s = newAmount.toString();
      String formatted = '';
      int length = s.length;
      for (int i = length - 1, j = 0; i >= 0; i--, j++) {
        if (j == 3 || (j > 3 && (j - 3) % 2 == 0)) {
          formatted = ',$formatted';
        }
        formatted = s[i] + formatted;
      }

      _amountController.text = formatted;
      _amountController.selection = TextSelection.fromPosition(TextPosition(offset: _amountController.text.length));
    });
  }

  @override
  Widget build(BuildContext context) {
    Color topBgColor = AppColors.primaryColor;
    Color accentBtnColor = AppColors.primaryColor;
    Color accentTextColor = Colors.white;

    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: topBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Add Money to Wallet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          // ================= CURRENT BALANCE SECTION =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Balance', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    const Text('₹ 4,250.00', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 28),
                )
              ],
            ),
          ),

          // ================= WHITE SHEET (MAIN CONTENT) =================
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: isKeyboardOpen ? const ClampingScrollPhysics() : const NeverScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Enter Amount', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                              const SizedBox(height: 16),

                              // ================= AMOUNT INPUT FIELD =================
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Text('₹', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: Colors.grey.shade500)),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextField(
                                        controller: _amountController,
                                        focusNode: _amountFocusNode,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [CurrencyInputFormatter()],
                                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black87),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '0',
                                          hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 28),
                                        ),
                                        onChanged: (val) => setState(() {}),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // ================= QUICK AMOUNT CHIPS =================
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _quickAmountChip('+ ₹500', 500, topBgColor),
                                  _quickAmountChip('+ ₹1,000', 1000, topBgColor),
                                  _quickAmountChip('+ ₹2,000', 2000, topBgColor),
                                  _quickAmountChip('+ ₹5,000', 5000, topBgColor),
                                ],
                              ),

                              const SizedBox(height: 35),
                              const Text('Select Payment Method', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                              const SizedBox(height: 16),

                              // ================= PAYMENT METHODS =================
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Column(
                                  children: [
                                    _paymentMethodTile(
                                      id: 'upi',
                                      title: 'UPI (GPay, PhonePe, Paytm)',
                                      subtitle: 'Zero processing fee',
                                      icon: Icons.qr_code_scanner,
                                      iconColor: Colors.purple,
                                      isRecommended: true,
                                    ),
                                    _divider(),
                                    _paymentMethodTile(
                                      id: 'card',
                                      title: 'Credit / Debit Card',
                                      subtitle: 'Visa, Mastercard, RuPay',
                                      icon: Icons.credit_card,
                                      iconColor: Colors.blue,
                                    ),
                                    _divider(),
                                    _paymentMethodTile(
                                      id: 'netbanking',
                                      title: 'Net Banking',
                                      subtitle: 'All Indian banks supported',
                                      icon: Icons.account_balance,
                                      iconColor: Colors.orange,
                                    ),
                                  ],
                                ),
                              ),

                              const Spacer(),
                              const SizedBox(height: 20),

                              // ================= PROCEED BUTTON =================
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: _amountController.text.isEmpty || _amountController.text == '0'
                                      ? null
                                      : () {
                                    FocusScope.of(context).unfocus();

                                    // ✅ JADOO: Direct navigation to Payment Success Screen
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentSuccessScreen(
                                          amount: _amountController.text,
                                          txnId: 'TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
                                          date: '25 Mar 2026, 11:30 AM',
                                          paymentMode: _selectedPaymentMethod.toUpperCase(),
                                          updatedBalance: '4,750.00', // Dummy updated balance
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: accentBtnColor,
                                    disabledBackgroundColor: Colors.grey.shade300,
                                    elevation: _amountController.text.isEmpty ? 0 : 5,
                                    shadowColor: accentBtnColor.withOpacity(0.5),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  child: Text(
                                    _amountController.text.isEmpty || _amountController.text == '0'
                                        ? 'Enter Amount to Proceed'
                                        : 'Proceed to Pay ₹${_amountController.text}',
                                    style: TextStyle(
                                      color: _amountController.text.isEmpty || _amountController.text == '0' ? Colors.grey.shade600 : accentTextColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.security, size: 14, color: Colors.grey.shade500),
                                  const SizedBox(width: 6),
                                  Text('100% Safe & Secure Payments', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500)),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _quickAmountChip(String label, int amount, Color themeColor) {
    return InkWell(
      onTap: () => _addQuickAmount(amount),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: themeColor.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: themeColor.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Text(
          label,
          style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    );
  }

  Widget _paymentMethodTile({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    bool isRecommended = false,
  }) {
    bool isSelected = _selectedPaymentMethod == id;
    Color themeColor = AppColors.primaryColor;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? themeColor.withOpacity(0.03) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isRecommended) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.green.shade200)),
                          child: Text('RECOMMENDED', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                        )
                      ]
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 22, height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? themeColor : Colors.grey.shade300, width: isSelected ? 6 : 2),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey.shade100, indent: 64, endIndent: 20);
  }
}

// ================= THE MAGIC FORMATTER =================
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    String cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanText.length > 7) {
      cleanText = cleanText.substring(0, 7);
    }

    String formatted = '';
    int length = cleanText.length;
    for (int i = length - 1, j = 0; i >= 0; i--, j++) {
      if (j == 3 || (j > 3 && (j - 3) % 2 == 0)) {
        formatted = ',$formatted';
      }
      formatted = cleanText[i] + formatted;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}