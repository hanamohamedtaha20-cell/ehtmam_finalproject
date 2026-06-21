import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/complaint_model.dart';

class ComplaintRepository {
  final ApiService _api;

  ComplaintRepository([ApiService? api]) : _api = api ?? ApiService();

  Future<ComplaintResponse> submitComplaint(ComplaintRequest request) async {
    final response = await _api.submitComplaint(
      bookingId:         request.bookingId,
      subject:           request.subject,
      message:           request.message,
      complaintCategory: request.complaintCategory,
    );
    return ComplaintResponse.fromJson(
      Map<String, dynamic>.from(response),
    );
  }
}
