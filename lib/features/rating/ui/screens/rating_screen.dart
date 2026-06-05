import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/rating/manager/rating_cubit.dart';
import 'package:ehtemam_final_project/features/rating/manager/rating_state.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/custom_header.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/rating_row.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/rating_stars.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/review_field.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/section_card.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/submit_button.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home_screen/ui/home_screen.dart';

class RatingScreen extends StatefulWidget {
  final String caregiverId;
  final String serviceId;
  final String requestId;
  final String caregiverName;  
  final String caregiverRole;

  const RatingScreen({
    super.key,
    required this.caregiverId,
    required this.serviceId,
    required this.requestId,
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(),
              const SizedBox(height: 10),
              Center(
                child: const Text(
                          "Rate Your Experience",
                          style: TextStyle(
                fontFamily: "Arimo",
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: AppColors.textDark),
                        ),
              ),

               const SizedBox(height: 10),
                Center(
                child: const Text(
                          "How Was Your Service Experience",
                          style: TextStyle(
                fontFamily: "Arimo",
                fontSize: 12,
                color: AppColors.textDark),
                        ),
              ),
              const SizedBox(height: 10),

                UserCard(
                  name: widget.caregiverName,
                  role: widget.caregiverRole,
                ),              
                const SizedBox(height: 20),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Overall Rating",
                        style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
                    const SizedBox(height: 8),
                    Center(child: RatingStars(rating: _overall, onChanged: (v) => setState(() => _overall = v), size: 36)),
                    const SizedBox(height: 4),
                    Center(
                      child: const Text("Tap to rate",
                          style: TextStyle(fontFamily: "Arimo", fontSize: 11, color: AppColors.textLight)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Detailed Ratings",
                        style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
                    const SizedBox(height: 12),
                    RatingRow(label: "Professionalism", rating: _professionalism, onChanged: (v) => setState(() => _professionalism = v)),
                    const SizedBox(height: 8),
                    RatingRow(label: "Service Quality", rating: _serviceQuality, onChanged: (v) => setState(() => _serviceQuality = v)),
                    const SizedBox(height: 8),
                    RatingRow(label: "Punctuality", rating: _punctuality, onChanged: (v) => setState(() => _punctuality = v)),
                    const SizedBox(height: 8),
                    RatingRow(label: "Communication", rating: _communication, onChanged: (v) => setState(() => _communication = v)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(child: ReviewField(controller: _reviewController)),
              const SizedBox(height: 24),
               BlocBuilder<RatingCubit, RatingState>(
                  builder: (context, state) {
                    if (state is RatingLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
              return SubmitButton(
                      onSubmit: () {
                        context.read<RatingCubit>().submit(
                          review:      _reviewController.text,
                          caregiverId: widget.caregiverId,
                          serviceId:   widget.serviceId,
                          requestId:   widget.requestId,
                  );
                },
              );}),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  "Your honest feedback helps improve our services",
                  style: TextStyle(fontFamily: "Arimo", fontSize: 11, color: AppColors.textLight),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}