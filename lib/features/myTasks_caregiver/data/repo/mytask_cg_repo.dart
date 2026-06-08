import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/mytask_cg_booking_model.dart';
import '../model/mytask_cg_task_model.dart';

class MytaskCgRepo {
  final ApiService _apiService;

  MytaskCgRepo(this._apiService);

  Future<List<MytaskCgBookingModel>> getBookings() async {
    final response = await _apiService.getMyBookings();
    final List bookingsData = response['data'] ?? [];

    return bookingsData.map((b) {
      final List tasksData = b['tasks'] ?? [];
      final tasks = tasksData.map((t) => MytaskCgTaskModel(
        id: t['_id'] ?? '',
        title: t['taskTitle'] ?? '',
        assignedTo: b['caregiver']?['full_name'] ?? '',
        category: b['service']?['serviceName'] ?? '',
        date: t['createdAt']?.toString().substring(0, 10) ?? '',
        mediaProof: List<String>.from(t['proofUrl'] != null && t['proofUrl'] != '' ? [t['proofUrl']] : []),
        isDone: t['taskState'] == 'completed',
        isAddedByCaregiver: t['addedByCaregiver'] ?? false,
      )).toList();

      return MytaskCgBookingModel(
        bookingId: b['_id'] ?? '',
        clientName: b['client']?['full_name'] ?? '',
        category: b['service']?['serviceName'] ?? '',
        tasks: tasks,
        isCheckedIn: b['isCheckedIn'] ?? false,
        isCheckedOut: b['status'] == 'COMPLETED',
        checkInTime: b['checkInTime'] ?? '',
      );
    }).toList();
  }

  Future<void> updateTask(String taskId, {String? taskState, String? proofUrl}) async {
    await _apiService.updateTask(taskId, {
      if (taskState != null) 'taskState': taskState,
      if (proofUrl != null) 'proofUrl': proofUrl,
    });
  }

  Future<MytaskCgTaskModel> createTask({required String bookingId, required String title}) async {
    final response = await _apiService.createTask(description: title);
    final t = response['data'];
    return MytaskCgTaskModel(
      id: t['_id'] ?? '',
      title: t['taskTitle'] ?? title,
      assignedTo: 'Me',
      category: 'General',
      date: DateTime.now().toString().substring(0, 10),
      isAddedByCaregiver: true,
    );
  }
  Future<String> uploadProof(String taskId, String filePath) async {
  final response = await _apiService.uploadTaskProof(taskId, filePath);
  return response['data']['proofUrl'] ?? '';
}
}