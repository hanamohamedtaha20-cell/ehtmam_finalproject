import 'package:dio/dio.dart';
import 'api_constants.dart';

class ApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<Response> post({
    required String endpoint,
    required dynamic data,
    Options? options,
  }) async {
    return await dio.post(endpoint,
      data: data,
      options: options,
    );
  }
}