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
    emit(MytaskCgLoading());
    try {
      final bookings = await repo.getBookings();
      emit(MytaskCgLoaded(bookings: bookings));
    } catch (e) {
      emit(MytaskCgError(e.toString()));
    }
  }

  void filterBookings(String filter) {
    final current = state as MytaskCgLoaded;
    emit(MytaskCgLoaded(bookings: current.bookings, filter: filter));
  }

  void checkIn(String bookingId) {
    final current = state as MytaskCgLoaded;
    final now = DateTime.now();
    final time = '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';
    final updated = current.bookings.map((b) {
      if (b.bookingId == bookingId) {
        return b.copyWith(isCheckedIn: true, checkInTime: time);
      }
      return b;
    }).toList();
    emit(MytaskCgLoaded(bookings: updated, filter: current.filter));
  }

  void checkOut(String bookingId) {
  final current = state as MytaskCgLoaded;
  final booking = current.bookings.firstWhere((b) => b.bookingId == bookingId);
  
  final allHaveMedia = booking.tasks.every((t) => t.mediaProof.isNotEmpty);
  if (!allHaveMedia) return; // مش هيعمل checkout
  
  final updated = current.bookings.map((b) {
    if (b.bookingId == bookingId) return b.copyWith(isCheckedOut: true);
    return b;
  }).toList();
  emit(MytaskCgLoaded(bookings: updated, filter: current.filter));
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
  emit(MytaskCgLoaded(bookings: updated, filter: current.filter));
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