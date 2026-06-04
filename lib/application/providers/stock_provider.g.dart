// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stockRepository)
final stockRepositoryProvider = StockRepositoryProvider._();

final class StockRepositoryProvider
    extends
        $FunctionalProvider<
          StockRepository?,
          StockRepository?,
          StockRepository?
        >
    with $Provider<StockRepository?> {
  StockRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockRepositoryHash();

  @$internal
  @override
  $ProviderElement<StockRepository?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StockRepository? create(Ref ref) {
    return stockRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StockRepository? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StockRepository?>(value),
    );
  }
}

String _$stockRepositoryHash() => r'524d10903e304666ed742b6b3d205cb9b885e53e';

@ProviderFor(categoriesStream)
final categoriesStreamProvider = CategoriesStreamProvider._();

final class CategoriesStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          Stream<List<Category>>
        >
    with $FutureModifier<List<Category>>, $StreamProvider<List<Category>> {
  CategoriesStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Category>> create(Ref ref) {
    return categoriesStream(ref);
  }
}

String _$categoriesStreamHash() => r'64774704badaa3a340c24afed6b0748cab56d061';

@ProviderFor(productsStream)
final productsStreamProvider = ProductsStreamProvider._();

final class ProductsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          Stream<List<Product>>
        >
    with $FutureModifier<List<Product>>, $StreamProvider<List<Product>> {
  ProductsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Product>> create(Ref ref) {
    return productsStream(ref);
  }
}

String _$productsStreamHash() => r'426d22bbe7de91440e6061a0eb2c8632e299f30d';

@ProviderFor(mouvementsStream)
final mouvementsStreamProvider = MouvementsStreamProvider._();

final class MouvementsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Mouvement>>,
          List<Mouvement>,
          Stream<List<Mouvement>>
        >
    with $FutureModifier<List<Mouvement>>, $StreamProvider<List<Mouvement>> {
  MouvementsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mouvementsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mouvementsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<Mouvement>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Mouvement>> create(Ref ref) {
    return mouvementsStream(ref);
  }
}

String _$mouvementsStreamHash() => r'2ccc21a5f65437e0370d334abbbf192386252e89';
