class ComplaintModel {
  final String id;
  final String title;
  final String category;
  final String status;
  final String fromName;
  final String fromRole;
  final String againstName;
  final String againstRole;
  final String date;
  final String description;

  ComplaintModel({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.fromName,
    required this.fromRole,
    required this.againstName,
    required this.againstRole,
    required this.date,
    required this.description,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? '',
      fromName: json['fromName'] ?? '',
      fromRole: json['fromRole'] ?? '',
      againstName: json['againstName'] ?? '',
      againstRole: json['againstRole'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
    );
  }
}