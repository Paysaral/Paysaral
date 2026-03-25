import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'payment_success_screen.dart';

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

  // ================= QUICK AMOUNT ADDER (With Commas & Limit) =================
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

  // ================= CONFIRMATION BOTTOM SHEET (For Fees) =================
  void _showPaymentConfirmation(double baseAmount, double chargePercent) {
    double charges = (baseAmount * chargePercent) / 100;
    double total = baseAmount + charges;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 20),
            const Text('Payment Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 20),
            _rowDetail('Top-up Amount', '₹ ${baseAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            _rowDetail('Convenience Fee ($chargePercent%)', '+ ₹ ${charges.toStringAsFixed(2)}', isRed: true),
            const Divider(height: 32),
            _rowDetail('Total Payable', '₹ ${total.toStringAsFixed(2)}', isBold: true),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close Bottom Sheet
                  _navigateToSuccess(total.toStringAsFixed(2)); // Go to Success
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: const Text('Confirm & Pay', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _rowDetail(String label, String value, {bool isRed = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        Text(value, style: TextStyle(color: isRed ? Colors.red : Colors.black87, fontWeight: isBold ? FontWeight.w900 : FontWeight.bold, fontSize: isBold ? 18 : 14)),
      ],
    );
  }

  // ================= NAVIGATE TO SUCCESS SCREEN =================
  void _navigateToSuccess(String finalAmount) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessScreen(
          amount: finalAmount,
          txnId: 'TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
          date: '25 Mar 2026, 11:30 AM',
          paymentMode: _selectedPaymentMethod.toUpperCase(),
          updatedBalance: '5,000.00',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color topBgColor = AppColors.primaryColor;
    Color accentColor = AppColors.primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: topBgColor,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title: const Text('Add Money', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22), onPressed: () => Navigator.pop(context)),
      ),

      // ================= SAFE BOTTOM NAVIGATION BAR =================
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _amountController.text.isEmpty || _amountController.text == '0'
                      ? null
                      : () {
                    FocusScope.of(context).unfocus();
                    double amt = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;

                    if (_selectedPaymentMethod == 'card') {
                      _showPaymentConfirmation(amt, 2.0); // Card charge 2%
                    } else if (_selectedPaymentMethod == 'netbanking') {
                      _showPaymentConfirmation(amt, 1.5); // NetBanking charge 1.5%
                    } else {
                      _navigateToSuccess(_amountController.text); // UPI is Free
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: topBgColor,
                    disabledBackgroundColor: Colors.grey.shade300,
                    elevation: _amountController.text.isEmpty ? 0 : 4,
                    shadowColor: topBgColor.withOpacity(0.3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    _amountController.text.isEmpty || _amountController.text == '0'
                        ? 'Enter Amount'
                        : 'Proceed to Pay ₹${_amountController.text}',
                    style: TextStyle(
                      color: _amountController.text.isEmpty || _amountController.text == '0' ? Colors.grey.shade600 : Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 13, color: Colors.grey.shade500),
                  const SizedBox(width: 6),
                  Text('Secured by 256-bit encryption', style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
      ),

      body: Column(
        children: [
          // ================= 1. STRUCTURED TEAL HEADER =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
            color: topBgColor,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.wallet, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Wallet Balance', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.3)),
                      const SizedBox(height: 6),
                      const Text('₹ 4,250.00', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ================= 2. MAIN SCROLLABLE BODY =================
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter Amount to Add', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.5)),
                  const SizedBox(height: 16),

                  // ================= NORMAL LEFT-ALIGNED INPUT =================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.015), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Row(
                      children: [
                        Text('₹', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Colors.grey.shade400)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            focusNode: _amountFocusNode,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.start,
                            inputFormatters: [CurrencyInputFormatter()],
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black87, letterSpacing: 0.5),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '0',
                              hintStyle: TextStyle(color: Colors.grey.shade200, fontSize: 28),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 4),
                            ),
                            onChanged: (val) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ================= QUICK AMOUNT CHIPS =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _quickAmountChip('+ ₹500', 500, accentColor),
                      _quickAmountChip('+ ₹1,000', 1000, accentColor),
                      _quickAmountChip('+ ₹2,000', 2000, accentColor),
                      _quickAmountChip('+ ₹5,000', 5000, accentColor),
                    ],
                  ),

                  const SizedBox(height: 35),
                  const Text('Select Payment Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.5)),
                  const SizedBox(height: 16),

                  // ================= PAYMENT METHODS =================
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.015), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      children: [
                        _paymentMethodTile(
                          id: 'upi',
                          title: 'UPI (GPay, PhonePe, Paytm)',
                          subtitle: 'Fastest & Zero Fee',
                          icon: Icons.qr_code_scanner,
                          iconColor: Colors.purple,
                          themeColor: accentColor,
                          isRecommended: true,
                        ),
                        _divider(),
                        _paymentMethodTile(
                          id: 'card',
                          title: 'Credit / Debit Card',
                          subtitle: 'Visa, Mastercard, RuPay',
                          icon: Icons.credit_card,
                          iconColor: Colors.blue,
                          themeColor: accentColor,
                        ),
                        _divider(),
                        _paymentMethodTile(
                          id: 'netbanking',
                          title: 'Net Banking',
                          subtitle: 'All Major Banks Supported',
                          icon: Icons.account_balance,
                          iconColor: Colors.orange,
                          themeColor: accentColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10), // Safe spacing at the bottom of the scroll
                ],
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
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F8F7),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE0F2F1)),
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
    required Color themeColor,
    bool isRecommended = false,
  }) {
    bool isSelected = _selectedPaymentMethod == id;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF1F8F7) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              height: 40, width: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
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
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5, color: Colors.black87),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isRecommended) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.green.shade100)),
                          child: Text('REC', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                        )
                      ]
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22, height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? themeColor : Colors.transparent,
                border: Border.all(color: isSelected ? themeColor : Colors.grey.shade200, width: 2),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
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

    // Limit to 7 digits (99 Lakhs)
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