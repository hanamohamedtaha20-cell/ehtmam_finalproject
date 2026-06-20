class AccountSettingsState {
  final String name;
  final String email;
  final String phone;
  final String role;

  final String government;
  final String careField;
  final String specialization;
  final String certificateFileName;

  final bool notifications;
  final bool isLoading;
  final String? message;
  final String? error;
  final bool success;
  final String profileImagePath;
  final String profileImageUrl;

  const AccountSettingsState({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.role = '',

    this.government = '',
    this.careField = '',
    this.specialization = '',
    this.certificateFileName = '',

    this.notifications = false,
    this.isLoading = false,
    this.message,
    this.error,
    this.success = false,
    required this.profileImagePath,
    this.profileImageUrl = '',
  });

  AccountSettingsState copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,

    String? government,
    String? careField,
    String? specialization,
    String? certificateFileName,

    bool? notifications,
    bool? isLoading,
    String? message,
    String? error,
    bool? success,
    String? profileImagePath,
    String? profileImageUrl,
  }) {
    return AccountSettingsState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,

      government: government ?? this.government,
      careField: careField ?? this.careField,
      specialization: specialization ?? this.specialization,
      certificateFileName: certificateFileName ?? this.certificateFileName,

      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      message: message,
      error: error,
      success: success ?? false,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}