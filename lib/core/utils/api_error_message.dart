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

  return 'something_went_wrong'.tr();
}

String? _serverMessage(DioException error) {
  final data = error.response?.data;
  if (data is Map && data['message'] != null) {
    return data['message'].toString();
  }
  return null;
}
