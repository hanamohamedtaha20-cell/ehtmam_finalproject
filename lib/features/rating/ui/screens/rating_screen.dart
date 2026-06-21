import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/rating/data/repo/rating_repo.dart';
import 'package:ehtemam_final_project/features/rating/manager/rating_cubit.dart';
import 'package:ehtemam_final_project/features/rating/manager/rating_state.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/rating_row.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/review_field.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/section_card.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/submit_button.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/thank_you_dialog.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/user_card.dart';
import 'package:ehtemam_final_project/features/rating_caregiver/ui/widgets/custom_header.dart';
import 'package:ehtemam_final_project/features/rating_caregiver/ui/widgets/rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class RatingScreen extends StatelessWidget {
  final String bookingId;
  final String caregiverName;
  final String caregiverRole;

  const RatingScreen({
    super.key,
    required this.bookingId,
    required this.caregiverName,
    required this.caregiverRole,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RatingCubit(RatingRepo()),
      child: _RatingBody(
        bookingId: bookingId,
        caregiverName: caregiverName,
        caregiverRole: caregiverRole,
      ),
    );
  }
}

class _RatingBody extends StatefulWidget {
  final String bookingId;
  final String caregiverName;
  final String caregiverRole;

  const _RatingBody({
    required this.bookingId,
    required this.caregiverName,
    required this.caregiverRole,
  });

  @override
  State<_RatingBody> createState() => _RatingBodyState();
}

class _RatingBodyState extends State<_RatingBody> {
  int _overall = 3;
  int _professionalism = 4;
  int _serviceQuality = 2;
  int _punctuality = 2;
  int _communication = 4;
  final TextEditingController _reviewController = TextEditingController();


  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<RatingCubit, RatingState>(
          listener: (context, state) {
            if (state is RatingSuccess) {
              ThankYouDialog.show(context, rating: _overall, bookingId: widget.bookingId);
            }
            if (state is RatingAlreadyReviewed) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  icon: Icon(Icons.check_circle, color: Colors.green, size: 48.r),
                  title: Text(
                    'Already Reviewed',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                  ),
                  content: Text(
                    'You have already submitted a review for this booking.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.sp, color: const Color(0xFF6B7280)),
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3A8BD7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              );
            }
            if (state is RatingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xffEF4444),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              );
            }
          },
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
                  child: Text('how_was_service'.tr(),
                    style: TextStyle(
                      fontFamily: "Arimo",
                      fontSize: 12.sp,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                UserCard(name: widget.caregiverName, role: widget.caregiverRole),
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
                              color: AppColors.textDark)),
                      SizedBox(height: 8.h),
                      Center(
                        child: RatingStars(
                          rating: _overall,
                          onChanged: (v) => setState(() => _overall = v),
                          size: 36.r,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Center(
                        child: Text('tap_to_rate'.tr(),
                            style: TextStyle(
                                fontFamily: "Arimo",
                                fontSize: 11.sp,
                                color: AppColors.textLight)),
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
                              color: AppColors.textDark)),
                      SizedBox(height: 12.h),
                      RatingRow(
                          label: "Professionalism",
                          rating: _professionalism,
                          onChanged: (v) => setState(() => _professionalism = v)),
                      SizedBox(height: 8.h),
                      RatingRow(
                          label: "Service Quality",
                          rating: _serviceQuality,
                          onChanged: (v) => setState(() => _serviceQuality = v)),
                      SizedBox(height: 8.h),
                      RatingRow(
                          label: "Punctuality",
                          rating: _punctuality,
                          onChanged: (v) => setState(() => _punctuality = v)),
                      SizedBox(height: 8.h),
                      RatingRow(
                          label: "Communication",
                          rating: _communication,
                          onChanged: (v) => setState(() => _communication = v)),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                SectionCard(child: ReviewField(controller: _reviewController)),
                SizedBox(height: 24.h),
                BlocBuilder<RatingCubit, RatingState>(
                  builder: (context, state) {
                    if (state is RatingLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return SubmitButton(
                      onSubmit: () {
                        context.read<RatingCubit>().submit(
                          review:          _reviewController.text,
                          bookingId:       widget.bookingId,
                          overall:         _overall,
                          professionalism: _professionalism,
                          serviceQuality:  _serviceQuality,
                          punctuality:     _punctuality,
                          communication:   _communication,
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 12.h),
                Center(
                  child: Text('honest_feedback_helps'.tr(),
                    style: TextStyle(
                        fontFamily: "Arimo",
                        fontSize: 11.sp,
                        color: AppColors.textLight),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
