import 'package:ehtemam_final_project/core/utils/date_formatter.dart';
import 'package:flutter/foundation.dart';

enum CareRequestSource { request, booking }

class CareRequestModel {
  final String id;
  final String status;
  final String serviceName;
  final String duration;
  final String location;
  final String date;
  final String time;
  final String notes;
  final String clientName;
  final double clientRating;
  final String price;
  final CareRequestSource sourceType;
  final String? bookingId;

  CareRequestModel({
    required this.id,
    required this.status,
    required this.serviceName,
    required this.duration,
    required this.location,
    required this.date,
    required this.time,
    required this.notes,
    required this.clientName,
    this.clientRating = 0,
    required this.price,
    required this.sourceType,
    this.bookingId,
  });

  factory CareRequestModel.fromRequestJson(Map<String, dynamic> json) {
    final service = json['service'];
    final client = json['client'];

    String serviceName = '';
    if (service is Map<String, dynamic>) {
      serviceName = service['serviceName']?.toString() ??
          service['name']?.toString() ??
          service['type']?.toString() ??
          service['careField']?.toString() ??
          '';
    }
    if (serviceName.isEmpty) {
      serviceName = json['serviceName']?.toString() ??
          json['careField']?.toString() ??
          json['speciality']?.toString() ??
          '';
    }
    debugPrint('[CareRequest] SERVICE_NAME_PARSED (request): "$serviceName" | service=$service');

    String clientName = '';
    double clientRating = 0;
    if (client is Map<String, dynamic>) {
      clientName = client['full_name']?.toString() ?? '';
      clientRating = ((client['rating'] ?? client['averageRating'] ?? client['average_rating'] ?? 0) as num).toDouble();
    }

    final statusValue = json['status']?.toString() ?? 'PENDING';

    return CareRequestModel(
      id: json['_id']?.toString() ?? '',
      status: _formatStatus(statusValue),
      serviceName: serviceName.isNotEmpty ? serviceName : 'Care Service',
      duration: json['duration']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      date: DateFormatter.formatDisplayDate(json['date']?.toString()),
      time: _formatTime(
        json['date']?.toString(),
        json['time']?.toString(),
      ),
      notes: json['notes']?.toString() ?? '',
      clientName: clientName,
      clientRating: clientRating,
      price: json['budget']?.toString() ?? '',
      sourceType: CareRequestSource.request,
    );
  }

  factory CareRequestModel.fromBookingJson(Map<String, dynamic> json) {
    final service = json['service'];
    final request = json['request'];
    final client = request is Map ? request['client'] : json['client'];

    String serviceName = '';
    if (service is Map<String, dynamic>) {
      serviceName = service['serviceName']?.toString() ??
          service['name']?.toString() ??
          service['type']?.toString() ??
          service['careField']?.toString() ??
          service['speciality']?.toString() ??
          '';
    }
    // Fallback: try request.service, then direct fields on json
    if (serviceName.isEmpty && request is Map) {
      final reqService = request['service'];
      if (reqService is Map) {
        serviceName = reqService['serviceName']?.toString() ??
            reqService['name']?.toString() ??
            reqService['type']?.toString() ??
            '';
      }
    }
    if (serviceName.isEmpty) {
      serviceName = json['serviceName']?.toString() ??
          json['careField']?.toString() ??
          json['speciality']?.toString() ??
          '';
    }
    debugPrint('[CareRequest] SERVICE_NAME_PARSED: "$serviceName" | service=$service');

    String clientName = '';
    double clientRating = 0;
    if (client is Map<String, dynamic>) {
      clientName = client['full_name']?.toString() ??
          client['fullName']?.toString() ??
          client['name']?.toString() ??
          '';
      clientRating = ((client['rating'] ?? client['averageRating'] ?? client['average_rating'] ?? 0) as num).toDouble();
    } else {
      clientName = json['clientName']?.toString() ?? '';
    }

    final rawStatus = (json['bookingStatus'] ?? json['status'] ?? '').toString().toUpperCase();
    String uiStatus;
    if (rawStatus == 'COMPLETED') {
      uiStatus = 'Completed';
    } else if (rawStatus == 'CANCELLED' ||
        rawStatus == 'REJECTED' ||
        rawStatus == 'DECLINED') {
      uiStatus = 'Cancelled';
    } else {
      // All other states: PENDING, CONFIRMED, ACCEPTED, IN_PROGRESS, CHECKED_IN, etc.
      // A booking record existing means the offer was accepted — always show as 'Accepted'.
      uiStatus = 'Accepted';
    }

    final price = _priceFromJson(json).toString();

    return CareRequestModel(
      id: request is Map
          ? (request['_id']?.toString() ?? json['_id']?.toString() ?? '')
          : (json['_id']?.toString() ?? ''),
      status: uiStatus,
      serviceName: serviceName.isNotEmpty ? serviceName : 'Care Service',
      duration: request is Map
          ? (request['duration']?.toString() ?? '')
          : (json['duration']?.toString() ?? ''),
      location: request is Map
          ? (request['location']?.toString() ?? '')
          : (json['location']?.toString() ?? ''),
      date: request is Map
          ? DateFormatter.formatDisplayDate(request['date']?.toString())
          : DateFormatter.formatDisplayDate(json['date']?.toString()),
      time: request is Map
          ? _formatTime(request['date']?.toString(), request['time']?.toString())
          : _formatTime(json['date']?.toString(), json['time']?.toString()),
      notes: request is Map
          ? (request['notes']?.toString() ?? '')
          : (json['notes']?.toString() ?? ''),
      clientName: clientName,
      clientRating: clientRating,
      price: price,
      sourceType: CareRequestSource.booking,
      bookingId: json['_id']?.toString(),
    );
  }

  CareRequestModel copyWithClientName(String clientName) {
    return CareRequestModel(
      id: id,
      status: status,
      serviceName: serviceName,
      duration: duration,
      location: location,
      date: date,
      time: time,
      notes: notes,
      clientName: clientName,
      clientRating: clientRating,
      price: price,
      sourceType: sourceType,
      bookingId: bookingId,
    );
  }

  CareRequestModel copyWithClientProfile({
    String? clientName,
    double? clientRating,
  }) {
    return CareRequestModel(
      id: id,
      status: status,
      serviceName: serviceName,
      duration: duration,
      location: location,
      date: date,
      time: time,
      notes: notes,
      clientName: clientName ?? this.clientName,
      clientRating: clientRating ?? this.clientRating,
      price: price,
      sourceType: sourceType,
      bookingId: bookingId,
    );
  }

  static num _priceFromJson(Map<String, dynamic> json) {
    final offer = json['offer'];
    if (offer is Map<String, dynamic>) {
      return (offer['price'] ?? json['price'] ?? 0) as num;
    }
    return (json['price'] ?? 0) as num;
  }

  static String _formatTime(String? dateRaw, String? timeRaw) {
    if (timeRaw != null && timeRaw.isNotEmpty) return timeRaw;
    if (dateRaw == null || !dateRaw.contains('T')) return '';
    return DateFormatter.formatDisplayTime(dateRaw);
  }

  static String _formatStatus(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pending';
      case 'ACCEPTED':
        return 'Accepted';
      case 'CONFIRMED':
        return 'Accepted';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return status;
    }
  }
}
