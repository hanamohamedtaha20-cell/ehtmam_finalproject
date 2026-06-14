enum PendingDocumentsStatus {
  initial,
  loading,
  success,
  error,
}

class PendingDocumentsState {
  final PendingDocumentsStatus status;

  final String? profileImage;
  final String? nationalId;
  final String? certificate;

  final String errorMessage;

  const PendingDocumentsState({
    this.status = PendingDocumentsStatus.initial,
    this.profileImage,
    this.nationalId,
    this.certificate,
    this.errorMessage = '',
  });

  PendingDocumentsState copyWith({
    PendingDocumentsStatus? status,
    String? profileImage,
    String? nationalId,
    String? certificate,
    String? errorMessage,
  }) {
    return PendingDocumentsState(
      status: status ?? this.status,
      profileImage: profileImage ?? this.profileImage,
      nationalId: nationalId ?? this.nationalId,
      certificate: certificate ?? this.certificate,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}