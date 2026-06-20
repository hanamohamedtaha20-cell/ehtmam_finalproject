import '../../data/complaint_model.dart';
import '../../data/complaint_details_model.dart';

enum ComplaintsStatus { initial, loading, success, error }

enum DetailsStatus { idle, loading, loaded, error }

class ComplaintsState {
  final ComplaintsStatus status;
  final List<ComplaintModel> complaints;
  final String errorMessage;

  final DetailsStatus detailsStatus;
  final ComplaintDetailsModel? details;
  final String detailsErrorMessage;

  const ComplaintsState({
    this.status = ComplaintsStatus.initial,
    this.complaints = const [],
    this.errorMessage = '',
    this.detailsStatus = DetailsStatus.idle,
    this.details,
    this.detailsErrorMessage = '',
  });

  ComplaintsState copyWith({
    ComplaintsStatus? status,
    List<ComplaintModel>? complaints,
    String? errorMessage,
    DetailsStatus? detailsStatus,
    ComplaintDetailsModel? details,
    String? detailsErrorMessage,
  }) {
    return ComplaintsState(
      status: status ?? this.status,
      complaints: complaints ?? this.complaints,
      errorMessage: errorMessage ?? this.errorMessage,
      detailsStatus: detailsStatus ?? this.detailsStatus,
      details: details ?? this.details,
      detailsErrorMessage: detailsErrorMessage ?? this.detailsErrorMessage,
    );
  }
}
