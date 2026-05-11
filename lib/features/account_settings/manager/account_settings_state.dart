class AccountSettingsState {
  final String name;
  final String email;
  final String phone;
  final String role;
  final bool notifications;
  final bool isLoading;
  final String? message;
  final String? error;
  final bool success;
  final String profileImagePath;


  const AccountSettingsState({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.role = '',
    this.notifications = false,
    this.isLoading = false,
    this.message, this.error, this.success = false, required this.profileImagePath,
  });

  AccountSettingsState copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,
    bool? notifications,
    bool? isLoading,
    String? message,
    String? error,
    bool? success,
    String? profileImagePath,

  }) {
    return AccountSettingsState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      message: message,
      error: error,
      success: success ?? false,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }}