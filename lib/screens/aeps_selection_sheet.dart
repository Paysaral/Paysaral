import 'package:flutter/material.dart';
import 'app_colors.dart'; // ✅ Asli AppColors use kar rahe hain
import 'aeps_screen.dart';

// यह फंक्शन कहीं से भी कॉल किया जा सकता है
void showAepsSelectionSheet(BuildContext context, bool isB2B) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _AepsSelectionWidget(isB2B: isB2B),
  );
}

class _AepsSelectionWidget extends StatelessWidget {
  final bool isB2B;

  const _AepsSelectionWidget({required this.isB2B});

  @override
  Widget build(BuildContext context) {
    // ✅ Using your Original AppColors
    const Color mainTeal = AppColors.primaryColor; // 0xFF009688
    const Color deepGreen = AppColors.deepMenuColor; // 0xFF004D40
    const Color accentLight = AppColors.accentColor; // 0xFF67C949

    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 20, spreadRadius: 2)
          ]
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            // टॉप ड्रैग हैंडल
            Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)
                )
            ),
            const SizedBox(height: 24),

            // हेडर सेक्शन (Teal Color)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: mainTeal.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.touch_app_rounded, color: mainTeal, size: 26),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                      'Select AEPS Server',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: mainTeal)
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                  'Choose a secure server to process biometric transactions seamlessly.',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13, height: 1.4)
              ),
            ),
            const SizedBox(height: 28),

            // सर्वर कार्ड्स
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildPremiumServerCard(
                      context: context,
                      title: 'AEPS Server 1',
                      subtitle: 'High success rate & instant settlement',
                      iconColor: deepGreen, // फिंगरप्रिंट Deep Green
                      borderColor: mainTeal, // बॉर्डर Teal
                      arrowColor: accentLight, // एरो Light Green
                      apiType: 'eko'
                  ),
                  const SizedBox(height: 16),
                  _buildPremiumServerCard(
                      context: context,
                      title: 'AEPS Server 2',
                      subtitle: 'Stable connection for rural areas',
                      iconColor: deepGreen, // फिंगerprint Deep Green
                      borderColor: mainTeal, // बॉर्डर Teal
                      arrowColor: accentLight, // एरो Light Green
                      apiType: 'paysprint'
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // 100% Safe, Secure & Reliable Tag
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: mainTeal.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: mainTeal.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.verified_user_rounded, size: 18, color: deepGreen),
                  const SizedBox(width: 8),
                  Text(
                    '100% Safe, Secure & Reliable',
                    style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: deepGreen,
                        letterSpacing: 0.3
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // स्लीक और प्रीमियम कार्ड बिल्डर
  Widget _buildPremiumServerCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color borderColor,
    required Color arrowColor,
    required String apiType,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => AepsScreen(isB2B: isB2B, selectedApi: apiType)));
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor.withOpacity(0.25), width: 1.2),
          boxShadow: [
            BoxShadow(color: borderColor.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 6))
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 52, width: 52,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.fingerprint_rounded, size: 28, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 11.5, height: 1.3)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: arrowColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: borderColor),
            ),
          ],
        ),
      ),
    );
  }
}