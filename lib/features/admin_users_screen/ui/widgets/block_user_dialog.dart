import 'package:ehtemam_final_project/core/widgets/action_buttons_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlockUserDialog extends StatelessWidget {
  final String name;
  final String email;
  final bool isBlocking;

  const BlockUserDialog({
    super.key,
    required this.name,
    required this.email,
    this.isBlocking = true,
  });

  @override
  Widget build(BuildContext context) {
    final color  = isBlocking ? Colors.red : Colors.orange;
    final icon   = isBlocking ? Icons.block : Icons.lock_open_rounded;
    final title  = isBlocking ? 'Block User' : 'Unblock User';
    final action = isBlocking ? 'Block User' : 'Unblock User';

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
                Icon(icon, color: color),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context, false),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            Text('User:', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 4.h),
            Text(
              name,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            Text(email, style: TextStyle(color: Colors.grey)),

            SizedBox(height: 20.h),

            if (isBlocking) ...[
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
                'This reason will be stored for record keeping.',
                style: TextStyle(fontSize: 11.sp, color: Colors.grey),
              ),
              SizedBox(height: 20.h),
            ] else ...[
              Text(
                'This user will be able to access the app again.',
                style: TextStyle(fontSize: 13.sp, color: Colors.grey),
              ),
              SizedBox(height: 20.h),
            ],

            ActionButtonsRow(
              firstText: 'Cancel',
              secondText: action,
              onFirstTap: () => Navigator.pop(context, false),
              onSecondTap: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ),
    );
  }
}
