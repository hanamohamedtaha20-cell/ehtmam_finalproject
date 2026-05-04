import 'package:ehtemam_final_project/features/bookings/data/model/booking_model.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoaded extends BookingState {
  final List<BookingModel> bookings;
  final int selectedTab; // 0=Upcoming, 1=Completed, 2=Cancelled

  BookingLoaded({required this.bookings, this.selectedTab = 0});

  List<BookingModel> get filtered {
    switch (selectedTab) {
      case 0: return bookings.where((b) => b.status == 'upcoming').toList();
      case 1: return bookings.where((b) => b.status == 'completed').toList();
      case 2: return bookings.where((b) => b.status == 'cancelled').toList();
      default: return bookings;
    }
  }
}