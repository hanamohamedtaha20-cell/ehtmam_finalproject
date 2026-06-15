import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskProgressItem extends StatelessWidget {
  final String title;
  final String time;
  final bool isDone;
  final int mediaCount;
  final List<String> mediaUrls;

  const TaskProgressItem({
    super.key,
    required this.title,
    required this.time,
    required this.isDone,
    required this.mediaCount,
    required this.mediaUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(131, 76, 175, 79), width: 1.w),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isDone ? const Color(0xff007A55) : Colors.grey,
                size: 22.r,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: "Arimo",
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: isDone ? Color(0xff007A55) : Colors.black,
                  ),
                ),
              ),
              if (isDone)
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 3.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFED0FAE5),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    "✓ Done",
                    style: TextStyle(
                      fontFamily: "Arimo",
                      fontSize: 12.sp,
                      color: Color(0xff007A55),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 6.h),
          if (isDone) ...[
            Row(
              children: [
                Icon(Icons.access_time, size: 13.r, color: Colors.grey),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    time,
                    style: TextStyle(
                      fontFamily: "Arimo",
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (mediaCount > 0) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.image, size: 15.r, color: Colors.blue),
                SizedBox(width: 4.w),
                Text(
                  "Attached Media ($mediaCount)",
                  style: TextStyle(
                      fontFamily: "Arimo",
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 80.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: mediaUrls.length,
                separatorBuilder: (_, __) => SizedBox(width: 8.w),
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    mediaUrls[i],
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
          if (!isDone) ...[
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFEE685)),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  "Task is pending completion by caregiver",
                  style: TextStyle(
                    fontFamily: "Arimo",
                    fontSize: 12.sp,
                    color: Color(0xFF973C00),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}