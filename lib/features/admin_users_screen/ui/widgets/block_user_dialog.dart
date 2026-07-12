import 'package:ehtemam_final_project/core/widgets/action_buttons_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

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
    final color     = isBlocking ? Colors.red : Colors.orange;
    final icon      = isBlocking ? Icons.block : Icons.lock_open_rounded;
    final titleKey  = isBlocking ? 'block_user' : 'unblock_user';
    final reasonKey = isBlocking ? 'reason_for_blocking' : 'reason_for_unblocking';
    final hintKey   = isBlocking ? 'explain_block_user' : 'explain_unblock_user';

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
                Text(titleKey.tr(),
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

            Text(reasonKey.tr(),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 8.h),

            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: hintKey.tr(),
                filled: true,
                fillColor: const Color(0xffE5E7EB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            if (isBlocking) ...[
              SizedBox(height: 12.h),
              Text('block_reason_note_user'.tr(),
                style: TextStyle(fontSize: 11.sp, color: Colors.grey),
              ),
            ],

            SizedBox(height: 20.h),

            ActionButtonsRow(
              firstText: 'cancel'.tr(),
              secondText: titleKey.tr(),
              onFirstTap: () => Navigator.pop(context, false),
              onSecondTap: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ),
    );
  }
}
