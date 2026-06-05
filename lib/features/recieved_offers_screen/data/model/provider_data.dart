class ProviderModel {
  final String description;
  final String experience;
  final int completed;
  final List<String> qualifications;
  final String phone;
  final String email;
  final String location;
  final String availability;
  final String responseTime;

  final int reviewsCount;
  final bool isVerified;
  final bool isCertified;

  final double price;
  final double oldPrice;

  final String name;
  final String service;
  final double rating;

  final String specialization;
  final String notes;
  final bool bestValue;

  ProviderModel({
    required this.description,
    required this.experience,
    required this.completed,
    required this.qualifications,
    required this.phone,
    required this.email,
    required this.location,
    required this.availability,
    required this.responseTime,
    required this.reviewsCount,
    required this.isVerified,
    required this.isCertified,
    required this.price,
    required this.oldPrice,
    required this.name,
    required this.service,
    required this.rating,
    required this.specialization,
    required this.notes,
    required this.bestValue,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      description: json['description']?.toString() ?? "",
      experience: json['experience']?.toString() ?? "",

      completed: (json['completed'] ?? 0) is int
          ? json['completed']
          : int.tryParse(json['completed'].toString()) ?? 0,

      qualifications: json['qualifications'] != null
          ? List<String>.from(json['qualifications'])
          : [],

      phone: json['phone']?.toString() ?? "",
      email: json['email']?.toString() ?? "",

      location: json['location']?.toString() ?? "",
      availability: json['availability']?.toString() ?? "",
      responseTime: json['response_time']?.toString() ?? "",

      name: json['name']?.toString() ?? "",
      service: json['service']?.toString() ?? "",

      rating: (json['rating'] is num)
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? "0") ?? 0.0,

      reviewsCount: (json['reviews_count'] ?? 0) is int
          ? json['reviews_count']
          : int.tryParse(json['reviews_count'].toString()) ?? 0,


      isVerified: json['verified'] == true,
      isCertified: json['certified'] == true,

      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? "0") ?? 0.0,

      oldPrice: (json['old_price'] is num)
          ? (json['old_price'] as num).toDouble()
          : double.tryParse(json['old_price']?.toString() ?? "0") ?? 0.0,

      specialization: json['specialization']?.toString() ?? "",
      notes: json['notes']?.toString() ?? "",


      bestValue: json['best_value'] == true,
    );
  }
}