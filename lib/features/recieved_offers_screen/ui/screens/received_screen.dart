import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/Provider_repo.dart';
import '../../manager/provider_details_cubit.dart';
import '../../manager/state/provider_state.dart';
import '../widgets/offer_header.dart';
import '../widgets/offers_list.dart';
import '../widgets/request_summary_card.dart';

class OffersScreen extends StatelessWidget {

  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(

      create: (_) =>
      ProviderCubit(
        ProviderRepository(),)..getProvider(),

      child: Scaffold(

        backgroundColor: const Color(0xFFF5F6FA),

        body: SafeArea(

          child: BlocBuilder<ProviderCubit, ProviderState>(

            builder: (context, state) {

              /// loading
              if (state is ProviderLoading) {

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              /// success
              if (state is ProviderLoaded) {

                final providers = state.provider;

                return Column(

                  children: [

                    const OffersHeader(),

                    const RequestSummaryCard(),

                    Expanded(

                      child: OffersList(
                        provider: providers,
                      ),
                    ),
                  ],
                );
              }

              /// initial
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}