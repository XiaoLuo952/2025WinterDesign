import '../config/app_config.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'edit_profile_page.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/user_service.dart';
import '../models/user.dart';
import 'follow_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  final UserService _userService = UserService();
  File? _avatarFile;

  Future<void> _pickAndUpdateAvatar() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // 更新用户资料，只更新头像
        final response = await _userService.updateUserProfile(
          avatar: File(image.path),
        );

        if (response.code == 200) {
          final user = response.data as User;
          final token = Provider.of<UserProvider>(context, listen: false).token;
          if (token != null) {
            // 确保更新的用户信息包含所有原有信息
            final currentUser =
                Provider.of<UserProvider>(context, listen: false).currentUser;
            final updatedUser = User(
              userId: user.userId,
              phone: user.phone,
              nickname: user.nickname ?? currentUser?.nickname, // 保留原有昵称
              avatar: user.avatar,
              bio: user.bio ?? currentUser?.bio, // 保留原有简介
              gender: user.gender ?? currentUser?.gender, // 保留原有性别
              birthday: user.birthday ?? currentUser?.birthday, // 保留原有生日
              location: user.location ?? currentUser?.location, // 保留原有位置
              followersCount: user.followersCount,
              followingCount: user.followingCount,
              likesCount: user.likesCount,
            );
            Provider.of<UserProvider>(context, listen: false)
                .setUserAndToken(updatedUser, token);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('头像更新成功')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.msg)),
          );
        }
      }
    } catch (e) {
      print('更新头像失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('更新头像失败')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 获取用户信息
    final user = context.watch<UserProvider>().currentUser;
    final nickname = user?.nickname ?? '未设置昵称';
    final avatar = user?.avatar;

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
            bottom: -150, // 往下移一点，从-100改为-150
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.6, // 设置透明度
              child: SizedBox(
                // 添加 SizedBox 来控制图片大小
                height: 400, // 设置合适的高度
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
                        nickname,
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
                      onTap: _pickAndUpdateAvatar,
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
                          backgroundColor: Colors.grey[200],  // 使用灰色背景
                          backgroundImage: avatar != null
                              ? NetworkImage(avatar)
                              : AssetImage('assets/images/default_avatar.png') as ImageProvider,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              // 选项列表
              _buildOptionButtons(),
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

  Widget _buildOptionButtons() {
    return Column(
      children: [
        _buildOptionTile(
          icon: Icons.people_outline,
          title: '我的粉丝',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FollowPage(
                  title: '我的粉丝',
                  type: 'followers',
                ),
              ),
            );
          },
        ),
        _buildOptionTile(
          icon: Icons.person_outline,
          title: '我的关注',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FollowPage(
                  title: '我的关注',
                  type: 'following',
                ),
              ),
            );
          },
        ),
      ],
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

  void _showMyPosts(BuildContext context) {
    // Implementation of _showMyPosts method
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
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Icon(Icons.exit_to_app),
                  title: Text('退出登录'),
                  onTap: () {
                    // 处理退出登录逻辑
                    Navigator.pop(context); // 关闭对话框
                    Navigator.pop(context); // 返回上一页
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false, // 清除所有路由栈
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

  // 添加一个通用的默认头像组件
  Widget _buildDefaultAvatar({double size = 60}) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: Icon(
        Icons.person,
        size: size,
        color: AppTheme.customGreen,
      ),
    );
  }
}
