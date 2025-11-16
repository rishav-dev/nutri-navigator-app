import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Widget for managing meal reminder notification settings
class NotificationSettingsWidget extends StatelessWidget {
  const NotificationSettingsWidget({
    super.key,
    required this.reminderEnabled,
    required this.advanceNoticeMinutes,
    required this.onReminderToggle,
    required this.onAdvanceNoticeChanged,
  });

  final bool reminderEnabled;
  final double advanceNoticeMinutes;
  final ValueChanged<bool> onReminderToggle;
  final ValueChanged<double> onAdvanceNoticeChanged;

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
          _buildReminderToggle(context),
          if (reminderEnabled) ...[
            SizedBox(height: 3.h),
            _buildAdvanceNoticeSlider(context),
          ],
        ],
      ),
    );
  }

  /// Build section header
  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'notifications',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 5.w,
        ),
        SizedBox(width: 3.w),
        Text(
          'Notification Settings',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Build reminder toggle switch
  Widget _buildReminderToggle(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Meal Reminders',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Get notified before optimal meal times',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: reminderEnabled,
          onChanged: onReminderToggle,
          activeColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      ],
    );
  }

  /// Build advance notice slider
  Widget _buildAdvanceNoticeSlider(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Advance Notice',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${advanceNoticeMinutes.round()} min',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.lightTheme.colorScheme.primary,
            thumbColor: AppTheme.lightTheme.colorScheme.primary,
            overlayColor:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
            inactiveTrackColor:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: advanceNoticeMinutes,
            min: 15,
            max: 60,
            divisions: 9,
            onChanged: onAdvanceNoticeChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '15 min',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '60 min',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          'You\'ll receive notifications ${advanceNoticeMinutes.round()} minutes before recommended meal times',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
