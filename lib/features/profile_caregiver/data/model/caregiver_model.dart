class CaregiverModel {
  final String name;
  final String specialty;
  final String phone;
  final String email;
  final String location;
  final double rating;
  final int reviews;
  final int totalRequests;
  final double totalEarnings;
  final double completionRate;
  final String avgResponse;

  CaregiverModel({
    required this.name,
    required this.specialty,
    required this.phone,
    required this.email,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.totalRequests,
    required this.totalEarnings,
    required this.completionRate,
    required this.avgResponse,
  });
}