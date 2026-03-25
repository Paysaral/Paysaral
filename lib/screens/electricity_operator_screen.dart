import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'electricity_bill_screen.dart';

class ElectricityOperatorScreen extends StatefulWidget {
  const ElectricityOperatorScreen({super.key});

  @override
  State<ElectricityOperatorScreen> createState() =>
      _ElectricityOperatorScreenState();
}

class _ElectricityOperatorScreenState
    extends State<ElectricityOperatorScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> discoms = [
    // Jharkhand
    {
      'name': 'JBVNL',
      'fullName': 'Jharkhand Bijli Vitran Nigam Ltd',
      'state': 'Jharkhand',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFF00897B),
    },
    // Bihar
    {
      'name': 'SBPDCL',
      'fullName': 'South Bihar Power Distribution Co. Ltd',
      'state': 'Bihar',
      'icon': Icons.electric_meter_rounded,
      'color': Color(0xFF1565C0),
    },
    {
      'name': 'NBPDCL',
      'fullName': 'North Bihar Power Distribution Co. Ltd',
      'state': 'Bihar',
      'icon': Icons.electric_meter_rounded,
      'color': Color(0xFF0288D1),
    },
    // Uttar Pradesh
    {
      'name': 'UPPCL (Urban)',
      'fullName': 'Uttar Pradesh Power Corp Ltd - Urban',
      'state': 'Uttar Pradesh',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFF6A1B9A),
    },
    {
      'name': 'UPPCL (Rural)',
      'fullName': 'Uttar Pradesh Power Corp Ltd - Rural',
      'state': 'Uttar Pradesh',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFF7B1FA2),
    },
    {
      'name': 'PVVNL',
      'fullName': 'Paschimanchal Vidyut Vitran Nigam Ltd',
      'state': 'Uttar Pradesh',
      'icon': Icons.electric_bolt_rounded,
      'color': Color(0xFF4527A0),
    },
    // Delhi
    {
      'name': 'BSES Rajdhani',
      'fullName': 'BSES Rajdhani Power Limited',
      'state': 'Delhi',
      'icon': Icons.location_city_rounded,
      'color': Color(0xFFE53935),
    },
    {
      'name': 'BSES Yamuna',
      'fullName': 'BSES Yamuna Power Limited',
      'state': 'Delhi',
      'icon': Icons.location_city_rounded,
      'color': Color(0xFFD81B60),
    },
    {
      'name': 'TPDDL',
      'fullName': 'Tata Power Delhi Distribution Ltd',
      'state': 'Delhi',
      'icon': Icons.flash_on_rounded,
      'color': Color(0xFF1565C0),
    },
    // Maharashtra
    {
      'name': 'MSEDCL',
      'fullName': 'Maharashtra State Electricity Dist. Co.',
      'state': 'Maharashtra',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFFE65100),
    },
    {
      'name': 'TATA Power Mumbai',
      'fullName': 'Tata Power Company Ltd - Mumbai',
      'state': 'Maharashtra',
      'icon': Icons.flash_on_rounded,
      'color': Color(0xFF1565C0),
    },
    {
      'name': 'Adani Electricity',
      'fullName': 'Adani Electricity Mumbai Ltd',
      'state': 'Maharashtra',
      'icon': Icons.electric_bolt_rounded,
      'color': Color(0xFF2E7D32),
    },
    // West Bengal
    {
      'name': 'WBSEDCL',
      'fullName': 'West Bengal State Electricity Dist. Co.',
      'state': 'West Bengal',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFF00838F),
    },
    {
      'name': 'CESC',
      'fullName': 'Calcutta Electric Supply Corp.',
      'state': 'West Bengal',
      'icon': Icons.electric_meter_rounded,
      'color': Color(0xFF37474F),
    },
    // Madhya Pradesh
    {
      'name': 'MPPKVVCL',
      'fullName': 'MP Paschim Kshetra Vidyut Vitaran Co.',
      'state': 'Madhya Pradesh',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFFF57F17),
    },
    {
      'name': 'MPEZ',
      'fullName': 'MP Poorv Kshetra Vidyut Vitaran Co.',
      'state': 'Madhya Pradesh',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFFF9A825),
    },
    // Rajasthan
    {
      'name': 'JVVNL',
      'fullName': 'Jaipur Vidyut Vitran Nigam Ltd',
      'state': 'Rajasthan',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFFBF360C),
    },
    {
      'name': 'AVVNL',
      'fullName': 'Ajmer Vidyut Vitran Nigam Ltd',
      'state': 'Rajasthan',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFFD84315),
    },
    // Gujarat
    {
      'name': 'DGVCL',
      'fullName': 'Dakshin Gujarat Vij Co. Ltd',
      'state': 'Gujarat',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFF00695C),
    },
    {
      'name': 'UGVCL',
      'fullName': 'Uttar Gujarat Vij Co. Ltd',
      'state': 'Gujarat',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFF00796B),
    },
    // Odisha
    {
      'name': 'TPCODL',
      'fullName': 'TP Central Odisha Distribution Ltd',
      'state': 'Odisha',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFF558B2F),
    },
    {
      'name': 'TPSODL',
      'fullName': 'TP Southern Odisha Distribution Ltd',
      'state': 'Odisha',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFF33691E),
    },
    // Assam
    {
      'name': 'APDCL',
      'fullName': 'Assam Power Distribution Co. Ltd',
      'state': 'Assam',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFF4E342E),
    },
    // Haryana
    {
      'name': 'UHBVN',
      'fullName': 'Uttar Haryana Bijli Vitran Nigam',
      'state': 'Haryana',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFF01579B),
    },
    {
      'name': 'DHBVN',
      'fullName': 'Dakshin Haryana Bijli Vitran Nigam',
      'state': 'Haryana',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFF0277BD),
    },
    // Punjab
    {
      'name': 'PSPCL',
      'fullName': 'Punjab State Power Corp. Ltd',
      'state': 'Punjab',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFF1A237E),
    },
  ];

  List<Map<String, dynamic>> get _filteredDiscoms {
    if (_searchQuery.isEmpty) return discoms;
    return discoms.where((d) {
      return d['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase()) ||
          d['fullName']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          d['state']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Map<String, List<Map<String, dynamic>>> get _groupedDiscoms {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var d in _filteredDiscoms) {
      final state = d['state'] as String;
      grouped[state] ??= [];
      grouped[state]!.add(d);
    }
    return grouped;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedDiscoms;
    final states = grouped.keys.toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Column(
          children: [

            // ══ HEADER ════════════════════════════════
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00695C), Color(0xFF009688)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [

                    // AppBar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Expanded(
                            child: Text(
                              'Electricity Bill',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),

                    // Title + Count
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 6),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.flash_on_rounded,
                                color: Colors.white, size: 26),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select Your Operator',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                '${discoms.length} boards across India',
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 14),
                            Icon(Icons.search_rounded,
                                color: Colors.grey.shade400, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (v) =>
                                    setState(() => _searchQuery = v),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87),
                                decoration: InputDecoration(
                                  hintText:
                                  'Search operator or state...',
                                  hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 14),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            if (_searchQuery.isNotEmpty)
                              IconButton(
                                icon: Icon(Icons.close_rounded,
                                    color: Colors.grey.shade400,
                                    size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ══ LIST ══════════════════════════════════
            Expanded(
              child: _filteredDiscoms.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 60,
                        color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text('No operator found',
                        style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15)),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                itemCount: states.length,
                itemBuilder: (_, si) {
                  final state = states[si];
                  final stateDiscoms = grouped[state]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // State Header
                      Padding(
                        padding:
                        const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius:
                                BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              state,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor
                                    .withOpacity(0.1),
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${stateDiscoms.length}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Operator Cards
                      ...stateDiscoms.map((d) => _buildOperatorCard(d)),

                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatorCard(Map<String, dynamic> d) {
    final Color color = d['color'] as Color;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ElectricityBillScreen(
              initialDiscom: d,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [

            // Icon Box
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(d['icon'] as IconData,
                  color: color, size: 28),
            ),

            const SizedBox(width: 16),

            // Name + Full Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d['name'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    d['fullName'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Arrow
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: color,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
