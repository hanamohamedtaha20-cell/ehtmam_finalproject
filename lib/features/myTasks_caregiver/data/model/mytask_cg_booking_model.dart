import 'mytask_cg_task_model.dart';

class MytaskCgBookingModel {
  final String bookingId;
  final String clientName;
  final String category;
  final List<MytaskCgTaskModel> tasks;
  final bool isCheckedIn;
  final bool isCheckedOut;
  final String? checkInTime;

  MytaskCgBookingModel({
    required this.bookingId,
    required this.clientName,
    required this.category,
    required this.tasks,
    this.isCheckedIn = false,
    this.isCheckedOut = false,
    this.checkInTime,
  });

  int get completedTasks => tasks.where((t) => t.isDone).length;
  int get totalTasks => tasks.length;

  /// True only when every task has at least one proof file uploaded.
  bool get allTasksHaveProof =>
      tasks.isNotEmpty && tasks.every((t) => t.mediaProof.isNotEmpty);

  MytaskCgBookingModel copyWith({
    String? bookingId,
    String? clientName,
    String? category,
    List<MytaskCgTaskModel>? tasks,
    bool? isCheckedIn,
    bool? isCheckedOut,
    String? checkInTime,
  }) {
    return MytaskCgBookingModel(
      bookingId:   bookingId   ?? this.bookingId,
      clientName:  clientName  ?? this.clientName,
      category:    category    ?? this.category,
      tasks:       tasks       ?? this.tasks,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      isCheckedOut: isCheckedOut ?? this.isCheckedOut,
      checkInTime: checkInTime ?? this.checkInTime,
    );
  }
}
