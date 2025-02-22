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
import '../theme/app_theme.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'discover_page.dart';
import 'community_page.dart';
import 'message_page.dart';
import '../services/post_service.dart';
import '../models/post.dart';
import '../config/app_config.dart';
import '../models/api_response.dart';

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
  final List<Widget> _pages = [
    const DiscoverPage(),
    const CommunityPage(),
    const PublishPage(),
    const MessagePage(),
    ProfilePage(),
  ];
  final PostService _postService = PostService();
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _loadPlants();
    if (_currentIndex == 0) {
      _loadPosts();
    }
  }

  Future<void> _loadPlants() async {
    try {
      final plants = await PlantService.loadPlants();
      setState(() {
        _plants = plants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _onPageChanged(int index) {
    if (index == 2) {
      // 如果点击了发布按钮，显示底部弹出的发布页面
      _showPublishSheet();
      return;
    }

    setState(() {
      _currentIndex = index;
      if (index == 0) {
        _loadPosts();
      }
    });
  }

  Future<void> _loadPosts() async {
    try {
      final response = await _postService.getPosts();

      if (response.code == 200) {
        final data = response.data as Map<String, dynamic>;
        final items = data['items'] as List<dynamic>;

        setState(() {
          _posts = items.map((data) => Post.fromJson(data)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // 添加标签切换方法
  void _onTabChanged(int index) {
    setState(() {
      _topTabIndex = index;
      if (index == 0) {
        // 关注
        _loadFollowingPosts();
      } else {
        // 发现
        _loadPosts();
      }
    });
  }

  // 添加加载关注帖子的方法
  Future<void> _loadFollowingPosts() async {
    try {
      final response = await _postService.getFollowingPosts();
      if (response.code == 200) {
        setState(() {
          _posts = (response.data['items'] as List)
              .map((item) => Post.fromJson(item))
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('加载关注用户帖子失败: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _buildAppBar(),
      body: Stack(
        // 使用 Stack 来叠加内容和底部导航栏
        children: [
          Container(
            // 背景和主要内容
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: _buildBody(),
          ),
          Positioned(
            // 底部导航栏
            left: 16,
            right: 16,
            bottom: 16,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.customGreen.withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  currentIndex: _currentIndex,
                  onTap: _onPageChanged,
                  type: BottomNavigationBarType.fixed,
                  selectedFontSize: 14,
                  unselectedFontSize: 14,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white70,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home, size: 28),
                      label: '社区',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu_book, size: 28),
                      label: '百科',
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        margin: EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange, // 中间按钮的颜色
                          shape: BoxShape.circle, // 圆形
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_currentIndex == 0) {
      return AppBar(
        backgroundColor: AppTheme.customGreen,
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
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                final avatar = userProvider.currentUser?.avatar;
                return CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: avatar != null && avatar.startsWith('http')
                      ? NetworkImage(avatar)
                      : avatar != null
                          ? NetworkImage('${AppConfig.baseUrl}$avatar')
                          : AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                  child: avatar == null
                      ? Icon(
                          Icons.person,
                          size: 24,
                          color: AppTheme.customGreen,
                        )
                      : null,
                );
              },
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
        backgroundColor: AppTheme.customGreen,
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
      case 0:
        return _buildCommunityPage();
      case 1:
        return _buildWarehousePage();
      case 2:
        return const PublishPage();
      case 3:
        return VirtualPlantPage();
      case 4:
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
                          child: Image.asset(
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
                        child: Image.asset(
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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          if (mounted) {
            // 添加检查
            setState(() {});
          }
          return Future.value();
        },
        child: FutureBuilder<ApiResponse>(
          future: _postService.getPosts(),
          builder: (context, snapshot) {
            if (!mounted) return Container(); // 添加检查

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('加载失败'));
            }

            if (!snapshot.hasData || snapshot.data?.data == null) {
              return Center(child: Text('暂无帖子'));
            }

            try {
              final data = snapshot.data!.data as Map<String, dynamic>;
              final items =
                  (data['items'] as List).cast<Map<String, dynamic>>();
              final posts = items.map((data) => Post.fromJson(data)).toList();

              return MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: EdgeInsets.all(10),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  double imageHeight = 200;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailPage(post: post),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (post.imageUrls.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.network(
                                post.imageUrls.first,
                                height: imageHeight,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                cacheWidth: 800,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: imageHeight,
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: imageHeight,
                                    color: Colors.grey[200],
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.image_not_supported,
                                            size: 40, color: Colors.grey),
                                        SizedBox(height: 8),
                                        Text('图片加载失败',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundImage: post.authorAvatar !=
                                                  null &&
                                              post.authorAvatar!.isNotEmpty &&
                                              post.authorAvatar!
                                                  .startsWith('http')
                                          ? NetworkImage(post.authorAvatar!)
                                          : AssetImage(
                                                  'assets/images/default_avatar.png')
                                              as ImageProvider,
                                      backgroundColor: Colors.grey[200],
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        post.authorNickname.isNotEmpty
                                            ? post.authorNickname
                                            : '匿名用户',
                                        style: TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _toggleLike(post),
                                      child: Row(
                                        children: [
                                          Icon(
                                            post.isLiked
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: post.isLiked
                                                ? Colors.red
                                                : Colors.grey,
                                            size: 20,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            '${post.likesCount}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
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
            } catch (e) {
              return Center(child: Text('数据格式错误'));
            }
          },
        ),
      ),
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

  Future<void> _toggleLike(Post post) async {
    try {
      final response = post.isLiked
          ? await _postService.unlikePost(post.postId)
          : await _postService.likePost(post.postId);

      if (response.code == 200) {
        setState(() {
          post.isLiked = !post.isLiked;
          post.likesCount =
              post.isLiked ? post.likesCount + 1 : post.likesCount - 1;
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
}
