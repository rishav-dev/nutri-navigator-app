import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Empty state widget for when no classes are scheduled
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageWidget(
            imageUrl:
                'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=400',
            width: 40.w,
            height: 25.h,
            fit: BoxFit.cover,
            semanticLabel:
                'Colorful healthy food bowl with vegetables and grains representing campus dining options',
          ),
          SizedBox(height: 4.h),
          Text(
            'No Classes Today!',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            'Perfect day to explore campus dining options and discover new favorite meals.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _exploreCampusDining(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryLight,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'explore',
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Explore Campus Dining',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          OutlinedButton(
            onPressed: () => _viewMealHistory(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryLight,
              side: BorderSide(color: AppTheme.primaryLight),
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'View Meal History',
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppTheme.primaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to campus dining exploration
  void _exploreCampusDining(BuildContext context) {
    Navigator.pushNamed(context, '/dining-location-details');
  }

  /// Navigate to meal history
  void _viewMealHistory(BuildContext context) {
    Navigator.pushNamed(context, '/meal-history');
  }
}
