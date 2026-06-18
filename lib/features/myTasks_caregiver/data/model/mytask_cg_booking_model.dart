import 'mytask_cg_task_model.dart';

class MytaskCgBookingModel {
  final String bookingId;
  final String clientName;
  final String category;
  final List<MytaskCgTaskModel> tasks;
  final bool isCheckedIn;
  final bool isCheckedOut;
  final String? checkInTime;

  /// Agreed price from the caregiver's offer (offer.price).
  /// Used to show the amount in the checkout success message and to
  /// trigger wallet credit via POST /booking/process-payment/{offerId}.
  final double bookingAmount;

  /// MongoDB _id of the offer document. Needed for process-payment API.
  final String offerId;

  MytaskCgBookingModel({
    required this.bookingId,
    required this.clientName,
    required this.category,
    required this.tasks,
    this.isCheckedIn = false,
    this.isCheckedOut = false,
    this.checkInTime,
    this.bookingAmount = 0,
    this.offerId = '',
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
    double? bookingAmount,
    String? offerId,
  }) {
    return MytaskCgBookingModel(
      bookingId:     bookingId     ?? this.bookingId,
      clientName:    clientName    ?? this.clientName,
      category:      category      ?? this.category,
      tasks:         tasks         ?? this.tasks,
      isCheckedIn:   isCheckedIn   ?? this.isCheckedIn,
      isCheckedOut:  isCheckedOut  ?? this.isCheckedOut,
      checkInTime:   checkInTime   ?? this.checkInTime,
      bookingAmount: bookingAmount ?? this.bookingAmount,
      offerId:       offerId       ?? this.offerId,
    );
  }
}
