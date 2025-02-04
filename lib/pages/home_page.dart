import 'package:flutter/material.dart';
import 'publish_page.dart';
import 'profile_page.dart';
import 'side_menu_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // 底部导航栏索引
  int _topTabIndex = 1; // 顶部标签索引

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final Color customGreen = Color(0xFFB1DF0B);

    // 社区页面
    if (_currentIndex == 0) {
      return AppBar(
        backgroundColor: customGreen,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SideMenuPage(),
                fullscreenDialog: true,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.green[200],
              child: Icon(
                Icons.person,
                color: Colors.green[900],
                size: 24,
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _topTabIndex = 0;
                });
              },
              child: Text(
                '关注',
                style: TextStyle(
                  color: _topTabIndex == 0 ? Colors.black : Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 20,
              width: 1,
              color: Colors.grey[300],
              margin: EdgeInsets.symmetric(horizontal: 8),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _topTabIndex = 1;
                });
              },
              child: Text(
                '发现',
                style: TextStyle(
                  color: _topTabIndex == 1 ? Colors.black : Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [SizedBox(width: 48)],
      );
    }

    // 仓库页面
    if (_currentIndex == 1) {
      return AppBar(
        backgroundColor: customGreen,
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: '搜索植物',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
      );
    }

    // 其他页面不显示AppBar
    return PreferredSize(
      preferredSize: Size.fromHeight(0),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0: // 社区页面
        return _buildCommunityPage();
      case 1: // 仓库页面
        return _buildWarehousePage();
      case 2: // 发布页面
        return Center(child: Text('发布页面'));
      case 3: // 虚拟植物页面
        return Center(child: Text('虚拟植物页面'));
      case 4: // 我的页面
        return ProfilePage();
      default:
        return _buildCommunityPage();
    }
  }

  Widget _buildWarehousePage() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return _buildWarehouseItem();
      },
      itemCount: 10,
    );
  }

  Widget _buildWarehouseItem() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: Icon(
                  Icons.eco,
                  size: 80,
                  color: Colors.green,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '植物名称',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityPage() {
    // 根据顶部标签索引显示不同内容
    if (_topTabIndex == 0) {
      return Center(child: Text('关注内容'));
    } else {
      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          return _buildGridItem();
        },
        itemCount: 10,
      );
    }
  }

  Widget _buildGridItem() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: Container(
                color: Colors.green[100],
                width: double.infinity,
                child: Icon(
                  Icons.eco,
                  size: 64,
                  color: Colors.green,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '植物标题',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.green[200],
                      child: Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.green[900],
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '用户名',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final Color customGreen = Color(0xFFB1DF0B);

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        if (index == 2) {
          _showPublishSheet();
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 14,
      unselectedFontSize: 14,
      backgroundColor: customGreen,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 28),
          label: '社区',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory, size: 28),
          label: '仓库',
        ),
        BottomNavigationBarItem(
          icon: Container(
            margin: EdgeInsets.only(top: 8), // 向下移动
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12), // 圆角正方形
              border: Border.all(color: Colors.white, width: 2),
            ),
            padding: EdgeInsets.all(8),
            child: Icon(Icons.add, color: Colors.white, size: 28),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.park, size: 28),
          label: '虚拟植物',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 28),
          label: '我的',
        ),
      ],
    );
  }

  void _showPublishSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PublishPage(),
    );
  }
}
