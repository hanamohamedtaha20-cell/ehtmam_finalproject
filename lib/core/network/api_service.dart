import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';


class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

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
        onError: (error, handler) {
          print("API ERROR: ${error.response?.data}");
          handler.next(error);
        },
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  //  USER AUTH — /userlog
  // ══════════════════════════════════════════════════════════

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
      'full_name':            fullName,
      'email':                email,
      'password':             password,
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
  final response = await _dio.post(
    endpoint,
    data: formData,
  );
  return response.data;
}

  Future<Map<String, dynamic>> logout() async {
    final response = await _dio.post(logoutEndpoint);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    return response.data;
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await _dio.post(
      forgotPasswordEndpoint,
      data: {'email': email},
      options: Options(headers: {'Authorization': null}),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _dio.patch(
      '/userlog/resetpassword/$token',
      data: {
        'password':             password,
        'passwordConfirmation': passwordConfirmation,
      },
      options: Options(headers: {'Authorization': null}),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> updatePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _dio.patch(
      updatePasswordEndpoint,
      data: {
        'currentPassword':      currentPassword,
        'password':             password,
        'passwordConfirmation': passwordConfirmation,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final response = await _dio.get('/userlog/$userId');
    return response.data;
  }
  // ══════════════════════════════════════════════════════════
  //  CAREGIVER — /caregiver
  // ══════════════════════════════════════════════════════════

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
      'full_name':            fullName,
      'email':                email,
      'password':             password,
      'passwordConfirmation': passwordConfirmation,
      if (speciality   != null) 'speciality':   speciality,
      if (price        != null) 'price':        price.toString(),
      if (availability != null) 'availability': availability,
      if (experience   != null) 'experience':   experience,
      if (profilePicture != null)
        'profile_picture': await MultipartFile.fromFile(profilePicture.path),
    };
    if (certifications != null) {
      map['certifications'] = [
        for (final f in certifications) await MultipartFile.fromFile(f.path)
      ];
    }
    if (verificationDocuments != null) {
      map['verifcation_documents'] = [
        for (final f in verificationDocuments) await MultipartFile.fromFile(f.path)
      ];
    }
    final response = await _dio.post(
      caregiverSignupEndpoint,
      data: FormData.fromMap(map),
    );
    return response.data;
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
    return response.data;
  }

  Future<Map<String, dynamic>> updateCaregiver(
      String id, Map<String, dynamic> fields) async {
    final response = await _dio.patch('$caregiverEndpoint/$id', data: fields);
    return response.data;
  }

  Future<Map<String, dynamic>> deleteCaregiver(String id) async {
    final response = await _dio.delete('$caregiverEndpoint/$id');
    return response.data;
  }

  // ══════════════════════════════════════════════════════════
  //  SERVICES — /services
  // ══════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> getAllServices() async {
    final response = await _dio.get(
      servicesEndpoint,
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

  // ══════════════════════════════════════════════════════════
  //  REQUESTS — /request
  // ══════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> createRequest({
    required String serviceId,
    required String governorate,
    required String date,
    required String time,
    String? duration,
    String? notes,
    String? budget,
  }) async {
    final parsedBudget =
        budget != null && budget.isNotEmpty ? num.tryParse(budget) : null;

    final response = await _dio.post(requestEndpoint, data: {
      'service':     serviceId,
      'governorate': governorate,
      'date':        date,
      'time':        time,
      if (duration != null && duration.isNotEmpty) 'duration': duration,
      if (notes    != null && notes.isNotEmpty)    'notes':    notes,
      if (parsedBudget != null)                    'budget':   parsedBudget,
    });
    return response.data;
  }
  Future<Map<String, dynamic>> getMyRequests() async {
    try {
      final response = await _dio.get(requestEndpoint);
      print("GET MY REQUESTS SUCCESS => ${response.data}");
      return response.data;
    } on DioException catch (e) {
      print("GET MY REQUESTS ERROR STATUS => ${e.response?.statusCode}");
      print("GET MY REQUESTS ERROR DATA => ${e.response?.data}");
      print("GET MY REQUESTS ERROR MESSAGE => ${e.message}");
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

  // ══════════════════════════════════════════════════════════
  //  OFFERS — /offer
  // ══════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> sendOffer({
    required String requestId,
    required num price,
    String? notes,
  }) async {
    final response = await _dio.post(
      '/offer/$requestId/offer',
      data: {
        'price': price,
        if (notes != null) 'notes': notes,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> respondToOffer({
    required String offerId,
    required String status,
  }) async {
    final response = await _dio.patch(
      '/offer/$offerId/respond',
      data: {'status': status},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> deleteOffer(String offerId) async {
    final response = await _dio.delete('/offer/$offerId');
    return response.data;
  }

  // ══════════════════════════════════════════════════════════
  //  BOOKINGS — /booking
  // ══════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> createBookingFromOffer(String offerId) async {
    final response = await _dio.post(
      bookingFromOfferEndpoint,
      data: {'offerId': offerId},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getMyBookings() async {
    final response = await _dio.get(bookingEndpoint);
    return response.data;
  }

  Future<Map<String, dynamic>> getBookingById(String id) async {
    final response = await _dio.get('$bookingEndpoint/$id');
    return response.data;
  }

  Future<Map<String, dynamic>> confirmAndPayBooking(String bookingId) async {
    final response = await _dio.patch('/booking/confirmbookingandpay/$bookingId');
    return response.data;
  }

  Future<Map<String, dynamic>> deleteBooking(String bookingId) async {
  final response = await _dio.delete('$bookingEndpoint/$bookingId');
  return response.data;
}

  // ══════════════════════════════════════════════════════════
  //  PAYMENTS — /payment
  // ══════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> createPayment({
    required num amount,
    required String paymentMethod,
  }) async {
    final response = await _dio.post(createPaymentEndpoint, data: {
      'amount':        amount,
      'paymentMethod': paymentMethod,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> payBookingFromWallet(String bookingId) async {
    final response = await _dio.post(
      payBookingWalletEndpoint,
      data: {'bookingId': bookingId},
    );
    return response.data;
  }

  // ══════════════════════════════════════════════════════════
  //  WALLET — /wallet
  // ══════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> createWallet(String userId) async {
    final response = await _dio.post(
      walletEndpoint,
      data: {'userlog': userId},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getWalletById(String id) async {
    print("malak");
    final response = await _dio.get(
      walletEndpoint
    );
    print(response);
    return response.data;
  }

  // ══════════════════════════════════════════════════════════
  //  REVIEWS — /review
  // ══════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> createReview({
    required String caregiverId,
    required String serviceId,
    required String requestId,
    required int rating,
    required String review,
    String? feedback,
  }) async {
    final response = await _dio.post(reviewEndpoint, data: {
      'caregiver': caregiverId,
      'service':   serviceId,
      'request':   requestId,
      'rating':    rating,
      'review':    review,
      if (feedback != null) 'feedback': feedback,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> getReviewById(String id) async {
    final response = await _dio.get('$reviewEndpoint/$id');
    return response.data;
  }

  // ══════════════════════════════════════════════════════════
  //  BUNDLES — /bundle & /clientbundle
  // ══════════════════════════════════════════════════════════

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

  Future<Map<String, dynamic>> payBundle(String clientBundleId) async {
    final response = await _dio.patch('$clientBundleEndpoint/$clientBundleId');
    return response.data;
  }

  // ══════════════════════════════════════════════════════════
  //  AI CHAT — /chat
  // ══════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> sendChatMessage({
    required String message,
    String? sessionId,
  }) async {
    final response = await _dio.post(chatMessageEndpoint, data: {
      'message': message,
      if (sessionId != null) 'sessionId': sessionId,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> getChatHistory({String? sessionId}) async {
    final response = await _dio.get(
      chatHistoryEndpoint,
      queryParameters: sessionId != null ? {'sessionId': sessionId} : null,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getChatSessions() async {
    final response = await _dio.get(chatSessionsEndpoint);
    return response.data;
  }

  Future<Map<String, dynamic>> startNewChatSession() async {
    final response = await _dio.post(newChatSessionEndpoint);
    return response.data;
  }

  // ══════════════════════════════════════════════════════════
  //  TASKS — /tasks
  // ══════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> getAllTasks() async {
    final response = await _dio.get(tasksEndpoint);
    return response.data;
  }

  Future<Map<String, dynamic>> getTaskById(String id) async {
    final response = await _dio.get('$tasksEndpoint/$id');
    return response.data;
  }

  Future<List<dynamic>> getTasksByRequestId(String requestId) async {
    final response = await _dio.get('$tasksEndpoint/$requestId');
    final data = response.data;
    if (data is List) return data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    return [];
  }

  Future<Map<String, dynamic>> createTask({
    required String description,
  }) async {
    final response = await _dio.post(tasksEndpoint, data: {
      'taskDescription': description,
      'taskTitle':       description,
      'taskID':          DateTime.now().millisecondsSinceEpoch.toString(),
      'proofUrl':        '',
    });
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
}