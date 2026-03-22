import 'package:flutter/material.dart';
import 'app_colors.dart';

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
                // ✅ COLORFUL ICONS
                _reportMenuItem(Icons.menu_book, 'Main Wallet Ledger', 'Check all your wallet top-ups & debits', Colors.blue),
                _divider(),
                _reportMenuItem(Icons.account_balance, 'AEPS Settlement Ledger', 'History of wallet to bank transfers', Colors.orange),
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
                _reportMenuItem(Icons.phone_android, 'Recharge & BBPS History', 'Mobile, DTH, Electricity bill status', Colors.purple),
                _divider(),
                _reportMenuItem(Icons.fingerprint, 'AEPS & mATM Report', 'Cash withdrawal & balance enquiry info', Colors.teal),
                _divider(),
                _reportMenuItem(Icons.sync_alt, 'Money Transfer (DMT)', 'Domestic money remittance status', Colors.indigo),
                _divider(),
                _reportMenuItem(Icons.flight_takeoff, 'Travel & Services', 'Flight, Train, PAN Card transaction history', Colors.redAccent),
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
                _reportMenuItem(Icons.savings, 'Commission Report', 'Detailed report of earnings per service', Colors.green),
                _divider(),
                _reportMenuItem(Icons.request_quote, 'TDS Deduction Report', 'Monthly & Yearly TDS statements', Colors.deepOrange),
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

  Widget _reportMenuItem(IconData icon, String title, String subtitle, Color iconColor) {
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
      onTap: () {},
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