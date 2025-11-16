import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Date range selector widget for filtering meal history
class DateRangeSelector extends StatefulWidget {
  const DateRangeSelector({
    super.key,
    required this.selectedRange,
    required this.onRangeChanged,
  });

  final DateTimeRange selectedRange;
  final ValueChanged<DateTimeRange> onRangeChanged;

  @override
  State<DateRangeSelector> createState() => _DateRangeSelectorState();
}

class _DateRangeSelectorState extends State<DateRangeSelector> {
  final List<String> _quickRanges = [
    'Last 7 days',
    'Last 30 days',
    'Last 3 months',
    'Custom'
  ];

  String _selectedQuickRange = 'Last 30 days';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date Range',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _quickRanges.map((range) {
                final isSelected = _selectedQuickRange == range;
                return Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: GestureDetector(
                    onTap: () => _handleRangeSelection(range),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outline.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        range,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          if (_selectedQuickRange == 'Custom') ...[
            SizedBox(height: 1.h),
            _buildCustomDateSelector(context, colorScheme),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomDateSelector(
      BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _showDatePicker(context, true),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 3.w,
                vertical: 1.5.h,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'calendar_today',
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '${widget.selectedRange.start.day}/${widget.selectedRange.start.month}/${widget.selectedRange.start.year}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Text(
            'to',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => _showDatePicker(context, false),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 3.w,
                vertical: 1.5.h,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'calendar_today',
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '${widget.selectedRange.end.day}/${widget.selectedRange.end.month}/${widget.selectedRange.end.year}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleRangeSelection(String range) {
    setState(() {
      _selectedQuickRange = range;
    });

    final now = DateTime.now();
    DateTimeRange newRange;

    switch (range) {
      case 'Last 7 days':
        newRange = DateTimeRange(
          start: now.subtract(const Duration(days: 7)),
          end: now,
        );
        break;
      case 'Last 30 days':
        newRange = DateTimeRange(
          start: now.subtract(const Duration(days: 30)),
          end: now,
        );
        break;
      case 'Last 3 months':
        newRange = DateTimeRange(
          start: DateTime(now.year, now.month - 3, now.day),
          end: now,
        );
        break;
      case 'Custom':
        return; // Don't change range for custom selection
      default:
        return;
    }

    widget.onRangeChanged(newRange);
  }

  Future<void> _showDatePicker(BuildContext context, bool isStartDate) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate:
          isStartDate ? widget.selectedRange.start : widget.selectedRange.end,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      final newRange = isStartDate
          ? DateTimeRange(
              start: selectedDate,
              end: widget.selectedRange.end,
            )
          : DateTimeRange(
              start: widget.selectedRange.start,
              end: selectedDate,
            );

      widget.onRangeChanged(newRange);
    }
  }
}
