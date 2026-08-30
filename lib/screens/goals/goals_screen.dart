import 'package:flutter/material.dart';
import '../../models/goals.dart';
import '../../services/local_storage_service.dart';
import '../../utils/constants.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final _storageService = MockLocalStorageService();
  late DailyGoals _goals;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final goals = await _storageService.getGoals();
    setState(() {
      _goals = goals ?? DailyGoals();
      _isLoading = false;
    });
  }

  Future<void> _saveGoals() async {
    setState(() => _isSaving = true);
    await _storageService.saveGoals(_goals);
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Goals saved successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dailyGoals),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set Your Daily Nutrition Goals',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            _GoalSlider(
              label: 'Calories',
              value: _goals.calories,
              min: 1000,
              max: 5000,
              unit: 'kcal',
              color: AppColors.primary,
              icon: Icons.local_fire_department,
              onChanged: (value) => setState(() => _goals.calories = value),
            ),
            const SizedBox(height: 24),
            _GoalSlider(
              label: 'Protein',
              value: _goals.protein,
              min: 20,
              max: 300,
              unit: 'g',
              color: AppColors.protein,
              icon: Icons.fitness_center,
              onChanged: (value) => setState(() => _goals.protein = value),
            ),
            const SizedBox(height: 24),
            _GoalSlider(
              label: 'Carbohydrates',
              value: _goals.carbs,
              min: 50,
              max: 600,
              unit: 'g',
              color: AppColors.carbs,
              icon: Icons.grain,
              onChanged: (value) => setState(() => _goals.carbs = value),
            ),
            const SizedBox(height: 24),
            _GoalSlider(
              label: 'Fat',
              value: _goals.fat,
              min: 20,
              max: 200,
              unit: 'g',
              color: AppColors.fat,
              icon: Icons.water_drop,
              onChanged: (value) => setState(() => _goals.fat = value),
            ),
            const SizedBox(height: 24),
            _GoalSlider(
              label: 'Fiber',
              value: _goals.fiber,
              min: 5,
              max: 80,
              unit: 'g',
              color: AppColors.fiber,
              icon: Icons.grass,
              onChanged: (value) => setState(() => _goals.fiber = value),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Goals Summary',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SummaryRow(label: 'Calories', value: '${_goals.calories.toStringAsFixed(0)} kcal'),
                  _SummaryRow(label: 'Protein', value: '${_goals.protein.toStringAsFixed(0)}g'),
                  _SummaryRow(label: 'Carbs', value: '${_goals.carbs.toStringAsFixed(0)}g'),
                  _SummaryRow(label: 'Fat', value: '${_goals.fat.toStringAsFixed(0)}g'),
                  _SummaryRow(label: 'Fiber', value: '${_goals.fiber.toStringAsFixed(0)}g'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveGoals,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(AppStrings.save),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _GoalSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String unit;
  final Color color;
  final IconData icon;
  final ValueChanged<double> onChanged;

  const _GoalSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.color,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${value.toStringAsFixed(0)} $unit',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) / 10).round(),
            activeColor: color,
            inactiveColor: color.withValues(alpha: 0.2),
            onChanged: onChanged,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${min.toStringAsFixed(0)} $unit', style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
              Text('${max.toStringAsFixed(0)} $unit', style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
