import 'package:ehtemam_final_project/features/admin_provider_screen/ui/widgets/ad_provider_card.dart';
import 'package:ehtemam_final_project/features/admin_provider_screen/ui/widgets/ad_provider_header.dart';
import 'package:ehtemam_final_project/features/admin_provider_screen/ui/widgets/ad_provider_status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bottom_nav_bar/ui/widget/admin_bottom.dart';
import '../../manager/ad_provider_cubit.dart';
import '../../manager/ad_provider_state.dart';

class AdProviderScreen extends StatelessWidget {
  const AdProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdProviderView();
  }
}

class AdProviderView extends StatelessWidget {
  const AdProviderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: BlocBuilder<AdProviderCubit, AdProviderState>(
                  builder: (context, state) {
                    if (state is AdProviderLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is AdProviderLoaded) {
                      if (state.providers.isEmpty) {
                        return ListView(
                          children: [
                            SizedBox(height: 16.h),

                            AdProviderStatsCard(
                              total: state.allProviders.length,
                            ),

                            SizedBox(height: 40.h),

                            Center(
                              child: Text(
                                'No providers found',
                                style: TextStyle(
                                  color: Color(0xff64748B),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.only(bottom: 24.h),
                        itemCount: state.providers.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 16.h,
                              ),
                              child: AdProviderStatsCard(
                                total: state.allProviders.length,
                              ),
                            );
                          }

                          final provider = state.providers[index - 1];

                          return AdProviderCard(
                            provider: provider,
                            onBlockConfirmed: () {
                              context
                                  .read<AdProviderCubit>()
                                  .blockProvider(provider);
                            },
                          );
                        },
                      );
                    }

                    if (state is AdProviderError) {
                      return Center(
                        child: Text(state.message),
                      );
                    }

                    return SizedBox();

                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}