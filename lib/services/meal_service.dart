import '../models/meal.dart';
import '../models/food.dart';

abstract class MealService {
  Future<void> addMeal(Meal meal);
  Future<void> updateMeal(Meal meal);
  Future<void> deleteMeal(String id);
  Future<List<Meal>> getMealsForDate(DateTime date);
  Future<List<Meal>> getAllMeals();
  Future<void> clearAllMeals();
}

class MockMealService implements MealService {
  // 🔥 SINGLETON PATTERN - Only ONE instance exists
  static final MockMealService _instance = MockMealService._internal();
  factory MockMealService() => _instance;
  
  // This is the constructor that actually creates the instance
  MockMealService._internal() {
    // Pre-populate with some mock data for today
    final today = DateTime.now();
    _meals.addAll([
      Meal(
        id: 'meal_1',
        food: Food(id: '6', name: 'Oats', category: 'Breakfast', calories: 389, protein: 17, carbs: 66, fat: 7, fiber: 11),
        quantity: 50,
        mealType: MealType.breakfast,
        date: today,
      ),
      Meal(
        id: 'meal_2',
        food: Food(id: '7', name: 'Banana', category: 'Breakfast', calories: 89, protein: 1.1, carbs: 23, fat: 0.3, fiber: 2.6),
        quantity: 100,
        mealType: MealType.breakfast,
        date: today,
      ),
      Meal(
        id: 'meal_3',
        food: Food(id: '1', name: 'Chicken Breast', category: 'High Protein', calories: 165, protein: 31, carbs: 0, fat: 3.6, fiber: 0),
        quantity: 150,
        mealType: MealType.lunch,
        date: today,
      ),
      Meal(
        id: 'meal_4',
        food: Food(id: '2', name: 'White Rice', category: 'Lunch', calories: 130, protein: 2.7, carbs: 28, fat: 0.3, fiber: 0.4),
        quantity: 200,
        mealType: MealType.lunch,
        date: today,
      ),
      Meal(
        id: 'meal_5',
        food: Food(id: '9', name: 'Greek Yogurt', category: 'High Protein', calories: 59, protein: 10, carbs: 3.6, fat: 0.4, fiber: 0),
        quantity: 150,
        mealType: MealType.snack,
        date: today,
      ),
    ]);
  }

  final List<Meal> _meals = [];

  @override
  Future<void> addMeal(Meal meal) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _meals.add(meal);
    // ignore: avoid_print
    print('📦 Current meals in service: ${_meals.length}');
  }

  @override
  Future<void> updateMeal(Meal meal) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _meals.indexWhere((m) => m.id == meal.id);
    if (index != -1) {
      _meals[index] = meal;
    }
  }

  @override
  Future<void> deleteMeal(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _meals.removeWhere((m) => m.id == id);
  }

  @override
  Future<List<Meal>> getMealsForDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final result = _meals.where((meal) => 
      meal.date.year == date.year && 
      meal.date.month == date.month && 
      meal.date.day == date.day
    ).toList();
    // ignore: avoid_print
    print('🔍 Found ${result.length} meals for today');
    return result;
  }

  @override
  Future<List<Meal>> getAllMeals() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_meals);
  }

  @override
  Future<void> clearAllMeals() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _meals.clear();
  }
}