import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Bottom navigation bar variants for different app states
enum CustomBottomBarVariant {
  main,
  minimal,
}

/// Navigation item data structure
class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String route;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// Production-ready custom bottom navigation bar
/// Implements gesture-aware navigation with contextual floating actions
class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.variant = CustomBottomBarVariant.main,
    this.showFloatingAction = true,
    this.onFloatingActionPressed,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final CustomBottomBarVariant variant;
  final bool showFloatingAction;
  final VoidCallback? onFloatingActionPressed;

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // Hardcoded navigation items for consistent app structure
  static const List<BottomNavItem> _mainNavItems = [
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      route: '/main-dashboard',
    ),
    BottomNavItem(
      icon: Icons.restaurant_menu_outlined,
      activeIcon: Icons.restaurant_menu,
      label: 'Meals',
      route: '/meal-recommendations',
    ),
    BottomNavItem(
      icon: Icons.schedule_outlined,
      activeIcon: Icons.schedule,
      label: 'Schedule',
      route: '/schedule-integration',
    ),
    BottomNavItem(
      icon: Icons.history_outlined,
      activeIcon: Icons.history,
      label: 'History',
      route: '/meal-history',
    ),
  ];

  static const List<BottomNavItem> _minimalNavItems = [
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      route: '/main-dashboard',
    ),
    BottomNavItem(
      icon: Icons.restaurant_menu_outlined,
      activeIcon: Icons.restaurant_menu,
      label: 'Meals',
      route: '/meal-recommendations',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final navItems = widget.variant == CustomBottomBarVariant.main
        ? _mainNavItems
        : _minimalNavItems;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildBottomNavigationBar(context, theme, colorScheme, navItems),
        if (widget.showFloatingAction &&
            widget.variant == CustomBottomBarVariant.main)
          _buildFloatingActionButton(context, colorScheme),
      ],
    );
  }

  /// Build the main bottom navigation bar
  Widget _buildBottomNavigationBar(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    List<BottomNavItem> navItems,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = widget.currentIndex == index;

              return _buildNavItem(
                context,
                colorScheme,
                item,
                isSelected,
                () => _handleNavTap(context, index, item.route),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Build individual navigation item with subtle animations
  Widget _buildNavItem(
    BuildContext context,
    ColorScheme colorScheme,
    BottomNavItem item,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        onTap: onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isSelected ? _scaleAnimation.value : 1.0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary.withAlpha(26)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isSelected && item.activeIcon != null
                            ? item.activeIcon!
                            : item.icon,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build contextual floating action button
  Widget _buildFloatingActionButton(
      BuildContext context, ColorScheme colorScheme) {
    return Positioned(
      top: -28,
      right: 24,
      child: FloatingActionButton(
        onPressed: widget.onFloatingActionPressed ??
            () => _getRecommendations(context),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4.0,
        child: const Icon(Icons.restaurant, size: 28),
      ),
    );
  }

  /// Handle navigation tap with route management
  void _handleNavTap(BuildContext context, int index, String route) {
    widget.onTap(index);

    // Navigate to the selected route if not already there
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != route) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false,
      );
    }
  }

  /// Get meal recommendations action
  void _getRecommendations(BuildContext context) {
    Navigator.pushNamed(context, '/meal-recommendations');
  }
}
