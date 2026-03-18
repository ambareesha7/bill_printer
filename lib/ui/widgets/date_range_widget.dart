import 'package:bill_printer/ui/utils/app_colors.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateRangeWidget extends ConsumerWidget {
  const DateRangeWidget({
    super.key,
    required this.dateRange,
    required this.onFromDateSelect,
    required this.onToDateSelect,
    required this.closeBtnFunc,
  });

  final ({DateTime? endDate, DateTime? startDate}) dateRange;
  final Function() onFromDateSelect;
  final Function() onToDateSelect;
  final Function() closeBtnFunc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: onFromDateSelect,
              label: Text(
                dateRange.startDate != null
                    ? dateFormat(dateRange.startDate!)
                    : "From Date & Time",
                style: TextStyle(
                  color: dateRange.startDate != null
                      ? AppColors.blue
                      : Colors.grey,
                ),
              ),
              icon: Icon(Icons.calendar_today),
              iconAlignment: IconAlignment.end,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text("to"),
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: onToDateSelect,
              label: Text(
                dateRange.endDate != null
                    ? dateFormat(dateRange.endDate!)
                    : "To Date & Time",
                style: TextStyle(
                  color: dateRange.endDate != null
                      ? AppColors.blue
                      : Colors.grey,
                ),
              ),
              icon: Icon(Icons.calendar_today),
              iconAlignment: IconAlignment.end,
            ),
          ),
          if (dateRange.startDate != null && dateRange.endDate != null)
            IconButton(
              onPressed: closeBtnFunc,
              icon: Icon(Icons.clear),
              tooltip: "Clear date range",
            ),
        ],
      ),
    );
  }
}
