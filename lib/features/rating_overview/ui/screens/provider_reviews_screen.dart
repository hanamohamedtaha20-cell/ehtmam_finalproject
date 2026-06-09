import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/ui/screens/caregiver_screen.dart';
import 'package:flutter/material.dart';
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

        title: const Text('My Ratings',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black)),
        
      ),
      body: BlocBuilder<ProviderReviewCubit, ProviderReviewState>(
        builder: (context, state) {
          if (state is ProviderReviewLoading || state is ProviderReviewInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is ProviderReviewError) {
            return ReviewEmptyState(
              message: state.message,
              icon: Icons.error_outline_rounded,
              isError: true,
              onRetry: () => context.read<ProviderReviewCubit>().loadReviews(),
            );
          }

          if (state is! ProviderReviewLoaded) return const SizedBox();

          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child:ReviewScoreHeader(
                      summary: state.summary,
                      activeStarFilter: state.activeStarFilter,
                      onFilterChanged: (star) =>
context.read<ProviderReviewCubit>().filterByStar(star as int?),                    ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ReviewFilterTabs(
                          activeFilter: state.activeStarFilter,
                          onFilterChanged: (star) =>
                              context.read<ProviderReviewCubit>().filterByStar(star),
                        ),
                      ),
                    ),
                    if (state.reviews.isEmpty)
                      const SliverFillRemaining(
                        child: ReviewEmptyState(message: 'No reviews for this filter yet.'),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final review = state.reviews[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ReviewItemCard(
                                review: review,
                                isHelpful: state.helpfulIds.contains(review.id),
                                 onHelpfulTap: () {},
                                 onViewBooking: () {
                                  // Navigate to booking: context.push('/bookings/${review.bookingId}');
                                },
                              ),
                            );
                          },
                          childCount: state.reviews.length,
                        ),
                      ),
                  ],
                ),
              ),
             
            ],
          );
        },
      ),
    );
  }
}