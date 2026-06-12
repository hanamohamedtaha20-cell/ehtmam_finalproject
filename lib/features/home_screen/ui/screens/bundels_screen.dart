import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/home_screen/data/repo/bundle_repo.dart';
import 'package:ehtemam_final_project/features/home_screen/manager/bundle_cubit.dart';
import 'package:ehtemam_final_project/features/home_screen/manager/state/bundle_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/bundels_widgets/bundels_card.dart';
import '../widgets/bundels_widgets/faq_section.dart';
import '../widgets/bundels_widgets/why_choose_card.dart';

class ServiceBundlesScreen extends StatelessWidget {
  const ServiceBundlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BundleCubit(BundleRepo(ApiService()))..getBundles(),
      child: const _ServiceBundlesBody(),
    );
  }
}

class _ServiceBundlesBody extends StatelessWidget {
  const _ServiceBundlesBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const WhyChooseUsCard(),
              const SizedBox(height: 16),
              BlocBuilder<BundleCubit, BundleState>(
                builder: (context, state) {
                  if (state is BundleLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is BundleError) {
                    return Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    );
                  }

                  if (state is BundleSuccess) {
                    if (state.bundles.isEmpty) {
                      return const Text('No bundles available');
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.bundles.length,
                      itemBuilder: (_, index) =>
                          BundleCard(bundle: state.bundles[index]),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 16),
              const FAQSection(),
            ],
          ),
        ),
      ),
    );
  }
}
