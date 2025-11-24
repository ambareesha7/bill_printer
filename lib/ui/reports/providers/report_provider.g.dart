// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$monthlyReportHash() => r'b3a2dbf75ebab075a1f91623ad14282cd8594c8a';

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
