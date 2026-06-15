import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/Provider_repo.dart';
import '../../manager/provider_details_cubit.dart';
import '../../manager/state/provider_state.dart';
import '../widgets/offer_header.dart';
import '../widgets/offers_list.dart';
import '../widgets/request_summary_card.dart';

class OffersScreen extends StatefulWidget {
  final String requestId;

  const OffersScreen({
    super.key,
    required this.requestId,
  });

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> with RouteAware {
  late final ProviderCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ProviderCubit(ProviderRepository())..getOffers(widget.requestId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _refresh() => _cubit.getOffers(widget.requestId);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: SafeArea(
          child: BlocBuilder<ProviderCubit, ProviderState>(
            builder: (context, state) {
              if (state is ProviderLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (state is ProviderLoaded) {
                return RefreshIndicator(
                  onRefresh: () async => _refresh(),
                  child: Column(
                    children: [
                      const OffersHeader(),
                      RequestSummaryCard(offersCount: state.offers.length),
                      Expanded(
                        child: OffersList(
                          requestId: widget.requestId,
                          offers: state.offers,
                          onOfferActioned: _refresh,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is ProviderEmpty) {
                return RefreshIndicator(
                  onRefresh: () async => _refresh(),
                  child: ListView(
                    children: [
                      OffersHeader(),
                      SizedBox(height: 80.h),
                      Center(child: Text('No offers received yet')),
                    ],
                  ),
                );
              }

              if (state is ProviderError) {
                return Column(
                  children: [
                    const OffersHeader(),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.r),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(state.message, textAlign: TextAlign.center),
                              SizedBox(height: 16.h),
                              ElevatedButton(
                                onPressed: _refresh,
                                child: Text('Retry'),
                              ),
                            ],
                          ),
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
