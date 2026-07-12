import 'package:ehtemam_final_project/core/utils/api_error_message.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/manager/state/booking_details_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model/booking_details_model.dart';
import '../data/repo/repo.dart';

class BookingDetailsCubit extends Cubit<BookingDetailsState> {
  final BookingRepository repository;

  BookingDetailsCubit(this.repository) : super(BookingDetailsInitial());

  Future<void> loadRequestDetails(String requestId) async {
    if (isClosed) return;
    emit(BookingDetailsLoading());

    try {
      var result = await repository.getRequestDetails(requestId);
      try {
        final tasks = await repository.getTasks(requestId);
        result = result.copyWith(tasks: tasks);
      } catch (_) {}
      if (!isClosed) {
        emit(BookingDetailsLoaded(result));
      }
    } catch (e) {
      if (!isClosed) {
        emit(BookingDetailsError(e.toString()));
      }
    }
  }

  Future<void> loadBookingDetails(String bookingId) async {
    if (isClosed) return;
    emit(BookingDetailsLoading());

    try {
      var result = await repository.getBookingDetails(bookingId);
      // ── LAYER 4 TRACE ──────────────────────────────────────────────────────
      debugPrint('[Cubit][L4] getBookingDetails returned:');
      debugPrint('[Cubit][L4]   clientName  = "${result.clientName}"');
      debugPrint('[Cubit][L4]   phone       = "${result.phone}"');
      debugPrint('[Cubit][L4]   email       = "${result.email}"');
      debugPrint('[Cubit][L4]   clientBudget    = ${result.clientBudget}');
      debugPrint('[Cubit][L4]   caregiverBudget = ${result.caregiverBudget}');
      debugPrint('[Cubit][L4]   description = "${result.description}"');
      // ───────────────────────────────────────────────────────────────────────
      try {
        final tasks = await repository.getTasksByBookingId(bookingId);
        result = result.copyWith(tasks: tasks);
      } catch (_) {}
      if (!isClosed) {
        emit(BookingDetailsLoaded(result));
      }
    } catch (e) {
      debugPrint('[Cubit][L4] ERROR in loadBookingDetails: $e');
      if (!isClosed) {
        emit(BookingDetailsError(e.toString()));
      }
    }
  }

  Future<void> loadTasks(String requestId) async {
    final current = state;
    if (current is! BookingDetailsLoaded) return;

    try {
      final tasks = await repository.getTasks(requestId);
      if (!isClosed) {
        emit(BookingDetailsLoaded(current.booking.copyWith(tasks: tasks)));
      }
    } catch (e) {
      if (!isClosed) {
        emit(BookingDetailsError(e.toString()));
      }
    }
  }

  Future<void> loadTasksByBookingId(String bookingId) async {
    final current = state;
    if (current is! BookingDetailsLoaded) return;

    try {
      final tasks = await repository.getTasksByBookingId(bookingId);
      if (!isClosed) {
        emit(BookingDetailsLoaded(current.booking.copyWith(tasks: tasks)));
      }
    } catch (e) {
      if (!isClosed) {
        emit(BookingDetailsError(e.toString()));
      }
    }
  }

  Future<void> toggleTask(String taskId, bool done) async {
    final current = state;
    if (current is! BookingDetailsLoaded) return;

    try {
      await repository.updateTask(taskId, done);
      final updatedTasks = current.booking.tasks.map((t) {
        if (t.id == taskId) {
          return TaskModel(id: t.id, title: t.title, done: done);
        }
        return t;
      }).toList();
      if (!isClosed) {
        emit(BookingDetailsLoaded(
          current.booking.copyWith(tasks: updatedTasks),
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(BookingDetailsError(e.toString()));
      }
    }
  }

  Future<String?> submitOffer({
    required String requestId,
    required num price,
    String? notes,
  }) async {
    try {
      await repository.sendOffer(
        requestId: requestId,
        price: price,
        notes: notes,
      );
      return null;
    } catch (e) {
      return apiErrorMessage(e);
    }
  }
}
