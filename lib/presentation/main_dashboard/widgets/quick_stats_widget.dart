import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Quick stats widget showing budget usage and nutritional goals progress
class QuickStatsWidget extends StatelessWidget {
  const QuickStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
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
              CustomIconWidget(
                iconName: 'analytics',
                color: AppTheme.primaryLight,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Today\'s Progress',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildBudgetProgress(context, theme, colorScheme),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildNutritionProgress(context, theme, colorScheme),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build budget progress indicator
  Widget _buildBudgetProgress(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    const budgetUsed = 28.50;
    const budgetTotal = 45.00;
    final budgetPercentage = budgetUsed / budgetTotal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'account_balance_wallet',
              color: AppTheme.successLight,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              'Budget',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          '\$${budgetUsed.toStringAsFixed(2)} / \$${budgetTotal.toStringAsFixed(2)}',
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: budgetPercentage,
          backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.successLight),
        ),
        SizedBox(height: 0.5.h),
        Text(
          '${(budgetPercentage * 100).toInt()}% used',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Build nutrition progress indicator
  Widget _buildNutritionProgress(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    const proteinGoal = 120; // grams
    const proteinConsumed = 85; // grams
    final proteinPercentage = proteinConsumed / proteinGoal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'fitness_center',
              color: AppTheme.primaryLight,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              'Protein Goal',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          '${proteinConsumed}g / ${proteinGoal}g',
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: proteinPercentage,
          backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryLight),
        ),
        SizedBox(height: 0.5.h),
        Text(
          '${(proteinPercentage * 100).toInt()}% complete',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
