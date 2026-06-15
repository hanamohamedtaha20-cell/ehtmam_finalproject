import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const TaskSearchField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4.r),
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6.r),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: "Enter task description...",
                    hintStyle: TextStyle(
                        fontFamily: "Arimo",
                        fontSize: 13.sp,
                        color: AppColors.textLight),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(14)),
                        borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 14.h),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 90.w,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: Color(0xFF97CCFD), // 👈 light blue
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                   child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 18.r),
                      SizedBox(width: 6.w),
                      Text("Add \n Task",
                          style: TextStyle(
                              fontFamily: "Arimo",
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14, 0, 14, 10),
            child: Text(
              "Please select a request to add tasks",
              style: TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 11.sp,
                  color: AppColors.textLight),
            ),
          ),
        ],
      ),
    );
  }
}