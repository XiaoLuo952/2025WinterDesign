import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import '../theme/app_theme.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final PostService _postService = PostService();
  List<Post> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      print('开始加载帖子列表...'); // 添加日志
      final response = await _postService.getPosts();
      print('获取到的响应数据: ${response.data}'); // 添加日志

      if (response.code == 200) {
        final data = response.data as Map<String, dynamic>;
        final items = data['data']?['items'] as List<dynamic>?; // 修改这里的数据访问路径

        print('解析到的帖子列表: $items'); // 添加日志

        if (items != null) {
          setState(() {
            _posts = items.map((data) => Post.fromJson(data)).toList();
            _isLoading = false;
          });
          print('转换后的帖子数量: ${_posts.length}'); // 添加日志
        }
      }
    } catch (e) {
      print('加载帖子失败: $e');
      print('错误堆栈: ${StackTrace.current}'); // 添加错误堆栈
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _loadPosts,
        child: MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          padding: EdgeInsets.all(10),
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            final post = _posts[index];
            // 根据图片比例计算卡片高度
            double imageHeight = 200; // 默认高度
            if (post.imageUrls.isNotEmpty) {
              // 这里可以添加图片预加载来获取实际比例
              // 暂时使用固定高度
              imageHeight = 200;
            }

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.imageUrls.isNotEmpty)
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        post.imageUrls.first,
                        height: imageHeight,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('图片加载错误: $error');
                          return Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: Icon(Icons.image_not_supported,
                                size: 40, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: post.authorAvatar != null &&
                                      post.authorAvatar!.isNotEmpty
                                  ? NetworkImage(post.authorAvatar!)
                                  : AssetImage(
                                          'assets/images/default_avatar.png')
                                      as ImageProvider,
                              backgroundColor: Colors.grey[200],
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                post.authorNickname,
                                style: TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              post.isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: post.isLiked ? Colors.red : Colors.grey,
                              size: 20,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${post.likesCount}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
