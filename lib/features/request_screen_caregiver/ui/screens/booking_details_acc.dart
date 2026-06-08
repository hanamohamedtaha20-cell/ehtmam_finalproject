import 'package:ehtemam_final_project/features/booking_caregiver/ui/widgets/date_time_card.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/ui/widgets/service_details_card.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/ui/widgets/special_instructions_card.dart';
import 'package:flutter/material.dart';
import '../../../../core/booking_details_appbar/booking_details_appbar.dart';
import '../../../booking_caregiver/ui/widgets/client_info.dart';
import '../../../booking_caregiver/ui/widgets/tabs.dart';
import '../../../booking_caregiver/ui/widgets/task_item_card.dart';



class BookingDetailsAcc extends StatefulWidget {
  const BookingDetailsAcc({super.key});

  @override
  State<BookingDetailsAcc> createState() =>
      _BookingDetailsScreenState();
}

class _BookingDetailsScreenState
    extends State<BookingDetailsAcc> {

  int selectedTab = 0;
  final TextEditingController priceController =
  TextEditingController();

  final TextEditingController notesController =
  TextEditingController();

  final List<Map<String, dynamic>> tasks = [
    {
      "title": "Feed Max breakfast",
      "done": false,
    },
    {
      "title": "Give medication at 12 PM",
      "done": false,
    },
    {
      "title": "Take Max for a walk",
      "done": false,
    },
    {
      "title": "Play fetch in the backyard",
      "done": false,
    },
    {
      "title": "Refill water bowl",
      "done": false,
    },
  ];

  @override
  Widget build(BuildContext context) {

    int completedTasks =
        tasks.where((task) => task["done"] == true).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// APPBAR
            const BookingDetailsAppBar(),

            const SizedBox(height: 16),

            /// TABS
            BookingTabs(
              selectedIndex: selectedTab,

              onTabChanged: (index) {
                setState(() {
                  selectedTab = index;
                });
              },
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Column(
                children: [

                  /// DETAILS TAB
                  if (selectedTab == 0) ...[



                    SizedBox(height: 16),
                    ClientInfoCard(),


                    SizedBox(height: 16),

                    ServiceDetailsCard(),

                    SizedBox(height: 16),

                    DateTimeCard(),

                    SizedBox(height: 16),

                    SpecialInstructionsCard(),

                  ],
                  SizedBox(height: 16,),
                  /// TASKS TAB
                  if (selectedTab == 1) ...[

                    Column(
                      children: List.generate(
                        tasks.length,
                            (index) {

                          final task = tasks[index];

                          return TaskItemCard(
                            title: task["title"],

                            isDone: task["done"],

                            onTap: () {
                              setState(() {
                                task["done"] =
                                !task["done"];
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}