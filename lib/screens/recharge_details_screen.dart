import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class RechargeDetailsScreen extends StatefulWidget {
  final bool isB2B;
  final String category;
  final String amount;
  final String txnId;
  final String date;
  final String rechargeNumber;
  final String operatorName;
  final String rewardAmount;
  final String operatorLogoText;
  final Color operatorLogoBg;

  // ✅ JADOO: All parameters OPTIONAL. Kabhi Error nahi aayega.
  const RechargeDetailsScreen({
    super.key,
    this.isB2B = false,
    this.category = 'Prepaid',
    this.amount = '299',
    this.txnId = 'RCH123456789',
    this.date = '25 Mar 2026, 04:25 PM',
    this.rechargeNumber = '+91 9876543210',
    this.operatorName = 'Airtel',
    this.rewardAmount = '0.00',
    this.operatorLogoText = 'A',
    this.operatorLogoBg = const Color(0xFFE74C3C),
  });

  @override
  State<RechargeDetailsScreen> createState() => _RechargeDetailsScreenState();
}

class _RechargeDetailsScreenState extends State<RechargeDetailsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _drawController;
  late Animation<double> _drawAnimation;

  @override
  void initState() {
    super.initState();

    // ✅ Asli PEN se Draw karne wala lagatar animation (No reverse)
    _drawController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _drawAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOutQuart)), weight: 40),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 60),
    ]).animate(_drawController);

    _drawController.repeat();
  }

  @override
  void dispose() {
    _drawController.dispose();
    super.dispose();
  }

  // ✅ Dynamic text generator
  String _getSuccessTitle() {
    switch (widget.category) {
      case 'Electricity': return 'Electricity Bill Paid!';
      case 'Gas': return 'Gas Bill Paid!';
      case 'DTH': return 'DTH Recharge Successful!';
      case 'Water': return 'Water Bill Paid!';
      case 'Postpaid': return 'Postpaid Bill Paid!';
      default: return 'Recharge Successful!';
    }
  }

  String _getRemarkText() {
    switch (widget.category) {
      case 'Electricity': return 'Electricity Bill Payment successful';
      case 'Gas': return 'Gas Cylinder Booking successful';
      case 'DTH': return 'DTH Recharge successful';
      case 'Water': return 'Water Bill Payment successful';
      case 'Postpaid': return 'Postpaid Bill Payment successful';
      default: return 'Mobile Recharge successful';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4F3),
        body: Column(
          children: [

            // ✅ FIXED HEADER
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00251A), Color(0xFF009688)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: statusBarHeight + 4),

                  // AppBar Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text('Transaction Details', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 18),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ✅ Success Icon (PERFECT TICK DRAWING)
                  Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentColor.withOpacity(0.5),
                          blurRadius: 22,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: AnimatedBuilder(
                      animation: _drawAnimation,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: TickPainter(progress: _drawAnimation.value),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ✅ Dynamic Title
                  Text(_getSuccessTitle(),
                      style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),

                  const SizedBox(height: 6),

                  Text('₹ ${widget.amount}',
                      style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800, letterSpacing: 1)),

                  const SizedBox(height: 10),

                  // TxnID pill
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: widget.txnId));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction ID Copied!')));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(widget.txnId, style: const TextStyle(color: Colors.white70, fontSize: 11.5, letterSpacing: 0.5)),
                          const SizedBox(width: 6),
                          const Icon(Icons.copy_rounded, color: Colors.white54, size: 13),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),
                ],
              ),
            ),

            // ✅ SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(), // no bounce
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  children: [

                    // ✅ RECEIPT CARD
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 20, offset: const Offset(0, 6)),
                        ],
                      ),
                      child: Column(
                        children: [

                          // ✅ Operator Banner (With Logo Text)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FFFD),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                              border: Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: widget.operatorLogoBg.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.operatorLogoText,
                                      style: TextStyle(color: widget.operatorLogoBg, fontSize: 22, fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.operatorName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                                      const SizedBox(height: 2),
                                      Text(widget.rechargeNumber, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(color: const Color(0xFFE8F5F3), borderRadius: BorderRadius.circular(20)),
                                  child: const Text('SUCCESS', style: TextStyle(color: AppColors.primaryColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
                                ),
                              ],
                            ),
                          ),

                          _dashedDivider(),

                          // ✅ Detail Rows
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                            child: Column(
                              children: [
                                _row('Transaction ID', widget.txnId, copyable: true),
                                _thinDivider(),
                                _row('Date & Time', widget.date),
                                _thinDivider(),
                                _row('Amount Paid', '₹ ${widget.amount}', valueColor: AppColors.primaryColor, isBold: true),
                                _thinDivider(),

                                // ✅ JADOO: Strict B2B check for text & color
                                widget.isB2B
                                    ? _row('Commission Earned', '+ ₹ ${widget.rewardAmount}', valueColor: Colors.green, isBold: true)
                                    : _row('Cashback Earned', '+ ₹ ${widget.rewardAmount}', valueColor: Colors.orange.shade600, isBold: true),

                                _thinDivider(),
                                _row('Payment Mode', 'Wallet Balance'),
                                _thinDivider(),
                                _row('Remark', _getRemarkText()), // ✅ Dynamic Remark
                              ],
                            ),
                          ),

                          _dashedDivider(),

                          // ✅ Commission / Cashback Badge
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: widget.isB2B
                                      ? [const Color(0xFFE8F5F3), const Color(0xFFF0FFF8)]
                                      : [const Color(0xFFFFF8E1), const Color(0xFFFFF3E0)],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: widget.isB2B ? AppColors.primaryColor.withOpacity(0.15) : Colors.orange.withOpacity(0.25),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: widget.isB2B ? AppColors.accentColor.withOpacity(0.15) : Colors.orange.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      widget.isB2B ? Icons.savings_rounded : Icons.stars_rounded,
                                      color: widget.isB2B ? AppColors.accentColor : Colors.orange.shade600,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.isB2B ? 'Commission Credited!' : 'Cashback Credited!',
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          widget.isB2B ? '₹${widget.rewardAmount} added to your wallet' : '₹${widget.rewardAmount} cashback added!',
                                          style: const TextStyle(fontSize: 11.5, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '+ ₹${widget.rewardAmount}',
                                    style: TextStyle(
                                      color: widget.isB2B ? Colors.green : Colors.orange.shade600,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ✅ SSL Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, color: Colors.grey.shade400, size: 14),
                        const SizedBox(width: 5),
                        Text('256-bit SSL Secured  |  Your data is safe', style: TextStyle(color: Colors.grey.shade400, fontSize: 11.5)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ✅ BOTTOM ACTION BAR
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, -4))],
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5F3),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.file_download_outlined, color: AppColors.primaryColor, size: 20),
                        SizedBox(width: 8),
                        Text('Download', style: TextStyle(color: AppColors.primaryColor, fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF009688), Color(0xFF00695C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: AppColors.primaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.share_rounded, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text('Share', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
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

  Widget _row(String label, String value, {Color? valueColor, bool isBold = false, bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13.5, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
          Row(
            children: [
              Text(value, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: valueColor ?? Colors.black87)),
              if (copyable) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => Clipboard.setData(ClipboardData(text: value)),
                  child: Icon(Icons.copy_rounded, size: 14, color: Colors.grey.shade400),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _thinDivider() => Divider(height: 1, thickness: 1, color: Colors.grey.shade100);

  Widget _dashedDivider() {
    return Row(
      children: [
        Transform.translate(offset: const Offset(-1, 0), child: Container(width: 20, height: 20, decoration: const BoxDecoration(color: Color(0xFFF0F4F3), shape: BoxShape.circle))),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final count = (constraints.maxWidth / 10).floor();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(count, (_) => Container(width: 6, height: 1.5, color: Colors.grey.shade200)),
              );
            },
          ),
        ),
        Transform.translate(offset: const Offset(1, 0), child: Container(width: 20, height: 20, decoration: const BoxDecoration(color: Color(0xFFF0F4F3), shape: BoxShape.circle))),
      ],
    );
  }
}

// ✅ THE PERFECT TICK SHAPE
class TickPainter extends CustomPainter {
  final double progress;

  TickPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final Paint paint = Paint()
      ..color = const Color(0xFF67C949)
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final Path path = Path();

    final double startX = size.width * 0.30;
    final double startY = size.height * 0.50;

    final double midX = size.width * 0.45;
    final double midY = size.height * 0.65;

    final double endX = size.width * 0.75;
    final double endY = size.height * 0.35;

    path.moveTo(startX, startY);

    if (progress <= 0.4) {
      double p1 = progress / 0.4;
      double currentX = startX + (midX - startX) * p1;
      double currentY = startY + (midY - startY) * p1;
      path.lineTo(currentX, currentY);
    } else {
      path.lineTo(midX, midY);
      double p2 = (progress - 0.4) / 0.6;
      double currentX = midX + (endX - midX) * p2;
      double currentY = midY + (endY - midY) * p2;
      path.lineTo(currentX, currentY);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TickPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}