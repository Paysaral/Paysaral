import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class RechargeDetailsScreen extends StatelessWidget {
  // ✅ isB2B parameter add kiya
  final bool isB2B;
  const RechargeDetailsScreen({super.key, this.isB2B = false});

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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text('Transaction Details',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.qr_code_2_rounded,
                                color: Colors.white, size: 18),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ✅ Success Icon
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
                    child: const Icon(Icons.check_rounded,
                        color: Color(0xFF67C949), size: 38),
                  ),

                  const SizedBox(height: 10),

                  const Text('Recharge Successful!',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),

                  const SizedBox(height: 6),

                  const Text('₹ 299',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1)),

                  const SizedBox(height: 10),

                  // TxnID pill
                  GestureDetector(
                    onTap: () => Clipboard.setData(
                        const ClipboardData(text: 'RCH248657331')),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('RCH248657331',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11.5,
                                  letterSpacing: 0.5)),
                          SizedBox(width: 6),
                          Icon(Icons.copy_rounded,
                              color: Colors.white54, size: 13),
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
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  children: [

                    // ✅ RECEIPT CARD
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [

                          // ✅ Operator Banner
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FFFD),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(24)),
                              border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey.shade100,
                                    width: 1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius:
                                    BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.cell_tower,
                                      color: Colors.red, size: 24),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text('Airtel Prepaid',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87)),
                                      const SizedBox(height: 2),
                                      Text('+91 9876543210',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade500)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F5F3),
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: const Text('SUCCESS',
                                      style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.8)),
                                ),
                              ],
                            ),
                          ),

                          _dashedDivider(),

                          // ✅ Detail Rows
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20, 8, 20, 8),
                            child: Column(
                              children: [
                                _row('Transaction ID', 'RCH248657331',
                                    copyable: true),
                                _thinDivider(),
                                _row('Date & Time',
                                    '24 Apr 2026, 04:25 PM'),
                                _thinDivider(),
                                _row('Recharge Amount', '₹ 299',
                                    valueColor: AppColors.primaryColor,
                                    isBold: true),
                                _thinDivider(),

                                // ✅ B2B = Commission | B2C = Cashback
                                isB2B
                                    ? _row(
                                    'Commission Earned', '+ ₹ 3.89',
                                    valueColor: Colors.green,
                                    isBold: true)
                                    : _row(
                                    'Cashback Earned', '+ ₹ 25.00',
                                    valueColor: Colors.orange.shade600,
                                    isBold: true),

                                _thinDivider(),
                                _row('Payment Mode', 'Wallet Balance'),
                                _thinDivider(),
                                _row('Remark', 'Recharge successful'),
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
                                  colors: isB2B
                                      ? [
                                    const Color(0xFFE8F5F3),
                                    const Color(0xFFF0FFF8),
                                  ]
                                      : [
                                    const Color(0xFFFFF8E1),
                                    const Color(0xFFFFF3E0),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isB2B
                                      ? AppColors.primaryColor
                                      .withOpacity(0.15)
                                      : Colors.orange.withOpacity(0.25),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isB2B
                                          ? AppColors.accentColor
                                          .withOpacity(0.15)
                                          : Colors.orange.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isB2B
                                          ? Icons.savings_rounded
                                          : Icons.stars_rounded,
                                      color: isB2B
                                          ? AppColors.accentColor
                                          : Colors.orange.shade600,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isB2B
                                              ? 'Commission Credited!'
                                              : 'Cashback Credited!',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          isB2B
                                              ? '₹3.89 added to your wallet'
                                              : '₹25.00 cashback added!',
                                          style: const TextStyle(
                                              fontSize: 11.5,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    isB2B ? '+ ₹3.89' : '+ ₹25.00',
                                    style: TextStyle(
                                      color: isB2B
                                          ? Colors.green
                                          : Colors.orange.shade600,
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
                        Icon(Icons.lock_outline,
                            color: Colors.grey.shade400, size: 14),
                        const SizedBox(width: 5),
                        Text(
                            '256-bit SSL Secured  |  Your data is safe',
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 11.5)),
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
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
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
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.file_download_outlined,
                            color: AppColors.primaryColor, size: 20),
                        SizedBox(width: 8),
                        Text('Download',
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
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
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.share_rounded,
                            color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text('Share',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
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

  Widget _row(String label, String value,
      {Color? valueColor,
        bool isBold = false,
        bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13.5,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500)),
          Row(
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                      isBold ? FontWeight.bold : FontWeight.w600,
                      color: valueColor ?? Colors.black87)),
              if (copyable) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () =>
                      Clipboard.setData(ClipboardData(text: value)),
                  child: Icon(Icons.copy_rounded,
                      size: 14, color: Colors.grey.shade400),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _thinDivider() =>
      Divider(height: 1, thickness: 1, color: Colors.grey.shade100);

  Widget _dashedDivider() {
    return Row(
      children: [
        Transform.translate(
          offset: const Offset(-1, 0),
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F4F3),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final count = (constraints.maxWidth / 10).floor();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  count,
                      (_) => Container(
                      width: 6,
                      height: 1.5,
                      color: Colors.grey.shade200),
                ),
              );
            },
          ),
        ),
        Transform.translate(
          offset: const Offset(1, 0),
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F4F3),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
