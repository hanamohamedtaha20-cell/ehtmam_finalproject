import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('user_government', government);
      await prefs.setString('user_name', name);
      await prefs.setString('user_email', email);
      await prefs.setString('user_phone', phone);
      await prefs.setString('user_role', role);
      print("NAME => ${prefs.getString('user_name')}");
      print("EMAIL => ${prefs.getString('user_email')}");
      print("PHONE => ${prefs.getString('user_phone')}");
      print("GOV => ${prefs.getString('user_government')}");

      // if (state.status == AuthStatus.registered) {
      //   final prefs = await SharedPreferences.getInstance();
      //   await prefs.setString('user_government', government);
      //   await prefs.setString('user_name', name);
      // }

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
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      final token = await authRepo.login(
        email: email,
        password: password,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setBool('is_logged_in', true);


      final parts = token.split('.');
      if (parts.length == 3) {
        final payload = utf8.decode(
          base64Url.decode(base64Url.normalize(parts[1])),
        );
        final decoded = jsonDecode(payload);
        await prefs.setString('userId', decoded['id'] ?? '');
      }

      emit(state.copyWith(status: AuthStatus.authenticated, token: token));
    } catch (e) {
      emit(state.copyWith(
          status: AuthStatus.error, errorMessage: 'Invalid email or password'));
    }
  }



  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('token');
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