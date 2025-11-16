import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Widget for displaying and managing calendar permissions
class CalendarPermissionsWidget extends StatelessWidget {
  const CalendarPermissionsWidget({
    super.key,
    required this.hasPermissions,
    required this.onModifyPermissions,
  });

  final bool hasPermissions;
  final VoidCallback onModifyPermissions;

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
          SizedBox(height: 2.h),
          _buildPermissionStatus(context),
          SizedBox(height: 2.h),
          _buildModifyButton(context),
        ],
      ),
    );
  }

  /// Build section header
  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'security',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 5.w,
        ),
        SizedBox(width: 3.w),
        Text(
          'Calendar Permissions',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Build permission status display
  Widget _buildPermissionStatus(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: hasPermissions
            ? AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: hasPermissions ? 'check_circle' : 'cancel',
            color: hasPermissions
                ? AppTheme.lightTheme.colorScheme.tertiary
                : AppTheme.lightTheme.colorScheme.error,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasPermissions ? 'Access Granted' : 'Access Denied',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: hasPermissions
                        ? AppTheme.lightTheme.colorScheme.tertiary
                        : AppTheme.lightTheme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  hasPermissions
                      ? 'Calendar events can be read and analyzed'
                      : 'Calendar access is required for meal recommendations',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build modify permissions button
  Widget _buildModifyButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onModifyPermissions,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: AppTheme.lightTheme.colorScheme.primary,
            width: 1.5,
          ),
          padding: EdgeInsets.symmetric(vertical: 1.2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Modify Permissions',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
