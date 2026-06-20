import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ApiService _api = ApiService();

  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  Future<void> sendResetLink(String email) async {
    if (isClosed) return;

    debugPrint('[ForgotPassword] POST /userlog/forgotpassword');
    debugPrint('[ForgotPassword] email: $email');

    emit(ForgotPasswordLoading());

    try {
      final response = await _api.forgotPassword(email.trim());

      debugPrint('[ForgotPassword] response: $response');

      final message = response['message']?.toString() ??
          'Reset link sent to your email! Valid for 10 minutes.';

      if (!isClosed) emit(ForgotPasswordSuccess(message));
    } catch (e) {
      debugPrint('[ForgotPassword] error: $e');
      if (!isClosed) emit(ForgotPasswordError(_friendlyError(e)));
    }
  }

  String _friendlyError(Object e) {
    try {
      // ignore: avoid_dynamic_calls
      final dynamic dioE = e;
      final resp = dioE.response;
      if (resp != null) {
        debugPrint('[ForgotPassword] statusCode: ${resp.statusCode}');
        debugPrint('[ForgotPassword] response data: ${resp.data}');
        final body = resp.data;
        if (body is Map) {
          final msg = body['message'] ?? body['error'] ?? body['msg'];
          if (msg != null) return msg.toString();
        }
        return 'Server error (${resp.statusCode}). Please try again.';
      }
    } catch (_) {}
    return 'Failed to send reset link. Please check your email and try again.';
  }
}

