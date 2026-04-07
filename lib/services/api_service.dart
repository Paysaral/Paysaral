import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // 🔥 PAYSARAL BOSS: Agar aapne IP badla tha (jaise 192.168...), toh wahi rakhiyega!
  static const String baseUrl = 'http://192.168.31.213:8000/api';

  // =========================================================================
  // 🛡️ 1. SECURE RECHARGE API (Token ke sath)
  // =========================================================================
  static Future<Map<String, dynamic>> processRecharge(String mobile, String operator, String amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('paysaral_token');

    if (token == null) {
      return {'success': false, 'message': 'Authentication failed. Please login again!'};
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/recharge'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'mobile': mobile,
          'operator': operator,
          'amount': amount,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Server se connect nahi ho paya. $e'};
    }
  }

  // =========================================================================
  // 💰 2. GET REAL WALLET BALANCES (MAIN & AEPS)
  // =========================================================================
  static Future<Map<String, String>> getWalletBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('paysaral_token');

    if (token == null) return {"main": "0.00", "aeps": "0.00"};

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wallet/balance'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return {
            "main": data['balance'].toString(),
            "aeps": (data['aeps_balance'] ?? 0.00).toString(),
          };
        }
      }
      return {"main": "0.00", "aeps": "0.00"};
    } catch (e) {
      return {"main": "0.00", "aeps": "0.00"};
    }
  }

  // =========================================================================
  // 👤 3. GET REAL USER PROFILE DATA (PAYSARAL BOSS)
  // =========================================================================
  static Future<Map<String, dynamic>> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('paysaral_token');

    if (token == null) return {'success': false, 'message': 'Aapka Token missing hai, kripya dobara Login karein!'};

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // 🔥 JADOO: Ab agar 500 error bhi aayega, toh hum asli error nikalenge
      try {
        final data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          return data; // Success case
        } else {
          // Agar token expire hai toh ye batayega
          return {'success': false, 'message': data['message'] ?? 'Server ne Status ${response.statusCode} bheja'};
        }
      } catch (e) {
        // Agar Laravel ne JSON ke bajaye HTML error (Crashed) bhej diya
        return {'success': false, 'message': 'Laravel Crash Ho Gaya! Status: ${response.statusCode}. Body: ${response.body}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection Error: $e'};
    }
  }
}