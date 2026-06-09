class BundleModel {
  final String client;
  final String caregiver;
  final String services;
  final double price;
  final double discount;
  final double totalPrice;

  BundleModel({
    required this.client,
    required this.caregiver,
    required this.services,
    required this.price,
    required this.discount,
    required this.totalPrice,
  });

  factory BundleModel.fromJson(Map<String, dynamic> json) {
    return BundleModel(
      client: json['client']?.toString() ?? '',
      caregiver: json['caregiver']?.toString() ?? '',
      services: json['services']?.toString() ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client': client,
      'caregiver': caregiver,
      'services': services,
      'price': price,
      'discount': discount,
      'totalPrice': totalPrice,
    };
  }
}