import 'request_type.dart';

class RequestModel {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String time;
  final String location;
  final String amount;
  final String status;
  final String? provider;
  final RequestType type;
  final int offersCount;


  const RequestModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
    required this.location,
    required this.amount,
    required this.status,
    required this.type,
    this.provider,
    this.offersCount = 0,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    final service = json['service'];

    String serviceName = '';

    if (service is Map<String, dynamic>) {
      serviceName = service['serviceName']?.toString() ?? '';
    } else {
      serviceName = service?.toString() ?? '';
    }

    final statusValue = json['status']?.toString() ?? 'PENDING';

    return RequestModel(
      id: json['_id']?.toString() ?? '',
      title: serviceName,
      subtitle: json['duration']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      amount: json['budget']?.toString() ?? '',
      status: _formatStatus(statusValue),
      provider: json['provider']?.toString(),
      type: _mapStringToRequestType(statusValue),
      offersCount: json['offers_count'] ?? 0,
    );
  }

  static String _formatStatus(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pending';
      case 'ACCEPTED':
        return 'Accepted';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return status;
    }
  }

  static RequestType _mapStringToRequestType(String? type) {
    switch (type?.toUpperCase()) {
      case 'PENDING':
        return RequestType.pending;
      case 'ACCEPTED':
        return RequestType.accepted;
      case 'COMPLETED':
        return RequestType.completed;
      case 'CANCELLED':
        return RequestType.cancelled;
      default:
        return RequestType.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "subtitle": subtitle,
      "date": date,
      "time": time,
      "location": location,
      "amount": amount,
      "status": status,
      "provider": provider,
      "type": type.name,
      "offers_count": offersCount,
    };
  }
}