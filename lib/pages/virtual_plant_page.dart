import 'package:flutter/material.dart';
import '../models/virtual_plant.dart';

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

  void _showPlantDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('开始种植'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('要开始种植你的植物吗？'),
            SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: '给植物取个名字吧',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          TextButton(
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
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              width: 60,
              height: 60,
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
          Center(
            child: _plant.isPlanted
                ? Image.asset(
                    'assets/images/orange_tree.png',
                    height: 300,
                    fit: BoxFit.contain,
                  )
                : IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    iconSize: 100,
                    color: Colors.green,
                    onPressed: _showPlantDialog,
                  ),
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
          // 底部按钮
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 左侧按钮
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildActionButton(
                        icon: Icons.book,
                        label: '图鉴',
                        onPressed: _showCollectionDialog,
                      ),
                      SizedBox(height: 16),
                      _buildActionButton(
                        icon: Icons.task,
                        label: '任务',
                        onPressed: _showTasksDialog,
                      ),
                    ],
                  ),
                  // 右侧按钮
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildActionButton(
                        icon: Icons.water_drop,
                        label: '浇水',
                        onPressed: _showWaterDialog,
                      ),
                      SizedBox(height: 16),
                      _buildActionButton(
                        icon: Icons.eco,
                        label: '施肥',
                        onPressed: _showFertilizeDialog,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Icon(icon, size: 24),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF2E7D32),
          ),
        ),
      ],
    );
  }

  void _showWaterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('浇水'),
        content: Text('确定要给植物浇水吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _plant.waterLevel = 100);
              Navigator.pop(context);
            },
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showFertilizeDialog() {
    if (_plant.fertilizer <= 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('肥料不足'),
          content: Text('你的肥料不足，请完成任务获取肥料！'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('确定'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('施肥'),
        content: Text('确定要给植物施肥吗？（剩余肥料：${_plant.fertilizer}）'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _plant.fertilizerLevel = 100;
                _plant.fertilizer--;
              });
              Navigator.pop(context);
            },
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showCollectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('果实图鉴'),
        content: Text('暂未收集到果实'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showTasksDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('每日任务'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '今日格言：',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('今天也要好好照顾植物哦！'),
            SizedBox(height: 16),
            Text(
              '任务列表：',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('每日浇水'),
              subtitle: Text('奖励：1个肥料'),
              trailing: TextButton(
                onPressed: () {
                  setState(() => _plant.fertilizer++);
                  Navigator.pop(context);
                },
                child: Text('完成'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 