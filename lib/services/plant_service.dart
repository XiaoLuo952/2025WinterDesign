import 'package:excel/excel.dart' as excel;
import 'dart:io';
import 'dart:math';
import '../models/plant.dart';

class PlantService {
  static Future<List<Plant>> loadPlants() async {
    try {
      // 模拟数据，直到 Excel 文件准备就绪
      return List.generate(20, (index) => Plant(
        name: '植物${index + 1}',
        category: '种类${(index % 5) + 1}',
        description: '这是植物${index + 1}的详细描述，包含了生长习性、养护方法等信息...',
        imageUrl: 'https://picsum.photos/500/300?random=$index', // 使用随机图片
      ));

      // 以下是读取 Excel 文件的代码，等文件准备好后可以启用
      /*
      var file = File('assets/plant.xlsx');
      var bytes = await file.readAsBytes();
      var excelFile = excel.Excel.decodeBytes(bytes);
      var sheet = excelFile.tables[excelFile.tables.keys.first]!;

      List<Plant> plants = [];
      for (var i = 1; i < sheet.maxRows!; i++) {
        var row = sheet.row(i)!;
        plants.add(Plant(
          name: row[0]?.value?.toString() ?? '',
          category: row[1]?.value?.toString() ?? '',
          description: row[2]?.value?.toString() ?? '',
          imageUrl: row[3]?.value?.toString() ?? '',
        ));
      }
      return plants;
      */
    } catch (e) {
      print('Error loading plants: $e');
      return [];
    }
  }

  static List<Plant> getRandomPlants(List<Plant> plants, int count) {
    if (plants.isEmpty) return [];
    
    final random = Random();
    final List<Plant> randomPlants = [];
    final List<int> indices = List.generate(plants.length, (i) => i);
    
    for (var i = 0; i < count && indices.isNotEmpty; i++) {
      final randomIndex = random.nextInt(indices.length);
      randomPlants.add(plants[indices[randomIndex]]);
      indices.removeAt(randomIndex);
    }
    
    return randomPlants;
  }
}
