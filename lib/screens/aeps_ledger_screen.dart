import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AepsLedgerScreen extends StatefulWidget {
  final bool isB2B;
  const AepsLedgerScreen({super.key, this.isB2B = true});

  @override
  State<AepsLedgerScreen> createState() => _AepsLedgerScreenState();
}

class _AepsLedgerScreenState extends State<AepsLedgerScreen> {
  String selectedFilter = 'All';
  String selectedStatus = 'All';

  // ✅ JADOO: Date Filter State Variables
  String selectedDateFilter = 'This Month';
  DateTime? customStartDate;
  DateTime? customEndDate;

  final List<String> filterOptions = ['All', 'Cash Withdrawal', 'Balance Enquiry', 'Mini Statement'];
  final List<String> statusOptions = ['All', 'Success', 'Failed', 'Pending'];

  final List<Map<String, dynamic>> aepsTransactions = [
    {
      'txnId': 'AEPS9876543210',
      'type': 'Cash Withdrawal',
      'bank': 'State Bank of India',
      'aadhaar': 'XXXX XXXX 4589',
      'amount': '3,500.00',
      'commission': '8.50',
      'date': '28 Mar 2026, 10:30 AM',
      'status': 'Success',
      'rrn': '123456789012',
      'openingBalance': '10,742.00',
      'closingBalance': '14,250.50'
    },
    {
      'txnId': 'AEPS6677889900',
      'type': 'Balance Enquiry',
      'bank': 'Bank of India',
      'aadhaar': 'XXXX XXXX 7890',
      'amount': '0.00',
      'commission': '0.00',
      'date': '27 Mar 2026, 04:45 PM',
      'status': 'Success',
      'rrn': '456123789012',
      'openingBalance': '10,750.50',
      'closingBalance': '10,750.50'
    },
    {
      'txnId': 'AEPS1122334455',
      'type': 'Mini Statement',
      'bank': 'HDFC Bank',
      'aadhaar': 'XXXX XXXX 1234',
      'amount': '0.00',
      'commission': '1.50',
      'date': '26 Mar 2026, 02:15 PM',
      'status': 'Success',
      'rrn': '987654321098',
      'openingBalance': '10,749.00',
      'closingBalance': '10,750.50'
    },
    {
      'txnId': 'AEPS5544332211',
      'type': 'Cash Withdrawal',
      'bank': 'Punjab National Bank',
      'aadhaar': 'XXXX XXXX 5566',
      'amount': '5,000.00',
      'commission': '10.00',
      'date': '25 Mar 2026, 01:20 PM',
      'status': 'Failed',
      'rrn': 'NA',
      'openingBalance': '10,750.50',
      'closingBalance': '10,750.50',
      'remark': 'Issuer Bank Inoperative'
    },
    {
      'txnId': 'AEPS9988776655',
      'type': 'Cash Withdrawal',
      'bank': 'ICICI Bank',
      'aadhaar': 'XXXX XXXX 3322',
      'amount': '2,000.00',
      'commission': '5.00',
      'date': '24 Mar 2026, 11:10 AM',
      'status': 'Pending',
      'rrn': 'Pending',
      'openingBalance': '10,750.50',
      'closingBalance': '10,750.50',
      'remark': 'Awaiting bank confirmation'
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Success':
        return const Color(0xFF4CAF50);
      case 'Failed':
        return const Color(0xFFE53935);
      case 'Pending':
        return const Color(0xFFF57C00);
      default:
        return Colors.grey.shade600;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Cash Withdrawal':
        return Icons.account_balance_wallet_rounded;
      case 'Balance Enquiry':
        return Icons.account_balance_rounded;
      case 'Mini Statement':
        return Icons.receipt_long_rounded;
      default:
        return Icons.fingerprint_rounded;
    }
  }

  // ✅ Helper to format date without external packages
  String _formatShortDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}';
  }

  // ✅ Dynamic String for Hero UI
  String get _dateFilterText {
    if (selectedDateFilter == 'Custom Date' && customStartDate != null && customEndDate != null) {
      return '${_formatShortDate(customStartDate!)} - ${_formatShortDate(customEndDate!)}';
    }
    return selectedDateFilter;
  }

  // ════════════════════════════════════════════════════════
  // DATE FILTER BOTTOM SHEET
  // ════════════════════════════════════════════════════════
  void _showDateFilterSheet() {
    final List<String> dateOptions = ['Today', 'Last 7 Days', 'This Month', 'Custom Date'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 48, height: 5,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 16),
            const Text('Select Date Range', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            ...dateOptions.map((option) {
              bool isSel = selectedDateFilter == option && option != 'Custom Date';
              if(option == 'Custom Date' && selectedDateFilter != 'Today' && selectedDateFilter != 'Last 7 Days' && selectedDateFilter != 'This Month') {
                isSel = true; // Highlight Custom Date if active
              }
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                title: Text(
                    option,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSel ? FontWeight.w600 : FontWeight.w500,
                        color: isSel ? AppColors.primaryColor : Colors.black87
                    )
                ),
                trailing: isSel ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryColor) : null,
                onTap: () async {
                  Navigator.pop(ctx);
                  if (option == 'Custom Date') {
                    // Show Flutter's beautiful Date Range Picker
                    DateTimeRange? picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppColors.primaryColor,
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDateFilter = 'Custom Date';
                        customStartDate = picked.start;
                        customEndDate = picked.end;
                      });
                    }
                  } else {
                    setState(() {
                      selectedDateFilter = option;
                      customStartDate = null;
                      customEndDate = null;
                    });
                  }
                },
              );
            }).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // 1. RETAILER VIEW (Full Details with Commission & Balances)
  // ════════════════════════════════════════════════════════
  void _showRetailerTransactionDetails(Map<String, dynamic> txn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 48, height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Retailer Ledger Details', style: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),

            // Header Icon & Status
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                color: _getStatusColor(txn['status']).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                txn['status'] == 'Success' ? Icons.check_circle_rounded :
                txn['status'] == 'Failed' ? Icons.cancel_rounded : Icons.pending_actions_rounded,
                color: _getStatusColor(txn['status']),
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '₹${txn['amount']}',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            Text(
              txn['status'] == 'Success' ? 'Transaction Successful' :
              txn['status'] == 'Failed' ? 'Transaction Failed' : 'Transaction Pending',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _getStatusColor(txn['status'])),
            ),
            const SizedBox(height: 24),

            // Details List
            Flexible(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    _detailRow('Transaction Type', txn['type']),
                    _detailRow('Bank Name', txn['bank']),
                    _detailRow('Aadhaar Number', txn['aadhaar']),
                    _detailRow('Date & Time', txn['date']),
                    Divider(color: Colors.grey.shade200, height: 24),
                    _detailRow('Transaction ID', txn['txnId']),
                    _detailRow('Bank RRN', txn['rrn']),
                    if (txn['status'] == 'Failed' || txn['status'] == 'Pending')
                      _detailRow('Remark', txn['remark'] ?? '', valueColor: _getStatusColor(txn['status'])),

                    if (widget.isB2B) ...[
                      Divider(color: Colors.grey.shade200, height: 24),
                      _detailRow('Opening Balance', '₹${txn['openingBalance']}'),
                      if (txn['status'] == 'Success' && txn['commission'] != '0.00')
                        _detailRow('Commission Earned', '+ ₹${txn['commission']}', valueColor: const Color(0xFF4CAF50), isBold: true),
                      _detailRow('Closing Balance', '₹${txn['closingBalance']}', isBold: true),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Action Buttons -> Opens Customer Receipt
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showCustomerReceipt(txn);
                  },
                  icon: const Icon(Icons.receipt_rounded, size: 18, color: Colors.white),
                  label: const Text('Generate Customer Receipt', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // 2. CUSTOMER RECEIPT VIEW (Safe for Sharing/Printing)
  // ════════════════════════════════════════════════════════
  void _showCustomerReceipt(Map<String, dynamic> txn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 48, height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Customer Transaction Receipt', style: TextStyle(color: AppColors.primaryColor, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Header Icon & Status
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                color: _getStatusColor(txn['status']).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                txn['status'] == 'Success' ? Icons.check_circle_rounded :
                txn['status'] == 'Failed' ? Icons.cancel_rounded : Icons.pending_actions_rounded,
                color: _getStatusColor(txn['status']),
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '₹${txn['amount']}',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            Text(
              txn['status'] == 'Success' ? 'Transaction Successful' :
              txn['status'] == 'Failed' ? 'Transaction Failed' : 'Transaction Pending',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _getStatusColor(txn['status'])),
            ),
            const SizedBox(height: 24),

            // Clean Customer Details List
            Flexible(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      _detailRow('Transaction Type', txn['type']),
                      _detailRow('Bank Name', txn['bank']),
                      _detailRow('Aadhaar Number', txn['aadhaar']),
                      _detailRow('Date & Time', txn['date']),
                      const SizedBox(height: 8),
                      Divider(color: Colors.grey.shade300, height: 20, thickness: 1),
                      const SizedBox(height: 8),
                      _detailRow('Transaction ID', txn['txnId']),
                      _detailRow('Bank RRN', txn['rrn']),
                      if (txn['status'] == 'Failed' || txn['status'] == 'Pending')
                        _detailRow('Remark', txn['remark'] ?? '', valueColor: _getStatusColor(txn['status'])),
                      const SizedBox(height: 10),
                      const Text('Thank you for transacting with Paysaral', style: TextStyle(color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons for Customer Receipt
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.share_rounded, size: 18),
                      label: const Text('Share', style: TextStyle(fontWeight: FontWeight.w500)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        side: const BorderSide(color: AppColors.primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.print_rounded, size: 18, color: Colors.white),
                      label: const Text('Print', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, {Color? valueColor, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w400)),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter Logic based on selected options
    List<Map<String, dynamic>> filteredList = aepsTransactions.where((txn) {
      bool typeMatch = selectedFilter == 'All' || txn['type'] == selectedFilter;
      bool statusMatch = selectedStatus == 'All' || txn['status'] == selectedStatus;
      return typeMatch && statusMatch;
    }).toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Column(
          children: [
            // ══ FIXED HEADER HERO SECTION ════════════════════════════
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00695C), Color(0xFF009688)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AppBar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Expanded(
                            child: Text('AEPS Ledger',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                          ),
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.search_rounded, color: Colors.white, size: 18),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),

                    // Today's Summary Card
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.15)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Today\'s Volume', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w400)),
                                const SizedBox(height: 4),
                                const Text('₹15,500', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Est. Commission', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w400)),
                                const SizedBox(height: 4),
                                const Text('₹23.50', style: TextStyle(color: Color(0xFFC6FF00), fontSize: 20, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ✅ JADOO: Interactive Month/Date Selector
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Transactions', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),

                          // Clickable Date Filter Container
                          GestureDetector(
                            onTap: _showDateFilterSheet,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_month_rounded, color: AppColors.primaryColor, size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                      _dateFilterText, // Automatically updates via getter
                                      style: const TextStyle(color: AppColors.primaryColor, fontSize: 12, fontWeight: FontWeight.w600)
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryColor, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ══ FILTER ROWS ════════════════════════════
            Container(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              color: const Color(0xFFF5F7FA),
              child: Column(
                children: [
                  // Transaction Type Filter
                  SizedBox(
                    height: 34,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const ClampingScrollPhysics(),
                      itemCount: filterOptions.length,
                      itemBuilder: (context, index) {
                        bool isSel = selectedFilter == filterOptions[index];
                        return GestureDetector(
                          onTap: () => setState(() => selectedFilter = filterOptions[index]),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSel ? AppColors.primaryColor : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSel ? AppColors.primaryColor : Colors.grey.shade300),
                              boxShadow: isSel ? [BoxShadow(color: AppColors.primaryColor.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 2))] : [],
                            ),
                            child: Text(
                              filterOptions[index],
                              style: TextStyle(
                                color: isSel ? Colors.white : Colors.grey.shade700,
                                fontWeight: isSel ? FontWeight.w500 : FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Status Filter
                  SizedBox(
                    height: 34,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const ClampingScrollPhysics(),
                      itemCount: statusOptions.length,
                      itemBuilder: (context, index) {
                        bool isSel = selectedStatus == statusOptions[index];
                        return GestureDetector(
                          onTap: () => setState(() => selectedStatus = statusOptions[index]),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSel ? Colors.grey.shade800 : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: isSel ? Colors.grey.shade800 : Colors.grey.shade300),
                            ),
                            child: Text(
                              statusOptions[index],
                              style: TextStyle(
                                color: isSel ? Colors.white : Colors.grey.shade600,
                                fontWeight: isSel ? FontWeight.w500 : FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ══ SCROLLABLE LEDGER LIST ════════════════════════════
            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long_rounded, size: 60, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text('No transactions found', style: TextStyle(color: Colors.grey.shade500, fontSize: 15, fontWeight: FontWeight.w500)),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                physics: const ClampingScrollPhysics(),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final txn = filteredList[index];
                  Color statusColor = _getStatusColor(txn['status']);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: InkWell(
                      onTap: () => _showRetailerTransactionDetails(txn),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Top Row: Icon, Type, Amount
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44, height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(_getTypeIcon(txn['type']), color: AppColors.primaryColor, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(txn['type'], style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black87)),
                                      const SizedBox(height: 4),
                                      Text('${txn['bank']} • ${txn['aadhaar']}', style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('₹${txn['amount']}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87)),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(txn['status'], style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w600)),
                                    ),
                                    if (widget.isB2B && txn['status'] == 'Success' && txn['commission'] != '0.00')
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text('+ ₹${txn['commission']} Comm.',
                                            style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 11, fontWeight: FontWeight.w600)),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Divider(color: Colors.grey.shade100, height: 1),
                            const SizedBox(height: 12),

                            // Bottom Row: Date & Txn ID
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(txn['date'], style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w400)),
                                Row(
                                  children: [
                                    Text('Txn: ${txn['txnId']}', style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w400)),
                                    const SizedBox(width: 4),
                                    Icon(Icons.copy_rounded, size: 12, color: Colors.grey.shade400),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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