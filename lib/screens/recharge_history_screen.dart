import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'recharge_details_screen.dart';

class RechargeHistoryScreen extends StatefulWidget {
  final bool isB2B;
  const RechargeHistoryScreen({super.key, this.isB2B = false});

  @override
  State<RechargeHistoryScreen> createState() => _RechargeHistoryScreenState();
}

class _RechargeHistoryScreenState extends State<RechargeHistoryScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;
  String _selectedDate = 'Last 7 Days';
  DateTimeRange? _customDateRange;

  final List<Map<String, dynamic>> _rechargeData = [
    {
      'txnId': 'TXN1001',
      'biller': 'Jio Prepaid',
      'number': '+91 98765 43210',
      'date': '25 Mar 2026, 11:15 AM',
      'amount': 500.00,
      'opRef': 'JIO123456789',
      'commission': 12.50,
      'cashback': 25.00,
      'opLogoText': 'J',
      'iconBg': const Color(0xFF4A90D9),
      'status': 'Success',
      'type': 'Prepaid',
    },
    {
      'txnId': 'TXN1002',
      'biller': 'Electricity Bill',
      'number': 'CA: 9087654321',
      'date': '24 Mar 2026, 9:00 PM',
      'amount': 1300.00,
      'opRef': 'UPPCL987654',
      'commission': 2.00,
      'cashback': null,
      'opLogoText': 'E',
      'iconBg': const Color(0xFFF5A623),
      'status': 'Pending',
      'type': 'Electricity',
    },
    {
      'txnId': 'TXN1003',
      'biller': 'Tata Sky DTH',
      'number': 'Sub ID: 8765432109',
      'date': '22 Mar 2026, 1:10 PM',
      'amount': 200.00,
      'opRef': 'DTH1122334',
      'commission': 5.50,
      'cashback': null,
      'opLogoText': 'T',
      'iconBg': const Color(0xFF9B59B6),
      'status': 'Failed',
      'type': 'DTH',
    },
    {
      'txnId': 'TXN1004',
      'biller': 'Airtel Postpaid',
      'number': '+91 99887 76655',
      'date': '21 Mar 2026, 4:45 PM',
      'amount': 749.00,
      'opRef': 'AIRTEL998877',
      'commission': 10.00,
      'cashback': null,
      'opLogoText': 'A',
      'iconBg': const Color(0xFFE74C3C),
      'status': 'Success',
      'type': 'Postpaid',
    },
    {
      'txnId': 'TXN1005',
      'biller': 'Gas Cylinder',
      'number': 'ID: 1234567890',
      'date': '20 Mar 2026, 2:30 PM',
      'amount': 950.00,
      'opRef': 'GAS567890',
      'commission': 8.00,
      'cashback': null,
      'opLogoText': 'G',
      'iconBg': const Color(0xFF27AE60),
      'status': 'Success',
      'type': 'Gas',
    },
  ];

  // ── Filtered list ──────────────────────────────────
  List<Map<String, dynamic>> _getFilteredList(String? status) {
    if (status == null) return _rechargeData;
    return _rechargeData.where((t) => t['status'] == status).toList();
  }

  // ── Stats — tab ke hisaab se ──────────────────────
  Map<String, String> _getStats(String? status) {
    final list = _getFilteredList(status);

    double totalAmount = list.fold(0, (sum, t) => sum + (t['amount'] as double));
    int totalTxns = list.length;

    double totalEarning = 0;
    for (var t in list) {
      if (t['status'] == 'Success') {
        if (widget.isB2B) {
          totalEarning += (t['commission'] as double? ?? 0);
        } else {
          totalEarning += (t['cashback'] as double? ?? 0);
        }
      }
    }

    return {
      'amount': '₹${_formatAmount(totalAmount)}',
      'txns': '$totalTxns',
      'earning': '₹${_formatAmount(totalEarning)}',
    };
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      String s = amount.toStringAsFixed(0);
      if (s.length > 3) {
        return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
      }
      return s;
    }
    return amount.toStringAsFixed(0);
  }

  String? _statusForIndex(int index) {
    switch (index) {
      case 1: return 'Success';
      case 2: return 'Pending';
      case 3: return 'Failed';
      default: return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarH = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: _buildHeader(statusBarH),
            ),
          ],
          body: Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildList(null),
                    _buildList('Success'),
                    _buildList('Pending'),
                    _buildList('Failed'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── HEADER ──────────────────────────────────────────
  Widget _buildHeader(double statusBarH) {
    final stats = _getStats(_statusForIndex(_tabController.index));

    return Container(
      color: AppColors.primaryColor,
      child: Column(
        children: [
          SizedBox(height: statusBarH),

          // Top bar
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 4, vertical: 6),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                      'Recharge & BBPS History',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                      )
                  ),
                ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                        Icons.tune_rounded,
                        color: Colors.white,
                        size: 18
                    ),
                  ),
                  onPressed: () => _showFilterSheet(context),
                ),
              ],
            ),
          ),

          // Date chips
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16),
              children: [
                'Today', 'Yesterday',
                'Last 7 Days', 'This Month', 'Custom'
              ].map((d) {
                final bool sel = _selectedDate == d;

                String displayText = d;
                if (d == 'Custom' && sel && _customDateRange != null) {
                  final start = _customDateRange!.start;
                  final end = _customDateRange!.end;
                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                  displayText = '${start.day} ${months[start.month - 1]} - ${end.day} ${months[end.month - 1]}';
                }

                return GestureDetector(
                  onTap: () async {
                    if (d == 'Custom') {
                      final DateTimeRange? picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: AppColors.primaryColor,
                                onPrimary: Colors.white,
                                onSurface: Colors.black87,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (picked != null) {
                        setState(() {
                          _customDateRange = picked;
                          _selectedDate = 'Custom';
                        });
                      }
                    } else {
                      setState(() => _selectedDate = d);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: sel
                          ? Colors.white
                          : Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: sel
                            ? Colors.white
                            : Colors.white.withOpacity(0.25),
                      ),
                    ),
                    child: Text(
                        displayText,
                        style: TextStyle(
                          color: sel
                              ? AppColors.primaryColor
                              : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // ✅ Dynamic stats — tab ke hisaab se
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Row(
                key: ValueKey(_tabController.index),
                children: [
                  _statBox(
                      'Total Amount',
                      stats['amount']!,
                      Icons.account_balance_wallet_rounded
                  ),
                  _vDivider(),
                  _statBox(
                      'Total Txns',
                      stats['txns']!,
                      Icons.receipt_long_rounded
                  ),
                  _vDivider(),
                  _statBox(
                    widget.isB2B ? 'Commission' : 'Cashback',
                    stats['earning']!,
                    widget.isB2B
                        ? Icons.savings_rounded
                        : Icons.stars_rounded,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _statBox(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(
              icon,
              color: Colors.white60,
              size: 18
          ),
          const SizedBox(height: 6),
          Text(
              value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800
              )
          ),
          const SizedBox(height: 3),
          Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 10.5
              )
          ),
        ],
      ),
    );
  }

  Widget _vDivider() {
    return Container(
        width: 1,
        height: 50,
        color: Colors.white.withOpacity(0.2)
    );
  }

  // ── TAB BAR ──────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primaryColor,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w500),
        indicatorColor: AppColors.primaryColor,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Success'),
          Tab(text: 'Pending'),
          Tab(text: 'Failed'),
        ],
      ),
    );
  }

  // ── LIST ──────────────────────────────────────────
  Widget _buildList(String? filterStatus) {
    final list = _getFilteredList(filterStatus);

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                Icons.receipt_long_outlined,
                size: 60,
                color: Colors.grey.shade300
            ),
            const SizedBox(height: 12),
            Text(
                'No transactions found',
                style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 15,
                    fontWeight: FontWeight.w500
                )
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 40),
      physics: const ClampingScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final curr = list[i];
        final prev = i == 0 ? null : list[i - 1];
        final showDate = prev == null ||
            (curr['date'] as String).split(',')[0] !=
                (prev['date'] as String).split(',')[0];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDate) ...[
              if (i != 0) const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(
                    left: 4, bottom: 8, top: 4),
                child: Text(
                  (curr['date'] as String).split(',')[0],
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade500,
                      letterSpacing: 0.4
                  ),
                ),
              ),
            ],
            _txnCard(curr),
          ],
        );
      },
    );
  }

  // ── TXN CARD ──────────────────────────────────────────
  Widget _txnCard(Map<String, dynamic> txn) {
    final String status = txn['status'];
    final bool isFailed = status == 'Failed';
    final bool isPending = status == 'Pending';
    final bool isSuccess = status == 'Success';

    final Color statusColor = isFailed
        ? const Color(0xFFE53935)
        : isPending
        ? const Color(0xFFF57C00)
        : const Color(0xFF2E7D32);

    final Color statusBg = isFailed
        ? const Color(0xFFFFEBEE)
        : isPending
        ? const Color(0xFFFFF3E0)
        : const Color(0xFFE8F5E9);

    final Color iconBg = txn['iconBg'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: iconBg.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      txn['opLogoText'] ?? 'O',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: iconBg,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Row 1: Name + Amount
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                                txn['biller'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.5,
                                    color: Color(0xFF1A1A2E)
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '₹${(txn['amount'] as double).toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: isFailed
                                  ? Colors.grey.shade400
                                  : const Color(0xFF1A1A2E),
                              decoration: isFailed
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      // Row 2: Number + Status
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              txn['number'],
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500
                              )
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius:
                              BorderRadius.circular(6),
                            ),
                            child: Text(
                                status,
                                style: TextStyle(
                                    color: statusColor,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600
                                )
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      // Row 3: Op Ref
                      Row(
                        children: [
                          Icon(
                              Icons.tag_rounded,
                              size: 11,
                              color: Colors.grey.shade400
                          ),
                          const SizedBox(width: 3),
                          const Text(
                              'Op Ref: ',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey
                              )
                          ),
                          Expanded(
                            child: Text(
                                txn['opRef'],
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      // Row 4: Time + Commission/Cashback
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              children: [
                                Icon(
                                    Icons.access_time_rounded,
                                    size: 11,
                                    color: Colors.grey.shade400
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  (txn['date'] as String).contains(',')
                                      ? (txn['date'] as String)
                                      .split(',')[1].trim()
                                      : txn['date'],
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade400
                                  ),
                                ),
                              ]
                          ),

                          // ✅ Sirf Success pe badge
                          if (isSuccess)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: widget.isB2B
                                    ? Colors.green.shade50
                                    : Colors.orange.shade50,
                                borderRadius:
                                BorderRadius.circular(6),
                                border: Border.all(
                                  color: widget.isB2B
                                      ? Colors.green.shade100
                                      : Colors.orange.shade100,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    widget.isB2B
                                        ? Icons.savings_rounded
                                        : Icons.stars_rounded,
                                    size: 11,
                                    color: widget.isB2B
                                        ? Colors.green.shade600
                                        : Colors.orange.shade600,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    widget.isB2B
                                        ? '+₹${(txn['commission'] as double?)?.toStringAsFixed(2) ?? '0.00'}'
                                        : (txn['cashback'] != null
                                        ? '+₹${(txn['cashback'] as double).toStringAsFixed(2)}'
                                        : '+₹${(txn['commission'] as double?)?.toStringAsFixed(2) ?? '0.00'}'),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: widget.isB2B
                                          ? Colors.green.shade600
                                          : Colors.orange.shade600,
                                    ),
                                  ),
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
          ),

          // View Receipt strip
          GestureDetector(
            onTap: () {
              String amtStr = (txn['amount'] as double?)?.toStringAsFixed(0) ?? '0';
              String rewardStr = widget.isB2B
                  ? (txn['commission']?.toString() ?? '0.00')
                  : (txn['cashback']?.toString() ?? txn['commission']?.toString() ?? '0.00');

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RechargeDetailsScreen(
                    isB2B: widget.isB2B,
                    category: txn['type'] ?? 'Prepaid',
                    amount: amtStr,
                    operatorName: txn['biller'] ?? 'Unknown',
                    rechargeNumber: txn['number'] ?? '',
                    txnId: txn['txnId'] ?? '',
                    date: txn['date'] ?? '',
                    rewardAmount: rewardStr,
                    operatorLogoText: txn['opLogoText'] ?? 'O',
                    operatorLogoBg: txn['iconBg'] as Color? ?? AppColors.primaryColor,
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16)),
                border: Border(
                  top: BorderSide(
                      color: Colors.grey.shade100, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      Icons.receipt_long_rounded,
                      size: 13,
                      color: AppColors.primaryColor
                  ),
                  const SizedBox(width: 6),
                  const Text(
                      'View Receipt',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor
                      )
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: AppColors.primaryColor
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── FILTER SHEET ──────────────────────────────────
  void _showFilterSheet(BuildContext context) {
    String tempStatus = 'All';
    String tempCategory = 'All';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Container(
          padding: EdgeInsets.only(
            top: 20, left: 20, right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 30,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36, height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                        'Filters',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        )
                    ),
                    TextButton(
                      onPressed: () => setS(() {
                        tempStatus = 'All';
                        tempCategory = 'All';
                      }),
                      child: const Text(
                          'Reset All',
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500
                          )
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _filterSection(
                  'Status',
                  ['All', 'Success', 'Pending', 'Failed'],
                  tempStatus,
                      (v) => setS(() => tempStatus = v),
                ),
                const SizedBox(height: 24),
                _filterSection(
                  'Category',
                  ['All', 'Prepaid', 'Postpaid', 'DTH',
                    'Electricity', 'Gas', 'Water'],
                  tempCategory,
                      (v) => setS(() => tempCategory = v),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(14)),
                    ),
                    child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterSection(String title, List<String> options,
      String selected, Function(String) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            title,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600
            )
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((opt) {
            final bool sel = selected == opt;
            return GestureDetector(
              onTap: () => onSelect(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: sel
                      ? AppColors.primaryColor
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                    opt,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: sel
                            ? Colors.white
                            : Colors.grey.shade700
                    )
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}