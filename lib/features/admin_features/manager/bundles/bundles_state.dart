enum BundlesStatus {
  initial,
  loading,
  success,
  error,
}

class BundlesState {
  final BundlesStatus status;

  final List<Map<String, dynamic>> bundles;

  final String errorMessage;

  const BundlesState({
    this.status = BundlesStatus.initial,
    this.bundles = const [],
    this.errorMessage = '',
  });

  BundlesState copyWith({
    BundlesStatus? status,
    List<Map<String, dynamic>>? bundles,
    String? errorMessage,
  }) {
    return BundlesState(
      status: status ?? this.status,
      bundles: bundles ?? this.bundles,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}