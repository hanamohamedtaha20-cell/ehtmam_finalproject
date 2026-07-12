import 'package:flutter/foundation.dart';
import '../../../../core/network/api_service.dart';
import '../model/booking_details_model.dart';

abstract class BookingRemoteDatasource {
  Future<BookingDetailsModel> getBookingDetails(String bookingId);
  Future<BookingDetailsModel> getRequestDetails(String requestId);
  Future<List<TaskModel>> getTasks(String requestId);
  Future<List<TaskModel>> getTasksByBookingId(String bookingId);
  Future<void> updateTask(String taskId, bool completed);
  Future<Map<String, dynamic>> sendOffer({
    required String requestId,
    required num price,
    String? notes,
  });
}

class BookingRemoteDataSourceImpl implements BookingRemoteDatasource {
  final ApiService apiService;

  BookingRemoteDataSourceImpl(this.apiService);

  Future<BookingDetailsModel> _enrichWithClientProfile(
    BookingDetailsModel details,
    Map<String, dynamic> rawData,
  ) async {
    final clientField = rawData['client'] ??
        (rawData['request'] is Map ? rawData['request']['client'] : null);

    // ── LAYER 2 TRACE ─────────────────────────────────────────────────────────
    debugPrint('[EnrichProfile][L2] clientField type: ${clientField?.runtimeType}  value: $clientField');
    debugPrint('[EnrichProfile][L2] details.phone BEFORE enrich: "${details.phone}"');
    debugPrint('[EnrichProfile][L2] details.clientBudget BEFORE enrich: ${details.clientBudget}');
    debugPrint('[EnrichProfile][L2] details.caregiverBudget BEFORE enrich: ${details.caregiverBudget}');
    // ─────────────────────────────────────────────────────────────────────────

    // Determine which client ID to use for the profile fetch.
    //
    // Three cases:
    //   A) clientField is a String (bare ID)  → use it directly.
    //   B) clientField is a Map WITH phone    → already complete, skip fetch.
    //   C) clientField is a Map WITHOUT phone → backend returned a partial
    //      object; extract _id and fetch the full profile.
    String? clientIdForEnrich;
    if (clientField is String && clientField.isNotEmpty) {
      clientIdForEnrich = clientField;
      debugPrint('[EnrichProfile][L2] Case A: client is a String ID → will fetch profile');
    } else if (clientField is Map) {
      if (details.phone.isEmpty) {
        clientIdForEnrich = clientField['_id']?.toString();
        debugPrint('[EnrichProfile][L2] Case C: client is partial Map (no phone) → will fetch profile using _id: $clientIdForEnrich');
      } else {
        debugPrint('[EnrichProfile][L2] Case B: client Map is complete (phone="${details.phone}") → skipping fetch');
        return details;
      }
    } else {
      debugPrint('[EnrichProfile][L2] clientField is null/unknown → skipping enrichment');
      return details;
    }

    if (clientIdForEnrich == null || clientIdForEnrich.isEmpty) {
      debugPrint('[EnrichProfile][L2] no valid client _id found → skipping enrichment');
      return details;
    }

    try {
      debugPrint('[EnrichProfile][L2] Fetching user profile for id: $clientIdForEnrich');
      final response = await apiService.getUserProfile(clientIdForEnrich);
      final rawProfile = response['data'];
      final profile = rawProfile is Map<String, dynamic> ? rawProfile : <String, dynamic>{};
      final address = profile['address'] is Map ? profile['address'] as Map : <String, dynamic>{};

      final picture = profile['profile_picture']?.toString() ??
          profile['profilePicture']?.toString() ??
          profile['avatar']?.toString() ??
          '';
      final rating = ((profile['rating'] ?? profile['averageRating'] ?? 0) as num).toDouble();

      debugPrint('[ClientProfile][L2] profile keys: ${profile.keys.toList()}');
      debugPrint('[ClientProfile][L2] phoneNumber=${profile['phoneNumber']}  phone=${profile['phone']}  phone_number=${profile['phone_number']}');
      debugPrint('[ClientProfile][L2] full_name=${profile['full_name']}  email=${profile['email']}');
      debugPrint('[ClientProfile][L2] profile_picture=$picture  rating=$rating');

      final enriched = details.copyWith(
        clientName: profile['full_name']?.toString() ?? details.clientName,
        phone: profile['phoneNumber']?.toString() ??
            profile['phone']?.toString() ??
            profile['phone_number']?.toString() ??
            profile['mobile']?.toString() ??
            profile['mobileNumber']?.toString() ??
            details.phone,
        email: profile['email']?.toString() ?? details.email,
        street: address['street']?.toString() ?? details.street,
        building: address['building']?.toString() ?? details.building,
        clientProfilePicture: picture.isNotEmpty ? picture : details.clientProfilePicture,
        rating: rating > 0 ? rating : details.rating,
      );
      debugPrint('[EnrichProfile][L2] phone AFTER enrich: "${enriched.phone}"');
      return enriched;
    } catch (e, st) {
      debugPrint('[EnrichProfile][L2] ERROR fetching profile — phone will remain "${details.phone}": $e\n$st');
      return details;
    }
  }

  @override
  Future<BookingDetailsModel> getBookingDetails(String bookingId) async {
    final response = await apiService.getBookingById(bookingId);
    debugPrint('BOOKING_DETAILS_RAW_RESPONSE: $response');

    final raw = response['data'];
    final rawData = raw is Map<String, dynamic>
        ? raw
        : (raw is List && raw.isNotEmpty
            ? raw.first as Map<String, dynamic>
            : <String, dynamic>{});

    // Work on a mutable copy so we can populate unpopulated ID references.
    final data = Map<String, dynamic>.from(rawData);

    debugPrint('[BookingDS] data keys: ${data.keys.toList()}');
    debugPrint('[BookingDS] request field type: ${data['request']?.runtimeType} value: ${data['request']}');

    // Determine whether we need to fetch the full request separately.
    // Two cases that require a fetch:
    //   A) 'request' is a plain String ID (backend did not populate it).
    //   B) 'request' is already a Map, but the backend omitted Description
    //      from the populated sub-object (common for booking list endpoints).
    final requestField = data['request'];
    String? requestIdToFetch;

    if (requestField is String && requestField.isNotEmpty) {
      requestIdToFetch = requestField;
    } else if (requestField is Map) {
      final hasDescription = requestField['Description'] != null ||
          requestField['description'] != null;
      debugPrint('[BookingDS] request is Map — hasDescription: $hasDescription  keys: ${requestField.keys.toList()}');
      if (!hasDescription) {
        requestIdToFetch = requestField['_id']?.toString();
      }
    }

    if (requestIdToFetch != null && requestIdToFetch.isNotEmpty) {
      debugPrint('[BookingDS] fetching full request: $requestIdToFetch');
      try {
        final requestResult = await apiService.getRequestById(requestIdToFetch);
        final requestData = requestResult['data'];
        if (requestData is Map<String, dynamic>) {
          if (requestField is String) {
            // Case A: request was an unpopulated String ID.
            // Replace entirely — nothing to preserve.
            data['request'] = requestData;
            debugPrint('[BookingDS] Case A: request replaced with fetched data. keys: ${requestData.keys.toList()}');
          } else {
            // Case B: request is already a populated Map.
            // Merge so the ORIGINAL populated fields always win over the
            // less-populated version returned by getRequestById.
            // Order: { ...fetched, ...original } means original overwrites
            // any conflicting key, preserving client objects, caregiver
            // objects, budget, etc. Description is then set explicitly from
            // whichever source has it.
            final originalRequest = Map<String, dynamic>.from(requestField as Map);
            final fetchedRequest = requestData;

            debugPrint('[BookingDS] ORIGINAL REQUEST: $originalRequest');
            debugPrint('[BookingDS] FETCHED REQUEST: $fetchedRequest');
            debugPrint('[BookingDS] CLIENT BEFORE: ${originalRequest['client']}');
            debugPrint('[BookingDS] CAREGIVER BEFORE: ${originalRequest['caregiver']}');
            debugPrint('[BookingDS] BUDGET BEFORE: ${originalRequest['budget']}');

            final mergedRequest = <String, dynamic>{
              ...fetchedRequest,   // base: fetched fills gaps (e.g. Description)
              ...originalRequest,  // original overwrites: keeps populated objects
            };

            // Explicitly resolve Description from either source so it is
            // never lost regardless of which side has it.
            mergedRequest['Description'] =
                originalRequest['Description'] ??
                originalRequest['description'] ??
                fetchedRequest['Description'] ??
                fetchedRequest['description'];

            mergedRequest['description'] =
                originalRequest['description'] ??
                originalRequest['Description'] ??
                fetchedRequest['description'] ??
                fetchedRequest['Description'];

            data['request'] = mergedRequest;

            debugPrint('[BookingDS] MERGED REQUEST: $mergedRequest');
            debugPrint('[BookingDS] CLIENT AFTER: ${mergedRequest['client']}');
            debugPrint('[BookingDS] CAREGIVER AFTER: ${mergedRequest['caregiver']}');
            debugPrint('[BookingDS] BUDGET AFTER: ${mergedRequest['budget']}');
          }
          debugPrint('[BookingDS] request Description resolved: ${data['request']['Description'] ?? data['request']['description']}');
        }
      } catch (e) {
        debugPrint('[BookingDS] failed to fetch request: $e');
      }
    }

    // If 'offer' came back as a plain String ID, fetch it so the caregiver
    // budget (offer.price) can be extracted by fromBookingJson.
    final offerField = data['offer'];
    debugPrint('[BookingDS] offer field type: ${offerField?.runtimeType}  value: $offerField');
    if (offerField is String && offerField.isNotEmpty) {
      try {
        debugPrint('[BookingDS] fetching offer by id: $offerField');
        final offerResult = await apiService.getOfferById(offerField);
        final offerData = offerResult['data'] ?? offerResult;
        if (offerData is Map<String, dynamic>) {
          data['offer'] = offerData;
          debugPrint('[BookingDS] offer fetched: price=${offerData['price']}  keys=${offerData.keys.toList()}');
        }
      } catch (e) {
        debugPrint('[BookingDS] failed to fetch offer: $e');
      }
    }

    var details = BookingDetailsModel.fromBookingJson(data);
    return _enrichWithClientProfile(details, data);
  }

  @override
  Future<BookingDetailsModel> getRequestDetails(String requestId) async {
    final response = await apiService.getRequestById(requestId);
    debugPrint('REQUEST_DETAILS_RAW_RESPONSE: $response');

    final raw = response['data'];
    final data = raw is Map<String, dynamic>
        ? raw
        : (raw is List && raw.isNotEmpty
            ? raw.first as Map<String, dynamic>
            : <String, dynamic>{});

    debugPrint('[RequestDS] data keys: ${data.keys.toList()}');

    var details = BookingDetailsModel.fromRequestJson(data);

    // For ACCEPTED requests the caregiver's offer price is not in the request
    // document itself. Fetch the offers for this request and use the accepted
    // (or highest-status) one's price as caregiverBudget.
    if (details.caregiverBudget == 0) {
      try {
        final offersResponse = await apiService.getOffersOnRequest(requestId);
        final offersRaw = offersResponse['data'];
        final offersList = offersRaw is List
            ? offersRaw
            : (offersRaw is Map ? (offersRaw['offers'] ?? offersRaw['data'] ?? []) : []);

        debugPrint('[RequestDS] offers for request: ${offersList.length} offers');

        Map<String, dynamic>? acceptedOffer;
        for (final o in offersList) {
          if (o is! Map<String, dynamic>) continue;
          final offerStatus = (o['status'] ?? '').toString().toLowerCase();
          debugPrint('[RequestDS] offer: status=$offerStatus  price=${o['price']}  caregiver=${o['caregiver']}');
          if (offerStatus == 'accepted') {
            acceptedOffer = o;
            break;
          }
          // Fallback: pick any offer if none marked accepted yet
          acceptedOffer ??= o;
        }

        if (acceptedOffer != null) {
          final offerPrice = (acceptedOffer['price'] ?? acceptedOffer['amount'] ?? 0) as num;
          debugPrint('[RequestDS] accepted offer price: $offerPrice');
          if (offerPrice > 0) {
            details = details.copyWith(caregiverBudget: offerPrice.toDouble());
          }
        }
      } catch (e) {
        debugPrint('[RequestDS] failed to fetch offers for request: $e');
      }
    }

    return _enrichWithClientProfile(details, data);
  }

  @override
  Future<List<TaskModel>> getTasks(String requestId) async {
    final list = await apiService.getTasksByRequestId(requestId);
    return list.asMap().entries.map((entry) {
      return TaskModel.fromJson(
        entry.value as Map<String, dynamic>,
        index: entry.key,
      );
    }).toList();
  }

  @override
  Future<List<TaskModel>> getTasksByBookingId(String bookingId) async {
    final list = await apiService.getTasksByBookingId(bookingId);
    return list.asMap().entries.map((entry) {
      return TaskModel.fromJson(
        entry.value as Map<String, dynamic>,
        index: entry.key,
      );
    }).toList();
  }

  @override
  Future<void> updateTask(String taskId, bool completed) async {
    await apiService.updateTask(
      id: taskId,
      taskState: completed ? 'completed' : 'pending',
    );
  }

  @override
  Future<Map<String, dynamic>> sendOffer({
    required String requestId,
    required num price,
    String? notes,
  }) async {
    debugPrint('SENDING OFFER: requestId=$requestId, price=$price');
    final response = await apiService.sendOffer(
      requestId: requestId,
      price: price,
      notes: notes,
    );
    debugPrint('OFFER RESPONSE: $response');
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    throw Exception(
      response['message']?.toString() ?? 'Failed to send offer',
    );
  }
}
