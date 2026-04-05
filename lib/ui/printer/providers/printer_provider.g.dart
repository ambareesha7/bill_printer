// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BLStatus)
const bLStatusProvider = BLStatusProvider._();

final class BLStatusProvider extends $NotifierProvider<BLStatus, bool> {
  const BLStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bLStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bLStatusHash();

  @$internal
  @override
  BLStatus create() => BLStatus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$bLStatusHash() => r'49ccb5ef1a3345bcb007168fd0d4e0ba41f0a32a';

abstract class _$BLStatus extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Printer)
const printerProvider = PrinterProvider._();

final class PrinterProvider extends $NotifierProvider<Printer, bool> {
  const PrinterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'printerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$printerHash();

  @$internal
  @override
  Printer create() => Printer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$printerHash() => r'1f841ae8f672edaa9d70d03891c78cb170f189bd';

abstract class _$Printer extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
