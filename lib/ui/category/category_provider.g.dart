// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CategoryList)
const categoryListProvider = CategoryListProvider._();

final class CategoryListProvider
    extends $NotifierProvider<CategoryList, List<CategoryModel>> {
  const CategoryListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryListHash();

  @$internal
  @override
  CategoryList create() => CategoryList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CategoryModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CategoryModel>>(value),
    );
  }
}

String _$categoryListHash() => r'68574e4688c08737a83e7e6cf437fb4dbaafff5e';

abstract class _$CategoryList extends $Notifier<List<CategoryModel>> {
  List<CategoryModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<CategoryModel>, List<CategoryModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<CategoryModel>, List<CategoryModel>>,
              List<CategoryModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(TabIndex)
const tabIndexProvider = TabIndexProvider._();

final class TabIndexProvider extends $NotifierProvider<TabIndex, int> {
  const TabIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tabIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tabIndexHash();

  @$internal
  @override
  TabIndex create() => TabIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$tabIndexHash() => r'b1eac483aa4e85034523bda124f7c32bc67aeb10';

abstract class _$TabIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(TextLength)
const textLengthProvider = TextLengthProvider._();

final class TextLengthProvider extends $NotifierProvider<TextLength, int> {
  const TextLengthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'textLengthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$textLengthHash();

  @$internal
  @override
  TextLength create() => TextLength();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$textLengthHash() => r'4778bc358fd5e23a9d8d4676e35f616a0ac086c2';

abstract class _$TextLength extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
