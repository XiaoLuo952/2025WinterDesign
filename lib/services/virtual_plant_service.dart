import 'package:dio/dio.dart';
import '../models/api_response.dart';
import 'api_service.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class VirtualPlantService {
  final ApiService _apiService = ApiService();

  Future<ApiResponse> createVirtualPlant(String name, String token) async {
    try {
      final response = await _apiService.post(
        '/api/virtual-plant/newPlant',
        data: {
          'name': name,
        },
        headers: {
          'Authorization': token,
        },
      );

      print('创建虚拟植物返回数据: $response');  // 在控制台显示返回数据

      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '创建失败',
        data: response['data'],
      );
    } catch (e) {
      print('创建虚拟植物失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }
} 