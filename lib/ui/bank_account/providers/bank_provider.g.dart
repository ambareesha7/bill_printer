// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BankList)
const bankListProvider = BankListProvider._();

final class BankListProvider
    extends $NotifierProvider<BankList, List<BankAccountModel>> {
  const BankListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bankListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bankListHash();

  @$internal
  @override
  BankList create() => BankList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<BankAccountModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<BankAccountModel>>(value),
    );
  }
}

String _$bankListHash() => r'7d089e4fd5d257eea08b40f70e4887a54c0015ee';

abstract class _$BankList extends $Notifier<List<BankAccountModel>> {
  List<BankAccountModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<List<BankAccountModel>, List<BankAccountModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<BankAccountModel>, List<BankAccountModel>>,
              List<BankAccountModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
