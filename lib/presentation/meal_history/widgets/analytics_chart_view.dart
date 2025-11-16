import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Analytics chart view displaying spending trends and patterns
class AnalyticsChartView extends StatefulWidget {
  const AnalyticsChartView({
    super.key,
    required this.mealHistory,
  });

  final List<Map<String, dynamic>> mealHistory;

  @override
  State<AnalyticsChartView> createState() => _AnalyticsChartViewState();
}

class _AnalyticsChartViewState extends State<AnalyticsChartView> {
  String _selectedChart = 'Spending';
  final List<String> _chartTypes = ['Spending', 'Locations', 'Nutrition'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        _buildChartSelector(context, theme, colorScheme),
        SizedBox(height: 2.h),
        Expanded(
          child: _buildSelectedChart(context, theme, colorScheme),
        ),
      ],
    );
  }

  Widget _buildChartSelector(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: _chartTypes.map((type) {
          final isSelected = _selectedChart == type;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedChart = type),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  type,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSelectedChart(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    switch (_selectedChart) {
      case 'Spending':
        return _buildSpendingChart(context, theme, colorScheme);
      case 'Locations':
        return _buildLocationChart(context, theme, colorScheme);
      case 'Nutrition':
        return _buildNutritionChart(context, theme, colorScheme);
      default:
        return _buildSpendingChart(context, theme, colorScheme);
    }
  }

  Widget _buildSpendingChart(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    final spendingData = _generateSpendingData();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
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
          Text(
            'Daily Spending Trend',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Semantics(
              label:
                  "Daily spending trend line chart showing meal expenses over time",
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final days = [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun'
                          ];
                          if (value.toInt() < days.length) {
                            return Text(
                              days[value.toInt()],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spendingData,
                      isCurved: true,
                      color: colorScheme.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor: colorScheme.surface,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorScheme.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationChart(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    final locationData = _generateLocationData();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
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
          Text(
            'Dining Location Frequency',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Semantics(
              label:
                  "Pie chart showing frequency of visits to different dining locations",
              child: PieChart(
                PieChartData(
                  sections: locationData.map((data) {
                    return PieChartSectionData(
                      color: data['color'] as Color,
                      value: (data['value'] as double),
                      title: '${(data['value'] as double).toInt()}%',
                      radius: 60,
                      titleStyle: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }).toList(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          _buildLocationLegend(context, theme, colorScheme, locationData),
        ],
      ),
    );
  }

  Widget _buildNutritionChart(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    final nutritionData = _generateNutritionData();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
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
          Text(
            'Nutritional Intake Patterns',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Semantics(
              label:
                  "Bar chart showing nutritional intake patterns across different categories",
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final labels = ['Protein', 'Carbs', 'Fats', 'Fiber'];
                          if (value.toInt() < labels.length) {
                            return Text(
                              labels[value.toInt()],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: nutritionData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          color: colorScheme.primary,
                          width: 20,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4)),
                        ),
                      ],
                    );
                  }).toList(),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationLegend(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    List<Map<String, dynamic>> locationData,
  ) {
    return Wrap(
      spacing: 3.w,
      runSpacing: 1.h,
      children: locationData.map((data) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: data['color'] as Color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 1.w),
            Text(
              data['name'] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  List<FlSpot> _generateSpendingData() {
    return [
      const FlSpot(0, 12),
      const FlSpot(1, 18),
      const FlSpot(2, 15),
      const FlSpot(3, 22),
      const FlSpot(4, 19),
      const FlSpot(5, 25),
      const FlSpot(6, 16),
    ];
  }

  List<Map<String, dynamic>> _generateLocationData() {
    return [
      {'name': 'Main Dining', 'value': 35.0, 'color': AppTheme.primaryLight},
      {
        'name': 'Student Union',
        'value': 25.0,
        'color': AppTheme.secondaryLight
      },
      {'name': 'Campus Café', 'value': 20.0, 'color': AppTheme.successLight},
      {'name': 'Food Court', 'value': 20.0, 'color': AppTheme.warningLight},
    ];
  }

  List<double> _generateNutritionData() {
    return [75, 85, 60, 45]; // Protein, Carbs, Fats, Fiber percentages
  }
}
