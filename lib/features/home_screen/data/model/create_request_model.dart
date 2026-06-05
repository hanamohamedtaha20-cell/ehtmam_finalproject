class CreateRequestModel {
  final String description;
  final String duration;
  final String location;
  final String budget;
  final String specialRequirements;

  CreateRequestModel({
    required this.description,
    required this.duration,
    required this.location,
    required this.budget,
    required this.specialRequirements,
  });

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "duration": duration,
      "location": location,
      "budget": budget,
      "special_requirements": specialRequirements,
    };
  }
  factory CreateRequestModel.fromJson(
      Map<String, dynamic> json) {
    return CreateRequestModel(
      description: json['description'],
      duration: json['duration'],
      location: json['location'],
      budget: json['budget'].toString(),
      specialRequirements:
      json['special_requirements'],
    );
  }
}
