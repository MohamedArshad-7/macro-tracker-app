class DailyGoals {
  double calories;
  double protein;
  double carbs;
  double fat;
  double fiber;

  DailyGoals({
    this.calories = 2200,
    this.protein = 130,
    this.carbs = 250,
    this.fat = 65,
    this.fiber = 30,
  });

  Map<String, dynamic> toJson() => {
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'fiber': fiber,
  };

  factory DailyGoals.fromJson(Map<String, dynamic> json) => DailyGoals(
    calories: json['calories'].toDouble(),
    protein: json['protein'].toDouble(),
    carbs: json['carbs'].toDouble(),
    fat: json['fat'].toDouble(),
    fiber: json['fiber'].toDouble(),
  );

  DailyGoals copyWith({
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? fiber,
  }) {
    return DailyGoals(
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
    );
  }
}
