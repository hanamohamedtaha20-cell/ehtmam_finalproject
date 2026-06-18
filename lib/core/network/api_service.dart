import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/admin_features/data/bundle_model.dart';
import '../../features/admin_features/data/transaction_model.dart';
import '../../features/admin_users_screen/model/AD_user_model.dart';
import '../../features/home_screen/data/model/chat_message_model.dart';
import 'api_constants.dart';


class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 180),
      receiveTimeout: const Duration(seconds: 180),
      sendTimeout: const Duration(seconds: 180),
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
      options: Options(
        contentType: 'multipart/form-data',
        headers: {
          'Authorization': null,
        },
      ),
    );

    return Map<String, dynamic>.from(response.data as Map);
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
    print('CAREGIVER BY ID: ${response.data}');
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
    required num budget,
    required List<String> tasks,
    String? description,
    String? duration,
    String? notes,
  }) async {
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

  // ══════════════════════════════════════════════════════════
  //  BOOKINGS — /booking
  // ══════════════════════════════════════════════════════════

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
    final response = await _dio.get('$bookingEndpoint/$bookingId/location');
    return response.data;
  }

  Future<Map<String, dynamic>> updateCaregiverLocation({
    required String bookingId,
    required double latitude,
    required double longitude,
  }) async {
    final response = await _dio.post(
      '$bookingEndpoint/$bookingId/location',
      data: {'latitude': latitude, 'longitude': longitude},
    );
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
    print('FULL RESPONSE: ${response.data}');


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
  Future<Map<String, dynamic>> getMyWallet() async {
  final response = await _dio.get(myWalletEndpoint);
  return response.data;
}

  // ══════════════════════════════════════════════════════════
  //  REVIEWS — /review
  // ══════════════════════════════════════════════════════════

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

  Future<Map<String, dynamic>> payBundle(String bundleId) async {
    final response = await _dio.post('$clientBundlePayEndpoint/$bundleId');
    return response.data;
  }

  // ══════════════════════════════════════════════════════════
  //  AI CHAT — /chat
  // ══════════════════════════════════════════════════════════

  // POST /chat → { success, data: { sessionId, title, createdAt } }
  Future<String> createChatSession() async {
    final response = await _dio.post('/chat');
    return response.data['data']['sessionId'] as String;
  }

  // POST /chat/:sessionId/messages → { success, data: { sessionId, message: { role, content } } }
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

  // ══════════════════════════════════════════════════════════
  //  TASKS — /tasks
  // ══════════════════════════════════════════════════════════

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

    print('[MyTasks] bookingId → "$bookingId"');
    print('[MyTasks] URL     → ${baseUrl}$bookingEndpoint/$bookingId/tasks');
    print('[MyTasks] token   → ${token.isEmpty ? "EMPTY/NULL — will 403" : "${token.substring(0, token.length.clamp(0, 24))}…"}');

    if (token.isEmpty) {
      throw Exception('auth_required');
    }

    try {
      final response = await _dio.get('$bookingEndpoint/$bookingId/tasks');
      print('[MyTasks] status  → ${response.statusCode}');
      final data = response.data;
      if (data is Map && data['data'] is List) return data['data'] as List;
      if (data is List) return data;
      return [];
    } on DioException catch (e) {
      print('[MyTasks] error   → HTTP ${e.response?.statusCode}: ${e.response?.data}');
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

  /// Adds a caregiver-created task to a specific booking.
  /// POST /booking/{bookingId}/tasks
  Future<Map<String, dynamic>> addCaregiverTask({
    required String bookingId,
    required String taskName,
  }) async {
    final response = await _dio.post(
      '$bookingEndpoint/$bookingId/tasks',
      data: {
        'taskName': taskName,
        'taskDescription': taskName,
      },
    );
    return response.data;
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
      data: {
        'reason': reason,
      },
    );

    return Map<String, dynamic>.from(response.data as Map);
  }
  Future<Map<String, dynamic>> blockProvider(
      String id,
      ) async {
    final response = await _dio.patch(
      '$adminBlockEndpoint/$id',
    );

    return Map<String, dynamic>.from(
      response.data as Map,
    );
  }
  Future<Map<String, dynamic>> getComplaints() async {
    final response = await _dio.get(
      '/admin/complaints',
    );

    return Map<String, dynamic>.from(
      response.data as Map,
    );
  }
  Future<List<BundleModel>> getBundles() async {
    final response = await _dio.get(
      bundleEndpoint,
    );

    final List<dynamic> data =
        response.data['data'] ?? [];

    return data
        .map<BundleModel>(
          (e) => BundleModel.fromJson(
        Map<String, dynamic>.from(e),
      ),
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
  Future<void> deleteBundle(
      String id,
      ) async {
    await _dio.delete(
      '$deleteBundleEndpoint/$id',
    );

  }
  Future<List<TransactionModel>>
  getAllTransactions() async {

    final response = await _dio.get(
      allTransactionsEndpoint,
    );

    final List data =
    response.data['data'];

    return data
        .map<TransactionModel>(
          (e) => TransactionModel.fromJson(
        Map<String, dynamic>.from(e),
      ),
    )
        .toList();
  }
  Future<List<AdUserModel>> getAllUsers() async {
    final response = await _dio.get(
      allUsersEndpoint,
    );

    final List data =
        response.data['data'] ?? [];

    return data
        .map<AdUserModel>(
          (e) => AdUserModel.fromJson(
        Map<String, dynamic>.from(e),
      ),
    )
        .toList();
  }
  Future<Map<String, dynamic>> blockUser(String id) async {
    final response = await _dio.patch('$adminBlockEndpoint/$id');
    return Map<String, dynamic>.from(response.data as Map);
  }
  Future<ChatMessageModel> sendMessage({
    required String sessionId,
    required String message,
  }) async {
    final response = await _dio.post(
      '/chat/$sessionId/messages',
      data: {
        "message": message,
      },
    );

    return ChatMessageModel.fromJson(
      response.data['data']['message'],
    );
  }

  // ══════════════════════════════════════════════════════════
  //  TASK PROOF — /tasks/upload-proof
  // ══════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> uploadTaskProof({
    required String taskId,
    required File proofFile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    // Sanitize filename — multer rejects filenames with spaces
    final rawName  = proofFile.path.replaceAll('\\', '/').split('/').last;
    final ext      = rawName.contains('.') ? rawName.split('.').last.toLowerCase() : '';
    final fileName = rawName
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^\w.\-]'), '_');
    final mimeType = _guessMimeType(ext);
    final endpoint = '$tasksEndpoint/upload-proof/$taskId';

    print('[UploadProof] ══════════════════════════════════════════════');
    print('[UploadProof] taskId    → "$taskId"');
    print('[UploadProof] url       → "$baseUrl$endpoint"');
    print('[UploadProof] rawName   → "$rawName"');
    print('[UploadProof] cleanName → "$fileName"');
    print('[UploadProof] mimeType  → "$mimeType"');
    print('[UploadProof] token     → ${token.isEmpty ? "EMPTY/NULL" : "${token.substring(0, token.length.clamp(0, 30))}…"}');
    print('[UploadProof] ══════════════════════════════════════════════');

    if (token.isEmpty) throw Exception('auth_required');

    // ── Auto-try every field name until one succeeds ──────────────────────
    // The server returns 500 for a wrong field name because multer leaves
    // req.file undefined and the route handler crashes.  We probe each name
    // in order and stop at the first non-500 response.
    const fieldNames = ['proof', 'proofFile', 'file', 'media', 'proofFiles'];

    DioException? lastDioError;

    for (int i = 0; i < fieldNames.length; i++) {
      final field = fieldNames[i];
      print('[UploadProof] ── attempt ${i + 1}/${fieldNames.length}  field="$field"');

      // Create a fresh MultipartFile each attempt — the stream is consumed
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
          // ⚠️ Do NOT set Content-Type manually — Dio adds the multipart
          //    boundary automatically.  Overriding it strips the boundary
          //    and causes an unparseable body → 500 on the server.
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
        print('[UploadProof] ✓ SUCCESS  field="$field"  status=${response.statusCode}');
        print('[UploadProof] response → ${response.data}');
        return response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : {'data': response.data};
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        final body   = e.response?.data;
        print('[UploadProof] ✗  field="$field"  HTTP $status  body=$body');

        lastDioError = e;

        // Only retry on 500 — all other status codes are definitive answers
        if (status != 500) {
          _throwUploadException(status, body);
          rethrow;
        }
        // 500 with last field name → give up and throw
        if (i == fieldNames.length - 1) {
          print('[UploadProof] All field names exhausted — this is a backend error.');
          _throwUploadException(status, body);
        }
        // 500 → try next field name
      }
    }

    // Should never reach here, but satisfies the compiler
    throw lastDioError ?? Exception('upload_failed:Unknown error');
  }

  void _throwUploadException(int? status, dynamic body) {
    String backendMsg = '';
    if (body is Map) {
      backendMsg =
          (body['message'] ?? body['error'] ?? body['msg'] ?? '').toString().trim();
    } else if (body is String) {
      backendMsg = body.trim();
    }

    if (status == 500) {
      throw Exception(
          'upload_error_500:${backendMsg.isNotEmpty ? backendMsg : 'Internal server error'}');
    }
    if (status == 403) throw Exception('forbidden_403');
    if (status == 401) throw Exception('auth_required');
    if (status == 400 || status == 422) {
      throw Exception(
          'upload_bad_request:${backendMsg.isNotEmpty ? backendMsg : 'Bad request'}');
    }
    if (backendMsg.isNotEmpty) throw Exception('upload_failed:$backendMsg');
    throw Exception('upload_failed:HTTP $status');
  }

  static String _guessMimeType(String ext) {
    switch (ext) {
      case 'jpg':
      case 'jpeg': return 'image/jpeg';
      case 'png':  return 'image/png';
      case 'gif':  return 'image/gif';
      case 'webp': return 'image/webp';
      case 'mp4':  return 'video/mp4';
      case 'mov':  return 'video/quicktime';
      case 'avi':  return 'video/x-msvideo';
      case 'pdf':  return 'application/pdf';
      default:     return 'application/octet-stream';
    }
  }

  // ══════════════════════════════════════════════════════════
  //  TASK PROGRESS — /booking/:bookingId/progress
  // ══════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> getTaskProgress(String bookingId) async {
    final response = await _dio.get('$bookingEndpoint/$bookingId/progress');
    return response.data;
  }

  // ══════════════════════════════════════════════════════════
  //  NOTIFICATIONS — /notifications
  // ══════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> getNotifications() async {
    final response = await _dio.get(notificationsEndpoint);
    return response.data;
  }
}
