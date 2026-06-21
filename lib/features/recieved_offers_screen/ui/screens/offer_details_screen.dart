import 'package:ehtemam_final_project/core/widgets/action_buttons_row.dart';
import 'package:ehtemam_final_project/features/recieved_offers_screen/ui/screens/received_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/Provider_repo.dart';
import '../../data/repo/reviews_repo.dart';
import '../../manager/provider_details_cubit.dart';
import '../../manager/reviews_cubit.dart';
import '../../manager/state/provider_state.dart';
import '../widgets/offer_details_widgets/ProviderInfoCard.dart';
import '../widgets/offer_details_widgets/about_provider.dart';
import '../widgets/offer_details_widgets/provider_card.dart';
import '../widgets/offer_details_widgets/provider_notes.dart';
import '../widgets/offer_details_widgets/reviews_section.dart';
import '../widgets/offer_details_widgets/services_list.dart';
import '../../utils/offer_accept_handler.dart';
import 'package:easy_localization/easy_localization.dart';

class OfferDetailsScreen extends StatelessWidget {
  final String requestId;
  final String offerId;

  const OfferDetailsScreen({
    super.key,
    required this.requestId,
    required this.offerId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProviderCubit(ProviderRepository())
            ..loadOfferDetails(requestId: requestId, offerId: offerId),
        ),
        BlocProvider(
          create: (_) => ReviewCubit(ReviewRepository())..getReviews(),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: SafeArea(
          child: BlocBuilder<ProviderCubit, ProviderState>(
            builder: (context, state) {
              if (state is ProviderLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (state is ProviderError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.r),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              if (state is ProviderEmpty) {
                return Center(child: Text('no_offer_details'.tr()));
              }

              if (state is ProviderLoaded) {
                final provider = state.provider;

                return Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back),
                        ),
                        SizedBox(width: 10.w),
                        Text('offer_details'.tr(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Divider(thickness: 1),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          children: [
                            ProviderCard(),
                            SizedBox(height: 12.h),
                            ProviderNotes(
                              description: provider.notes.isNotEmpty
                                  ? provider.notes
                                  : 'No additional notes from the provider.',
                            ),
                            SizedBox(height: 12.h),
                            ServicesList(),
                            SizedBox(height: 12.h),
                            const ProviderInfoCard(),
                            SizedBox(height: 12.h),
                            const AboutProviderCard(),
                            SizedBox(height: 12.h),
                            const ReviewsSection(),
                            SizedBox(height: 20.h),
                            if (provider.status.toUpperCase() == 'ACCEPTED')
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: 14.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Color(0xFF2E7D32)),
                                    SizedBox(width: 8.w),
                                    Text('offer_accepted'.tr(),
                                      style: TextStyle(
                                        color: Color(0xFF2E7D32),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ActionButtonsRow(
                                firstText: 'Other Offers',
                                secondText: 'Accept',
                                onFirstTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OffersScreen(
                                        requestId: requestId,
                                      ),
                                    ),
                                  );
                                },
                                onSecondTap: () async {
                                  await acceptOffer(
                                    context: context,
                                    offerId: offerId,
                                    requestId: requestId,
                                    offerPrice: provider.price,
                                    popOnSuccess: false,
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
