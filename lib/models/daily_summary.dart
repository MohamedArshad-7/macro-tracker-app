class DailySummary {
  final DateTime date;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final double totalFiber;
  final int mealCount;
  final double targetCalories; // 👈 NEW: Added target calories

  DailySummary({
    required this.date,
    this.totalCalories = 0,
    this.totalProtein = 0,
    this.totalCarbs = 0,
    this.totalFat = 0,
    this.totalFiber = 0,
    this.mealCount = 0,
    this.targetCalories = 2000, // 👈 Default goal is 2000 calories
  });

  // 👈 FIXED: Now calculates remaining calories properly
  double get remainingCalories {
    final remaining = targetCalories - totalCalories;
    return remaining > 0 ? remaining : 0; // Can't go below 0
  }

  DailySummary copyWith({
    DateTime? date,
    double? totalCalories,
    double? totalProtein,
    double? totalCarbs,
    double? totalFat,
    double? totalFiber,
    int? mealCount,
    double? targetCalories,
  }) {
    return DailySummary(
      date: date ?? this.date,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProtein: totalProtein ?? this.totalProtein,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalFat: totalFat ?? this.totalFat,
      totalFiber: totalFiber ?? this.totalFiber,
      mealCount: mealCount ?? this.mealCount,
      targetCalories: targetCalories ?? this.targetCalories,
    );
  }
}