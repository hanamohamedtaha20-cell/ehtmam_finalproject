import 'package:ehtemam_final_project/core/utils/date_formatter.dart';

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
    required this.price,
    required this.sourceType,
    this.bookingId,
  });

  factory CareRequestModel.fromRequestJson(Map<String, dynamic> json) {
    final service = json['service'];
    final client = json['client'];

    String serviceName = '';
    if (service is Map<String, dynamic>) {
      serviceName = service['serviceName']?.toString() ?? '';
    }

    String clientName = '';
    if (client is Map<String, dynamic>) {
      clientName = client['full_name']?.toString() ?? '';
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
      price: json['budget']?.toString() ?? '',
      sourceType: CareRequestSource.request,
    );
  }

  factory CareRequestModel.fromBookingJson(Map<String, dynamic> json) {
    final service = json['service'];
    final request = json['request'];
    final client = request is Map ? request['client'] : null;

    String serviceName = '';
    if (service is Map<String, dynamic>) {
      serviceName = service['serviceName']?.toString() ?? '';
    }

    String clientName = '';
    if (client is Map<String, dynamic>) {
      clientName = client['full_name']?.toString() ?? '';
    }

    final rawStatus = (json['status'] ?? '').toString().toUpperCase();
    String uiStatus;
    if (rawStatus == 'CONFIRMED') {
      uiStatus = 'Accepted';
    } else if (rawStatus == 'COMPLETED') {
      uiStatus = 'Completed';
    } else {
      uiStatus = _formatStatus(rawStatus);
    }

    final price = _priceFromJson(json).toString();

    return CareRequestModel(
      id: request is Map
          ? (request['_id']?.toString() ?? json['_id']?.toString() ?? '')
          : (json['_id']?.toString() ?? ''),
      status: uiStatus,
      serviceName: serviceName.isNotEmpty ? serviceName : 'Care Service',
      duration: request is Map ? (request['duration']?.toString() ?? '') : '',
      location: request is Map ? (request['location']?.toString() ?? '') : '',
      date: request is Map
          ? DateFormatter.formatDisplayDate(request['date']?.toString())
          : '',
      time: request is Map
          ? _formatTime(
              request['date']?.toString(),
              request['time']?.toString(),
            )
          : '',
      notes: request is Map ? (request['notes']?.toString() ?? '') : '',
      clientName: clientName,
      price: price,
      sourceType: CareRequestSource.booking,
      bookingId: json['_id']?.toString(),
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
