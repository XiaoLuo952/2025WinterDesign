import 'package:flutter/material.dart';
import '../models/virtual_plant.dart';
import 'dart:math';

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
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFF0F9E6),
      appBar: AppBar(
        backgroundColor: Color(0xFFB1DF0B),
        title: Text(_plant.isPlanted
            ? '这是你陪伴${_plant.name}的第${_plant.days}天'
            : '开始你的种植之旅吧'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 天空背景
          Positioned.fill(
            child: Image.asset(
              'assets/images/sky.png',
              fit: BoxFit.cover,
            ),
          ),
          // 太阳
          Positioned(
            top: 20,
            right: 20,
            child: Image.asset(
              'assets/images/sun.png',
              width: 150, // 增大太阳尺寸
              height: 150,
            ),
          ),
          // 地板
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/floor.png',
              fit: BoxFit.cover,
            ),
          ),
          // 植物或加号按钮
          Positioned(
            bottom: 50, // 从 100 改为 50，进一步下移
            left: 0,
            right: 0,
            child: Center(
              child: _plant.isPlanted
                  ? Image.asset(
                      'assets/images/orange_tree.png',
                      height: 500,
                      fit: BoxFit.contain,
                    )
                  : IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      iconSize: 100,
                      color: Colors.green,
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
      offset: Offset(isLeft ? -20 : 20, 0), // 根据方向设置偏移
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? Radius.zero : Radius.circular(30),
            right: isLeft ? Radius.circular(30) : Radius.zero,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
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
            child: Icon(
              icon,
              color: Color(0xFF2E7D32),
              size: 30,
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
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(icon, color: color),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 40 * (level / 100),
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPlantDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.eco,
                size: 60,
                color: Color(0xFF2E7D32),
              ),
              SizedBox(height: 16),
              Text(
                '开始种植',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: '给植物取个名字吧',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color(0xFF2E7D32),
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
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        setState(() {
                          _plant = _plant.copyWith(
                            name: controller.text,
                            isPlanted: true,
                            days: 1,
                          );
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: Text('开始种植'),
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
        backgroundColor: Color(0xFFF0F9E6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.water_drop, color: Color(0xFF2E7D32), size: 40),
              SizedBox(height: 16),
              Text('确定要给植物浇水吗？',
                  style: TextStyle(fontSize: 18, color: Color(0xFF2E7D32))),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('取消', style: TextStyle(color: Colors.grey)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _plant.waterLevel = 100);
                      Navigator.pop(context);
                      _checkAndProduceFruit(); // 检查是否产生果实
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('确定', style: TextStyle(color: Colors.white)),
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
          backgroundColor: Color(0xFFF0F9E6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.orange, size: 40),
                SizedBox(height: 16),
                Text('肥料不足',
                    style: TextStyle(fontSize: 18, color: Color(0xFF2E7D32))),
                Text('请完成任务获取肥料！',
                    style: TextStyle(color: Color(0xFF2E7D32))),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('确定', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      );
      return;
    }

    // 有肥料时的对话框
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Color(0xFFF0F9E6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.eco, color: Color(0xFF2E7D32), size: 40),
              SizedBox(height: 16),
              Text('确定要给植物施肥吗？',
                  style: TextStyle(fontSize: 18, color: Color(0xFF2E7D32))),
              Text('剩余肥料：${_plant.fertilizer}',
                  style: TextStyle(color: Color(0xFF2E7D32))),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('取消', style: TextStyle(color: Colors.grey)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _plant.fertilizerLevel = 100;
                        _plant.fertilizer--;
                      });
                      Navigator.pop(context);
                      _checkAndProduceFruit(); // 检查是否产生果实
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('确定', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCollectionDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Color(0xFFF0F9E6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.book, color: Color(0xFF2E7D32), size: 40),
              SizedBox(height: 16),
              Text('果实图鉴',
                  style: TextStyle(fontSize: 18, color: Color(0xFF2E7D32))),
              SizedBox(height: 16),
              _plant.collectedFruits.isEmpty
                  ? Text('暂未收集到果实',
                      style: TextStyle(color: Color(0xFF2E7D32)))
                  : Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _plant.collectedFruits
                          .map((fruit) => _buildFruitItem(fruit))
                          .toList(),
                    ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('确定', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTasksDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Color(0xFFF0F9E6), // 浅绿色背景
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.water_drop, color: Color(0xFF2E7D32)),
                title: Text('每日浇水'),
                subtitle: Text('奖励：1个肥料'),
                trailing: TextButton(
                  onPressed: () {
                    setState(() => _plant.fertilizer++);
                    Navigator.pop(context);
                  },
                  child: Text('完成', style: TextStyle(color: Color(0xFF2E7D32))),
                ),
              ),
              Divider(color: Colors.green.withOpacity(0.2)),
              ListTile(
                leading: Icon(Icons.post_add, color: Color(0xFF2E7D32)),
                title: Text('发布帖子'),
                subtitle: Text('奖励：2个肥料'),
                trailing: TextButton(
                  onPressed: () {
                    setState(() => _plant.fertilizer += 2);
                    Navigator.pop(context);
                  },
                  child: Text('完成', style: TextStyle(color: Color(0xFF2E7D32))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkAndProduceFruit() {
    if (_plant.waterLevel > 80 && _plant.fertilizerLevel > 80) {
      final random = Random();
      if (random.nextDouble() < 0.3) { // 30% 的概率产生果实
        setState(() {
          // 这里可以根据后端数据设置不同的果实
          final newFruit = '橘子${_plant.collectedFruits.length + 1}';
          _plant.collectedFruits = [..._plant.collectedFruits, newFruit];
        });
        
        // 显示获得果实的提示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('恭喜！你收获了一个新的果实！'),
            backgroundColor: Color(0xFF2E7D32),
          ),
        );
      }
    }
  }

  Widget _buildFruitItem(String fruit) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFF2E7D32)),
      ),
      child: Text(fruit, style: TextStyle(color: Color(0xFF2E7D32))),
    );
  }
}
