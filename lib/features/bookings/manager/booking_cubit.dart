import 'package:ehtemam_final_project/features/bookings/data/model/booking_model.dart';
import 'package:ehtemam_final_project/features/bookings/data/repo/booking_repo.dart';
import 'package:ehtemam_final_project/features/bookings/manager/booking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepo _repo;

  BookingCubit(this._repo) : super(BookingInitial());

  void loadBookings() {
    emit(BookingLoaded(bookings: _repo.getBookings()));
  }

  void selectTab(int index) {
    if (state is BookingLoaded) {
      final s = state as BookingLoaded;
      emit(BookingLoaded(bookings: s.bookings, selectedTab: index));
    }
  }
}