import '../models/food.dart';
import '../models/meal.dart';
import '../models/goals.dart';

class Calculations {
  static double calculateCalories(Food food, double quantity) {
    return (food.calories * quantity / 100);
  }

  static double calculateProtein(Food food, double quantity) {
    return (food.protein * quantity / 100);
  }

  static double calculateCarbs(Food food, double quantity) {
    return (food.carbs * quantity / 100);
  }

  static double calculateFat(Food food, double quantity) {
    return (food.fat * quantity / 100);
  }

  static double calculateFiber(Food food, double quantity) {
    return (food.fiber * quantity / 100);
  }

  static Map<String, double> calculateMealNutrition(Meal meal) {
    return {
      'calories': meal.calories,
      'protein': meal.protein,
      'carbs': meal.carbs,
      'fat': meal.fat,
      'fiber': meal.fiber,
    };
  }

  static Map<String, double> calculateDailyTotals(List<Meal> meals) {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    double totalFiber = 0;

    for (var meal in meals) {
      totalCalories += meal.calories;
      totalProtein += meal.protein;
      totalCarbs += meal.carbs;
      totalFat += meal.fat;
      totalFiber += meal.fiber;
    }

    return {
      'calories': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fat': totalFat,
      'fiber': totalFiber,
    };
  }

  static double remainingCalories(double consumed, DailyGoals goals) {
    return goals.calories - consumed;
  }

  static double goalPercentage(double consumed, double goal) {
    if (goal == 0) return 0;
    return (consumed / goal).clamp(0.0, 1.0);
  }

  static double goalPercentageOver(double consumed, double goal) {
    if (goal == 0) return 0;
    return (consumed / goal).clamp(0.0, 2.0);
  }
}
