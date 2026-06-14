import 'package:ehtemam_final_project/features/recieved_offers_screen/manager/state/reviews_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/reviews_repo.dart';



class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository repo;

  ReviewCubit(this.repo) : super(ReviewInitial());

  void getReviews() async {
    if (isClosed) return;
    emit(ReviewLoading());

    try {
      final reviews = await repo.getReviews();
      if (!isClosed) {
        emit(ReviewLoaded(reviews));
      }
    } catch (e) {
      if (!isClosed) {
        emit(ReviewError());
      }
    }
  }
}
