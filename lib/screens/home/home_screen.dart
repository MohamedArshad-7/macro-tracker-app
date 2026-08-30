import 'package:flutter/material.dart';
import '../../models/meal.dart';
import '../../services/meal_service.dart';
import '../../utils/constants.dart';
import '../../utils/calculations.dart';
import '../../models/goals.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../diary/diary_screen.dart';
import '../progress/progress_screen.dart';
import '../profile/profile_screen.dart';
import '../food/search_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool shouldRefresh;

  const HomeScreen({super.key, this.shouldRefresh = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _mealService = MockMealService();
  List<Meal> _todayMeals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldRefresh) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final meals = await _mealService.getMealsForDate(DateTime.now());
    setState(() {
      _todayMeals = meals;
      _isLoading = false;
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  Map<String, double> _getTotals() {
    return Calculations.calculateDailyTotals(_todayMeals);
  }

  List<Meal> _getMealsByType(MealType type) {
    return _todayMeals.where((m) => m.mealType == type).toList();
  }

  double _getMealTypeCalories(MealType type) {
    return _getMealsByType(type).fold(0.0, (sum, m) => sum + m.calories);
  }

  @override
  Widget build(BuildContext context) {
    final totals = _getTotals();
    final goals = DailyGoals();

    final screens = [
      _buildHomeContent(totals, goals),
      const DiaryScreen(),
      const ProgressScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildHomeContent(Map<String, double> totals, dynamic goals) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    final totalCalories = totals['calories'] ?? 0;
    final remainingCalories = goals.calories - totalCalories;

    // Get meal sections that have meals
    final mealSections = [
      if (_getMealsByType(MealType.breakfast).isNotEmpty)
        _MealTypeCard(
          type: MealType.breakfast,
          calories: _getMealTypeCalories(MealType.breakfast),
          items: _getMealsByType(MealType.breakfast).map((m) => m.food.name).toList(),
        ),
      if (_getMealsByType(MealType.lunch).isNotEmpty)
        _MealTypeCard(
          type: MealType.lunch,
          calories: _getMealTypeCalories(MealType.lunch),
          items: _getMealsByType(MealType.lunch).map((m) => m.food.name).toList(),
        ),
      if (_getMealsByType(MealType.snack).isNotEmpty)
        _MealTypeCard(
          type: MealType.snack,
          calories: _getMealTypeCalories(MealType.snack),
          items: _getMealsByType(MealType.snack).map((m) => m.food.name).toList(),
        ),
      if (_getMealsByType(MealType.dinner).isNotEmpty)
        _MealTypeCard(
          type: MealType.dinner,
          calories: _getMealTypeCalories(MealType.dinner),
          items: _getMealsByType(MealType.dinner).map((m) => m.food.name).toList(),
        ),
    ];

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🎨 Premium Header
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6C63FF), Color(0xFF8B83FF)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_getGreeting()}, Arshad 👋',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 13,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getFormattedDate(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // 🎨 Calories Summary
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCalorieItem(
                      label: 'Eaten',
                      value: totalCalories,
                      unit: 'kcal',
                      color: const Color(0xFF6C63FF),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey.shade300,
                    ),
                    _buildCalorieItem(
                      label: 'Remaining',
                      value: remainingCalories > 0 ? remainingCalories : 0,
                      unit: 'kcal',
                      color: const Color(0xFF00D4AA),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey.shade300,
                    ),
                    _buildCalorieItem(
                      label: 'Goal',
                      value: goals.calories,
                      unit: 'kcal',
                      color: const Color(0xFFFF6584),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // 🎨 Macro Cards - 2x2 Grid
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  mainAxisExtent: 64,
                ),
                children: [
                    _buildMacroCard(
                      label: 'Protein',
                      current: totals['protein'] ?? 0,
                      goal: goals.protein,
                      color: const Color(0xFF6C63FF),
                      icon: Icons.fitness_center,
                    ),
                    _buildMacroCard(
                      label: 'Carbs',
                      current: totals['carbs'] ?? 0,
                      goal: goals.carbs,
                      color: const Color(0xFF00D4AA),
                      icon: Icons.grain,
                    ),
                    _buildMacroCard(
                      label: 'Fat',
                      current: totals['fat'] ?? 0,
                      goal: goals.fat,
                      color: const Color(0xFFFF6584),
                      icon: Icons.water_drop,
                    ),
                    _buildMacroCard(
                      label: 'Fiber',
                      current: totals['fiber'] ?? 0,
                      goal: goals.fiber,
                      color: const Color(0xFFF59E0B),
                      icon: Icons.grass,
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // 🎨 Today's Meals Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Today's Meals",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _todayMeals.length.toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6C63FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => setState(() => _currentIndex = 1),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6C63FF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // 🎨 MEAL CARDS - DYNAMIC, NO GAPS
              if (mealSections.isNotEmpty) ...[
                ...mealSections,
                const SizedBox(height: 6),
              ],

              // 🎨 Empty State
              if (_todayMeals.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(
                        Icons.restaurant,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No meals logged today',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap the button below to add your first meal',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),

              // 🎨 Add Food Button
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    ).then((_) => _loadData());
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    AppStrings.addFood,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalorieItem({
    required String label,
    required double value,
    required String unit,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value.toStringAsFixed(0),
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMacroCard({
    required String label,
    required double current,
    required double goal,
    required Color color,
    required IconData icon,
  }) {
    final percentage = goal > 0 ? (current / goal * 100).clamp(0, 100) : 0;
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 13),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Row(
            children: [
              Text(
                current.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                ' / ${goal.toStringAsFixed(0)}g',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey.shade200,
              color: color,
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }
}

class _MealTypeCard extends StatelessWidget {
  final MealType type;
  final double calories;
  final List<String> items;

  const _MealTypeCard({
    required this.type,
    required this.calories,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                type.emoji,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.displayName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  items.join(', '),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            '${calories.toStringAsFixed(0)} kcal',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6C63FF),
            ),
          ),
        ],
      ),
    );
  }
}