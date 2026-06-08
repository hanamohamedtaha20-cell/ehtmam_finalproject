import 'package:ehtemam_final_project/features/profile2/data/repo/profile_repo.dart';
import 'package:ehtemam_final_project/features/profile2/manager/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _repo;

  ProfileCubit(this._repo) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final user = await _repo.getUser();
      emit(ProfileLoaded(
        user:          user,
        totalRequests: 0,
        completed:     0,
        rating:        0.0,
      ));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}