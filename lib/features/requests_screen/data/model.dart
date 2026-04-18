import 'package:ehtemam_final_project/features/requests_screen/data/request_type.dart';


class RequestModel {
  final String title;
  final String subtitle;
  final String date;
  final String amount;
  final String status;
  final String? provider;
  final RequestType type;

  RequestModel({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.status,
    required this.type,
    this.provider,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      date: json['date'] ?? '',
      amount: json['amount']?.toString() ?? '',
      status: json['status'] ?? '',
      provider: json['provider'],
      type: _mapStringToRequestType(json['type']),
    );
  }

  static RequestType _mapStringToRequestType(String? type) {
    switch (type) {
      case 'pending':
        return RequestType.pending;
      case 'accepted':
        return RequestType.accepted;
      case 'completed':
        return RequestType.completed;
      case 'cancelled':
        return RequestType.cancelled;
      default:
        return RequestType.pending; // default fallback
    }
  }
}