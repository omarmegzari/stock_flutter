import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_provider.dart';
import '../../application/providers/stock_provider.dart';
import '../../domain/models/mouvement.dart';
import '../../domain/models/product.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsStreamProvider);
    final mouvementsAsync = ref.watch(mouvementsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          return mouvementsAsync.when(
            data: (mouvements) {
              return _buildDashboard(context, products, mouvements);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Erreur: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, List<Product> products, List<Mouvement> mouvements) {
    // 1. Produits sous le seuil d'approvisionnement
    final lowStockProducts = products.where((p) => p.stockQuantity <= p.minStockLevel).toList();

    // 2. Produits les plus vendus (sorties)
    final sales = mouvements.where((m) => m.type == MouvementType.sortie);
    final Map<String, int> productSales = {};
    for (var sale in sales) {
      productSales[sale.productId] = (productSales[sale.productId] ?? 0) + sale.quantity;
    }
    
    final sortedSales = productSales.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topSellingProducts = sortedSales.take(5).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Alertes de Stock', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent)),
          const SizedBox(height: 8),
          if (lowStockProducts.isEmpty)
            const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('Tous les stocks sont à un niveau correct.')))
          else
            ...lowStockProducts.map((p) => Card(
                  color: Colors.red.shade50,
                  child: ListTile(
                    leading: const Icon(Icons.warning, color: Colors.red),
                    title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Stock actuel : ${p.stockQuantity} (Seuil : ${p.minStockLevel})'),
                  ),
                )),

          const SizedBox(height: 24),

          const Text('Produits les plus vendus', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (topSellingProducts.isEmpty)
            const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('Aucune vente enregistrée.')))
          else
            ...topSellingProducts.map((entry) {
              final product = products.firstWhere(
                (p) => p.id == entry.key, 
                orElse: () => Product(id: '', categoryId: '', name: 'Produit inconnu', price: 0, stockQuantity: 0, minStockLevel: 0)
              );
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.trending_up, color: Colors.green),
                  title: Text(product.name),
                  trailing: Text('${entry.value} vendus', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              );
            }),
            
          const SizedBox(height: 24),
          
          const Text('Résumé Global', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.inventory, size: 40, color: Colors.blue),
                        const SizedBox(height: 8),
                        Text('${products.length}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const Text('Total Produits'),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.shopping_cart, size: 40, color: Colors.green),
                        const SizedBox(height: 8),
                        Text('${sales.fold(0, (sum, item) => sum + item.quantity)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const Text('Total Ventes'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
