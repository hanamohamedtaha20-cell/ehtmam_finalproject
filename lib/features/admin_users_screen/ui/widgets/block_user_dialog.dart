import 'package:ehtemam_final_project/core/widgets/action_buttons_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlockUserDialog extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onBlock;

  const BlockUserDialog({
    super.key,
    required this.name,
    required this.email,
    required this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Block User',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            Text(
              'User:',
              style: TextStyle(color: Colors.grey),
            ),

            SizedBox(height: 4.h),

            Text(
              name,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            Text(
              email,
              style: TextStyle(color: Colors.grey),
            ),

            SizedBox(height: 20.h),

            Text(
              'Reason for Blocking *',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 8.h),

            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Explain why you are blocking this user...',
                filled: true,
                fillColor: const Color(0xffE5E7EB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 12.h),

            Text(
              'This reason will be stored for record keeping and may be shared with the user.',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 20.h),

            ActionButtonsRow(
              firstText: "Cancel",
              secondText: "Block User",
              onFirstTap: () {
                Navigator.pop(context);
              },
              onSecondTap: () {

                onBlock();
                Navigator.pop(context);

              },
            ),
          ],
        ),
      ),
    );
  }
}