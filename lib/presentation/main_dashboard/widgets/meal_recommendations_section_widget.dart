import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import 'meal_recommendation_card_widget.dart';

/// Section widget displaying meal recommendations grouped by time slots
class MealRecommendationsSectionWidget extends StatelessWidget {
  const MealRecommendationsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'restaurant',
                color: AppTheme.primaryLight,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Recommended for You',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        _buildBreakfastSection(context),
        SizedBox(height: 3.h),
        _buildLunchSection(context),
        SizedBox(height: 3.h),
        _buildDinnerSection(context),
      ],
    );
  }

  /// Build breakfast recommendations section
  Widget _buildBreakfastSection(BuildContext context) {
    final breakfastRecommendations = _getBreakfastRecommendations();

    return _buildMealSection(
      context,
      'Breakfast (8:00 AM)',
      breakfastRecommendations,
    );
  }

  /// Build lunch recommendations section
  Widget _buildLunchSection(BuildContext context) {
    final lunchRecommendations = _getLunchRecommendations();

    return _buildMealSection(
      context,
      'Lunch (12:00 PM)',
      lunchRecommendations,
    );
  }

  /// Build dinner recommendations section
  Widget _buildDinnerSection(BuildContext context) {
    final dinnerRecommendations = _getDinnerRecommendations();

    return _buildMealSection(
      context,
      'Dinner (6:30 PM)',
      dinnerRecommendations,
    );
  }

  /// Build individual meal section with recommendations
  Widget _buildMealSection(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> recommendations,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 45.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final meal = recommendations[index];
              return SizedBox(
                width: 85.w,
                child: MealRecommendationCardWidget(
                  mealData: meal,
                  onTap: () => _handleMealTap(context, meal),
                  onSave: () => _handleSaveMeal(context, meal),
                  onDismiss: () => _handleDismissMeal(context, meal),
                  onGetDirections: () => _handleGetDirections(context, meal),
                  onViewMenu: () => _handleViewMenu(context, meal),
                  onSetReminder: () => _handleSetReminder(context, meal),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Get breakfast recommendations mock data
  List<Map<String, dynamic>> _getBreakfastRecommendations() {
    return [
      {
        'id': 1,
        'name': 'Avocado Toast & Fresh Fruit',
        'description':
            'Whole grain toast topped with fresh avocado, cherry tomatoes, and a side of seasonal fruit.',
        'location': 'Campus Café',
        'mealType': 'Breakfast',
        'walkingTime': 3,
        'waitTime': 2,
        'price': '\$7.50',
        'valueIndicator': 'Great Value',
        'image':
            'https://images.unsplash.com/photo-1705872430145-5a20f840425c',
        'semanticLabel':
            'Sliced avocado on toasted bread with cherry tomatoes and mixed berries on a white plate',
        'tags': ['Healthy', 'Vegetarian', 'High Fiber'],
      },
      {
        'id': 2,
        'name': 'Protein Power Bowl',
        'description':
            'Greek yogurt with granola, mixed berries, and a drizzle of honey for sustained energy.',
        'location': 'Student Union',
        'mealType': 'Breakfast',
        'walkingTime': 5,
        'waitTime': 1,
        'price': '\$6.25',
        'valueIndicator': 'Budget Pick',
        'image':
            'https://images.unsplash.com/photo-1670843839025-d50924a51f31',
        'semanticLabel':
            'Greek yogurt bowl topped with granola, fresh blueberries, strawberries, and honey drizzle',
        'tags': ['High Protein', 'Quick', 'Energizing'],
      },
    ];
  }

  /// Get lunch recommendations mock data
  List<Map<String, dynamic>> _getLunchRecommendations() {
    return [
      {
        'id': 3,
        'name': 'Mediterranean Wrap',
        'description':
            'Grilled chicken, hummus, fresh vegetables, and feta cheese wrapped in a whole wheat tortilla.',
        'location': 'Main Dining Hall',
        'mealType': 'Lunch',
        'walkingTime': 4,
        'waitTime': 5,
        'price': '\$9.75',
        'valueIndicator': 'Popular Choice',
        'image':
            'https://images.unsplash.com/photo-1666819476628-2f3afb0ca147',
        'semanticLabel':
            'Wrapped tortilla filled with grilled chicken, lettuce, tomatoes, and feta cheese on a wooden board',
        'tags': ['High Protein', 'Mediterranean', 'Balanced'],
      },
      {
        'id': 4,
        'name': 'Quinoa Power Salad',
        'description':
            'Fresh quinoa salad with roasted vegetables, chickpeas, and tahini dressing.',
        'location': 'Health Hub',
        'mealType': 'Lunch',
        'walkingTime': 7,
        'waitTime': 3,
        'price': '\$8.50',
        'valueIndicator': 'Healthy Choice',
        'image':
            'https://images.unsplash.com/photo-1552613008-fb6553157f96',
        'semanticLabel':
            'Colorful quinoa salad with roasted vegetables, chickpeas, and greens in a white bowl',
        'tags': ['Vegan', 'Gluten-Free', 'Superfood'],
      },
      {
        'id': 5,
        'name': 'Classic Burger & Fries',
        'description':
            'Juicy beef burger with lettuce, tomato, and cheese, served with crispy sweet potato fries.',
        'location': 'Grill Station',
        'mealType': 'Lunch',
        'walkingTime': 2,
        'waitTime': 8,
        'price': '\$11.25',
        'valueIndicator': 'Comfort Food',
        'image':
            'https://images.unsplash.com/photo-1591336277932-f0579b75992b',
        'semanticLabel':
            'Beef burger with lettuce and tomato on a sesame bun, served with golden sweet potato fries',
        'tags': ['Classic', 'Filling', 'Comfort'],
      },
    ];
  }

  /// Get dinner recommendations mock data
  List<Map<String, dynamic>> _getDinnerRecommendations() {
    return [
      {
        'id': 6,
        'name': 'Grilled Salmon & Vegetables',
        'description':
            'Fresh Atlantic salmon with roasted seasonal vegetables and wild rice pilaf.',
        'location': 'Fine Dining',
        'mealType': 'Dinner',
        'walkingTime': 6,
        'waitTime': 4,
        'price': '\$14.50',
        'valueIndicator': 'Premium',
        'image':
            'https://images.unsplash.com/photo-1726609012802-b90296b1fe4a',
        'semanticLabel':
            'Grilled salmon fillet with roasted broccoli, carrots, and wild rice on a white plate',
        'tags': ['Omega-3', 'Low Carb', 'Heart Healthy'],
      },
      {
        'id': 7,
        'name': 'Vegetarian Pasta Bowl',
        'description':
            'Penne pasta with roasted vegetables, marinara sauce, and fresh basil.',
        'location': 'Italian Corner',
        'mealType': 'Dinner',
        'walkingTime': 3,
        'waitTime': 6,
        'price': '\$10.75',
        'valueIndicator': 'Student Favorite',
        'image':
            'https://images.unsplash.com/photo-1724116382173-19e67a873740',
        'semanticLabel':
            'Penne pasta with marinara sauce, roasted vegetables, and fresh basil in a ceramic bowl',
        'tags': ['Vegetarian', 'Italian', 'Comfort'],
      },
    ];
  }

  /// Handle meal card tap
  void _handleMealTap(BuildContext context, Map<String, dynamic> meal) {
    Navigator.pushNamed(context, '/meal-recommendations');
  }

  /// Handle save meal action
  void _handleSaveMeal(BuildContext context, Map<String, dynamic> meal) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${meal['name']} saved to favorites!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Handle dismiss meal action
  void _handleDismissMeal(BuildContext context, Map<String, dynamic> meal) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${meal['name']} dismissed'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Handle get directions action
  void _handleGetDirections(BuildContext context, Map<String, dynamic> meal) {
    Navigator.pushNamed(context, '/dining-location-details');
  }

  /// Handle view menu action
  void _handleViewMenu(BuildContext context, Map<String, dynamic> meal) {
    Navigator.pushNamed(context, '/dining-location-details');
  }

  /// Handle set reminder action
  void _handleSetReminder(BuildContext context, Map<String, dynamic> meal) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder set for ${meal['name']}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
