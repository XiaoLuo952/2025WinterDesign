import 'package:flutter/material.dart';
import '../models/virtual_plant.dart';
import '../theme/app_theme.dart';
import '../services/virtual_plant_service.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class VirtualPlantPage extends StatefulWidget {
  @override
  _VirtualPlantPageState createState() => _VirtualPlantPageState();
}

class _VirtualPlantPageState extends State<VirtualPlantPage> {
  late VirtualPlant _plant;

  @override
  void initState() {
    super.initState();
    _plant = VirtualPlant();
    _loadVirtualPlant();
  }

  Future<void> _loadVirtualPlant() async {
    try {
      final response = await VirtualPlantService().getVirtualPlant();
      
      if (response.code == 200) {
        if (response.data != null) {
          // 有虚拟植物存在
          setState(() {
            _plant = _plant.copyWith(
              name: response.data['name'] ?? '',
              isPlanted: true,
              days: response.data['days'] ?? 1,
              waterLevel: response.data['waterLevel']?.toDouble() ?? 100,
              fertilizerLevel: response.data['fertilizerLevel']?.toDouble() ?? 100,
              fertilizer: response.data['fertilizer'] ?? 0,
            );
          });
        } else {
          // 没有虚拟植物
          setState(() {
            _plant = _plant.copyWith(isPlanted: false);
          });
        }
      }
    } catch (e) {
      print('加载虚拟植物失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: AppTheme.customGreen,
        automaticallyImplyLeading: false,
        title: Text(
          _plant.isPlanted
              ? '这是你陪伴${_plant.name}的第${_plant.days}天'
              : '开始你的种植之旅吧',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 背景层
          Column(
            children: [
              Expanded(
                child: Image.asset(
                  'assets/images/sky.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Image.asset(
                'assets/images/floor.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ],
          ),
          // 太阳
          Positioned(
            top: 20,
            right: 20,
            child: Image.asset(
              'assets/images/sun.png',
              width: 120,
              height: 120,
            ),
          ),
          // 植物或加号按钮
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: _plant.isPlanted
                  ? Image.asset(
                      'assets/images/orange_tree.png',
                      height: 400,
                      fit: BoxFit.contain,
                    )
                  : IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      iconSize: 100,
                      color: AppTheme.customGreen,
                      onPressed: _showPlantDialog,
                    ),
            ),
          ),
          // 功能按钮
          if (_plant.isPlanted)
            Stack(
              children: [
                // 左侧按钮
                Positioned(
                  top: screenSize.height * 0.25,
                  left: 0,
                  child: _buildFloatingButton(
                    icon: Icons.book,
                    onPressed: _showCollectionDialog,
                    isLeft: true,
                  ),
                ),
                Positioned(
                  top: screenSize.height * 0.35,
                  left: 0,
                  child: _buildFloatingButton(
                    icon: Icons.task,
                    onPressed: _showTasksDialog,
                    isLeft: true,
                  ),
                ),
                // 右侧按钮
                Positioned(
                  top: screenSize.height * 0.25,
                  right: 0,
                  child: _buildFloatingButton(
                    icon: Icons.water_drop,
                    onPressed: _showWaterDialog,
                    isLeft: false,
                  ),
                ),
                Positioned(
                  top: screenSize.height * 0.35,
                  right: 0,
                  child: _buildFloatingButton(
                    icon: Icons.eco,
                    onPressed: _showFertilizeDialog,
                    isLeft: false,
                  ),
                ),
              ],
            ),
          // 状态指示器
          if (_plant.isPlanted)
            Positioned(
              right: 20,
              bottom: 120,
              child: Column(
                children: [
                  _buildIndicator(
                    icon: Icons.water_drop,
                    level: _plant.waterLevel,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 8),
                  _buildIndicator(
                    icon: Icons.eco,
                    level: _plant.fertilizerLevel,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isLeft,
  }) {
    return Transform.translate(
      offset: Offset(isLeft ? -40 : 40, 0),
      child: Container(
        width: 125,
        height: 60,
        decoration: BoxDecoration(
          color: Color(0xFFAEC3AC),
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? Radius.zero : Radius.circular(30),
            right: isLeft ? Radius.circular(30) : Radius.zero,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(isLeft ? 2 : -2, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.horizontal(
              left: isLeft ? Radius.zero : Radius.circular(30),
              right: isLeft ? Radius.circular(30) : Radius.zero,
            ),
            child: Stack(
              children: [
                Positioned(
                  left: isLeft ? null : 16,
                  right: isLeft ? 16 : null,
                  top: 10,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: Image.asset(
                        icon == Icons.water_drop
                            ? 'assets/images/kettle.png'
                            : icon == Icons.eco
                                ? 'assets/images/fer.png'
                                : icon == Icons.book
                                    ? 'assets/images/tujian.png'
                                    : 'assets/images/task.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator({
    required IconData icon,
    required double level,
    required Color color,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          ClipOval(
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.bottomCenter,
              child: Container(
                height: (40 * level / 100).clamp(0, 40),
                width: 40,
                color: color.withOpacity(0.3),
              ),
            ),
          ),
          Center(
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showPlantDialog() {
    final controller = TextEditingController();
    final token = Provider.of<UserProvider>(context, listen: false).token;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.eco,
                size: 60,
                color: AppTheme.customGreen,
              ),
              SizedBox(height: 16),
              Text(
                '开始种植',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: controller,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: '给植物取个名字吧',
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.customGreen,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      '取消',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (controller.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('请输入植物名称')),
                        );
                        return;
                      }

                      if (token == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('请先登录')),
                        );
                        return;
                      }

                      final response = await VirtualPlantService()
                          .createVirtualPlant(controller.text);

                      if (response.code == 200) {
                        print('创建成功，返回数据: ${response.data}');
                        setState(() {
                          _plant = _plant.copyWith(
                            name: controller.text,
                            isPlanted: true,
                            days: 1,
                          );
                        });
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response.msg)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.customGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      '开始种植',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWaterDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFAEC3AC),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Image.asset(
                    'assets/images/kettle.png',
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                '浇水',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '确定要给植物浇水吗？',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      '取消',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final response = await VirtualPlantService().waterPlant();
                      
                      if (response.code == 200) {
                        // 浇水成功，刷新植物状态
                        await _loadVirtualPlant();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('浇水成功')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response.msg)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.customGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      '确定',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFertilizeDialog() {
    if (_plant.fertilizer <= 0) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFAEC3AC),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Image.asset(
                      'assets/images/fer.png',
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '肥料不足',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '请完成任务获取肥料！',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFAEC3AC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    '确定',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFAEC3AC),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Image.asset(
                    'assets/images/fer.png',
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                '施肥',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '确定要给植物施肥吗？（剩余肥料：${_plant.fertilizer}）',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      '取消',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final response = await VirtualPlantService().fertilizePlant();
                      
                      if (response.code == 200) {
                        // 施肥成功，刷新植物状态
                        await _loadVirtualPlant();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('施肥成功')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response.msg)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.customGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      '确定',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCollectionDialog() async {
    final response = await VirtualPlantService().getFruits();
    
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFAEC3AC),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Image.asset('assets/images/tujian.png'),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '果实图鉴',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                if (response.code == 200 && 
                    response.data != null && 
                    response.data['fruits'] is List && 
                    (response.data['fruits'] as List).isNotEmpty)
                  ...(response.data['fruits'] as List).map((fruit) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: ListTile(
                      leading: fruit['imageUrl'] != null
                          ? Image.network(
                              fruit['imageUrl'],
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.eco, color: AppTheme.customGreen),
                      title: Text(
                        fruit['name'] ?? '未知果实',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        fruit['description'] ?? '',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      trailing: Text(
                        fruit['collected'] == true ? '已收集' : '未收集',
                        style: TextStyle(
                          color: fruit['collected'] == true
                              ? Colors.green
                              : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )).toList()
                else
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      '暂未收集到果实',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.customGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    '确定',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTasksDialog() async {
    final response = await VirtualPlantService().getTasks();
    
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFAEC3AC),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Image.asset('assets/images/task.png'),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '每日任务',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                if (response.code == 200 && response.data != null)
                  ...((response.data['dailyTasks'] as List).map((task) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      title: Text(
                        task['title'] ?? '',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                      subtitle: Text(
                        task['description'] ?? '',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 11,
                        ),
                      ),
                      trailing: SizedBox(
                        width: 70,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '奖励: ${task['rewardAmount']} ${task['rewardType']}',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 9,
                              ),
                            ),
                            SizedBox(height: 2),
                            ElevatedButton(
                              onPressed: () async {
                                final taskId = task['taskId'];
                                if (taskId == null) return;

                                final response = await VirtualPlantService().completeTask(taskId);
                                
                                if (response.code == 200) {
                                  // 完成任务成功，刷新任务列表和植物状态
                                  await _loadVirtualPlant();
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('奖励领取成功')),
                                  );
                                  // 重新打开任务对话框显示更新后的状态
                                  _showTasksDialog();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(response.msg)),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.customGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 0,
                                ),
                                minimumSize: Size(50, 20),
                              ),
                              child: Text(
                                '领取奖励',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
