import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AepsScreen extends StatefulWidget {
  final bool isB2B;
  final String selectedApi;

  const AepsScreen({
    super.key,
    required this.isB2B,
    required this.selectedApi,
  });

  @override
  State<AepsScreen> createState() => _AepsScreenState();
}

class _AepsScreenState extends State<AepsScreen> with TickerProviderStateMixin {
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _amountController  = TextEditingController();
  final FocusNode _aadhaarFocus = FocusNode();

  int _selectedTab   = 0;
  bool _isLoading    = false;
  String selectedBank   = 'Select Bank';
  String selectedDevice = 'Mantra';

  late AnimationController _pulseController;
  late AnimationController _fingerController;
  late Animation<double>   _pulseAnimation;
  late Animation<double>   _fingerAnimation;

  final List<String> devices = ['Mantra', 'Morpho', 'Startek', 'Evolute', 'SecuGen'];

  final List<Map<String, dynamic>> _tabs = [
    {'label': 'Withdraw',  'icon': Icons.account_balance_wallet_rounded},
    {'label': 'Balance',   'icon': Icons.donut_large_rounded},
    {'label': 'Statement', 'icon': Icons.receipt_long_rounded},
  ];

  final List<Map<String, String>> _popularBanks = [
    {'name': 'State Bank of India',   'short': 'SBI'},
    {'name': 'Punjab National Bank',  'short': 'PNB'},
    {'name': 'Bank of Baroda',        'short': 'BOB'},
    {'name': 'Canara Bank',           'short': 'CNR'},
    {'name': 'HDFC Bank',             'short': 'HDFC'},
    {'name': 'ICICI Bank',            'short': 'ICICI'},
    {'name': 'Axis Bank',             'short': 'AXIS'},
    {'name': 'Union Bank of India',   'short': 'UBI'},
    {'name': 'Indian Bank',           'short': 'IB'},
    {'name': 'Central Bank of India', 'short': 'CBI'},
    {'name': 'Kotak Mahindra Bank',   'short': 'KMB'},
    {'name': 'IndusInd Bank',         'short': 'INDUS'},
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _fingerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fingerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fingerController, curve: Curves.easeInOut),
    );

    _aadhaarController.addListener(_formatAadhaar);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _aadhaarFocus.requestFocus();
    });
  }

  // ── Aadhaar Auto Format: XXXX-XXXX-XXXX ──
  void _formatAadhaar() {
    String raw = _aadhaarController.text
        .replaceAll('-', '')
        .replaceAll(RegExp(r'[^0-9]'), '');
    if (raw.length > 12) raw = raw.substring(0, 12);

    final buf = StringBuffer();
    for (int i = 0; i < raw.length; i++) {
      if (i == 4 || i == 8) buf.write('-');
      buf.write(raw[i]);
    }

    final formatted = buf.toString();
    if (_aadhaarController.text != formatted) {
      _aadhaarController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fingerController.dispose();
    _aadhaarController.removeListener(_formatAadhaar);
    _aadhaarController.dispose();
    _amountController.dispose();
    _aadhaarFocus.dispose();
    super.dispose();
  }

  String get _apiLabel =>
      widget.selectedApi == 'eko' ? 'AEPS Server 1' : 'AEPS Server 2';

  // ── Comma format for Chips: 1000 → 1,000 ──
  String _formatChipAmount(int amt) {
    return amt.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
    );
  }

  Future<void> _processTransaction() async {
    FocusScope.of(context).unfocus();

    final rawAadhaar = _aadhaarController.text.replaceAll('-', '');
    if (rawAadhaar.length < 12) {
      _showSnack('Please enter a valid 12-digit Aadhaar Number');
      return;
    }
    if (_selectedTab == 0 &&
        (_amountController.text.isEmpty || _amountController.text == '0')) {
      _showSnack('Please enter withdrawal amount');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _showSnack('Device Ready! Please scan fingerprint.');
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: AppColors.deepMenuColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ✅ Bank Sheet with Live Search Feature
  void _showBankSheet() {
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
          builder: (context, setModalState) {
            final filteredBanks = _popularBanks.where((bank) {
              return bank['name']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
                  bank['short']!.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 48, height: 5,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(height: 20),
                  const Text('Select Bank', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.deepMenuColor)),
                  const SizedBox(height: 16),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      onChanged: (value) {
                        setModalState(() {
                          searchQuery = value;
                        });
                      },
                      cursorColor: AppColors.primaryColor,
                      decoration: InputDecoration(
                        hintText: 'Search Bank Name...',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryColor),
                        filled: true,
                        fillColor: AppColors.bgColor,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.shade200, height: 1),

                  // Bank List (FLAT LIST, NO BOXES, NORMAL FONT)
                  Expanded(
                    child: filteredBanks.isEmpty
                        ? Center(child: Text('No bank found', style: TextStyle(color: Colors.grey.shade500)))
                        : ListView.builder(
                      itemCount: filteredBanks.length,
                      padding: const EdgeInsets.only(top: 8, bottom: 20),
                      itemBuilder: (_, i) {
                        final bank = filteredBanks[i];
                        final isSelected = selectedBank == bank['name'];
                        return InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() => selectedBank = bank['name']!);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            color: isSelected ? AppColors.primaryColor.withOpacity(0.06) : Colors.transparent,
                            child: Row(
                              children: [
                                Container(
                                  width: 44, height: 44,
                                  decoration: BoxDecoration(color: isSelected ? AppColors.primaryColor : AppColors.bgColor, shape: BoxShape.circle),
                                  child: Center(
                                    child: Text(bank['short']!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: isSelected ? Colors.white : Colors.grey.shade600)),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(bank['name']!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          color: Colors.black87
                                      )
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle_rounded, color: AppColors.primaryColor, size: 22),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.bgColor,
          body: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [

              // ════════════════════════════════════
              //  HEADER
              // ════════════════════════════════════
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.deepMenuColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36), // ✅ Slightly less radius to save space
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [

                        // ── AppBar ──
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // ✅ Reduced padding
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(_apiLabel,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                                    // ✅ Text Updated to 'System'
                                    Text('Aadhaar Enabled Payment System',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                                  ),
                                  child: const Icon(Icons.history_rounded, color: Colors.white, size: 18),
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),

                        // ── Fingerprint Animation ──
                        const SizedBox(height: 8), // ✅ Reduced Gap
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (_, __) => Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: 88, height: 88, // ✅ Reduced Hero Size (100 -> 88)
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.accentColor.withOpacity(0.2), width: 2),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 70, height: 70, // ✅ Reduced (80 -> 70)
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [AppColors.primaryColor.withOpacity(0.4), AppColors.deepMenuColor.withOpacity(0.1)],
                                ),
                                border: Border.all(color: AppColors.primaryColor.withOpacity(0.5), width: 1.5),
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _fingerAnimation,
                              builder: (_, __) => ClipOval(
                                child: SizedBox(
                                  width: 56, height: 56, // ✅ Reduced (64 -> 56)
                                  child: CustomPaint(painter: _ScanLinePainter(_fingerAnimation.value)),
                                ),
                              ),
                            ),
                            const Icon(Icons.fingerprint_rounded, size: 42, color: AppColors.accentColor), // ✅ Reduced Icon Size
                          ],
                        ),
                        const SizedBox(height: 14), // ✅ Reduced Gap

                        // ── Tabs ──
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: 44, // ✅ Slightly slimmer tabs (48 -> 44)
                            padding: const EdgeInsets.all(4), // ✅ Slimmer padding
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12), // ✅ Adjusted radius
                            ),
                            child: Row(
                              children: _tabs.asMap().entries.map((e) {
                                final active = _selectedTab == e.key;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      setState(() => _selectedTab = e.key);
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      decoration: BoxDecoration(
                                        color: active ? Colors.white : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8), // ✅ Adjusted radius
                                        boxShadow: active ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)] : [],
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              e.value['icon'] as IconData,
                                              size: 13, // ✅ Adjusted size
                                              color: active ? AppColors.deepMenuColor : Colors.white60,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              e.value['label'] as String,
                                              style: TextStyle(
                                                fontSize: 11.5, // ✅ Adjusted size
                                                fontWeight: FontWeight.w700,
                                                color: active ? AppColors.deepMenuColor : Colors.white60,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16), // ✅ Reduced Gap
                      ],
                    ),
                  ),
                ),
              ),

              // ════════════════════════════════════
              //  BODY
              // ════════════════════════════════════
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30), // ✅ Reduced Top & Bottom padding
                sliver: SliverList(
                  delegate: SliverChildListDelegate([

                    // ── Section Label ──
                    _sectionLabel(icon: Icons.how_to_reg_rounded, title: 'Customer Details'),
                    const SizedBox(height: 10), // ✅ Reduced

                    // ── SINGLE UNIFIED CONTAINER ──
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 8)),
                        ],
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Aadhaar Row
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12), // ✅ Reduced
                            child: Row(
                              children: [
                                _fieldIcon(Icons.fingerprint_rounded, AppColors.primaryColor),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Aadhaar Number', style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                                      TextField(
                                        controller: _aadhaarController,
                                        focusNode: _aadhaarFocus,
                                        keyboardType: TextInputType.number,
                                        maxLength: 14,
                                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]'))],
                                        cursorColor: AppColors.primaryColor,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 2.0, color: Colors.black87),
                                        decoration: const InputDecoration(
                                          counterText: '',
                                          hintText: 'XXXX-XXXX-XXXX',
                                          hintStyle: TextStyle(color: Color(0xFFE0E0E0), fontSize: 16, letterSpacing: 2, fontWeight: FontWeight.w400),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.only(top: 4), // ✅ Adjusted
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: AppColors.bgColor, borderRadius: BorderRadius.circular(10)),
                                  child: Icon(Icons.qr_code_scanner_rounded, color: Colors.grey.shade600, size: 20),
                                ),
                              ],
                            ),
                          ),
                          Divider(color: Colors.grey.shade100, thickness: 1.5, height: 1),

                          // Bank Selector Row
                          InkWell(
                            onTap: _showBankSheet,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12), // ✅ Reduced
                              child: Row(
                                children: [
                                  _fieldIcon(Icons.account_balance_rounded, Colors.indigo.shade400),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Selected Bank', style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                                        const SizedBox(height: 2), // ✅ Reduced
                                        Text(selectedBank, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                                      ],
                                    ),
                                  ),
                                  const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Change', style: TextStyle(color: AppColors.primaryColor, fontSize: 13, fontWeight: FontWeight.bold)),
                                      SizedBox(width: 2),
                                      Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primaryColor, size: 12),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Amount Row
                          AnimatedSize(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOutCubic,
                            child: _selectedTab == 0
                                ? Column(
                              children: [
                                Divider(color: Colors.grey.shade100, thickness: 1.5, height: 1),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 14), // ✅ Reduced
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                            child: const Text('₹', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryColor)),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Enter Amount', style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                                                TextField(
                                                  controller: _amountController,
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.digitsOnly,
                                                    LengthLimitingTextInputFormatter(5),
                                                    _CommaTextInputFormatter(),
                                                  ],
                                                  cursorColor: AppColors.primaryColor,
                                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
                                                  decoration: InputDecoration(
                                                    hintText: '0',
                                                    hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 22, fontWeight: FontWeight.w400),
                                                    border: InputBorder.none,
                                                    isDense: true,
                                                    contentPadding: const EdgeInsets.only(top: 2), // ✅ Adjusted
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10), // ✅ Reduced
                                      // Quick Chips
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        child: Row(
                                          children: [500, 1000, 2000, 5000].map((amt) {
                                            final formatted = _formatChipAmount(amt);
                                            final isSelected = _amountController.text.replaceAll(',', '') == amt.toString();
                                            return GestureDetector(
                                              onTap: () {
                                                HapticFeedback.lightImpact();
                                                setState(() => _amountController.text = formatted);
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 200),
                                                margin: const EdgeInsets.only(right: 10),
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: isSelected ? AppColors.primaryColor : Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: isSelected ? AppColors.primaryColor : Colors.grey.shade300),
                                                ),
                                                child: Text('₹$formatted',
                                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: isSelected ? Colors.white : Colors.black87)),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                                : const SizedBox(width: double.infinity, height: 0),
                          ),

                          Divider(color: Colors.grey.shade100, thickness: 1.5, height: 1),

                          // ── Biometric Device (Single Line Row) ──
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14), // ✅ Reduced
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Select Device', style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                                const SizedBox(height: 8), // ✅ Reduced
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  child: Row(
                                    children: devices.map((dev) {
                                      final isSel = selectedDevice == dev;
                                      return GestureDetector(
                                        onTap: () {
                                          HapticFeedback.selectionClick();
                                          setState(() => selectedDevice = dev);
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 220),
                                          margin: const EdgeInsets.only(right: 10),
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), // ✅ Slightly slimmer
                                          decoration: BoxDecoration(
                                            color: isSel ? AppColors.primaryColor.withOpacity(0.08) : Colors.white,
                                            borderRadius: BorderRadius.circular(10), // ✅ Adjusted radius
                                            border: Border.all(color: isSel ? AppColors.primaryColor : Colors.grey.shade200, width: isSel ? 1.5 : 1),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(isSel ? Icons.check_circle_rounded : Icons.usb_rounded, size: 15, color: isSel ? AppColors.primaryColor : Colors.grey.shade500),
                                              const SizedBox(width: 6),
                                              Text(dev, style: TextStyle(fontWeight: isSel ? FontWeight.w500 : FontWeight.w500, fontSize: 12.5, color: isSel ? AppColors.primaryColor : Colors.black87)),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24), // ✅ Reduced Gap to bring button up

                    // ── Scan & Proceed Button ──
                    Center(
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (_, __) => Transform.scale(
                          scale: _isLoading ? 1.0 : _pulseAnimation.value,
                          child: Container(
                            height: 52, // ✅ Slightly slimmer button (56 -> 52)
                            width: MediaQuery.of(context).size.width * 0.75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16), // ✅ Adjusted
                              color: AppColors.accentColor,
                              boxShadow: _isLoading ? [] : [
                                BoxShadow(color: AppColors.accentColor.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6)),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: _isLoading ? null : _processTransaction,
                                child: Center(
                                  child: _isLoading
                                      ? const SizedBox(
                                    height: 22, width: 22,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                  )
                                      : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.fingerprint_rounded, color: Colors.white, size: 20),
                                      SizedBox(width: 8),
                                      Text('Scan & Proceed',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.5,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16), // ✅ Reduced Gap

                    // ── Safety Badge ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), // ✅ Slimmer padding
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_user_rounded, size: 13, color: Colors.green.shade600),
                              const SizedBox(width: 6),
                              Text('100% Safe & Secure Transaction',
                                  style: TextStyle(fontSize: 11, color: Colors.green.shade700, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Section Label Helper
  Widget _sectionLabel({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6), // ✅ Adjusted
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 13, color: AppColors.primaryColor), // ✅ Adjusted
        ),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
              fontSize: 13.5, // ✅ Adjusted
              fontWeight: FontWeight.w800,
              color: AppColors.deepMenuColor,
            )),
      ],
    );
  }

  // ✅ Field Icon Helper
  Widget _fieldIcon(IconData icon, Color color) {
    return Container(
      width: 40, height: 40, // ✅ Slightly slimmer (44 -> 40)
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10), // ✅ Adjusted
      ),
      child: Icon(icon, color: color, size: 20), // ✅ Adjusted
    );
  }
}

// ── Custom Comma Formatter for Indian Rupee ──
class _CommaTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    String cleanString = newValue.text.replaceAll(',', '');
    int? value = int.tryParse(cleanString);
    if (value == null) return oldValue;

    String newString = cleanString.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}

// ── Scanner Line Painter ──
class _ScanLinePainter extends CustomPainter {
  final double progress;
  _ScanLinePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          AppColors.accentColor.withOpacity(0.8),
          Colors.transparent,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final y = size.height * progress;
    canvas.drawRect(Rect.fromLTWH(0, y - 1.5, size.width, 3), paint);
  }

  @override
  bool shouldRepaint(_ScanLinePainter old) => old.progress != progress;
}