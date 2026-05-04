class BookingModel {
  final String title;
  final String subtitle;
  final String date;
  final String time;
  final String location;
  final int price;
  final String status; // upcoming / completed / cancelled

  BookingModel({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
    required this.location,
    required this.price,
    required this.status,
  });
}