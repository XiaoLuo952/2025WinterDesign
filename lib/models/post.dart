import '../config/app_config.dart';

class Post {
  final int postId;
  final String title;
  final String content;
  final List<String> imageUrls;
  final String? authorAvatar;
  final String authorNickname;
  final int authorId;
  bool isLiked;
  int likesCount;
  final int commentsCount;
  final DateTime createdAt;

  Post({
    required this.postId,
    required this.title,
    required this.content,
    required this.imageUrls,
    this.authorAvatar,
    required this.authorNickname,
    required this.authorId,
    required this.isLiked,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    // 解析 images 字符串为 List
    List<String> parseImages(String imagesStr) {
      try {
        if (imagesStr == "[]") return [];
        
        // 将字符串转换为 List，只保留图片路径
        List<String> urls = imagesStr
            .substring(1, imagesStr.length - 1)  // 移除 []
            .split(',')
            .map((s) => s.trim().replaceAll('"', ''))  // 移除引号和空格
            .where((s) => s.isNotEmpty)
            .map((s) => '${AppConfig.baseUrl}$s')  // 添加 baseUrl
            .toList();
        
        return urls;
      } catch (e) {
        print('解析图片列表错误: $e');
        return [];
      }
    }

    // 设置默认的作者信息
    const defaultAvatar = '';
    const defaultNickname = '匿名用户';

    // 获取作者信息，添加日志
    final author = json['author'] as Map<String, dynamic>?;
    print('原始作者数据: $author');

    // 处理作者头像 URL
    final rawAvatar = author?['avatar'] as String?;
    final authorAvatar = rawAvatar != null && rawAvatar.isNotEmpty
        ? (rawAvatar.startsWith('http') ? rawAvatar : '${AppConfig.baseUrl}$rawAvatar')
        : defaultAvatar;

    final authorNickname = author?['nickname'] as String? ?? defaultNickname;
    
    print('处理后的作者信息: avatar=$authorAvatar, nickname=$authorNickname');

    final post = Post(
      postId: json['postId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      imageUrls: parseImages(json['images'] as String? ?? '[]'),
      authorAvatar: authorAvatar.isNotEmpty ? authorAvatar : null,
      authorNickname: authorNickname,
      authorId: author?['userId'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      likesCount: json['likesCount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );

    print('创建的帖子对象: ${post.authorAvatar}, ${post.authorNickname}');
    return post;
  }
} 