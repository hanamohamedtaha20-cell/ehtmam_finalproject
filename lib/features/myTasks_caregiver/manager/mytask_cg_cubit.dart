import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model/mytask_cg_booking_model.dart';
import '../data/model/mytask_cg_task_model.dart';
import '../data/repo/mytask_cg_repo.dart';
import 'mytask_cg_state.dart';
import 'package:image_picker/image_picker.dart';

class MytaskCgCubit extends Cubit<MytaskCgState> {
  final MytaskCgRepo repo;
  final ImagePicker _picker = ImagePicker();

  MytaskCgCubit(this.repo) : super(MytaskCgInitial());

  Future<void> loadBookings() async {
    if (isClosed) return;
    emit(MytaskCgLoading());
    try {
      final bookings = await repo.getBookings();
      if (!isClosed) {
        emit(MytaskCgLoaded(bookings: bookings));
      }
    } catch (e) {
      if (!isClosed) {
        emit(MytaskCgError(e.toString()));
      }
    }
  }

  void filterBookings(String filter) {
    final current = state as MytaskCgLoaded;
    emit(MytaskCgLoaded(bookings: current.bookings, filter: filter));
  }

  Future<void> checkIn(String bookingId) async {
    final current = state;
    if (current is! MytaskCgLoaded) return;

    try {
      await ApiService().checkInBooking(bookingId);
    } catch (_) {
      // Continue with local check-in even if backend call fails.
    }

    final now = DateTime.now();
    final hour = now.hour;
    final time =
        '${(hour > 12 ? hour - 12 : hour == 0 ? 12 : hour)}:${now.minute.toString().padLeft(2, '0')} ${hour >= 12 ? 'PM' : 'AM'}';

    final updated = current.bookings.map((b) {
      if (b.bookingId == bookingId) {
        return b.copyWith(isCheckedIn: true, checkInTime: time);
      }
      return b;
    }).toList();

    if (!isClosed) emit(MytaskCgLoaded(bookings: updated, filter: current.filter));
  }

  Future<bool> checkOut(String bookingId) async {
    final current = state;
    if (current is! MytaskCgLoaded) return false;

    final booking = current.bookings.firstWhere((b) => b.bookingId == bookingId);
    final allHaveMedia = booking.tasks.every((t) => t.mediaProof.isNotEmpty);
    if (!allHaveMedia) return false;

    try {
      await ApiService().checkOutBooking(bookingId);
    } catch (_) {
      // Continue with local checkout even if backend call fails.
    }

    final updated = current.bookings.map((b) {
      if (b.bookingId == bookingId) return b.copyWith(isCheckedOut: true);
      return b;
    }).toList();

    if (!isClosed) emit(MytaskCgLoaded(bookings: updated, filter: current.filter));
    return true;
  }

  void addTask(String bookingId, MytaskCgTaskModel newTask) {
  print('adding task: ${newTask.title} with media: ${newTask.mediaProof}'); // ✅
  final current = state as MytaskCgLoaded;
  final updated = current.bookings.map((b) {
    if (b.bookingId == bookingId) {
      return b.copyWith(tasks: [...b.tasks, newTask]);
    }
    return b;
  }).toList();
  emit(MytaskCgLoaded(bookings: updated, filter: current.filter));
}
  Future<void> addMediaToTask(String bookingId, String taskId) async {
  final List<XFile> files = await _picker.pickMultipleMedia();
  if (files.isEmpty) return;

  final current = state as MytaskCgLoaded;
  final updated = current.bookings.map((b) {
    if (b.bookingId == bookingId) {
      final updatedTasks = b.tasks.map((t) {
        if (t.id == taskId) {
          return t.copyWith(
            mediaProof: [...t.mediaProof, ...files.map((f) => f.path)],
          );
        }
        return t;
      }).toList();
      return b.copyWith(tasks: updatedTasks);
    }
    return b;
  }).toList();
  if (!isClosed) {
    emit(MytaskCgLoaded(bookings: updated, filter: current.filter));
  }
}
void toggleTaskDone(String bookingId, String taskId) {
  final current = state as MytaskCgLoaded;
  final updated = current.bookings.map((b) {
    if (b.bookingId == bookingId) {
      final updatedTasks = b.tasks.map((t) {
        if (t.id == taskId) {
          if (t.mediaProof.isEmpty) return t;
          return t.copyWith(isDone: !t.isDone);
        }
        return t;
      }).toList();
      return b.copyWith(tasks: updatedTasks);
    }
    return b;
  }).toList();
  emit(MytaskCgLoaded(bookings: updated, filter: current.filter));
}
void deleteTask(String bookingId, String taskId) {
  final current = state as MytaskCgLoaded;
  final updated = current.bookings.map((b) {
    if (b.bookingId == bookingId) {
      final updatedTasks = b.tasks
          .where((t) => !(t.id == taskId && t.isAddedByCaregiver))
          .toList();
      return b.copyWith(tasks: updatedTasks);
    }
    return b;
  }).toList();
  emit(MytaskCgLoaded(bookings: updated, filter: current.filter));
}
}
