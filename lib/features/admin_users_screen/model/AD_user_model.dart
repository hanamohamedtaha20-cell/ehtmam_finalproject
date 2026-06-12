class AdUserModel {
  final int id;
  final String name;
  final String email;
  final int bookings;
  final String joinedDate;
  final bool isActive;
  final bool isPremium;

  AdUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.bookings,
    required this.joinedDate,
    required this.isActive,
    required this.isPremium,
  });

  factory AdUserModel.fromJson(Map<String, dynamic> json) {
    return AdUserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      bookings: json['bookings'],
      joinedDate: json['joined_date'],
      isActive: json['is_active'],
      isPremium: json['is_premium'],
    );
  }
}