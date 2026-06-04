import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/category.dart';
import '../../domain/models/product.dart';
import '../../domain/models/mouvement.dart';
import '../../infrastructure/repositories/stock_repository.dart';
import 'auth_provider.dart';

part 'stock_provider.g.dart';

@riverpod
StockRepository? stockRepository(Ref ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.value;
  
  if (user == null) return null;
  
  return StockRepository(FirebaseFirestore.instance, user.uid);
}

@riverpod
Stream<List<Category>> categoriesStream(Ref ref) {
  final repository = ref.watch(stockRepositoryProvider);
  if (repository == null) return const Stream.empty();
  return repository.getCategories();
}

@riverpod
Stream<List<Product>> productsStream(Ref ref) {
  final repository = ref.watch(stockRepositoryProvider);
  if (repository == null) return const Stream.empty();
  return repository.getProducts();
}

@riverpod
Stream<List<Mouvement>> mouvementsStream(Ref ref) {
  final repository = ref.watch(stockRepositoryProvider);
  if (repository == null) return const Stream.empty();
  return repository.getMouvements();
}
