import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_colors.dart';
import 'package:paysaral/services/api_service.dart'; // 🔥 PAYSARAL BOSS: Apna API Service

class WalletScreen extends StatefulWidget {
  final double topPadding;
  final VoidCallback onGoToReports;
  final VoidCallback onGoToAddMoney;

  const WalletScreen({
    super.key,
    required this.topPadding,
    required this.onGoToReports,
    required this.onGoToAddMoney,
  });

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool isB2B = false;
  bool _isLoading = true;
  String _walletBalance = "0.00";
  String _aepsBalance = "0.00"; // 🔥 PAYSARAL BOSS: Naya variable AEPS ke liye

  @override
  void initState() {
    super.initState();
    _loadWalletData();
  }

  Future<void> _loadWalletData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 1. Backend se dono (Main + AEPS) balance nikal lo
    Map<String, String> balances = await ApiService.getWalletBalance();

    if (mounted) {
      setState(() {
        isB2B = prefs.getBool('isB2B') ?? false;
        _walletBalance = balances['main']!; // Main Balance
        _aepsBalance = balances['aeps']!;   // AEPS Balance
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
            // ================= 1. WALLET CARDS =================
            if (isB2B)
              _buildB2BWalletCards()
            else
              _buildB2CWalletCard(),

            const SizedBox(height: 30),

            // ================= 2. WALLET SERVICES =================
            const Text(
                'Wallet Services',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.5)
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _serviceButton(Icons.history, 'Passbook', Colors.blueGrey),
                _serviceButton(Icons.qr_code_scanner, 'Scan & Pay', Colors.orange),
                _serviceButton(Icons.account_balance, 'Bank Links', Colors.indigo),
                _serviceButton(Icons.support_agent, 'Support', Colors.green),
              ],
            ),

            const SizedBox(height: 32),

            // ================= 3. RECENT TRANSACTIONS =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                    'Recent Transactions',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.5)
                ),
                InkWell(
                  onTap: widget.onGoToReports,
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text('View All', style: TextStyle(color: AppColors.primaryColor, fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),

            _transactionTile(Icons.account_balance_wallet, 'Money Added', '23 Mar, 10:30 AM', '+ ₹500.00', Colors.green),
            _transactionTile(Icons.phone_android, 'Jio Recharge', '22 Mar, 04:15 PM', '- ₹299.00', Colors.red),
            if (isB2B) _transactionTile(Icons.account_balance, 'Bank Settlement', '21 Mar, 09:00 AM', '- ₹5,000.00', Colors.blue),
            if (isB2B) _transactionTile(Icons.fingerprint, 'AEPS Withdrawal', '21 Mar, 08:45 AM', '+ ₹1,500.00', Colors.green),
            if (isB2B) _transactionTile(Icons.percent, 'Commission Earned', '21 Mar, 08:45 AM', '+ ₹15.00', Colors.orange),

          ],
        ),
      ),
    );
  }

  // ================= B2C WALLET DESIGN (User) =================
  Widget _buildB2CWalletCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E3C72), Color(0xFF2A5298)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: const Color(0xFF2A5298).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                      child: const Text('Personal Wallet', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Text('₹ $_walletBalance', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.15), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24))),
            child: Row(
              children: [
                Expanded(child: _cardActionButton(Icons.add_circle, 'Add Money', onTap: widget.onGoToAddMoney)),
                Container(width: 1, height: 30, color: Colors.white24),
                Expanded(child: _cardActionButton(Icons.send, 'Send Money', onTap: () {})),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ================= B2B WALLET DESIGN (Retailer) =================
  Widget _buildB2BWalletCards() {
    return Column(
      children: [
        // 1. MAIN WALLET
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.primaryColor, Color(0xFF26A69A)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: AppColors.primaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Main Wallet Balance', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                          child: const Text('For Recharges & Bills', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('₹ $_walletBalance', style: const TextStyle(color: Colors.white, fontSize: 29, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              InkWell(
                onTap: widget.onGoToAddMoney,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.12), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_circle_outline, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text('ADD MONEY TO MAIN WALLET', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2. AEPS / TRADE WALLET
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF333333), Color(0xFF1A1A1A)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('AEPS / Trade Wallet', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.accentColor.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                          child: const Text('Settlement Balance', style: TextStyle(color: AppColors.accentColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    // 🔥 PAYSARAL BOSS: Ab yahan dummy hat gaya, asli AEPS balance aayega
                    Text('₹ $_aepsBalance', style: const TextStyle(color: AppColors.accentColor, fontSize: 29, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20))),
                child: Row(
                  children: [
                    Expanded(child: _cardActionButton(Icons.account_balance, 'Move to Bank', textColor: AppColors.accentColor, onTap: () {})),
                    Container(width: 1, height: 30, color: Colors.white24),
                    Expanded(child: _cardActionButton(Icons.swap_horiz, 'Move to Main', textColor: Colors.white, onTap: () {})),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // ================= COMMON UI HELPERS =================
  Widget _cardActionButton(IconData icon, String label, {Color textColor = Colors.white, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 18),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _serviceButton(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: 70,
        child: Column(
          children: [
            Container(
              height: 48, width: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.2), width: 1),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.2),
            )
          ],
        ),
      ),
    );
  }

  Widget _transactionTile(IconData icon, String title, String date, String amount, Color amountColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            height: 40, width: 40,
            decoration: BoxDecoration(color: amountColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: amountColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5, color: Colors.black87)),
                const SizedBox(height: 3),
                Text(date, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: amountColor),
          )
        ],
      ),
    );
  }
}