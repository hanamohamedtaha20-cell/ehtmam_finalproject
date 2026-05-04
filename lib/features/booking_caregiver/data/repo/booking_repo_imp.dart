// import 'booking_remote_ds.dart';
// import 'booking_repo.dart';
//
// class BookingRepoImpl implements BookingRepo {
//   final BookingRemoteDataSource remote;
//
//   BookingRepoImpl(this.remote);
//
//   @override
//   Future<BookingEntity> getBookingDetails(String id) async {
//     final data = await remote.getBookingDetails(id);
//     return BookingEntity(
//       id: data.id,
//       clientName: data.clientName,
//       earnings: data.earnings,
//     );
//   }
// }