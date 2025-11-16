import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationHeaderWidget extends StatefulWidget {
  final String locationName;
  final bool isFavorite;
  final VoidCallback onBackPressed;
  final VoidCallback onFavoriteToggle;

  const LocationHeaderWidget({
    super.key,
    required this.locationName,
    required this.isFavorite,
    required this.onBackPressed,
    required this.onFavoriteToggle,
  });

  @override
  State<LocationHeaderWidget> createState() => _LocationHeaderWidgetState();
}

class _LocationHeaderWidgetState extends State<LocationHeaderWidget> {
  void _handleFavoriteToggle() {
    HapticFeedback.lightImpact();
    widget.onFavoriteToggle();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            GestureDetector(
              onTap: widget.onBackPressed,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 20,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                widget.locationName,
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 4.w),
            GestureDetector(
              onTap: _handleFavoriteToggle,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: widget.isFavorite
                      ? AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.isFavorite
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.3)
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                  ),
                ),
                child: CustomIconWidget(
                  iconName: widget.isFavorite ? 'favorite' : 'favorite_border',
                  color: widget.isFavorite
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
