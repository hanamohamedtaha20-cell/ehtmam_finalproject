import 'package:ehtemam_final_project/features/profile2/data/model/profile_model.dart';
import 'package:ehtemam_final_project/features/profile2/data/repo/profile_repo.dart';
import 'package:ehtemam_final_project/features/profile2/manager/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _repo;

  ProfileCubit(this._repo) : super(ProfileInitial());

  void loadProfile() {
    emit(ProfileLoaded(
      user: _repo.getUser(),
      totalRequests: 8,
      completed: 5,
      rating: 4.5,
    ));
  }
}