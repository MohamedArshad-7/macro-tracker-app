import 'package:flutter/material.dart';
import '../../models/meal.dart';
import '../../services/meal_service.dart';
import '../../utils/constants.dart';
import '../../utils/calculations.dart';
import '../../widgets/meal_card.dart';
import '../food/search_screen.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final _mealService = MockMealService();
  List<Meal> _meals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    final meals = await _mealService.getMealsForDate(DateTime.now());
    setState(() {
      _meals = meals;
      _isLoading = false;
    });
  }

  Future<void> _deleteMeal(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Meal'),
        content: const Text('Are you sure you want to delete this meal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.delete, style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _mealService.deleteMeal(id);
      _loadMeals();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meal deleted'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Map<String, double> _getTotals() {
    return Calculations.calculateDailyTotals(_meals);
  }

  List<Meal> _getMealsByType(MealType type) {
    return _meals.where((m) => m.mealType == type).toList();
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final totals = _getTotals();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadMeals,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    Center(
                      child: Text(
                        _getFormattedDate(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Daily Totals
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _TotalItem(
                                label: 'Calories',
                                value: totals['calories'] ?? 0,
                                unit: 'kcal',
                              ),
                              _TotalItem(
                                label: 'Protein',
                                value: totals['protein'] ?? 0,
                                unit: 'g',
                              ),
                              _TotalItem(
                                label: 'Carbs',
                                value: totals['carbs'] ?? 0,
                                unit: 'g',
                              ),
                              _TotalItem(
                                label: 'Fat',
                                value: totals['fat'] ?? 0,
                                unit: 'g',
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _TotalItem(
                                label: 'Fiber',
                                value: totals['fiber'] ?? 0,
                                unit: 'g',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Meals by type - only show if meals exist
                    _buildMealSection(MealType.breakfast),
                    _buildMealSection(MealType.lunch),
                    _buildMealSection(MealType.snack),
                    _buildMealSection(MealType.dinner),

                    // Show empty state if no meals at all
                    if (_meals.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(32),
                        alignment: Alignment.center,
                        child: const Column(
                          children: [
                            Icon(
                              Icons.restaurant,
                              size: 64,
                              color: AppColors.textHint,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No meals logged today',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tap the button below to add your first meal',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Add Food Button (only ONE)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const SearchScreen()),
                          ).then((_) => _loadMeals());
                        },
                        icon: const Icon(Icons.add),
                        label: const Text(
                          AppStrings.addFood,
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.accent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMealSection(MealType type) {
    final meals = _getMealsByType(type);

    // If no meals, don't show anything
    if (meals.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Text(
                '${type.emoji} ${type.displayName}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${meals.fold(0.0, (sum, m) => sum + m.calories).toStringAsFixed(0)} kcal',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        ...meals.map((meal) => MealCard(
          meal: meal,
          onEdit: () {},
          onDelete: () => _deleteMeal(meal.id),
        )),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _TotalItem extends StatelessWidget {
  final String label;
  final double value;
  final String unit;

  const _TotalItem({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toStringAsFixed(0),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$label ($unit)',
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}