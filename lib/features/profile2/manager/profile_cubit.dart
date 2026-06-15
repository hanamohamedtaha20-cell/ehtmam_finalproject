import 'package:ehtemam_final_project/features/profile2/data/repo/profile_repo.dart';
import 'package:ehtemam_final_project/features/profile2/manager/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _repo;

  ProfileCubit(this._repo) : super(ProfileInitial());

  Future<void> loadProfile() async {
    if (isClosed) return;
    emit(ProfileLoading());
    try {
      final results = await Future.wait([
        _repo.getUser(),
        _repo.getStats(),
      ]);
      final user  = results[0] as dynamic;
      final stats = results[1] as Map<String, dynamic>;
      if (!isClosed) {
        emit(ProfileLoaded(
          user:          user,
          totalRequests: stats['total'] as int,
          completed:     stats['completed'] as int,
          rating:        0.0,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(ProfileError(e.toString()));
      }
    }
  }
}
