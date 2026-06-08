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

  const AuthState({
    this.status = AuthStatus.initial,
    this.selectedRole = '',
    this.errorMessage,
    this.token,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? selectedRole,
    String? errorMessage,
    String? token,
  }) {
    return AuthState(
      status: status ?? this.status,
      selectedRole: selectedRole ?? this.selectedRole,
      errorMessage: errorMessage,
      token: token ?? this.token,
    );
  }
}