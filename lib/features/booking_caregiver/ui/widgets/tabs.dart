import 'package:flutter/material.dart';

class BookingTabs extends StatefulWidget {
  const BookingTabs({super.key});

  @override
  State<BookingTabs> createState() => _BookingTabsState();
}

class _BookingTabsState extends State<BookingTabs> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Container(
        padding: const EdgeInsets.all(4),

        decoration: BoxDecoration(
          color: const Color(0xffF4F4F4),

          borderRadius: BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [

            /// DETAILS TAB
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),

                  padding: const EdgeInsets.symmetric(vertical: 14),

                  decoration: BoxDecoration(
                    gradient: selectedIndex == 0
                        ? const LinearGradient(
                      colors: [
                        Color(0xff2F80ED),
                        Color(0xffD9D9D9),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                        : null,

                    color: selectedIndex == 0
                        ? null
                        : Colors.transparent,

                    borderRadius: BorderRadius.circular(14),

                    boxShadow: selectedIndex == 0
                        ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                        : [],
                  ),

                  child: Center(
                    child: Text(
                      'Details',

                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: selectedIndex == 0
                            ? Colors.white
                            : const Color(0xff5C667A),

                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// TASKS TAB
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),

                  padding: const EdgeInsets.symmetric(vertical: 14),

                  decoration: BoxDecoration(
                    gradient: selectedIndex == 1
                        ? const LinearGradient(
                      colors: [
                        Color(0xff2F80ED),
                        Color(0xffD9D9D9),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                        : null,

                    color: selectedIndex == 1
                        ? null
                        : Colors.transparent,

                    borderRadius: BorderRadius.circular(14),

                    boxShadow: selectedIndex == 1
                        ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                        : [],
                  ),

                  child: Center(
                    child: Text(
                      'Tasks (3/5)',

                      style: TextStyle(
                        fontWeight: FontWeight.w600,

                        color: selectedIndex == 1
                            ? Colors.white
                            : const Color(0xff5C667A),

                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}