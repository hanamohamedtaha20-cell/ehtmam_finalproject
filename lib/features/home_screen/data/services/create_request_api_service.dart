import 'package:dio/dio.dart';

class CreateRequestApiService {
  final Dio dio;

  CreateRequestApiService(this.dio);

  Future<void> createRequest(Map<String, dynamic> data) async {
    await dio.post(
      "/requests",
      data: data,
    );
  }
}