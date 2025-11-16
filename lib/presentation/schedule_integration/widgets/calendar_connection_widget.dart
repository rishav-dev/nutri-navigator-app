import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Widget for managing Google Calendar connection status and actions
class CalendarConnectionWidget extends StatelessWidget {
  const CalendarConnectionWidget({
    super.key,
    required this.isConnected,
    required this.onConnectPressed,
    required this.onReconnectPressed,
  });

  final bool isConnected;
  final VoidCallback onConnectPressed;
  final VoidCallback onReconnectPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildConnectionStatus(context),
          SizedBox(height: 3.h),
          _buildConnectionButton(context),
        ],
      ),
    );
  }

  /// Build connection status indicator
  Widget _buildConnectionStatus(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: isConnected
                ? AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: isConnected ? 'check_circle' : 'error_outline',
            color: isConnected
                ? AppTheme.lightTheme.colorScheme.tertiary
                : AppTheme.lightTheme.colorScheme.error,
            size: 8.w,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          isConnected ? 'Calendar Connected' : 'Calendar Disconnected',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: isConnected
                ? AppTheme.lightTheme.colorScheme.tertiary
                : AppTheme.lightTheme.colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          isConnected
              ? 'Your Google Calendar is successfully connected and syncing'
              : 'Connect your Google Calendar to get personalized meal recommendations',
          textAlign: TextAlign.center,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Build connection action button
  Widget _buildConnectionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isConnected ? onReconnectPressed : onConnectPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isConnected
              ? AppTheme.lightTheme.colorScheme.secondary
              : AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: isConnected ? 'refresh' : 'calendar_today',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              isConnected ? 'Reconnect Calendar' : 'Connect Google Calendar',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
