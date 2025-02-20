import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

const Color titleGreen = Color(0x3B78DF73);  // #78DF733B

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key}) : super(key: key);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLiked = false;
  int _likeCount = 0;
  int _commentCount = 0;

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: AppTheme.customGreen,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: AppTheme.customGreen),
            ),
            SizedBox(width: 8),
            Text('作者昵称', style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              '关注',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 图片区域
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        color: Colors.green[100],
                        child: Icon(Icons.image, size: 100, color: Colors.green),
                      ),
                    ),
                    // 标题和正文
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '帖子标题',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('这里是帖子正文内容...'),
                          SizedBox(height: 8),
                          Text(
                            '2024-03-20 12:00',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    // 评论区
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('共 $_commentCount 条评论'),
                          SizedBox(height: 16),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            itemBuilder: (context, index) => _buildCommentItem(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 底部互动栏
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.customGreen,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '写下你的评论...',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Row(
                      children: [
                        _buildInteractionButton(
                          icon: Icons.favorite,
                          count: _likeCount,
                          isActive: _isLiked,
                          onTap: () {
                            setState(() {
                              _isLiked = !_isLiked;
                              _likeCount += _isLiked ? 1 : -1;
                            });
                          },
                        ),
                        SizedBox(width: 16),
                        _buildInteractionButton(
                          icon: Icons.comment,
                          count: _commentCount,
                          onTap: _showCommentSheet,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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
}
