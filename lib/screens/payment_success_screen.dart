import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String amount;
  final String txnId;
  final String date;
  final String paymentMode;
  final String updatedBalance;

  const PaymentSuccessScreen({
    super.key,
    required this.amount,
    required this.txnId,
    required this.date,
    required this.paymentMode,
    required this.updatedBalance,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // ✅ JADOO: Smooth entrance animation ke liye
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7F9), // Soft premium grey
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ================= TOP TITLE =================
              const Text('Transaction Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.5)),

              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(), // Fevicol Fix
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        // ================= SUCCESS ANIMATION & AMOUNT =================
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            height: 80, width: 80,
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.green.shade200, width: 2),
                            ),
                            child: Icon(Icons.check_circle, color: Colors.green.shade600, size: 50),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('Top-up Successful!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87)),
                        const SizedBox(height: 8),
                        Text('Your wallet has been recharged securely.', style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 24),

                        // Amount Display
                        Text('₹ ${widget.amount}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: AppColors.primaryColor, letterSpacing: 0.5)),
                        const SizedBox(height: 35),

                        // ================= SLEEK RECEIPT CARD =================
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: Column(
                            children: [
                              _receiptRow('Transaction ID', widget.txnId, isHighlight: true),
                              _divider(),
                              _receiptRow('Date & Time', widget.date),
                              _divider(),
                              _receiptRow('Payment Mode', widget.paymentMode),
                              _divider(),
                              _receiptRow('Updated Balance', '₹ ${widget.updatedBalance}', isTotal: true),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // ================= HELP SECTION =================
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primaryColor.withOpacity(0.15)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.support_agent, color: AppColors.primaryColor, size: 22),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text('Having issues with this transaction? Contact our support team.', style: TextStyle(fontSize: 11.5, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primaryColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ================= BOTTOM ACTIONS =================
              Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, -5))],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {}, // Share logic
                        icon: const Icon(Icons.share, size: 18, color: AppColors.primaryColor),
                        label: const Text('Share', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: AppColors.primaryColor, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          // ✅ JADOO: Wapas Dashboard pe le jayega (sari stack clear karke)
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Done', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ================= UI HELPERS =================
  Widget _receiptRow(String title, String value, {bool isHighlight = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
          Text(
              value,
              style: TextStyle(
                fontSize: isTotal ? 16 : 13.5,
                fontWeight: isTotal ? FontWeight.w800 : (isHighlight ? FontWeight.w700 : FontWeight.w600),
                color: isTotal ? AppColors.primaryColor : Colors.black87,
              )
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey.shade100, indent: 20, endIndent: 20);
  }
}