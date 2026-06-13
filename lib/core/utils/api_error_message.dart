import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

String apiErrorMessage(Object error) {
  if (error is DioException) {
    final serverMessage = _serverMessage(error);
    if (serverMessage != null) return serverMessage;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'connection_timeout_error'.tr();
      case DioExceptionType.connectionError:
        return 'connection_error'.tr();
      case DioExceptionType.badResponse:
        return 'server_error'.tr();
      case DioExceptionType.cancel:
        return 'request_cancelled'.tr();
      default:
        return 'something_went_wrong'.tr();
    }
  }

  final message = error.toString();
  if (message.startsWith('Exception: ')) {
    return message.substring('Exception: '.length);
  }

  if (message.isNotEmpty) return message;

  return 'something_went_wrong'.tr();
}

String? _serverMessage(DioException error) {
  final data = error.response?.data;

  if (data is Map) {
    final message = data['message'];
    if (message != null) return message.toString();

    final errorField = data['error'];
    if (errorField != null) return errorField.toString();

    final errors = data['errors'];
    if (errors is List && errors.isNotEmpty) {
      return errors.first.toString();
    }
  }

  if (data is String && data.isNotEmpty) return data;

  return null;
}
