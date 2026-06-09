import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../manager/hc_cubit.dart';
import '../../manager/hc_state.dart';
import '../widgets/hc_availability_card.dart';
import '../widgets/hc_header_section.dart';
import '../widgets/hc_pending_requests_header..dart';
import '../widgets/hc_request_card.dart';
import '../widgets/hc_stats_grid.dart';

class HcHomeScreen extends StatelessWidget {
  const HcHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HcHomeCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xffF7FAFC),
        body: BlocBuilder<HcHomeCubit, HcHomeState>(
          builder: (context, state) {
            if (state is! HcHomeLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                const HcHeaderSection(),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HcStatsGrid(),

                     const SizedBox(height: 10),

                      Transform.translate(
                        offset: const Offset(0, -40),
                        child: HcAvailabilityCard(
                          isAvailable: state.isAvailable,
                        ),
                      ),

                      const SizedBox(height: 10),

                      HcPendingRequestsHeader(
                        pendingCount: state.requests.length,
                      ),

                      const SizedBox(height: 14),

                      ...state.requests.map(
                            (request) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: HcRequestCard(request: request),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}