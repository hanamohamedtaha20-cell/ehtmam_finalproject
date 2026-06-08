import 'package:ehtemam_final_project/features/booking_caregiver/manager/state/booking_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/repo.dart';

class BookingDetailsCubit
    extends Cubit<BookingDetailsState> {
  final BookingRepository repository;

  BookingDetailsCubit(this.repository)
      : super(
    BookingDetailsInitial(),
  );

  Future<void> getBookingDetails(
      int bookingId,
      ) async {
    emit(BookingDetailsLoading());

    try {
      final result =
      await repository.getBookingDetails(
        bookingId,
      );

      emit(
        BookingDetailsLoaded(result),
      );
    } catch (e) {
      emit(
        BookingDetailsError(
          e.toString(),
        ),
      );
    }
  }
}