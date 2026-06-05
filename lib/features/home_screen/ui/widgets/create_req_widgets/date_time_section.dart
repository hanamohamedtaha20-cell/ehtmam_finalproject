import 'package:flutter/material.dart';
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

        final cubit =
        CreateRequestCubit.get(context);

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

            const SizedBox(width: 12),

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
        BorderRadius.circular(20),

        onTap: onTap,

        child: AnimatedContainer(
          duration:
          const Duration(milliseconds: 250),

          padding:
          const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
            BorderRadius.circular(20),

            border: Border.all(
              color:
              isError
                  ? Colors.red
                  : Colors.transparent,

              width: 2,
            ),

            boxShadow: [
              BoxShadow(
                color:
                Colors.black.withOpacity(0.2),

                blurRadius: 6,

                offset:
                const Offset(0, 4),
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
                    size: 18,
                    color: Colors.blueGrey,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    title,

                    style:
                    const TextStyle(
                      fontSize: 14,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
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

                    fontSize: 13,
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