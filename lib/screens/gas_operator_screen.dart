import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'gas_bill_screen.dart'; // ✅ Asli Gas Bill Screen ka link

class GasOperatorScreen extends StatefulWidget {
  const GasOperatorScreen({super.key});

  @override
  State<GasOperatorScreen> createState() => _GasOperatorScreenState();
}

class _GasOperatorScreenState extends State<GasOperatorScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // ✅ Gas Operators List (LPG and PNG pipelines)
  final List<Map<String, dynamic>> gasOperators = [
    // LPG Cylinders
    {'name': 'Indane Gas (IOCL)', 'fullName': 'Indian Oil Corporation Ltd.', 'type': 'LPG Cylinder', 'icon': Icons.local_fire_department_rounded, 'color': Color(0xFFF57C00)},
    {'name': 'Bharat Gas (BPCL)', 'fullName': 'Bharat Petroleum', 'type': 'LPG Cylinder', 'icon': Icons.local_fire_department_rounded, 'color': Color(0xFF1976D2)},
    {'name': 'HP Gas (HPCL)', 'fullName': 'Hindustan Petroleum', 'type': 'LPG Cylinder', 'icon': Icons.local_fire_department_rounded, 'color': Color(0xFFD32F2F)},

    // PNG Pipelines
    {'name': 'Adani Total Gas', 'fullName': 'Adani Gas Pipeline', 'type': 'PNG Pipeline', 'icon': Icons.gas_meter_rounded, 'color': Color(0xFF388E3C)},
    {'name': 'IGL (Indraprastha)', 'fullName': 'Indraprastha Gas Limited Delhi', 'type': 'PNG Pipeline', 'icon': Icons.gas_meter_rounded, 'color': Color(0xFF0288D1)},
    {'name': 'MGL (Mahanagar)', 'fullName': 'Mahanagar Gas Mumbai', 'type': 'PNG Pipeline', 'icon': Icons.gas_meter_rounded, 'color': Color(0xFFFBC02D)},
    {'name': 'Gujarat Gas', 'fullName': 'Gujarat Gas Limited', 'type': 'PNG Pipeline', 'icon': Icons.gas_meter_rounded, 'color': Color(0xFF00796B)},
    {'name': 'Haryana City Gas', 'fullName': 'Haryana City Gas', 'type': 'PNG Pipeline', 'icon': Icons.gas_meter_rounded, 'color': Color(0xFF558B2F)},
    {'name': 'Torrent Gas', 'fullName': 'Torrent Gas Private Limited', 'type': 'PNG Pipeline', 'icon': Icons.gas_meter_rounded, 'color': Color(0xFFE65100)},
    {'name': 'MNGL', 'fullName': 'Maharashtra Natural Gas Ltd', 'type': 'PNG Pipeline', 'icon': Icons.gas_meter_rounded, 'color': Color(0xFF1565C0)},
    {'name': 'Aavantika Gas', 'fullName': 'Aavantika Gas Ltd (Indore, Gwalior)', 'type': 'PNG Pipeline', 'icon': Icons.gas_meter_rounded, 'color': Color(0xFF6A1B9A)},
  ];

  List<Map<String, dynamic>> get _filteredOperators {
    if (_searchQuery.isEmpty) return gasOperators;
    return gasOperators.where((d) {
      return d['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase()) ||
          d['fullName']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          d['type']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // ✅ Grouping logic based on LPG vs PNG
  Map<String, List<Map<String, dynamic>>> get _groupedOperators {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var op in _filteredOperators) {
      final type = op['type'] as String;
      grouped[type] ??= [];
      grouped[type]!.add(op);
    }
    return grouped;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ✅ JADOO: Fixed Bottom White Strip for Bharat Connect Logo (Added Here)
  Widget _buildFixedBharatConnectFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Powered by', style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/bharat_connect.png',
              height: 32, // Height set to 32 as requested
              errorBuilder: (context, error, stackTrace) {
                return Row(
                  children: [
                    const Icon(Icons.hub_rounded, color: Color(0xFF003A70), size: 20),
                    const SizedBox(width: 4),
                    const Text('Bharat', style: TextStyle(color: Color(0xFF003A70), fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 0.3)),
                    const Text('Connect', style: TextStyle(color: Color(0xFFF37021), fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 0.3)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedOperators;
    final types = grouped.keys.toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        bottomNavigationBar: _buildFixedBharatConnectFooter(), // ✅ Added Fixed Footer Here
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Expanded(
                            child: Text(
                              'Book Cylinder / Gas Bill',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
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
                            child: const Icon(Icons.gas_meter_rounded, color: Colors.white, size: 26),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select Your Provider',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                '${gasOperators.length} providers across India',
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
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
                            Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (v) => setState(() => _searchQuery = v),
                                style: const TextStyle(fontSize: 14, color: Colors.black87),
                                decoration: InputDecoration(
                                  hintText: 'Search provider or type...',
                                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            if (_searchQuery.isNotEmpty)
                              IconButton(
                                icon: Icon(Icons.close_rounded, color: Colors.grey.shade400, size: 18),
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
              child: _filteredOperators.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off_rounded, size: 60, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text('No provider found', style: TextStyle(color: Colors.grey.shade400, fontSize: 15)),
                  ],
                ),
              )
                  : ListView.builder(
                physics: const ClampingScrollPhysics(), // Added smooth scrolling
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                itemCount: types.length,
                itemBuilder: (_, ti) {
                  final type = types[ti];
                  final typeOperators = grouped[type]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // LPG/PNG Header
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              type, // "LPG Cylinder" or "PNG Pipeline"
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black87),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${typeOperators.length}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Operator Cards
                      ...typeOperators.map((d) => _buildOperatorCard(d)),

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
        // ✅ JADOO: Yahan GasBillScreen par navigate karte waqt selected operator bhej rahe hain
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GasBillScreen(
              initialOperator: d,
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
              child: Icon(d['icon'] as IconData, color: color, size: 28),
            ),

            const SizedBox(width: 16),

            // Name + Full Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d['name'],
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    d['fullName'],
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500, height: 1.3),
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
              child: Icon(Icons.arrow_forward_ios_rounded, color: color, size: 14),
            ),
          ],
        ),
      ),
    );
  }
}