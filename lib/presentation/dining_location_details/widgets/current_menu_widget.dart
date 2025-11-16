import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CurrentMenuWidget extends StatelessWidget {
  final List<Map<String, dynamic>> menuData;
  final Function(Map<String, dynamic>) onMenuItemTap;

  const CurrentMenuWidget({
    super.key,
    required this.menuData,
    required this.onMenuItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Menu',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: menuData.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final mealPeriod = menuData[index];
              return _buildMealPeriodSection(mealPeriod);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMealPeriodSection(Map<String, dynamic> mealPeriod) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: _getMealPeriodIcon(mealPeriod['period'] as String),
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Text(
                  mealPeriod['period'] as String,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  mealPeriod['time'] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: (mealPeriod['items'] as List<Map<String, dynamic>>)
                  .map((item) => _buildMenuItem(item))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => onMenuItemTap(item),
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['name'] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Text(
                        item['price'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: (item['dietaryTags'] as List<String>)
                        .map((tag) => _buildDietaryTag(tag))
                        .toList(),
                  ),
                ],
              ),
            ),
            SizedBox(width: 3.w),
            CustomIconWidget(
              iconName: 'info_outline',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietaryTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: _getDietaryTagColor(tag).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getDietaryTagColor(tag).withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        tag,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: _getDietaryTagColor(tag),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getMealPeriodIcon(String period) {
    switch (period.toLowerCase()) {
      case 'breakfast':
        return 'wb_sunny';
      case 'lunch':
        return 'wb_sunny_outlined';
      case 'dinner':
        return 'nights_stay';
      default:
        return 'restaurant';
    }
  }

  Color _getDietaryTagColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'vegetarian':
      case 'vegan':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'gluten-free':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'high-protein':
        return AppTheme.lightTheme.colorScheme.primary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }
}
