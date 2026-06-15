import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/home_screen/data/repo/bundle_repo.dart';
import 'package:ehtemam_final_project/features/home_screen/manager/bundle_cubit.dart';
import 'package:ehtemam_final_project/features/home_screen/manager/state/bundle_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          padding: EdgeInsets.all(16.r),
          child: Column(
            children: [
              const WhyChooseUsCard(),
              SizedBox(height: 16.h),
              BlocBuilder<BundleCubit, BundleState>(
                builder: (context, state) {
                  if (state is BundleLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state is BundleError) {
                    return Text(
                      state.message,
                      style: TextStyle(color: Colors.red),
                    );
                  }

                  if (state is BundleSuccess) {
                    if (state.bundles.isEmpty) {
                      return Text('No bundles available');
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.bundles.length,
                      itemBuilder: (_, index) =>
                          BundleCard(bundle: state.bundles[index]),
                    );
                  }

                  return SizedBox.shrink();
                },
              ),
              SizedBox(height: 16.h),
              const FAQSection(),
            ],
          ),
        ),
      ),
    );
  }
}
