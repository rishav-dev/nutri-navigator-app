import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import 'widgets/calendar_connection_widget.dart';
import 'widgets/calendar_permissions_widget.dart';
import 'widgets/meal_timing_preferences_widget.dart';
import 'widgets/notification_settings_widget.dart';
import 'widgets/schedule_analysis_widget.dart';
import 'widgets/sync_controls_widget.dart';

/// Schedule Integration screen for managing Google Calendar connectivity and meal timing preferences
class ScheduleIntegration extends StatefulWidget {
  const ScheduleIntegration({super.key});

  @override
  State<ScheduleIntegration> createState() => _ScheduleIntegrationState();
}

class _ScheduleIntegrationState extends State<ScheduleIntegration> {
  // Calendar connection state
  bool _isCalendarConnected = false;
  bool _hasCalendarPermissions = false;
  bool _isSyncing = false;
  bool _isAnalyzing = false;
  DateTime? _lastSyncTime;

  // Meal timing preferences
  TimeOfDay _breakfastTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _lunchTime = const TimeOfDay(hour: 12, minute: 30);
  TimeOfDay _dinnerTime = const TimeOfDay(hour: 18, minute: 0);
  bool _weekendRecommendations = true;
  bool _breakPeriodAdjustments = true;

  // Notification settings
  bool _reminderEnabled = true;
  double _advanceNoticeMinutes = 30.0;

  // Changes tracking for save button
  bool _hasUnsavedChanges = false;

  // Mock data for schedule analysis
  final List<Map<String, dynamic>> _mockClassPatterns = [
    {
      'day': 'Monday',
      'classCount': 4,
      'duration': '8:00 AM - 4:00 PM',
    },
    {
      'day': 'Tuesday',
      'classCount': 3,
      'duration': '10:00 AM - 3:00 PM',
    },
    {
      'day': 'Wednesday',
      'classCount': 5,
      'duration': '9:00 AM - 5:00 PM',
    },
  ];

  final List<Map<String, dynamic>> _mockMealOpportunities = [
    {
      'mealType': 'Breakfast',
      'timeWindow': '7:30 - 8:30 AM',
      'duration': '45 minutes',
    },
    {
      'mealType': 'Lunch',
      'timeWindow': '12:00 - 1:30 PM',
      'duration': '1.5 hours',
    },
    {
      'mealType': 'Dinner',
      'timeWindow': '5:30 - 7:00 PM',
      'duration': '1.5 hours',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  /// Initialize settings and check connection status
  void _initializeSettings() {
    // Simulate checking existing connection status
    setState(() {
      _isCalendarConnected = false;
      _hasCalendarPermissions = false;
      _lastSyncTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  /// Build app bar with back button and save action
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
      elevation: 1.0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 6.w,
        ),
      ),
      title: Text(
        'Schedule Integration',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _hasUnsavedChanges ? _saveSettings : null,
          child: Text(
            'Save',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: _hasUnsavedChanges
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  /// Build main body content
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.h),

          // Calendar Connection Status
          CalendarConnectionWidget(
            isConnected: _isCalendarConnected,
            onConnectPressed: _connectCalendar,
            onReconnectPressed: _reconnectCalendar,
          ),

          // Calendar Permissions
          CalendarPermissionsWidget(
            hasPermissions: _hasCalendarPermissions,
            onModifyPermissions: _modifyPermissions,
          ),

          // Meal Timing Preferences
          MealTimingPreferencesWidget(
            breakfastTime: _breakfastTime,
            lunchTime: _lunchTime,
            dinnerTime: _dinnerTime,
            weekendRecommendations: _weekendRecommendations,
            breakPeriodAdjustments: _breakPeriodAdjustments,
            onBreakfastTimeChanged: _updateBreakfastTime,
            onLunchTimeChanged: _updateLunchTime,
            onDinnerTimeChanged: _updateDinnerTime,
            onWeekendToggle: _updateWeekendRecommendations,
            onBreakPeriodToggle: _updateBreakPeriodAdjustments,
          ),

          // Schedule Analysis
          if (_isCalendarConnected)
            ScheduleAnalysisWidget(
              isAnalyzing: _isAnalyzing,
              classPatterns: _mockClassPatterns,
              mealOpportunities: _mockMealOpportunities,
              onViewDetails: _viewScheduleDetails,
            ),

          // Notification Settings
          NotificationSettingsWidget(
            reminderEnabled: _reminderEnabled,
            advanceNoticeMinutes: _advanceNoticeMinutes,
            onReminderToggle: _updateReminderEnabled,
            onAdvanceNoticeChanged: _updateAdvanceNotice,
          ),

          // Sync Controls
          if (_isCalendarConnected)
            SyncControlsWidget(
              isSyncing: _isSyncing,
              lastSyncTime: _lastSyncTime,
              onSyncNow: _syncCalendar,
            ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  /// Connect Google Calendar
  void _connectCalendar() async {
    try {
      // Show loading state
      setState(() {
        _isSyncing = true;
      });

      // Simulate calendar connection process
      await Future.delayed(const Duration(seconds: 2));

      // Simulate successful connection
      setState(() {
        _isCalendarConnected = true;
        _hasCalendarPermissions = true;
        _isSyncing = false;
        _lastSyncTime = DateTime.now();
        _hasUnsavedChanges = true;
      });

      // Start schedule analysis
      _analyzeSchedule();

      // Show success feedback
      HapticFeedback.lightImpact();
      _showSuccessSnackBar('Google Calendar connected successfully!');
    } catch (e) {
      setState(() {
        _isSyncing = false;
      });
      _showErrorSnackBar('Failed to connect calendar. Please try again.');
    }
  }

  /// Reconnect Google Calendar
  void _reconnectCalendar() async {
    try {
      setState(() {
        _isSyncing = true;
      });

      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isSyncing = false;
        _lastSyncTime = DateTime.now();
        _hasUnsavedChanges = true;
      });

      _analyzeSchedule();
      HapticFeedback.lightImpact();
      _showSuccessSnackBar('Calendar reconnected successfully!');
    } catch (e) {
      setState(() {
        _isSyncing = false;
      });
      _showErrorSnackBar('Failed to reconnect calendar. Please try again.');
    }
  }

  /// Modify calendar permissions
  void _modifyPermissions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Calendar Permissions',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'To modify calendar permissions, please go to your device settings and update the permissions for Nutri Navigator.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessSnackBar('Opening system settings...');
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Analyze schedule for meal opportunities
  void _analyzeSchedule() async {
    setState(() {
      _isAnalyzing = true;
    });

    // Simulate schedule analysis
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isAnalyzing = false;
    });
  }

  /// View detailed schedule analysis
  void _viewScheduleDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        height: 70.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Schedule Analysis Details',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your schedule analysis shows optimal meal timing opportunities based on your class patterns. The AI has identified the best windows for breakfast, lunch, and dinner that align with your academic schedule.',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Recommendations:',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '• Plan breakfast before 8:30 AM on weekdays\n'
                      '• Lunch breaks are optimal between 12:00-1:30 PM\n'
                      '• Dinner timing works best after 5:30 PM\n'
                      '• Weekend schedule allows for more flexible timing',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Sync calendar manually
  void _syncCalendar() async {
    setState(() {
      _isSyncing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSyncing = false;
      _lastSyncTime = DateTime.now();
    });

    _analyzeSchedule();
    HapticFeedback.lightImpact();
    _showSuccessSnackBar('Calendar synced successfully!');
  }

  /// Update breakfast time
  void _updateBreakfastTime(TimeOfDay time) {
    setState(() {
      _breakfastTime = time;
      _hasUnsavedChanges = true;
    });
  }

  /// Update lunch time
  void _updateLunchTime(TimeOfDay time) {
    setState(() {
      _lunchTime = time;
      _hasUnsavedChanges = true;
    });
  }

  /// Update dinner time
  void _updateDinnerTime(TimeOfDay time) {
    setState(() {
      _dinnerTime = time;
      _hasUnsavedChanges = true;
    });
  }

  /// Update weekend recommendations setting
  void _updateWeekendRecommendations(bool enabled) {
    setState(() {
      _weekendRecommendations = enabled;
      _hasUnsavedChanges = true;
    });
  }

  /// Update break period adjustments setting
  void _updateBreakPeriodAdjustments(bool enabled) {
    setState(() {
      _breakPeriodAdjustments = enabled;
      _hasUnsavedChanges = true;
    });
  }

  /// Update reminder enabled setting
  void _updateReminderEnabled(bool enabled) {
    setState(() {
      _reminderEnabled = enabled;
      _hasUnsavedChanges = true;
    });
  }

  /// Update advance notice minutes
  void _updateAdvanceNotice(double minutes) {
    setState(() {
      _advanceNoticeMinutes = minutes;
      _hasUnsavedChanges = true;
    });
  }

  /// Save all settings
  void _saveSettings() async {
    try {
      // Simulate saving settings
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _hasUnsavedChanges = false;
      });

      HapticFeedback.lightImpact();
      _showSuccessSnackBar('Settings saved successfully!');
    } catch (e) {
      _showErrorSnackBar('Failed to save settings. Please try again.');
    }
  }

  /// Show success snack bar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Show error snack bar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: Colors.white,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
