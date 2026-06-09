class ProviderModel {
  final String id;
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
    required this.id,
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

  factory ProviderModel.fromOfferJson(Map<String, dynamic> json) {
    final caregiver = json['caregiver'];
    final caregiverMap = caregiver is Map<String, dynamic>
        ? caregiver
        : <String, dynamic>{};

    final caregiverPrice = _toDouble(caregiverMap['price']);
    final offerPrice = _toDouble(json['price']);

    return ProviderModel(
      id: json['_id']?.toString() ?? '',
      description: caregiverMap['experience']?.toString() ??
          json['description']?.toString() ??
          '',
      experience: caregiverMap['experience']?.toString() ?? '',
      completed: _toInt(caregiverMap['completed'] ?? caregiverMap['totalRequests']),
      qualifications: _toStringList(caregiverMap['qualifications'] ??
          caregiverMap['certifications']),
      phone: caregiverMap['phone']?.toString() ?? '',
      email: caregiverMap['email']?.toString() ?? '',
      location: caregiverMap['governorate']?.toString() ??
          caregiverMap['location']?.toString() ??
          '',
      availability: caregiverMap['availability']?.toString() ?? '',
      responseTime: caregiverMap['response_time']?.toString() ??
          caregiverMap['avgResponse']?.toString() ??
          '',
      name: caregiverMap['full_name']?.toString() ??
          caregiverMap['name']?.toString() ??
          json['name']?.toString() ??
          '',
      service: caregiverMap['speciality']?.toString() ??
          caregiverMap['specialization']?.toString() ??
          json['service']?.toString() ??
          '',
      rating: _toDouble(caregiverMap['rating']),
      reviewsCount: _toInt(caregiverMap['reviews_count'] ?? caregiverMap['reviews']),
      isVerified: caregiverMap['verified'] == true || caregiverMap['active'] == true,
      isCertified: caregiverMap['certified'] == true,
      price: offerPrice > 0 ? offerPrice : caregiverPrice,
      oldPrice: caregiverPrice > 0 && offerPrice > 0 && caregiverPrice > offerPrice
          ? caregiverPrice
          : 0,
      specialization: caregiverMap['speciality']?.toString() ??
          caregiverMap['specialization']?.toString() ??
          '',
      notes: json['notes']?.toString() ?? '',
      bestValue: json['best_value'] == true,
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '0') ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '0') ?? 0;
  }

  static List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return const [];
  }
}
