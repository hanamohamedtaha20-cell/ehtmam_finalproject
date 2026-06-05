import 'package:flutter/material.dart';

class BookingTabs extends StatelessWidget {

  final int selectedIndex;

  final Function(int) onTabChanged;

  const BookingTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),

      child: Container(
        padding: EdgeInsets.all(4),

        decoration: BoxDecoration(
          color: Color(0xffF4F4F4),

          borderRadius: BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              offset: Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),

        child: Row(
          children: [

            /// DETAILS TAB
            Expanded(
              child: GestureDetector(
                onTap: () {
                  onTabChanged(0);
                },

                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),

                  padding: EdgeInsets.symmetric(
                    vertical: 14,
                  ),

                  decoration: BoxDecoration(
                    gradient: selectedIndex == 0
                        ? const LinearGradient(
                      colors: [
                        Color(0xff2F80ED),
                        Color(0xff7EB6FF),
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
                        color:
                        Colors.blue.withOpacity(.18),

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
                            : Color(0xff5C667A),

                        fontSize: 12,
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
                  onTabChanged(1);
                },

                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),

                  padding: EdgeInsets.symmetric(
                    vertical: 14,
                  ),

                  decoration: BoxDecoration(
                    gradient: selectedIndex == 1
                        ? LinearGradient(
                      colors: [
                        Color(0xff2F80ED),
                        Color(0xff7EB6FF),
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
                        color:
                        Colors.blue.withOpacity(.18),

                        blurRadius: 8,

                        offset: Offset(0, 3),
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

                        fontSize: 12,
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