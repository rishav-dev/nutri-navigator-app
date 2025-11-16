import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Individual meal recommendation card with swipe actions
class MealRecommendationCard extends StatelessWidget {
  final Map<String, dynamic> mealData;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback onDismiss;

  const MealRecommendationCard({
    super.key,
    required this.mealData,
    required this.onTap,
    required this.onFavorite,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(mealData["id"]),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onFavorite(),
              backgroundColor: AppTheme.successLight,
              foregroundColor: Colors.white,
              icon: Icons.favorite,
              label: 'Save',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onDismiss(),
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
          child: Container(
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
                _buildImageSection(colorScheme),
                _buildContentSection(theme, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(ColorScheme colorScheme) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: CustomImageWidget(
            imageUrl: mealData["image"] as String,
            width: double.infinity,
            height: 20.h,
            fit: BoxFit.cover,
            semanticLabel: mealData["semanticLabel"] as String,
          ),
        ),
        Positioned(
          top: 2.h,
          right: 4.w,
          child: _buildWaitTimeBadge(colorScheme),
        ),
        if ((mealData["dietaryTags"] as List).isNotEmpty)
          Positioned(
            top: 2.h,
            left: 4.w,
            child: _buildDietaryBadges(),
          ),
      ],
    );
  }

  Widget _buildWaitTimeBadge(ColorScheme colorScheme) {
    final waitTime = mealData["waitTime"] as int;
    Color badgeColor;

    if (waitTime <= 5) {
      badgeColor = AppTheme.successLight;
    } else if (waitTime <= 15) {
      badgeColor = AppTheme.warningLight;
    } else {
      badgeColor = AppTheme.errorLight;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${waitTime}min wait',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDietaryBadges() {
    final tags = (mealData["dietaryTags"] as List).take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tags
          .map((tag) => Container(
                margin: EdgeInsets.only(bottom: 0.5.h),
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag as String,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildContentSection(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  mealData["diningHall"] as String,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                mealData["priceRange"] as String,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.primaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            mealData["featuredMeal"] as String,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'directions_walk',
                color: colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                '${mealData["walkingTime"]} min walk',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: 4.w),
              CustomIconWidget(
                iconName: 'local_dining',
                color: colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  (mealData["nutritionalHighlights"] as List).join(' • '),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
