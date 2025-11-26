// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$billListHash() => r'4b5c581f19eb86c2396855f0a28dd83f3acd6854';

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
