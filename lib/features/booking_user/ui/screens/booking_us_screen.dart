import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/booking_user/data/repo/booking_repo.dart';
import 'package:ehtemam_final_project/features/booking_user/manager/booking_cubit.dart';
import 'package:ehtemam_final_project/features/booking_user/manager/booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/booking_card.dart';
import '../widgets/booking_header.dart';
import '../widgets/tabs_row.dart';

class BookingUsScreenScreen extends StatelessWidget {
  const BookingUsScreenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingCubit(BookingRepo())..loadBookings(),
      child: Scaffold(
        backgroundColor:  Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<BookingCubit, BookingState>(
              builder: (context, state) {
                if (state is! BookingLoaded) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BookingHeader(),
                    const SizedBox(height: 20),
                    TabsRow(
                      selectedIndex: state.selectedTab,
                      onTap: (i) => context.read<BookingCubit>().selectTab(i),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: state.filtered.isEmpty
                          ? const Center(
                              child: Text("No booking_user found",
                                  style: TextStyle(
                                      fontFamily: "Arimo",
                                      color: AppColors.textLight)))
                          : ListView.separated(
                              itemCount: state.filtered.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (_, i) =>
                                  BookingCard(booking: state.filtered[i]),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}