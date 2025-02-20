import 'package:dio/dio.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://apifoxmock.com/m1/5849282-5535156-default',
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
    contentType: 'application/json',
    responseType: ResponseType.json,
  ));

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
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      print('请求地址: ${_dio.options.baseUrl}$path');  // 添加调试输出
      print('请求参数: $data');  // 添加调试输出
      
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
      print('响应数据: ${response.data}');  // 添加调试输出
      return response.data;
    } catch (e) {
      print('请求错误: $e');  // 添加调试输出
      throw _handleError(e);
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
