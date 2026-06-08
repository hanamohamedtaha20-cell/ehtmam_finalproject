class CareRequestStatsModel {
  final int pending;
  final int active;
  final int completed;

  CareRequestStatsModel({
    required this.pending,
    required this.active,
    required this.completed,
  });

  factory CareRequestStatsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CareRequestStatsModel(
      pending: json['pending'],
      active: json['active'],
      completed: json['completed'],
    );
  }
}