import '/features/offer_details_screen/ui/widgets/provider_notes.dart';
import '/features/offer_details_screen/ui/widgets/reviews_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/Provider_repo.dart';
import '../../data/repo/reviews_repo.dart';
import '../../manager/provider_details_cubit.dart';
import '../../manager/reviews_cubit.dart';
import '../widgets/ProviderInfoCard.dart';
import '../widgets/about_provider.dart';
import '../widgets/provider_card.dart';
import '../widgets/services_list.dart';

class OfferDetailsScreen extends StatelessWidget {
    const OfferDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create:(_) => ProviderCubit(ProviderRepository())..getProvider(),
        ),
        BlocProvider(
          create: (_) => ReviewCubit(ReviewRepository())..getReviews(),
        ),


      ],
      child: Scaffold(
        backgroundColor: Color(0xFFF5F6FA),
      
        body: SafeArea(
          child: Column(
            children: [
           Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
              ),
              SizedBox(width: 10),
              Text(
                "Offer Details",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
        ), Divider(thickness: 1,),
          Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ProviderCard(),
                      SizedBox(height: 12),
                      ProviderNotes(description: "I'd love to take care of your pet! I have over 5 years of experience working with all breeds and temperaments. Your pet will receive individual attention and lots of love.\n I'm also trained in pet first aid and have connections with local veterinarians for emergencies.:",),
                      SizedBox(height: 12),
                      ServicesList(),
                      SizedBox(height: 12),
                      ProviderInfoCard(),
                      SizedBox(height: 12),
                      AboutProviderCard(),
                      SizedBox(height: 12),
                      ReviewsSection(),
                      SizedBox(height: 20),
                      // BottomButtons(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}