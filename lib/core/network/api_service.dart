import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

// 100% FULL & READY TO PASTE CODE
class ApiService {
  // अपनी API का Base URL यहाँ डालें (जब PHP बैकएंड रेडी हो जाए)
  static const String _baseUrl = 'https://api.paysaral.com/v1/';

  late Dio _dio;

  // Singleton Pattern ताकि पूरे ऐप में एक ही Instance इस्तेमाल हो
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio = Dio(options);

    // Interceptors: हर API कॉल के जाने से पहले और आने के बाद का लॉजिक
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // यहाँ आप Shared Preferences या Secure Storage से अपना Token निकाल कर डाल सकते हैं
        // String token = await getAuthToken();
        String token = "YOUR_SAVED_TOKEN_HERE"; // डमी टोकन

        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        if (kDebugMode) {
          print('==> API REQUEST: ${options.method} ${options.uri}');
          print('==> HEADERS: ${options.headers}');
          if (options.data is! FormData) {
            print('==> DATA: ${options.data}');
          } else {
            print('==> DATA: [FormData containing files/images]');
          }
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          print('<== API RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
          print('<== RESPONSE DATA: ${response.data}');
        }
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        if (kDebugMode) {
          print('XXX API ERROR: ${e.response?.statusCode} ${e.requestOptions.uri}');
          print('XXX ERROR MESSAGE: ${e.message}');
        }
        // यहाँ आप Global Error Handling कर सकते हैं (जैसे 401 पर Logout करवा देना)
        return handler.next(e);
      },
    ));
  }

  // GET Request
  Future<Response?> getRequest(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await _dio.get(endpoint, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      return e.response;
    } catch (e) {
      print("Unexpected Error: $e");
      return null;
    }
  }

  // POST Request
  Future<Response?> postRequest(String endpoint, {dynamic data}) async {
    try {
      Response response = await _dio.post(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      return e.response;
    } catch (e) {
      print("Unexpected Error: $e");
      return null;
    }
  }

  // PUT Request
  Future<Response?> putRequest(String endpoint, {dynamic data}) async {
    try {
      Response response = await _dio.put(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      return e.response;
    } catch (e) {
      print("Unexpected Error: $e");
      return null;
    }
  }

  // DELETE Request
  Future<Response?> deleteRequest(String endpoint, {dynamic data}) async {
    try {
      Response response = await _dio.delete(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      return e.response;
    } catch (e) {
      print("Unexpected Error: $e");
      return null;
    }
  }

  // MULTIPART Request (For Image/KYC Document Upload)
  Future<Response?> uploadFile(String endpoint, {required FormData formData}) async {
    try {
      Response response = await _dio.post(
        endpoint,
        data: formData,
        // Multipart के लिए अलग हेडर चाहिए होता है
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      _handleError(e);
      return e.response;
    } catch (e) {
      print("Unexpected Error: $e");
      return null;
    }
  }

  // Global Error Handler Helper Method
  void _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      print("Error: Connection Timeout. Please check your internet.");
    } else if (e.type == DioExceptionType.badResponse) {
      print("Error: Server responded with status code ${e.response?.statusCode}");
    } else if (e.type == DioExceptionType.connectionError) {
      print("Error: No Internet Connection");
    } else {
      print("Error: Something went wrong. ${e.message}");
    }
  }
}