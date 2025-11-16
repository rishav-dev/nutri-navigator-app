import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tab bar variants for different content contexts
enum CustomTabBarVariant {
  primary,
  secondary,
  minimal,
}

/// Tab item data structure
class TabItem {
  final String label;
  final IconData? icon;
  final Widget content;

  const TabItem({
    required this.label,
    this.icon,
    required this.content,
  });
}

/// Production-ready custom tab bar with progressive information disclosure
/// Implements adaptive navigation patterns for meal planning workflows
class CustomTabBar extends StatefulWidget {
  const CustomTabBar({
    super.key,
    required this.tabs,
    this.variant = CustomTabBarVariant.primary,
    this.initialIndex = 0,
    this.onTabChanged,
    this.isScrollable = false,
  });

  final List<TabItem> tabs;
  final CustomTabBarVariant variant;
  final int initialIndex;
  final ValueChanged<int>? onTabChanged;
  final bool isScrollable;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      widget.onTabChanged?.call(_tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        _buildTabBar(context, theme, colorScheme),
        Expanded(
          child: _buildTabBarView(context),
        ),
      ],
    );
  }

  /// Build tab bar based on variant
  Widget _buildTabBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    switch (widget.variant) {
      case CustomTabBarVariant.secondary:
        return _buildSecondaryTabBar(context, colorScheme);
      case CustomTabBarVariant.minimal:
        return _buildMinimalTabBar(context, colorScheme);
      case CustomTabBarVariant.primary:
      default:
        return _buildPrimaryTabBar(context, colorScheme);
    }
  }

  /// Primary tab bar for main content sections
  Widget _buildPrimaryTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withAlpha(51),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.isScrollable,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorColor: colorScheme.primary,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        tabs: widget.tabs.map((tab) => _buildTab(tab, showIcon: true)).toList(),
      ),
    );
  }

  /// Secondary tab bar for sub-sections
  Widget _buildSecondaryTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withAlpha(51),
          width: 1,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.isScrollable,
        labelColor: colorScheme.onPrimary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicator: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        tabs:
            widget.tabs.map((tab) => _buildTab(tab, showIcon: false)).toList(),
      ),
    );
  }

  /// Minimal tab bar for simple navigation
  Widget _buildMinimalTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.isScrollable,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
          insets: const EdgeInsets.symmetric(horizontal: 16),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        tabs:
            widget.tabs.map((tab) => _buildTab(tab, showIcon: false)).toList(),
      ),
    );
  }

  /// Build individual tab with optional icon
  Widget _buildTab(TabItem tabItem, {required bool showIcon}) {
    return Tab(
      icon: showIcon && tabItem.icon != null
          ? Icon(tabItem.icon, size: 20)
          : null,
      text: tabItem.label,
      height: showIcon && tabItem.icon != null ? 72 : 48,
    );
  }

  /// Build tab bar view with smooth transitions
  Widget _buildTabBarView(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: widget.tabs.map((tab) => tab.content).toList(),
    );
  }
}

/// Predefined tab configurations for common meal planning scenarios
class MealPlanningTabs {
  /// Main dashboard tabs
  static List<TabItem> get dashboardTabs => [
        TabItem(
          label: 'Today',
          icon: Icons.today,
          content: _buildTodayContent(),
        ),
        TabItem(
          label: 'Upcoming',
          icon: Icons.schedule,
          content: _buildUpcomingContent(),
        ),
        TabItem(
          label: 'Favorites',
          icon: Icons.favorite_outline,
          content: _buildFavoritesContent(),
        ),
      ];

  /// Meal recommendation tabs
  static List<TabItem> get recommendationTabs => [
        TabItem(
          label: 'Quick Picks',
          content: _buildQuickPicksContent(),
        ),
        TabItem(
          label: 'Healthy',
          content: _buildHealthyContent(),
        ),
        TabItem(
          label: 'Budget',
          content: _buildBudgetContent(),
        ),
      ];

  /// History tabs
  static List<TabItem> get historyTabs => [
        TabItem(
          label: 'Recent',
          content: _buildRecentContent(),
        ),
        TabItem(
          label: 'This Week',
          content: _buildWeekContent(),
        ),
        TabItem(
          label: 'All Time',
          content: _buildAllTimeContent(),
        ),
      ];

  // Placeholder content builders
  static Widget _buildTodayContent() => const Center(
        child: Text('Today\'s meal recommendations will appear here'),
      );

  static Widget _buildUpcomingContent() => const Center(
        child: Text('Upcoming scheduled meals will appear here'),
      );

  static Widget _buildFavoritesContent() => const Center(
        child: Text('Your favorite meals will appear here'),
      );

  static Widget _buildQuickPicksContent() => const Center(
        child: Text('Quick meal recommendations based on your schedule'),
      );

  static Widget _buildHealthyContent() => const Center(
        child: Text('Healthy meal options matching your goals'),
      );

  static Widget _buildBudgetContent() => const Center(
        child: Text('Budget-friendly meal recommendations'),
      );

  static Widget _buildRecentContent() => const Center(
        child: Text('Your recent meal history'),
      );

  static Widget _buildWeekContent() => const Center(
        child: Text('This week\'s meal activity'),
      );

  static Widget _buildAllTimeContent() => const Center(
        child: Text('Complete meal history and statistics'),
      );
}
