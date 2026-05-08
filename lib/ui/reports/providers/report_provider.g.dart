// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FiltersList)
const filtersListProvider = FiltersListProvider._();

final class FiltersListProvider
    extends $NotifierProvider<FiltersList, List<String>> {
  const FiltersListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filtersListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filtersListHash();

  @$internal
  @override
  FiltersList create() => FiltersList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$filtersListHash() => r'77ea36470e4990b4fb9355cb3d79e60f78e91031';

abstract class _$FiltersList extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(AppliedFilters)
const appliedFiltersProvider = AppliedFiltersProvider._();

final class AppliedFiltersProvider
    extends $NotifierProvider<AppliedFilters, List<String>> {
  const AppliedFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appliedFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appliedFiltersHash();

  @$internal
  @override
  AppliedFilters create() => AppliedFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$appliedFiltersHash() => r'4e286102044394578ff21cd6500f540e08a03ab3';

abstract class _$AppliedFilters extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(YearlyReport)
const yearlyReportProvider = YearlyReportProvider._();

final class YearlyReportProvider
    extends $NotifierProvider<YearlyReport, List<SaleReceiptModel>> {
  const YearlyReportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'yearlyReportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$yearlyReportHash();

  @$internal
  @override
  YearlyReport create() => YearlyReport();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SaleReceiptModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SaleReceiptModel>>(value),
    );
  }
}

String _$yearlyReportHash() => r'7f8f710bcf144498b433ecc538fd4ef873f6acc7';

abstract class _$YearlyReport extends $Notifier<List<SaleReceiptModel>> {
  List<SaleReceiptModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<List<SaleReceiptModel>, List<SaleReceiptModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<SaleReceiptModel>, List<SaleReceiptModel>>,
              List<SaleReceiptModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(DateRange)
const dateRangeProvider = DateRangeProvider._();

final class DateRangeProvider
    extends
        $NotifierProvider<
          DateRange,
          ({DateTime? endDate, DateTime? startDate})
        > {
  const DateRangeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dateRangeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dateRangeHash();

  @$internal
  @override
  DateRange create() => DateRange();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({DateTime? endDate, DateTime? startDate}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<({DateTime? endDate, DateTime? startDate})>(value),
    );
  }
}

String _$dateRangeHash() => r'64df17ae5fef57246421263b5c8f958fac640c04';

abstract class _$DateRange
    extends $Notifier<({DateTime? endDate, DateTime? startDate})> {
  ({DateTime? endDate, DateTime? startDate}) build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              ({DateTime? endDate, DateTime? startDate}),
              ({DateTime? endDate, DateTime? startDate})
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ({DateTime? endDate, DateTime? startDate}),
                ({DateTime? endDate, DateTime? startDate})
              >,
              ({DateTime? endDate, DateTime? startDate}),
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(DateRangeReport)
const dateRangeReportProvider = DateRangeReportProvider._();

final class DateRangeReportProvider
    extends $NotifierProvider<DateRangeReport, List<SaleReceiptModel>> {
  const DateRangeReportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dateRangeReportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dateRangeReportHash();

  @$internal
  @override
  DateRangeReport create() => DateRangeReport();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SaleReceiptModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SaleReceiptModel>>(value),
    );
  }
}

String _$dateRangeReportHash() => r'1753d350f91e0a975ee6db7a9ae1326d74cbda74';

abstract class _$DateRangeReport extends $Notifier<List<SaleReceiptModel>> {
  List<SaleReceiptModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<List<SaleReceiptModel>, List<SaleReceiptModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<SaleReceiptModel>, List<SaleReceiptModel>>,
              List<SaleReceiptModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MonthlyReport)
const monthlyReportProvider = MonthlyReportProvider._();

final class MonthlyReportProvider
    extends $NotifierProvider<MonthlyReport, List<SaleReceiptModel>> {
  const MonthlyReportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monthlyReportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monthlyReportHash();

  @$internal
  @override
  MonthlyReport create() => MonthlyReport();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SaleReceiptModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SaleReceiptModel>>(value),
    );
  }
}

String _$monthlyReportHash() => r'648ee118e2b804e35e4a047ad7946db36db27422';

abstract class _$MonthlyReport extends $Notifier<List<SaleReceiptModel>> {
  List<SaleReceiptModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<List<SaleReceiptModel>, List<SaleReceiptModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<SaleReceiptModel>, List<SaleReceiptModel>>,
              List<SaleReceiptModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(WeeklyReport)
const weeklyReportProvider = WeeklyReportProvider._();

final class WeeklyReportProvider
    extends $NotifierProvider<WeeklyReport, List<SaleReceiptModel>> {
  const WeeklyReportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyReportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyReportHash();

  @$internal
  @override
  WeeklyReport create() => WeeklyReport();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SaleReceiptModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SaleReceiptModel>>(value),
    );
  }
}

String _$weeklyReportHash() => r'44365fe151a199f6469425950bfa07a2340434ae';

abstract class _$WeeklyReport extends $Notifier<List<SaleReceiptModel>> {
  List<SaleReceiptModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<List<SaleReceiptModel>, List<SaleReceiptModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<SaleReceiptModel>, List<SaleReceiptModel>>,
              List<SaleReceiptModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MonthlyDate)
const monthlyDateProvider = MonthlyDateProvider._();

final class MonthlyDateProvider
    extends $NotifierProvider<MonthlyDate, DateTime> {
  const MonthlyDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monthlyDateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monthlyDateHash();

  @$internal
  @override
  MonthlyDate create() => MonthlyDate();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$monthlyDateHash() => r'2aeada1e60c777495568c2afbc2c6dd9c954c054';

abstract class _$MonthlyDate extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(WeeklyDate)
const weeklyDateProvider = WeeklyDateProvider._();

final class WeeklyDateProvider extends $NotifierProvider<WeeklyDate, DateTime> {
  const WeeklyDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyDateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyDateHash();

  @$internal
  @override
  WeeklyDate create() => WeeklyDate();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$weeklyDateHash() => r'0105fe6a75b56ca28eba6cc5bb9f3f7e100e2a6f';

abstract class _$WeeklyDate extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
