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
      final active = users.where((u) => !u.isBlocked).toList();
      _allUsers = active;
      if (!isClosed) {
        emit(state.copyWith(allUsers: active, filteredUsers: active));
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

  /// Returns null on success, an error message string on failure.
  Future<String?> blockUser(String id) async {
    try {
      await apiService.blockUser(id);
      _allUsers = _allUsers.where((u) => u.id != id).toList();
      if (!isClosed) {
        emit(state.copyWith(
          allUsers: _allUsers,
          filteredUsers: state.filteredUsers.where((u) => u.id != id).toList(),
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
