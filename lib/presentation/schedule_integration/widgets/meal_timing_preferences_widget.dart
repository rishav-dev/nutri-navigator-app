import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Widget for managing meal timing preferences with platform-specific time pickers
class MealTimingPreferencesWidget extends StatelessWidget {
  const MealTimingPreferencesWidget({
    super.key,
    required this.breakfastTime,
    required this.lunchTime,
    required this.dinnerTime,
    required this.weekendRecommendations,
    required this.breakPeriodAdjustments,
    required this.onBreakfastTimeChanged,
    required this.onLunchTimeChanged,
    required this.onDinnerTimeChanged,
    required this.onWeekendToggle,
    required this.onBreakPeriodToggle,
  });

  final TimeOfDay breakfastTime;
  final TimeOfDay lunchTime;
  final TimeOfDay dinnerTime;
  final bool weekendRecommendations;
  final bool breakPeriodAdjustments;
  final ValueChanged<TimeOfDay> onBreakfastTimeChanged;
  final ValueChanged<TimeOfDay> onLunchTimeChanged;
  final ValueChanged<TimeOfDay> onDinnerTimeChanged;
  final ValueChanged<bool> onWeekendToggle;
  final ValueChanged<bool> onBreakPeriodToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context),
          SizedBox(height: 3.h),
          _buildMealTimeSelector(
              context, 'Breakfast', breakfastTime, onBreakfastTimeChanged),
          SizedBox(height: 2.h),
          _buildMealTimeSelector(
              context, 'Lunch', lunchTime, onLunchTimeChanged),
          SizedBox(height: 2.h),
          _buildMealTimeSelector(
              context, 'Dinner', dinnerTime, onDinnerTimeChanged),
          SizedBox(height: 3.h),
          _buildToggleOptions(context),
        ],
      ),
    );
  }

  /// Build section header
  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'schedule',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 5.w,
        ),
        SizedBox(width: 3.w),
        Text(
          'Meal Timing Preferences',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Build meal time selector with platform-specific time picker
  Widget _buildMealTimeSelector(
    BuildContext context,
    String mealName,
    TimeOfDay selectedTime,
    ValueChanged<TimeOfDay> onTimeChanged,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: _getMealIcon(mealName),
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                mealName,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => _showTimePicker(context, selectedTime, onTimeChanged),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                selectedTime.format(context),
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build toggle options for weekend and break period adjustments
  Widget _buildToggleOptions(BuildContext context) {
    return Column(
      children: [
        _buildToggleOption(
          context,
          'Weekend Recommendations',
          'Get meal suggestions on weekends',
          weekendRecommendations,
          onWeekendToggle,
        ),
        SizedBox(height: 2.h),
        _buildToggleOption(
          context,
          'Break Period Adjustments',
          'Adjust recommendations during academic breaks',
          breakPeriodAdjustments,
          onBreakPeriodToggle,
        ),
      ],
    );
  }

  /// Build individual toggle option
  Widget _buildToggleOption(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                subtitle,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      ],
    );
  }

  /// Show platform-specific time picker
  void _showTimePicker(
    BuildContext context,
    TimeOfDay currentTime,
    ValueChanged<TimeOfDay> onTimeChanged,
  ) {
    if (Platform.isIOS) {
      _showCupertinoTimePicker(context, currentTime, onTimeChanged);
    } else {
      _showMaterialTimePicker(context, currentTime, onTimeChanged);
    }
  }

  /// Show iOS-style time picker
  void _showCupertinoTimePicker(
    BuildContext context,
    TimeOfDay currentTime,
    ValueChanged<TimeOfDay> onTimeChanged,
  ) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 40.h,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: const Text('Done'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime(
                  2023,
                  1,
                  1,
                  currentTime.hour,
                  currentTime.minute,
                ),
                onDateTimeChanged: (DateTime dateTime) {
                  onTimeChanged(TimeOfDay(
                    hour: dateTime.hour,
                    minute: dateTime.minute,
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show Material Design time picker
  void _showMaterialTimePicker(
    BuildContext context,
    TimeOfDay currentTime,
    ValueChanged<TimeOfDay> onTimeChanged,
  ) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.colorScheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      onTimeChanged(selectedTime);
    }
  }

  /// Get appropriate icon for meal type
  String _getMealIcon(String mealName) {
    switch (mealName.toLowerCase()) {
      case 'breakfast':
        return 'free_breakfast';
      case 'lunch':
        return 'lunch_dining';
      case 'dinner':
        return 'dinner_dining';
      default:
        return 'restaurant';
    }
  }
}
