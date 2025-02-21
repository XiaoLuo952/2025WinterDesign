import 'package:dio/dio.dart';
import '../config/app_config.dart';

class ApiService {
  final Dio _dio;
  
  ApiService() : _dio = Dio() {
    _dio.options.baseUrl = AppConfig.baseUrl;
    _dio.options.connectTimeout = Duration(seconds: 30);
    _dio.options.receiveTimeout = Duration(seconds: 30);
    _dio.options.sendTimeout = Duration(seconds: 30);
    
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  // 添加请求拦截器，用于统一添加token等认证信息
  void init() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // 在这里添加token
        // options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
      onError: (error, handler) {
        // 统一错误处理
        return handler.next(error);
      },
    ));
  }

  // GET 请求封装
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST 请求封装
  Future<Map<String, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data ?? {};
    } catch (e) {
      print('请求错误: $e');
      rethrow;
    }
  }

  // PUT 请求封装
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    try {
      // 创建 FormData
      FormData formData = FormData.fromMap(data ?? {});
      
      // 设置请求头
      final options = Options(
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      );

      final response = await _dio.put(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } catch (e) {
      print('PUT请求错误: $e');
      rethrow;
    }
  }

  // 统一错误处理
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return Exception('连接超时');
        case DioExceptionType.sendTimeout:
          return Exception('请求超时');
        case DioExceptionType.receiveTimeout:
          return Exception('响应超时');
        case DioExceptionType.badResponse:
          return Exception('服务器错误: ${error.response?.statusCode}');
        default:
          return Exception('网络错误');
      }
    }
    return Exception('未知错误');
  }
}
