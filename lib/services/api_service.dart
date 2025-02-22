import 'package:dio/dio.dart';
import '../config/app_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;
  String? _token;

  ApiService._internal() {
    _dio = Dio();
    _dio.options.baseUrl = AppConfig.baseUrl;
    _dio.options.connectTimeout = Duration(seconds: 30);
    _dio.options.receiveTimeout = Duration(seconds: 30);
    _dio.options.sendTimeout = Duration(seconds: 30);
    
    // 添加请求拦截器，确保每个请求都带上 token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        return handler.next(options);
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  // 设置 token 的方法
  void setToken(String? token) {
    _token = token;
    // 更新 dio 的默认 headers
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  // GET 请求封装
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      print('发送GET请求: $path');
      print('请求参数: $queryParameters');
      print('请求头: ${_dio.options.headers}');

      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      print('GET请求返回数据: ${response.data}');
      return response.data;
    } catch (e) {
      print('GET请求错误: $e');
      rethrow;
    }
  }

  // POST 请求封装
  Future<Map<String, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
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
  }) async {
    try {
      // 创建 FormData
      FormData formData = FormData.fromMap(data ?? {});
      
      // 设置请求头，不再需要单独处理 token
      final options = Options(
        headers: {
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

  // DELETE 请求封装
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data ?? {};
    } catch (e) {
      print('DELETE请求错误: $e');
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
