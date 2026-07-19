// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ShopList)
const shopListProvider = ShopListProvider._();

final class ShopListProvider
    extends $NotifierProvider<ShopList, List<ShopModel>> {
  const ShopListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shopListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shopListHash();

  @$internal
  @override
  ShopList create() => ShopList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ShopModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ShopModel>>(value),
    );
  }
}

String _$shopListHash() => r'8c94e440052263406e6ab8b9fd5eb25c9a4cf3ac';

abstract class _$ShopList extends $Notifier<List<ShopModel>> {
  List<ShopModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<ShopModel>, List<ShopModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ShopModel>, List<ShopModel>>,
              List<ShopModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
