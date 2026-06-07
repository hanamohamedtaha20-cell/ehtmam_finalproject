import '../model/mytask_cg_booking_model.dart';
import '../model/mytask_cg_task_model.dart';

class MytaskCgRepo {
  Future<List<MytaskCgBookingModel>> getBookings() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      MytaskCgBookingModel(
        bookingId: '#BK12346',
        clientName: 'Fatma adel',
        category: 'Pet Care',
        tasks: [
          MytaskCgTaskModel(id: '1', title: 'Feed Max breakfast', assignedTo: 'Fatma', category: 'Pet Care', date: '2026-04-10', mediaProof: ['img1', 'img2'], isDone: true, isAddedByCaregiver: false),
          MytaskCgTaskModel(id: '2', title: 'Give medication at 12 PM', assignedTo: 'Fatma', category: 'Pet Care', date: '2026-04-10', mediaProof: ['img1'], isDone: false, isAddedByCaregiver: false),
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
}