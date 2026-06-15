import 'package:ehtemam_final_project/features/profile_caregiver/data/repo/caregiver_repo.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/manager/caregiver_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaregiverCubit extends Cubit<CaregiverState> {
  final CaregiverRepo _repo;

  CaregiverCubit(this._repo) : super(CaregiverInitial());

  Future<void> loadProfile() async {
    if (isClosed) return;
    emit(CaregiverLoading());
    try {
      final profile = await _repo.getProfile();
      if (!isClosed) emit(CaregiverLoaded(profile: profile));
    } catch (e) {
      if (!isClosed) emit(CaregiverError(e.toString()));
    }
  }
}
