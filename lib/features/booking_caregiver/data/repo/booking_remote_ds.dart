import 'package:dio/dio.dart';
import '../model/booking_details_model.dart';

abstract class BookingRemoteDatasource {
  Future<BookingDetailsModel> getBookingDetails(
      int bookingId,
      );
}

class BookingRemoteDataSourceImpl
    implements BookingRemoteDatasource {
  final Dio dio;

  BookingRemoteDataSourceImpl(this.dio);

  @override
  Future<BookingDetailsModel> getBookingDetails(
      int bookingId,
      ) async {
    final res = await dio.get(
      '/booking/$bookingId',
    );

    return BookingDetailsModel.fromJson(
      res.data,
    );
  }
}