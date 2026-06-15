import 'package:ehtemam_final_project/features/request_screen_caregiver/data/model/care_request.dart';

class HcState {
  final bool isLoading;
  final String? errorMessage;
  final String userName;
  final bool isAvailable;
  final int requestsToday;
  final int earningsThisWeek;
  final double rating;
  final String activeHours;
  final List<CareRequestModel> pendingRequests;
  final List<CareRequestModel> acceptedBookings;

  const HcState({
    this.isLoading = true,
    this.errorMessage,
    this.userName = 'Caregiver',
    this.isAvailable = true,
    this.requestsToday = 0,
    this.earningsThisWeek = 0,
    this.rating = 4.9,
    this.activeHours = '0h',
    this.pendingRequests = const [],
    this.acceptedBookings = const [],
  });

  int get pendingCount => pendingRequests.length;

  String get businessTitle => "$userName's Care Services";

  HcState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? userName,
    bool? isAvailable,
    int? requestsToday,
    int? earningsThisWeek,
    double? rating,
    String? activeHours,
    List<CareRequestModel>? pendingRequests,
    List<CareRequestModel>? acceptedBookings,
  }) {
    return HcState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      userName: userName ?? this.userName,
      isAvailable: isAvailable ?? this.isAvailable,
      requestsToday: requestsToday ?? this.requestsToday,
      earningsThisWeek: earningsThisWeek ?? this.earningsThisWeek,
      rating: rating ?? this.rating,
      activeHours: activeHours ?? this.activeHours,
      pendingRequests: pendingRequests ?? this.pendingRequests,
      acceptedBookings: acceptedBookings ?? this.acceptedBookings,
    );
  }
}
