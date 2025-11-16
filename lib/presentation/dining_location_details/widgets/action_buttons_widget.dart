import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onGetDirections;
  final VoidCallback onSetReminder;
  final VoidCallback onShare;

  const ActionButtonsWidget({
    super.key,
    required this.onGetDirections,
    required this.onSetReminder,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onGetDirections,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 3.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'directions',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Get Directions',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 3.w),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onSetReminder,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.lightTheme.colorScheme.primary,
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 1.5,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 2.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 18,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Set Reminder',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: onShare,
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 2.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 18,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Share',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
