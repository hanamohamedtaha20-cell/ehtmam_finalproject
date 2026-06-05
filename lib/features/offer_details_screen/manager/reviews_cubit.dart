import '/features/offer_details_screen/manager/state/reviews_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/reviews_repo.dart';



class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository repo;

  ReviewCubit(this.repo) : super(ReviewInitial());

  void getReviews() async {
    emit(ReviewLoading());

    try {
      final reviews = await repo.getReviews();
      emit(ReviewLoaded(reviews));
    } catch (e) {
      emit(ReviewError());
    }
  }
}