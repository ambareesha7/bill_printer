// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_id.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UnitId)
const unitIdProvider = UnitIdProvider._();

final class UnitIdProvider extends $NotifierProvider<UnitId, String> {
  const UnitIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unitIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unitIdHash();

  @$internal
  @override
  UnitId create() => UnitId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$unitIdHash() => r'4f1b6dc42d6c962ced901a23c36e616dde035f57';

abstract class _$UnitId extends $Notifier<String> {
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
