import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import 'widgets/empty_state_widget.dart';
import 'widgets/greeting_header_widget.dart';
import 'widgets/meal_recommendations_section_widget.dart';
import 'widgets/quick_stats_widget.dart';
import 'widgets/schedule_timeline_widget.dart';

/// Main Dashboard screen serving as the primary hub for meal recommendations
class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard>
    with TickerProviderStateMixin {
  int _currentBottomNavIndex = 0;
  bool _isLoading = false;
  bool _hasClassesToday = true;
  DateTime _lastUpdated = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeDashboard();
  }

  /// Initialize dashboard data
  Future<void> _initializeDashboard() async {
    setState(() => _isLoading = true);

    // Simulate data loading
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isLoading = false;
      _lastUpdated = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingState(context)
            : _buildMainContent(context),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _handleBottomNavTap,
        showFloatingAction: true,
        onFloatingActionPressed: _handleFindMealNow,
      ),
      floatingActionButton: _buildFloatingActionButton(context, colorScheme),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// Build loading state
  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primaryLight,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading your meal recommendations...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Build main dashboard content
  Widget _buildMainContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.primaryLight,
      child: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GreetingHeaderWidget(),
                SizedBox(height: 2.h),
                _hasClassesToday
                    ? _buildScheduleContent()
                    : _buildEmptyStateContent(),
                SizedBox(height: 3.h),
                const QuickStatsWidget(),
                SizedBox(height: 2.h),
                _buildLastUpdatedInfo(context),
                SizedBox(height: 10.h), // Bottom padding for FAB
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build custom app bar
  Widget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverAppBar(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 1.0,
      floating: true,
      snap: true,
      title: Row(
        children: [
          CustomImageWidget(
            imageUrl:
                'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=100',
            width: 32,
            height: 32,
            fit: BoxFit.cover,
            semanticLabel:
                'Nutri Navigator app logo with crossed fork and spoon in yellow circle',
          ),
          SizedBox(width: 2.w),
          Text(
            'Nutri Navigator',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _showNotifications,
          icon: Stack(
            children: [
              CustomIconWidget(
                iconName: 'notifications_outlined',
                color: colorScheme.onSurface,
                size: 24,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          tooltip: 'Notifications',
        ),
        IconButton(
          onPressed: _showSettingsMenu,
          icon: CustomIconWidget(
            iconName: 'settings_outlined',
            color: colorScheme.onSurface,
            size: 24,
          ),
          tooltip: 'Settings',
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  /// Build schedule content when classes are available
  Widget _buildScheduleContent() {
    return Column(
      children: [
        const ScheduleTimelineWidget(),
        SizedBox(height: 3.h),
        const MealRecommendationsSectionWidget(),
      ],
    );
  }

  /// Build empty state content when no classes
  Widget _buildEmptyStateContent() {
    return const EmptyStateWidget();
  }

  /// Build last updated information
  Widget _buildLastUpdatedInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final timeAgo = DateTime.now().difference(_lastUpdated).inMinutes;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'update',
            color: colorScheme.onSurfaceVariant,
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(
            'Last updated ${timeAgo == 0 ? 'just now' : '$timeAgo minutes ago'}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Build floating action button
  Widget _buildFloatingActionButton(
      BuildContext context, ColorScheme colorScheme) {
    return FloatingActionButton.extended(
      onPressed: _handleFindMealNow,
      backgroundColor: AppTheme.primaryLight,
      foregroundColor: Colors.white,
      elevation: 4.0,
      icon: CustomIconWidget(
        iconName: 'restaurant',
        color: Colors.white,
        size: 24,
      ),
      label: Text(
        'Find Meal Now',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  /// Handle pull to refresh
  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    await _initializeDashboard();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recommendations updated!'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Handle bottom navigation tap
  void _handleBottomNavTap(int index) {
    setState(() => _currentBottomNavIndex = index);

    // Navigation is handled by CustomBottomBar
    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/meal-recommendations');
        break;
      case 2:
        Navigator.pushNamed(context, '/schedule-integration');
        break;
      case 3:
        Navigator.pushNamed(context, '/meal-history');
        break;
    }
  }

  /// Handle find meal now action
  void _handleFindMealNow() {
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(context, '/meal-recommendations');
  }

  /// Show notifications
  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'notifications',
                  color: AppTheme.primaryLight,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'restaurant',
                  color: AppTheme.primaryLight,
                  size: 20,
                ),
              ),
              title: const Text('Lunch Reminder'),
              subtitle: const Text('Perfect time for your Mediterranean wrap!'),
              trailing: const Text('12:00 PM'),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.successLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'local_offer',
                  color: AppTheme.successLight,
                  size: 20,
                ),
              ),
              title: const Text('Special Offer'),
              subtitle: const Text('20% off at Campus Café today!'),
              trailing: const Text('2h ago'),
            ),
          ],
        ),
      ),
    );
  }

  /// Show settings menu
  void _showSettingsMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'settings',
                  color: AppTheme.primaryLight,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Quick Settings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'schedule',
                color: Theme.of(context).colorScheme.onSurface,
                size: 20,
              ),
              title: const Text('Schedule Integration'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/schedule-integration');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'location_on',
                color: Theme.of(context).colorScheme.onSurface,
                size: 20,
              ),
              title: const Text('Dining Locations'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/dining-location-details');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'tune',
                color: Theme.of(context).colorScheme.onSurface,
                size: 20,
              ),
              title: const Text('Preferences'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to preferences when available
              },
            ),
          ],
        ),
      ),
    );
  }
}
