import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_colors.dart';
import 'transaction_history_screen.dart';

class ReportsScreen extends StatefulWidget {
  final double topPadding;
  const ReportsScreen({super.key, required this.topPadding});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool isB2B = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(milliseconds: 50));

    if (mounted) {
      setState(() {
        isB2B = prefs.getBool('isB2B') ?? false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.only(
        top: widget.topPadding + 20,
        left: 20, right: 20, bottom: 40,
      ),
      child: AnimatedOpacity(
        opacity: _isLoading ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= HEADER TEXT =================
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isB2B ? 'Business Reports' : 'My Passbook',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  'Track all your transactions & history',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ================= B2B (RETAILER) REPORTS =================
            if (isB2B) ...[
              _sectionTitle('FINANCIAL LEDGERS'),
              _buildCardWrapper([
                _reportMenuItem(context, Icons.menu_book, 'Main Wallet Ledger', 'Check all your wallet top-ups & debits', Colors.blue, 'Main Wallet Ledger'),
                _divider(),
                _reportMenuItem(context, Icons.account_balance, 'AEPS Settlement Ledger', 'History of wallet to bank transfers', Colors.orange, 'AEPS Settlement Ledger'),
              ]),

              const SizedBox(height: 20),

              _sectionTitle('SERVICE TRANSACTIONS'),
              _buildCardWrapper([
                _reportMenuItem(context, Icons.phone_android, 'Recharge & BBPS History', 'Mobile, DTH, Electricity bill status', Colors.purple, 'Recharge History'),
                _divider(),
                _reportMenuItem(context, Icons.fingerprint, 'AEPS & mATM Report', 'Cash withdrawal & balance enquiry info', Colors.teal, 'AEPS & mATM Report'),
                _divider(),
                _reportMenuItem(context, Icons.sync_alt, 'Money Transfer (DMT)', 'Domestic money remittance status', Colors.indigo, 'DMT History'),
                _divider(),
                _reportMenuItem(context, Icons.flight_takeoff, 'Travel & Services', 'Flight, Train, PAN Card transaction history', Colors.redAccent, 'Travel Services Report'),
              ]),

              const SizedBox(height: 20),

              _sectionTitle('EARNINGS & TAXES'),
              _buildCardWrapper([
                _reportMenuItem(context, Icons.savings, 'Commission Report', 'Detailed report of earnings per service', Colors.green, 'Commission Report'),
                _divider(),
                _reportMenuItem(context, Icons.request_quote, 'TDS Deduction Report', 'Monthly & Yearly TDS statements', Colors.deepOrange, 'TDS Report'),
              ]),
            ]

            // ================= B2C (USER) REPORTS =================
            else ...[
              _sectionTitle('MY PAYMENTS & WALLET'),
              _buildCardWrapper([
                _reportMenuItem(context, Icons.account_balance_wallet, 'Wallet Passbook', 'All your added funds and expenses', Colors.blue, 'Wallet Passbook'),
                _divider(),
                _reportMenuItem(context, Icons.phone_android, 'Recharge & Bill Payments', 'History of mobile, DTH & utilities', Colors.purple, 'Recharge & Bills'),
                _divider(),
                _reportMenuItem(context, Icons.send_outlined, 'Send Money History', 'Funds transferred to bank or friends', Colors.indigo, 'Send Money History'),
              ]),

              const SizedBox(height: 20),

              _sectionTitle('REWARDS & OFFERS'),
              _buildCardWrapper([
                _reportMenuItem(context, Icons.card_giftcard_rounded, 'Cashback Earned', 'History of promo codes and cashback', Colors.orange, 'Cashback Report'),
                _divider(),
                _reportMenuItem(context, Icons.people_outline, 'Referral Rewards', 'Earnings from inviting your friends', Colors.green, 'Referral Report'),
              ]),
            ],

            const SizedBox(height: 30),

            // ================= NEED HELP SECTION =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.support_agent, color: AppColors.primaryColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Need Help with a Transaction?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                        SizedBox(height: 4),
                        Text('Raise a ticket for failed payments.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: AppColors.primaryColor, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI HELPERS =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCardWrapper(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _reportMenuItem(BuildContext context, IconData icon, String title, String subtitle, Color iconColor, String pageTitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black87),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionHistoryScreen(
              pageTitle: pageTitle,
              isB2B: isB2B,
            ),
          ),
        );
      },
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade100,
      indent: 74,
      endIndent: 20,
    );
  }
}