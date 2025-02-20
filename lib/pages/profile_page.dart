import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _avatarFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // 底部地球图片
          Positioned(
            bottom: -150,  // 往下移一点，从-100改为-150
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.6,  // 设置透明度
              child: SizedBox(  // 添加 SizedBox 来控制图片大小
                height: 400,    // 设置合适的高度
                child: Image.asset(
                  'assets/images/earth.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // 顶部背景图和个人信息区域
          Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // 顶部背景图
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/view.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // 白色信息区域
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 160,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xFFCAFECF),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 2),
                            blurRadius: 6,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.fromLTRB(160, 20, 20, 20),
                      child: Text(
                        '用户名',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // 头像
                  Positioned(
                    left: 20,
                    top: 100,
                    child: GestureDetector(
                      onTap: _showAvatarOptions,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: _avatarFile != null
                              ? FileImage(_avatarFile!)
                              : null,
                          child: _avatarFile == null
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: AppTheme.customGreen,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              // 选项列表
              _buildOptionTile(
                icon: Icons.favorite_border,
                title: '我的关注',
                onTap: () => _showFollowingList(context),
              ),
              _buildOptionTile(
                icon: Icons.thumb_up_outlined,
                title: '我的点赞',
                onTap: () => _showLikedPosts(context),
              ),
              _buildOptionTile(
                icon: Icons.article_outlined,
                title: '我的帖子',
                onTap: () => _showMyPosts(context),
              ),
              _buildOptionTile(
                icon: Icons.settings_outlined,
                title: '设置',
                onTap: () => _showSettings(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, size: 28),
        title: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showFollowingList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('我的关注'),
            backgroundColor: AppTheme.customGreen,
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[100],
                    child: Icon(Icons.person, color: AppTheme.customGreen),
                  ),
                  title: Text('用户 ${index + 1}'),
                  subtitle: Text('个性签名'),
                  trailing: TextButton(
                    onPressed: () {},
                    child: Text('已关注'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.customGreen,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showLikedPosts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('我的点赞'),
            backgroundColor: AppTheme.customGreen,
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('帖子标题 ${index + 1}'),
                    subtitle: Text('帖子内容预览...'),
                    trailing: Icon(Icons.favorite, color: Colors.red),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showMyPosts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('我的帖子'),
            backgroundColor: AppTheme.customGreen,
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('帖子标题 ${index + 1}'),
                        subtitle: Text('发布时间: 2024-03-20'),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text('编辑'),
                              value: 'edit',
                            ),
                            PopupMenuItem(
                              child: Text('删除'),
                              value: 'delete',
                            ),
                          ],
                          onSelected: (value) {
                            // 处理编辑或删除
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('帖子内容...'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('设置'),
            backgroundColor: AppTheme.customGreen,
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Icon(Icons.edit),
                  title: Text('编辑资料'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(),
                      ),
                    );
                  },
                ),
                Divider(height: 1),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Icon(Icons.exit_to_app),
                  title: Text('退出登录'),
                  onTap: () {
                    // 处理退出登录逻辑
                    Navigator.pop(context);  // 关闭对话框
                    Navigator.pop(context);  // 返回上一页
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,  // 清除所有路由栈
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAvatarOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('从相册选择'),
              onTap: () async {
                Navigator.pop(context);
                final image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  setState(() => _avatarFile = File(image.path));
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('拍照'),
              onTap: () async {
                Navigator.pop(context);
                final image = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  setState(() => _avatarFile = File(image.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
