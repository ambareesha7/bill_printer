// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_num_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OrderNum)
const orderNumProvider = OrderNumProvider._();

final class OrderNumProvider extends $NotifierProvider<OrderNum, String> {
  const OrderNumProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderNumProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderNumHash();

  @$internal
  @override
  OrderNum create() => OrderNum();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$orderNumHash() => r'598e4f470bbcc73e4851d5c2e10a6df60785a6ab';

abstract class _$OrderNum extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
