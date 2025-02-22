import 'api_service.dart';
import '../models/api_response.dart';
import '../models/auth_response.dart';
import '../models/user.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../providers/user_provider.dart';
import 'package:dio/dio.dart';
import '../main.dart';
import 'package:http_parser/http_parser.dart';
import '../config/app_config.dart';

class UserService {
  final ApiService _apiService = ApiService();

  // 登录
  Future<ApiResponse> login(String phone, String code) async {
    try {
      final response = await _apiService.post(
        '/api/auth/login',
        data: {
          'phone': phone,
          'code': code,
        },
      );

      if (response['code'] == 200) {
        final data = response['data'] as Map<String, dynamic>;
        final authResponse = AuthResponse.fromJson(data);
        // 设置全局 token
        _apiService.setToken(authResponse.token);
        return ApiResponse(
          code: 200,
          msg: response['message'] ?? '登录成功',
          data: authResponse,
        );
      } else {
        return ApiResponse(
          code: response['code'] ?? -1,
          msg: response['msg'] ?? '手机号或验证码错误',
        );
      }
    } catch (e) {
      print('登录失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  // 获取验证码
  Future<ApiResponse> getVerificationCode(String phone) async {
    try {
      final response = await _apiService.post(
        '/api/auth/send-code',
        data: {
          'phone': phone,
        },
      );

      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '发送失败',
        data: response['data'],
      );
    } catch (e) {
      print('获取验证码失败: $e');
      return ApiResponse(code: -1, msg: '发送验证码失败');
    }
  }

  // 获取用户资料
  Future<ApiResponse> getUserProfile(int userId) async {
    try {
      final response = await _apiService.get('/api/users/$userId');
      
      if (response['code'] == 200) {
        final data = response['data'] as Map<String, dynamic>;
        if (data['avatar'] != null && data['avatar'].toString().startsWith('/')) {
          data['avatar'] = '${AppConfig.baseUrl}${data['avatar']}';
        }
        return ApiResponse(
          code: 200,
          msg: response['message'] ?? '获取成功',
          data: User.fromJson(data),
        );
      } else {
        return ApiResponse(
          code: response['code'] ?? -1,
          msg: response['message'] ?? '获取用户信息失败',
        );
      }
    } catch (e) {
      print('获取用户资料失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  // 修改更新用户资料的方法
  Future<ApiResponse> updateUserProfile({
    String? nickname,
    String? bio,
    String? gender,
    String? birthday,
    String? location,
    File? avatar,
  }) async {
    try {
      final Map<String, dynamic> data = {
        if (nickname != null) 'nickname': nickname,
        if (bio != null) 'bio': bio,
        if (gender != null) 'gender': gender,
        if (birthday != null) 'birthday': birthday,
        if (location != null) 'location': location,
      };

      if (avatar != null) {
        String fileName = avatar.path.split('/').last;
        data['avatar'] = await MultipartFile.fromFile(
          avatar.path,
          filename: fileName,
          contentType: MediaType('image', 'jpeg'),
        );
      }

      final response = await _apiService.put(
        '/api/users/profile',
        data: data,
      );

      print('更新用户资料返回数据: $response');

      if (response['code'] == 200) {
        final data = response['data'] as Map<String, dynamic>;
        print('用户资料数据: $data');
        
        if (data['avatar'] != null && data['avatar'].toString().startsWith('/')) {
          data['avatar'] = '${AppConfig.baseUrl}${data['avatar']}';
        }
        print('处理后的头像URL: ${data['avatar']}');
        
        return ApiResponse(
          code: 200,
          msg: response['msg'] ?? '修改成功',
          data: User.fromJson(data),
        );
      } else {
        return ApiResponse(
          code: response['code'] ?? -1,
          msg: response['msg'] ?? '修改失败',
        );
      }
    } catch (e) {
      print('更新用户资料失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  Future<ApiResponse> followUser(int userId) async {
    try {
      final response = await _apiService.post('/api/users/$userId/follow');
      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '关注失败',
        data: response['data'],
      );
    } catch (e) {
      print('关注用户失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  Future<ApiResponse> unfollowUser(int userId) async {
    try {
      final response = await _apiService.delete('/api/users/$userId/follow');
      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '取消关注失败',
        data: response['data'],
      );
    } catch (e) {
      print('取消关注失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  Future<ApiResponse> getFollowers(int userId) async {
    try {
      final response = await _apiService.get('/api/users/$userId/followers');
      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '获取失败',
        data: response['data']?['items'] ?? [],  // 直接返回 items 数组
      );
    } catch (e) {
      print('获取粉丝列表失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  Future<ApiResponse> getFollowing(int userId) async {
    try {
      final response = await _apiService.get('/api/users/$userId/following');
      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '获取失败',
        data: response['data']?['items'] ?? [],  // 直接返回 items 数组
      );
    } catch (e) {
      print('获取关注列表失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }
}
