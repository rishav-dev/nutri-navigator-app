import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Individual meal recommendation card with swipe actions
class MealRecommendationCardWidget extends StatelessWidget {
  final Map<String, dynamic> mealData;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final VoidCallback? onDismiss;
  final VoidCallback? onGetDirections;
  final VoidCallback? onViewMenu;
  final VoidCallback? onSetReminder;

  const MealRecommendationCardWidget({
    super.key,
    required this.mealData,
    this.onTap,
    this.onSave,
    this.onDismiss,
    this.onGetDirections,
    this.onViewMenu,
    this.onSetReminder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(mealData['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onSave?.call(),
              backgroundColor: AppTheme.successLight,
              foregroundColor: Colors.white,
              icon: Icons.bookmark,
              label: 'Save',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onDismiss?.call(),
              backgroundColor: AppTheme.errorLight,
              foregroundColor: Colors.white,
              icon: Icons.close,
              label: 'Dismiss',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          onLongPress: () => _showContextMenu(context),
          child: Container(
            width: double.infinity,
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
                _buildHeader(context, theme, colorScheme),
                SizedBox(height: 2.h),
                _buildMealImage(context),
                SizedBox(height: 2.h),
                _buildMealInfo(context, theme, colorScheme),
                SizedBox(height: 2.h),
                _buildMetrics(context, theme, colorScheme),
                SizedBox(height: 2.h),
                _buildTags(context, theme, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build card header with location and meal type
  Widget _buildHeader(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'location_on',
          color: AppTheme.primaryLight,
          size: 20,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mealData['location'] as String? ?? 'Unknown Location',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                mealData['mealType'] as String? ?? 'Meal',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: AppTheme.primaryLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            mealData['valueIndicator'] as String? ?? 'Good Value',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.primaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// Build meal image
  Widget _buildMealImage(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CustomImageWidget(
        imageUrl: mealData['image'] as String? ?? '',
        width: double.infinity,
        height: 20.h,
        fit: BoxFit.cover,
        semanticLabel: mealData['semanticLabel'] as String? ?? 'Meal image',
      ),
    );
  }

  /// Build meal information
  Widget _buildMealInfo(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mealData['name'] as String? ?? 'Delicious Meal',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          mealData['description'] as String? ??
              'A nutritious and delicious meal option.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Build metrics (walking time, wait time, price)
  Widget _buildMetrics(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        _buildMetricItem(
          context,
          Icons.directions_walk,
          '${mealData['walkingTime'] ?? 5} min walk',
          theme,
          colorScheme,
        ),
        SizedBox(width: 4.w),
        _buildMetricItem(
          context,
          Icons.access_time,
          '${mealData['waitTime'] ?? 3} min wait',
          theme,
          colorScheme,
        ),
        SizedBox(width: 4.w),
        _buildMetricItem(
          context,
          Icons.attach_money,
          mealData['price'] as String? ?? '\$8.50',
          theme,
          colorScheme,
        ),
      ],
    );
  }

  /// Build individual metric item
  Widget _buildMetricItem(
    BuildContext context,
    IconData icon,
    String text,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: 1.w),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Build nutritional tags
  Widget _buildTags(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    final tags = (mealData['tags'] as List?)?.cast<String>() ?? [];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: tags
          .map((tag) => Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ))
          .toList(),
    );
  }

  /// Show context menu on long press
  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.directions),
              title: const Text('Get Directions'),
              onTap: () {
                Navigator.pop(context);
                onGetDirections?.call();
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('View Menu'),
              onTap: () {
                Navigator.pop(context);
                onViewMenu?.call();
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Set Reminder'),
              onTap: () {
                Navigator.pop(context);
                onSetReminder?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
