// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../data/repo/create_request_repo.dart';
// import 'package:ehtemam_final_project/features/home_screen/manager/state/create_request_state.dart';
//
// class CreateRequestCubit extends Cubit<CreateRequestState> {
//   Future<void> createRequest({
//     required String serviceId,
//     required String governorate,
//     required String date,
//     required String time,
//     String? duration,
//     String? notes,
//     String? budget,
//   }) async {
//     emit(CreateRequestLoading());
//     try {
//       await repository.createRequest(
//         serviceId:   serviceId,
//         governorate: governorate,
//         date:        date,
//         time:        time,
//         duration:    duration,
//         notes:       notes,
//         budget:      budget,
//       );
//       emit(CreateRequestSuccess());
//     } catch (e) {
//       emit(CreateRequestError(e.toString()));
//     }
//   }
//
//   void setTime(TimeOfDay time) {
//   selectedTime = time;
//   isTimeEmpty = false;
//   emit(CreateRequestInitial());
//   }
//
//   final formKey = GlobalKey<FormState>();
//
//   void submitRequest({required String serviceId}) {
//     if (selectedDate == null) {
//       isDateEmpty = true;
//       emit(CreateRequestInitial());
//       return;
//     }
//
//     if (selectedTime == null) {
//       isTimeEmpty = true;
//       emit(CreateRequestInitial());
//       return;
//     }
//
//     if (formKey.currentState!.validate()) {
//       createRequest(
//         serviceId: serviceId,
//         location: locationController.text,
//         date:
//         '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
//         time:
//         '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
//         duration: durationController.text,
//         notes: notesController.text,
//       );
//     }
//
//   }
//
//
//   Future<void> createRequest({
//     required String serviceId,
//     required String location,
//     required String date,
//     required String time,
//     String? duration,
//     String? notes,
//   }) async {
//     emit(CreateRequestLoading());
//
//     try {
//       print("SERVICE ID: $serviceId");
//       print("LOCATION: $location");
//       print("DATE: $date");
//       print("TIME: $time");
//       print("DURATION: $duration");
//       print("NOTES: $notes");
//       await repository.createRequest(
//         serviceId: serviceId,
//         location: location,
//         date: date,
//         time: time,
//         duration: duration,
//         notes: notes,
//       );
//       print("CREATE REQUEST SUCCESS FROM CUBIT");
//       emit(CreateRequestSuccess());
//     } catch (e) {
//       emit(
//         CreateRequestError(
//           e.toString(),
//         ),
//       );
//     }
//   }
// }
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/create_request_repo.dart';
import 'package:ehtemam_final_project/features/home_screen/manager/state/create_request_state.dart';

class CreateRequestCubit extends Cubit<CreateRequestState> {
  final CreateRequestRepository repository;

  CreateRequestCubit(this.repository) : super(CreateRequestInitial());

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedGovernorate;
  bool isDateEmpty = false;
  bool isTimeEmpty = false;
  bool isGovernorateEmpty = false;

  final formKey = GlobalKey<FormState>();
  final durationController = TextEditingController();
  final notesController = TextEditingController();
  final budgetController = TextEditingController();
  final List<String> tasks = [];

  void addTask(String description) {
    final trimmed = description.trim();
    if (trimmed.isEmpty) return;
    tasks.add(trimmed);
    emit(CreateRequestInitial());
  }

  void removeTask(int index) {
    if (index < 0 || index >= tasks.length) return;
    tasks.removeAt(index);
    emit(CreateRequestInitial());
  }

  void setDate(DateTime date) {
    selectedDate = date;
    isDateEmpty = false;
    emit(CreateRequestInitial());
  }

  void setTime(TimeOfDay time) {
    selectedTime = time;
    isTimeEmpty = false;
    emit(CreateRequestInitial());
  }

  void setGovernorate(String governorate) {
    selectedGovernorate = governorate;
    isGovernorateEmpty = false;
    emit(CreateRequestInitial());
  }

  void submitRequest({required String serviceId}) {
    if (selectedDate == null) {
      isDateEmpty = true;
      emit(CreateRequestInitial());
      return;
    }
    if (selectedTime == null) {
      isTimeEmpty = true;
      emit(CreateRequestInitial());
      return;
    }
    if (selectedGovernorate == null) {
      isGovernorateEmpty = true;
      emit(CreateRequestInitial());
      return;
    }
    if (formKey.currentState!.validate()) {
      createRequest(
        serviceId: serviceId,
        governorate: selectedGovernorate!,
        date: '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
        time: '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
        duration: _optionalText(durationController.text),
        notes: _optionalText(notesController.text),
        budget: _optionalText(budgetController.text),
        tasks: List<String>.from(tasks),
      );
    }
  }

  String? _optionalText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<void> createRequest({
    required String serviceId,
    required String governorate,
    required String date,
    required String time,
    String? duration,
    String? notes,
    String? budget,
    List<String> tasks = const [],
  }) async {
    emit(CreateRequestLoading());
    try {
      await repository.createRequest(
        serviceId: serviceId,
        governorate: governorate,
        date: date,
        time: time,
        duration: duration,
        notes: notes,
        budget: budget,
        tasks: tasks,
      );
      emit(CreateRequestSuccess());
    } catch (e) {
      emit(CreateRequestError(_errorMessage(e)));
    }
  }

  String _errorMessage(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      return e.message ?? 'Failed to create request';
    }
    return e.toString();
  }
}