import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState());

  Timer? _timer;

  void startSplashTimer() {
    _timer?.cancel();

    emit(state.copyWith(navigate: false));

    _timer = Timer(const Duration(seconds: 6), () {
      emit(state.copyWith(navigate: true));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}