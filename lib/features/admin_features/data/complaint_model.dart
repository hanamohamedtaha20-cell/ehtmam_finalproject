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
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      fromName: json['fromName']?.toString() ?? '',
      fromRole: json['fromRole']?.toString() ?? '',
      againstName: json['againstName']?.toString() ?? '',
      againstRole: json['againstRole']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}