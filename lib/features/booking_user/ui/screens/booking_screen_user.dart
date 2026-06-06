import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/booking_user/data/repo/booking_repo_user.dart';
import 'package:ehtemam_final_project/features/booking_user/manager/booking_cubit_user.dart';
import 'package:ehtemam_final_project/features/booking_user/manager/booking_state_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/booking_card.dart';
import '../widgets/booking_header.dart';
import '../widgets/tabs_row.dart';

class BookingScreenUser extends StatelessWidget {
  const BookingScreenUser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingCubitUser(BookingRepoUser())..loadBookings(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<BookingCubitUser, BookingStateUser>(
              builder: (context, state) {
                if (state is BookingLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is BookingError) {
                  return Center(child: Text(state.message));
                }
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
                      onTap: (i) => context.read<BookingCubitUser>().selectTab(i),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: state.filtered.isEmpty
                          ? const Center(
                              child: Text(
                                "No bookings found",
                                style: TextStyle(
                                  fontFamily: "Arimo",
                                  color: AppColors.textLight,
                                ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: state.filtered.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (_, i) => BookingCard(
                                booking: state.filtered[i],
                                onCancel: () {
                                  context.read<BookingCubitUser>().cancelBooking(state.filtered[i].id);
                                },
                              ),
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