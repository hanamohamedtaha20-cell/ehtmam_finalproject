import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../model/AD_user_model.dart';
import 'ad_user_state.dart';

class AdUserCubit extends Cubit<AdUsersState> {
  final ApiService apiService;

  AdUserCubit({
    ApiService? apiService,
  }) : apiService = apiService ?? ApiService(),
        super(const AdUsersState());

  List<AdUserModel> _allUsers = [];

  Future<void> getUsers() async {
    try {
      final users =
      await apiService.getAllUsers();

      _allUsers = users;

      emit(
        state.copyWith(
          allUsers: users,
          filteredUsers: users,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
        ),
      );
    }
  }
  void searchUsers(String value) {
    final query = value.trim().toLowerCase();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchText: value,
          filteredUsers: _allUsers,
        ),
      );
      return;
    }

    final filtered = _allUsers.where((user) {
      return user.name
          .toLowerCase()
          .contains(query) ||
          user.email
              .toLowerCase()
              .contains(query);
    }).toList();

    emit(
      state.copyWith(
        searchText: value,
        filteredUsers: filtered,
      ),
    );
  }

  Future<void> blockUser(String id) async {
    try {
      await apiService.blockUser(id);

      await getUsers();
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
        ),
      );
    }
  }
}