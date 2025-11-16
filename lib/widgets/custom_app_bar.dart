import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom app bar variants for different screen contexts
enum CustomAppBarVariant {
  standard,
  search,
  profile,
  back,
}

/// Production-ready custom app bar implementing Contemporary Campus Minimalism
/// Provides consistent navigation and branding across the application
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = CustomAppBarVariant.standard,
    this.actions,
    this.onSearchChanged,
    this.searchHint,
    this.showBackButton = false,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  final String title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final ValueChanged<String>? onSearchChanged;
  final String? searchHint;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomAppBarVariant.search:
        return _buildSearchAppBar(context, theme, colorScheme);
      case CustomAppBarVariant.profile:
        return _buildProfileAppBar(context, theme, colorScheme);
      case CustomAppBarVariant.back:
        return _buildBackAppBar(context, theme, colorScheme);
      case CustomAppBarVariant.standard:
      default:
        return _buildStandardAppBar(context, theme, colorScheme);
    }
  }

  /// Standard app bar for main navigation screens
  Widget _buildStandardAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? colorScheme.onSurface,
        ),
      ),
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation ?? 1.0,
      centerTitle: false,
      leading: _buildLeading(context),
      actions: [
        if (actions != null) ...actions!,
        _buildNotificationButton(context, colorScheme),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Search-enabled app bar for meal discovery
  Widget _buildSearchAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.outline.withAlpha(77)),
        ),
        child: TextField(
          onChanged: onSearchChanged,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: searchHint ?? 'Search meals...',
            hintStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurfaceVariant,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ),
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation ?? 1.0,
      leading: _buildLeading(context),
      actions: [
        IconButton(
          onPressed: () => _navigateToMealHistory(context),
          icon: const Icon(Icons.history),
          tooltip: 'Meal History',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Profile-focused app bar for user settings
  Widget _buildProfileAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? colorScheme.onSurface,
        ),
      ),
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation ?? 1.0,
      centerTitle: false,
      leading: _buildLeading(context),
      actions: [
        IconButton(
          onPressed: () => _showSettingsMenu(context),
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'Settings',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Back navigation app bar for detail screens
  Widget _buildBackAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? colorScheme.onSurface,
        ),
      ),
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation ?? 1.0,
      centerTitle: false,
      leading: IconButton(
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
      ),
      actions: actions,
    );
  }

  /// Build leading widget based on context
  Widget? _buildLeading(BuildContext context) {
    if (showBackButton) {
      return IconButton(
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
      );
    }

    // Show menu button for main screens
    if (variant == CustomAppBarVariant.standard) {
      return IconButton(
        onPressed: () => _navigateToMainDashboard(context),
        icon: const Icon(Icons.menu),
        tooltip: 'Menu',
      );
    }

    return null;
  }

  /// Build notification button with contextual badge
  Widget _buildNotificationButton(
      BuildContext context, ColorScheme colorScheme) {
    return Stack(
      children: [
        IconButton(
          onPressed: () => _showNotifications(context),
          icon: const Icon(Icons.notifications_outlined),
          tooltip: 'Notifications',
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  /// Navigate to main dashboard
  void _navigateToMainDashboard(BuildContext context) {
    Navigator.pushNamed(context, '/main-dashboard');
  }

  /// Navigate to meal history
  void _navigateToMealHistory(BuildContext context) {
    Navigator.pushNamed(context, '/meal-history');
  }

  /// Show settings menu
  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.schedule),
              title: Text(
                'Schedule Integration',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/schedule-integration');
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(
                'Dining Locations',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/dining-location-details');
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Show notifications
  void _showNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'No new notifications',
          style: GoogleFonts.inter(fontWeight: FontWeight.w400),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
