import 'package:ehtemam_final_project/core/widgets/action_buttons_row.dart';
import 'package:ehtemam_final_project/features/recieved_offers_screen/ui/screens/received_screen.dart';
import 'package:flutter/material.dart';
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
import '../../utils/offer_payment_handler.dart';

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
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProviderError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              if (state is ProviderEmpty) {
                return const Center(child: Text('No offer details available'));
              }

              if (state is ProviderLoaded) {
                final provider = state.provider;

                return Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Offer Details',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(thickness: 1),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ProviderCard(),
                            const SizedBox(height: 12),
                            ProviderNotes(
                              description: provider.notes.isNotEmpty
                                  ? provider.notes
                                  : 'No additional notes from the provider.',
                            ),
                            const SizedBox(height: 12),
                            ServicesList(),
                            const SizedBox(height: 12),
                            const ProviderInfoCard(),
                            const SizedBox(height: 12),
                            const AboutProviderCard(),
                            const SizedBox(height: 12),
                            const ReviewsSection(),
                            const SizedBox(height: 20),
                            ActionButtonsRow(
                              firstText: 'Other Offers',
                              secondText: 'Process Payment',
                              onFirstTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OffersScreen(
                                      requestId: requestId,
                                    ),
                                  ),
                                );
                              },
                              onSecondTap: () {
                                processOfferPayment(
                                  context: context,
                                  offerId: offerId,
                                  offerPrice: provider.price,
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

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
