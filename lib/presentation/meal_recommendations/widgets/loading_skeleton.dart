import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Loading skeleton for meal recommendation cards
class LoadingSkeleton extends StatefulWidget {
  const LoadingSkeleton({super.key});

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) => _buildSkeletonCard(colorScheme),
    );
  }

  Widget _buildSkeletonCard(ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSkeletonImage(colorScheme),
          _buildSkeletonContent(colorScheme),
        ],
      ),
    );
  }

  Widget _buildSkeletonImage(ColorScheme colorScheme) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 20.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(
              alpha: _animation.value,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonContent(ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSkeletonLine(colorScheme, width: 60.w),
              ),
              _buildSkeletonLine(colorScheme, width: 15.w),
            ],
          ),
          SizedBox(height: 1.h),
          _buildSkeletonLine(colorScheme, width: 80.w),
          SizedBox(height: 0.5.h),
          _buildSkeletonLine(colorScheme, width: 50.w),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              _buildSkeletonLine(colorScheme, width: 25.w),
              SizedBox(width: 4.w),
              _buildSkeletonLine(colorScheme, width: 35.w),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLine(ColorScheme colorScheme, {required double width}) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: 2.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(
              alpha: _animation.value,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}
