import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/admin_features/data/bundle_model.dart';
import '../../features/admin_features/data/transaction_model.dart';
import '../../features/admin_users_screen/model/AD_user_model.dart';
import '../../features/home_screen/data/model/chat_message_model.dart';
import '../navigation/app_navigator.dart';
import '../../features/auth/ui/screens/login_screen.dart';
import 'api_constants.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 180),
        receiveTimeout: const Duration(seconds: 180),
        sendTimeout: const Duration(seconds: 180),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token') ?? '';
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          debugPrint("API ERROR URL: ${error.requestOptions.uri}");
          debugPrint("API ERROR STATUS: ${error.response?.statusCode}");
          debugPrint("API ERROR BODY: ${error.response?.data}");
          if (error.response?.statusCode == 401) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('token');
            await prefs.remove('userId');
            await prefs.setBool('is_logged_in', false);
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }
          handler.next(error);
        },
      ),
    );
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  USER AUTH â€” /userlog
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Future<Map<String, dynamic>> signupClient({
    required String fullName,
    required String email,
    required String password,
    required String passwordConfirmation,
    File? profilePicture,
    File? nationalId,
    String? governorate,
    String? street,
    String? building,
  }) async {
    final formData = FormData.fromMap({
      'full_name': fullName,
      'email': email,
      'password': password,
      'passwordConfirmation': passwordConfirmation,
      if (profilePicture != null)
        'profile_picture': await MultipartFile.fromFile(profilePicture.path),
      if (nationalId != null)
        'national_id': await MultipartFile.fromFile(nationalId.path),
      if (governorate != null) 'governorate': governorate,
      if (street != null) 'address[street]': street,
      if (building != null) 'address[building]': building,
    });
    final response = await _dio.post(signupEndpoint, data: formData);
    return response.data;
  }

  Future<Map<String, dynamic>> loginClient({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      loginEndpoint,
      data: {'email': email, 'password': password},
      options: Options(headers: {'Authorization': null}),
    );

    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> postFormData({
    required String endpoint,
    required FormData formData,
  }) async {
    debugPrint('### CAREGIVER_SIGNUP_START ###');
    debugPrint('REQUEST URL: $baseUrl$endpoint');

    debugPrint('### CAREGIVER_SIGNUP_FORMDATA_FIELDS ###');
    for (final f in formData.fields) {
      debugPrint('FIELD => ${f.key}: ${f.value}');
    }

    debugPrint('### CAREGIVER_SIGNUP_FORMDATA_FILES ###');
    for (final f in formData.files) {
      debugPrint('FILE => ${f.key}: ${f.value.filename}');
    }

    try {
      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {'Authorization': null},
        ),
      );

      debugPrint('### CAREGIVER_SIGNUP_RESPONSE ###');
      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('RESPONSE DATA: ${response.data}');

      return Map<String, dynamic>.from(response.data as Map);
    } catch (e) {
      if (e is DioException) {
        debugPrint('### CAREGIVER_SIGNUP_DIO_ERROR ###');
        debugPrint('STATUS: ${e.response?.statusCode}');
        debugPrint('DATA: ${e.response?.data}');
        debugPrint('HEADERS: ${e.response?.headers}');
        debugPrint('REQUEST: ${e.requestOptions.uri}');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> logout() async {
    final response = await _dio.post(logoutEndpoint);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    return response.data;
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    // Must NOT send the Authorization token â€” use a clean Dio with no interceptors.
    // The global _dio interceptor overwrites Options(headers:{'Authorization':null}),
    // so we create a standalone instance for this call only.
    final cleanDio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    final fullUrl = '$baseUrl$forgotPasswordEndpoint';
    final body = {'email': email.trim()};

    debugPrint('[ForgotPassword] POST $fullUrl');
    debugPrint('[ForgotPassword] body: $body');

    final response = await cleanDio.post(forgotPasswordEndpoint, data: body);

    debugPrint('[ForgotPassword] statusCode: ${response.statusCode}');
    debugPrint('[ForgotPassword] response: ${response.data}');

    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    // Clean Dio â€” no auth interceptor, no token sent (same reason as forgotPassword).
    final cleanDio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    final endpoint = '/userlog/resetpassword/$token';
    final body = {
      'password': password,
      'passwordConfirmation': passwordConfirmation,
    };

    debugPrint('[ResetPassword] PATCH $baseUrl$endpoint');
    debugPrint('[ResetPassword] body: $body');

    final response = await cleanDio.patch(endpoint, data: body);

    debugPrint('[ResetPassword] statusCode: ${response.statusCode}');
    debugPrint('[ResetPassword] response: ${response.data}');

    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> updatePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _dio.patch(
      updatePasswordEndpoint,
      data: {
        'currentPassword': currentPassword,
        'password': password,
        'passwordConfirmation': passwordConfirmation,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final response = await _dio.get('/userlog/$userId');
    return response.data;
  }

  // â”€â”€ DELETE ACCOUNT â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Tries each candidate URL in order. Stops at the first success.
  // On 404 it tries the next URL. On any other error it fails immediately.
  Future<Map<String, dynamic>> deleteAccount({String role = ''}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final isCaregiver = role.toLowerCase() == 'giver' ||
        role.toLowerCase() == 'caregiver';
    final endpoint =
        isCaregiver ? '/caregiver/delete_me' : '/userlog/delete_me';

    debugPrint('DELETE_ACCOUNT_ROLE: $role');
    debugPrint('DELETE_ACCOUNT_URL: $endpoint');
    debugPrint('TOKEN_EXISTS: ${token != null}');

    try {
      final response = await _dio.delete(endpoint);
      debugPrint('DELETE_RESPONSE: ${response.data}');
      return Map<String, dynamic>.from(response.data as Map? ?? {});
    } on DioException catch (e) {
      debugPrint('DELETE_ERROR: ${e.response?.data}');
      rethrow;
    }
  }
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  CAREGIVER â€” /caregiver
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Future<Map<String, dynamic>> signupCaregiver({
    required String fullName,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? speciality,
    num? price,
    String? availability,
    String? experience,
    File? profilePicture,
    List<File>? certifications,
    List<File>? verificationDocuments,
  }) async {
    final map = <String, dynamic>{
      'full_name': fullName,
      'email': email,
      'password': password,
      'passwordConfirmation': passwordConfirmation,
      if (speciality != null) 'speciality': speciality,
      if (price != null) 'price': price.toString(),
      if (availability != null) 'availability': availability,
      if (experience != null) 'experience': experience,
      if (profilePicture != null)
        'profile_picture': await MultipartFile.fromFile(profilePicture.path),
    };
    if (certifications != null) {
      map['certifications'] = [
        for (final f in certifications) await MultipartFile.fromFile(f.path),
      ];
    }
    if (verificationDocuments != null) {
      map['verifcation_documents'] = [
        for (final f in verificationDocuments)
          await MultipartFile.fromFile(f.path),
      ];
    }
    final response = await _dio.post(
      caregiverSignupEndpoint,
      data: FormData.fromMap(map),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> updateCaregiverDocuments({
    required String id,
    PlatformFile? profileFile,
    PlatformFile? nationalIdFile,
    PlatformFile? certificateFile,
  }) async {
    final map = <String, dynamic>{};

    if (profileFile != null) {
      map['profile_picture'] = profileFile.bytes != null
          ? MultipartFile.fromBytes(
              profileFile.bytes!,
              filename: profileFile.name,
            )
          : await MultipartFile.fromFile(
              profileFile.path!,
              filename: profileFile.name,
            );
    }
    if (nationalIdFile != null) {
      map['verifcation_documents'] = [
        nationalIdFile.bytes != null
            ? MultipartFile.fromBytes(
                nationalIdFile.bytes!,
                filename: nationalIdFile.name,
              )
            : await MultipartFile.fromFile(
                nationalIdFile.path!,
                filename: nationalIdFile.name,
              ),
      ];
    }
    if (certificateFile != null) {
      map['certifications'] = [
        certificateFile.bytes != null
            ? MultipartFile.fromBytes(
                certificateFile.bytes!,
                filename: certificateFile.name,
              )
            : await MultipartFile.fromFile(
                certificateFile.path!,
                filename: certificateFile.name,
              ),
      ];
    }

    final response = await _dio.patch(
      '$caregiverEndpoint/update-documents/$id',
      data: FormData.fromMap(map),
      options: Options(contentType: 'multipart/form-data'),
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> getAllCaregivers({
    Map<String, String>? queryParams,
  }) async {
    final response = await _dio.get(
      caregiverEndpoint,
      queryParameters: queryParams,
      options: Options(headers: {'Authorization': null}),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getCaregiverById(String id) async {
    final response = await _dio.get(
      '$caregiverEndpoint/$id',
      options: Options(headers: {'Authorization': null}),
    );
    debugPrint('CAREGIVER BY ID: ${response.data}');
    return response.data;
  }

  Future<Map<String, dynamic>> updateCaregiver(
    String id,
    Map<String, dynamic> fields,
  ) async {
    final response = await _dio.patch('$caregiverEndpoint/$id', data: fields);
    return response.data;
  }

  Future<Map<String, dynamic>> deleteCaregiver(String id) async {
    final response = await _dio.delete('$caregiverEndpoint/$id');
    return response.data;
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  SERVICES â€” /services
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Future<Map<String, dynamic>> getAllServices() async {
    final response = await _dio.get(
      servicesEndpoint,
      queryParameters: {'limit': 100},
      options: Options(headers: {'Authorization': null}),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getServiceById(String id) async {
    final response = await _dio.get(
      '$servicesEndpoint/$id',
      options: Options(headers: {'Authorization': null}),
    );
    return response.data;
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  REQUESTS â€” /request
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Future<Map<String, dynamic>> createRequest({
    required String serviceId,
    required String serviceType,
    required String governorate,
    required String date,
    required String time,
    required num budget,
    required List<String> tasks,
    String? description,
    String? duration,
    String? notes,
    String? serviceType,
  }) async {
    debugPrint('SERVICE_TYPE_SENT: $serviceType');
    final response = await _dio.post(requestEndpoint, data: {
      'service':     serviceId,
      'governorate': governorate,
      'date':        date,
      'time':        time,
      'budget':      budget,
      'tasks':       tasks.map((t) => {'taskDescription': t}).toList(),
      if (description != null && description.isNotEmpty) 'description': description,
      if (duration    != null && duration.isNotEmpty)    'duration':    duration,
      if (notes       != null && notes.isNotEmpty)       'notes':       notes,
      if (serviceType != null && serviceType.isNotEmpty) 'serviceType': serviceType,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> getMyRequests() async {
    try {
      final response = await _dio.get(requestEndpoint);
      debugPrint("GET MY REQUESTS SUCCESS => ${response.data}");
      return response.data;
    } on DioException catch (e) {
      debugPrint("GET MY REQUESTS ERROR STATUS => ${e.response?.statusCode}");
      debugPrint("GET MY REQUESTS ERROR DATA => ${e.response?.data}");
      debugPrint("GET MY REQUESTS ERROR MESSAGE => ${e.message}");
      rethrow;
    }
  }
  // Future<Map<String, dynamic>> getMyRequests() async {
  //   final response = await _dio.get(requestEndpoint);
  //   return response.data;
  // }

  Future<Map<String, dynamic>> getAvailableRequests() async {
    final response = await _dio.get(availableRequestsEndpoint);
    return response.data;
  }

  Future<Map<String, dynamic>> getRequestById(String id) async {
    final response = await _dio.get('$requestEndpoint/$id');
    return response.data;
  }

  Future<Map<String, dynamic>> getOffersOnRequest(String requestId) async {
    final response = await _dio.get('$requestEndpoint/$requestId/offers');
    return response.data;
  }

  Future<Map<String, dynamic>> respondToRequest({
    required String requestId,
    required String action,
  }) async {
    final response = await _dio.post(
      '$requestEndpoint/$requestId/respond',
      data: {'action': action},
    );
    return response.data;
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  OFFERS â€” /offer
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Future<Map<String, dynamic>> sendOffer({
    required String requestId,
    required num price,
    String? notes,
  }) async {
    final response = await _dio.post(
      '$offerEndpoint/$requestId/offer',
      data: {
        'price': price,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> respondToOffer({
    required String offerId,
    required String status,
  }) async {
    final response = await _dio.patch(
      '$offerEndpoint/$offerId/respond',
      data: {'status': status},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    final data = response.data;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return {'message': 'Response saved', 'data': data};
  }

  Future<Map<String, dynamic>> deleteOffer(String offerId) async {
    final response = await _dio.delete('/offer/$offerId');
    return response.data;
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  BOOKINGS â€” /booking
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Future<Map<String, dynamic>> createBookingFromOffer(String offerId) async {
    final response = await _dio.post(
      bookingFromOfferEndpoint,
      data: {'offerId': offerId},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    final data = response.data;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return {'data': data};
  }

  Future<Map<String, dynamic>> getMyBookings() async {
    final response = await _dio.get(bookingEndpoint);
    return response.data;
  }

  Future<Map<String, dynamic>> getBookingById(String id) async {
    final response = await _dio.get('$bookingEndpoint/$id');
    return response.data;
  }

  Future<Map<String, dynamic>> checkInBooking(String bookingId) async {
    final response = await _dio.post('$tasksEndpoint/$bookingId/check-in');
    return response.data;
  }

  Future<Map<String, dynamic>> checkOutBooking(String bookingId) async {
    final response = await _dio.post('$tasksEndpoint/$bookingId/check-out');
    return response.data;
  }

  Future<Map<String, dynamic>> getCaregiverLocation(String bookingId) async {
    final url = '$baseUrl$bookingEndpoint/$bookingId/location';
    debugPrint('TRACK_URL = $url');
    final response = await _dio.get('$bookingEndpoint/$bookingId/location');
    debugPrint('TRACK_RESPONSE = ${response.data}');
    return response.data;
  }

  Future<Map<String, dynamic>> updateCaregiverLocation({
    required String bookingId,
    required double latitude,
    required double longitude,
  }) async {
    final url = '$baseUrl$bookingEndpoint/$bookingId/location';
    final body = {'latitude': latitude, 'longitude': longitude};
    debugPrint('REST_LOCATION_URL: $url');
    debugPrint('REST_LOCATION_BODY: $body');

    try {
      final response = await _dio.post(
        '$bookingEndpoint/$bookingId/location',
        data: body,
      );
      debugPrint('REST_LOCATION_RESPONSE: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      debugPrint(
        'REST_LOCATION_ERROR: status=${e.response?.statusCode} body=${e.response?.data}',
      );
      rethrow;
    } catch (e) {
      debugPrint('REST_LOCATION_ERROR: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> confirmAndPayBooking(String bookingId) async {
    final response = await _dio.patch(
      '/booking/confirmbookingandpay/$bookingId',
    );
    return response.data;
  }

  Future<Map<String, dynamic>> deleteBooking(String bookingId) async {
    final response = await _dio.delete('$bookingEndpoint/$bookingId');
    return response.data;
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  PAYMENTS â€” /payment
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Future<Map<String, dynamic>> createPayment({
    required num amount,
    required String paymentMethod,
  }) async {
    final response = await _dio.post(
      createPaymentEndpoint,
      data: {'amount': amount, 'paymentMethod': paymentMethod},
    );
    debugPrint('FULL RESPONSE: ${response.data}');

    return response.data;
  }

  Future<Map<String, dynamic>> payBookingFromWallet(String bookingId) async {
    final response = await _dio.post(
      payBookingWalletEndpoint,
      data: {'bookingId': bookingId},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> processPayment(String offerId) async {
    final response = await _dio.post('$processPaymentEndpoint/$offerId');
    return response.data;
  }

  /// Charges the user wallet for a caregiver-added extra task that was approved.
  /// POST /payment/pay-extra-task/{taskId}
  Future<Map<String, dynamic>> payExtraTask(
    String taskId, {
    String? bookingId,
  }) async {
    const path = '/payment/pay-extra-task';
    final url = '$path/$taskId';
    final body = <String, dynamic>{};
    if (bookingId != null && bookingId.isNotEmpty)
      body['bookingId'] = bookingId;
    debugPrint('PAYMENT REQUEST URL: $baseUrl$url');
    debugPrint('PAYMENT REQUEST BODY: $body');
    try {
      final response = await _dio.post(
        url,
        data: body.isNotEmpty ? body : null,
      );
      debugPrint('PAYMENT RESPONSE STATUS: ${response.statusCode}');
      debugPrint('PAYMENT RESPONSE: ${response.data}');
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (e) {
      debugPrint('PAYMENT ERROR STATUS: ${e.response?.statusCode}');
      debugPrint('PAYMENT ERROR BODY: ${e.response?.data}');
      rethrow;
    }
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  WALLET â€” /wallet
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Future<Map<String, dynamic>> createWallet(String userId) async {
    final response = await _dio.post(walletEndpoint, data: {'userlog': userId});
    return response.data;
  }

  Future<Map<String, dynamic>> getWalletById(String id) async {
    debugPrint("malak");
    final response = await _dio.get(walletEndpoint);
    debugPrint(response.toString());
    return response.data;
  }

  Future<Map<String, dynamic>> getMyWallet() async {
    final response = await _dio.get(myWalletEndpoint);
    return response.data;
  }

  Future<Map<String, dynamic>> getTransactionDetails(String transactionId) async {
    debugPrint('TRANSACTION_DETAILS_ID: $transactionId');
    final response = await _dio.get('$transactionEndpoint/$transactionId');
    debugPrint('TRANSACTION_DETAILS_RESPONSE: ${response.data}');
    return Map<String, dynamic>.from(response.data as Map? ?? {});
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  REVIEWS â€” /review
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Future<Map<String, dynamic>> createReview({
    required String bookingId,
    required int overallRating,
    required int professionalismRating,
    required int serviceQualityRating,
    required int punctualityRating,
    required int communicationRating,
    required String reviewComment,
  }) async {
    final response = await _dio.post(
      '$reviewEndpoint/create_review/$bookingId',
      data: {
        'overallRating': overallRating,
        'professionalismRating': professionalismRating,
        'serviceQualityRating': serviceQualityRating,
        'punctualityRating': punctualityRating,
        'communicationRating': communicationRating,
        'reviewComment': reviewComment,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getReviewById(String id) async {
    final response = await _dio.get('$reviewEndpoint/$id');
    return response.data;
  }

  Future<Map<String, dynamic>> getCaregiverReviews(String caregiverId) async {
    final response = await _dio.get('$reviewEndpoint/caregiver/$caregiverId');
    return response.data;
  }

  Future<Map<String, dynamic>> getMyReviews() async {
    debugPrint('GET MY REVIEWS URL: $myReviewsEndpoint');
    final response = await _dio.get(myReviewsEndpoint);
    debugPrint('GET MY REVIEWS RESPONSE: ${response.data}');
    return Map<String, dynamic>.from(response.data as Map? ?? {});
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  BUNDLES â€” /bundle & /clientbundle
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Future<Map<String, dynamic>> getAllBundles() async {
    final response = await _dio.get(
      bundleEndpoint,
      options: Options(headers: {'Authorization': null}),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getBundleById(String id) async {
    final response = await _dio.get(
      '$bundleEndpoint/$id',
      options: Options(headers: {'Authorization': null}),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> chooseBundle(String bundleId) async {
    final response = await _dio.post(
      clientBundleEndpoint,
      data: {'bundleId': bundleId},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> payBundle(String bundleId) async {
    final response = await _dio.post('$clientBundlePayEndpoint/$bundleId');
    return response.data;
  }

  /// GET /clientbundle/my-active-bundle
  /// Returns the current user's purchased bundle with remainingSessions.
  /// Backend must implement this endpoint.
  Future<Map<String, dynamic>> getMyActiveBundle() async {
    debugPrint('[Bundle] GET $myActiveBundleEndpoint');
    final response = await _dio.get(myActiveBundleEndpoint);
    debugPrint('[Bundle] getMyActiveBundle: ${response.data}');
    return Map<String, dynamic>.from(response.data as Map);
  }

  /// POST /clientbundle/use-for-booking/{offerId}
  /// Accepts the offer and deducts 1 session from the user's active bundle.
  /// Backend must implement this endpoint.
  /// Expected response: { success, data: { bookingId, paymentMethod, remainingSessions, walletDeducted } }
  Future<Map<String, dynamic>> acceptOfferWithBundle(String offerId) async {
    debugPrint('[Bundle] POST $acceptWithBundleEndpoint/$offerId');
    final response = await _dio.post('$acceptWithBundleEndpoint/$offerId');
    debugPrint('[Bundle] acceptOfferWithBundle: ${response.data}');
    return Map<String, dynamic>.from(response.data as Map);
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  AI CHAT â€” /chat
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  // POST /chat â†’ { success, data: { sessionId, title, createdAt } }
  Future<String> createChatSession() async {
    final response = await _dio.post('/chat');
    return response.data['data']['sessionId'] as String;
  }

  // POST /chat/:sessionId/messages â†’ { success, data: { sessionId, message: { role, content } } }
  Future<String> sendChatMessage({
    required String sessionId,
    required String message,
  }) async {
    final response = await _dio.post(
      '/chat/$sessionId/messages',
      data: {'message': message},
    );
    return response.data['data']['message']['content'] as String;
  }

  Future<Map<String, dynamic>> startNewChatSession() async {
    final response = await _dio.post(newChatSessionEndpoint);
    return response.data;
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  TASKS â€” /tasks
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Future<List<dynamic>> fetchTasks() async {
    final response = await _dio.get(tasksEndpoint);
    final data = response.data;
    if (data is List) return data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    return [];
  }

  Future<Map<String, dynamic>> getAllTasks() async {
    final response = await _dio.get(tasksEndpoint);
    return response.data;
  }

  Future<Map<String, dynamic>> getTaskById(String id) async {
    final response = await _dio.get('$tasksEndpoint/$id');
    return response.data;
  }

  Future<List<dynamic>> getTasksByRequestId(String requestId) async {
    final list = await fetchTasks();
    return list.where((item) {
      if (item is! Map) return false;
      return _taskBelongsToRequest(item, requestId);
    }).toList();
  }

  Future<List<dynamic>> getTasksByBookingId(String bookingId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    debugPrint('[MyTasks] bookingId â†’ "$bookingId"');
    debugPrint(
      '[MyTasks] URL     â†’ ${baseUrl}$bookingEndpoint/$bookingId/tasks',
    );
    debugPrint(
      '[MyTasks] token   â†’ ${token.isEmpty ? "EMPTY/NULL â€” will 403" : "${token.substring(0, token.length.clamp(0, 24))}â€¦"}',
    );

    if (token.isEmpty) {
      throw Exception('auth_required');
    }

    try {
      final response = await _dio.get('$bookingEndpoint/$bookingId/tasks');
      debugPrint('[MyTasks] status  â†’ ${response.statusCode}');
      final data = response.data;
      if (data is Map && data['data'] is List) return data['data'] as List;
      if (data is List) return data;
      return [];
    } on DioException catch (e) {
      debugPrint(
        '[MyTasks] error   â†’ HTTP ${e.response?.statusCode}: ${e.response?.data}',
      );
      if (e.response?.statusCode == 403) {
        throw Exception('forbidden_403');
      }
      rethrow;
    }
  }

  bool _taskBelongsToRequest(Map task, String requestId) {
    final request = task['request'];
    if (request is Map) {
      return request['_id']?.toString() == requestId;
    }
    return request?.toString() == requestId;
  }

  Future<Map<String, dynamic>> createTask({required String description}) async {
    final response = await _dio.post(
      tasksEndpoint,
      data: {
        'taskDescription': description,
        'taskTitle': description,
        'taskID': DateTime.now().millisecondsSinceEpoch.toString(),
        'proofUrl': '',
      },
    );
    return response.data;
  }

  /// Adds a caregiver-created task to a specific booking.
  /// POST /booking/{bookingId}/tasks
  Future<Map<String, dynamic>> addCaregiverTask({
    required String bookingId,
    required String taskName,
  }) async {
    final response = await _dio.post(
      '$bookingEndpoint/$bookingId/tasks',
      data: {'taskName': taskName, 'taskDescription': taskName},
    );
    return response.data;
  }

  /// POST /tasks/booking/{bookingId} â€” caregiver adds extra chargeable task.
  Future<Map<String, dynamic>> addExtraTask({
    required String bookingId,
    required String title,
    required String description,
    required double price,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    debugPrint('[ExtraTask] POST $tasksEndpoint/booking/$bookingId');
    debugPrint(
      '[ExtraTask] token: ${token.isNotEmpty ? "present" : "MISSING"}',
    );
    debugPrint(
      '[ExtraTask] body: {title: $title, description: $description, price: $price}',
    );
    final response = await _dio.post(
      '$tasksEndpoint/booking/$bookingId',
      data: {'title': title, 'description': description, 'price': price},
    );
    debugPrint('[ExtraTask] statusCode: ${response.statusCode}');
    debugPrint('[ExtraTask] response: ${response.data}');
    return Map<String, dynamic>.from(response.data as Map);
  }

  /// PATCH /tasks/{taskId}/approve — client approves caregiver extra task.
  Future<Map<String, dynamic>> approveExtraTask(String taskId) async {
    final url = '$tasksEndpoint/$taskId/approve';
    debugPrint('APPROVE REQUEST URL: $baseUrl$url');
    try {
      final response = await _dio.patch(url);
      debugPrint('APPROVE RESPONSE STATUS: ${response.statusCode}');
      debugPrint('APPROVE RESPONSE: ${response.data}');
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (e) {
      debugPrint('APPROVE ERROR STATUS: ${e.response?.statusCode}');
      debugPrint('APPROVE ERROR BODY: ${e.response?.data}');
      rethrow;
    }
  }

  /// PATCH /tasks/{taskId}/reject â€” client rejects caregiver extra task.
  Future<Map<String, dynamic>> rejectExtraTask(String taskId) async {
    debugPrint('[ExtraTask] PATCH $tasksEndpoint/$taskId/reject');
    final response = await _dio.patch('$tasksEndpoint/$taskId/reject');
    debugPrint('[ExtraTask] reject statusCode: ${response.statusCode}');
    debugPrint('[ExtraTask] reject response: ${response.data}');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> createRequestTasks({
    required String requestId,
    required List<String> taskDescriptions,
  }) async {
    if (taskDescriptions.isEmpty) return {};

    final response = await _dio.post(
      '$tasksEndpoint/$requestId',
      data: taskDescriptions
          .map((description) => {'taskDescription': description})
          .toList(),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> updateTask({
    required String id,
    required String taskState,
  }) async {
    final response = await _dio.patch(
      '$tasksEndpoint/$id',
      data: {'taskState': taskState},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> deleteTask(String id) async {
    final response = await _dio.delete('$tasksEndpoint/$id');
    return response.data;
  }

  Future<Map<String, dynamic>> getPendingCaregivers() async {
    final response = await _dio.get(adminPendingCaregiversEndpoint);
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> approveCaregiver(String id) async {
    final response = await _dio.patch('$adminCaregiversEndpoint/$id/approve');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> rejectCaregiver({
    required String id,
    required String reason,
  }) async {
    final response = await _dio.patch(
      '$adminCaregiversEndpoint/$id/reject',
      data: {'reason': reason},
    );

    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> blockProvider(String id) async {
    final response = await _dio.patch('$adminBlockEndpoint/$id');

    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> submitComplaint({
    required String bookingId,
    required String subject,
    required String message,
    required String complaintCategory,
  }) async {
    final response = await _dio.post(
      '$complaintsEndpoint/$bookingId',
      data: {
        'subject': subject,
        'message': message,
        'complaint_category': complaintCategory,
      },
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> getComplaints() async {
    debugPrint('GET COMPLAINTS URL: /admin/complaints');
    final response = await _dio.get(adminComplaintsEndpoint);
    debugPrint('GET COMPLAINTS RESPONSE: ${response.data}');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> getComplaintDetails(String complaintId) async {
    debugPrint('GET COMPLAINT DETAILS URL: /admin/complaints/$complaintId');
    final response = await _dio.get('$adminComplaintsEndpoint/$complaintId');
    debugPrint('GET COMPLAINT DETAILS RESPONSE: ${response.data}');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<List<BundleModel>> getBundles() async {
    final response = await _dio.get(bundleEndpoint);

    final List<dynamic> data = response.data['data'] ?? [];

    return data
        .map<BundleModel>(
          (e) => BundleModel.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList();
  }

  Future<void> createBundle({
    required String name,
    required String sessions,
    required String validity,
    required String price,
    required String discount,
    required List<String> features,
  }) async {
    await _dio.post(
      createBundleEndpoint,
      data: {
        "price": int.parse(price),
        "discount": int.parse(discount),
        "bundle_name": name,
        "validity": validity,
        "sessions": sessions,
        "features": features,
      },
    );
  }

  Future<void> updateBundle({
    required String id,
    required String name,
    required String sessions,
    required String validity,
    required String price,
    required String discount,
    required List<String> features,
  }) async {
    await _dio.patch(
      '$updateBundleEndpoint/$id',
      data: {
        "price": int.parse(price),
        "discount": int.parse(discount),
        "bundle_name": name,
        "validity": validity,
        "sessions": sessions,
        "features": features,
      },
    );
  }

  Future<void> deleteBundle(String id) async {
    await _dio.delete('$deleteBundleEndpoint/$id');
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final response = await _dio.get(allTransactionsEndpoint);

    final List data = response.data['data'];

    return data
        .map<TransactionModel>(
          (e) => TransactionModel.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList();
  }

  Future<List<AdUserModel>> getAllUsers() async {
    final response = await _dio.get(allUsersEndpoint);

    final List data = response.data['data'] ?? [];

    return data
        .map<AdUserModel>(
          (e) => AdUserModel.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList();
  }

  Future<Map<String, dynamic>> blockUser(String id) async {
    final response = await _dio.patch('$adminBlockEndpoint/$id');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<void> unblockUser(String id) async {
    await _dio.patch('/admin/unblock/$id');
  }

  Future<ChatMessageModel> sendMessage({
    required String sessionId,
    required String message,
  }) async {
    final response = await _dio.post(
      '/chat/$sessionId/messages',
      data: {"message": message},
    );

    return ChatMessageModel.fromJson(response.data['data']['message']);
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  TASK PROOF â€” /tasks/upload-proof
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Future<Map<String, dynamic>> uploadTaskProof({
    required String taskId,
    required File proofFile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    // Sanitize filename â€” multer rejects filenames with spaces
    final rawName = proofFile.path.replaceAll('\\', '/').split('/').last;
    final ext = rawName.contains('.')
        ? rawName.split('.').last.toLowerCase()
        : '';
    final fileName = rawName
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^\w.\-]'), '_');
    final mimeType = _guessMimeType(ext);
    final endpoint = '$tasksEndpoint/upload-proof/$taskId';

    debugPrint(
      '[UploadProof] â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•',
    );
    debugPrint('[UploadProof] taskId    â†’ "$taskId"');
    debugPrint('[UploadProof] url       â†’ "$baseUrl$endpoint"');
    debugPrint('[UploadProof] rawName   â†’ "$rawName"');
    debugPrint('[UploadProof] cleanName â†’ "$fileName"');
    debugPrint('[UploadProof] mimeType  â†’ "$mimeType"');
    debugPrint(
      '[UploadProof] token     â†’ ${token.isEmpty ? "EMPTY/NULL" : "${token.substring(0, token.length.clamp(0, 30))}â€¦"}',
    );
    debugPrint(
      '[UploadProof] â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•',
    );

    if (token.isEmpty) throw Exception('auth_required');

    // â”€â”€ Auto-try every field name until one succeeds â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    // The server returns 500 for a wrong field name because multer leaves
    // req.file undefined and the route handler crashes.  We probe each name
    // in order and stop at the first non-500 response.
    const fieldNames = ['proof', 'proofFile', 'file', 'media', 'proofFiles'];

    DioException? lastDioError;

    for (int i = 0; i < fieldNames.length; i++) {
      final field = fieldNames[i];
      debugPrint(
        '[UploadProof] â”€â”€ attempt ${i + 1}/${fieldNames.length}  field="$field"',
      );

      // Create a fresh MultipartFile each attempt â€” the stream is consumed
      // after the first POST so we cannot reuse the same instance.
      final mp = await MultipartFile.fromFile(
        proofFile.path,
        filename: fileName,
      );
      final formData = FormData.fromMap({field: mp});

      try {
        final response = await _dio.post(
          endpoint,
          data: formData,
          // âš ï¸ Do NOT set Content-Type manually â€” Dio adds the multipart
          //    boundary automatically.  Overriding it strips the boundary
          //    and causes an unparseable body â†’ 500 on the server.
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
        debugPrint(
          '[UploadProof] âœ“ SUCCESS  field="$field"  status=${response.statusCode}',
        );
        debugPrint('[UploadProof] response â†’ ${response.data}');
        return response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : {'data': response.data};
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        final body = e.response?.data;
        debugPrint(
          '[UploadProof] âœ—  field="$field"  HTTP $status  body=$body',
        );

        lastDioError = e;

        // Only retry on 500 â€” all other status codes are definitive answers
        if (status != 500) {
          _throwUploadException(status, body);
          rethrow;
        }
        // 500 with last field name â†’ give up and throw
        if (i == fieldNames.length - 1) {
          debugPrint(
            '[UploadProof] All field names exhausted â€” this is a backend error.',
          );
          _throwUploadException(status, body);
        }
        // 500 â†’ try next field name
      }
    }

    // Should never reach here, but satisfies the compiler
    throw lastDioError ?? Exception('upload_failed:Unknown error');
  }

  void _throwUploadException(int? status, dynamic body) {
    String backendMsg = '';
    if (body is Map) {
      backendMsg = (body['message'] ?? body['error'] ?? body['msg'] ?? '')
          .toString()
          .trim();
    } else if (body is String) {
      backendMsg = body.trim();
    }

    if (status == 500) {
      throw Exception(
        'upload_error_500:${backendMsg.isNotEmpty ? backendMsg : 'Internal server error'}',
      );
    }
    if (status == 403) throw Exception('forbidden_403');
    if (status == 401) throw Exception('auth_required');
    if (status == 400 || status == 422) {
      throw Exception(
        'upload_bad_request:${backendMsg.isNotEmpty ? backendMsg : 'Bad request'}',
      );
    }
    if (backendMsg.isNotEmpty) throw Exception('upload_failed:$backendMsg');
    throw Exception('upload_failed:HTTP $status');
  }

  static String _guessMimeType(String ext) {
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'avi':
        return 'video/x-msvideo';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  TASK PROGRESS â€” /booking/:bookingId/progress
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Future<Map<String, dynamic>> getTaskProgress(String bookingId) async {
    final url = '$bookingEndpoint/$bookingId/progress';
    debugPrint('REFRESH REQUEST URL: $baseUrl$url');
    final response = await _dio.get(url);
    debugPrint('REFRESH RESPONSE STATUS: ${response.statusCode}');
    debugPrint('REFRESH RESPONSE: ${response.data}');
    return response.data;
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  NOTIFICATIONS â€” /notifications
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Future<Map<String, dynamic>> getNotifications() async {
    final response = await _dio.get(notificationsEndpoint);
    return response.data;
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await _dio.get('/admin/dashboard/stats');

    return response.data;
  }

  Future<Map<String, dynamic>> getAllProviders() async {
    final response = await _dio.get(caregiverEndpoint);
    final data = response.data;
    if (data is Map) return Map<String, dynamic>.from(data);
    // fallback if the API returns a list directly
    return {'data': data};
  }

  Future<void> unblockProvider(String providerId) async {
    await _dio.patch('/admin/unblock/$providerId');
  }
}
