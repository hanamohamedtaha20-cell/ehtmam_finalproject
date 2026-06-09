import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/Provider_repo.dart';
import '../../manager/provider_details_cubit.dart';
import '../../manager/state/provider_state.dart';
import '../widgets/offer_header.dart';
import '../widgets/offers_list.dart';
import '../widgets/request_summary_card.dart';

class OffersScreen extends StatelessWidget {
  final String requestId;

  const OffersScreen({
    super.key,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProviderCubit(
        ProviderRepository(),
      )..getOffers(requestId),

      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),

        body: SafeArea(
          child: BlocBuilder<ProviderCubit, ProviderState>(
            builder: (context, state) {
              if (state is ProviderLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is ProviderLoaded) {
                return Column(
                  children: [
                    const OffersHeader(),
                    RequestSummaryCard(
                      offersCount: state.offers.length,
                    ),
                    Expanded(
                      child: OffersList(
                        requestId: requestId,
                        offers: state.offers,
                      ),
                    ),
                  ],
                );
              }

              if (state is ProviderEmpty) {
                return Column(
                  children: [
                    const OffersHeader(),
                    const Expanded(
                      child: Center(
                        child: Text('No offers received yet'),
                      ),
                    ),
                  ],
                );
              }

              if (state is ProviderError) {
                return Column(
                  children: [
                    const OffersHeader(),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            state.message,
                            textAlign: TextAlign.center,
                          ),
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
