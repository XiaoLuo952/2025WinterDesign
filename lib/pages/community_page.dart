import 'package:flutter/material.dart';
import '../services/post_service.dart';
import '../models/api_response.dart';
import '../config/app_config.dart';
import '../models/post.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final PostService _postService = PostService();
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    print('CommunityPage initState 被调用');
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    print('_loadPosts 方法被调用');
    try {
      print('开始加载帖子列表...');
      print('调用 PostService.getPosts()');
      final response = await _postService.getPosts();
      print('社区帖子列表返回数据: $response');
      
      if (response.code == 200) {
        print('帖子列表数据: ${response.data}');
        setState(() {
          _posts = (response.data['items'] as List)
              .map((item) => Post.fromJson(item))
              .toList();
        });
      } else {
        print('加载失败: ${response.msg}');
      }
    } catch (e) {
      print('加载帖子列表失败: $e');
    }
  }

  Future<void> _toggleLike(Post post) async {
    try {
      final response = post.isLiked
          ? await _postService.unlikePost(post.postId)
          : await _postService.likePost(post.postId);

      if (response.code == 200) {
        setState(() {
          post.isLiked = !post.isLiked;
          post.likesCount = post.isLiked 
              ? post.likesCount + 1 
              : post.likesCount - 1;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.msg)),
        );
      }
    } catch (e) {
      print('点赞操作失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('操作失败，请稍后重试')),
      );
    }
  }

  Future<void> _loadFollowingPosts() async {
    try {
      final response = await _postService.getFollowingPosts();
      if (response.code == 200) {
        setState(() {
          _posts = (response.data['items'] as List)
              .map((item) => Post.fromJson(item))
              .toList();
        });
      }
    } catch (e) {
      print('加载关注用户帖子失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _loadPosts,
        child: FutureBuilder<ApiResponse>(
          future: _postService.getPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data?.code != 200) {
              return Center(child: Text('加载失败'));
            }

            final posts = (snapshot.data!.data['items'] as List)
                .map((item) => Post.fromJson(item))
                .toList();

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: post.authorAvatar != null
                              ? NetworkImage(post.authorAvatar!)
                              : AssetImage('assets/images/default_avatar.png')
                                  as ImageProvider,
                        ),
                        title: Text(post.title),
                        subtitle: Text(post.authorNickname),
                      ),
                      if (post.imageUrls.isNotEmpty)
                        Image.network(
                          post.imageUrls.first,
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(post.content),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                post.isLiked ? Icons.favorite : Icons.favorite_border,
                                color: post.isLiked ? Colors.red : Colors.grey,
                              ),
                              onPressed: () => _toggleLike(post),
                            ),
                            Text('${post.likesCount}'),
                            SizedBox(width: 16),
                            Icon(Icons.comment_outlined),
                            SizedBox(width: 4),
                            Text('${post.commentsCount}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
} 