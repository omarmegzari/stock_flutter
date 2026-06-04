import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/mouvement.dart';
import '../../domain/models/product.dart';
import '../../application/providers/stock_provider.dart';

class MouvementsScreen extends ConsumerWidget {
  const MouvementsScreen({super.key});

  void _showAddMouvementDialog(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.read(productsStreamProvider);
    
    // S'il n'y a pas encore de produits, on bloque l'action
    if (productsAsync.value == null || productsAsync.value!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez d\'abord créer un produit.')),
      );
      return;
    }

    final products = productsAsync.value!;
    Product? selectedProduct = products.first;
    MouvementType selectedType = MouvementType.entree;
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Nouveau Mouvement'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<Product>(
                    value: selectedProduct,
                    decoration: const InputDecoration(labelText: 'Produit'),
                    items: products.map((p) {
                      return DropdownMenuItem(value: p, child: Text(p.name));
                    }).toList(),
                    onChanged: (val) => setState(() => selectedProduct = val),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<MouvementType>(
                    value: selectedType,
                    decoration: const InputDecoration(labelText: 'Type de mouvement'),
                    items: const [
                      DropdownMenuItem(value: MouvementType.entree, child: Text('Entrée (Achat)')),
                      DropdownMenuItem(value: MouvementType.sortie, child: Text('Sortie (Vente)')),
                    ],
                    onChanged: (val) => setState(() => selectedType = val!),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(labelText: 'Quantité'),
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
                  final qty = int.tryParse(quantityController.text) ?? 0;
                  if (qty > 0 && selectedProduct != null) {
                    // Si c'est une sortie, vérifier si la quantité est suffisante
                    if (selectedType == MouvementType.sortie && selectedProduct!.stockQuantity < qty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Quantité en stock insuffisante !')),
                      );
                      return;
                    }

                    ref.read(stockRepositoryProvider)?.addMouvement(
                      Mouvement(
                        id: '',
                        productId: selectedProduct!.id,
                        type: selectedType,
                        quantity: qty,
                        date: DateTime.now(),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Valider'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mouvementsAsync = ref.watch(mouvementsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mouvements'),
      ),
      body: mouvementsAsync.when(
        data: (mouvements) {
          if (mouvements.isEmpty) {
            return const Center(child: Text('Aucun mouvement enregistré.'));
          }
          return ListView.builder(
            itemCount: mouvements.length,
            itemBuilder: (context, index) {
              final mouvement = mouvements[index];
              final isEntree = mouvement.type == MouvementType.entree;
              
              return ListTile(
                leading: Icon(
                  isEntree ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isEntree ? Colors.green : Colors.red,
                ),
                title: Text(isEntree ? 'Entrée de stock' : 'Sortie de stock (Vente)'),
                subtitle: Text('Quantité : ${mouvement.quantity} - Date : ${mouvement.date.day}/${mouvement.date.month}/${mouvement.date.year}'),
                trailing: Text(
                  '${isEntree ? '+' : '-'}${mouvement.quantity}',
                  style: TextStyle(
                    color: isEntree ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMouvementDialog(context, ref),
        icon: const Icon(Icons.swap_horiz),
        label: const Text('Nouveau'),
      ),
    );
  }
}
