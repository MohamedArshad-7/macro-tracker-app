import 'package:flutter/material.dart';
import '../utils/constants.dart';

class NutritionChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final double maxValue;
  final Color barColor;
  final double barWidth;

  const NutritionChart({
    super.key,
    required this.values,
    required this.labels,
    required this.maxValue,
    this.barColor = AppColors.primary,
    this.barWidth = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(values.length, (index) {
          final percentage = maxValue > 0 
              ? (values[index] / maxValue).clamp(0.0, 1.0) 
              : 0.0;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                values[index].toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: barWidth,
                height: 140 * percentage,
                decoration: BoxDecoration(
                  color: barColor.withValues(alpha: 0.7 + (index % 3) * 0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                labels[index],
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
