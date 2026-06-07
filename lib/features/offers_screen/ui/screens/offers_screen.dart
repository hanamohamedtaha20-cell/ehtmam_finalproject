import 'package:ehtemam_final_project/features/recieved_offers_screen/ui/widgets/offer_header.dart';
import 'package:ehtemam_final_project/features/recieved_offers_screen/ui/widgets/request_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../offer_details_screen/data/repo/Provider_repo.dart';
import '../../../offer_details_screen/manager/provider_details_cubit.dart';
import '../../../offer_details_screen/manager/state/provider_state.dart';
import '../widgets/offers_list.dart';


class OffersScreen extends StatelessWidget {
   OffersScreen({super.key});

   @override
   Widget build(BuildContext context) {
     return BlocProvider(
       create: (_) => ProviderCubit(ProviderRepository())..getProvider(),

       child: Scaffold(
         backgroundColor: Color(0xFFF5F6FA),

         body: SafeArea(
           child: BlocBuilder<ProviderCubit, ProviderState>(
             builder: (context, state) {

               /// loading
               if (state is ProviderLoading) {
                 return Center(child: CircularProgressIndicator());
               }

               /// success
               if (state is ProviderLoaded) {
                 final provider = state.provider;

                 return Column(
                   children: [
                     OffersHeader(),
                     RequestSummaryCard(),

                     Expanded(
                       child: OffersList(
                         provider: provider,
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
   }  }