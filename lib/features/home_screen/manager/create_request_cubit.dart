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

  void submitRequest() {
    if (formKey.currentState!.validate()) {
      createRequest(
        serviceId: '',
        location: '',
        date: selectedDate != null
            ? '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}'
            : '',
        time: selectedTime != null
            ? '${selectedTime!.hour}:${selectedTime!.minute}'
            : '',
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
      await repository.createRequest(
        serviceId: serviceId,
        location: location,
        date: date,
        time: time,
        duration: duration,
        notes: notes,
      );

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