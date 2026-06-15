class BundleModel {
  final String id;
  final String name;
  final int price;
  final int discount;
  final int sessions;
  final String validity;
  final bool isActive;
  final List<String> features;

  BundleModel({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.sessions,
    required this.validity,
    required this.isActive,
    required this.features,
  });

  factory BundleModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return BundleModel(
      id: json['_id']?.toString() ?? '',
      name: json['bundle_name']?.toString() ?? '',
      price: json['price'] ?? 0,
      discount: json['discount'] ?? 0,
      sessions: json['sessions'] ?? 0,
      validity: json['validity']?.toString() ?? '',
      isActive: json['isActive'] ?? true,
      features:
      (json['features'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }

}