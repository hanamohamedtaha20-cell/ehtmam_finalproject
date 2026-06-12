import 'package:intl/intl.dart';

import 'request_type.dart';

class RequestModel {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String time;
  final String governorate;
  final String amount;
  final String status;
  final String? provider;
  final RequestType type;
  final int offersCount;
  final String Description;


  const RequestModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
    required this.governorate,
    required this.amount,
    required this.status,
    required this.type,
    this.provider,
    this.offersCount = 0, required this.Description,
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
    final rawGovernorate =
        json['governorate']?.toString() ?? json['location']?.toString() ?? '';

    final providerValue = json['provider'];
    String? providerName;
    if (providerValue is Map) {
      providerName = providerValue['full_name']?.toString() ??
          providerValue['name']?.toString();
    } else {
      providerName = providerValue?.toString();
    }

    return RequestModel(
      id: json['_id']?.toString() ?? '',
      title: serviceName,
      subtitle: json['duration']?.toString() ?? '',
      date: _formatDate(json['date']?.toString()),
      time: json['time']?.toString() ?? '',
      governorate: rawGovernorate,
      amount: json['budget']?.toString() ?? '',
      status: _formatStatus(statusValue),
      provider: providerName,
      type: _mapStringToRequestType(statusValue),
      offersCount: _toInt(json['offers_count']), Description: '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';

    try {
      final parsed = DateTime.parse(raw).toLocal();
      return DateFormat('MMM d, yyyy').format(parsed);
    } catch (_) {
      return raw.split('T').first;
    }
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
      "governorate": governorate,
      "amount": amount,
      "status": status,
      "provider": provider,
      "type": type.name,
      "offers_count": offersCount,
    };
  }
}