enum MouvementType { entree, sortie }

class Mouvement {
  final String id;
  final String productId;
  final MouvementType type;
  final int quantity;
  final DateTime date;

  Mouvement({
    required this.id,
    required this.productId,
    required this.type,
    required this.quantity,
    required this.date,
  });

  factory Mouvement.fromJson(Map<String, dynamic> json, String id) {
    return Mouvement(
      id: id,
      productId: json['productId'] as String,
      type: MouvementType.values.firstWhere((e) => e.name == json['type']),
      quantity: json['quantity'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'type': type.name,
      'quantity': quantity,
      'date': date.toIso8601String(),
    };
  }
}
