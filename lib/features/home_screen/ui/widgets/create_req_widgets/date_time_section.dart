import 'package:ehtemam_final_project/features/home_screen/manager/state/create_request_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../manager/create_request_cubit.dart';
import '../../../manager/state/create_request_state.dart';

class DateTimeSection extends StatelessWidget {
  const DateTimeSection({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<CreateRequestCubit,
        CreateRequestState>(
      builder: (context, state) {

        final cubit = context.read<CreateRequestCubit>();

        return Row(
          children: [

            /// DATE
            Expanded(
              child: _DateTimeCard(
                title: "Date",

                icon:
                Icons.calendar_month_outlined,

                isError:
                cubit.isDateEmpty,

                value:
                cubit.selectedDate == null
                    ? "Select date"
                    : "${cubit.selectedDate!.day}/"
                    "${cubit.selectedDate!.month}/"
                    "${cubit.selectedDate!.year}",

                onTap: () async {

                  final pickedDate =
                  await showDatePicker(
                    context: context,

                    firstDate:
                    DateTime.now(),

                    lastDate:
                    DateTime(2030),

                    initialDate:
                    DateTime.now(),
                  );

                  if (pickedDate != null) {

                    cubit.setDate(
                      pickedDate,
                    );
                  }
                },
              ),
            ),

            SizedBox(width: 12.w),

            /// TIME
            Expanded(
              child: _DateTimeCard(
                title: "Time",

                icon:
                Icons.access_time_rounded,

                isError:
                cubit.isTimeEmpty,

                value:
                cubit.selectedTime == null
                    ? "Select time"
                    : cubit.selectedTime!
                    .format(context),

                onTap: () async {

                  final pickedTime =
                  await showTimePicker(
                    context: context,

                    initialTime:
                    TimeOfDay.now(),
                  );

                  if (pickedTime != null) {

                    cubit.setTime(
                      pickedTime,
                    );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DateTimeCard extends StatelessWidget {

  final String title;

  final IconData icon;

  final String value;

  final VoidCallback onTap;

  final bool isError;

  const _DateTimeCard({
    required this.title,
    required this.icon,
    required this.value,
    required this.onTap,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius:
        BorderRadius.circular(20.r),

        onTap: onTap,

        child: AnimatedContainer(
          duration:
          const Duration(milliseconds: 250),

          padding:
          EdgeInsets.all(16.r),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
            BorderRadius.circular(20.r),

            border: Border.all(
              color:
              isError
                  ? Colors.red
                  : Colors.transparent,

              width: 2.w,
            ),

            boxShadow: [
              BoxShadow(
                color:
                Colors.black.withOpacity(0.2),

                blurRadius: 6.r,

                offset:
                Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Row(
                children: [

                  Icon(
                    icon,
                    size: 18.r,
                    color: Colors.blueGrey,
                  ),

                  SizedBox(width: 6.w),

                  Text(
                    title,

                    style:
                    TextStyle(
                      fontSize: 14.sp,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 18.h),

              Container(
                width: double.infinity,

                padding:
                EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 14.h,
                ),

                decoration: BoxDecoration(
                  color:
                  const Color(
                      0xFFF5F7FA),

                  borderRadius:
                  BorderRadius.circular(
                      14),
                ),

                child: Text(
                  value,

                  style: TextStyle(
                    color:
                    Colors.grey.shade600,

                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}