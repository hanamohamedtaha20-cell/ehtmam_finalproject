import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reviews.dart';
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
                  fontSize: 16.sp,
                ),
              ),

              SizedBox(height: 12.h),

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