import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'app_colors.dart';

class MobileRechargeScreen extends StatefulWidget {
  const MobileRechargeScreen({super.key});

  @override
  State<MobileRechargeScreen> createState() => _MobileRechargeScreenState();
}

class _MobileRechargeScreenState extends State<MobileRechargeScreen> {
  final TextEditingController _phoneController = TextEditingController();

  // ✅ FIX: प्रीपेड और पोस्टपेड के लिए अलग-अलग अमाउंट कंट्रोलर
  final TextEditingController _prepaidAmountController = TextEditingController();
  final TextEditingController _postpaidAmountController = TextEditingController();

  final FocusNode _phoneFocus = FocusNode();

  bool isPrepaid = true;
  int _currentOfferIndex = 0;

  String selectedPrepaidOperator = 'Airtel';
  String selectedPrepaidCircle = 'Jharkhand';

  String selectedPostpaidOperator = 'Jio';
  String selectedPostpaidCircle = 'Jharkhand';

  final List<Map<String, dynamic>> operatorsList = [
    {'name': 'Airtel', 'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Airtel_logo.png/512px-Airtel_logo.png', 'color': Colors.red},
    {'name': 'Jio', 'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Reliance_Jio_Logo_%28October_2015%29.svg/512px-Reliance_Jio_Logo_%28October_2015%29.svg.png', 'color': Colors.blue.shade700},
    {'name': 'Vi', 'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Vodafone_Idea_logo.svg/512px-Vodafone_Idea_logo.svg.png', 'color': Colors.redAccent},
    {'name': 'BSNL', 'logo': 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e0/BSNL_logo.svg/512px-BSNL_logo.svg.png', 'color': Colors.blueAccent},
  ];

  final List<String> circlesList = ['Jharkhand', 'Bihar', 'Delhi', 'Mumbai', 'West Bengal', 'Assam', 'Odisha', 'UP East', 'UP West'];

  final List<Map<String, dynamic>> recentRecharges = [
    {'name': 'Rahul Singh', 'number': '9876543210', 'operator': 'Jio'},
    {'name': 'Mom', 'number': '9123456789', 'operator': 'Airtel'},
    {'name': 'Shop WiFi', 'number': '9988776655', 'operator': 'Vi'},
    {'name': 'Papa', 'number': '9431000000', 'operator': 'Airtel'},
    {'name': 'Amit', 'number': '9123412345', 'operator': 'Jio'},
    {'name': 'Office', 'number': '9988001122', 'operator': 'Vi'},
    {'name': 'Rakesh Bhai', 'number': '9898989898', 'operator': 'BSNL'},
  ];

  final List<String> quickAmounts = ['₹199', '₹299', '₹349', '₹666'];

  final List<String> offerImages = [
    'assets/images/bg1.png',
    'https://img.freepik.com/premium-photo/digital-payment-technology-graphic_53876-113543.jpg',
    'https://img.freepik.com/premium-photo/online-shopping-digital-marketing_53876-113539.jpg',
    'https://img.freepik.com/premium-photo/mobile-banking-money-transfer_53876-113538.jpg'
  ];

  final List<Color> dotColors = [
    Colors.orange, Colors.blue, Colors.purple, Colors.redAccent, Colors.teal
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _prepaidAmountController.dispose();
    _postpaidAmountController.dispose();
    _phoneFocus.dispose();
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

  void _showOperatorCircleBottomSheet(BuildContext context) {
    int step = 1;
    String tempOp = isPrepaid ? selectedPrepaidOperator : selectedPostpaidOperator;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.55,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(height: 5, width: 50, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      if (step == 2) IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.arrow_back), onPressed: () => setModalState(() => step = 1)),
                      if (step == 2) const SizedBox(width: 10),
                      Text(step == 1 ? 'Select Operator' : 'Select Circle', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: step == 1
                        ? ListView.separated(
                      itemCount: operatorsList.length,
                      separatorBuilder: (c, i) => const Divider(height: 1),
                      itemBuilder: (c, i) {
                        var op = operatorsList[i];
                        return ListTile(
                          leading: _buildLogo(op['name'], op['logo'], op['color'], 40),
                          title: Text(op['name'], style: const TextStyle(fontWeight: FontWeight.w500)),
                          trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                          onTap: () {
                            setModalState(() {
                              tempOp = op['name'];
                              step = 2;
                            });
                          },
                        );
                      },
                    )
                        : ListView.separated(
                      itemCount: circlesList.length,
                      separatorBuilder: (c, i) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(circlesList[index]),
                          onTap: () {
                            setState(() {
                              if (isPrepaid) {
                                selectedPrepaidOperator = tempOp;
                                selectedPrepaidCircle = circlesList[index];
                              } else {
                                selectedPostpaidOperator = tempOp;
                                selectedPostpaidCircle = circlesList[index];
                              }
                            });
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentOperator = isPrepaid ? selectedPrepaidOperator : selectedPostpaidOperator;
    String currentCircle = isPrepaid ? selectedPrepaidCircle : selectedPostpaidCircle;
    var opData = operatorsList.firstWhere((o) => o['name'] == currentOperator);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          title: const Text('Mobile Recharge', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                child: Column(
                  children: [
                    Container(
                      height: 45, padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isPrepaid = true),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(color: isPrepaid ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(10), boxShadow: isPrepaid ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : []),
                                child: Center(child: Text('Prepaid', style: TextStyle(color: isPrepaid ? AppColors.primaryColor : Colors.white, fontWeight: FontWeight.bold, fontSize: 15))),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isPrepaid = false),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(color: !isPrepaid ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(10), boxShadow: !isPrepaid ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : []),
                                child: Center(child: Text('Postpaid', style: TextStyle(color: !isPrepaid ? AppColors.primaryColor : Colors.white, fontWeight: FontWeight.bold, fontSize: 15))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]),
                      child: TextField(
                        controller: _phoneController, focusNode: _phoneFocus, keyboardType: TextInputType.number, maxLength: 10, style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          counterText: '', hintText: 'Enter Your M.No', hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w400, fontSize: 17),
                          border: InputBorder.none, prefixIcon: const Icon(Icons.phone_android, color: Colors.grey), suffixIcon: const Icon(Icons.contact_phone, color: AppColors.primaryColor), contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
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
                            _buildLogo(currentOperator, opData['logo'], opData['color'], 45),
                            const SizedBox(width: 12),
                            Text('$currentOperator • $currentCircle', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        TextButton(onPressed: () => _showOperatorCircleBottomSheet(context), child: const Text('Change', style: TextStyle(color: AppColors.accentColor, fontWeight: FontWeight.bold)))
                      ],
                    ),
                    const SizedBox(height: 25),

                    Text(isPrepaid ? 'Recharge Amount' : 'Bill Amount', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 8),
                    TextField(
                      // ✅ FIX: यहाँ जो टैब खुला है, उसी का कंट्रोलर इस्तेमाल होगा
                      controller: isPrepaid ? _prepaidAmountController : _postpaidAmountController,
                      keyboardType: TextInputType.number, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.currency_rupee, color: Colors.black87), hintText: '0',
                        suffixIcon: TextButton(onPressed: () {}, child: Text(isPrepaid ? 'Browse Plans' : 'View Bill', style: const TextStyle(color: AppColors.primaryColor))),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)), focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor, width: 2)),
                      ),
                    ),

                    if (isPrepaid) ...[
                      const SizedBox(height: 15),
                      Wrap(
                        spacing: 10,
                        children: quickAmounts.map((a) => ActionChip(
                            label: Text(a), backgroundColor: Colors.white, side: const BorderSide(color: Color(0xFFE0E0E0)),
                            // ✅ FIX: Quick Amount सिर्फ प्रीपेड वाले डब्बे में जाएगा
                            onPressed: () => _prepaidAmountController.text = a.replaceAll('₹', '')
                        )).toList(),
                      ),
                    ],

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity, height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                        child: Text(isPrepaid ? 'Proceed to Pay' : 'Pay Bill', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 40),

                    if (isPrepaid) ...[
                      const Text('Recent Recharges', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade200)
                        ),
                        child: Column(
                          children: recentRecharges.asMap().entries.map((entry) {
                            int idx = entry.key;
                            var recent = entry.value;
                            var opD = operatorsList.firstWhere((o) => o['name'] == recent['operator']);
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  leading: _buildLogo(recent['operator'], opD['logo'], opD['color'], 40),
                                  title: Text(recent['name'], style: const TextStyle(fontWeight: FontWeight.w500)),
                                  subtitle: Text('${recent['number']} • ${recent['operator']}', style: const TextStyle(fontSize: 12)),
                                  trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                                  onTap: () {
                                    _phoneController.text = recent['number'];
                                    setState(() {
                                      selectedPrepaidOperator = recent['operator'];
                                    });
                                  },
                                ),
                                if (idx != recentRecharges.length - 1)
                                  Divider(height: 1, color: Colors.grey.shade100, indent: 70, endIndent: 16),
                              ],
                            );
                          }).toList(),
                        ),
                      )
                    ] else ...[
                      Column(
                        children: [
                          CarouselSlider.builder(
                            itemCount: offerImages.length,
                            options: CarouselOptions(height: 100, viewportFraction: 1.0, enlargeCenterPage: false, autoPlay: true, autoPlayInterval: const Duration(seconds: 3), onPageChanged: (index, reason) { setState(() { _currentOfferIndex = index; }); }),
                            itemBuilder: (context, index, realIndex) {
                              String imagePath = offerImages[index];
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
                            children: offerImages.asMap().entries.map((entry) {
                              Color activeDotColor = dotColors[entry.key % dotColors.length];
                              return AnimatedContainer(duration: const Duration(milliseconds: 300), width: _currentOfferIndex == entry.key ? 18.0 : 8.0, height: 8.0, margin: const EdgeInsets.symmetric(horizontal: 4.0), decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: _currentOfferIndex == entry.key ? activeDotColor : Colors.grey.shade300));
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
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