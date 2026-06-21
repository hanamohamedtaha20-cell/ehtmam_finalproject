import 'package:flutter/foundation.dart';
import 'package:ehtemam_final_project/core/utils/date_formatter.dart';

class BookingDetailsModel {
  final String id;
  final String requestId;
  final String displayId;
  final String status;
  final String statusLabel;

  final String clientName;
  final String phone;
  final String email;
  final double rating;
  final String clientProfilePicture;

  final String serviceType;
  final String petType;
  final String duration;

  final String date;
  final String time;
  final String location;
  final String governorate;
  final String street;
  final String building;

  final String description;
  final String offerDescription;
  final String specialInstructions;

  final double clientBudget;
  final double caregiverBudget;

  final List<TaskModel> tasks;

  BookingDetailsModel({
    required this.id,
    required this.requestId,
    required this.displayId,
    required this.status,
    required this.statusLabel,
    required this.clientName,
    required this.phone,
    required this.email,
    required this.rating,
    this.clientProfilePicture = '',
    required this.serviceType,
    required this.petType,
    required this.duration,
    required this.date,
    required this.time,
    required this.location,
    this.governorate = '',
    this.street = '',
    this.building = '',
    this.description = '',
    this.offerDescription = '',
    required this.specialInstructions,
    required this.clientBudget,
    this.caregiverBudget = 0,
    this.tasks = const [],
  });

  // ── Description extraction ────────────────────────────────────────────────
  // Searches every known nesting path for the description field and logs each
  // candidate so the real backend path is visible in the debug output.

  static String _extractDescription(
    Map<String, dynamic> root, {
    Map? requestMap,
    String context = '',
  }) {
    final dataMap = root['data'] is Map ? root['data'] as Map : null;
    final rootRequest = root['request'] is Map ? root['request'] as Map : null;
    final dataRequest = dataMap != null && dataMap['request'] is Map
        ? dataMap['request'] as Map
        : null;

    // Effective "request" sub-object: explicit param wins, then nested paths.
    final req = requestMap ?? rootRequest ?? dataRequest;

    debugPrint('DESCRIPTION_ROOT: ${root['Description']}');
    debugPrint('DESCRIPTION_LOWER_ROOT: ${root['description']}');
    debugPrint('DESCRIPTION_REQUEST: ${req?['Description']}');
    debugPrint('DESCRIPTION_REQUEST_LOWER: ${req?['description']}');

    // All search paths in priority order (matches task requirements):
    final candidates = <String?>[
      root['Description']?.toString(),          // json['Description']
      root['description']?.toString(),          // json['description']
      dataMap?['Description']?.toString(),      // json['data']['Description']
      dataMap?['description']?.toString(),      // json['data']['description']
      dataRequest?['Description']?.toString(),  // json['data']['request']['Description']
      dataRequest?['description']?.toString(),  // json['data']['request']['description']
      req?['Description']?.toString(),          // json['request']['Description']
      req?['description']?.toString(),          // json['request']['description']
    ];

    for (final v in candidates) {
      if (v != null && v.trim().isNotEmpty) {
        debugPrint('[$context] DESCRIPTION_RESOLVED: "$v"');
        return v.trim();
      }
    }

    debugPrint('[$context] DESCRIPTION_RESOLVED: <empty — check backend field name>');
    return '';
  }

  // ─────────────────────────────────────────────────────────────────────────

  factory BookingDetailsModel.fromRequestJson(Map<String, dynamic> json) {
    debugPrint('[RequestModel] keys: ${json.keys.toList()}');
    debugPrint('[RequestModel] full json: $json');

    final service = json['service'];
    final client = json['client'];

    String serviceName = '';
    if (service is Map<String, dynamic>) {
      serviceName = service['serviceName']?.toString() ?? '';
    }

    String clientName = '';
    String phone = '';
    String email = '';
    String clientProfilePicture = '';
    double clientRating = 0;
    if (client is Map<String, dynamic>) {
      clientName = client['full_name']?.toString() ?? '';
      phone = client['phoneNumber']?.toString() ??
          client['phone']?.toString() ??
          client['phone_number']?.toString() ??
          '';
      email = client['email']?.toString() ?? '';
      clientProfilePicture = client['profile_picture']?.toString() ??
          client['profilePicture']?.toString() ??
          client['avatar']?.toString() ??
          '';
      clientRating =
          ((client['rating'] ?? client['averageRating'] ?? 0) as num).toDouble();
    }

    final statusValue = (json['status'] ?? 'PENDING').toString();
    final description = _extractDescription(json, context: 'RequestModel');

    return BookingDetailsModel(
      id: json['_id']?.toString() ?? '',
      requestId: json['_id']?.toString() ?? '',
      displayId: _shortId(json['_id']?.toString() ?? ''),
      status: statusValue,
      statusLabel: _formatStatus(statusValue),
      clientName: clientName,
      phone: phone,
      email: email,
      rating: clientRating,
      clientProfilePicture: clientProfilePicture,
      serviceType: serviceName.isNotEmpty ? serviceName : 'Care Service',
      petType: json['notes']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      date: DateFormatter.formatDisplayDate(
        json['date']?.toString(),
        includeTime: false,
      ),
      time: _formatTime(json['date']?.toString(), json['time']?.toString()),
      location: json['location']?.toString() ?? '',
      governorate: json['governorate']?.toString() ?? '',
      description: description,
      specialInstructions: json['notes']?.toString() ?? '',
      clientBudget: ((json['budget'] ?? 0) as num).toDouble(),
    );
  }

  factory BookingDetailsModel.fromBookingJson(Map<String, dynamic> json) {
    debugPrint('[BookingModel] keys: ${json.keys.toList()}');
    debugPrint('[BookingModel] full json: $json');

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
    String clientProfilePicture = '';
    double clientRating = 0;
    if (client is Map<String, dynamic>) {
      clientName = client['full_name']?.toString() ?? '';
      phone = client['phoneNumber']?.toString() ??
          client['phone']?.toString() ??
          client['phone_number']?.toString() ??
          '';
      email = client['email']?.toString() ?? '';
      clientProfilePicture = client['profile_picture']?.toString() ??
          client['profilePicture']?.toString() ??
          client['avatar']?.toString() ??
          '';
      clientRating =
          ((client['rating'] ?? client['averageRating'] ?? 0) as num).toDouble();
    }

    final statusValue =
        (json['bookingStatus'] ?? json['status'] ?? 'PENDING').toString();

    final offerPrice = offer is Map ? offer['price'] : null;
    final selectedOffer = json['selectedOffer'];
    final selectedOfferPrice = selectedOffer is Map ? selectedOffer['price'] : null;
    final price = _parsePrice(offerPrice) ??
        _parsePrice(json['finalPrice']) ??
        _parsePrice(selectedOfferPrice) ??
        _parsePrice(json['caregiverBudget']) ??
        _parsePrice(json['price']) ??
        0.0;

    debugPrint('[BookingModel] offer sub-object: $offer');

    String offerDescription = '';
    if (offer is Map) {
      offerDescription = offer['notes']?.toString() ??
          offer['Description']?.toString() ??
          offer['message']?.toString() ??
          offer['note']?.toString() ??
          offer['comment']?.toString() ??
          '';
      debugPrint('[BookingModel] offerDescription resolved: "$offerDescription"');
      if (offerDescription.isEmpty) {
        debugPrint(
            '[BookingModel] Backend does not return offer description — endpoint: GET /booking/{bookingId}');
      }
    } else {
      debugPrint(
          '[BookingModel] offer field is not a Map (value: $offer) — cannot extract offer description');
    }

    debugPrint('CAREGIVER_BUDGET_VALUE: $price');

    // Normalise the request sub-object so _extractDescription can search it.
    final reqMap = request is Map<String, dynamic>
        ? request
        : (request is Map ? Map<String, dynamic>.from(request) : null);

    final description = _extractDescription(
      json,
      requestMap: reqMap,
      context: 'BookingModel',
    );

    return BookingDetailsModel(
      id: json['_id']?.toString() ?? '',
      requestId: request is Map
          ? (request['_id']?.toString() ?? '')
          : (request?.toString() ?? ''),
      displayId: _shortId(json['_id']?.toString() ?? ''),
      status: statusValue,
      statusLabel: _formatStatus(statusValue),
      clientName: clientName,
      phone: phone,
      email: email,
      rating: clientRating,
      clientProfilePicture: clientProfilePicture,
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
          ? _formatTime(
              request['date']?.toString(), request['time']?.toString())
          : '',
      location: request is Map ? (request['location']?.toString() ?? '') : '',
      governorate:
          request is Map ? (request['governorate']?.toString() ?? '') : '',
      description: description,
      offerDescription: offerDescription,
      specialInstructions:
          request is Map ? (request['notes']?.toString() ?? '') : '',
      clientBudget: price,
      caregiverBudget: price,
    );
  }

  BookingDetailsModel copyWith({
    String? clientName,
    String? phone,
    String? email,
    double? rating,
    String? clientProfilePicture,
    String? street,
    String? building,
    List<TaskModel>? tasks,
  }) {
    return BookingDetailsModel(
      id: id,
      requestId: requestId,
      displayId: displayId,
      status: status,
      statusLabel: statusLabel,
      clientName: clientName ?? this.clientName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      rating: rating ?? this.rating,
      clientProfilePicture: clientProfilePicture ?? this.clientProfilePicture,
      serviceType: serviceType,
      petType: petType,
      duration: duration,
      date: date,
      time: time,
      location: location,
      governorate: governorate,
      street: street ?? this.street,
      building: building ?? this.building,
      description: description,
      offerDescription: offerDescription,
      specialInstructions: specialInstructions,
      clientBudget: clientBudget,
      caregiverBudget: caregiverBudget,
      tasks: tasks ?? this.tasks,
    );
  }

  static double? _parsePrice(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
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
      case 'ACCEPTED':
        return 'Accepted';
      case 'IN_PROGRESS':
      case 'UPCOMING':
      case 'ACTIVE':
        return 'In Progress';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
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

  factory TaskModel.fromJson(Map<String, dynamic> json, {int index = 0}) {
    final statusStr =
        (json['taskState'] ?? json['done'] ?? 'pending').toString().toLowerCase();
    final done = statusStr == 'completed' || statusStr == 'true';

    return TaskModel(
      id: json['_id']?.toString() ??
          json['taskId']?.toString() ??
          'task_$index',
      title: json['taskName']?.toString() ??
          json['taskTitle']?.toString() ??
          json['title']?.toString() ??
          json['taskDescription']?.toString() ??
          '',
      done: done,
    );
  }
}
