import 'package:flutter/material.dart';
import 'app_colors.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final String pageTitle;
  final bool isB2B; // ✅ B2B aur B2C ko alag karne ka switch

  const TransactionHistoryScreen({
    super.key,
    required this.pageTitle,
    this.isB2B = false, // Default B2C rahega
  });

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedDate = '7 Days';
  String _selectedCategory = 'All';
  String _selectedPaymentType = 'All';
  String _selectedStatus = 'All';

  final List<Map<String, dynamic>> _transactions = [
    {
      'txnId': 'TXN9876543210', 'title': 'AEPS Cash Withdrawal', 'operator': 'State Bank of India',
      'date': '22 Mar 2026, 02:30 PM', 'amount': '10,000.00', 'commission': '+ ₹25.00', 'cashback': null,
      'isCredit': true, 'icon': Icons.fingerprint, 'status': 'Success'
    },
    {
      'txnId': 'TXN1234567890', 'title': 'Mobile Recharge', 'operator': 'Jio Prepaid',
      'date': '22 Mar 2026, 11:15 AM', 'amount': '299.00', 'commission': '+ ₹8.50', 'cashback': '+ ₹15.00',
      'isCredit': false, 'icon': Icons.phone_android, 'status': 'Success'
    },
    {
      'txnId': 'TXN4567890123', 'title': 'Money Transfer (DMT)', 'operator': 'HDFC Bank (Rahul)',
      'date': '21 Mar 2026, 04:45 PM', 'amount': '5,000.00', 'commission': '+ ₹15.00', 'cashback': null,
      'isCredit': false, 'icon': Icons.sync_alt, 'status': 'Success'
    },
    {
      'txnId': 'TXN7890123456', 'title': 'Electricity Bill', 'operator': 'JBVNL Jharkhand',
      'date': '20 Mar 2026, 09:00 PM', 'amount': '850.00', 'commission': '+ ₹2.00', 'cashback': null,
      'isCredit': false, 'icon': Icons.lightbulb_outline, 'status': 'Failed'
    },
    {
      'txnId': 'TXN3456789012', 'title': 'DTH Recharge', 'operator': 'Tata Play',
      'date': '19 Mar 2026, 01:10 PM', 'amount': '500.00', 'commission': '+ ₹12.50', 'cashback': '+ ₹25.00',
      'isCredit': false, 'icon': Icons.tv, 'status': 'Success'
    },
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
                          children: ['All', 'AEPS', 'Recharge', 'DMT', 'Electricity', 'Water'].map((category) {
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
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Text(widget.pageTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(icon: const Icon(Icons.download_rounded, color: Colors.white), tooltip: 'Download Report', onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Downloading Report...'))); })
        ],
      ),
      body: Column(
        children: [
          // ================= TOP SUMMARY CARD =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            ),
            child: widget.isB2B

            // ✅ B2B WALA CARD (Retailer ke liye)
                ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: const [Icon(Icons.bar_chart, size: 16, color: Colors.grey), SizedBox(width: 4), Text('Total Business', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600))]),
                      const SizedBox(height: 6),
                      const Text('₹ 16,649.00', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800, fontSize: 20)),
                    ],
                  ),
                  Container(height: 40, width: 1, color: Colors.grey.shade300),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(children: const [Icon(Icons.savings_outlined, size: 16, color: Colors.grey), SizedBox(width: 4), Text('Commission', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600))]),
                      const SizedBox(height: 6),
                      Text('+ ₹ 63.00', style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.w800, fontSize: 20)),
                    ],
                  ),
                ],
              ),
            )

            // ✅ B2C WALA CARD (New Premium White Design)
                : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white, // सफ़ेद बैकग्राउंड
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5))
                  ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(Icons.stars_rounded, size: 18, color: Colors.orange.shade500), // गोल्डन आइकॉन
                        const SizedBox(width: 6),
                        Text('Lifetime Cashback Won', style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w600))
                      ]),
                      const SizedBox(height: 6),
                      const Text('₹ 245.00', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: 0.5)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFF8C00)], // खूबसूरत गोल्डन-ऑरेंज ग्रेडिएंट
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.orange.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))
                        ]
                    ),
                    child: const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 28),
                  )
                ],
              ),
            ),
          ),

          // ================= FILTER ROW =================
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Showing: $_selectedDate', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                InkWell(
                  onTap: () => _showFilterBottomSheet(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.primaryColor.withOpacity(0.3))),
                    child: Row(children: const [Icon(Icons.filter_list, size: 16, color: AppColors.primaryColor), SizedBox(width: 4), Text('Filter', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 12))]),
                  ),
                ),
              ],
            ),
          ),

          // ================= DETAILED TRANSACTION LIST =================
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40, top: 5),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                var txn = _transactions[index];
                bool isFailed = txn['status'] == 'Failed';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))]),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(height: 45, width: 45, decoration: BoxDecoration(color: isFailed ? Colors.red.shade50 : AppColors.primaryColor.withOpacity(0.08), borderRadius: BorderRadius.circular(12)), child: Icon(txn['icon'], color: isFailed ? Colors.red : AppColors.primaryColor, size: 22)),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(txn['title'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)), const SizedBox(height: 4), Text(txn['date'], style: const TextStyle(fontSize: 11, color: Colors.grey))])),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: isFailed ? Colors.red.shade50 : Colors.green.shade50, borderRadius: BorderRadius.circular(6)), child: Text(txn['status'], style: TextStyle(color: isFailed ? Colors.red : Colors.green.shade700, fontSize: 10, fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),

                      Divider(height: 1, color: Colors.grey.shade100, indent: 16, endIndent: 16),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [const Text('Txn ID: ', style: TextStyle(fontSize: 11, color: Colors.grey)), Text(txn['txnId'], style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500)), const SizedBox(width: 6), const Icon(Icons.copy, size: 12, color: Colors.grey)]),
                                  const SizedBox(height: 4),
                                  Row(children: [const Text('Operator: ', style: TextStyle(fontSize: 11, color: Colors.grey)), Expanded(child: Text(txn['operator'], style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis))]),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('₹ ${txn['amount']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, decoration: isFailed ? TextDecoration.lineThrough : null, color: isFailed ? Colors.grey : Colors.black87)),
                                const SizedBox(height: 4),

                                // ✅ B2B Commission Badge
                                if (widget.isB2B && !isFailed && txn['commission'] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
                                    child: Text('Comm: ${txn['commission']}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                                  ),

                                // ✅ B2C Cashback Badge (Customer ko khush karne ke liye)
                                if (!widget.isB2B && !isFailed && txn['cashback'] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(4)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.stars, size: 10, color: Colors.orange.shade700),
                                        const SizedBox(width: 2),
                                        Text('Cashback: ${txn['cashback']}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange.shade700)),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}