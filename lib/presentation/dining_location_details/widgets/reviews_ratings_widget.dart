import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReviewsRatingsWidget extends StatelessWidget {
  final double overallRating;
  final List<Map<String, dynamic>> recentReviews;

  const ReviewsRatingsWidget({
    super.key,
    required this.overallRating,
    required this.recentReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviews & Ratings',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          _buildOverallRatingSection(),
          SizedBox(height: 3.h),
          Text(
            'Recent Reviews',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentReviews.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              return _buildReviewCard(recentReviews[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverallRatingSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                overallRating.toStringAsFixed(1),
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: List.generate(5, (index) {
                  return CustomIconWidget(
                    iconName: index < overallRating.floor()
                        ? 'star'
                        : (index < overallRating ? 'star_half' : 'star_border'),
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Based on ${recentReviews.length} student reviews',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 1.h),
                _buildRatingBreakdown(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBreakdown() {
    final ratingCounts = [0, 0, 0, 0, 0];
    for (final review in recentReviews) {
      final rating = (review['rating'] as double).round() - 1;
      if (rating >= 0 && rating < 5) {
        ratingCounts[4 - rating]++;
      }
    }

    return Column(
      children: List.generate(5, (index) {
        final starCount = 5 - index;
        final count = ratingCounts[index];
        final percentage =
            recentReviews.isNotEmpty ? count / recentReviews.length : 0.0;

        return Padding(
          padding: EdgeInsets.only(bottom: 0.5.h),
          child: Row(
            children: [
              Text(
                '$starCount',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: 2.w),
              CustomIconWidget(
                iconName: 'star',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 12,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                '$count',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                child: Text(
                  (review['studentName'] as String)
                      .substring(0, 1)
                      .toUpperCase(),
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['studentName'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return CustomIconWidget(
                              iconName:
                                  index < (review['rating'] as double).floor()
                                      ? 'star'
                                      : 'star_border',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 14,
                            );
                          }),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          review['date'] as String,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            review['comment'] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
