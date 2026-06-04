import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/category.dart';
import '../../domain/models/product.dart';
import '../../domain/models/mouvement.dart';

class StockRepository {
  final FirebaseFirestore _firestore;
  final String tenantId; // Correspond au UID de l'utilisateur Firebase (SAAS)

  StockRepository(this._firestore, this.tenantId);

  // -- Catégories --
  CollectionReference<Map<String, dynamic>> get _categoriesRef =>
      _firestore.collection('clients').doc(tenantId).collection('categories');

  Stream<List<Category>> getCategories() {
    return _categoriesRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Category.fromJson(doc.data(), doc.id)).toList());
  }

  Future<void> addCategory(Category category) async {
    await _categoriesRef.add(category.toJson());
  }

  // -- Produits --
  CollectionReference<Map<String, dynamic>> get _productsRef =>
      _firestore.collection('clients').doc(tenantId).collection('products');

  Stream<List<Product>> getProducts() {
    return _productsRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromJson(doc.data(), doc.id)).toList());
  }

  Future<void> addProduct(Product product) async {
    await _productsRef.add(product.toJson());
  }

  Future<void> updateProductStock(String productId, int newQuantity) async {
    await _productsRef.doc(productId).update({'stockQuantity': newQuantity});
  }

  // -- Mouvements --
  CollectionReference<Map<String, dynamic>> get _mouvementsRef =>
      _firestore.collection('clients').doc(tenantId).collection('mouvements');

  Stream<List<Mouvement>> getMouvements() {
    return _mouvementsRef.orderBy('date', descending: true).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Mouvement.fromJson(doc.data(), doc.id)).toList());
  }

  Future<void> addMouvement(Mouvement mouvement) async {
    await _mouvementsRef.add(mouvement.toJson());
    
    // Mettre à jour la quantité du produit
    final productDoc = await _productsRef.doc(mouvement.productId).get();
    if (productDoc.exists) {
      final product = Product.fromJson(productDoc.data()!, productDoc.id);
      final newQuantity = mouvement.type == MouvementType.entree
          ? product.stockQuantity + mouvement.quantity
          : product.stockQuantity - mouvement.quantity;
      await updateProductStock(product.id, newQuantity);
    }
  }
}
