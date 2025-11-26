// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$monthlyReportHash() => r'60b3e18331040ded144352075bbc3e538f66ac86';

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

String _$weeklyReportHash() => r'be6f7571b668fec5688c058c4c6f5c7f085dbc62';

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

String _$monthlyDateHash() => r'589a2a2ba03c79374fbbd469d5f73c1924acd98c';

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

String _$weeklyDateHash() => r'3fbe2a1a327ef99748ba08df22e44470016884fb';

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
