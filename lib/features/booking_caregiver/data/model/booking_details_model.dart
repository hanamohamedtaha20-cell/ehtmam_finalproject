import 'package:ehtemam_final_project/core/utils/date_formatter.dart';

class BookingDetailsModel {
  final String id;
  final String displayId;
  final String status;
  final String statusLabel;

  final String clientName;
  final String phone;
  final String email;
  final double rating;

  final String serviceType;
  final String petType;
  final String duration;

  final String date;
  final String time;
  final String location;

  final String specialInstructions;

  final double clientBudget;

  final List<TaskModel> tasks;

  BookingDetailsModel({
    required this.id,
    required this.displayId,
    required this.status,
    required this.statusLabel,
    required this.clientName,
    required this.phone,
    required this.email,
    required this.rating,
    required this.serviceType,
    required this.petType,
    required this.duration,
    required this.date,
    required this.time,
    required this.location,
    required this.specialInstructions,
    required this.clientBudget,
    this.tasks = const [],
  });

  factory BookingDetailsModel.fromRequestJson(Map<String, dynamic> json) {
    final service = json['service'];
    final client = json['client'];

    String serviceName = '';
    if (service is Map<String, dynamic>) {
      serviceName = service['serviceName']?.toString() ?? '';
    }

    String clientName = '';
    String phone = '';
    String email = '';
    if (client is Map<String, dynamic>) {
      clientName = client['full_name']?.toString() ?? '';
      phone = client['phone']?.toString() ?? '';
      email = client['email']?.toString() ?? '';
    }

    final statusValue = (json['status'] ?? 'PENDING').toString();

    return BookingDetailsModel(
      id: json['_id']?.toString() ?? '',
      displayId: _shortId(json['_id']?.toString() ?? ''),
      status: statusValue,
      statusLabel: _formatStatus(statusValue),
      clientName: clientName,
      phone: phone,
      email: email,
      rating: 0,
      serviceType: serviceName.isNotEmpty ? serviceName : 'Care Service',
      petType: json['notes']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      date: DateFormatter.formatDisplayDate(
        json['date']?.toString(),
        includeTime: false,
      ),
      time: _formatTime(json['date']?.toString(), json['time']?.toString()),
      location: json['location']?.toString() ?? '',
      specialInstructions: json['notes']?.toString() ?? '',
      clientBudget: 0,
    );
  }

  factory BookingDetailsModel.fromBookingJson(Map<String, dynamic> json) {
    final service = json['service'];
    final request = json['request'];
    final offer = json['offer'];
    final client = request is Map ? request['client'] : null;

    String serviceName = '';
    if (service is Map<String, dynamic>) {
      serviceName = service['serviceName']?.toString() ?? '';
    }

    String clientName = '';
    String phone = '';
    String email = '';
    if (client is Map<String, dynamic>) {
      clientName = client['full_name']?.toString() ?? '';
      phone = client['phone']?.toString() ?? '';
      email = client['email']?.toString() ?? '';
    }

    final statusValue = (json['status'] ?? 'PENDING').toString();
    final price = (offer?['price'] ?? json['price'] ?? 0).toDouble();

    return BookingDetailsModel(
      id: json['_id']?.toString() ?? '',
      displayId: _shortId(json['_id']?.toString() ?? ''),
      status: statusValue,
      statusLabel: _formatStatus(statusValue),
      clientName: clientName,
      phone: phone,
      email: email,
      rating: 0,
      serviceType: serviceName.isNotEmpty ? serviceName : 'Care Service',
      petType: request is Map ? (request['notes']?.toString() ?? '') : '',
      duration: request is Map ? (request['duration']?.toString() ?? '') : '',
      date: request is Map
          ? DateFormatter.formatDisplayDate(
              request['date']?.toString(),
              includeTime: false,
            )
          : '',
      time: request is Map
          ? _formatTime(request['date']?.toString(), request['time']?.toString())
          : '',
      location: request is Map ? (request['location']?.toString() ?? '') : '',
      specialInstructions:
          request is Map ? (request['notes']?.toString() ?? '') : '',
      clientBudget: price,
    );
  }

  BookingDetailsModel copyWith({
    String? clientName,
    String? phone,
    String? email,
    double? rating,
    List<TaskModel>? tasks,
  }) {
    return BookingDetailsModel(
      id: id,
      displayId: displayId,
      status: status,
      statusLabel: statusLabel,
      clientName: clientName ?? this.clientName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      rating: rating ?? this.rating,
      serviceType: serviceType,
      petType: petType,
      duration: duration,
      date: date,
      time: time,
      location: location,
      specialInstructions: specialInstructions,
      clientBudget: clientBudget,
      tasks: tasks ?? this.tasks,
    );
  }

  static String _formatTime(String? dateRaw, String? timeRaw) {
    if (timeRaw != null && timeRaw.isNotEmpty) return timeRaw;
    if (dateRaw == null || !dateRaw.contains('T')) return '';
    return DateFormatter.formatDisplayTime(dateRaw);
  }

  static String _shortId(String id) {
    if (id.length <= 8) return 'BK$id';
    return 'BK${id.substring(id.length - 5).toUpperCase()}';
  }

  static String _formatStatus(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pending';
      case 'CONFIRMED':
        return 'Confirmed';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      case 'ACCEPTED':
        return 'Accepted';
      default:
        return status;
    }
  }
}

class TaskModel {
  final String id;
  final String title;
  final bool done;

  TaskModel({
    required this.id,
    required this.title,
    required this.done,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final statusStr =
        (json['taskState'] ?? json['done'] ?? 'pending').toString().toLowerCase();
    final done = statusStr == 'completed' || statusStr == 'true';

    return TaskModel(
      id: json['_id']?.toString() ?? '',
      title: json['taskTitle']?.toString() ??
          json['title']?.toString() ??
          json['taskDescription']?.toString() ??
          '',
      done: done,
    );
  }
}
