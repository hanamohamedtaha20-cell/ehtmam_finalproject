
import '../../data/complaint_model.dart';

enum ComplaintsStatus {
  initial,
  loading,
  success,
  error,
}

class ComplaintsState {
  final ComplaintsStatus status;
  final List<ComplaintModel> complaints;
  final String errorMessage;

  const ComplaintsState({
    this.status = ComplaintsStatus.initial,
    this.complaints = const [],
    this.errorMessage = '',
  });

  ComplaintsState copyWith({
    ComplaintsStatus? status,
    List<ComplaintModel>? complaints,
    String? errorMessage,
  }) {
    return ComplaintsState(
      status: status ?? this.status,
      complaints: complaints ?? this.complaints,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}