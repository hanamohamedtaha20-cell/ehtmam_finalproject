import 'package:ehtemam_final_project/features/booking_user/data/repo/booking_repo_user.dart';
import 'package:ehtemam_final_project/features/booking_user/manager/booking_state_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingCubitUser extends Cubit<BookingStateUser> {
  final BookingRepoUser _repo;

  BookingCubitUser(this._repo) : super(BookingInitial());

  Future<void> loadBookings() async {
    if (isClosed) return;
    emit(BookingLoading());
    try {
      final bookings = await _repo.getBookings();
      if (!isClosed) emit(BookingLoaded(bookings: bookings));
    } catch (e) {
      if (!isClosed) emit(BookingError(e.toString()));
    }
  }

  void selectTab(int index) {
    if (isClosed) return;
    if (state is BookingLoaded) {
      final s = state as BookingLoaded;
      emit(BookingLoaded(bookings: s.bookings, selectedTab: index));
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await _repo.cancelBooking(bookingId);
      await loadBookings();
    } catch (e) {
      if (!isClosed) emit(BookingError(e.toString()));
    }
  }
}