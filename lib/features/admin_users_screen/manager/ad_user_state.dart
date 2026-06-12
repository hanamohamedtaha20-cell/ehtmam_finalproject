class AdUsersState {
  final List<Map<String, dynamic>> allUsers;
  final List<Map<String, dynamic>> filteredUsers;
  final String searchText;

  const AdUsersState({
    this.allUsers = const [],
    this.filteredUsers = const [],
    this.searchText = '',
  });

  AdUsersState copyWith({
    List<Map<String, dynamic>>? allUsers,
    List<Map<String, dynamic>>? filteredUsers,
    String? searchText,
  }) {
    return AdUsersState(
      allUsers: allUsers ?? this.allUsers,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      searchText: searchText ?? this.searchText,
    );
  }
}