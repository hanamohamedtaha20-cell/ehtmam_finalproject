import '../data/model/booking_model_user.dart';

abstract class BookingStateUser {}

class BookingInitial extends BookingStateUser {}

class BookingLoading extends BookingStateUser {}

class BookingLoaded extends BookingStateUser {
  final List<BookingModelUser> bookings;
  final int selectedTab;

  BookingLoaded({required this.bookings, this.selectedTab = 0});

  List<BookingModelUser> get filtered {
    switch (selectedTab) {
      case 0: return bookings.where((b) => b.status == 'upcoming').toList();
      case 1: return bookings.where((b) => b.status == 'completed').toList();
      case 2: return bookings.where((b) => b.status == 'cancelled').toList();
      default: return bookings;
    }
  }
}

class BookingError extends BookingStateUser {
  final String message;
  BookingError(this.message);
}