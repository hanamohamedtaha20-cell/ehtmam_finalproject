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
      id:          json['_id']?.toString()            ?? '',
      title:       json['taskTitle']?.toString()       ?? '',
      description: json['taskDescription']?.toString() ?? '',
      state:       json['taskState']?.toString()       ?? 'pending',
      proofUrl:    json['proofUrl']?.toString()        ?? '',
      proofType:   json['proofType']?.toString()       ?? 'image',
    );
  }

  bool get isCompleted  => state == 'completed';
  bool get isInProgress => state == 'in-progress';
  bool get isPending    => state == 'pending';
}