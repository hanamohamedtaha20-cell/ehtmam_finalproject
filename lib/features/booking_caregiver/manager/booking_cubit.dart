// import 'package:ehtemam_final_project/features/booking_caregiver/manager/state/booking_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../data/repo/booking_repo.dart';
//
// class BookingCubit extends Cubit<BookingState> {
//   final BookingRepo repo;
//
//   BookingCubit(this.repo) : super(BookingInitial());
//
//   Future<void> getBooking(String id) async {
//     emit(BookingLoading());
//
//     try {
//       final data = await repo.getBookingDetails(id);
//       emit(BookingLoaded(data));
//     } catch (e) {
//       emit(BookingError(e.toString()));
//     }
//   }
// }