import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class CreditCardPaymentScreen extends StatefulWidget {
  final Map<String, dynamic> billData;
  final Map<String, dynamic> bankData;
  final bool isB2B; // ✅ Required

  const CreditCardPaymentScreen({
    super.key,
    required this.billData,
    required this.bankData,
    required this.isB2B,
  });

  @override
  State<CreditCardPaymentScreen> createState() => _CreditCardPaymentScreenState();
}

class _CreditCardPaymentScreenState extends State<CreditCardPaymentScreen> {
  bool _isPaying = false;
  final double _walletBalance = 25000.00;

  double get _payAmount {
    final raw = widget.billData['payAmount'].toString().replaceAll(',', '');
    return double.tryParse(raw) ?? 0.0;
  }

  bool get _hasSufficientBalance => _walletBalance >= _payAmount;

  List<Color> get _themeGradient {
    return widget.isB2B
        ? [const Color(0xFF00695C), const Color(0xFF009688)]
        : [const Color(0xFF1E3C72), const Color(0xFF2A5298)];
  }

  Color get _primaryThemeColor {
    return widget.isB2B ? const Color(0xFF00695C) : const Color(0xFF1E3C72);
  }

  void _confirmPayment() async {
    setState(() => _isPaying = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isPaying = false);
    _showSuccessSheet();
  }

  void _showSuccessSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24, 28, 24, MediaQuery.of(context).viewInsets.bottom + 40),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                child: Icon(Icons.check_circle_rounded, color: Colors.green.shade500, size: 48),
              ),
              const SizedBox(height: 16),

              const Text('Bill Payment Successful!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black87)),
              const SizedBox(height: 6),
              Text(
                '₹${widget.billData['payAmount']} paid towards ${widget.bankData['name']}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(14)),
                child: Column(
                  children: [
                    _receiptRow('Card No.', widget.billData['cardNo']),
                    _receiptRow('Bank Name', widget.bankData['name']),
                    _receiptRow('Amount Paid', '₹${widget.billData['payAmount']}'),
                    _receiptRow('Date & Time', '27 Mar 2026, 11:30 AM'),
                    _receiptRow('Txn ID', 'CCB${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}'),

                    if (!widget.isB2B)
                      _receiptRow('Cashback Earned', '+₹25.00', valueColor: Colors.orange.shade700),

                    _receiptRow('Status', 'Success', valueColor: Colors.green),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)..pop()..pop()..pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: _themeGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text('Done', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: _themeGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    children: [
                      IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20), onPressed: () => Navigator.pop(context)),
                      const Expanded(child: Text('Payment Summary', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52, height: 52,
                            decoration: BoxDecoration(color: (widget.bankData['color'] as Color).withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
                            child: Icon(widget.bankData['icon'] as IconData, color: widget.bankData['color'] as Color, size: 26),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.bankData['name'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87)),
                                const SizedBox(height: 3),
                                Text(widget.bankData['fullName'], style: TextStyle(fontSize: 12, color: Colors.grey.shade500), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                            decoration: BoxDecoration(color: _primaryThemeColor.withOpacity(0.05), borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
                            child: Row(
                              children: [
                                Icon(Icons.receipt_long_rounded, color: _primaryThemeColor, size: 18),
                                const SizedBox(width: 8),
                                Text('Bill Details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _primaryThemeColor)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _summaryRow('Card Holder', widget.billData['customerName']),
                                _summaryRow('Card No.', widget.billData['cardNo']),
                                _summaryRow('Due Date', widget.billData['dueDate'], valueColor: const Color(0xFFE53935)),
                                const SizedBox(height: 8),
                                Divider(color: Colors.grey.shade100),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Amount to Pay', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87)),
                                    Text('₹${widget.billData['payAmount']}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _primaryThemeColor)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _hasSufficientBalance ? Colors.green.shade200 : Colors.red.shade200, width: 1.5),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(color: _hasSufficientBalance ? Colors.green.shade50 : Colors.red.shade50, borderRadius: BorderRadius.circular(13)),
                            child: Icon(Icons.account_balance_wallet_rounded, color: _hasSufficientBalance ? Colors.green.shade600 : Colors.red.shade400, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('PaySaral Wallet', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                                const SizedBox(height: 3),
                                Text(_hasSufficientBalance ? 'Sufficient balance available' : 'Insufficient balance', style: TextStyle(fontSize: 11, color: _hasSufficientBalance ? Colors.green.shade600 : Colors.red.shade400)),
                              ],
                            ),
                          ),
                          Text('₹${_walletBalance.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _hasSufficientBalance ? Colors.green.shade600 : Colors.red.shade400)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity, height: 54,
                      child: ElevatedButton(
                        onPressed: _isPaying ? null : _hasSufficientBalance ? _confirmPayment : () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Redirecting to Add Money...'), backgroundColor: _primaryThemeColor, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, shadowColor: Colors.transparent, disabledBackgroundColor: Colors.transparent, padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _isPaying ? [Colors.grey.shade400, Colors.grey.shade400] : _hasSufficientBalance ? _themeGradient : [Colors.orange.shade600, Colors.orange.shade400],
                              begin: Alignment.topLeft, end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: _isPaying
                                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(_hasSufficientBalance ? Icons.lock_rounded : Icons.add_circle_outline_rounded, color: Colors.white70, size: 18),
                                const SizedBox(width: 8),
                                Text(_hasSufficientBalance ? 'Pay ₹${widget.billData['payAmount']}' : 'Add Money to Wallet', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_user_rounded, size: 14, color: Colors.grey.shade400),
                        const SizedBox(width: 6),
                        Text('100% Safe & Secure BBPS Payment', style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                      ],
                    ),

                    // ✅ JADOO: Transparent, slightly larger Bharat Connect Logo at the very bottom
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Powered by', style: TextStyle(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 8),
                        Image.asset(
                          'assets/images/bharat_connect.png',
                          height: 40, // ✅ Size thoda aur bada kar diya bina patti ke
                          errorBuilder: (context, error, stackTrace) {
                            return Row(
                              children: [
                                const Icon(Icons.hub_rounded, color: Color(0xFF003A70), size: 24),
                                const SizedBox(width: 4),
                                const Text('Bharat', style: TextStyle(color: Color(0xFF003A70), fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: 0.3)),
                                const Text('Connect', style: TextStyle(color: Color(0xFFF37021), fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: 0.3)),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: valueColor ?? Colors.black87)),
        ],
      ),
    );
  }

  Widget _receiptRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: valueColor ?? Colors.black87)),
        ],
      ),
    );
  }
}