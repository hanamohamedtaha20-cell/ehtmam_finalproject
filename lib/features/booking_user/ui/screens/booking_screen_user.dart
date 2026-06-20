import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/booking_user/data/repo/booking_repo_user.dart';
import 'package:ehtemam_final_project/features/booking_user/manager/booking_cubit_user.dart';
import 'package:ehtemam_final_project/features/booking_user/manager/booking_state_user.dart';
import 'package:ehtemam_final_project/features/booking_user/ui/widgets/booking_header.dart';
import 'package:ehtemam_final_project/features/booking_user/ui/widgets/tabs_row.dart';
import 'package:ehtemam_final_project/features/auth/manager/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/booking_card.dart';


class BookingScreenUser extends StatelessWidget {
  const BookingScreenUser({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<AuthCubit>().state.isGuest) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: Text(
                'Please login to view your bookings.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) => BookingCubitUser(BookingRepoUser())..loadBookings(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: BlocBuilder<BookingCubitUser, BookingStateUser>(
              builder: (context, state) {
                if (state is BookingLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is BookingError) {
                  final isAuthError = state.message.contains('not_authenticated') ||
                      state.message.contains('401') ||
                      state.message.contains('Unauthorized');
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.r),
                      child: Text(
                        isAuthError
                            ? 'You must login first'
                            : state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      ),
                    ),
                  );
                }
                if (state is! BookingLoaded) {
                  return Center(child: CircularProgressIndicator());
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(child: BookingHeader()),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.black),
                          tooltip: 'Refresh',
                          onPressed: () => context.read<BookingCubitUser>().loadBookings(),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    TabsRow(
                      selectedIndex: state.selectedTab,
                      onTap: (i) => context.read<BookingCubitUser>().selectTab(i),
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: state.filtered.isEmpty
                          ? Center(
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
                                  SizedBox(height: 12.h),
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