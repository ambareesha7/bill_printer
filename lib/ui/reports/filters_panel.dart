import 'package:bill_printer/data/app_enums.dart';
import 'package:bill_printer/ui/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bill_printer/ui/reports/providers/report_provider.dart';

class FiltersPanel extends ConsumerStatefulWidget {
  const FiltersPanel({
    required this.availableFilters,
    required this.reportType,
    required this.onApplyFilters,
    super.key,
  });

  final List<String> availableFilters;
  final ReportType reportType;
  final Function(List<String>) onApplyFilters;

  @override
  ConsumerState<FiltersPanel> createState() => _FiltersPanelState();
}

class _FiltersPanelState extends ConsumerState<FiltersPanel> {
  late List<String> selectedFilters;

  @override
  void initState() {
    super.initState();
    selectedFilters = ref.read(appliedFiltersProvider);
  }

  @override
  Widget build(BuildContext context) {
    selectedFilters = ref.watch(appliedFiltersProvider);
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 12),
              // Filter Options
              if (widget.availableFilters.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Methods & Banks',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blueGrey,
                      ),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.availableFilters.map((filter) {
                        final isSelected = selectedFilters.contains(filter);
                        return FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedFilters.add(filter);
                              } else {
                                selectedFilters.remove(filter);
                              }
                            });
                          },
                          backgroundColor: Colors.transparent,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.orange
                                : AppColors.borderColor,
                          ),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.orange
                                : AppColors.blueGrey,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              if (widget.availableFilters.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No filters available',
                      style: TextStyle(color: AppColors.blueGrey),
                    ),
                  ),
                ),
              SizedBox(height: 24),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedFilters.clear();
                      });
                    },
                    child: Text(
                      'Clear All',
                      style: TextStyle(color: AppColors.blueGrey),
                    ),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      widget.onApplyFilters(selectedFilters);
                      ref
                          .read(appliedFiltersProvider.notifier)
                          .updateAppliedFilters(selectedFilters);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
