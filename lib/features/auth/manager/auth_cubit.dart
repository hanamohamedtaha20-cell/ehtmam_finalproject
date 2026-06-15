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
    String certificateFileName = '', required String street, required String building,
  }) async {
    if (isClosed) return;
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
        governorate: government,
        street: street,
        building: building,
        profileFile: profileFile,
        nationalIdFile: nationalIdFile,
        certificateFile: certificateFile,
        careField: careField,
        specialization: specialization,
        phone: phone,
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

      if (!isClosed) {
        emit(
          state.copyWith(
            status: AuthStatus.registered,
          ),
        );
      }
    } catch (e) {
      String message = e.toString();

      if (message.contains('Email already exists')) {
        message = 'Email already exists';
      } else {
        message = 'Registration failed, please try again';
      }

      if (!isClosed) {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: message,
          ),
        );
      }
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        errorMessage: null,
      ),
    );

    try {
      // Admin Login (Temporary)
      if (email.trim() == 'hana@example.com' &&
          password.trim() == '123456789') {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', 'admin_token');
        await prefs.setString('user_role', 'admin');
        await prefs.setString('user_name', 'Admin');
        await prefs.setBool('is_logged_in', true);

        if (!isClosed) {
          emit(
            state.copyWith(
              status: AuthStatus.authenticated,
              token: 'admin_token',
              userRole: 'admin',
              userName: 'Admin',
            ),
          );
        }

        return;
      }

      final loginResponse = await authRepo.login(
        email: email,
        password: password,
      );

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', loginResponse.token);
      await prefs.setString('user_role', loginResponse.user.role);
      await prefs.setString('user_name', loginResponse.user.fullName);
      await prefs.setString('userId', loginResponse.user.id);
      await prefs.setBool('is_logged_in', true);

      if (!isClosed) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            token: loginResponse.token,
            userRole: loginResponse.user.role,
            userName: loginResponse.user.fullName,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: 'Invalid email or password',
          ),
        );
      }
    }
  }

  Future<void> logout() async {
    try {
      // Best-effort backend logout — ignore errors (token may already be expired).
      try { await authRepo.apiService.logout(); } catch (_) {}

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (!isClosed) emit(const AuthState());
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Logout failed',
        ));
      }
    }
  }
}
