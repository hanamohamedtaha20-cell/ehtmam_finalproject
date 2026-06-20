import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  Future<void> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    if (isClosed) return;

    if (password.length < 8) {
      emit(ResetPasswordError('Password must be at least 8 characters.'));
      return;
    }
    if (password != confirmPassword) {
      emit(ResetPasswordError('Passwords do not match.'));
      return;
    }

    emit(ResetPasswordLoading());
    try {
      final response = await ApiService().resetPassword(
        token: token,
        password: password,
        passwordConfirmation: confirmPassword,
      );
      debugPrint('[ResetPassword] response: $response');
      final message = response['message']?.toString() ?? 'Password reset successfully!';
      if (!isClosed) emit(ResetPasswordSuccess(message));
    } catch (e) {
      debugPrint('[ResetPassword] error: $e');
      if (!isClosed) emit(ResetPasswordError(_friendlyError(e)));
    }
  }

  String _friendlyError(Object e) {
    try {
      // ignore: avoid_dynamic_calls
      final dynamic dioE = e;
      final resp = dioE.response;
      if (resp != null) {
        debugPrint('[ResetPassword] statusCode: ${resp.statusCode}');
        debugPrint('[ResetPassword] response data: ${resp.data}');
        final body = resp.data;
        if (body is Map) {
          final msg = body['message'] ?? body['error'] ?? body['msg'];
          if (msg != null) return msg.toString();
        }
        return 'Server error (${resp.statusCode}). Please try again.';
      }
    } catch (_) {}
    return 'Failed to reset password. The link may have expired. Please request a new one.';
  }
}

