import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Timeline widget showing today's schedule with meal recommendation slots
class ScheduleTimelineWidget extends StatelessWidget {
  const ScheduleTimelineWidget({super.key});

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
                iconName: 'schedule',
                color: AppTheme.primaryLight,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Today\'s Schedule',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildTimelineItem(
            context,
            '8:00 AM',
            'Breakfast Time',
            'Recommended meal slot',
            true,
            colorScheme,
          ),
          _buildTimelineItem(
            context,
            '9:30 AM',
            'Biology 101',
            'Science Building - Room 204',
            false,
            colorScheme,
          ),
          _buildTimelineItem(
            context,
            '12:00 PM',
            'Lunch Break',
            'Perfect time for a healthy meal',
            true,
            colorScheme,
          ),
          _buildTimelineItem(
            context,
            '1:30 PM',
            'Mathematics',
            'Math Building - Room 105',
            false,
            colorScheme,
          ),
          _buildTimelineItem(
            context,
            '6:30 PM',
            'Dinner Time',
            'End your day with a nutritious meal',
            true,
            colorScheme,
          ),
        ],
      ),
    );
  }

  /// Build individual timeline item
  Widget _buildTimelineItem(
    BuildContext context,
    String time,
    String title,
    String subtitle,
    bool isMealSlot,
    ColorScheme colorScheme,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          // Timeline indicator
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isMealSlot ? AppTheme.primaryLight : colorScheme.outline,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 3.w),
          // Time
          SizedBox(
            width: 20.w,
            child: Text(
              time,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          // Content
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
              decoration: BoxDecoration(
                color: isMealSlot
                    ? AppTheme.primaryLight.withValues(alpha: 0.1)
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: isMealSlot
                    ? Border.all(
                        color: AppTheme.primaryLight.withValues(alpha: 0.3))
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
