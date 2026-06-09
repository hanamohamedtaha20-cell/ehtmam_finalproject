import '../../data/model/booking_details_model.dart';


abstract class BookingDetailsState {}

class BookingDetailsInitial
    extends BookingDetailsState {}

class BookingDetailsLoading
    extends BookingDetailsState {}

class BookingDetailsLoaded
    extends BookingDetailsState {
  final BookingDetailsModel booking;

  BookingDetailsLoaded(this.booking);
}

class BookingDetailsError
    extends BookingDetailsState {
  final String message;

  BookingDetailsError(this.message);
}