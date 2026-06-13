enum PendingApprovalsStatus {
  initial,
  loading,
  success,
  error,
}

class PendingApprovalsState {
  final PendingApprovalsStatus status;
  final List<Map<String, dynamic>> providers;
  final String errorMessage;

  const PendingApprovalsState({
    this.status = PendingApprovalsStatus.initial,
    this.providers = const [],
    this.errorMessage = '',
  });

  PendingApprovalsState copyWith({
    PendingApprovalsStatus? status,
    List<Map<String, dynamic>>? providers,
    String? errorMessage,
  }) {
    return PendingApprovalsState(
      status: status ?? this.status,
      providers: providers ?? this.providers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}