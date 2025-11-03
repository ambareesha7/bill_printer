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

String _$billListHash() => r'9769968309b84cbe959c9ca909012fb64225fdd9';

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
