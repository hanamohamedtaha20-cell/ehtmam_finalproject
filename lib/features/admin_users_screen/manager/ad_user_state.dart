import '../model/AD_user_model.dart';

class AdUsersState {
  final List<AdUserModel> allUsers;
  final List<AdUserModel> filteredUsers;
  final String searchText;
  final String errorMessage;

  const AdUsersState({
    this.allUsers = const [],
    this.filteredUsers = const [],
    this.searchText = '',
    this.errorMessage = '',
  });

  AdUsersState copyWith({
    List<AdUserModel>? allUsers,
    List<AdUserModel>? filteredUsers,
    String? searchText,
    String? errorMessage,
  }) {
    return AdUsersState(
      allUsers: allUsers ?? this.allUsers,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      searchText: searchText ?? this.searchText,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}