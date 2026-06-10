import 'package:ehtemam_final_project/features/admin_provider_screen/ui/widgets/ad_provider_card.dart';
import 'package:ehtemam_final_project/features/admin_provider_screen/ui/widgets/ad_provider_header.dart';
import 'package:ehtemam_final_project/features/admin_provider_screen/ui/widgets/ad_provider_status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/ad_provider_cubit.dart';
import '../manager/state/ad_provider_state.dart';
import '../model/repo/ad_provider_repository.dart';

class AdProviderScreen extends StatelessWidget {
  const AdProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdProviderCubit(
        AdProviderRepositoryImpl(),
      )..getProviders(),
      child: Scaffold(
        backgroundColor: const Color(0xffF5F6FA),
        body: SafeArea(
          child: Column(
            children: [
              AdProviderHeader(
                onSearch: (value) {
                  context.read<AdProviderCubit>().searchProviders(value);
                },
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BlocBuilder<AdProviderCubit, AdProviderState>(
                    builder: (context, state) {
                      if (state is AdProviderLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is AdProviderLoaded) {
                        return ListView.builder(
                          itemCount: state.providers.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: AdProviderStatsCard(),
                              );
                            }

                            return AdProviderCard(
                              provider: state.providers[index - 1],
                            );
                          },
                        );
                      }

                      if (state is AdProviderError) {
                        return Center(
                          child: Text(
                            state.message,
                          ),
                        );
                      }

                      return const SizedBox();
                    },
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