import 'package:flutter/material.dart';
import 'app_colors.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedDate = '7 Days';
  String _selectedCategory = 'All';
  String _selectedPaymentType = 'All';
  String _selectedStatus = 'All';

  final List<Map<String, dynamic>> _transactions = [
    {'title': 'Cashback Received', 'date': '20 Mar 2026, 10:30 AM', 'amount': '+ ₹50.00', 'isCredit': true, 'icon': Icons.card_giftcard, 'status': 'Success'},
    {'title': 'Mobile Recharge (Jio)', 'date': '19 Mar 2026, 06:15 PM', 'amount': '- ₹299.00', 'isCredit': false, 'icon': Icons.phone_android, 'status': 'Success'},
    {'title': 'Money sent to Rahul', 'date': '18 Mar 2026, 02:45 PM', 'amount': '- ₹1,500.00', 'isCredit': false, 'icon': Icons.send, 'status': 'Success'},
    {'title': 'AEPS Settlement', 'date': '18 Mar 2026, 11:20 AM', 'amount': '+ ₹12,000.00', 'isCredit': true, 'icon': Icons.fingerprint, 'status': 'Success'},
    {'title': 'Electricity Bill (JBVNL)', 'date': '15 Mar 2026, 09:00 PM', 'amount': '- ₹850.00', 'isCredit': false, 'icon': Icons.lightbulb_outline, 'status': 'Failed'},
    {'title': 'Wallet Topup (UPI)', 'date': '12 Mar 2026, 01:10 PM', 'amount': '+ ₹5,000.00', 'isCredit': true, 'icon': Icons.account_balance_wallet, 'status': 'Success'},
  ];

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Container(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 30),
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Container(height: 5, width: 50, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
                        const SizedBox(height: 20),
                        const Text('Filter Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const Divider(height: 30),

                        const Text('Date Range', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8, runSpacing: 8,
                          children: ['Today', 'Yesterday', '7 Days', '1 Month', '3 Months', '1 Year'].map((date) {
                            return ChoiceChip(
                              label: Text(date), selected: _selectedDate == date, selectedColor: AppColors.accentColor,
                              labelStyle: TextStyle(color: _selectedDate == date ? Colors.white : Colors.black87, fontWeight: _selectedDate == date ? FontWeight.bold : FontWeight.normal),
                              onSelected: (bool selected) { if (selected) setModalState(() => _selectedDate = date); },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        const Text('Service Category', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8, runSpacing: 8,
                          children: ['All', 'Recharge', 'DTH', 'Electricity', 'Water', 'Gas', 'Fastag'].map((category) {
                            return ChoiceChip(
                              label: Text(category), selected: _selectedCategory == category, selectedColor: AppColors.accentColor,
                              labelStyle: TextStyle(color: _selectedCategory == category ? Colors.white : Colors.black87, fontWeight: _selectedCategory == category ? FontWeight.bold : FontWeight.normal),
                              onSelected: (bool selected) { if (selected) setModalState(() => _selectedCategory = category); },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        const Text('Payment Type', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8, runSpacing: 8,
                          children: ['All', 'Payment', 'Received'].map((type) {
                            return ChoiceChip(
                              label: Text(type), selected: _selectedPaymentType == type, selectedColor: AppColors.accentColor,
                              labelStyle: TextStyle(color: _selectedPaymentType == type ? Colors.white : Colors.black87, fontWeight: _selectedPaymentType == type ? FontWeight.bold : FontWeight.normal),
                              onSelected: (bool selected) { if (selected) setModalState(() => _selectedPaymentType = type); },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        const Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8, runSpacing: 8,
                          children: ['All', 'Success', 'Failed', 'Pending'].map((status) {
                            return ChoiceChip(
                              label: Text(status), selected: _selectedStatus == status, selectedColor: AppColors.accentColor,
                              labelStyle: TextStyle(color: _selectedStatus == status ? Colors.white : Colors.black87, fontWeight: _selectedStatus == status ? FontWeight.bold : FontWeight.normal),
                              onSelected: (bool selected) { if (selected) setModalState(() => _selectedStatus = status); },
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity, height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                            onPressed: () { setState(() {}); Navigator.pop(context); },
                            child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(backgroundColor: AppColors.primaryColor, elevation: 0, title: const Text('Recent Transactions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)), leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Showing: $_selectedDate', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                OutlinedButton.icon(onPressed: () => _showFilterBottomSheet(context), icon: const Icon(Icons.filter_list, size: 18), label: const Text('Filter & Sort'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.primaryColor, side: const BorderSide(color: AppColors.primaryColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
              child: ListView.separated(
                shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), padding: EdgeInsets.zero, itemCount: _transactions.length,
                separatorBuilder: (context, index) => Divider(height: 1, thickness: 1, color: Colors.grey.shade100, indent: 60),
                itemBuilder: (context, index) {
                  var txn = _transactions[index];
                  bool isCredit = txn['isCredit'];
                  bool isFailed = txn['status'] == 'Failed';
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Container(height: 45, width: 45, decoration: BoxDecoration(color: isFailed ? Colors.red.shade50 : AppColors.primaryColor.withOpacity(0.08), borderRadius: BorderRadius.circular(12)), child: Icon(txn['icon'], color: isFailed ? Colors.red : AppColors.primaryColor, size: 22)),
                    title: Text(txn['title'], style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text(txn['date'], style: const TextStyle(fontSize: 11, color: Colors.grey))),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(txn['amount'], style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: isFailed ? Colors.grey : (isCredit ? Colors.green.shade600 : Colors.black87))),
                        if (isFailed) ...[const SizedBox(height: 2), const Text('Failed', style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold))]
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}