class BookingModel {
  final String id;
  final String clientName;
  final double earnings;

  BookingModel({
    required this.id,
    required this.clientName,
    required this.earnings,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      clientName: json['client_name'],
      earnings: json['earnings'].toDouble(),
    );
  }
}