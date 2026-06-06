class TaskProgressModel {
  final String id;
  final String title;
  final String description;
  final String state;
  final String proofUrl;
  final String proofType;

  TaskProgressModel({
    required this.id,
    required this.title,
    required this.description,
    required this.state,
    required this.proofUrl,
    required this.proofType,
  });

  factory TaskProgressModel.fromJson(Map<String, dynamic> json) {
    return TaskProgressModel(
      id:          json['_id']             ?? '',
      title:       json['taskTitle']        ?? '',
      description: json['taskDescription'] ?? '',
      state:       json['taskState']        ?? 'pending',
      proofUrl:    json['proofUrl']         ?? '',
      proofType:   json['proofType']        ?? 'image',
    );
  }

  bool get isCompleted  => state == 'completed';
  bool get isInProgress => state == 'in-progress';
  bool get isPending    => state == 'pending';
}