class ServiceModel {
  final String id;
  final String name;
  final String description;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id']?.toString() ?? '',
      name: json['serviceName']?.toString() ?? '',
      description: json['serviceDescription']?.toString() ?? '',
    );
  }
}