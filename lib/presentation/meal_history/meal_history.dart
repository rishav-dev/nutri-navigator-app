import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import 'widgets/analytics_chart_view.dart';
import 'widgets/date_range_selector.dart';
import 'widgets/empty_history_state.dart';
import 'widgets/meal_timeline_item.dart';
import 'widgets/summary_metrics_card.dart';

/// Meal History screen displaying comprehensive dining analytics and past recommendations
class MealHistory extends StatefulWidget {
  const MealHistory({super.key});

  @override
  State<MealHistory> createState() => _MealHistoryState();
}

class _MealHistoryState extends State<MealHistory>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late DateTimeRange _selectedDateRange;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;

  // Mock meal history data
  final List<Map<String, dynamic>> _allMealHistory = [
    {
      'id': 1,
      'name': 'Grilled Chicken Caesar Salad',
      'location': 'Main Dining Hall',
      'mealType': 'Lunch',
      'cost': '\$12.50',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'rating': 4.5,
      'image':
          'https://images.unsplash.com/photo-1669472546301-6ea7e733b130',
      'semanticLabel':
          'Fresh Caesar salad with grilled chicken breast, romaine lettuce, parmesan cheese and croutons on white plate',
      'nutritionTags': ['High Protein', 'Low Carb'],
      'calories': 450,
    },
    {
      'id': 2,
      'name': 'Veggie Burger with Sweet Potato Fries',
      'location': 'Student Union Food Court',
      'mealType': 'Dinner',
      'cost': '\$9.75',
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 6)),
      'rating': 4.0,
      'image':
          'https://images.unsplash.com/photo-1639339474646-1e45134913bc',
      'semanticLabel':
          'Veggie burger with lettuce and tomato on sesame bun served with golden sweet potato fries',
      'nutritionTags': ['Vegetarian', 'High Fiber'],
      'calories': 520,
    },
    {
      'id': 3,
      'name': 'Overnight Oats with Berries',
      'location': 'Campus Café',
      'mealType': 'Breakfast',
      'cost': '\$6.25',
      'timestamp': DateTime.now().subtract(const Duration(days: 2, hours: 14)),
      'rating': 5.0,
      'image':
          'https://images.unsplash.com/photo-1652169891786-ca64aa08dd24',
      'semanticLabel':
          'Glass jar filled with overnight oats topped with fresh blueberries, strawberries and chia seeds',
      'nutritionTags': ['Healthy', 'High Fiber'],
      'calories': 320,
    },
    {
      'id': 4,
      'name': 'Chicken Teriyaki Bowl',
      'location': 'Asian Express',
      'mealType': 'Lunch',
      'cost': '\$11.00',
      'timestamp': DateTime.now().subtract(const Duration(days: 3, hours: 4)),
      'rating': 4.2,
      'image':
          'https://images.unsplash.com/photo-1634640848446-6d4d670b5142',
      'semanticLabel':
          'Teriyaki chicken bowl with steamed rice, broccoli, carrots and sesame seeds in white bowl',
      'nutritionTags': ['High Protein', 'Balanced'],
      'calories': 580,
    },
    {
      'id': 5,
      'name': 'Greek Yogurt Parfait',
      'location': 'Campus Café',
      'mealType': 'Snack',
      'cost': '\$4.50',
      'timestamp': DateTime.now().subtract(const Duration(days: 4, hours: 10)),
      'rating': 4.8,
      'image':
          'https://images.unsplash.com/photo-1691455653742-ea1aded33376',
      'semanticLabel':
          'Layered Greek yogurt parfait with granola, fresh berries and honey in clear glass',
      'nutritionTags': ['High Protein', 'Probiotic'],
      'calories': 280,
    },
  ];

  List<Map<String, dynamic>> get _filteredMealHistory {
    var filtered = _allMealHistory.where((meal) {
      final mealDate = meal['timestamp'] as DateTime;
      final inDateRange = mealDate.isAfter(
              _selectedDateRange.start.subtract(const Duration(days: 1))) &&
          mealDate
              .isBefore(_selectedDateRange.end.add(const Duration(days: 1)));

      if (!inDateRange) return false;

      if (_searchQuery.isEmpty) return true;

      final searchLower = _searchQuery.toLowerCase();
      return (meal['name'] as String).toLowerCase().contains(searchLower) ||
          (meal['location'] as String).toLowerCase().contains(searchLower) ||
          (meal['mealType'] as String).toLowerCase().contains(searchLower);
    }).toList();

    filtered.sort((a, b) =>
        (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDateRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    );
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(context, theme, colorScheme),
      body: _filteredMealHistory.isEmpty && _allMealHistory.isNotEmpty
          ? _buildNoResultsState(context, theme, colorScheme)
          : _allMealHistory.isEmpty
              ? EmptyHistoryState(
                  onGetStarted: () =>
                      Navigator.pushNamed(context, '/meal-recommendations'),
                )
              : _buildHistoryContent(context, theme, colorScheme),
      floatingActionButton: _allMealHistory.isNotEmpty
          ? FloatingActionButton(
              onPressed: _exportHistory,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              child: CustomIconWidget(
                iconName: 'share',
                size: 24,
                color: colorScheme.onPrimary,
              ),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      title: Text(
        'Meal History',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 1.0,
      centerTitle: false,
      leading: IconButton(
        onPressed: () => Navigator.pushNamed(context, '/main-dashboard'),
        icon: CustomIconWidget(
          iconName: 'home',
          size: 24,
          color: colorScheme.onSurface,
        ),
        tooltip: 'Home',
      ),
      actions: [
        IconButton(
          onPressed: _refreshData,
          icon: CustomIconWidget(
            iconName: 'refresh',
            size: 24,
            color: colorScheme.onSurface,
          ),
          tooltip: 'Refresh',
        ),
        SizedBox(width: 2.w),
      ],
      bottom: _allMealHistory.isNotEmpty
          ? PreferredSize(
              preferredSize: Size.fromHeight(12.h),
              child: Column(
                children: [
                  _buildSearchBar(context, theme, colorScheme),
                  _buildTabBar(context, theme, colorScheme),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildSearchBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: TextField(
        controller: _searchController,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search meals, locations, or types...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          prefixIcon: CustomIconWidget(
            iconName: 'search',
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                )
              : null,
          filled: true,
          fillColor: colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        ),
      ),
    );
  }

  Widget _buildTabBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return TabBar(
      controller: _tabController,
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
      indicatorColor: colorScheme.primary,
      indicatorWeight: 3,
      labelStyle: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w400,
      ),
      tabs: const [
        Tab(text: 'Timeline'),
        Tab(text: 'Analytics'),
      ],
    );
  }

  Widget _buildHistoryContent(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        DateRangeSelector(
          selectedRange: _selectedDateRange,
          onRangeChanged: (range) {
            setState(() {
              _selectedDateRange = range;
            });
          },
        ),
        if (_filteredMealHistory.isNotEmpty)
          SummaryMetricsCard(
            totalMeals: _filteredMealHistory.length,
            averageSpending: _calculateAverageSpending(),
            topDiningHall: _getTopDiningHall(),
            goalProgress: 78.5,
          ),
        Expanded(
          child: _isLoading
              ? _buildLoadingState(colorScheme)
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTimelineView(context, theme, colorScheme),
                    AnalyticsChartView(mealHistory: _filteredMealHistory),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildTimelineView(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    if (_filteredMealHistory.isEmpty) {
      return _buildNoResultsState(context, theme, colorScheme);
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: colorScheme.primary,
      child: ListView.builder(
        padding: EdgeInsets.only(top: 1.h, bottom: 10.h),
        itemCount: _filteredMealHistory.length,
        itemBuilder: (context, index) {
          final meal = _filteredMealHistory[index];
          final showDateHeader = index == 0 ||
              !_isSameDay(
                meal['timestamp'] as DateTime,
                _filteredMealHistory[index - 1]['timestamp'] as DateTime,
              );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showDateHeader)
                _buildDateHeader(
                    context, theme, colorScheme, meal['timestamp'] as DateTime),
              MealTimelineItem(
                meal: meal,
                onTap: () => _showMealDetails(context, meal),
                onDelete: () => _deleteMeal(meal['id'] as int),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context, ThemeData theme,
      ColorScheme colorScheme, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final mealDate = DateTime(date.year, date.month, date.day);

    String dateText;
    if (mealDate == today) {
      dateText = 'Today';
    } else if (mealDate == yesterday) {
      dateText = 'Yesterday';
    } else {
      dateText = '${date.day}/${date.month}/${date.year}';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Text(
        dateText,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildNoResultsState(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 2.h),
            Text(
              'No meals found',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search or date range',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedDateRange = DateTimeRange(
                    start: DateTime.now().subtract(const Duration(days: 30)),
                    end: DateTime.now(),
                  );
                });
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading meal history...',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Meal history updated'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showMealDetails(BuildContext context, Map<String, dynamic> meal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => _buildMealDetailsSheet(
          context,
          meal,
          scrollController,
        ),
      ),
    );
  }

  Widget _buildMealDetailsSheet(
    BuildContext context,
    Map<String, dynamic> meal,
    ScrollController scrollController,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: ListView(
        controller: scrollController,
        children: [
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          if (meal['image'] != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomImageWidget(
                imageUrl: meal['image'] as String,
                width: double.infinity,
                height: 25.h,
                fit: BoxFit.cover,
                semanticLabel: meal['semanticLabel'] as String? ?? 'Meal image',
              ),
            ),
          SizedBox(height: 2.h),
          Text(
            meal['name'] as String,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 1.w),
              Text(
                meal['location'] as String,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                meal['cost'] as String,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          if (meal['nutritionTags'] != null) ...[
            Text(
              'Nutrition Tags',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: (meal['nutritionTags'] as List<String>).map((tag) {
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    tag,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 2.h),
          ],
          if (meal['calories'] != null) ...[
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'local_fire_department',
                  size: 20,
                  color: Colors.orange,
                ),
                SizedBox(width: 2.w),
                Text(
                  '${meal['calories']} calories',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/meal-recommendations');
              },
              child: const Text('Get Similar Recommendations'),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteMeal(int mealId) {
    setState(() {
      _allMealHistory.removeWhere((meal) => meal['id'] == mealId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Meal removed from history'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // In a real app, you would restore the meal here
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Meal restored'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _exportHistory() async {
    final csvContent = _generateCSVContent();
    await Share.share(
      csvContent,
      subject: 'My Meal History - Nutri Navigator',
    );
  }

  String _generateCSVContent() {
    final buffer = StringBuffer();
    buffer.writeln('Date,Time,Meal Name,Location,Type,Cost,Rating,Calories');

    for (final meal in _filteredMealHistory) {
      final timestamp = meal['timestamp'] as DateTime;
      final date = '${timestamp.day}/${timestamp.month}/${timestamp.year}';
      final time =
          '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';

      buffer.writeln([
        date,
        time,
        meal['name'],
        meal['location'],
        meal['mealType'],
        meal['cost'],
        meal['rating']?.toString() ?? '',
        meal['calories']?.toString() ?? '',
      ].join(','));
    }

    return buffer.toString();
  }

  double _calculateAverageSpending() {
    if (_filteredMealHistory.isEmpty) return 0.0;

    double total = 0.0;
    for (final meal in _filteredMealHistory) {
      final costString = meal['cost'] as String;
      final cost = double.tryParse(costString.replaceAll('\$', '')) ?? 0.0;
      total += cost;
    }

    return total / _filteredMealHistory.length;
  }

  String _getTopDiningHall() {
    if (_filteredMealHistory.isEmpty) return 'N/A';

    final locationCounts = <String, int>{};
    for (final meal in _filteredMealHistory) {
      final location = meal['location'] as String;
      locationCounts[location] = (locationCounts[location] ?? 0) + 1;
    }

    return locationCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
