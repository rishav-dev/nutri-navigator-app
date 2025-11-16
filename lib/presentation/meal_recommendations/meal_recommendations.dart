import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import 'widgets/empty_state_widget.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'widgets/loading_skeleton.dart';
import 'widgets/meal_recommendation_card.dart';

/// Meal Recommendations screen providing AI-powered dining suggestions
class MealRecommendations extends StatefulWidget {
  const MealRecommendations({super.key});

  @override
  State<MealRecommendations> createState() => _MealRecommendationsState();
}

class _MealRecommendationsState extends State<MealRecommendations> {
  bool _isLoading = true;
  bool _isRefreshing = false;
  Map<String, bool> _activeFilters = {};
  List<Map<String, dynamic>> _recommendations = [];
  final ScrollController _scrollController = ScrollController();

  // Mock meal recommendations data
  final List<Map<String, dynamic>> _mockRecommendations = [
    {
      "id": 1,
      "diningHall": "Central Dining Commons",
      "featuredMeal": "Grilled Chicken Caesar Salad with Parmesan Croutons",
      "waitTime": 3,
      "walkingTime": 5,
      "priceRange": "\$8-12",
      "nutritionalHighlights": ["High Protein", "Low Carb", "Gluten Free"],
      "dietaryTags": ["GF", "HP"],
      "image":
          "https://images.unsplash.com/photo-1669472546301-6ea7e733b130",
      "semanticLabel":
          "Fresh Caesar salad with grilled chicken breast, romaine lettuce, parmesan cheese, and golden croutons in a white bowl",
      "tags": ["highProtein", "healthy", "glutenFree"]
    },
    {
      "id": 2,
      "diningHall": "Student Union Food Court",
      "featuredMeal": "Build-Your-Own Burrito Bowl",
      "waitTime": 8,
      "walkingTime": 2,
      "priceRange": "\$6-9",
      "nutritionalHighlights": [
        "Customizable",
        "Fresh Ingredients",
        "Balanced"
      ],
      "dietaryTags": ["V", "GF"],
      "image":
          "https://images.unsplash.com/photo-1543339186-90777e2cbf52",
      "semanticLabel":
          "Colorful burrito bowl with black beans, rice, grilled vegetables, avocado, and fresh cilantro in a ceramic bowl",
      "tags": ["budgetFriendly", "vegetarian", "healthy"]
    },
    {
      "id": 3,
      "diningHall": "Grab & Go Market",
      "featuredMeal": "Pre-made Protein Power Sandwich",
      "waitTime": 1,
      "walkingTime": 3,
      "priceRange": "\$5-7",
      "nutritionalHighlights": ["Quick Grab", "High Protein", "Portable"],
      "dietaryTags": ["HP", "QG"],
      "image":
          "https://images.unsplash.com/photo-1553909489-cd47e0907980",
      "semanticLabel":
          "Hearty sandwich with turkey, cheese, lettuce, and tomato on whole grain bread, wrapped in paper",
      "tags": ["quickGrab", "highProtein", "budgetFriendly"]
    },
    {
      "id": 4,
      "diningHall": "Wellness Café",
      "featuredMeal": "Quinoa Buddha Bowl with Tahini Dressing",
      "waitTime": 12,
      "walkingTime": 8,
      "priceRange": "\$9-13",
      "nutritionalHighlights": ["Superfood", "Plant-Based", "Antioxidants"],
      "dietaryTags": ["V", "GF", "SF"],
      "image":
          "https://images.unsplash.com/photo-1623428187425-873f16e10554",
      "semanticLabel":
          "Nutritious Buddha bowl with quinoa, roasted vegetables, chickpeas, avocado, and tahini dressing",
      "tags": ["healthy", "vegetarian", "glutenFree"]
    },
    {
      "id": 5,
      "diningHall": "Pizza Corner",
      "featuredMeal": "Personal Margherita Pizza",
      "waitTime": 15,
      "walkingTime": 4,
      "priceRange": "\$7-10",
      "nutritionalHighlights": ["Fresh Basil", "Mozzarella", "Comfort Food"],
      "dietaryTags": ["V"],
      "image":
          "https://images.unsplash.com/photo-1703784022146-b72677752ce5",
      "semanticLabel":
          "Classic Margherita pizza with fresh mozzarella, basil leaves, and tomato sauce on thin crust",
      "tags": ["vegetarian", "budgetFriendly"]
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadRecommendations() async {
    setState(() => _isLoading = true);

    // Simulate AI processing time
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _recommendations = _filterRecommendations(_mockRecommendations);
      _isLoading = false;
    });
  }

  Future<void> _refreshRecommendations() async {
    setState(() => _isRefreshing = true);

    // Simulate refresh with updated wait times
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _recommendations = _filterRecommendations(_mockRecommendations);
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Recommendations updated with latest wait times'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  List<Map<String, dynamic>> _filterRecommendations(
      List<Map<String, dynamic>> recommendations) {
    if (_activeFilters.isEmpty || !_activeFilters.containsValue(true)) {
      return recommendations;
    }

    return recommendations.where((meal) {
      final mealTags = (meal["tags"] as List<String>);
      return _activeFilters.entries
          .where((filter) => filter.value)
          .any((filter) => mealTags.contains(filter.key));
    }).toList();
  }

  void _showFilterBottomSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilters: _activeFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _activeFilters = filters;
            _recommendations = _filterRecommendations(_mockRecommendations);
          });
        },
      ),
    );
  }

  void _onMealCardTap(Map<String, dynamic> mealData) {
    HapticFeedback.selectionClick();
    Navigator.pushNamed(
      context,
      '/dining-location-details',
      arguments: mealData,
    );
  }

  void _onFavoriteMeal(Map<String, dynamic> mealData) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${mealData["featuredMeal"]} saved to favorites'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'View',
          onPressed: () => Navigator.pushNamed(context, '/meal-history'),
        ),
      ),
    );
  }

  void _onDismissMeal(Map<String, dynamic> mealData) {
    HapticFeedback.lightImpact();
    setState(() {
      _recommendations.removeWhere((meal) => meal["id"] == mealData["id"]);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Recommendation dismissed'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _recommendations.add(mealData);
              _recommendations
                  .sort((a, b) => (a["id"] as int).compareTo(b["id"] as int));
            });
          },
        ),
      ),
    );
  }

  void _navigateToBrowseAll() {
    Navigator.pushNamed(context, '/dining-location-details');
  }

  void _navigateToMapView() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Map view coming soon!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildStickyHeader(theme, colorScheme),
            Expanded(
              child: _buildMainContent(theme, colorScheme),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToMapView,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: CustomIconWidget(
          iconName: 'map',
          color: colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildStickyHeader(ThemeData theme, ColorScheme colorScheme) {
    final activeFilterCount =
        _activeFilters.values.where((value) => value).length;
    final currentTime = DateTime.now();
    final timeContext = _getTimeContext(currentTime);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meal Recommendations',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      timeContext,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _showFilterBottomSheet,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: activeFilterCount > 0
                        ? colorScheme.primary.withValues(alpha: 0.1)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    border: activeFilterCount > 0
                        ? Border.all(color: colorScheme.primary, width: 1)
                        : null,
                  ),
                  child: Stack(
                    children: [
                      CustomIconWidget(
                        iconName: 'tune',
                        color: activeFilterCount > 0
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                        size: 24,
                      ),
                      if (activeFilterCount > 0)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$activeFilterCount',
                                style: TextStyle(
                                  color: colorScheme.onPrimary,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (activeFilterCount > 0) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'filter_alt',
                    color: colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      '$activeFilterCount filter${activeFilterCount > 1 ? 's' : ''} applied',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeFilters.clear();
                        _recommendations =
                            _filterRecommendations(_mockRecommendations);
                      });
                    },
                    child: Text(
                      'Clear',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMainContent(ThemeData theme, ColorScheme colorScheme) {
    if (_isLoading) {
      return const LoadingSkeleton();
    }

    if (_recommendations.isEmpty) {
      return EmptyStateWidget(
        onBrowseAll: _navigateToBrowseAll,
        onAdjustFilters: _showFilterBottomSheet,
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshRecommendations,
      color: colorScheme.primary,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _recommendations.length + 1,
        itemBuilder: (context, index) {
          if (index == _recommendations.length) {
            return _buildBottomSection(theme, colorScheme);
          }

          final meal = _recommendations[index];
          return MealRecommendationCard(
            mealData: meal,
            onTap: () => _onMealCardTap(meal),
            onFavorite: () => _onFavoriteMeal(meal),
            onDismiss: () => _onDismissMeal(meal),
          );
        },
      ),
    );
  }

  Widget _buildBottomSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'explore',
            color: colorScheme.onSurfaceVariant,
            size: 32,
          ),
          SizedBox(height: 2.h),
          Text(
            'Not finding what you want?',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Explore all campus dining locations and discover new favorites.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _navigateToBrowseAll,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Browse All Locations',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeContext(DateTime time) {
    final hour = time.hour;

    if (hour >= 6 && hour < 11) {
      return 'Perfect timing for breakfast • ${_formatTime(time)}';
    } else if (hour >= 11 && hour < 15) {
      return 'Great lunch options available • ${_formatTime(time)}';
    } else if (hour >= 15 && hour < 18) {
      return 'Afternoon snack time • ${_formatTime(time)}';
    } else if (hour >= 18 && hour < 22) {
      return 'Dinner recommendations • ${_formatTime(time)}';
    } else {
      return 'Late night options • ${_formatTime(time)}';
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }
}
