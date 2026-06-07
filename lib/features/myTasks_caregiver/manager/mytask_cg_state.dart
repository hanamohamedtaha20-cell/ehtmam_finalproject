import '../data/model/mytask_cg_booking_model.dart';
import '../data/model/mytask_cg_task_model.dart';

abstract class MytaskCgState {}

class MytaskCgInitial extends MytaskCgState {}

class MytaskCgLoading extends MytaskCgState {}

class MytaskCgLoaded extends MytaskCgState {
  final List<MytaskCgBookingModel> bookings;
  final String filter;

  MytaskCgLoaded({required this.bookings, this.filter = 'all'});

  List<MytaskCgTaskModel> get allTasks =>
      bookings.expand((b) => b.tasks).toList();

  List<MytaskCgTaskModel> get pendingTasks =>
      allTasks.where((t) => !t.isDone).toList();

  List<MytaskCgTaskModel> get doneTasks =>
      allTasks.where((t) => t.isDone).toList();

  List<MytaskCgTaskModel> get filteredTasks {
    if (filter == 'pending') return pendingTasks;
    if (filter == 'done') return doneTasks;
    return allTasks;
  }

  int get pendingCount => pendingTasks.length;
  int get completedCount => doneTasks.length;

  MytaskCgBookingModel? getBookingForTask(String taskId) {
    try {
      return bookings.firstWhere((b) => b.tasks.any((t) => t.id == taskId));
    } catch (_) {
      return null;
    }
  }
}

class MytaskCgError extends MytaskCgState {
  final String message;
  MytaskCgError(this.message);
}