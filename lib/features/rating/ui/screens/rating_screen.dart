import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/screens/home_screen.dart';
import 'package:ehtemam_final_project/features/rating/manager/rating_cubit.dart';
import 'package:ehtemam_final_project/features/rating/manager/rating_state.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/rating_row.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/review_field.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/section_card.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/submit_button.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/user_card.dart';
import 'package:ehtemam_final_project/features/rating_caregiver/ui/widgets/custom_header.dart';
import 'package:ehtemam_final_project/features/rating_caregiver/ui/widgets/rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RatingScreen extends StatefulWidget {
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
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            }
            if (state is RatingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
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
                child: Text(
                          "Rate Your Experience",
                          style: TextStyle(
                fontFamily: "Arimo",
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
                color: AppColors.textDark),
                        ),
              ),

               SizedBox(height: 10.h),
                Center(
                child: Text(
                          "How Was Your Service Experience",
                          style: TextStyle(
                fontFamily: "Arimo",
                fontSize: 12.sp,
                color: AppColors.textDark),
                        ),
              ),
              SizedBox(height: 10.h),

                UserCard(
                  name: widget.caregiverName,
                  role: widget.caregiverRole,
                ),              
                SizedBox(height: 20.h),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Overall Rating",
                        style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 14.sp, color: AppColors.textDark)),
                    SizedBox(height: 8.h),
                    Center(child: RatingStars(rating: _overall, onChanged: (v) => setState(() => _overall = v), size: 36.r)),
                    SizedBox(height: 4.h),
                    Center(
                      child: Text("Tap to rate",
                          style: TextStyle(fontFamily: "Arimo", fontSize: 11.sp, color: AppColors.textLight)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Detailed Ratings",
                        style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 14.sp, color: AppColors.textDark)),
                    SizedBox(height: 12.h),
                    RatingRow(label: "Professionalism", rating: _professionalism, onChanged: (v) => setState(() => _professionalism = v)),
                    SizedBox(height: 8.h),
                    RatingRow(label: "Service Quality", rating: _serviceQuality, onChanged: (v) => setState(() => _serviceQuality = v)),
                    SizedBox(height: 8.h),
                    RatingRow(label: "Punctuality", rating: _punctuality, onChanged: (v) => setState(() => _punctuality = v)),
                    SizedBox(height: 8.h),
                    RatingRow(label: "Communication", rating: _communication, onChanged: (v) => setState(() => _communication = v)),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              SectionCard(child: ReviewField(controller: _reviewController)),
              SizedBox(height: 24.h),
               BlocBuilder<RatingCubit, RatingState>(
                  builder: (context, state) {
                    if (state is RatingLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
              return SubmitButton(
                      onSubmit: () {
                        context.read<RatingCubit>().submit(
                          review:    _reviewController.text,
                          bookingId: widget.bookingId,
                  );
                },
              );}),
              SizedBox(height: 12.h),
              Center(
                child: Text(
                  "Your honest feedback helps improve our services",
                  style: TextStyle(fontFamily: "Arimo", fontSize: 11.sp, color: AppColors.textLight),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}