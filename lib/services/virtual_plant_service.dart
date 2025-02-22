import 'package:dio/dio.dart';
import '../models/api_response.dart';
import 'api_service.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class VirtualPlantService {
  final ApiService _apiService = ApiService();

  Future<ApiResponse> createVirtualPlant(String name) async {
    try {
      print('准备发送请求，参数：name = $name');
      final data = {'name': name};
      print('请求体：$data');

      final response = await _apiService.post(
        '/api/virtual-plant/newPlant',
        data: data,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('完整请求信息：');
      print('URL: /api/virtual-plant/newPlant');
      print('Method: POST');
      print('Headers: Content-Type: application/json');
      print('Body: $data');
      print('创建虚拟植物返回数据: $response');

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

  Future<ApiResponse> getVirtualPlant() async {
    try {
      final response = await _apiService.get('/api/virtual-plant');
      print('获取虚拟植物返回数据: $response');

      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '获取失败',
        data: response['data'],
      );
    } catch (e) {
      print('获取虚拟植物失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  Future<ApiResponse> waterPlant() async {
    try {
      final response = await _apiService.post(
        '/api/virtual-plant/water',
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('浇水返回数据: $response');

      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '浇水失败',
        data: response['data'],
      );
    } catch (e) {
      print('浇水失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  Future<ApiResponse> fertilizePlant() async {
    try {
      final response = await _apiService.post(
        '/api/virtual-plant/fertilize',
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('施肥返回数据: $response');

      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '施肥失败',
        data: response['data'],
      );
    } catch (e) {
      print('施肥失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  Future<ApiResponse> getTasks() async {
    try {
      final response = await _apiService.get('/api/virtual-plant/tasks');
      print('获取任务列表返回数据: $response');

      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '获取任务失败',
        data: response['data'],
      );
    } catch (e) {
      print('获取任务列表失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  Future<ApiResponse> completeTask(int taskId) async {
    try {
      final response = await _apiService.post(
        '/api/virtual-plant/tasks/$taskId/complete',
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('完成任务返回数据: $response');

      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '完成任务失败',
        data: response['data'],
      );
    } catch (e) {
      print('完成任务失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  Future<ApiResponse> getFruits() async {
    try {
      final response = await _apiService.get('/api/virtual-plant/fruits');
      print('获取果实图鉴返回数据: $response');

      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '获取果实失败',
        data: response['data'],
      );
    } catch (e) {
      print('获取果实图鉴失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }
} 