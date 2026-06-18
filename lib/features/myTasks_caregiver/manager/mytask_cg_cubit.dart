import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/mytask_cg_booking_model.dart';
import '../data/model/mytask_cg_task_model.dart';
import '../data/repo/mytask_cg_repo.dart';
import 'mytask_cg_state.dart';
import 'package:image_picker/image_picker.dart';

class MytaskCgCubit extends Cubit<MytaskCgState> {
  final MytaskCgRepo repo;
  final ApiService _api = ApiService();
  final ImagePicker _picker = ImagePicker();

  // Remembered so silent refreshes after upload know which booking to reload.
  String? _currentBookingId;

  MytaskCgCubit(this.repo) : super(MytaskCgInitial());

  // ── Load by bookingId (fast path — direct GET /booking/{id}/tasks) ────────
  Future<void> loadTasksForBooking(String bookingId) async {
    _currentBookingId = bookingId;
    if (isClosed) return;
    emit(MytaskCgLoading());
    try {
      final booking = await repo.getTasksForBooking(bookingId);
      if (!isClosed) emit(MytaskCgLoaded(bookings: [booking]));
    } catch (e) {
      if (!isClosed) emit(MytaskCgError(_friendlyTaskError(e)));
    }
  }

  String _friendlyTaskError(Object e) {
    final msg = e.toString();
    if (msg.contains('auth_required')) {
      return 'Please login again to view your tasks.';
    }
    if (msg.contains('forbidden_403')) {
      return 'You are not allowed to view tasks for this booking.\n'
          'Please make sure this booking belongs to the logged-in caregiver.';
    }
    // Catch a raw DioException 403 in case it propagates without the label
    try {
      // ignore: avoid_dynamic_calls
      final dynamic dioE = e;
      final statusCode = dioE.response?.statusCode;
      if (statusCode == 403) {
        return 'You are not allowed to view tasks for this booking.\n'
            'Please make sure this booking belongs to the logged-in caregiver.';
      }
    } catch (_) {}
    return _extractErrorMessage(e);
  }

  // ── Load all active bookings (fallback — no bookingId known) ──────────────
  Future<void> loadBookings() async {
    if (isClosed) return;
    emit(MytaskCgLoading());
    try {
      final bookings = await repo.getBookings();
      if (!isClosed) emit(MytaskCgLoaded(bookings: bookings));
    } catch (e) {
      if (!isClosed) emit(MytaskCgError(e.toString()));
    }
  }

  // ── Silent refresh — reloads tasks without flashing a loading spinner ─────
  Future<void> _silentRefreshTasks() async {
    final id = _currentBookingId;
    if (id == null) return;
    final current = state;
    if (current is! MytaskCgLoaded) return;
    try {
      final freshBooking = await repo.getTasksForBooking(id);
      final updated = current.bookings.map((b) {
        return b.bookingId == id ? freshBooking : b;
      }).toList();
      if (!isClosed) emit(MytaskCgLoaded(bookings: updated, filter: current.filter));
    } catch (e) {
      debugPrint('_silentRefreshTasks failed: $e');
    }
  }

  void filterBookings(String filter) {
    final current = state as MytaskCgLoaded;
    emit(MytaskCgLoaded(bookings: current.bookings, filter: filter));
  }

  // ── Check-in — returns '' on success, error message on failure ────────────
  Future<String> checkIn(String bookingId) async {
    final current = state;
    if (current is! MytaskCgLoaded) return 'Not loaded';

    String time = _toAmPm(DateTime.now());
    String error = '';

    try {
      final response = await _api.checkInBooking(bookingId);
      final data = response['data'];
      if (data is Map) {
        final rawTime = data['checkInTime'] ??
            data['check_in_time'] ??
            data['checkinTime'];
        if (rawTime != null) time = _formatIsoTime(rawTime.toString());
      }
    } catch (e) {
      error = _extractErrorMessage(e);
      debugPrint('checkIn failed: $e');
    }

    final updated = current.bookings.map((b) {
      if (b.bookingId == bookingId) {
        return b.copyWith(isCheckedIn: true, checkInTime: time);
      }
      return b;
    }).toList();

    if (!isClosed) emit(MytaskCgLoaded(bookings: updated, filter: current.filter));
    return error;
  }

  // ── Check-out — returns '' on success, error message on failure ───────────
  // After a successful checkout the method also calls processPayment so the
  // booking amount is released to the caregiver wallet.  That call is
  // non-fatal: if it fails the checkout still succeeds.
  Future<String> checkOut(String bookingId) async {
    final current = state;
    if (current is! MytaskCgLoaded) return 'Not loaded';

    // Locate the booking so we can access offerId and bookingAmount.
    MytaskCgBookingModel? booking;
    try {
      booking = current.bookings.firstWhere((b) => b.bookingId == bookingId);
    } catch (_) {}

    // Ensure the caregiver's wallet exists — the backend checkout endpoint
    // will reject with "wallet not found" if no wallet record exists yet.
    await _ensureWalletExists();

    try {
      await _api.checkOutBooking(bookingId);
    } catch (e) {
      debugPrint('checkOut failed: $e');
      return _extractErrorMessage(e);
    }

    // ── Release payment to caregiver wallet ────────────────────────────────
    // Prefer offerId (the process-payment endpoint was designed for it).
    // Fall back to bookingId if no offer is available.
    final paymentId = (booking?.offerId.isNotEmpty == true)
        ? booking!.offerId
        : bookingId;
    try {
      await _api.processPayment(paymentId);
      debugPrint('[Checkout] processPayment succeeded — id=$paymentId '
          'amount=${booking?.bookingAmount}');
    } catch (e) {
      // Non-fatal: checkout already succeeded; wallet may update later
      // or the backend releases funds automatically on checkout.
      debugPrint('[Checkout] processPayment failed (non-fatal): $e');
    }

    final updated = current.bookings.map((b) {
      if (b.bookingId == bookingId) return b.copyWith(isCheckedOut: true);
      return b;
    }).toList();

    if (!isClosed) emit(MytaskCgLoaded(bookings: updated, filter: current.filter));
    return '';
  }

  // ── Upload proof for a task ───────────────────────────────────────────────
  // Returns:
  //   null  — picker cancelled (no SnackBar needed)
  //   ''    — all files uploaded successfully (show success SnackBar)
  //   msg   — at least one upload failed (show error SnackBar)
  Future<String?> addMediaToTask(String bookingId, String taskId) async {
    final List<XFile> files = await _picker.pickMultipleMedia();
    if (files.isEmpty) return null; // user cancelled

    int success = 0;
    String? lastError;

    for (final file in files) {
      try {
        await _api.uploadTaskProof(
          taskId: taskId,
          proofFile: File(file.path),
        );
        success++;
      } catch (e) {
        lastError = _extractErrorMessage(e);
        debugPrint('uploadTaskProof failed: $e');
      }
    }

    // Refresh task list from server so proofFiles reflect the server's state.
    _currentBookingId ??= bookingId;
    await _silentRefreshTasks();

    if (lastError != null) return lastError;
    if (success > 0) return '';   // empty = success indicator
    return null;
  }

  // ── Toggle task done (requires proof to be uploaded first) ────────────────
  Future<void> toggleTaskDone(String bookingId, String taskId) async {
    final current = state as MytaskCgLoaded;
    final booking = current.bookings.firstWhere((b) => b.bookingId == bookingId);
    final task = booking.tasks.firstWhere((t) => t.id == taskId);

    if (task.mediaProof.isEmpty) return;

    final newDone = !task.isDone;
    _emitWithTaskToggled(current, bookingId, taskId, newDone);

    try {
      await _api.updateTask(
        id: task.id,
        taskState: newDone ? 'completed' : 'pending',
      );
    } catch (_) {
      _emitWithTaskToggled(current, bookingId, taskId, task.isDone);
    }
  }

  void _emitWithTaskToggled(
    MytaskCgLoaded current,
    String bookingId,
    String taskId,
    bool isDone,
  ) {
    final updated = current.bookings.map((b) {
      if (b.bookingId == bookingId) {
        final updatedTasks = b.tasks.map((t) {
          if (t.id == taskId) return t.copyWith(isDone: isDone);
          return t;
        }).toList();
        return b.copyWith(tasks: updatedTasks);
      }
      return b;
    }).toList();
    if (!isClosed) emit(MytaskCgLoaded(bookings: updated, filter: current.filter));
  }

  // ── Add a caregiver-created task ──────────────────────────────────────────
  Future<String?> addTask(String bookingId, String taskName) async {
    final current = state;
    if (current is! MytaskCgLoaded) return 'State not loaded';

    try {
      final response = await _api.addCaregiverTask(
        bookingId: bookingId,
        taskName: taskName,
      );

      final raw = response['data'];
      final Map<String, dynamic> data =
          raw is Map<String, dynamic> ? raw : {};

      final task = MytaskCgTaskModel(
        id: data['_id']?.toString() ??
            data['taskId']?.toString() ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: data['taskName']?.toString() ??
            data['taskDescription']?.toString() ??
            taskName,
        description: data['taskDescription']?.toString() ?? taskName,
        assignedTo: '',
        category: 'General',
        date: DateTime.now().toString().substring(0, 10),
        isAddedByCaregiver: true,
      );

      final updated = current.bookings.map((b) {
        if (b.bookingId == bookingId) {
          return b.copyWith(tasks: [...b.tasks, task]);
        }
        return b;
      }).toList();

      if (!isClosed) emit(MytaskCgLoaded(bookings: updated, filter: current.filter));
      return null;
    } catch (e) {
      debugPrint('addTask failed: $e');
      return _extractErrorMessage(e);
    }
  }

  void deleteTask(String bookingId, String taskId) {
    final current = state as MytaskCgLoaded;
    final updated = current.bookings.map((b) {
      if (b.bookingId == bookingId) {
        return b.copyWith(
          tasks: b.tasks
              .where((t) => !(t.id == taskId && t.isAddedByCaregiver))
              .toList(),
        );
      }
      return b;
    }).toList();
    emit(MytaskCgLoaded(bookings: updated, filter: current.filter));
  }

  // ── Ensure wallet exists — creates one if missing ────────────────────────
  // The backend checkout endpoint requires the caregiver wallet to exist.
  Future<void> _ensureWalletExists() async {
    try {
      await _api.getMyWallet();
      // Wallet exists — nothing to do.
    } catch (_) {
      // Wallet not found or any error: try to create it.
      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userId') ?? '';
        if (userId.isNotEmpty) {
          await _api.createWallet(userId);
          debugPrint('[Checkout] Wallet created for userId=$userId');
        }
      } catch (e) {
        debugPrint('[Checkout] createWallet failed (non-fatal): $e');
      }
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  String _extractErrorMessage(Object e) {
    final raw = e.toString();

    // Named exceptions thrown by api_service.uploadTaskProof
    if (raw.contains('auth_required')) {
      return 'Please login again.';
    }
    if (raw.contains('forbidden_403')) {
      return 'You are not allowed to perform this action. '
          'Please make sure this booking belongs to your account.';
    }
    if (raw.contains('upload_error_500:')) {
      final detail = raw.split('upload_error_500:').last;
      return 'Server error: $detail';
    }
    if (raw.contains('upload_bad_request:')) {
      return raw.split('upload_bad_request:').last;
    }
    if (raw.contains('upload_failed:')) {
      return raw.split('upload_failed:').last;
    }

    // Raw DioException that slipped through
    try {
      // ignore: avoid_dynamic_calls
      final dynamic dioE = e;
      final resp = dioE.response;
      if (resp != null) {
        final body = resp.data;
        if (body is Map) {
          final msg = body['message'] ?? body['error'] ?? body['msg'];
          if (msg != null) return msg.toString();
        }
        return 'Server returned HTTP ${resp.statusCode}';
      }
    } catch (_) {}

    return raw;
  }

  String _formatIsoTime(String raw) {
    try {
      return _toAmPm(DateTime.parse(raw).toLocal());
    } catch (_) {
      return raw;
    }
  }

  String _toAmPm(DateTime dt) {
    final h = dt.hour;
    final displayH = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    final m = dt.minute.toString().padLeft(2, '0');
    return '$displayH:$m ${h >= 12 ? 'PM' : 'AM'}';
  }
}
