class ProviderModel {
  final String id;
  final String caregiverId;
  final String status;
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
  final double hourlyRate;

  final String name;
  final String service;
  final double rating;

  final String specialization;
  final String notes;
  final bool bestValue;

  ProviderModel({
    required this.id,
    this.caregiverId = '',
    this.status = '',
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
    this.hourlyRate = 0,
    required this.name,
    required this.service,
    required this.rating,
    required this.specialization,
    required this.notes,
    required this.bestValue,
  });

  factory ProviderModel.fromOfferJson(Map<String, dynamic> json) {
    final caregiver = json['caregiver'];
    final caregiverMap = caregiver is Map
        ? Map<String, dynamic>.from(caregiver)
        : <String, dynamic>{};

    final hourlyRate = _toDouble(caregiverMap['price']);
    final offerPrice = _toDouble(json['price']);
    final explicitOldPrice = _toDouble(json['old_price'] ?? json['oldPrice']);

    return ProviderModel(
      id: _asString(json['_id']),
      caregiverId: _asString(caregiverMap['_id']),
      status: _asString(json['status']),
      description: _firstNonEmpty([
        caregiverMap['experience'],
        caregiverMap['bio'],
        json['description'],
      ]),
      experience: _asString(caregiverMap['experience']),
      completed: _toInt(
        caregiverMap['completed'] ?? caregiverMap['totalRequests'],
      ),
      qualifications: _toStringList(
        caregiverMap['qualifications'] ?? caregiverMap['certifications'],
      ),
      phone: _asString(caregiverMap['phone']),
      email: _asString(caregiverMap['email']),
      location: _firstNonEmpty([
        caregiverMap['governorate'],
        caregiverMap['location'],
      ]),
      availability: _asString(caregiverMap['availability']),
      responseTime: _firstNonEmpty([
        caregiverMap['response_time'],
        caregiverMap['avgResponse'],
      ]),
      name: _firstNonEmpty([
        caregiverMap['full_name'],
        caregiverMap['fullName'],
        caregiverMap['name'],
        json['name'],
      ]),
      service: _firstNonEmpty([
        _serviceName(json['service']),
        caregiverMap['speciality'],
        caregiverMap['specialization'],
        caregiverMap['specialty'],
      ]),
      rating: _toDouble(caregiverMap['rating']),
      reviewsCount: _toInt(
        caregiverMap['reviews_count'] ?? caregiverMap['reviews'],
      ),
      isVerified:
          caregiverMap['verified'] == true || caregiverMap['active'] == true,
      isCertified: caregiverMap['certified'] == true,
      price: offerPrice,
      oldPrice: explicitOldPrice,
      hourlyRate: hourlyRate,
      specialization: _firstNonEmpty([
        caregiverMap['speciality'],
        caregiverMap['specialization'],
        caregiverMap['specialty'],
      ]),
      notes: _asString(json['notes']),
      bestValue: json['best_value'] == true,
    );
  }

  static String _serviceName(dynamic service) {
    if (service is Map) {
      return _firstNonEmpty([
        service['serviceName'],
        service['name'],
        service['title'],
      ]);
    }
    return _asString(service);
  }

  static String _asString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static String _firstNonEmpty(List<dynamic> values) {
    for (final value in values) {
      final text = _asString(value).trim();
      if (text.isNotEmpty) return text;
    }
    return '';
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(_asString(value)) ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(_asString(value)) ?? 0;
  }

  static List<String> _toStringList(dynamic value) {
    if (value is! List) return const [];

    return value
        .map((item) => _asString(item).trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}
