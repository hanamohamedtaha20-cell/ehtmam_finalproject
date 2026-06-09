// import 'package:ehtemam_final_project/core/network/api_service.dart';
// import '../model/mytask_cg_booking_model.dart';
// import '../model/mytask_cg_task_model.dart';

// class MytaskCgRepo {
//   final ApiService _apiService;

//   MytaskCgRepo(this._apiService);

//   Future<List<MytaskCgBookingModel>> getBookings() async {
//     final response = await _apiService.getMyBookings();
//     final List bookingsData = response['data'] ?? [];

//     return bookingsData.map((b) {
//       final List tasksData = b['tasks'] ?? [];
//       final tasks = tasksData.map((t) => MytaskCgTaskModel(
//         id: t['_id'] ?? '',
//         title: t['taskTitle'] ?? '',
//         assignedTo: b['caregiver']?['full_name'] ?? '',
//         category: b['service']?['serviceName'] ?? '',
//         date: t['createdAt']?.toString().substring(0, 10) ?? '',
//         mediaProof: List<String>.from(t['proofUrl'] != null && t['proofUrl'] != '' ? [t['proofUrl']] : []),
//         isDone: t['taskState'] == 'completed',
//         isAddedByCaregiver: t['addedByCaregiver'] ?? false,
//       )).toList();

//       return MytaskCgBookingModel(
//         bookingId: b['_id'] ?? '',
//         clientName: b['client']?['full_name'] ?? '',
//         category: b['service']?['serviceName'] ?? '',
//         tasks: tasks,
//         isCheckedIn: b['isCheckedIn'] ?? false,
//         isCheckedOut: b['status'] == 'COMPLETED',
//         checkInTime: b['checkInTime'] ?? '',
//       );
//     }).toList();
//   }

//   Future<void> updateTask(String taskId, {String? taskState, String? proofUrl}) async {
//     await _apiService.updateTask(taskId, {
//       if (taskState != null) 'taskState': taskState,
//       if (proofUrl != null) 'proofUrl': proofUrl,
//     });
//   }

//   Future<MytaskCgTaskModel> createTask({required String bookingId, required String title}) async {
//     final response = await _apiService.createTask(description: title);
//     final t = response['data'];
//     return MytaskCgTaskModel(
//       id: t['_id'] ?? '',
//       title: t['taskTitle'] ?? title,
//       assignedTo: 'Me',
//       category: 'General',
//       date: DateTime.now().toString().substring(0, 10),
//       isAddedByCaregiver: true,
//     );
//   }
//   Future<String> uploadProof(String taskId, String filePath) async {
//   final response = await _apiService.uploadTaskProof(taskId, filePath);
//   return response['data']['proofUrl'] ?? '';
// }
// }
import '../model/mytask_cg_booking_model.dart';
import '../model/mytask_cg_task_model.dart';

class MytaskCgRepo {
  MytaskCgRepo();

  Future<List<MytaskCgBookingModel>> getBookings() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      MytaskCgBookingModel(
        bookingId: '#BK12346',
        clientName: 'Fatma adel',
        category: 'Pet Care',
        tasks: [
          MytaskCgTaskModel(id: '1', title: 'Feed Max breakfast', assignedTo: 'Fatma', category: 'Pet Care', date: '2026-04-10', mediaProof: [], isDone: false, isAddedByCaregiver: false),
          MytaskCgTaskModel(id: '2', title: 'Give medication at 12 PM', assignedTo: 'Fatma', category: 'Pet Care', date: '2026-04-10', mediaProof: [], isDone: false, isAddedByCaregiver: false),
          MytaskCgTaskModel(id: '3', title: 'Take Max for a walk', assignedTo: 'Fatma', category: 'Pet Care', date: '2026-04-10', isDone: false, isAddedByCaregiver: false),
        ],
      ),
      MytaskCgBookingModel(
        bookingId: '#BK12345',
        clientName: 'Fatma',
        category: 'Pet Care',
        tasks: [
          MytaskCgTaskModel(id: '4', title: 'Task 1', assignedTo: 'Fatma', category: 'Pet Care', date: '2026-04-10', isDone: true, isAddedByCaregiver: false),
          MytaskCgTaskModel(id: '5', title: 'Task 2', assignedTo: 'Fatma', category: 'Pet Care', date: '2026-04-10', isDone: true, isAddedByCaregiver: false),
          MytaskCgTaskModel(id: '6', title: 'Task 3', assignedTo: 'Fatma', category: 'Pet Care', date: '2026-04-10', isDone: false, isAddedByCaregiver: false),
        ],
        isCheckedIn: true,
        checkInTime: '08:57 PM',
      ),
    ];
  }

  Future<void> updateTask(String taskId, {String? taskState, String? proofUrl}) async {}

  Future<MytaskCgTaskModel> createTask({required String bookingId, required String title}) async {
    return MytaskCgTaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      assignedTo: 'Me',
      category: 'General',
      date: DateTime.now().toString().substring(0, 10),
      isAddedByCaregiver: true,
    );
  }

  Future<String> uploadProof(String taskId, String filePath) async {
    return filePath;
  }
}