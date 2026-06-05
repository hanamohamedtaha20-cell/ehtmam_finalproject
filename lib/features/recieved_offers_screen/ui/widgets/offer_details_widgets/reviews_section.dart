import 'package:ehtemam_final_project/features/recieved_offers_screen/ui/widgets/offer_details_widgets/reviews.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart%20';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../manager/reviews_cubit.dart';
import '../../../manager/state/reviews_state.dart';


class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {

        if (state is ReviewLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is ReviewError) {
          return Text("Error loading reviews");
        }

        if (state is ReviewLoaded) {
          final reviews = state.reviews;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔥 Title
              Text(
                "Reviews (${reviews.length})",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              SizedBox(height: 12),

              /// 🔹 List
              ...reviews.map((r) => ReviewCard(review: r)),
            ],
          );
        }

        return SizedBox();
      },
    );
  }
}