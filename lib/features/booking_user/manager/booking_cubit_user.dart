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
    if (state is! BookingLoaded) return;
    final s = state as BookingLoaded;
    try {
      await _repo.cancelBooking(bookingId);
      // Backend deletes the record, so do NOT reload — keep it locally as
      // cancelled and switch to the Cancelled tab so the user sees it.
      final updated = s.bookings
          .map((b) => b.id == bookingId ? b.copyWith(status: 'cancelled') : b)
          .toList();
      if (!isClosed) emit(BookingLoaded(bookings: updated, selectedTab: 2));
    } catch (e) {
      if (!isClosed) emit(BookingError(e.toString()));
    }
  }
}