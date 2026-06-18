import 'package:flutter/foundation.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/mytask_cg_booking_model.dart';
import '../model/mytask_cg_task_model.dart';

class MytaskCgRepo {
  final ApiService _api;
  MytaskCgRepo([ApiService? api]) : _api = api ?? ApiService();

  // ─────────────────────────────────────────────────────────────────────────
  // Load a single booking's tasks by bookingId.
  // Called from MytaskCgCubit.loadTasksForBooking — fast path when we already
  // know which booking we're looking at (e.g. navigated from a request card).
  // ─────────────────────────────────────────────────────────────────────────
  Future<MytaskCgBookingModel> getTasksForBooking(String bookingId) async {
    // 1. Fetch tasks
    final taskList = await _api.getTasksByBookingId(bookingId);

    // 2. Fetch booking details for check-in state + metadata
    String clientName = '';
    String category = '';
    bool isCheckedIn = false;
    String? checkInTime;

    try {
      final bookingRes = await _api.getBookingById(bookingId);
      final rawData = bookingRes['data'];
      Map<String, dynamic>? data;
      if (rawData is Map<String, dynamic>) {
        data = rawData;
      } else if (rawData is List && rawData.isNotEmpty) {
        data = rawData.first as Map<String, dynamic>;
      }

      if (data != null) {
        final rawStatus =
            (data['bookingStatus'] ?? data['status'] ?? '').toString().toUpperCase();
        final rawCheckIn = data['checkInTime'] ??
            data['check_in_time'] ??
            data['checkinTime'] ??
            (data['checkIn'] is Map ? data['checkIn']['time'] : null);

        isCheckedIn = rawCheckIn != null || rawStatus == 'IN_PROGRESS';
        if (rawCheckIn != null) checkInTime = _formatIso(rawCheckIn.toString());

        clientName = _clientNameFrom(data);

        final service = data['service'];
        if (service is Map) {
          category = service['serviceName']?.toString() ??
              service['name']?.toString() ??
              '';
        }
      }
    } catch (e) {
      debugPrint('MytaskCgRepo.getTasksForBooking: booking details fetch failed: $e');
    }

    final tasks = taskList
        .whereType<Map<String, dynamic>>()
        .map((t) => MytaskCgTaskModel.fromJson(
              t,
              category: category,
              clientName: clientName,
            ))
        .toList();

    return MytaskCgBookingModel(
      bookingId:   bookingId,
      clientName:  clientName,
      category:    category,
      tasks:       tasks,
      isCheckedIn: isCheckedIn,
      checkInTime: checkInTime,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Load all active bookings with their tasks.
  // Used when MytaskCgScreen is opened without a specific bookingId.
  // ─────────────────────────────────────────────────────────────────────────
  Future<List<MytaskCgBookingModel>> getBookings() async {
    final response = await _api.getMyBookings();
    final raw = response['data'];
    final list = raw is List ? raw : <dynamic>[];

    final bookings = <MytaskCgBookingModel>[];

    for (final item in list) {
      if (item is! Map<String, dynamic>) continue;

      final rawStatus =
          (item['bookingStatus'] ?? item['status'] ?? '').toString().toUpperCase();
      if (rawStatus != 'CONFIRMED' &&
          rawStatus != 'ACCEPTED' &&
          rawStatus != 'IN_PROGRESS') {
        continue;
      }

      final bookingId = item['_id']?.toString() ?? '';
      if (bookingId.isEmpty) continue;

      final service = item['service'];
      final category = service is Map
          ? (service['serviceName']?.toString() ??
              service['name']?.toString() ??
              'Care Service')
          : 'Care Service';

      String clientName = _clientNameFrom(item);

      if (clientName.isEmpty) {
        try {
          final fullRes = await _api.getBookingById(bookingId);
          final rawData = fullRes['data'];
          Map<String, dynamic>? full;
          if (rawData is Map<String, dynamic>) {
            full = rawData;
          } else if (rawData is List && rawData.isNotEmpty) {
            full = rawData.first as Map<String, dynamic>;
          }

          if (full != null) {
            clientName = _clientNameFrom(full);

            if (clientName.isEmpty) {
              final clientId = full['client'] is String
                  ? full['client'] as String
                  : (full['request'] is Map
                      ? full['request']['client']?.toString()
                      : null);

              if (clientId != null && clientId.isNotEmpty) {
                final profileRes = await _api.getUserProfile(clientId);
                final rawProfile = profileRes['data'];
                final profile = rawProfile is Map<String, dynamic>
                    ? rawProfile
                    : <String, dynamic>{};
                clientName = profile['full_name']?.toString() ??
                    profile['fullName']?.toString() ??
                    '';
              }
            }
          }
        } catch (e) {
          debugPrint('MytaskCgRepo: client name enrichment failed for $bookingId: $e');
        }
      }

      List<MytaskCgTaskModel> tasks = [];
      try {
        final taskList = await _api.getTasksByBookingId(bookingId);
        tasks = taskList
            .whereType<Map<String, dynamic>>()
            .map((t) => MytaskCgTaskModel.fromJson(
                  t,
                  category: category,
                  clientName: clientName,
                ))
            .toList();
      } catch (_) {}

      final rawCheckInTime = item['checkInTime'] ??
          item['check_in_time'] ??
          item['checkinTime'] ??
          (item['checkIn'] is Map ? item['checkIn']['time'] : null);
      final isAlreadyCheckedIn =
          rawCheckInTime != null || rawStatus == 'IN_PROGRESS';
      final checkInTimeStr =
          rawCheckInTime != null ? _formatIso(rawCheckInTime.toString()) : null;

      bookings.add(MytaskCgBookingModel(
        bookingId:   bookingId,
        clientName:  clientName,
        category:    category,
        tasks:       tasks,
        isCheckedIn: isAlreadyCheckedIn,
        checkInTime: checkInTimeStr,
      ));
    }

    return bookings;
  }

  String _formatIso(String raw) {
    try {
      final dt = DateTime.parse(raw).toLocal();
      final h = dt.hour;
      final displayH = h > 12 ? h - 12 : (h == 0 ? 12 : h);
      final m = dt.minute.toString().padLeft(2, '0');
      return '$displayH:$m ${h >= 12 ? 'PM' : 'AM'}';
    } catch (_) {
      return raw;
    }
  }

  String _clientNameFrom(Map<String, dynamic> booking) {
    final topClient = booking['client'];
    if (topClient is Map) {
      final name = topClient['full_name']?.toString() ??
          topClient['fullName']?.toString() ??
          '';
      if (name.isNotEmpty) return name;
    }
    final request = booking['request'];
    if (request is Map) {
      final reqClient = request['client'];
      if (reqClient is Map) {
        return reqClient['full_name']?.toString() ??
            reqClient['fullName']?.toString() ??
            '';
      }
    }
    return '';
  }
}
