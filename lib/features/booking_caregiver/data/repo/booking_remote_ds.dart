<<<<<<< HEAD
// import '../data/booking_model.dart';
=======
// import '../model/booking_model.dart';
>>>>>>> 823415860e4e0e2ecdcdcb85db67f7d02283a408
//
// abstract class BookingRemoteDataSource {
//   Future<BookingModel> getBookingDetails(String id);
// }
//
// class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
//   final Dio dio;
//
//   BookingRemoteDataSourceImpl(this.dio);
//
//   @override
//   Future<BookingModel> getBookingDetails(String id) async {
//     final res = await dio.get('/booking/$id');
//     return BookingModel.fromJson(res.data);
//   }
// }