import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'transaction_history_screen.dart'; // ✅ स्क्रीन इम्पोर्ट कर ली

class WalletScreen extends StatefulWidget {
  final double topPadding;
  final VoidCallback onGoToReports;

  const WalletScreen({super.key, required this.topPadding, required this.onGoToReports});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _showDetailedReport = false;

  final List<Map<String, dynamic>> _commissionBreakdown = [
    {'service': 'AEPS Withdrawal', 'icon': Icons.fingerprint, 'color': Colors.teal, 'business': '₹ 10,200', 'commission': 180.50},
    {'service': 'Mobile Recharge', 'icon': Icons.phone_android, 'color': Colors.blue, 'business': '₹ 3,500', 'commission': 45.00},
    {'service': 'Money Transfer (DMT)', 'icon': Icons.sync_alt, 'color': Colors.indigo, 'business': '₹ 1,500', 'commission': 15.00},
    {'service': 'DTH Recharge', 'icon': Icons.tv, 'color': Colors.orange, 'business': '₹ 250', 'commission': 5.00},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: widget.topPadding + 20, left: 16, right: 16, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. MAIN WALLET CARD
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryColor, AppColors.deepMenuColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: AppColors.primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Main Wallet Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    // ✅ वॉलेट आइकॉन पर क्लिक करने से भी लेजर खुल जाएगा
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionHistoryScreen(pageTitle: 'Main Wallet Ledger', isB2B: true)));
                      },
                      child: const Icon(Icons.account_balance_wallet, color: AppColors.accentColor, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('₹ 45,230.50', style: TextStyle(color: Colors.white, fontSize: 29, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add_circle, color: Colors.white, size: 18),
                        label: const Text('Add Money', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.send, color: Colors.white, size: 18),
                        label: const Text('Send Money', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white54),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. AEPS WALLET CARD
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('AEPS Wallet Balance', style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w600)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(6)),
                      child: Text('Withdrawable', style: TextStyle(color: Colors.orange.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                const Text('₹ 12,500.00', style: TextStyle(color: Colors.black87, fontSize: 27, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.account_balance, color: Colors.white, size: 18),
                        label: const Text('Bank Settle', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.sync_alt, color: AppColors.primaryColor, size: 18),
                        label: const Text('Move to Main', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 25),

          // 3. TODAY'S EARNINGS
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text('Today\'s Performance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accentColor.withOpacity(0.5), width: 1.5),
              boxShadow: [BoxShadow(color: AppColors.accentColor.withOpacity(0.1), blurRadius: 10)],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.accentColor.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.insights, color: AppColors.primaryColor, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Total Commission Earned', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                        Text('₹ 245.50', style: TextStyle(color: AppColors.primaryColor, fontSize: 24, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Total Business', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('₹ 15,450.00', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    Container(height: 30, width: 1, color: Colors.grey.shade200),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Net Profit', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('₹ 233.25', style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _showDetailedReport = !_showDetailedReport;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade50,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _showDetailedReport ? 'Hide Detailed Reports' : 'View Detailed Reports',
                          style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _showDetailedReport ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: AppColors.primaryColor,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  // बटन के लिए हाइट बढ़ा दी है
                  height: _showDetailedReport ? (_commissionBreakdown.length * 75).toDouble() + 70 : 0,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 15, bottom: 8), child: Divider()),
                        ..._commissionBreakdown.map((data) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Container(
                                  height: 40, width: 40,
                                  decoration: BoxDecoration(color: data['color'].withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                  child: Icon(data['icon'], color: data['color'], size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(data['service'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87)),
                                      const SizedBox(height: 2),
                                      Text('Vol: ${data['business']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                Text('+ ₹${data['commission'].toStringAsFixed(2)}', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                          );
                        }).toList(),

                        // ✅ जादुई बटन: Full Commission Report खोलने के लिए
                        if (_showDetailedReport)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TransactionHistoryScreen(
                                      pageTitle: 'Commission Report',
                                      isB2B: true,
                                    ),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.primaryColor),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('View Full Commission Report', style: TextStyle(color: AppColors.primaryColor)),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}