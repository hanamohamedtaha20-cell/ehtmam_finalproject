class CareRequestModel {
  final String id;
  final String status;
  final String location;
  final String notes;

  CareRequestModel({
    required this.id,
    required this.status,
    required this.location,
    required this.notes,
  });

  factory CareRequestModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CareRequestModel(
      id: json['_id'] ?? '',
      status: json['status'] ?? '',
      location: json['location'] ?? '',
      notes: json['notes'] ?? '',
    );
  }
}