class VirtualPlant {
  String name;
  bool isPlanted;
  int days;  // 陪伴天数
  double waterLevel;  // 水分等级 0-100
  double fertilizerLevel;  // 肥料等级 0-100
  int fertilizer;  // 拥有的肥料数量
  List<String> collectedFruits;  // 已收集的果实
  final DateTime lastWatered;  // 上次浇水时间
  final DateTime lastFertilized;  // 上次施肥时间

  VirtualPlant({
    this.name = '',
    this.isPlanted = false,
    this.days = 0,
    this.waterLevel = 100,
    this.fertilizerLevel = 100,
    this.fertilizer = 3,
    List<String>? collectedFruits,
    DateTime? lastWatered,
    DateTime? lastFertilized,
  }) : collectedFruits = collectedFruits ?? [],
       lastWatered = lastWatered ?? DateTime.now(),
       lastFertilized = lastFertilized ?? DateTime.now();

  VirtualPlant copyWith({
    String? name,
    bool? isPlanted,
    int? days,
    double? waterLevel,
    double? fertilizerLevel,
    int? fertilizer,
    List<String>? collectedFruits,
  }) {
    return VirtualPlant(
      name: name ?? this.name,
      isPlanted: isPlanted ?? this.isPlanted,
      days: days ?? this.days,
      waterLevel: waterLevel ?? this.waterLevel,
      fertilizerLevel: fertilizerLevel ?? this.fertilizerLevel,
      fertilizer: fertilizer ?? this.fertilizer,
      collectedFruits: collectedFruits ?? this.collectedFruits,
    );
  }
}

class DailyTask {
  final String title;
  final String description;
  final int rewardAmount;
  bool isCompleted;

  DailyTask({
    required this.title,
    required this.description,
    required this.rewardAmount,
    this.isCompleted = false,
  });
} 