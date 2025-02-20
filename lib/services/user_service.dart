import 'api_service.dart';
import '../models/api_response.dart';
import '../models/auth_response.dart';

class UserService {
  final ApiService _apiService = ApiService();

  // 登录
  Future<ApiResponse<AuthResponse>> login(String phone, String code) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/api/auth/login',
        data: {
          'phone': phone,
          'code': code,
        },
      );
      
      return ApiResponse.fromJson(
        response,
        (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('登录失败：$e');
    }
  }

  // 获取验证码
  Future<ApiResponse<void>> getVerificationCode(String phone) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/api/auth/send-code',
        data: {
          'phone': phone,
        },
      );
      
      return ApiResponse.fromJson(response, (_) => null);
    } catch (e) {
      throw Exception('获取验证码失败：$e');
    }
  }
} 