import 'package:flutter/material.dart';
import 'publish_page.dart';
import 'profile_page.dart';
import 'side_menu_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'post_detail_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'encyclopedia_detail_page.dart';
import 'package:excel/excel.dart' as excel;
import 'dart:io';
import '../models/plant.dart';
import '../services/plant_service.dart';
import 'virtual_plant_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // 底部导航栏索引
  int _topTabIndex = 1; // 顶部标签索引
  List<Plant> _plants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlants();
  }

  Future<void> _loadPlants() async {
    try {
      final plants = await PlantService.loadPlants();
      setState(() {
        _plants = plants;
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() => _isLoading = false);
    }
  }

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
        return VirtualPlantPage();
      case 4: // 我的页面
        return ProfilePage();
      default:
        return _buildCommunityPage();
    }
  }

  Widget _buildWarehousePage() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_plants.isEmpty) {
      return Center(child: Text('暂无植物数据'));
    }

    // 获取5个随机植物用于轮播图
    final carouselPlants = PlantService.getRandomPlants(_plants, 5);
    // 获取剩余的植物用于列表显示
    final remainingPlants = List<Plant>.from(_plants)
      ..removeWhere((plant) => carouselPlants.contains(plant));

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: CarouselSlider(
            options: CarouselOptions(
              height: 200,
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
            ),
            items: carouselPlants.map((plant) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EncyclopediaDetailPage(
                            plant: plant,
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(
                            plant.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.green[100],
                                child: Icon(
                                  Icons.eco,
                                  size: 80,
                                  color: Colors.green,
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Text(
                              plant.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= remainingPlants.length) return null;
              final plant = remainingPlants[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EncyclopediaDetailPage(
                        plant: plant,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(16),
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          plant.imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.green[100],
                              child: Icon(
                                Icons.eco,
                                size: 80,
                                color: Colors.green,
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(12),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Text(
                            plant.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCommunityPage() {
    if (_topTabIndex == 0) {
      return Center(child: Text('你还没有关注的人哦'));
    } else {
      return MasonryGridView.count(
        padding: EdgeInsets.all(12),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: 10,
        itemBuilder: (context, index) {
          final double randomHeight = 150 + (index % 3) * 50.0;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailPage(),
                ),
              );
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8)),
                    child: Container(
                      height: randomHeight,
                      color: Colors.green[100],
                      width: double.infinity,
                      child: Icon(
                        Icons.eco,
                        size: 64,
                        color: Colors.green,
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
            ),
          );
        },
      );
    }
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
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
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
