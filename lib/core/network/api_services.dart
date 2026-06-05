import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class ApiService {

  Future<String> _getToken() async {
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getString('token') ?? '';
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhMjJiZmRlZmU4NjVmZDExODYyZmE2MCIsInJvbGUiOiJjbGllbnQiLCJpYXQiOjE3ODA2NjIyNDR9.C_ySfnHWrfRAb2sWRtYvFV9b-W44Qmyx3HoWUaUWWFE';
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Map<String, String> get _publicHeaders => {
        'Content-Type': 'application/json',
      };

  // ── USER AUTH ─────────────────────────────────────────────

  Future<Map<String, dynamic>> signupClient({
    required String fullName,
    required String email,
    required String password,
    required String passwordConfirmation,
    File? profilePicture,
    File? nationalId,
  }) async {
    var request = http.MultipartRequest(
      'POST', Uri.parse('$baseUrl$signupEndpoint'),
    );
    request.fields['full_name']            = fullName;
    request.fields['email']                = email;
    request.fields['password']             = password;
    request.fields['passwordConfirmation'] = passwordConfirmation;
    if (profilePicture != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profile_picture', profilePicture.path));
    }
    if (nationalId != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'national_id', nationalId.path));
    }
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> loginClient({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$loginEndpoint'),
      headers: _publicHeaders,
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == 'success') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['data']);
    }
    return data;
  }

  Future<Map<String, dynamic>> logout() async {
    final response = await http.post(
      Uri.parse('$baseUrl$logoutEndpoint'),
      headers: await _authHeaders(),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl$forgotPasswordEndpoint'),
      headers: _publicHeaders,
      body: jsonEncode({'email': email}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/userlog/resetpassword/$token'),
      headers: _publicHeaders,
      body: jsonEncode({
        'password': password,
        'passwordConfirmation': passwordConfirmation,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updatePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl$updatePasswordEndpoint'),
      headers: await _authHeaders(),
      body: jsonEncode({
        'currentPassword': currentPassword,
        'password': password,
        'passwordConfirmation': passwordConfirmation,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/userlog/$userId'),
    );
    return jsonDecode(response.body);
  }

  // ── CAREGIVER ─────────────────────────────────────────────

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
    var request = http.MultipartRequest(
      'POST', Uri.parse('$baseUrl$caregiverSignupEndpoint'),
    );
    request.fields['full_name']            = fullName;
    request.fields['email']                = email;
    request.fields['password']             = password;
    request.fields['passwordConfirmation'] = passwordConfirmation;
    if (speciality   != null) request.fields['speciality']   = speciality;
    if (price        != null) request.fields['price']        = price.toString();
    if (availability != null) request.fields['availability'] = availability;
    if (experience   != null) request.fields['experience']   = experience;
    if (profilePicture != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profile_picture', profilePicture.path));
    }
    for (final f in certifications ?? []) {
      request.files.add(await http.MultipartFile.fromPath('certifications', f.path));
    }
    for (final f in verificationDocuments ?? []) {
      request.files.add(await http.MultipartFile.fromPath('verifcation_documents', f.path));
    }
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getAllCaregivers({
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse('$baseUrl$caregiverEndpoint')
        .replace(queryParameters: queryParams);
    final response = await http.get(uri);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getCaregiverById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl$caregiverEndpoint/$id'),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateCaregiver(
      String id, Map<String, dynamic> fields) async {
    final response = await http.patch(
      Uri.parse('$baseUrl$caregiverEndpoint/$id'),
      headers: await _authHeaders(),
      body: jsonEncode(fields),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> deleteCaregiver(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$caregiverEndpoint/$id'),
      headers: await _authHeaders(),
    );
    return jsonDecode(response.body);
  }

  // ── SERVICES ──────────────────────────────────────────────

  Future<Map<String, dynamic>> getAllServices() async {
    final response = await http.get(Uri.parse('$baseUrl$servicesEndpoint'));
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getServiceById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl$servicesEndpoint/$id'),
    );
    return jsonDecode(response.body);
  }

  // ── REQUESTS ──────────────────────────────────────────────

  Future<Map<String, dynamic>> createRequest({
    required String serviceId,
    required String location,
    required String date,
    required String time,
    String? duration,
    String? notes,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$requestEndpoint'),
      headers: await _authHeaders(),
      body: jsonEncode({
        'service': serviceId,
        'location': location,
        'date': date,
        'time': time,
        if (duration != null) 'duration': duration,
        if (notes    != null) 'notes': notes,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getMyRequests() async {
    final response = await http.get(
      Uri.parse('$baseUrl$requestEndpoint'),
      headers: await _authHeaders(),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getAvailableRequests() async {
    final response = await http.get(
      Uri.parse('$baseUrl$availableRequestsEndpoint'),
      headers: await _authHeaders(),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getRequestById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl$requestEndpoint/$id'),
      headers: await _authHeaders(),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getOffersOnRequest(String requestId) async {
    final response = await http.get(
      Uri.parse('$baseUrl$requestEndpoint/$requestId/offers'),
      headers: await _authHeaders(),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> respondToRequest({
    required String requestId,
    required String action,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$requestEndpoint/$requestId/respond'),
      headers: await _authHeaders(),
      body: jsonEncode({'action': action}),
    );
    return jsonDecode(response.body);
  }

  // ── OFFERS ────────────────────────────────────────────────

  Future<Map<String, dynamic>> sendOffer({
    required String requestId,
    required num price,
    String? notes,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/offer/$requestId/offer'),
      headers: await _authHeaders(),
      body: jsonEncode({
        'price': price,
        if (notes != null) 'notes': notes,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> respondToOffer({
    required String offerId,
    required String status,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/offer/$offerId/respond'),
      headers: await _authHeaders(),
      body: jsonEncode({'status': status}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> deleteOffer(String offerId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/offer/$offerId'),
      headers: await _authHeaders(),
    );
    return jsonDecode(response.body);
  }

  // ── BOOKINGS ──────────────────────────────────────────────

  Future<Map<String, dynamic>> createBookingFromOffer(String offerId) async {
    final response = await http.post(
      Uri.parse('$baseUrl$bookingFromOfferEndpoint'),
      headers: await _authHeaders(),
      body: jsonEncode({'offerId': offerId}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getMyBookings() async {
    final response = await http.get(
      Uri.parse('$baseUrl$bookingEndpoint'),
      headers: await _authHeaders(),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getBookingById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl$bookingEndpoint/$id'),
      headers: await _authHeaders(),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> confirmAndPayBooking(String bookingId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/booking/confirmbookingandpay/$bookingId'),
      headers: await _authHeaders(),
    );
    return jsonDecode(response.body);
  }

  // ── PAYMENTS ──────────────────────────────────────────────

  Future<Map<String, dynamic>> createPayment({
    required num amount,
    required String paymentMethod,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$createPaymentEndpoint'),
      headers: await _authHeaders(),
      body: jsonEncode({
        'amount': amount,
        'paymentMethod': paymentMethod,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> payBookingFromWallet(String bookingId) async {
    final response = await http.post(
      Uri.parse('$baseUrl$payBookingWalletEndpoint'),
      headers: await _authHeaders(),
      body: jsonEncode({'bookingId': bookingId}),
    );
    return jsonDecode(response.body);
  }

  // ── WALLET ────────────────────────────────────────────────

  Future<Map<String, dynamic>> createWallet(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl$walletEndpoint'),
      headers: await _authHeaders(),
      body: jsonEncode({'userlog': userId}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getWalletById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl$walletEndpoint/$id'),
      headers: await _authHeaders(),
    );
    return jsonDecode(response.body);
  }

  // ── REVIEWS ───────────────────────────────────────────────

  Future<Map<String, dynamic>> createReview({
    required String caregiverId,
    required String serviceId,
    required String requestId,
    required int rating,
    required String review,
    String? feedback,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$reviewEndpoint'),
      headers: await _authHeaders(),
      body: jsonEncode({
        'caregiver': caregiverId,
        'service':   serviceId,
        'request':   requestId,
        'rating':    rating,
        'review':    review,
        if (feedback != null) 'feedback': feedback,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getReviewById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl$reviewEndpoint/$id'),
      headers: await _authHeaders(),
    );
    return jsonDecode(response.body);
  }

  // ── BUNDLES ───────────────────────────────────────────────

  Future<Map<String, dynamic>> getAllBundles() async {
    final response = await http.get(Uri.parse('$baseUrl$bundleEndpoint'));
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getBundleById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl$bundleEndpoint/$id'),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> chooseBundle(String bundleId) async {
    final response = await http.post(
      Uri.parse('$baseUrl$clientBundleEndpoint'),
      headers: await _authHeaders(),
      body: jsonEncode({'bundleId': bundleId}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> payBundle(String clientBundleId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl$clientBundleEndpoint/$clientBundleId'),
      headers: await _authHeaders(),
    );
    return jsonDecode(response.body);
  }

  // ── AI CHAT ───────────────────────────────────────────────

  Future<Map<String, dynamic>> sendChatMessage({
    required String message,
    String? sessionId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$chatMessageEndpoint'),
      headers: await _authHeaders(),
      body: jsonEncode({
        'message': message,
        if (sessionId != null) 'sessionId': sessionId,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getChatHistory({String? sessionId}) async {
    final uri = Uri.parse('$baseUrl$chatHistoryEndpoint').replace(
      queryParameters: sessionId != null ? {'sessionId': sessionId} : null,
    );
    final response = await http.get(uri, headers: await _authHeaders());
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getChatSessions() async {
    final response = await http.get(
      Uri.parse('$baseUrl$chatSessionsEndpoint'),
      headers: await _authHeaders(),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> startNewChatSession() async {
    final response = await http.post(
      Uri.parse('$baseUrl$newChatSessionEndpoint'),
      headers: await _authHeaders(),
    );
    return jsonDecode(response.body);
  }

  // ── TASKS ─────────────────────────────────────────────────

  Future<Map<String, dynamic>> getAllTasks() async {
    final response = await http.get(
      Uri.parse('$baseUrl$tasksEndpoint'),
      headers: await _authHeaders(),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getTaskById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl$tasksEndpoint/$id'),
      headers: await _authHeaders(),
    );
    return jsonDecode(response.body);
  }
  Future<Map<String, dynamic>> createTask({
  required String description,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl$tasksEndpoint'),
    headers: await _authHeaders(),
    body: jsonEncode({
      'taskDescription': description,
      'taskTitle':       description,
      'taskID':          DateTime.now().millisecondsSinceEpoch.toString(),
      'proofUrl':        '',
    }),
  );
  return jsonDecode(response.body);
}
}