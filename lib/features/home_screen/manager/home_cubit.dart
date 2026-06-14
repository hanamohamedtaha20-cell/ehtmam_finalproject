import 'package:ehtemam_final_project/features/home_screen/manager/state/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/home_repo.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit(this.homeRepo) : super(HomeInitial());

  Future<void> getServices() async {
    if (isClosed) return;
    emit(HomeLoading());

    try {
      final services = await homeRepo.getServices();
      if (!isClosed) {
        emit(HomeSuccess(services));
      }
    } catch (e) {
      if (!isClosed) {
        emit(HomeError(e.toString()));
      }
    }
  }
}
