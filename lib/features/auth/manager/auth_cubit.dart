import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repo/auth_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;

  AuthCubit(this.authRepo) : super(const AuthState());

  void selectRole(String role) {
    emit(
      state.copyWith(
        selectedRole: role,
        status: AuthStatus.initial,
        errorMessage: null,
      ),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    required String government,
    PlatformFile? profileFile,
    PlatformFile? nationalIdFile,
    PlatformFile? certificateFile,
    String careField = '',
    String specialization = '',
    String certificateFileName = '',
  }) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        errorMessage: null,
      ),
    );

    try {
      await authRepo.signup(
        fullName: name,
        email: email,
        password: password,
        passwordConfirmation: password,
        role: role,
        profileFile: profileFile,
        nationalIdFile: nationalIdFile,
        certificateFile: certificateFile,
        careField: careField,
        specialization: specialization,
      );

      emit(
        state.copyWith(
          status: AuthStatus.registered,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Registration failed: $e',
        ),
      );
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        errorMessage: null,
      ),
    );

    try {
      final loginResponse = await authRepo.login(
        email: email,
        password: password,
      );

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', loginResponse.token);
      await prefs.setString('user_role', loginResponse.user.role);
      await prefs.setBool('is_logged_in', true);

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          token: loginResponse.token,
          userRole: loginResponse.user.role,
          userName: loginResponse.user.fullName,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Invalid email or password',
        ),
      );
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('token');
      await prefs.remove('user_role');
      await prefs.setBool('is_logged_in', false);

      emit(const AuthState());
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Logout failed',
        ),
      );
    }
  }
}