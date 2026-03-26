import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class ElectricityPaymentScreen extends StatefulWidget {
  final Map<String, dynamic> billData;
  final Map<String, dynamic> discomData;

  const ElectricityPaymentScreen({
    super.key,
    required this.billData,
    required this.discomData,
  });

  @override
  State<ElectricityPaymentScreen> createState() =>
      _ElectricityPaymentScreenState();
}

class _ElectricityPaymentScreenState extends State<ElectricityPaymentScreen> {
  bool _isPaying = false;

  final double _walletBalance = 2000.00;

  double get _billAmount {
    final raw = widget.billData['billAmount'].toString().replaceAll(',', '');
    return double.tryParse(raw) ?? 0.0;
  }

  bool get _hasSufficientBalance => _walletBalance >= _billAmount;

  // ✅ Indian Currency Comma Formatter (E.g., 2000.00 -> 2,000.00)
  String _formatCurrency(double amount) {
    String numStr = amount.toStringAsFixed(2);
    List<String> parts = numStr.split('.');
    String intPart = parts[0];
    if (intPart.length > 3) {
      String lastThree = intPart.substring(intPart.length - 3);
      String rest = intPart.substring(0, intPart.length - 3);
      rest = rest.replaceAllMapped(RegExp(r'\B(?=(\d{2})+(?!\d))'), (Match m) => ',');
      intPart = '$rest,$lastThree';
    }
    return '$intPart.${parts[1]}';
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 28, 24, MediaQuery.of(context).viewInsets.bottom + 40),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // Success Icon
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle_rounded,
                    color: Colors.green.shade500, size: 48),
              ),
              const SizedBox(height: 16),

              const Text('Payment Successful!',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87)),
              const SizedBox(height: 6),
              Text(
                '₹${widget.billData['billAmount']} paid to ${widget.discomData['name']}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Receipt Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _receiptRow('Consumer No.', widget.billData['consumerNo']),
                    _receiptRow('Operator', widget.discomData['name']),
                    _receiptRow('Amount', '₹${widget.billData['billAmount']}'),
                    _receiptRow('Date', '25 Mar 2026'),
                    _receiptRow('Txn ID',
                        'TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}'),
                    _receiptRow('Status', 'Success', valueColor: Colors.green),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Done Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                      ..pop()
                      ..pop()
                      ..pop();
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
                      child: const Text('Done',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
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
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Column(
          children: [

            // ══ HEADER ════════════════════════════════
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00695C), Color(0xFF009688)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text('Payment Summary',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
            ),

            // ══ BODY (FIXED TO SCREEN SIZE) ══════════════════════════════════
            // ✅ JADOO: SingleChildScrollView hata diya hai, ab ye screen me 100% lock ho jayega
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Column(
                  children: [

                    // Operator Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52, height: 52,
                            decoration: BoxDecoration(
                              color: (widget.discomData['color'] as Color).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              widget.discomData['icon'] as IconData,
                              color: widget.discomData['color'] as Color,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.discomData['name'],
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87)),
                                const SizedBox(height: 3),
                                Text(widget.discomData['fullName'],
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey.shade500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Bill Summary Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.05),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.receipt_long_rounded,
                                    color: AppColors.primaryColor, size: 18),
                                SizedBox(width: 8),
                                Text('Bill Summary',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryColor)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _summaryRow('Consumer Name', widget.billData['consumerName']),
                                _summaryRow('Consumer No.', widget.billData['consumerNo']),
                                _summaryRow('Bill Month', widget.billData['billMonth']),
                                _summaryRow('Due Date', widget.billData['dueDate'],
                                    valueColor: const Color(0xFFE53935)),
                                _summaryRow('Units', '${widget.billData['units']} kWh'),
                                const SizedBox(height: 8),
                                Divider(color: Colors.grey.shade100),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Bill Amount',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87)),
                                    Text('₹${widget.billData['billAmount']}',
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryColor)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Wallet Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _hasSufficientBalance
                              ? Colors.green.shade200
                              : Colors.red.shade200,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(
                              color: _hasSufficientBalance
                                  ? Colors.green.shade50
                                  : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Icon(Icons.account_balance_wallet_rounded,
                                color: _hasSufficientBalance
                                    ? Colors.green.shade600
                                    : Colors.red.shade400,
                                size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('PaySaral Wallet',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87)),
                                const SizedBox(height: 3),
                                Text(
                                  _hasSufficientBalance
                                      ? 'Sufficient balance available'
                                      : 'Insufficient balance',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: _hasSufficientBalance
                                          ? Colors.green.shade600
                                          : Colors.red.shade400),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '₹${_formatCurrency(_walletBalance)}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: _hasSufficientBalance
                                    ? Colors.green.shade600
                                    : Colors.red.shade400),
                          ),
                        ],
                      ),
                    ),

                    // ✅ JADOO: Spacer lagane se Pay button aur Logo hamesha screen ke bilkul bottom me chipke rahenge. Scroll completely disabled.
                    const Spacer(),

                    // Pay / Add Money Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isPaying
                            ? null
                            : _hasSufficientBalance
                            ? _confirmPayment
                            : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Redirecting to Add Money...'),
                              backgroundColor: AppColors.primaryColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          disabledBackgroundColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _isPaying
                                  ? [Colors.grey.shade400, Colors.grey.shade400]
                                  : _hasSufficientBalance
                                  ? [const Color(0xFF00695C), const Color(0xFF009688)]
                                  : [Colors.orange.shade600, Colors.orange.shade400],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: _isPaying
                                ? const SizedBox(
                                width: 22, height: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5))
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _hasSufficientBalance
                                      ? Icons.lock_rounded
                                      : Icons.add_circle_outline_rounded,
                                  color: Colors.white70,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _hasSufficientBalance
                                      ? 'Pay ₹${widget.billData['billAmount']}'
                                      : 'Add Money to Wallet',
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

                    const SizedBox(height: 16),

                    // Safe payment note
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_user_rounded,
                            size: 14, color: Colors.grey.shade400),
                        const SizedBox(width: 6),
                        Text('100% Safe & Secure Payment',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade400)),
                      ],
                    ),

                    // Bharat Connect Logo
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Powered by', style: TextStyle(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 8),
                        Image.asset(
                          'assets/images/bharat_connect.png',
                          height: 40,
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

  Widget _receiptRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          Text(value,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.black87)),
        ],
      ),
    );
  }
}