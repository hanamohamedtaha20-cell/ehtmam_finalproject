class BundleModel {
  final String id;
  final String client;
  final String bundleName;
  final double price;
  final double? discount;
  final double? totalPrice;
  final List<String> features;
  final bool isActive;
  final String? createdAt;
  final int totalSessions;
  final int remainingSessions;
  final bool isPurchased;

  BundleModel({
    required this.id,
    required this.client,
    required this.bundleName,
    required this.price,
    this.discount,
    this.totalPrice,
    this.features = const [],
    this.isActive = true,
    this.createdAt,
    this.totalSessions = 0,
    this.remainingSessions = 0,
    this.isPurchased = false,
  });

  double get displayPrice => totalPrice ?? price;

  int get discountPercent => discount?.round() ?? 0;

  BundleModel copyWith({
    int? totalSessions,
    int? remainingSessions,
    bool? isPurchased,
  }) =>
      BundleModel(
        id: id,
        client: client,
        bundleName: bundleName,
        price: price,
        discount: discount,
        totalPrice: totalPrice,
        features: features,
        isActive: isActive,
        createdAt: createdAt,
        totalSessions: totalSessions ?? this.totalSessions,
        remainingSessions: remainingSessions ?? this.remainingSessions,
        isPurchased: isPurchased ?? this.isPurchased,
      );

  factory BundleModel.fromJson(Map<String, dynamic> json) {
    return BundleModel(
      id: json['_id']?.toString() ?? '',
      client: json['client']?.toString() ?? '',
      bundleName: json['bundle_name']?.toString() ?? json['bundleName']?.toString() ?? '',
      price: _parseDouble(json['price']),
      discount: json['discount'] == null ? null : _parseDouble(json['discount']),
      totalPrice: json['totalPrice'] == null ? null : _parseDouble(json['totalPrice']),
      features: _parseFeatures(json['features']),
      isActive: json['isActive'] == true,
      createdAt: json['createdAt']?.toString(),
      totalSessions: _parseInt(
        json['sessions'] ??
            json['totalSessions'] ??
            json['numberOfSessions'] ??
            json['sessionsCount'] ??
            json['session_count'],
      ),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static List<String> _parseFeatures(dynamic raw) {
    if (raw is! List) return [];

    return raw
        .map((item) {
          if (item == null) return '';
          if (item is String) return item;
          if (item is Map) {
            final value = item['name'] ??
                item['title'] ??
                item['feature'] ??
                item['description'];
            return value?.toString() ?? '';
          }
          return item.toString();
        })
        .where((feature) => feature.isNotEmpty)
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'client': client,
      'bundle_name': bundleName,
      'price': price,
      if (discount != null) 'discount': discount,
      if (totalPrice != null) 'totalPrice': totalPrice,
      'features': features,
      'isActive': isActive,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}
