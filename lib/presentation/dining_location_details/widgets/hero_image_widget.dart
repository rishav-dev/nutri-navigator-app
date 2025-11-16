import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HeroImageWidget extends StatelessWidget {
  final String imageUrl;
  final String semanticLabel;
  final bool isOpen;
  final String waitTime;
  final String walkingDistance;

  const HeroImageWidget({
    super.key,
    required this.imageUrl,
    required this.semanticLabel,
    required this.isOpen,
    required this.waitTime,
    required this.walkingDistance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      width: double.infinity,
      child: Stack(
        children: [
          CustomImageWidget(
            imageUrl: imageUrl,
            width: double.infinity,
            height: 30.h,
            fit: BoxFit.cover,
            semanticLabel: semanticLabel,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                ],
              ),
            ),
          ),
          Positioned(
            top: 2.h,
            left: 4.w,
            child: _buildStatusBadge(),
          ),
          Positioned(
            top: 2.h,
            right: 4.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildInfoBadge(waitTime, 'schedule'),
                SizedBox(height: 1.h),
                _buildInfoBadge(walkingDistance, 'directions_walk'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isOpen
            ? AppTheme.lightTheme.colorScheme.tertiary
            : AppTheme.lightTheme.colorScheme.error,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            isOpen ? 'Open' : 'Closed',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(String text, String iconName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: Colors.white,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            text,
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
