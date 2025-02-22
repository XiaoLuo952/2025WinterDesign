import 'package:dio/dio.dart';
import 'dart:io';
import '../models/api_response.dart';
import 'api_service.dart';

class PostService {
  final ApiService _apiService = ApiService();

  Future<ApiResponse> createPost({
    required String title,
    required String content,
    List<File>? images,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'title': title,
        'content': content,
      };

      // 如果有图片，添加到请求中
      if (images != null && images.isNotEmpty) {
        final imageFiles = await Future.wait(
          images.map((file) async {
            String fileName = file.path.split('/').last;
            return await MultipartFile.fromFile(
              file.path,
              filename: fileName,
            );
          }),
        );
        data['images'] = imageFiles;
      }

      final response = await _apiService.post(
        '/api/posts',
        data: FormData.fromMap(data),
      );

      print('发帖请求数据: $data');
      print('发帖返回数据: $response');

      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '发布失败',
        data: response['data'],
      );
    } catch (e) {
      print('发帖失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  // 添加获取帖子列表的方法
  Future<ApiResponse> getPosts({
    String type = 'discover',
    int page = 1,
    int limit = 10,
  }) async {
    try {
      print('发送请求，type: $type');
      final response = await _apiService.get(
        '/api/posts',
        queryParameters: {
          'type': type,
          'page': page,
          'limit': limit,
        },
      );

      print('请求参数: ${{'type': type, 'page': page, 'limit': limit}}');
      print('获取帖子列表返回数据: $response');

      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '获取失败',
        data: response['data'],
      );
    } catch (e) {
      print('获取帖子列表失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  Future<ApiResponse> getPostDetail(int postId) async {
    try {
      final response = await _apiService.get('/api/posts/$postId');

      print('获取帖子详情返回数据: $response');

      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '获取失败',
        data: response['data'],
      );
    } catch (e) {
      print('获取帖子详情失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  Future<ApiResponse> likePost(int postId) async {
    try {
      final response = await _apiService.post('/api/posts/$postId/like');
      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '点赞失败',
        data: response['data'],
      );
    } catch (e) {
      print('点赞失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  Future<ApiResponse> unlikePost(int postId) async {
    try {
      final response = await _apiService.delete('/api/posts/$postId/like');
      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '取消点赞失败',
        data: response['data'],
      );
    } catch (e) {
      print('取消点赞失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  Future<ApiResponse> getComments(int postId) async {
    try {
      final response = await _apiService.get('/api/posts/$postId/comments');
      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '获取评论失败',
        data: response['data'],
      );
    } catch (e) {
      print('获取评论失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  Future<ApiResponse> createComment(int postId, String content) async {
    try {
      final response = await _apiService.post(
        '/api/posts/$postId/comments',
        data: {
          'content': content,
        },
      );
      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '发送评论失败',
        data: response['data'],
      );
    } catch (e) {
      print('发送评论失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  Future<ApiResponse> likeComment(int commentId) async {
    try {
      final response = await _apiService.post('/api/comments/$commentId/like');
      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '点赞失败',
        data: response['data'],
      );
    } catch (e) {
      print('评论点赞失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  Future<ApiResponse> unlikeComment(int commentId) async {
    try {
      final response =
          await _apiService.delete('/api/comments/$commentId/like');
      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '取消点赞失败',
        data: response['data'],
      );
    } catch (e) {
      print('取消评论点赞失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }

  Future<ApiResponse> getFollowingPosts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiService.get(
        '/api/posts',
        queryParameters: {
          'type': 'following',
          'page': page,
          'limit': limit,
        },
      );
      return ApiResponse(
        code: response['code'] ?? -1,
        msg: response['msg'] ?? '获取失败',
        data: response['data'],
      );
    } catch (e) {
      print('获取关注用户帖子失败: $e');
      return ApiResponse(code: -1, msg: '网络错误');
    }
  }
}
