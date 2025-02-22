import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/post.dart';
import '../models/api_response.dart';
import '../services/post_service.dart';
import '../config/app_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/user_service.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

const Color titleGreen = Color(0x3B78DF73); // #78DF733B

class PostDetailPage extends StatefulWidget {
  final Post post;

  const PostDetailPage({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final PostService _postService = PostService();
  final UserService _userService = UserService();
  Post? _detailPost; // 存储详细信息
  bool _isLoading = true;
  final TextEditingController _commentController = TextEditingController();
  bool _isLiked = false;
  int _likeCount = 0;
  int _commentCount = 0;
  bool _isFollowing = false; // 添加关注状态

  @override
  void initState() {
    super.initState();
    _loadPostDetail();
    _loadFollowStatus();
    // 初始化点赞状态和数量
    _isLiked = widget.post.isLiked;
    _likeCount = widget.post.likesCount;
  }

  Future<void> _loadPostDetail() async {
    try {
      final response = await _postService.getPostDetail(widget.post.postId);
      if (response.code == 200 && mounted) {
        setState(() {
          _detailPost = Post.fromJson(response.data);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('加载帖子详情失败: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadFollowStatus() async {
    try {
      final user =
          Provider.of<UserProvider>(context, listen: false).currentUser;
      if (user == null) return;

      final response = await _userService.getFollowing(user.userId);
      if (response.code == 200 && mounted) {
        final followingList = response.data as List;
        setState(() {
          // 检查帖子作者是否在关注列表中
          _isFollowing = followingList
              .any((user) => user['userId'] == widget.post.authorId);
        });
        print('作者ID: ${widget.post.authorId}, 是否关注: $_isFollowing');
      }
    } catch (e) {
      print('获取关注状态失败: $e');
    }
  }

  void _showCommentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text('发表评论',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(16).copyWith(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: TextField(
                controller: _commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: '说点什么...',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // 处理评论提交
                Navigator.pop(context);
              },
              child: Text('发布'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB1DF0B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 获取键盘高度
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.customGreen,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: widget.post.authorAvatar != null
                  ? NetworkImage(widget.post.authorAvatar!)
                  : AssetImage('assets/images/default_avatar.png')
                      as ImageProvider,
            ),
            SizedBox(width: 8),
            Text(
              widget.post.authorNickname,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        titleSpacing: 0, // 移除标题默认的左边距
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: _toggleFollow,
              child: Text(
                _isFollowing ? '已关注' : '关注',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: _isFollowing
                    ? Colors.grey.withOpacity(0.3)
                    : AppTheme.customGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片列表
            if (widget.post.imageUrls.isNotEmpty)
              Container(
                height: 300,
                width: double.infinity,
                child: PageView.builder(
                  itemCount: widget.post.imageUrls.length,
                  itemBuilder: (context, index) {
                    final imageUrl = widget.post.imageUrls[index]
                            .startsWith('http')
                        ? widget.post.imageUrls[index]
                        : '${AppConfig.baseUrl}${widget.post.imageUrls[index]}';

                    print('图片 URL: $imageUrl'); // 添加这行来查看完整的图片 URL

                    return CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported,
                                size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('图片加载失败',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            // 标题和内容
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    widget.post.content,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),  // 增加间距
                  Text(
                    widget.post.createdAt.toString().substring(0, 19).replaceAll('T', ' '),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              // 添加分割线
              height: 32,
              thickness: 1,
              color: Colors.grey[300],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<ApiResponse>(
                    future: _postService.getComments(widget.post.postId),
                    builder: (context, snapshot) {
                      // 先显示评论标题
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '评论',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            Center(child: CircularProgressIndicator()),
                          ],
                        );
                      }

                      final data = snapshot.data?.data as Map<String, dynamic>?;
                      final comments = data?['items'] as List? ?? [];
                      final total = data?['total'] as int? ?? 0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comments.isEmpty ? '评论' : '共$total条评论',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          if (comments.isEmpty)
                            Center(child: Text('暂无评论'))
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                final comment = comments[index];
                                // 处理头像 URL
                                String? avatarUrl;
                                if (comment['author'] != null &&
                                    comment['author']['avatar'] != null) {
                                  final avatar = comment['author']['avatar'];
                                  avatarUrl = avatar.startsWith('http')
                                      ? avatar
                                      : '${AppConfig.baseUrl}$avatar';
                                }

                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,  // 让头像靠上对齐
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: avatarUrl != null
                                            ? NetworkImage(avatarUrl)
                                            : AssetImage('assets/images/default_avatar.png')
                                                as ImageProvider,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  comment['author']?['nickname'] ?? '用户',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                  onTap: () => _toggleCommentLike(comment),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        comment['isLiked'] == true
                                                            ? Icons.favorite
                                                            : Icons.favorite_border,
                                                        size: 16,
                                                        color: comment['isLiked'] == true
                                                            ? Colors.red
                                                            : Colors.grey,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        '${comment['likesCount'] ?? 0}',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Text(comment['content'] ?? ''),
                                            SizedBox(height: 4),
                                            Text(
                                              (comment['createdAt'] ?? '').replaceAll('T', ' '),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.customGreen,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: '说点什么...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: () => _toggleLike(),
                  child: Row(
                    children: [
                      Icon(
                        widget.post.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: widget.post.isLiked ? Colors.red : Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${widget.post.likesCount}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                IconButton(
                  onPressed: _submitComment,
                  icon: Icon(Icons.send),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentItem() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.green[200],
            child: Icon(Icons.person, size: 20, color: Colors.green[900]),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('评论用户名', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('这是评论内容...'),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.favorite_border, size: 16),
                onPressed: () {},
              ),
              Text('0', style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required int count,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: isActive ? Colors.red : Colors.white,
            size: 20,
          ),
          SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleFollow() async {
    try {
      final response = _isFollowing
          ? await _userService.unfollowUser(widget.post.authorId)
          : await _userService.followUser(widget.post.authorId);

      if (response.code == 200) {
        setState(() {
          _isFollowing = !_isFollowing;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isFollowing ? '已关注' : '已取消关注')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.msg)),
        );
      }
    } catch (e) {
      print('关注操作失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('操作失败，请稍后重试')),
      );
    }
  }

  Future<void> _toggleLike() async {
    print('_toggleLike 被调用');
    print('当前帖子ID: ${widget.post.postId}');
    try {
      final response = _isLiked
          ? await _postService.unlikePost(widget.post.postId)
          : await _postService.likePost(widget.post.postId);

      print('点赞请求响应: ${response.code}');

      if (response.code == 200) {
        setState(() {
          widget.post.isLiked = !widget.post.isLiked; // 直接更新 post 对象
          widget.post.likesCount = widget.post.isLiked
              ? widget.post.likesCount + 1
              : widget.post.likesCount - 1;
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

  Future<void> _submitComment() async {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) return;

    try {
      final response =
          await _postService.createComment(widget.post.postId, comment);
      if (response.code == 200) {
        _commentController.clear();
        // 刷新评论列表
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('评论发送成功')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.msg)),
        );
      }
    } catch (e) {
      print('发送评论失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('发送失败，请稍后重试')),
      );
    }
  }

  Future<void> _toggleCommentLike(Map<String, dynamic> comment) async {
    try {
      final commentId = comment['commentId'];
      final isLiked = comment['isLiked'] == true;
      
      final response = isLiked
          ? await _postService.unlikeComment(commentId)
          : await _postService.likeComment(commentId);

      if (response.code == 200) {
        setState(() {
          comment['isLiked'] = !isLiked;
          comment['likesCount'] = isLiked 
              ? (comment['likesCount'] ?? 0) - 1 
              : (comment['likesCount'] ?? 0) + 1;
        });
      }
    } catch (e) {
      print('评论点赞操作失败: $e');
    }
  }
}
