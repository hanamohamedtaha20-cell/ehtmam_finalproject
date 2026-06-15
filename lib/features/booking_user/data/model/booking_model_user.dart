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

  BookingModelUser({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
    required this.location,
    required this.price,
    required this.status, required this.speciality, required this.phone,
  });

  factory BookingModelUser.fromJson(Map<String, dynamic> json) {
    final service = json['service'];
    final request = json['request'];
    final offer = json['offer'];

    final rawStatus = (json['bookingStatus'] ?? json['status'] ?? '').toString().toLowerCase();

    String status;
    if (rawStatus == 'confirmed' || rawStatus == 'pending' || rawStatus == 'accepted') {
      status = 'upcoming';
    } else if (rawStatus == 'completed') {
      status = 'completed';
    } else {
      status = 'cancelled';
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