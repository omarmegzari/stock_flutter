import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/product.dart';
import '../../application/providers/stock_provider.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  void _showAddProductDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final minStockController = TextEditingController();
    // Simplification : pas de sélection de catégorie dans cette V1, on prendra la première ou on la demandera

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau Produit'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom du produit'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: minStockController,
                decoration: const InputDecoration(labelText: 'Seuil minimum (Alerte)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final price = double.tryParse(priceController.text) ?? 0.0;
              final minStock = int.tryParse(minStockController.text) ?? 0;

              if (name.isNotEmpty) {
                ref.read(stockRepositoryProvider)?.addProduct(
                  Product(
                    id: '',
                    categoryId: 'default_category', // Sera amélioré plus tard
                    name: name,
                    price: price,
                    stockQuantity: 0,
                    minStockLevel: minStock,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produits'),
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('Aucun produit en stock.'));
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: const Icon(Icons.inventory_2),
                title: Text(product.name),
                subtitle: Text('En stock : ${product.stockQuantity} (Prix: ${product.price}€)'),
                trailing: product.stockQuantity <= product.minStockLevel
                    ? const Icon(Icons.warning, color: Colors.redAccent)
                    : const Icon(Icons.check_circle, color: Colors.green),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
