class BookingDetailsModel {
  final String clientName;
  final String phone;
  final String email;
  final double rating;

  final String serviceType;
  final String petType;
  final String duration;

  final String date;
  final String time;
  final String location;

  final String specialInstructions;

  final double clientBudget;

  final List<TaskModel> tasks;

  BookingDetailsModel({
    required this.clientName,
    required this.phone,
    required this.email,
    required this.rating,
    required this.serviceType,
    required this.petType,
    required this.duration,
    required this.date,
    required this.time,
    required this.location,
    required this.specialInstructions,
    required this.clientBudget,
    required this.tasks,
  });

  factory BookingDetailsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return BookingDetailsModel(
      clientName: json['client_name'],
      phone: json['phone'],
      email: json['email'],
      rating: json['rating'].toDouble(),
      serviceType: json['service_type'],
      petType: json['pet_type'],
      duration: json['duration'],
      date: json['date'],
      time: json['time'],
      location: json['location'],
      specialInstructions:
      json['special_instructions'],
      clientBudget:
      json['client_budget'].toDouble(),
      tasks: (json['tasks'] as List)
          .map((e) => TaskModel.fromJson(e))
          .toList(),
    );
  }
}
class TaskModel {
  final String title;
  final bool done;

  TaskModel({
    required this.title,
    required this.done,
  });

  factory TaskModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return TaskModel(
      title: json['title'],
      done: json['done'],
    );
  }
}