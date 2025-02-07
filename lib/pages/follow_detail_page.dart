import 'package:flutter/material.dart';

class FollowDetailPage extends StatefulWidget {
  final String initialTab;
  
  const FollowDetailPage({Key? key, required this.initialTab}) : super(key: key);

  @override
  _FollowDetailPageState createState() => _FollowDetailPageState();
}

class _FollowDetailPageState extends State<FollowDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // 设置初始标签
    switch (widget.initialTab) {
      case '互相关注':
        _tabController.index = 0;
        break;
      case '关注':
        _tabController.index = 1;
        break;
      case '粉丝':
        _tabController.index = 2;
        break;
      case '获赞':
        _tabController.index = 3;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: '互相关注'),
            Tab(text: '关注'),
            Tab(text: '粉丝'),
            Tab(text: '获赞'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildListView('互相关注'),
          _buildListView('关注'),
          _buildListView('粉丝'),
          _buildListView('获赞'),
        ],
      ),
    );
  }

  Widget _buildListView(String type) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text('用户 $index'),
          subtitle: Text('这是一段简介'),
          trailing: type != '获赞' ? ElevatedButton(
            onPressed: () {},
            child: Text(type == '互相关注' ? '已关注' : '关注'),
          ) : null,
        );
      },
    );
  }
} 