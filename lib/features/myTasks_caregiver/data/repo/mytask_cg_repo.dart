import 'package:flutter/foundation.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/mytask_cg_booking_model.dart';
import '../model/mytask_cg_task_model.dart';

class MytaskCgRepo {
  final ApiService _api;
  MytaskCgRepo([ApiService? api]) : _api = api ?? ApiService();

  // ─────────────────────────────────────────────────────────────────────────
  // Load a single booking's tasks by bookingId (fast path).
  // ─────────────────────────────────────────────────────────────────────────
  Future<MytaskCgBookingModel> getTasksForBooking(String bookingId) async {
    final taskList = await _api.getTasksByBookingId(bookingId);

    String clientName   = '';
    String category     = '';
    bool   isCheckedIn  = false;
    String? checkInTime;
    double bookingAmount = 0;
    String offerId       = '';

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
        // Check-in state
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

        // ── Booking amount: offer price is the authoritative source ──────
        final offer = data['offer'];
        if (offer is Map) {
          bookingAmount = ((offer['price'] ?? 0) as num).toDouble();
          offerId = offer['_id']?.toString() ?? '';
        }
        if (bookingAmount == 0) {
          bookingAmount =
              ((data['price'] ?? data['budget'] ?? 0) as num).toDouble();
        }
      }
    } catch (e) {
      debugPrint('MytaskCgRepo.getTasksForBooking: booking details failed: $e');
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
      bookingId:     bookingId,
      clientName:    clientName,
      category:      category,
      tasks:         tasks,
      isCheckedIn:   isCheckedIn,
      checkInTime:   checkInTime,
      bookingAmount: bookingAmount,
      offerId:       offerId,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Load all active bookings with their tasks (slow path).
  // ─────────────────────────────────────────────────────────────────────────
  Future<List<MytaskCgBookingModel>> getBookings() async {
    final response = await _api.getMyBookings();
    final raw  = response['data'];
    final list = raw is List ? raw : <dynamic>[];

    list.sort((a, b) {
      final aStr = (a as Map)['createdAt']?.toString() ?? (a)['_id']?.toString() ?? '';
      final bStr = (b as Map)['createdAt']?.toString() ?? (b)['_id']?.toString() ?? '';
      return bStr.compareTo(aStr);
    });

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

      String clientName    = _clientNameFrom(item);
      double bookingAmount = 0;
      String offerId       = '';

      // Enrich: fetch full booking for offer price + client name
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
          if (clientName.isEmpty) clientName = _clientNameFrom(full);

          final offer = full['offer'];
          if (offer is Map) {
            bookingAmount = ((offer['price'] ?? 0) as num).toDouble();
            offerId = offer['_id']?.toString() ?? '';
          }
          if (bookingAmount == 0) {
            bookingAmount =
                ((full['price'] ?? full['budget'] ?? 0) as num).toDouble();
          }
        }
      } catch (e) {
        debugPrint('MytaskCgRepo: booking details fetch failed for $bookingId: $e');
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
        bookingId:     bookingId,
        clientName:    clientName,
        category:      category,
        tasks:         tasks,
        isCheckedIn:   isAlreadyCheckedIn,
        checkInTime:   checkInTimeStr,
        bookingAmount: bookingAmount,
        offerId:       offerId,
      ));
    }

    return bookings;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
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
