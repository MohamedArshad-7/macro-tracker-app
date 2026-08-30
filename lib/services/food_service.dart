import '../models/food.dart';

abstract class FoodService {
  Future<List<Food>> searchFoods(String query);
  Future<List<Food>> getFoodsByCategory(String category);
  Future<Food?> getFoodById(String id);
  Future<List<Food>> getPopularFoods();
}

class MockFoodService implements FoodService {
  final List<Food> _foods = [
    Food(id: '1', name: 'Chicken Breast', category: 'High Protein', calories: 165, protein: 31, carbs: 0, fat: 3.6, fiber: 0),
    Food(id: '2', name: 'White Rice', category: 'Lunch', calories: 130, protein: 2.7, carbs: 28, fat: 0.3, fiber: 0.4),
    Food(id: '3', name: 'Brown Rice', category: 'Lunch', calories: 112, protein: 2.6, carbs: 24, fat: 0.9, fiber: 1.8),
    Food(id: '4', name: 'Egg', category: 'Breakfast', calories: 155, protein: 13, carbs: 1.1, fat: 11, fiber: 0),
    Food(id: '5', name: 'Egg Whites', category: 'High Protein', calories: 52, protein: 11, carbs: 0.7, fat: 0.2, fiber: 0),
    Food(id: '6', name: 'Oats', category: 'Breakfast', calories: 389, protein: 17, carbs: 66, fat: 7, fiber: 11),
    Food(id: '7', name: 'Banana', category: 'Breakfast', calories: 89, protein: 1.1, carbs: 23, fat: 0.3, fiber: 2.6),
    Food(id: '8', name: 'Apple', category: 'Snack', calories: 52, protein: 0.3, carbs: 14, fat: 0.2, fiber: 2.4),
    Food(id: '9', name: 'Greek Yogurt', category: 'High Protein', calories: 59, protein: 10, carbs: 3.6, fat: 0.4, fiber: 0),
    Food(id: '10', name: 'Milk', category: 'Breakfast', calories: 42, protein: 3.4, carbs: 5, fat: 1, fiber: 0),
    Food(id: '11', name: 'Paneer', category: 'High Protein', calories: 265, protein: 18, carbs: 1.2, fat: 21, fiber: 0),
    Food(id: '12', name: 'Chapati', category: 'Lunch', calories: 120, protein: 3, carbs: 18, fat: 3.7, fiber: 2.6),
    Food(id: '13', name: 'Idli', category: 'Breakfast', calories: 58, protein: 1.6, carbs: 12, fat: 0.1, fiber: 0.4),
    Food(id: '14', name: 'Dosa', category: 'Breakfast', calories: 133, protein: 2.7, carbs: 29, fat: 0.6, fiber: 0.9),
    Food(id: '15', name: 'Sambar', category: 'Lunch', calories: 50, protein: 2.5, carbs: 8, fat: 1.5, fiber: 2.8),
    Food(id: '16', name: 'Fish (Salmon)', category: 'High Protein', calories: 208, protein: 20, carbs: 0, fat: 13, fiber: 0),
    Food(id: '17', name: 'Potato', category: 'Lunch', calories: 77, protein: 2, carbs: 17, fat: 0.1, fiber: 2.2),
    Food(id: '18', name: 'Whey Protein', category: 'High Protein', calories: 120, protein: 24, carbs: 3, fat: 1, fiber: 0),
    Food(id: '19', name: 'Peanut Butter', category: 'Snack', calories: 588, protein: 25, carbs: 20, fat: 50, fiber: 6),
    Food(id: '20', name: 'Chicken Rice', category: 'Lunch', calories: 280, protein: 18, carbs: 32, fat: 8, fiber: 1.2),
    Food(id: '21', name: 'Almonds', category: 'Snack', calories: 579, protein: 21, carbs: 22, fat: 50, fiber: 12.5),
    Food(id: '22', name: 'Broccoli', category: 'Lunch', calories: 34, protein: 2.8, carbs: 7, fat: 0.4, fiber: 2.6),
    Food(id: '23', name: 'Sweet Potato', category: 'Lunch', calories: 86, protein: 1.6, carbs: 20, fat: 0.1, fiber: 3),
    Food(id: '24', name: 'Tofu', category: 'High Protein', calories: 76, protein: 8, carbs: 1.9, fat: 4.8, fiber: 0.3),
    Food(id: '25', name: 'Lentils (Dal)', category: 'Lunch', calories: 116, protein: 9, carbs: 20, fat: 0.4, fiber: 7.9),
  ];

  @override
  Future<List<Food>> searchFoods(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    return _foods.where((food) => 
      food.name.toLowerCase().contains(lowerQuery) ||
      food.category.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  @override
  Future<List<Food>> getFoodsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (category == 'All' || category == 'Popular') {
      return _foods.take(10).toList();
    }
    return _foods.where((food) => food.category == category).toList();
  }

  @override
  Future<Food?> getFoodById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _foods.firstWhere((food) => food.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Food>> getPopularFoods() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _foods.take(8).toList();
  }
}
