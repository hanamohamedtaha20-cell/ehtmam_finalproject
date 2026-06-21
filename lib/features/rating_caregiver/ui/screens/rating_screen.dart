import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/rating_caregiver/manager/rating_cubit.dart';
import 'package:ehtemam_final_project/features/rating_caregiver/manager/rating_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_header.dart';
import '../widgets/rating_row.dart';
import '../widgets/rating_stars.dart';
import '../widgets/review_field.dart';
import '../widgets/section_card.dart';
import '../widgets/submit_button.dart';
import '../widgets/user_card.dart';
import 'package:easy_localization/easy_localization.dart';

class RatingGiverScreen extends StatefulWidget {
  final String bookingId;
  final String clientName;

  const RatingGiverScreen({
    super.key,
    required this.bookingId,
    required this.clientName,
  });

  @override
  State<RatingGiverScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingGiverScreen> {
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RatingGiverCubit(bookingId: widget.bookingId),
      child: BlocConsumer<RatingGiverCubit, RatingState>(
        listener: (context, state) {
          if (state is RatingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('review_submitted'.tr())),
            );
            Navigator.pop(context);
          } else if (state is RatingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is RatingLoading;
          final ratings = state is RatingUpdated ? state : null;

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomHeader(),
                    SizedBox(height: 10.h),
                    Center(
                      child: Text('rate_your_experience'.tr(),
                        style: TextStyle(
                          fontFamily: "Arimo",
                          fontWeight: FontWeight.bold,
                          fontSize: 24.sp,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Center(
                      child: Text('how_was_client_exp'.tr(),
                        style: TextStyle(
                          fontFamily: "Arimo",
                          fontSize: 12.sp,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    UserCard(name: widget.clientName, role: "Client"),
                    SizedBox(height: 20.h),
                    SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('overall_rating'.tr(),
                            style: TextStyle(
                              fontFamily: "Arimo",
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Center(
                            child: RatingStars(
                              rating: ratings?.overallRating ?? 3,
                              onChanged: (v) => context
                                  .read<RatingGiverCubit>()
                                  .updateOverallRating(v),
                              size: 36.r,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Center(
                            child: Text('tap_to_rate'.tr(),
                              style: TextStyle(
                                fontFamily: "Arimo",
                                fontSize: 11.sp,
                                color: AppColors.textLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('detailed_ratings'.tr(),
                            style: TextStyle(
                              fontFamily: "Arimo",
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          RatingRow(
                            label: "Communication",
                            rating: ratings?.communication ?? 3,
                            onChanged: (v) => context
                                .read<RatingGiverCubit>()
                                .updateCommunication(v),
                          ),
                          SizedBox(height: 8.h),
                          RatingRow(
                            label: "Ease of Use",
                            rating: ratings?.easeOfUse ?? 3,
                            onChanged: (v) => context
                                .read<RatingGiverCubit>()
                                .updateEaseOfUse(v),
                          ),
                          SizedBox(height: 8.h),
                          RatingRow(
                            label: "Reliability",
                            rating: ratings?.reliability ?? 3,
                            onChanged: (v) => context
                                .read<RatingGiverCubit>()
                                .updateReliability(v),
                          ),
                          SizedBox(height: 8.h),
                          RatingRow(
                            label: "Overall Satisfaction",
                            rating: ratings?.overallSatisfaction ?? 3,
                            onChanged: (v) => context
                                .read<RatingGiverCubit>()
                                .updateOverallSatisfaction(v),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SectionCard(child: ReviewField(controller: _reviewController)),
                    SizedBox(height: 24.h),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      SubmitButton(
                        onSubmit: () => context
                            .read<RatingGiverCubit>()
                            .submitRating(review: _reviewController.text.trim()),
                      ),
                    SizedBox(height: 12.h),
                    Center(
                      child: Text('honest_feedback_helps'.tr(),
                        style: TextStyle(
                          fontFamily: "Arimo",
                          fontSize: 11.sp,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
