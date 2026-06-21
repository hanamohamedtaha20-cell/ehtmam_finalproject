import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../model/AD_user_model.dart';
import 'ad_user_state.dart';

class AdUserCubit extends Cubit<AdUsersState> {
  final ApiService apiService;

  AdUserCubit({ApiService? apiService})
      : apiService = apiService ?? ApiService(),
        super(const AdUsersState());

  List<AdUserModel> _allUsers = [];

  Future<void> getUsers() async {
    try {
      final users = await apiService.getAllUsers();
      // Show ALL users (blocked and active) so admin can toggle
      _allUsers = users;
      if (!isClosed) {
        emit(state.copyWith(allUsers: users, filteredUsers: users));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(errorMessage: _extractError(e)));
      }
    }
  }

  void searchUsers(String value) {
    final query = value.trim().toLowerCase();
    if (query.isEmpty) {
      emit(state.copyWith(searchText: value, filteredUsers: _allUsers));
      return;
    }
    final filtered = _allUsers.where((user) {
      return user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query);
    }).toList();
    emit(state.copyWith(searchText: value, filteredUsers: filtered));
  }

  /// Toggles block status. Returns null on success, error message on failure.
  Future<String?> toggleBlockUser(AdUserModel user) async {
    try {
      await apiService.blockUser(user.id);
      // Flip the status locally — same endpoint is a toggle on the backend
      final newStatus = user.isBlocked ? 'active' : 'blocked';
      _allUsers = _allUsers
          .map((u) => u.id == user.id ? u.copyWith(status: newStatus) : u)
          .toList();
      if (!isClosed) {
        emit(state.copyWith(
          allUsers: _allUsers,
          filteredUsers: state.filteredUsers
              .map((u) => u.id == user.id ? u.copyWith(status: newStatus) : u)
              .toList(),
        ));
      }
      return null;
    } catch (e) {
      final msg = _extractError(e);
      if (!isClosed) emit(state.copyWith(errorMessage: msg));
      return msg;
    }
  }

  static String _extractError(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            'Request failed';
      }
      return 'Request failed (${e.response?.statusCode ?? 'no response'})';
    }
    return e.toString();
  }
}
