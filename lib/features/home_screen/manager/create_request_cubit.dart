import 'package:ehtemam_final_project/features/home_screen/manager/state/create_request_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateRequestCubit
    extends Cubit<CreateRequestState> {

  CreateRequestCubit()
      : super(CreateRequestInitial());

  static CreateRequestCubit get(context) =>
      BlocProvider.of(context);

  /// FORM KEY
  final formKey = GlobalKey<FormState>();

  /// DATE & TIME
  DateTime? selectedDate;

  TimeOfDay? selectedTime;

  /// VALIDATION FLAGS
  bool isDateEmpty = false;

  bool isTimeEmpty = false;

  /// SET DATE
  void setDate(DateTime date) {

    selectedDate = date;

    isDateEmpty = false;

    emit(CreateRequestDateChanged());
  }

  /// SET TIME
  void setTime(TimeOfDay time) {

    selectedTime = time;

    isTimeEmpty = false;

    emit(CreateRequestTimeChanged());
  }

  /// SUBMIT REQUEST
  void submitRequest() {

    /// DATE VALIDATION
    isDateEmpty = selectedDate == null;

    /// TIME VALIDATION
    isTimeEmpty = selectedTime == null;

    /// REBUILD UI
    emit(CreateRequestDateChanged());

    emit(CreateRequestTimeChanged());

    /// FORM VALIDATION
    final isFormValid =
    formKey.currentState!.validate();

    /// STOP IF ANY ERROR
    if (!isFormValid ||
        isDateEmpty ||
        isTimeEmpty) {

      emit(
        CreateRequestError(
          "Please complete all required fields",
        ),
      );

      return;
    }

    emit(CreateRequestLoading());

    // API OR LOGIC HERE

    emit(CreateRequestSuccess());
  }
}