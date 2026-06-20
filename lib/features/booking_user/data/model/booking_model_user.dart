class BookingModelUser {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String time;
  final String location;
  final int price;
  final String status;
  final String speciality;
  final String phone;
  final String paymentMethod;
  final String caregiverPicture;
  final double caregiverRating;
  final int caregiverReviewCount;

  BookingModelUser({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
    required this.location,
    required this.price,
    required this.status,
    required this.speciality,
    required this.phone,
    this.paymentMethod = '',
    this.caregiverPicture = '',
    this.caregiverRating = 0,
    this.caregiverReviewCount = 0,
  });

  bool get isPaidByBundle =>
      paymentMethod.toLowerCase() == 'bundle';

  BookingModelUser copyWith({String? status}) => BookingModelUser(
        id: id,
        title: title,
        subtitle: subtitle,
        date: date,
        time: time,
        location: location,
        price: price,
        status: status ?? this.status,
        speciality: speciality,
        phone: phone,
        paymentMethod: paymentMethod,
        caregiverPicture: caregiverPicture,
        caregiverRating: caregiverRating,
        caregiverReviewCount: caregiverReviewCount,
      );

  factory BookingModelUser.fromJson(Map<String, dynamic> json) {
    final service = json['service'];
    final request = json['request'];

    final rawStatus = (json['bookingStatus'] ?? json['status'] ?? '').toString().toLowerCase();

    String status;
    if (rawStatus == 'confirmed' ||
        rawStatus == 'pending' ||
        rawStatus == 'accepted' ||
        rawStatus == 'in_progress' ||  // check-in sets bookingStatus to IN_PROGRESS
        rawStatus == 'upcoming' ||
        rawStatus == 'active') {
      status = 'upcoming';
    } else if (rawStatus == 'completed') {
      status = 'completed';
    } else if (rawStatus == 'cancelled' || rawStatus == 'canceled') {
      status = 'cancelled';
    } else {
      // Unknown status: treat as upcoming so it's visible, not silently "Cancelled"
      status = 'upcoming';
    }

    return BookingModelUser(
      id:       json['_id']?.toString() ?? '',
      title:    service is Map ? (service['serviceName']?.toString() ?? 'Care Service') : 'Care Service',
      subtitle: json['caregiver'] is Map ? (json['caregiver']['full_name']?.toString() ?? '') : '',
      date:     request is Map ? _formatDate(request['date']?.toString()) : '',
      time:     request is Map ? (request['time']?.toString() ?? '') : '',
      location: request is Map ? (request['location']?.toString() ?? request['governorate']?.toString() ?? '') : '',
      price:    int.tryParse((json['price'] ?? 0).toString()) ?? 0,
      speciality: json['request'] is Map
          ? (json['request']['service'] is Map
          ? (json['request']['service']['serviceName']?.toString() ?? '')
          : '')
          : '',
      phone: json['caregiver'] is Map
          ? (json['caregiver']['phone']?.toString()
              ?? json['caregiver']['phoneNumber']?.toString()
              ?? json['caregiver']['phone_number']?.toString()
              ?? '')
          : '',
      status:   status,
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      caregiverPicture: json['caregiver'] is Map
          ? (json['caregiver']['profile_picture']?.toString()
              ?? json['caregiver']['profilePicture']?.toString()
              ?? json['caregiver']['avatar']?.toString()
              ?? '')
          : '',
      caregiverRating: json['caregiver'] is Map
          ? ((json['caregiver']['rating']
              ?? json['caregiver']['averageRating']
              ?? json['caregiver']['average_rating']
              ?? 0) as num).toDouble()
          : 0,
      caregiverReviewCount: json['caregiver'] is Map
          ? (int.tryParse(
                (json['caregiver']['reviewCount']
                    ?? json['caregiver']['review_count']
                    ?? json['caregiver']['totalReviews']
                    ?? json['caregiver']['numReviews']
                    ?? 0).toString()) ?? 0)
          : 0,
    );
  }
  static String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final parsed = DateTime.parse(raw).toLocal();
      return '${parsed.day}/${parsed.month}/${parsed.year}';
    } catch (_) {
      return raw.split('T').first;
    }
  }
}