import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/api_response.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../config/app_config.dart';

class FollowPage extends StatefulWidget {
  final String title;
  final String type;  // 'followers' 或 'following'

  const FollowPage({
    Key? key,
    required this.title,
    required this.type,
  }) : super(key: key);

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  final UserService _userService = UserService();
  List<dynamic> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final response = await _userService.getFollowers(user.userId);
      if (response.code == 200 && mounted) {
        // 处理头像 URL
        final processedUsers = (response.data as List).map((user) {
          if (user['avatar'] != null) {
            user['avatar'] = user['avatar'].startsWith('http')
                ? user['avatar']
                : '${AppConfig.baseUrl}${user['avatar']}';
          }
          return user;
        }).toList();

        setState(() {
          _users = processedUsers;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('加载用户列表失败: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppTheme.customGreen,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user['avatar'] != null
                        ? NetworkImage(user['avatar'])
                        : AssetImage('assets/images/default_avatar.png')
                            as ImageProvider,
                  ),
                  title: Text(user['nickname'] ?? '用户'),
                  subtitle: Text(user['bio'] ?? ''),
                );
              },
            ),
    );
  }
} 