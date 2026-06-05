import '../model/booking_model.dart';

class BookingRepo {
  List<BookingModel> getBookings() {
    return [
      BookingModel(
        title: "Pet Care",
        subtitle: "Paws & Claws",
        date: "March 15, 2026",
        time: "2:00 PM - 4:00 PM",
        location: "123 Main Street",
        price: 2500,
        status: "upcoming",
      ),
      BookingModel(
        title: "Elderly Care",
        subtitle: "Caring Hearts",
        date: "March 20, 2026",
        time: "10:00 AM - 12:00 PM",
        location: "456 Oak Avenue",
        price: 450,
        status: "upcoming",
      ),
      BookingModel(
        title: "Child Care",
        subtitle: "Little Stars",
        date: "March 10, 2026",
        time: "3:00 PM - 5:00 PM",
        location: "789 Pine Road",
        price: 400,
        status: "completed",
      ),
    ];
  }
}