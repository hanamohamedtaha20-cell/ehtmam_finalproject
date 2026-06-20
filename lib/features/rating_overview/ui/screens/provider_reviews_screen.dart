import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/ui/screens/caregiver_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/provider_review_repo.dart';
import '../../manager/provider_review_cubit.dart';
import '../../manager/provider_review_state.dart';
import '../widgets/review_score_header.dart';
import '../widgets/review_filter_tabs.dart';
import '../widgets/review_item_card.dart';
import '../widgets/review_empty_state.dart';

class ProviderReviewsScreen extends StatelessWidget {
  const ProviderReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProviderReviewCubit(ProviderReviewRepoImpl())..loadReviews(),
      child: const _ProviderReviewsView(),
    );
  }
}

class _ProviderReviewsView extends StatelessWidget {
  const _ProviderReviewsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading:  GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CaregiverScreen(),
                ),
              );
            },
            child: Icon(Icons.arrow_back)),

        title: Text('My Ratings',
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.black)),
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black),
              tooltip: 'Refresh',
              onPressed: () => ctx.read<ProviderReviewCubit>().loadReviews(),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProviderReviewCubit, ProviderReviewState>(
        builder: (context, state) {
          if (state is ProviderReviewLoading || state is ProviderReviewInitial) {
            return Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is ProviderReviewError) {
            return ReviewEmptyState(
              message: state.message,
              icon: Icons.error_outline_rounded,
              isError: true,
              onRetry: () => context.read<ProviderReviewCubit>().loadReviews(),
            );
          }

          if (state is! ProviderReviewLoaded) return SizedBox();

        return Column(
          children: [
            ReviewScoreHeader(
              summary: state.summary,
              activeStarFilter: state.activeStarFilter,
              onFilterChanged: (star) =>
                  context.read<ProviderReviewCubit>().filterByStar(star as int?),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: ReviewFilterTabs(
                activeFilter: state.activeStarFilter,
                onFilterChanged: (star) =>
                    context.read<ProviderReviewCubit>().filterByStar(star),
              ),
            ),
            Expanded(
              child: state.reviews.isEmpty
                  ? const ReviewEmptyState(message: 'No reviews for this filter yet.')
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: state.reviews.length,
                      itemBuilder: (context, index) {
                        final review = state.reviews[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: ReviewItemCard(
                            review: review,
                            isHelpful: state.helpfulIds.contains(review.id),
                            onHelpfulTap: () {},
                            onViewBooking: () {},
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
        },
      ),
    );
  }
}