import 'package:flutter/material.dart';
import 'follow_page.dart';

class SideMenuPage extends StatelessWidget {
  const SideMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              _buildMenuItem(
                icon: Icons.comment,
                title: '我的评论',
                onTap: () {
                  // 处理我的评论
                },
              ),
              _buildMenuItem(
                icon: Icons.history,
                title: '浏览记录',
                onTap: () {
                  // 处理浏览记录
                },
              ),
              _buildMenuItem(
                icon: Icons.notifications,
                title: '通知公告',
                onTap: () {
                  // 处理通知公告
                },
              ),
              Divider(),
              _buildMenuItem(
                icon: Icons.settings,
                title: '设置',
                onTap: () {
                  // 处理设置
                },
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: '帮助',
                onTap: () {
                  // 处理帮助
                },
              ),
              _buildMenuItem(
                icon: Icons.people_outline,
                title: '我的粉丝',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowPage(
                        title: '我的粉丝',
                        type: 'followers',  // 用于区分是粉丝列表还是关注列表
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
