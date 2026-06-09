import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/data/repo/booking_remote_ds.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/data/repo/repository_implementation.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/manager/booking_details_cubit.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/manager/state/booking_details_state.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/ui/widgets/date_time_card.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/ui/widgets/service_details_card.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/ui/widgets/special_instructions_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/booking_details_appbar/booking_details_appbar.dart';
import '../../../booking_caregiver/ui/widgets/client_info.dart';
import '../../../booking_caregiver/ui/widgets/tabs.dart';
import '../../../booking_caregiver/ui/widgets/task_item_card.dart';

class BookingDetailsAcc extends StatelessWidget {
  final String bookingId;
  final int initialTab;

  const BookingDetailsAcc({
    super.key,
    required this.bookingId,
    this.initialTab = 0,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingDetailsCubit(
        BookingRepositoryImpl(
          BookingRemoteDataSourceImpl(ApiService()),
        ),
      )..loadBookingDetails(bookingId),
      child: BookingDetailsAccView(
        bookingId: bookingId,
        initialTab: initialTab,
      ),
    );
  }
}

class BookingDetailsAccView extends StatefulWidget {
  final String bookingId;
  final int initialTab;

  const BookingDetailsAccView({
    super.key,
    required this.bookingId,
    this.initialTab = 0,
  });

  @override
  State<BookingDetailsAccView> createState() => _BookingDetailsAccViewState();
}

class _BookingDetailsAccViewState extends State<BookingDetailsAccView> {
  late int selectedTab;
  bool tasksLoaded = false;

  @override
  void initState() {
    super.initState();
    selectedTab = widget.initialTab;
    if (selectedTab == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        tasksLoaded = true;
        context.read<BookingDetailsCubit>().loadTasks();
      });
    }
  }

  void _onTabChanged(int index) {
    setState(() => selectedTab = index);
    if (index == 1 && !tasksLoaded) {
      tasksLoaded = true;
      context.read<BookingDetailsCubit>().loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingDetailsCubit, BookingDetailsState>(
      builder: (context, state) {
        if (state is BookingDetailsLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is BookingDetailsError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context
                        .read<BookingDetailsCubit>()
                        .loadBookingDetails(widget.bookingId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is! BookingDetailsLoaded) {
          return const SizedBox.shrink();
        }

        final booking = state.booking;
        final completedTasks =
            booking.tasks.where((t) => t.done).length;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: SingleChildScrollView(
            child: Column(
              children: [
                BookingDetailsAppBar(
                  bookingId: booking.displayId,
                  statusLabel: booking.statusLabel,
                ),
                const SizedBox(height: 16),
                BookingTabs(
                  selectedIndex: selectedTab,
                  onTabChanged: _onTabChanged,
                  completedCount: completedTasks,
                  totalCount: booking.tasks.length,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      if (selectedTab == 0) ...[
                        const SizedBox(height: 16),
                        ClientInfoCard(
                          name: booking.clientName,
                          phone: booking.phone,
                          email: booking.email,
                          rating: booking.rating,
                        ),
                        const SizedBox(height: 16),
                        ServiceDetailsCard(
                          serviceType: booking.serviceType,
                          petType: booking.petType,
                          duration: booking.duration,
                        ),
                        const SizedBox(height: 16),
                        DateTimeCard(
                          date: booking.date,
                          time: booking.time,
                          location: booking.location,
                        ),
                        const SizedBox(height: 16),
                        SpecialInstructionsCard(
                          instructions: booking.specialInstructions,
                        ),
                      ],
                      const SizedBox(height: 16),
                      if (selectedTab == 1)
                        booking.tasks.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(24),
                                child: Text('No tasks available'),
                              )
                            : Column(
                                children: booking.tasks.map((task) {
                                  return TaskItemCard(
                                    title: task.title,
                                    isDone: task.done,
                                    onTap: () => context
                                        .read<BookingDetailsCubit>()
                                        .toggleTask(task.id, !task.done),
                                  );
                                }).toList(),
                              ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
