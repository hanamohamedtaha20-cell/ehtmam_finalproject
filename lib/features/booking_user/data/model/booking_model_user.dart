class BookingModelUser {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String time;
  final String location;
  final int price;
  final String status;

  BookingModelUser({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
    required this.location,
    required this.price,
    required this.status,
  });

  factory BookingModelUser.fromJson(Map<String, dynamic> json) {
    final service  = json['service'];
    final request  = json['request'];
    final offer    = json['offer'];

    final rawStatus = (json['status'] ?? '').toString().toLowerCase();
    String status;
    if (rawStatus == 'confirmed' || rawStatus == 'pending') {
      status = 'upcoming';
    } else if (rawStatus == 'completed') {
      status = 'completed';
    } else {
      status = 'cancelled';
    }

    return BookingModelUser(
      id:       json['_id']                    ?? '',
      title:    service?['serviceName']         ?? 'Care Service',
      subtitle: json['caregiver']?['full_name'] ?? '',
      date:     request?['date']               ?? '',
      time:     request?['time']               ?? '',
      location: request?['location']           ?? '',
      price:    (offer?['price'] ?? json['price'] ?? 0).toInt(),
      status:   status,
    );
  }
}