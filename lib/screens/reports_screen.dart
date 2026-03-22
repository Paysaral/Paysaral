import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'transaction_history_screen.dart'; // ✅ जादुई स्क्रीन इम्पोर्ट कर ली

class ReportsScreen extends StatelessWidget {
  final double topPadding;

  const ReportsScreen({super.key, required this.topPadding});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: topPadding + 20,
        left: 20,
        right: 20,
        bottom: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Business Reports',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          _sectionTitle('FINANCIAL LEDGERS'),
          Container(
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
            child: Column(
              children: [
                // ✅ यहाँ पेज का नाम पास कर रहे हैं
                _reportMenuItem(context, Icons.menu_book, 'Main Wallet Ledger', 'Check all your wallet top-ups & debits', Colors.blue, 'Main Wallet Ledger'),
                _divider(),
                _reportMenuItem(context, Icons.account_balance, 'AEPS Settlement Ledger', 'History of wallet to bank transfers', Colors.orange, 'AEPS Settlement Ledger'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _sectionTitle('SERVICE TRANSACTIONS'),
          Container(
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
            child: Column(
              children: [
                _reportMenuItem(context, Icons.phone_android, 'Recharge & BBPS History', 'Mobile, DTH, Electricity bill status', Colors.purple, 'Recharge History'),
                _divider(),
                _reportMenuItem(context, Icons.fingerprint, 'AEPS & mATM Report', 'Cash withdrawal & balance enquiry info', Colors.teal, 'AEPS & mATM Report'),
                _divider(),
                _reportMenuItem(context, Icons.sync_alt, 'Money Transfer (DMT)', 'Domestic money remittance status', Colors.indigo, 'DMT History'),
                _divider(),
                _reportMenuItem(context, Icons.flight_takeoff, 'Travel & Services', 'Flight, Train, PAN Card transaction history', Colors.redAccent, 'Travel Services Report'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _sectionTitle('EARNINGS & TAXES'),
          Container(
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
            child: Column(
              children: [
                _reportMenuItem(context, Icons.savings, 'Commission Report', 'Detailed report of earnings per service', Colors.green, 'Commission Report'),
                _divider(),
                _reportMenuItem(context, Icons.request_quote, 'TDS Deduction Report', 'Monthly & Yearly TDS statements', Colors.deepOrange, 'TDS Report'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        bottom: 10,
      ),
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

  // ✅ FIX: इस फंक्शन में Context और PageTitle जोड़ दिया ताकि यह सीधा स्क्रीन खोल सके
  Widget _reportMenuItem(BuildContext context, IconData icon, String title, String subtitle, Color iconColor, String pageTitle) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      // ✅ जादुई कोड यहाँ लगा दिया है
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionHistoryScreen(
              pageTitle: pageTitle, // जो नाम भेजोगे, वही हेडर में छपेगा
              isB2B: true,          // B2B वाला शानदार कमीशन डैशबोर्ड दिखेगा
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
      indent: 60,
      endIndent: 20,
    );
  }
}