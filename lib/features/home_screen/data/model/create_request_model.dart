class CreateRequestModel {
  final String description;
  final String duration;
  final String location;
  final String budget;
  final String specialRequirements;
  final String serviceType;

  CreateRequestModel({
    required this.description,
    required this.duration,
    required this.location,
    required this.budget,
    required this.specialRequirements,
    required this.serviceType,
  });

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "duration": duration,
      "location": location,
      "budget": budget,
      "special_requirements": specialRequirements,
      "serviceType": serviceType,
    };
  }
  factory CreateRequestModel.fromJson(Map<String, dynamic> json) {
    return CreateRequestModel(
      description:       json['description']?.toString()        ?? '',
      duration:          json['duration']?.toString()           ?? '',
      location:          json['location']?.toString()           ?? '',
      budget:            json['budget']?.toString()             ?? '',
      specialRequirements: json['special_requirements']?.toString() ?? '',
      serviceType:       json['serviceType']?.toString()        ?? '',
    );
  }
}
