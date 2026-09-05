// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PrintSettingsNotifier)
const printSettingsProvider = PrintSettingsNotifierProvider._();

final class PrintSettingsNotifierProvider
    extends $NotifierProvider<PrintSettingsNotifier, PrintSettingsModel?> {
  const PrintSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'printSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$printSettingsNotifierHash();

  @$internal
  @override
  PrintSettingsNotifier create() => PrintSettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrintSettingsModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrintSettingsModel?>(value),
    );
  }
}

String _$printSettingsNotifierHash() =>
    r'4e398dcf68852ed25faba8ba0be4a5687abcb729';

abstract class _$PrintSettingsNotifier extends $Notifier<PrintSettingsModel?> {
  PrintSettingsModel? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PrintSettingsModel?, PrintSettingsModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PrintSettingsModel?, PrintSettingsModel?>,
              PrintSettingsModel?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
