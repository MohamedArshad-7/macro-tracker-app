import 'food.dart';

enum MealType { breakfast, lunch, snack, dinner }

extension MealTypeExtension on MealType {
  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.snack:
        return 'Snack';
      case MealType.dinner:
        return 'Dinner';
    }
  }

  String get emoji {
    switch (this) {
      case MealType.breakfast:
        return '🍳';
      case MealType.lunch:
        return '☀️';
      case MealType.snack:
        return '🍎';
      case MealType.dinner:
        return '🌙';
    }
  }
}

class Meal {
  final String id;
  final Food food;
  final double quantity; // in grams
  final MealType mealType;
  final DateTime date;

  Meal({
    required this.id,
    required this.food,
    required this.quantity,
    required this.mealType,
    required this.date,
  });

  double get calories => (food.calories * quantity / 100);
  double get protein => (food.protein * quantity / 100);
  double get carbs => (food.carbs * quantity / 100);
  double get fat => (food.fat * quantity / 100);
  double get fiber => (food.fiber * quantity / 100);

  Map<String, dynamic> toJson() => {
    'id': id,
    'food': food.toJson(),
    'quantity': quantity,
    'mealType': mealType.index,
    'date': date.toIso8601String(),
  };

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    id: json['id'],
    food: Food.fromJson(json['food']),
    quantity: json['quantity'].toDouble(),
    mealType: MealType.values[json['mealType']],
    date: DateTime.parse(json['date']),
  );

  Meal copyWith({
    String? id,
    Food? food,
    double? quantity,
    MealType? mealType,
    DateTime? date,
  }) {
    return Meal(
      id: id ?? this.id,
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
      mealType: mealType ?? this.mealType,
      date: date ?? this.date,
    );
  }
}
