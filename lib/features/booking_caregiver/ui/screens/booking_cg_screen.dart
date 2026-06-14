import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/data/repo/booking_remote_ds.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/data/repo/repository_implementation.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/manager/booking_details_cubit.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/manager/state/booking_details_state.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/ui/widgets/client_budget_card.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/ui/widgets/date_time_card.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/ui/widgets/proposed_price_card.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/ui/widgets/service_details_card.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/ui/widgets/special_instructions_card.dart';
import 'package:ehtemam_final_project/features/recieved_offers_screen/ui/screens/received_screen.dart';
import 'package:ehtemam_final_project/features/request_screen_caregiver/ui/screens/care_requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/booking_details_appbar/booking_details_appbar.dart';
import '../../../../core/widgets/gradient_action_button.dart';
import '../widgets/client_info.dart';
import '../widgets/tabs.dart';
import '../widgets/task_item_card.dart';

class BookingCgScreen extends StatelessWidget {
  final String requestId;

  const BookingCgScreen({
    super.key,
    required this.requestId, required int initialTab, required String bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingDetailsCubit(
        BookingRepositoryImpl(
          BookingRemoteDataSourceImpl(ApiService()),
        ),
      )..loadRequestDetails(requestId),
      child: BookingCgView(requestId: requestId),
    );
  }
}

class BookingCgView extends StatefulWidget {
  final String requestId;

  const BookingCgView({super.key, required this.requestId});

  @override
  State<BookingCgView> createState() => _BookingCgViewState();
}

class _BookingCgViewState extends State<BookingCgView> {
  int selectedTab = 0;
  bool tasksLoaded = false;
  bool isSubmittingOffer = false;
  final TextEditingController priceController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  void dispose() {
    priceController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() => selectedTab = index);
    if (index == 1 && !tasksLoaded) {
      tasksLoaded = true;
      context.read<BookingDetailsCubit>().loadTasks(widget.requestId);
    }
  }

  Future<void> _submitOffer(BuildContext context) async {
    if (isSubmittingOffer) return;

    final price = num.tryParse(priceController.text.trim());
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price')),
      );
      return;
    }

    setState(() => isSubmittingOffer = true);

    final error = await context.read<BookingDetailsCubit>().submitOffer(
          requestId: widget.requestId,
          price: price,
          notes: notesController.text.trim().isEmpty
              ? null
              : notesController.text.trim(),
        );

    if (!context.mounted) return;

    setState(() => isSubmittingOffer = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Offer sent')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CareRequestsScreen(),
      ),
    );
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
                        .loadRequestDetails(widget.requestId),
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
        final budgetText = booking.clientBudget > 0
            ? '\$${booking.clientBudget.toStringAsFixed(2)}'
            : '—';

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
                        const SizedBox(height: 16),
                        ClientBudgetCard(amount: budgetText),
                        const SizedBox(height: 16),
                        ProposedPriceCard(
                          controller: priceController,
                          notesController: notesController,
                        ),
                        const SizedBox(height: 16),
                        GradientActionButton(
                          text: isSubmittingOffer ? "Submitting..." : "Submit offer",
                          onTap: () => _submitOffer(context),
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
