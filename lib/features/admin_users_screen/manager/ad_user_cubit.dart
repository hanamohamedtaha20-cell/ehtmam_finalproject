import 'package:ehtemam_final_project/features/admin_users_screen/manager/state/ad_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/AD_user_model.dart';
import '../model/repo/ad_user_repository.dart';


class AdUserCubit extends Cubit<AdUserState> {
  final AdUserRepository repository;

  AdUserCubit(this.repository) : super(UserInitial());

  List<AdUserModel> users = [];

  Future<void> getUsers() async {
    try {
      emit(UserLoading());

      users = await repository.getUsers();

      emit(
        UserLoaded(users),
      );
    } catch (e) {
      emit(
        UsersError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> blockUser(int userId) async {
    try {
      emit(UserBlocking());

      await repository.blockUser(userId);

      users = users.map((user) {
        if (user.id == userId) {
          return AdUserModel(
            id: user.id,
            name: user.name,
            email: user.email,
            bookings: user.bookings,
            joinedDate: user.joinedDate,
            isActive: false,
            isPremium: user.isPremium,
          );
        }

        return user;
      }).toList();

      emit(
        UserBlocked(
          'User blocked successfully',
        ),
      );

      emit(
        UserLoaded(users),
      );
    } catch (e) {
      emit(
        UsersError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> searchUsers(String query) async {
    try {
      if (query.isEmpty) {
        emit(
          UserLoaded(users),
        );
        return;
      }

      final filteredUsers = users.where((user) {
        return user.name
            .toLowerCase()
            .contains(query.toLowerCase()) ||
            user.email
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();

      emit(
        UserLoaded(filteredUsers),
      );
    } catch (e) {
      emit(
        UsersError(
          e.toString(),
        ),
      );
    }
  }
}