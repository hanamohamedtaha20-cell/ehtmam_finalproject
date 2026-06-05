// import '../data/booking_model.dart';
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