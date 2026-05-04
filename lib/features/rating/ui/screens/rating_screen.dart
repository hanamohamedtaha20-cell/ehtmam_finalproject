import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/custom_header.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/rating_row.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/rating_stars.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/review_field.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/section_card.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/submit_button.dart';
import 'package:ehtemam_final_project/features/rating/ui/widgets/user_card.dart';
import 'package:flutter/material.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

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
        backgroundColor: Colors.white,      body: SafeArea(
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

              const UserCard(name: "Sarah Adam", role: "Pet Care"),
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
              SubmitButton(onSubmit: () {}),
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
    );
  }
}