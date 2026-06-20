import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/rating_model.dart';
import '../data/repo/rating_repo.dart';
import 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  final RatingRepo repo;

  RatingCubit(this.repo) : super(RatingInitial());

  int overall         = 0;
  int professionalism = 0;
  int serviceQuality  = 0;
  int punctuality     = 0;
  int communication   = 0;

  void updateRating(String type, int value) {
    switch (type) {
      case 'overall':         overall         = value; break;
      case 'professionalism': professionalism = value; break;
      case 'serviceQuality':  serviceQuality  = value; break;
      case 'punctuality':     punctuality     = value; break;
      case 'communication':   communication   = value; break;
    }
    emit(RatingInitial());
  }

  Future<void> submit({
    required String review,
    required String bookingId,
    required int overall,
    required int professionalism,
    required int serviceQuality,
    required int punctuality,
    required int communication,
  }) async {
    if (isClosed) return;

    final prefs = await SharedPreferences.getInstance();
    final userRole = prefs.getString('user_role') ?? '';
    final userId   = prefs.getString('userId')    ?? '';

    debugPrint('[Rating] Logged-in userId: $userId');
    debugPrint('[Rating] Logged-in role: $userRole');
    debugPrint('[Rating] bookingId: $bookingId');
    debugPrint('[Rating] Request body â€” overall: $overall | professionalism: $professionalism | serviceQuality: $serviceQuality | punctuality: $punctuality | communication: $communication | comment: "$review"');

    // Only CLIENT/USER accounts may submit caregiver reviews.
    final role = userRole.toLowerCase();
    if (role == 'giver' || role == 'caregiver') {
      debugPrint('[Rating] Blocked: caregiver account tried to submit a review.');
      if (!isClosed) {
        emit(RatingError('You are not allowed to submit this review.'));
      }
      return;
    }

    emit(RatingLoading());

    try {
      await repo.submitRating(
        model: RatingModel(
          overall:         overall,
          professionalism: professionalism,
          serviceQuality:  serviceQuality,
          punctuality:     punctuality,
          communication:   communication,
          review:          review,
        ),
        bookingId: bookingId,
      );
      if (!isClosed) emit(RatingSuccess());
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      debugPrint('[Rating] DioException â€” statusCode: $code');
      debugPrint('[Rating] DioException â€” response.data: ${e.response?.data}');
      debugPrint('[Rating] DioException â€” headers: ${e.response?.headers}');

      if (!isClosed) {
        if (code == 403) {
          emit(RatingError('You are not allowed to submit this review.'));
        } else if (code == 401) {
          emit(RatingError('Your session has expired. Please log in again.'));
        } else if (code == 404) {
          emit(RatingError('Booking not found. Please try again.'));
        } else {
          emit(RatingError('Failed to submit review. Please try again.'));
        }
      }
    } catch (e) {
      debugPrint('[Rating] Unexpected error: $e');
      if (!isClosed) {
        emit(RatingError('Failed to submit review. Please try again.'));
      }
    }
  }
}

