import 'package:ehtemam_final_project/features/home_screen/ui/screens/home_screen.dart';
import 'package:ehtemam_final_project/features/rating/ui/screens/complaint_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThankYouDialog extends StatelessWidget {
  final int rating;

  const ThankYouDialog({super.key, required this.rating});

  static void show(BuildContext context, int rating) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ThankYouDialog(rating: rating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Checkmark icon
            Container(
              width: 72.w,
              height: 72.w,
              decoration: const BoxDecoration(
                color: Color(0xFF3A8BD7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
                size: 40.r,
              ),
            ),

            SizedBox(height: 20.h),

            Text(
              'Thank You for Your\nReview!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
            ),

            SizedBox(height: 10.h),

            Text(
              'Your feedback helps us improve our services',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 13.sp,
                color: const Color(0xFF6B7280),
              ),
            ),

            SizedBox(height: 20.h),

            // Star display
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (i) => Padding(
                    padding: EdgeInsets.only(right: i < 4 ? 4.w : 0),
                    child: Icon(
                      i < rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: const Color(0xFFFFC107),
                      size: 28.r,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Back to Home
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A8BD7),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  'Back to Home',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // Submit a Complaint
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ComplaintScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                icon: Icon(Icons.error_outline, size: 18.r, color: Colors.red),
                label: Text(
                  'Submit a Complaint',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
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
