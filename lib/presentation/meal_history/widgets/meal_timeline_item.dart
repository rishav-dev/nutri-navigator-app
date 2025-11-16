import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Individual meal timeline item widget
class MealTimelineItem extends StatelessWidget {
  const MealTimelineItem({
    super.key,
    required this.meal,
    required this.onTap,
    required this.onDelete,
  });

  final Map<String, dynamic> meal;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dismissible(
      key: Key(meal['id'].toString()),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(colorScheme),
      confirmDismiss: (direction) => _showDeleteConfirmation(context),
      onDismissed: (direction) => onDelete(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  _buildMealImage(colorScheme),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: _buildMealInfo(context, theme, colorScheme),
                  ),
                  _buildMealActions(context, colorScheme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealImage(ColorScheme colorScheme) {
    return Container(
      width: 15.w,
      height: 15.w,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: meal['image'] != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomImageWidget(
                imageUrl: meal['image'] as String,
                width: 15.w,
                height: 15.w,
                fit: BoxFit.cover,
                semanticLabel: meal['semanticLabel'] as String? ?? 'Meal image',
              ),
            )
          : CustomIconWidget(
              iconName: _getMealTypeIcon(meal['mealType'] as String),
              size: 24,
              color: colorScheme.primary,
            ),
    );
  }

  Widget _buildMealInfo(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    final DateTime mealTime = meal['timestamp'] as DateTime;
    final String timeString =
        '${mealTime.hour.toString().padLeft(2, '0')}:${mealTime.minute.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                meal['name'] as String,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              timeString,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'location_on',
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 1.w),
            Expanded(
              child: Text(
                meal['location'] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: _getMealTypeColor(meal['mealType'] as String)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                meal['mealType'] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _getMealTypeColor(meal['mealType'] as String),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              meal['cost'] as String,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
            if (meal['rating'] != null) ...[
              SizedBox(width: 2.w),
              _buildRatingStars(meal['rating'] as double, colorScheme),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildMealActions(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: 'chevron_right',
          size: 20,
          color: colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildRatingStars(double rating, ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return CustomIconWidget(
          iconName: index < rating ? 'star' : 'star_border',
          size: 12,
          color: index < rating ? Colors.amber : colorScheme.onSurfaceVariant,
        );
      }),
    );
  }

  Widget _buildDismissBackground(ColorScheme colorScheme) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 6.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.error,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomIconWidget(
        iconName: 'delete',
        size: 24,
        color: colorScheme.onError,
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Meal'),
        content: const Text(
            'Are you sure you want to remove this meal from your history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _getMealTypeIcon(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return 'wb_sunny';
      case 'lunch':
        return 'wb_sunny_outlined';
      case 'dinner':
        return 'nights_stay';
      case 'snack':
        return 'local_cafe';
      default:
        return 'restaurant';
    }
  }

  Color _getMealTypeColor(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return Colors.orange;
      case 'lunch':
        return Colors.green;
      case 'dinner':
        return Colors.blue;
      case 'snack':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
