import 'package:excel/excel.dart' as excel;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import '../models/plant.dart';

class PlantService {
  static Future<List<Plant>> loadPlants() async {
    try {
      final bytes = await rootBundle.load('assets/plant.xlsx');
      var excelFile = excel.Excel.decodeBytes(bytes.buffer.asUint8List());
      var sheet = excelFile.tables[excelFile.tables.keys.first]!;

      List<Plant> plants = [];
      for (var i = 1; i < sheet.maxRows!; i++) {
        var row = sheet.row(i)!;
        plants.add(Plant(
          name: row[0]?.value?.toString() ?? '',
          category: row[1]?.value?.toString() ?? '',
          description: row[2]?.value?.toString() ?? '',
          imageUrl: 'assets/pictures/${row[3]?.value?.toString()}',
        ));
      }
      
      if (plants.isEmpty) {
        plants = [
          Plant(
            name: '橘子树',
            category: '果树',
            description: '这是一棵漂亮的橘子树，适合在温暖的气候下生长。',
            imageUrl: 'assets/pictures/orange_tree.png',
          ),
          Plant(
            name: '苹果树',
            category: '果树',
            description: '这是一棵结实的苹果树，需要充足的阳光和水分。',
            imageUrl: 'assets/pictures/apple_tree.png',
          ),
        ];
      }
      
      return plants;
    } catch (e) {
      print('Error loading plants: $e');
      return [
        Plant(
          name: '橘子树',
          category: '果树',
          description: '这是一棵漂亮的橘子树，适合在温暖的气候下生长。',
          imageUrl: 'assets/pictures/orange_tree.png',
        ),
        Plant(
          name: '苹果树',
          category: '果树',
          description: '这是一棵结实的苹果树，需要充足的阳光和水分。',
          imageUrl: 'assets/pictures/apple_tree.png',
        ),
      ];
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
