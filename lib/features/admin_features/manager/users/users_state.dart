class UsersState {
  final List<Map<String, dynamic>> allUsers;
  final List<Map<String, dynamic>> filteredUsers;
  final String searchText;

  const UsersState({
    this.allUsers = const [],
    this.filteredUsers = const [],
    this.searchText = '',
  });

  UsersState copyWith({
    List<Map<String, dynamic>>? allUsers,
    List<Map<String, dynamic>>? filteredUsers,
    String? searchText,
  }) {
    return UsersState(
      allUsers: allUsers ?? this.allUsers,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      searchText: searchText ?? this.searchText,
    );
  }
}