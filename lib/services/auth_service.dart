import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // 🔥 PAYSARAL BOSS: Apna Base URL set karein
  // Agar Android Emulator use kar rahe hain toh 10.0.2.2 aayega
  // Agar asli mobile USB se laga kar test kar rahe hain, toh apne computer ka Wi-Fi IP daalein (Jaise: 192.168.1.5)
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // =========================================================================
  // 🔑 1. LOGIN API & SAVE TOKEN
  // =========================================================================
  static Future<Map<String, dynamic>> login(String mobile, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'mobile': mobile,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // 🔥 JAISE HI SUCCESS HOGA, TOKEN KO MOBILE KI TIJORI MEIN SAVE KARENGE 🔥
        if (data['success'] == true && data['token'] != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('paysaral_token', data['token']);
          await prefs.setString('user_role', data['user']['role']);
          await prefs.setString('user_name', data['user']['name']);
        }

        return data; // UI ko return kar denge taaki wo aage ka kaam kare
      } else {
        // Agar password galat hua ya koi aur error aayi
        final errorData = jsonDecode(response.body);
        return {'success': false, 'message': errorData['message'] ?? 'Login failed!'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Server se connect nahi ho paya. $e'};
    }
  }

  // =========================================================================
  // 🛡️ 2. GET SAVED TOKEN (Recharge karte waqt ye kaam aayega)
  // =========================================================================
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('paysaral_token');
  }

  // =========================================================================
  // 🚪 3. LOGOUT & CLEAR TOKEN
  // =========================================================================
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('paysaral_token');
    await prefs.remove('user_role');
    await prefs.remove('user_name');
  }
}