import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;
  final int completedCount;
  final int totalCount;

  const BookingTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
    this.completedCount = 0,
    this.totalCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final tasksLabel = totalCount > 0
        ? 'Tasks ($completedCount/$totalCount)'
        : 'Tasks';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: const Color(0xffF4F4F4),
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              offset: Offset(0, 4),
              blurRadius: 6.r,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onTabChanged(0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    gradient: selectedIndex == 0
                        ? LinearGradient(
                            colors: [
                              Color(0xff2F80ED),
                              Color(0xff7EB6FF),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : null,
                    color:
                        selectedIndex == 0 ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: selectedIndex == 0
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(.18),
                              blurRadius: 8.r,
                              offset: Offset(0, 3),
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
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => onTabChanged(1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
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
                    color:
                        selectedIndex == 1 ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: selectedIndex == 1
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(.18),
                              blurRadius: 8.r,
                              offset: Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      tasksLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: selectedIndex == 1
                            ? Colors.white
                            : const Color(0xff5C667A),
                        fontSize: 12.sp,
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
