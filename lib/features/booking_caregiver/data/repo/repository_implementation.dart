import 'package:ehtemam_final_project/features/booking_caregiver/data/repo/booking_remote_ds.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/data/repo/repo.dart';
import '../model/booking_details_model.dart';

class BookingRepositoryImpl
    implements BookingRepository {
  final BookingRemoteDatasource datasource;

  BookingRepositoryImpl(this.datasource);

  @override
  Future<BookingDetailsModel> getBookingDetails(
      int bookingId,
      ) {
    return datasource.getBookingDetails(
      bookingId,
    );
  }
}