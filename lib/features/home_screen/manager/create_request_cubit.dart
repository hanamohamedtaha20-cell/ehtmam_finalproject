import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/create_request_repo.dart';
import 'package:ehtemam_final_project/features/home_screen/manager/state/create_request_state.dart';

class CreateRequestCubit extends Cubit<CreateRequestState> {
  final CreateRequestRepository repository;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isDateEmpty = false;
  bool isTimeEmpty = false;
  final durationController = TextEditingController();
  final locationController = TextEditingController();
  final notesController = TextEditingController();

  CreateRequestCubit(this.repository) : super(CreateRequestInitial());

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

  final formKey = GlobalKey<FormState>();

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

    if (formKey.currentState!.validate()) {
      createRequest(
        serviceId: serviceId,
        location: locationController.text,
        date:
        '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
        time:
        '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
        duration: durationController.text,
        notes: notesController.text,
      );
    }

  }


  Future<void> createRequest({
    required String serviceId,
    required String location,
    required String date,
    required String time,
    String? duration,
    String? notes,
  }) async {
    emit(CreateRequestLoading());

    try {
      print("SERVICE ID: $serviceId");
      print("LOCATION: $location");
      print("DATE: $date");
      print("TIME: $time");
      print("DURATION: $duration");
      print("NOTES: $notes");
      await repository.createRequest(
        serviceId: serviceId,
        location: location,
        date: date,
        time: time,
        duration: duration,
        notes: notes,
      );
      print("CREATE REQUEST SUCCESS FROM CUBIT");
      emit(CreateRequestSuccess());
    } catch (e) {
      emit(
        CreateRequestError(
          e.toString(),
        ),
      );
    }
  }
}