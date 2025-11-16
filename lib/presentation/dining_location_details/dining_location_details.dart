import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import 'widgets/action_buttons_widget.dart';
import 'widgets/current_menu_widget.dart';
import 'widgets/hero_image_widget.dart';
import 'widgets/location_header_widget.dart';
import 'widgets/photo_gallery_widget.dart';
import 'widgets/quick_info_cards_widget.dart';
import 'widgets/reviews_ratings_widget.dart';
import 'widgets/wait_times_chart_widget.dart';

class DiningLocationDetails extends StatefulWidget {
  const DiningLocationDetails({super.key});

  @override
  State<DiningLocationDetails> createState() => _DiningLocationDetailsState();
}

class _DiningLocationDetailsState extends State<DiningLocationDetails> {
  bool _isFavorite = false;
  bool _isRefreshing = false;
  DateTime _lastUpdated = DateTime.now();

  // Mock data for dining location
  final Map<String, dynamic> _locationData = {
    'name': 'Campus Commons Dining Hall',
    'heroImage':
        'https://images.unsplash.com/photo-1708998111039-b5e9342f2154',
    'heroSemanticLabel':
        'Modern dining hall interior with wooden tables, pendant lighting, and students eating meals in a bright, contemporary space',
    'isOpen': true,
    'waitTime': '5-8 min',
    'walkingDistance': '3 min walk',
    'hours': '7:00 AM - 10:00 PM',
    'contact': '(555) 123-4567',
    'paymentMethods': ['Dining Dollars', 'Credit Card', 'Cash'],
    'accessibility': 'Wheelchair Accessible',
  };

  final List<Map<String, dynamic>> _menuData = [
    {
      'period': 'Breakfast',
      'time': '7:00 AM - 10:30 AM',
      'items': [
        {
          'name': 'Avocado Toast with Poached Egg',
          'price': '\$8.50',
          'dietaryTags': ['Vegetarian', 'High-Protein'],
        },
        {
          'name': 'Greek Yogurt Parfait',
          'price': '\$6.25',
          'dietaryTags': ['Vegetarian', 'Gluten-Free'],
        },
        {
          'name': 'Breakfast Burrito',
          'price': '\$7.75',
          'dietaryTags': ['High-Protein'],
        },
      ],
    },
    {
      'period': 'Lunch',
      'time': '11:00 AM - 3:00 PM',
      'items': [
        {
          'name': 'Grilled Chicken Caesar Salad',
          'price': '\$9.50',
          'dietaryTags': ['High-Protein', 'Gluten-Free'],
        },
        {
          'name': 'Quinoa Buddha Bowl',
          'price': '\$10.25',
          'dietaryTags': ['Vegan', 'Gluten-Free'],
        },
        {
          'name': 'Turkey Club Sandwich',
          'price': '\$8.75',
          'dietaryTags': ['High-Protein'],
        },
      ],
    },
    {
      'period': 'Dinner',
      'time': '5:00 PM - 9:00 PM',
      'items': [
        {
          'name': 'Salmon with Roasted Vegetables',
          'price': '\$12.50',
          'dietaryTags': ['High-Protein', 'Gluten-Free'],
        },
        {
          'name': 'Vegetarian Pasta Primavera',
          'price': '\$9.75',
          'dietaryTags': ['Vegetarian'],
        },
        {
          'name': 'BBQ Pulled Pork Bowl',
          'price': '\$11.25',
          'dietaryTags': ['High-Protein'],
        },
      ],
    },
  ];

  final List<Map<String, dynamic>> _waitTimeData = [
    {'hour': 7, 'waitTime': 2},
    {'hour': 8, 'waitTime': 8},
    {'hour': 9, 'waitTime': 12},
    {'hour': 10, 'waitTime': 6},
    {'hour': 11, 'waitTime': 15},
    {'hour': 12, 'waitTime': 18},
    {'hour': 13, 'waitTime': 16},
    {'hour': 14, 'waitTime': 8},
    {'hour': 15, 'waitTime': 4},
    {'hour': 16, 'waitTime': 6},
    {'hour': 17, 'waitTime': 14},
    {'hour': 18, 'waitTime': 19},
    {'hour': 19, 'waitTime': 12},
    {'hour': 20, 'waitTime': 6},
    {'hour': 21, 'waitTime': 3},
  ];

  final List<Map<String, dynamic>> _reviewsData = [
    {
      'studentName': 'Sarah Johnson',
      'rating': 4.5,
      'date': '2 days ago',
      'comment':
          'Great variety of healthy options! The quinoa bowl was delicious and the staff was very friendly. Wait times are usually reasonable.',
    },
    {
      'studentName': 'Mike Chen',
      'rating': 4.0,
      'date': '1 week ago',
      'comment':
          'Good food quality and convenient location. The breakfast burritos are my go-to before morning classes. Could use more vegan options though.',
    },
    {
      'studentName': 'Emma Rodriguez',
      'rating': 5.0,
      'date': '2 weeks ago',
      'comment':
          'Love this place! The salmon dinner is amazing and they always accommodate my gluten-free needs. Clean environment and great atmosphere.',
    },
  ];

  final List<Map<String, dynamic>> _photoGallery = [
    {
      'url':
          'https://images.unsplash.com/photo-1723537788332-07bf5997dc37',
      'caption': 'Fresh salad bar with organic ingredients',
      'semanticLabel':
          'Colorful salad bar display with fresh lettuce, tomatoes, cucumbers, and various toppings in stainless steel containers',
    },
    {
      'url':
          'https://images.unsplash.com/photo-1650359481661-aa17767be295',
      'caption': 'Grilled entrees and daily specials',
      'semanticLabel':
          'Grilled chicken and vegetables on a white plate with herbs and colorful presentation on wooden table',
    },
    {
      'url':
          'https://images.unsplash.com/photo-1596650396826-5cd7fb50f964',
      'caption': 'Comfortable seating areas for studying',
      'semanticLabel':
          'Modern dining area with comfortable booth seating, warm lighting, and students studying with laptops and books',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocationHeaderWidget(
                    locationName: _locationData['name'] as String,
                    isFavorite: _isFavorite,
                    onBackPressed: _handleBackPressed,
                    onFavoriteToggle: _handleFavoriteToggle,
                  ),
                  HeroImageWidget(
                    imageUrl: _locationData['heroImage'] as String,
                    semanticLabel: _locationData['heroSemanticLabel'] as String,
                    isOpen: _locationData['isOpen'] as bool,
                    waitTime: _locationData['waitTime'] as String,
                    walkingDistance: _locationData['walkingDistance'] as String,
                  ),
                  QuickInfoCardsWidget(
                    locationInfo: _locationData,
                  ),
                  PhotoGalleryWidget(
                    photos: _photoGallery,
                  ),
                  CurrentMenuWidget(
                    menuData: _menuData,
                    onMenuItemTap: _handleMenuItemTap,
                  ),
                  WaitTimesChartWidget(
                    waitTimeData: _waitTimeData,
                  ),
                  ReviewsRatingsWidget(
                    overallRating: 4.5,
                    recentReviews: _reviewsData,
                  ),
                  ActionButtonsWidget(
                    onGetDirections: _handleGetDirections,
                    onSetReminder: _handleSetReminder,
                    onShare: _handleShare,
                  ),
                  SizedBox(height: 4.h),
                  if (_isOfflineMode()) _buildOfflineBanner(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      _lastUpdated = DateTime.now();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Menu and wait times updated',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _handleBackPressed() {
    Navigator.of(context).pop();
  }

  void _handleFavoriteToggle() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? 'Added to favorites' : 'Removed from favorites',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: _isFavorite
            ? AppTheme.lightTheme.colorScheme.tertiary
            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleMenuItemTap(Map<String, dynamic> menuItem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildNutritionModal(menuItem),
    );
  }

  Widget _buildNutritionModal(Map<String, dynamic> menuItem) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menuItem['name'] as String,
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Nutritional Information',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                _buildNutritionRow('Calories', '420'),
                _buildNutritionRow('Protein', '28g'),
                _buildNutritionRow('Carbs', '35g'),
                _buildNutritionRow('Fat', '18g'),
                _buildNutritionRow('Fiber', '8g'),
                _buildNutritionRow('Sodium', '680mg'),
                SizedBox(height: 3.h),
                Text(
                  'Ingredients',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Fresh ingredients sourced locally when possible. Contains allergens: eggs, dairy. Prepared in a facility that processes nuts.',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  void _handleGetDirections() {
    // Simulate launching native navigation app
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening directions in Maps app...',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleSetReminder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Set Meal Reminder',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'When would you like to be reminded to visit ${_locationData['name']}?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _createCalendarEvent();
            },
            child: Text(
              'Set Reminder',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _createCalendarEvent() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Reminder set for optimal dining time',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleShare() async {
    final String shareText =
        'Check out ${_locationData['name']} - great food and only a ${_locationData['walkingDistance']} from campus! Currently ${_locationData['isOpen'] ? 'open' : 'closed'} with ${_locationData['waitTime']} wait time.';

    try {
      await Share.share(
        shareText,
        subject: 'Campus Dining Recommendation',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to share at this time',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  bool _isOfflineMode() {
    // Simulate offline detection
    return DateTime.now().difference(_lastUpdated).inMinutes > 30;
  }

  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'wifi_off',
            color: AppTheme.lightTheme.colorScheme.secondary,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offline Mode',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                ),
                Text(
                  'Showing cached data from ${_formatLastUpdate()}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatLastUpdate() {
    final now = DateTime.now();
    final difference = now.difference(_lastUpdated);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
