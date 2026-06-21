import 'package:ehtemam_final_project/core/services/notification_socket_service.dart';
import 'package:flutter/foundation.dart';
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
    PlatformFile? mentalHealthFile,
    String careField = '',
    String specialization = '',
    String certificateFileName = '',
    required String street,
    required String building,
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
        mentalHealthFile: mentalHealthFile,
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
      if (careField.isNotEmpty) {
        await prefs.setString('care_field', careField);
        await prefs.setString('speciality', careField.toLowerCase());
      }
      debugPrint("NAME => ${prefs.getString('user_name')}");
      debugPrint("EMAIL => ${prefs.getString('user_email')}");
      debugPrint("PHONE => ${prefs.getString('user_phone')}");
      debugPrint("GOV => ${prefs.getString('user_government')}");
      debugPrint("CARE_FIELD => ${prefs.getString('care_field')}");

      if (!isClosed) {
        emit(
          state.copyWith(
            status: AuthStatus.registered,
          ),
        );
      }
    } catch (e) {
      debugPrint('[Register] error: $e');
      // auth_repo already extracted the backend message and wrapped it in Exception(msg)
      String message = e.toString().replaceFirst('Exception: ', '').trim();
      if (message.isEmpty || message.startsWith('Exception')) {
        message = 'Registration failed, please try again';
      }
      if (!isClosed) {
        emit(state.copyWith(status: AuthStatus.error, errorMessage: message));
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
        await prefs.setBool('is_guest', false);

        if (!isClosed) {
          emit(
            state.copyWith(
              status: AuthStatus.authenticated,
              token: 'admin_token',
              userRole: 'admin',
              userName: 'Admin',
              isGuest: false,
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

      final userRole = loginResponse.user.role.toLowerCase();
      final isCaregiver =
          userRole == 'giver' || userRole == 'caregiver';
      final isRejected =
          loginResponse.user.status.toLowerCase() == 'rejected';

      await prefs.setString('token', loginResponse.token);
      await prefs.setString('user_role', loginResponse.user.role);
      await prefs.setString('user_name', loginResponse.user.fullName);
      await prefs.setString('user_email', loginResponse.user.email);
      await prefs.setString('userId', loginResponse.user.id);
      await prefs.setString('user_phone', loginResponse.user.phone);
      await prefs.setString('caregiver_status', loginResponse.user.status);
      if (loginResponse.user.speciality.isNotEmpty) {
        await prefs.setString('speciality', loginResponse.user.speciality);
        await prefs.setString('care_field', loginResponse.user.speciality);
        debugPrint('LOGIN_SPECIALITY_SAVED: ${loginResponse.user.speciality}');
      }

      if (isCaregiver && isRejected) {
        debugPrint('[Login] Caregiver status: Rejected â€” blocking home navigation.');
        if (!isClosed) {
          emit(
            state.copyWith(
              status: AuthStatus.caregiverRejected,
              token: loginResponse.token,
              userRole: loginResponse.user.role,
              userName: loginResponse.user.fullName,
            ),
          );
        }
        return;
      }

      await prefs.setBool('is_logged_in', true);
      await prefs.setBool('is_guest', false);

      NotificationSocketService.instance.connect(loginResponse.token);

      if (!isClosed) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            token: loginResponse.token,
            userRole: loginResponse.user.role,
            userName: loginResponse.user.fullName,
            isGuest: false,
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

  Future<void> loginAsGuest() async {
    // Emit immediately so the UI gets the correct guest state right away.
    emit(state.copyWith(
      isGuest: true,
      status: AuthStatus.initial,
      userName: 'Guest',
    ));

    // Persist the flag and wipe any cached user data from a previous session.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_guest', true);
    await prefs.remove('user_name');
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('user_email');
    await prefs.remove('user_phone');
    await prefs.remove('is_logged_in');
  }

  Future<void> logout() async {
    try {
      // Best-effort backend logout â€” ignore errors (token may already be expired).
      try { await authRepo.apiService.logout(); } catch (_) {}

      NotificationSocketService.instance.disconnect();

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

