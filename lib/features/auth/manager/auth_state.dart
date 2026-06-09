enum AuthStatus {
  initial,
  loading,
  registered,
  authenticated,
  error,
}

class AuthState {
  final AuthStatus status;
  final String selectedRole;
  final String? errorMessage;
  final String? token;
  final String userName;
  final String userRole;

  const AuthState({
    this.status = AuthStatus.initial,
    this.selectedRole = '',
    this.errorMessage,
    this.token,
    this.userName = 'User',
    this.userRole = '',
  });

  AuthState copyWith({
    AuthStatus? status,
    String? selectedRole,
    String? errorMessage,
    String? token,
    String? userName,
    String? userRole,
  }) {
    return AuthState(
      status: status ?? this.status,
      selectedRole: selectedRole ?? this.selectedRole,
      errorMessage: errorMessage,
      token: token ?? this.token,
      userName: userName ?? this.userName,
      userRole: userRole ?? this.userRole,
    );
  }
}