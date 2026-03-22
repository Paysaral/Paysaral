import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'app_colors.dart';

class DthRechargeScreen extends StatefulWidget {
  const DthRechargeScreen({super.key});

  @override
  State<DthRechargeScreen> createState() => _DthRechargeScreenState();
}

class _DthRechargeScreenState extends State<DthRechargeScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _idFocus = FocusNode();

  int _currentOfferIndex = 0;

  final List<Map<String, dynamic>> operatorsList = [
    {'name': 'Tata Play', 'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7b/Tata_Play_2022_logo.svg/512px-Tata_Play_2022_logo.svg.png', 'color': Colors.purple},
    {'name': 'Airtel Digital TV', 'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Airtel_logo.png/512px-Airtel_logo.png', 'color': Colors.red},
    {'name': 'Dish TV', 'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Dish_TV_India_logo.svg/512px-Dish_TV_India_logo.svg.png', 'color': Colors.orange},
    {'name': 'Sun Direct', 'logo': 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e6/Sun_Direct_logo.svg/512px-Sun_Direct_logo.svg.png', 'color': Colors.yellow.shade700},
    {'name': 'Videocon D2H', 'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Videocon_d2h_Logo.svg/512px-Videocon_d2h_Logo.svg.png', 'color': Colors.green},
  ];

  final List<String> dthOfferImages = [
    'assets/images/bg1.png',
    'https://img.freepik.com/premium-photo/digital-payment-technology-graphic_53876-113543.jpg',
    'https://img.freepik.com/premium-photo/online-shopping-digital-marketing_53876-113539.jpg',
    'https://img.freepik.com/premium-photo/mobile-banking-money-transfer_53876-113538.jpg'
  ];

  final List<Color> dotColors = [
    Colors.orange, Colors.blue, Colors.purple, Colors.redAccent, Colors.teal
  ];

  String selectedOperator = 'Tata Play';
  final List<String> quickAmounts = ['₹200', '₹300', '₹500', '₹1000'];

  @override
  void dispose() {
    _idController.dispose();
    _amountController.dispose();
    _idFocus.dispose();
    super.dispose();
  }

  Widget _buildLogo(String name, String url, Color color, double size) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)),
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.network(
            url, fit: BoxFit.contain,
            errorBuilder: (c, e, s) => Center(child: Text(name[0], style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: size * 0.4))),
          ),
        ),
      ),
    );
  }

  void _showOperatorSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.55,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(height: 5, width: 50, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 20),
              const Text('Select DTH Operator', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              Expanded(
                child: ListView.separated(
                  itemCount: operatorsList.length,
                  separatorBuilder: (c, i) => const Divider(height: 1),
                  itemBuilder: (c, i) {
                    var op = operatorsList[i];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                      leading: _buildLogo(op['name'], op['logo'], op['color'], 40),
                      title: Text(op['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                      onTap: () {
                        setState(() => selectedOperator = op['name']);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var opData = operatorsList.firstWhere((o) => o['name'] == selectedOperator);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          title: const Text('DTH Recharge', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                ),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]),
                  child: TextField(
                    controller: _idController, focusNode: _idFocus, keyboardType: TextInputType.text, maxLength: 20, style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      counterText: '', hintText: 'Enter Subscriber ID / VC No.', hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w400, fontSize: 17),
                      border: InputBorder.none, prefixIcon: const Icon(Icons.tv, color: Colors.grey), suffixIcon: const Icon(Icons.contact_mail, color: AppColors.primaryColor), contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _buildLogo(selectedOperator, opData['logo'], opData['color'], 45),
                            const SizedBox(width: 12),
                            Text(selectedOperator, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        TextButton(onPressed: () => _showOperatorSheet(context), child: const Text('Change', style: TextStyle(color: AppColors.accentColor, fontWeight: FontWeight.bold)))
                      ],
                    ),
                    const SizedBox(height: 25),

                    const Text('Recharge Amount', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _amountController, keyboardType: TextInputType.number, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.currency_rupee, color: Colors.black87), hintText: '0',
                        suffixIcon: TextButton(onPressed: () {}, child: const Text('Customer Info', style: TextStyle(color: AppColors.primaryColor))),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)), focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor, width: 2)),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Wrap(
                      spacing: 10,
                      children: quickAmounts.map((a) => ActionChip(label: Text(a), backgroundColor: Colors.white, side: const BorderSide(color: Color(0xFFE0E0E0)), onPressed: () => _amountController.text = a.replaceAll('₹', ''))).toList(),
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity, height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                        child: const Text('Proceed to Pay', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),

                    const SizedBox(height: 40),

                    Column(
                      children: [
                        CarouselSlider.builder(
                          itemCount: dthOfferImages.length,
                          options: CarouselOptions(height: 100, viewportFraction: 1.0, enlargeCenterPage: false, autoPlay: true, autoPlayInterval: const Duration(seconds: 3), onPageChanged: (index, reason) { setState(() { _currentOfferIndex = index; }); }),
                          itemBuilder: (context, index, realIndex) {
                            String imagePath = dthOfferImages[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: imagePath.startsWith('http')
                                    ? Image.network(imagePath, fit: BoxFit.fill, width: double.infinity, errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade300, child: const Center(child: Icon(Icons.image, color: Colors.grey))))
                                    : Image.asset(imagePath, fit: BoxFit.fill, width: double.infinity, errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade300, child: const Center(child: Icon(Icons.image, color: Colors.grey)))),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: dthOfferImages.asMap().entries.map((entry) {
                            Color activeDotColor = dotColors[entry.key % dotColors.length];
                            return AnimatedContainer(duration: const Duration(milliseconds: 300), width: _currentOfferIndex == entry.key ? 18.0 : 8.0, height: 8.0, margin: const EdgeInsets.symmetric(horizontal: 4.0), decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: _currentOfferIndex == entry.key ? activeDotColor : Colors.grey.shade300));
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}