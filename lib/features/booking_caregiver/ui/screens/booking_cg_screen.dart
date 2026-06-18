import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/data/repo/booking_remote_ds.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/data/repo/repository_implementation.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/manager/booking_details_cubit.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/manager/state/booking_details_state.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/ui/widgets/client_budget_card.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/ui/widgets/date_time_card.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/ui/widgets/proposed_price_card.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/ui/widgets/service_details_card.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/ui/widgets/description_card.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/ui/widgets/special_instructions_card.dart';
import 'package:ehtemam_final_project/features/bottom_nav_bar/ui/caregiver_buttom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/booking_details_appbar/booking_details_appbar.dart';
import '../../../../core/widgets/gradient_action_button.dart';
import '../widgets/client_info.dart';
import '../widgets/tabs.dart';
import '../widgets/task_item_card.dart';

class BookingCgScreen extends StatelessWidget {
  final String requestId;
  final String bookingId;
  final int initialTab;

  const BookingCgScreen({
    super.key,
    required this.requestId,
    this.bookingId = '',
    this.initialTab = 0,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = BookingDetailsCubit(
      BookingRepositoryImpl(
        BookingRemoteDataSourceImpl(ApiService()),
      ),
    );
    if (bookingId.isNotEmpty) {
      cubit.loadBookingDetails(bookingId);
    } else {
      cubit.loadRequestDetails(requestId);
    }
    return BlocProvider(
      create: (_) => cubit,
      child: BookingCgView(requestId: requestId, bookingId: bookingId, initialTab: initialTab),
    );
  }
}

class BookingCgView extends StatefulWidget {
  final String requestId;
  final String bookingId;
  final int initialTab;

  const BookingCgView({super.key, required this.requestId, this.bookingId = '', this.initialTab = 0});

  @override
  State<BookingCgView> createState() => _BookingCgViewState();
}

class _BookingCgViewState extends State<BookingCgView> {
  late int selectedTab = widget.initialTab;
  bool tasksLoaded = true;
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
      final cubit = context.read<BookingDetailsCubit>();
      if (widget.bookingId.isNotEmpty) {
        cubit.loadTasksByBookingId(widget.bookingId);
      } else {
        cubit.loadTasks(widget.requestId);
      }
    }
  }

  Future<void> _submitOffer(BuildContext context) async {
    if (isSubmittingOffer) return;

    final price = num.tryParse(priceController.text.trim());
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid price')),
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
      SnackBar(content: Text('Offer sent')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const CareGiverBottomNavScreen(),
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
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: () => context
                        .read<BookingDetailsCubit>()
                        .loadRequestDetails(widget.requestId),
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is! BookingDetailsLoaded) {
          return SizedBox.shrink();
        }

        final booking = state.booking;
        final budgetText = booking.clientBudget > 0
            ? '${booking.clientBudget.toStringAsFixed(0)} EGP'
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
                SizedBox(height: 16.h),
                BookingTabs(
                  selectedIndex: selectedTab,
                  onTabChanged: _onTabChanged,
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      if (selectedTab == 0) ...[
                        SizedBox(height: 16.h),
                        ClientInfoCard(
                          name: booking.clientName,
                          phone: booking.phone,
                          email: booking.email,
                          rating: booking.rating,
                        ),
                        SizedBox(height: 16.h),
                        DescriptionCard(
                          description: booking.description,
                        ),
                        SizedBox(height: 16.h),
                        ServiceDetailsCard(
                          serviceType: booking.serviceType,
                          petType: booking.petType,
                          duration: booking.duration,
                        ),
                        SizedBox(height: 16.h),
                        DateTimeCard(
                          date: booking.date,
                          time: booking.time,
                          location: booking.location,
                          governorate: booking.governorate,
                          street: booking.street,
                          building: booking.building,
                        ),
                        SizedBox(height: 16.h),
                        SpecialInstructionsCard(
                          instructions: booking.specialInstructions,
                        ),
                        SizedBox(height: 16.h),
                        ClientBudgetCard(amount: budgetText),
                        SizedBox(height: 16.h),
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: OutlinedButton.icon(
                        //     onPressed: () => Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (_) => ShareLocationCgScreen(
                        //           bookingId: booking.id,
                        //           clientName: booking.clientName,
                        //           serviceType: booking.serviceType,
                        //         ),
                        //       ),
                        //     ),
                        //     icon: Icon(Icons.location_on_outlined),
                        //     label: Text('Share My Location'),
                        //     style: OutlinedButton.styleFrom(
                        //       foregroundColor: const Color(0xFF3A8BD7),
                        //       side: BorderSide(color: Color(0xFF3A8BD7)),
                        //       padding: EdgeInsets.symmetric(vertical: 12.h),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12.r),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 16.h),
                        ProposedPriceCard(
                          controller: priceController,
                          notesController: notesController,
                        ),
                        SizedBox(height: 16.h),
                        GradientActionButton(
                          text: isSubmittingOffer ? "Submitting..." : "Submit offer",
                          onTap: () => _submitOffer(context),
                        ),
                      ],
                      SizedBox(height: 16.h),
                      if (selectedTab == 1)
                        booking.tasks.isEmpty
                            ? Padding(
                                padding: EdgeInsets.all(24.r),
                                child: Text('No tasks available'),
                              )
                            : Column(
                                children: booking.tasks
                                    .map((task) => TaskItemCard(title: task.title))
                                    .toList(),
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
