import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> quickActions = [
    {'icon': Icons.fingerprint, 'label': 'AEPS', 'color': Color(0xFF009688)},
    {'icon': Icons.send_to_mobile, 'label': 'DMT', 'color': Color(0xFF67C949)},
    {'icon': Icons.phone_android, 'label': 'Recharge', 'color': Color(0xFF009688)},
    {'icon': Icons.receipt_long, 'label': 'Bill Pay', 'color': Color(0xFF67C949)},
    {'icon': Icons.credit_card, 'label': 'PAN Card', 'color': Color(0xFF009688)},
    {'icon': Icons.account_balance, 'label': 'Banking', 'color': Color(0xFF67C949)},
    {'icon': Icons.confirmation_number, 'label': 'Coupon', 'color': Color(0xFF009688)},
    {'icon': Icons.more_horiz, 'label': 'More', 'color': Color(0xFF67C949)},
  ];

  final List<Map<String, dynamic>> recentTransactions = [
    {'name': 'Rahul Kumar', 'type': 'DMT Transfer', 'amount': '- ₹500', 'time': '2 min ago', 'isDebit': true},
    {'name': 'Airtel Recharge', 'type': 'Mobile Recharge', 'amount': '- ₹199', 'time': '1 hr ago', 'isDebit': true},
    {'name': 'Wallet Topup', 'type': 'Added Money', 'amount': '+ ₹2000', 'time': '3 hr ago', 'isDebit': false},
    {'name': 'AEPS Withdrawal', 'type': 'Cash Withdrawal', 'amount': '- ₹1000', 'time': 'Yesterday', 'isDebit': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              // Wallet Card
              _buildWalletCard(),
              // Quick Actions
              _buildQuickActions(),
              // Recent Transactions
              _buildRecentTransactions(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF009688), Color(0xFF67C949)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Namaste 👋', style: TextStyle(color: Colors.white70, fontSize: 13)),
              Text('Roshan Kumar', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Stack(
                  children: [
                    Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
                    Positioned(
                      right: 0, top: 0,
                      child: Container(
                        width: 10, height: 10,
                        decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      ),
                    ),
                  ],
                ),
                onPressed: () {},
              ),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Text('R', style: TextStyle(color: Color(0xFF009688), fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00796B), Color(0xFF009688)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Color(0xFF009688).withOpacity(0.4), blurRadius: 15, offset: Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Wallet Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                child: Text('Active', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('₹ 12,500.00', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _walletAction(Icons.add_circle_outline, 'Add Money'),
              _walletAction(Icons.send, 'Transfer'),
              _walletAction(Icons.history, 'History'),
              _walletAction(Icons.qr_code, 'QR Code'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _walletAction(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.85,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: quickActions.length,
            itemBuilder: (context, index) {
              return _buildActionItem(quickActions[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(Map<String, dynamic> action) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: action['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: action['color'].withOpacity(0.2)),
            ),
            child: Icon(action['icon'], color: action['color'], size: 26),
          ),
          SizedBox(height: 6),
          Text(action['label'], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black87), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              Text('See All', style: TextStyle(fontSize: 13, color: Color(0xFF009688), fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(height: 12),
          ...recentTransactions.map((txn) => _buildTransactionItem(txn)).toList(),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> txn) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: txn['isDebit'] ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              txn['isDebit'] ? Icons.arrow_upward : Icons.arrow_downward,
              color: txn['isDebit'] ? Colors.red : Colors.green,
              size: 18,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(txn['name'], style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(txn['type'], style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(txn['amount'], style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14,
                color: txn['isDebit'] ? Colors.red : Colors.green,
              )),
              Text(txn['time'], style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      selectedItemColor: Color(0xFF009688),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'History'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
      ],
    );
  }
}
