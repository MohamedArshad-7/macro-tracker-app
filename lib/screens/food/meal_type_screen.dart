import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/food.dart';
import '../../models/meal.dart';
import '../../services/meal_service.dart';
import '../../utils/constants.dart';
import '../home/home_screen.dart';

class MealTypeScreen extends StatefulWidget {
  final Food food;
  final double quantity;

  const MealTypeScreen({
    super.key,
    required this.food,
    required this.quantity,
  });

  @override
  State<MealTypeScreen> createState() => _MealTypeScreenState();
}

class _MealTypeScreenState extends State<MealTypeScreen> {
  final _mealService = MockMealService();
  bool _isLoading = false;

  Future<void> _addMeal(MealType type) async {
    setState(() => _isLoading = true);

    final meal = Meal(
      id: const Uuid().v4(),
      food: widget.food,
      quantity: widget.quantity,
      mealType: type,
      date: DateTime.now(),
    );

    await _mealService.addMeal(meal);
    debugPrint('Meal added: ${meal.food.name} to ${meal.mealType.displayName}');

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.mealAddedSuccess),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // 🔥 FIXED: Pass shouldRefresh: true
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen(shouldRefresh: true)),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add to Meal'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.restaurant, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.food.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${widget.quantity.toStringAsFixed(0)}g • ${(widget.food.calories * widget.quantity / 100).toStringAsFixed(0)} kcal',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Select Meal Type',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Meal Type Options
                  _MealTypeOption(
                    type: MealType.breakfast,
                    onTap: () => _addMeal(MealType.breakfast),
                  ),
                  const SizedBox(height: 12),
                  _MealTypeOption(
                    type: MealType.lunch,
                    onTap: () => _addMeal(MealType.lunch),
                  ),
                  const SizedBox(height: 12),
                  _MealTypeOption(
                    type: MealType.snack,
                    onTap: () => _addMeal(MealType.snack),
                  ),
                  const SizedBox(height: 12),
                  _MealTypeOption(
                    type: MealType.dinner,
                    onTap: () => _addMeal(MealType.dinner),
                  ),
                ],
              ),
            ),
    );
  }
}

class _MealTypeOption extends StatelessWidget {
  final MealType type;
  final VoidCallback onTap;

  const _MealTypeOption({
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    type.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add to ${type.displayName.toLowerCase()}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}