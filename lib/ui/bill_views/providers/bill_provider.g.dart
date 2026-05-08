// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TempBillList)
const tempBillListProvider = TempBillListProvider._();

final class TempBillListProvider
    extends $NotifierProvider<TempBillList, List<List<BillItemModel>>> {
  const TempBillListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tempBillListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tempBillListHash();

  @$internal
  @override
  TempBillList create() => TempBillList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<List<BillItemModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<List<BillItemModel>>>(value),
    );
  }
}

String _$tempBillListHash() => r'8391add452a50c7f4e8ec2cbaa2c8c075d1de023';

abstract class _$TempBillList extends $Notifier<List<List<BillItemModel>>> {
  List<List<BillItemModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<List<List<BillItemModel>>, List<List<BillItemModel>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<List<BillItemModel>>, List<List<BillItemModel>>>,
              List<List<BillItemModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(BillList)
const billListProvider = BillListProvider._();

final class BillListProvider
    extends $NotifierProvider<BillList, List<BillItemModel>> {
  const BillListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'billListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$billListHash();

  @$internal
  @override
  BillList create() => BillList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<BillItemModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<BillItemModel>>(value),
    );
  }
}

String _$billListHash() => r'c7cccd836425313b784eeb3543a20d8d04a93169';

abstract class _$BillList extends $Notifier<List<BillItemModel>> {
  List<BillItemModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<BillItemModel>, List<BillItemModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<BillItemModel>, List<BillItemModel>>,
              List<BillItemModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(BillItem)
const billItemProvider = BillItemProvider._();

final class BillItemProvider
    extends $NotifierProvider<BillItem, BillItemModel> {
  const BillItemProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'billItemProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$billItemHash();

  @$internal
  @override
  BillItem create() => BillItem();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BillItemModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BillItemModel>(value),
    );
  }
}

String _$billItemHash() => r'4e06738197d977ebb681b711663605299a366237';

abstract class _$BillItem extends $Notifier<BillItemModel> {
  BillItemModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BillItemModel, BillItemModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BillItemModel, BillItemModel>,
              BillItemModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
